const CATALOG_URL = 'https://gamewave.digital/ports/catalog.json';
const CACHE_MS = 24 * 60 * 60 * 1000;
let cache = [];
let expiresAt = 0;
let pending;

export const normalizeGameTitle = value => String(value || '')
  .normalize('NFKD').replace(/\p{Diacritic}/gu, '')
  .toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim();

export function matchPorts(titles, apps) {
  const index = new Map();
  for (const app of apps) {
    if (!app.enabled || app.deprecated || app.verification === 'community_android_sheet') continue;
    if (!Array.isArray(app.gameNames) || !app.name) continue;
    let url;
    try {
      url = new URL(app.projectUrl);
      if (url.protocol !== 'https:' || !url.hostname) continue;
    } catch { continue; }
    for (const name of app.gameNames) {
      const key = normalizeGameTitle(name);
      if (!key) continue;
      const ports = index.get(key) || [];
      if (!ports.some(port => port.url === url.href)) ports.push({ name: app.name, url: url.href });
      index.set(key, ports);
    }
  }
  return Object.fromEntries(titles.flatMap(title => {
    const key = normalizeGameTitle(title);
    const collectionGame = key === 'super mario galaxy 1 2' ? 'Super Mario Galaxy' : null;
    const ports = index.get(collectionGame ? normalizeGameTitle(collectionGame) : key);
    return ports?.length ? [[title, ports.slice(0, 5).map(port => collectionGame ? { ...port, game: collectionGame } : port)]] : [];
  }));
}

export async function getGameWavePorts(titles) {
  if (Date.now() >= expiresAt && !pending) {
    pending = fetch(CATALOG_URL, { signal: AbortSignal.timeout(7000) })
      .then(async response => {
        if (!response.ok) throw new Error(`GameWave returned ${response.status}`);
        const catalog = await response.json();
        if (!Array.isArray(catalog.apps)) throw new Error('Invalid GameWave catalog');
        cache = catalog.apps;
        expiresAt = Date.now() + CACHE_MS;
      })
      .catch(() => { expiresAt = Date.now() + 5 * 60 * 1000; })
      .finally(() => { pending = null; });
  }
  if (pending) await pending;
  return matchPorts(titles, cache);
}
