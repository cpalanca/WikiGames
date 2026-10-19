import { readdir } from 'node:fs/promises';
import { createHash } from 'node:crypto';
import path from 'node:path';

export const diskSources = [
  { root: 'E:\\', platform: 'Switch', directoriesOnly: true, ignore: ['NSP', 'N64', 'PORTS', 'TOOLS', 'JKSV', 'Checkpoint', 'COPIA SD 125GB'] },
  { root: 'E:\\NSP', platform: 'Switch', ignore: ['N64 NSP'] },
  { root: 'E:\\PORTS', platform: 'Switch', directoriesOnly: true, ignore: ['N64 NSP'] },
  { root: 'G:\\WII\\wbfs', platform: 'Wii', directoriesOnly: true },
  { root: 'G:\\WII U\\DATA\\ALL\\ESHOP', platform: 'Wii U', directoriesOnly: true, ignore: ['nusspli'] },
  { root: 'G:\\WII U\\DATA\\ALL\\DATA\\EUR\\ESHOP', platform: 'Wii U', directoriesOnly: true },
  { root: 'G:\\WII U\\DATA\\ALL\\DATA\\EUR\\GAMES', platform: 'Wii U', directoriesOnly: true }
];

const gameExtensions = new Set(['.nsp', '.nsz', '.xci', '.xcz', '.wbfs', '.iso', '.wud', '.wux', '.wua']);

export function cleanTitle(name) {
  return name
    .replace(/\.(?:nsp|nsz|xci|xcz|wbfs|iso|wud|wux|wua)$/i, '')
    .replace(/[._]+/g, ' ')
    .replace(/\[[^\]]*\]|\([^)]*\)/g, ' ')
    .replace(/\+\s*update.*$/i, '')
    .replace(/\b(?:plus|\+)\s*\d+\s*DLC\b.*$/i, '')
    .replace(/\b(?:DLC|Update)\s+v?\d+.*$/i, '')
    .replace(/\bpart\s*\d+\b.*$/i, '')
    .replace(/([a-z])([A-Z])/g, '$1 $2')
    .replace(/\s+/g, ' ')
    .replace(/^[\s+\-]+|[\s+\-]+$/g, '');
}

export function gameKey(platform, title) {
  return `${platform.toLowerCase()}:${title.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]/g, '')}`;
}

export async function scanLocalGames(sources = diskSources) {
  const found = new Map();
  const unavailable = [];
  for (const source of sources) {
    let entries;
    try { entries = await readdir(source.root, { withFileTypes: true }); }
    catch { unavailable.push(source.root); continue; }
    for (const entry of entries) {
      if (entry.name.startsWith('.') || entry.name.startsWith('$') || source.ignore?.includes(entry.name)) continue;
      if (source.directoriesOnly ? !entry.isDirectory() : !(entry.isDirectory() || entry.isFile() && gameExtensions.has(path.extname(entry.name).toLowerCase()))) continue;
      if (/^(?:system volume information|update offline|nusspli|emulators|tools)(?:\b|$)/i.test(entry.name)) continue;
      const title = cleanTitle(entry.name);
      if (title.length < 2) continue;
      const key = gameKey(source.platform, title);
      if (found.has(key)) continue;
      const sourcePath = path.join(source.root, entry.name);
      found.set(key, {
        id: createHash('sha256').update(`${source.platform}:${sourcePath.toLowerCase()}`).digest('hex').slice(0, 20),
        gameKey: key,
        title,
        platform: source.platform,
        sourcePath,
        drive: path.parse(sourcePath).root.slice(0, 2)
      });
    }
  }
  return { games: [...found.values()].sort((a, b) => a.title.localeCompare(b.title, 'es')), unavailable };
}
