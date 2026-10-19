import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { getSteamCatalog } from './steam.mjs';
import { createDatabase } from './database.mjs';
import { scanLocalGames } from './inventory.mjs';
import { getSceneNews } from './scene.mjs';
import { getGameWavePorts } from './ports.mjs';
import { games as curatedGames } from '../../packages/catalog/src/index.js';

const here = path.dirname(fileURLToPath(import.meta.url));
const routes = new Map([
  ['/', path.join(here, 'public/index.html')],
  ['/src/app.js', path.join(here, 'src/app.js')],
  ['/src/styles.css', path.join(here, 'src/styles.css')],
  ['/src/steam.css', path.join(here, 'src/steam.css')],
  ['/src/local.css', path.join(here, 'src/local.css')],
  ['/catalog/index.js', path.resolve(here, '../../packages/catalog/src/index.js')]
]);
const mime = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8' };
const port = Number(process.env.PORT) || 3000;
const database = createDatabase(path.join(here, 'data/wikigames.sqlite'));

async function readJson(request) {
  let body = '';
  for await (const chunk of request) {
    body += chunk;
    if (body.length > 8192) return null;
  }
  try { return JSON.parse(body); } catch { return null; }
}

function json(response, status, value) {
  response.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify(value));
}

createServer(async (request, response) => {
  const url = new URL(request.url, 'http://localhost');
  if (url.pathname === '/api/games') {
    const catalog = await getSteamCatalog();
    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-cache' }).end(JSON.stringify({ games: catalog.games, source: catalog.source, synced: catalog.synced || 0, gridCount: catalog.gridCount || 0 }));
    return;
  }
  if (url.pathname === '/api/ports' && request.method === 'GET') {
    const titles = [...new Set([...curatedGames.map(game => game.title), ...database.listLocal().map(game => game.title)])];
    return json(response, 200, { matches: await getGameWavePorts(titles) });
  }
  if (url.pathname === '/api/scene' && request.method === 'GET') {
    return json(response, 200, await getSceneNews());
  }
  if (url.pathname === '/api/library' && request.method === 'GET') {
    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify({ items: database.listLibrary() }));
    return;
  }
  const libraryId = /^\/api\/library\/([a-z0-9-]+)$/.exec(url.pathname)?.[1];
  if (libraryId && (request.method === 'PUT' || request.method === 'DELETE')) {
    const valid = request.method === 'PUT' ? database.addLibrary(libraryId) : database.removeLibrary(libraryId);
    response.writeHead(valid ? 200 : 404, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify(valid ? { items: database.listLibrary() } : { error: 'Unknown game' }));
    return;
  }
  if (url.pathname === '/api/local-games' && request.method === 'GET') {
    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify({ games: database.listLocal() }));
    return;
  }
  const localMedia = /^\/api\/local-games\/([a-f0-9]{20})\/media(?:\/(\d+))?$/.exec(url.pathname);
  if (localMedia) {
    const [, id, mediaId] = localMedia;
    if (request.method === 'GET' && !mediaId) return json(response, 200, { media: database.listMedia(id) });
    if (request.method === 'POST' && !mediaId) {
      const input = await readJson(request);
      const added = input && database.addMedia(id, input.kind, input.url);
      return json(response, added ? 200 : 400, added ? { media: database.listMedia(id) } : { error: 'Invalid media' });
    }
    if (request.method === 'DELETE' && mediaId) {
      const removed = database.removeMedia(id, Number(mediaId));
      return json(response, removed ? 200 : 404, removed ? { media: database.listMedia(id) } : { error: 'Unknown media' });
    }
  }
  const coverId = /^\/api\/local-games\/([a-f0-9]{20})\/cover$/.exec(url.pathname)?.[1];
  if (coverId && request.method === 'GET') {
    const game = database.listLocal().find(item => item.id === coverId);
    const wiiId = game?.platform === 'Wii' ? /\[([A-Z0-9]{6})\]/i.exec(game.sourcePath)?.[1]?.toUpperCase() : null;
    if (wiiId) {
      for (const folder of ['2D', '']) {
        try {
          const image = await readFile(path.join('G:\\WII\\config\\images', folder, `${wiiId}.png`));
          response.writeHead(200, { 'Content-Type': 'image/png', 'Content-Length': image.length, 'Cache-Control': 'public, max-age=3600' }).end(image);
          return;
        } catch {}
      }
    }
    response.writeHead(404).end('Cover not found');
    return;
  }
  if (url.pathname === '/api/local-games/scan' && request.method === 'POST') {
    const scan = await scanLocalGames();
    const added = database.importLocal(scan.games);
    response.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify({ games: database.listLocal(), added, unavailable: scan.unavailable }));
    return;
  }
  const localId = /^\/api\/local-games\/([a-f0-9]{20})$/.exec(url.pathname)?.[1];
  if (localId && request.method === 'PATCH') {
    const input = await readJson(request);
    const fields = input && Object.keys(input);
    const valid = fields?.length === 1 && database.setLocalFlag(localId, fields[0], input[fields[0]]);
    return json(response, valid ? 200 : 400, valid ? { games: database.listLocal() } : { error: 'Invalid game update' });
  }
  if (localId && request.method === 'DELETE') {
    const removed = database.removeLocal(localId);
    response.writeHead(removed ? 200 : 404, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }).end(JSON.stringify(removed ? { games: database.listLocal() } : { error: 'Unknown local game' }));
    return;
  }
  const file = routes.get(url.pathname);
  if (!file) {
    response.writeHead(404).end('Not found');
    return;
  }
  try {
    const info = await stat(file);
    const content = await readFile(file);
    response.writeHead(200, { 'Content-Type': mime[path.extname(file)], 'Content-Length': info.size, 'Cache-Control': 'no-cache' }).end(content);
  } catch {
    response.writeHead(500).end('Server error');
  }
}).listen(port, () => console.log(`WikiGames: http://localhost:${port}`));
