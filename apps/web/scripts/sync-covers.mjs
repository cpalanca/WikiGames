import { access } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createDatabase } from '../database.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const database = createDatabase(path.join(here, '../data/wikigames.sqlite'));
const base = 'https://www.gametdb.com';
const art = 'https://art.gametdb.com';
const aliases = new Map([
  ['Switch:Cadence of Hyrule Crypt', 'Cadence of Hyrule: Crypt of the NecroDancer Featuring The Legend of Zelda'],
  ['Switch:Capitan Toad', 'Captain Toad: Treasure Tracker'],
  ['Switch:Hyrule Warriors Age of Calamity 01002B00111A2000v0 10 65 GB', 'Hyrule Warriors: Age of Calamity'],
  ['Switch:Little Nightmares', 'Little Nightmares: Complete Edition'],
  ['Switch:Nintendo Switch Sport', 'Nintendo Switch Sports'],
  ["Switch:The Legend of Zelda Links Awakening", "The Legend of Zelda: Link's Awakening"],
  ['Switch:Nintendo 64 – Nintendo Switch Online Base', 'Nintendo 64 - Nintendo Switch Online'],
  ['Wii U:Hot Wheelsâ„¢ Worldâ€s Best Driver', "Hot Wheels: World's Best Driver"],
  ['Wii U:LEGOÂ Jurassic Worldâ„¢', 'LEGO Jurassic World'],
  ['Wii U:Sponge Bob Square Pants Planktonâ€s Robotic Revenge', "SpongeBob SquarePants: Plankton's Robotic Revenge"]
]);

function key(title) {
  return title.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '');
}

async function indexFor(platform) {
  const file = platform === 'Switch' ? 'switchtdb.txt' : platform === 'Wii U' ? 'wiiutdb.txt' : 'wiitdb.txt';
  const response = await fetch(`${base}/${file}?LANG=EN`, { signal: AbortSignal.timeout(20000) });
  if (!response.ok) throw new Error(`${file}: HTTP ${response.status}`);
  const byTitle = new Map();
  for (const line of (await response.text()).split(/\r?\n/)) {
    const match = /^([A-Z0-9]{4,6}) = (.+)$/.exec(line);
    if (!match) continue;
    const titleKey = key(match[2]);
    if (!byTitle.has(titleKey)) byTitle.set(titleKey, []);
    byTitle.get(titleKey).push(match[1]);
  }
  return byTitle;
}

async function exists(url) {
  try {
    const response = await fetch(url, { method: 'HEAD', signal: AbortSignal.timeout(10000) });
    return response.ok && response.headers.get('content-type')?.startsWith('image/');
  } catch { return false; }
}

async function localWiiCover(game) {
  const id = /\[([A-Z0-9]{6})\]/i.exec(game.sourcePath)?.[1]?.toUpperCase();
  if (!id) return null;
  for (const folder of ['2D', '']) {
    try {
      await access(path.join('G:\\WII\\config\\images', folder, `${id}.png`));
      return `/api/local-games/${game.id}/cover`;
    } catch {}
  }
  return null;
}

async function remoteCover(platform, ids) {
  const kind = platform === 'Switch' ? 'switch' : platform === 'Wii U' ? 'wiiu' : 'wii';
  const formats = platform === 'Switch' ? [['coverHQ', 'jpg'], ['coverM', 'png']] : [['cover', 'png'], ['cover3D', 'png']];
  for (const id of ids.slice(0, 5)) {
    for (const [format, ext] of formats) {
      for (const region of ['EN', 'US']) {
        const url = `${art}/${kind}/${format}/${region}/${id}.${ext}`;
        if (await exists(url)) return url;
      }
    }
  }
  return null;
}

try {
  const games = database.listLocal();
  const indexes = new Map();
  for (const platform of new Set(games.map(game => game.platform))) {
    try { indexes.set(platform, await indexFor(platform)); }
    catch (error) { console.warn(`Sin índice ${platform}: ${error.message}`); }
  }
  let updated = 0;
  let missing = 0;
  const queue = games.filter(game => !game.coverImage);
  async function worker() {
    while (queue.length) {
      const game = queue.shift();
      const local = game.platform === 'Wii' ? await localWiiCover(game) : null;
      const title = aliases.get(`${game.platform}:${game.title}`) || game.title;
      const ids = indexes.get(game.platform)?.get(key(title)) || [];
      const cover = local || await remoteCover(game.platform, ids);
      if (cover) { database.setLocalCover(game.id, cover); updated++; }
      else missing++;
    }
  }
  await Promise.all(Array.from({ length: 6 }, worker));
  console.log(`Carátulas asociadas: ${updated}; sin coincidencia: ${missing}; ya existentes: ${games.length - updated - missing}.`);
} finally {
  database.close();
}
