import { cp, mkdir, copyFile, rm } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const here = path.dirname(fileURLToPath(import.meta.url));
const app = path.resolve(here, '..');
const dist = path.join(app, 'dist');
await rm(dist, { recursive: true, force: true });
await mkdir(path.join(dist, 'catalog'), { recursive: true });
await cp(path.join(app, 'public'), dist, { recursive: true });
await cp(path.join(app, 'src'), path.join(dist, 'src'), { recursive: true });
await copyFile(path.resolve(app, '../../packages/catalog/src/index.js'), path.join(dist, 'catalog/index.js'));
console.log(`Built ${dist}`);
