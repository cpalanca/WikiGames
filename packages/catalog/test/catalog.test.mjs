import test from 'node:test';
import assert from 'node:assert/strict';
import { games, filterGames } from '../src/index.js';

test('catalog entries have unique IDs and required content', () => {
  assert.equal(new Set(games.map(game => game.id)).size, games.length);
  assert.equal(new Set(games.map(game => game.steamAppId)).size, games.length);
  for (const game of games) {
    assert.ok(game.title && game.description && game.art);
    assert.ok(Number.isInteger(game.steamAppId));
    assert.ok(game.genres.length > 0);
  }
});

test('search, genre, library and sorting combine correctly', () => {
  assert.deepEqual(filterGames(games, { query: 'team cherry' }).map(game => game.id), ['hollow-knight']);
  assert.ok(filterGames(games, { genre: 'RPG' }).every(game => game.genres.includes('RPG')));
  assert.deepEqual(filterGames(games, { library: ['hades'] }).map(game => game.id), ['hades']);
  const byScore = filterGames(games, { sort: 'score' });
  assert.ok(byScore.every((game, index) => index === 0 || byScore[index - 1].score >= game.score));
});
