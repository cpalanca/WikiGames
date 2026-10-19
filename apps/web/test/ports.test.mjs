import test from 'node:test';
import assert from 'node:assert/strict';
import { matchPorts } from '../ports.mjs';

test('GameWave links require an enabled exact game name and a safe project URL', () => {
  const apps = [
    { name: 'Wii recomp', gameNames: ['Mario Kart Wii'], projectUrl: 'https://github.com/example/recomp', enabled: true },
    { name: 'Different game', gameNames: ['Mario Kart 64'], projectUrl: 'https://example.com/64', enabled: true },
    { name: 'Unreviewed community entry', gameNames: ['Mario Kart Wii'], projectUrl: 'https://example.com/community', verification: 'community_android_sheet', enabled: true },
    { name: 'Unsafe', gameNames: ['Mario Kart Wii'], projectUrl: 'javascript:alert(1)', enabled: true }
  ];
  assert.deepEqual(matchPorts(['MARIO KART WII', 'Mario Kart 8'], apps), {
    'MARIO KART WII': [{ name: 'Wii recomp', url: 'https://github.com/example/recomp' }]
  });
});

test('the Mario Galaxy 1-2 collection links only to the documented first game', () => {
  const apps = [{ name: 'Nebula', gameNames: ['Super Mario Galaxy'], projectUrl: 'https://github.com/example/nebula', enabled: true }];
  assert.deepEqual(matchPorts(['Super Mario Galaxy 1-2', 'Super Mario Galaxy 2'], apps), {
    'Super Mario Galaxy 1-2': [{ name: 'Nebula', url: 'https://github.com/example/nebula', game: 'Super Mario Galaxy' }]
  });
});
