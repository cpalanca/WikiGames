import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { createDatabase } from '../database.mjs';

test('SQLite library starts empty, validates games and persists changes', () => {
  const dir = mkdtempSync(path.join(tmpdir(), 'wikigames-library-'));
  const file = path.join(dir, 'library.sqlite');
  try {
    let library = createDatabase(file);
    assert.deepEqual(library.listLibrary(), []);
    assert.equal(library.addLibrary('not-a-game'), false);
    assert.equal(library.addLibrary('elden-ring'), true);
    assert.equal(library.addLibrary('elden-ring'), true);
    assert.deepEqual(library.listLibrary(), ['elden-ring']);
    library.close();

    library = createDatabase(file);
    assert.deepEqual(library.listLibrary(), ['elden-ring']);
    assert.equal(library.removeLibrary('elden-ring'), true);
    assert.deepEqual(library.listLibrary(), []);
    library.close();
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
});
