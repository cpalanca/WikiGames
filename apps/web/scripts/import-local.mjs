import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { createDatabase } from '../database.mjs';
import { scanLocalGames } from '../inventory.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const db = createDatabase(path.resolve(here, '../data/wikigames.sqlite'));
try {
  const scan = await scanLocalGames();
  const added = db.importLocal(scan.games);
  console.log(JSON.stringify({ detected: scan.games.length, added, total: db.listLocal().length, unavailable: scan.unavailable }, null, 2));
} finally {
  db.close();
}
