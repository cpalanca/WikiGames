import test from 'node:test';
import assert from 'node:assert/strict';
import { getSteamGridCover } from '../steam.mjs';

test('SteamGridDB grid lookup uses a server-side key and selects the highest rated portrait', async () => {
  const calls = [];
  const request = async (url, options) => {
    calls.push({ url: String(url), authorization: options.headers.Authorization });
    return {
      ok: true,
      json: async () => calls.length === 1
        ? { data: { id: 42 } }
        : { data: [{ url: 'https://example.com/low.jpg', score: 2 }, { url: 'https://example.com/high.jpg', score: 9 }] }
    };
  };
  const cover = await getSteamGridCover({ steamAppId: 1245620 }, 'secret-test-key', request);
  assert.equal(cover, 'https://example.com/high.jpg');
  assert.match(calls[0].url, /games\/steam\/1245620/);
  assert.match(calls[1].url, /grids\/game\/42\?dimensions=600x900/);
  assert.ok(calls.every(call => call.authorization === 'Bearer secret-test-key'));
});

test('SteamGridDB is skipped when no key is configured', async () => {
  assert.equal(await getSteamGridCover({ steamAppId: 1245620 }, '', () => { throw new Error('should not fetch'); }), null);
});
