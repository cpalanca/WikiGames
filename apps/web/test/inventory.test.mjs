import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { DatabaseSync } from 'node:sqlite';
import { cleanTitle, scanLocalGames } from '../inventory.mjs';
import { createDatabase } from '../database.mjs';

test('disk scan finds game folders and packages without utility folders or duplicate versions', async () => {
  const dir = mkdtempSync(path.join(tmpdir(), 'wikigames-scan-'));
  try {
    mkdirSync(path.join(dir, 'Mario Kart 8 Deluxe [0100152000022000][v0]'));
    mkdirSync(path.join(dir, 'UPDATE OFFLINE 19.0.1'));
    writeFileSync(path.join(dir, 'Mario Kart 8 Deluxe [0100152000022800][v1245184].nsz'), '');
    const scan = await scanLocalGames([{ root: dir, platform: 'Switch' }]);
    assert.deepEqual(scan.games.map(game => game.title), ['Mario Kart 8 Deluxe']);
    assert.equal(cleanTitle('The Legend of Zelda Breath of the Wild +[DLC Pack 1]+update1.6.0 [NSP]'), 'The Legend of Zelda Breath of the Wild');
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});

test('deleted catalog records stay excluded from later scans', () => {
  const db = createDatabase();
  const game = { id: '1234567890abcdef1234', gameKey: 'switch:testgame', title: 'Test Game', platform: 'Switch', sourcePath: 'E:\\Test Game', drive: 'E:' };
  assert.equal(db.importLocal([game]), 1);
  assert.equal(db.listLocal().length, 1);
  assert.equal(db.removeLocal(game.id), true);
  assert.equal(db.importLocal([game]), 0);
  assert.deepEqual(db.listLocal(), []);
  db.close();
});

test('direct SQL deletion also keeps a game out of later scans', () => {
  const dir = mkdtempSync(path.join(tmpdir(), 'wikigames-sql-'));
  const file = path.join(dir, 'catalog.sqlite');
  const game = { id: 'abcdef1234567890abcd', gameKey: 'wii:testgame', title: 'Test Game', platform: 'Wii', sourcePath: 'G:\\WII\\wbfs\\Test Game', drive: 'G:' };
  try {
    const catalog = createDatabase(file);
    catalog.importLocal([game]);
    const sql = new DatabaseSync(file);
    sql.prepare('DELETE FROM local_games WHERE id = ?').run(game.id);
    sql.close();
    assert.equal(catalog.importLocal([game]), 0);
    catalog.close();
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});
