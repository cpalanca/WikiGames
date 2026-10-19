import test from 'node:test';
import assert from 'node:assert/strict';
import { createDatabase } from '../database.mjs';
import { parseSceneFeed } from '../scene.mjs';

const game = { id: '1234567890abcdef1234', gameKey: 'switch:sample', title: 'Sample', platform: 'Switch', sourcePath: 'E:\\Sample', drive: 'E:' };

test('local favorites, completion and media persist and are removed with the game', () => {
  const db = createDatabase();
  try {
    db.importLocal([game]);
    assert.equal(db.setLocalFlag(game.id, 'isFavorite', true), true);
    assert.equal(db.setLocalFlag(game.id, 'isCompleted', true), true);
    assert.equal(db.setLocalFlag(game.id, 'isCompleted', 'yes'), false);
    assert.equal(db.listLocal()[0].isFavorite, 1);
    assert.equal(db.listLocal()[0].isCompleted, 1);
    assert.equal(db.addMedia(game.id, 'image', 'https://example.com/image.jpg'), true);
    assert.equal(db.addMedia(game.id, 'video', 'javascript:alert(1)'), false);
    assert.equal(db.listMedia(game.id).length, 1);
    db.removeLocal(game.id);
    assert.deepEqual(db.listMedia(game.id), []);
  } finally { db.close(); }
});

test('scene feed parser reads public video metadata', () => {
  const xml = '<feed><entry><yt:videoId>abcdefghijk</yt:videoId><title>Nuevo &amp; mejorado</title><published>2026-10-19T10:00:00+00:00</published></entry></feed>';
  assert.deepEqual(parseSceneFeed(xml, { name: 'Canal', topic: 'Scene' })[0], {
    id: 'abcdefghijk', title: 'Nuevo & mejorado', published: '2026-10-19T10:00:00+00:00', channel: 'Canal', topic: 'Scene', url: 'https://www.youtube.com/watch?v=abcdefghijk', thumbnail: 'https://i.ytimg.com/vi/abcdefghijk/hqdefault.jpg'
  });
});
