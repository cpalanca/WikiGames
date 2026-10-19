import { games } from '../../packages/catalog/src/index.js';

const SIX_HOURS = 6 * 60 * 60 * 1000;
const FIVE_MINUTES = 5 * 60 * 1000;
let cache = { expires: 0, games, source: 'local' };
let pending;

function plainText(value) {
  return String(value || '').replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
}

async function fetchGame(game) {
  const url = new URL('https://store.steampowered.com/api/appdetails');
  url.searchParams.set('appids', game.steamAppId);
  url.searchParams.set('cc', 'es');
  url.searchParams.set('l', 'spanish');
  try {
    const response = await fetch(url, { signal: AbortSignal.timeout(7000), headers: { Accept: 'application/json' } });
    if (!response.ok) return game;
    const result = (await response.json())[game.steamAppId];
    if (!result?.success || !result.data) return game;
    const data = result.data;
    const videos = await Promise.all((data.movies || []).slice(0, 2).map(async item => {
      const url = item.mp4?.max || (Number.isInteger(item.id) ? `https://cdn.akamai.steamstatic.com/steam/apps/${item.id}/movie_max.mp4` : null);
      if (!url?.startsWith('https://')) return null;
      try {
        const check = await fetch(url, { method: 'HEAD', signal: AbortSignal.timeout(5000) });
        return check.ok ? { title: plainText(item.name), url } : null;
      } catch { return null; }
    }));
    return {
      ...game,
      title: plainText(data.name) || game.title,
      studio: plainText(data.developers?.[0]) || game.studio,
      description: plainText(data.short_description) || game.description,
      screenshots: (data.screenshots || []).map(item => item.path_full).filter(url => url?.startsWith('https://')).slice(0, 6),
      videos: videos.filter(Boolean),
      steamSynced: true
    };
  } catch {
    return game;
  }
}

export async function getSteamGridCover(game, key, request = fetch) {
  if (!key || !game.steamAppId) return null;
  const headers = { Authorization: `Bearer ${key}`, Accept: 'application/json' };
  try {
    const match = await request(`https://www.steamgriddb.com/api/v2/games/steam/${game.steamAppId}`, { headers, signal: AbortSignal.timeout(7000) });
    if (!match.ok) return null;
    const gameId = (await match.json()).data?.id;
    if (!Number.isInteger(gameId)) return null;
    const url = new URL(`https://www.steamgriddb.com/api/v2/grids/game/${gameId}`);
    url.searchParams.set('dimensions', '600x900');
    url.searchParams.set('types', 'static');
    url.searchParams.set('nsfw', 'false');
    url.searchParams.set('humor', 'false');
    url.searchParams.set('epilepsy', 'false');
    url.searchParams.set('limit', '20');
    const grids = await request(url, { headers, signal: AbortSignal.timeout(7000) });
    if (!grids.ok) return null;
    const choices = (await grids.json()).data || [];
    const best = choices.filter(item => item.url?.startsWith('https://')).sort((a, b) => b.score - a.score)[0];
    return best?.url || null;
  } catch {
    return null;
  }
}

export async function getSteamCatalog() {
  if (Date.now() < cache.expires) return cache;
  if (pending) return pending;
  pending = (async () => {
    const updated = [];
    for (let index = 0; index < games.length; index += 3) {
      updated.push(...await Promise.all(games.slice(index, index + 3).map(fetchGame)));
    }
    const synced = updated.filter(game => game.steamSynced).length;
    let gridCount = 0;
    const key = process.env.STEAMGRIDDB_API_KEY;
    if (key) {
      for (let index = 0; index < updated.length; index += 3) {
        const batch = updated.slice(index, index + 3);
        const covers = await Promise.all(batch.map(game => getSteamGridCover(game, key)));
        covers.forEach((cover, offset) => {
          if (cover) { updated[index + offset].coverImage = cover; gridCount++; }
        });
      }
    }
    cache = {
      games: updated,
      source: synced ? 'steam' : 'local',
      synced,
      gridCount,
      expires: Date.now() + (synced === games.length ? SIX_HOURS : FIVE_MINUTES)
    };
    return cache;
  })();
  try { return await pending; } finally { pending = null; }
}
