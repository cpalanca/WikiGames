import { DatabaseSync } from 'node:sqlite';
import { mkdirSync } from 'node:fs';
import path from 'node:path';
import { games } from '../../packages/catalog/src/index.js';

const validIds = new Set(games.map(game => game.id));

export function createDatabase(file = ':memory:') {
  if (file !== ':memory:') mkdirSync(path.dirname(file), { recursive: true });
  const db = new DatabaseSync(file);
  db.exec('PRAGMA foreign_keys = ON');
  db.exec(`
    CREATE TABLE IF NOT EXISTS library_items (
      game_id TEXT PRIMARY KEY,
      added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) STRICT;
    CREATE TABLE IF NOT EXISTS local_games (
      id TEXT PRIMARY KEY,
      game_key TEXT NOT NULL UNIQUE,
      title TEXT NOT NULL,
      platform TEXT NOT NULL,
      source_path TEXT NOT NULL,
      drive TEXT NOT NULL,
      cover_url TEXT,
      is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1)),
      is_completed INTEGER NOT NULL DEFAULT 0 CHECK (is_completed IN (0, 1)),
      imported_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) STRICT;
    CREATE TABLE IF NOT EXISTS excluded_local_games (
      game_key TEXT PRIMARY KEY,
      excluded_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) STRICT;
    CREATE TABLE IF NOT EXISTS local_game_media (
      id INTEGER PRIMARY KEY,
      game_id TEXT NOT NULL REFERENCES local_games(id) ON DELETE CASCADE,
      kind TEXT NOT NULL CHECK (kind IN ('image', 'video')),
      url TEXT NOT NULL,
      added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) STRICT;
    CREATE TRIGGER IF NOT EXISTS exclude_deleted_local_game
    AFTER DELETE ON local_games
    BEGIN
      INSERT OR IGNORE INTO excluded_local_games (game_key) VALUES (OLD.game_key);
    END;
  `);
  if (!db.prepare('PRAGMA table_info(local_games)').all().some(column => column.name === 'cover_url')) {
    db.exec('ALTER TABLE local_games ADD COLUMN cover_url TEXT');
  }
  const localColumns = new Set(db.prepare('PRAGMA table_info(local_games)').all().map(column => column.name));
  if (!localColumns.has('is_favorite')) db.exec('ALTER TABLE local_games ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0 CHECK (is_favorite IN (0, 1))');
  if (!localColumns.has('is_completed')) db.exec('ALTER TABLE local_games ADD COLUMN is_completed INTEGER NOT NULL DEFAULT 0 CHECK (is_completed IN (0, 1))');
  const listLibrary = db.prepare('SELECT game_id FROM library_items ORDER BY added_at DESC, game_id');
  const addLibrary = db.prepare('INSERT OR IGNORE INTO library_items (game_id) VALUES (?)');
  const removeLibrary = db.prepare('DELETE FROM library_items WHERE game_id = ?');
  const listLocal = db.prepare('SELECT id, title, platform, source_path AS sourcePath, drive, cover_url AS coverImage, imported_at AS importedAt, is_favorite AS isFavorite, is_completed AS isCompleted FROM local_games ORDER BY title COLLATE NOCASE, platform');
  const setLocalCover = db.prepare('UPDATE local_games SET cover_url = ? WHERE id = ?');
  const setLocalFavorite = db.prepare('UPDATE local_games SET is_favorite = ? WHERE id = ?');
  const setLocalCompleted = db.prepare('UPDATE local_games SET is_completed = ? WHERE id = ?');
  const listMedia = db.prepare('SELECT id, kind, url, added_at AS addedAt FROM local_game_media WHERE game_id = ? ORDER BY id DESC');
  const addMedia = db.prepare('INSERT INTO local_game_media (game_id, kind, url) VALUES (?, ?, ?)');
  const removeMedia = db.prepare('DELETE FROM local_game_media WHERE id = ? AND game_id = ?');
  const excluded = db.prepare('SELECT 1 FROM excluded_local_games WHERE game_key = ?');
  const insertLocal = db.prepare('INSERT OR IGNORE INTO local_games (id, game_key, title, platform, source_path, drive) VALUES (?, ?, ?, ?, ?, ?)');
  const findLocal = db.prepare('SELECT game_key FROM local_games WHERE id = ?');
  const removeLocal = db.prepare('DELETE FROM local_games WHERE id = ?');

  return {
    listLibrary: () => listLibrary.all().map(row => row.game_id),
    addLibrary(id) {
      if (!validIds.has(id)) return false;
      addLibrary.run(id);
      return true;
    },
    removeLibrary(id) {
      if (!validIds.has(id)) return false;
      removeLibrary.run(id);
      return true;
    },
    listLocal: () => listLocal.all(),
    setLocalCover(id, url) {
      return Boolean(setLocalCover.run(url, id).changes);
    },
    setLocalFlag(id, flag, value) {
      if (typeof value !== 'boolean') return false;
      const statement = flag === 'isFavorite' ? setLocalFavorite : flag === 'isCompleted' ? setLocalCompleted : null;
      return statement ? Boolean(statement.run(Number(value), id).changes) : false;
    },
    listMedia: id => listMedia.all(id),
    addMedia(id, kind, url) {
      if (!findLocal.get(id) || !['image', 'video'].includes(kind) || typeof url !== 'string' || url.length > 2048) return false;
      let parsed;
      try { parsed = new URL(url); } catch { return false; }
      if (!['http:', 'https:'].includes(parsed.protocol)) return false;
      addMedia.run(id, kind, parsed.href);
      return true;
    },
    removeMedia(id, mediaId) {
      return Boolean(removeMedia.run(mediaId, id).changes);
    },
    importLocal(entries) {
      let inserted = 0;
      db.exec('BEGIN');
      try {
        for (const game of entries) {
          if (excluded.get(game.gameKey)) continue;
          inserted += Number(insertLocal.run(game.id, game.gameKey, game.title, game.platform, game.sourcePath, game.drive).changes);
        }
        db.exec('COMMIT');
      } catch (error) {
        db.exec('ROLLBACK');
        throw error;
      }
      return inserted;
    },
    removeLocal(id) {
      if (!findLocal.get(id)) return false;
      removeLocal.run(id);
      return true;
    },
    close: () => db.close()
  };
}
