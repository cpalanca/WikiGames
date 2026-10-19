import { games as localGames, genres, filterGames } from '../catalog/index.js';

let games = localGames;
let catalogSource = '';
let diskGames = [];
let gameWaveMatches = {};
let sceneNews = null;
let sceneLoadedAt = 0;

const icons = {
  grid: '<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/>',
  compass: '<circle cx="12" cy="12" r="9"/><path d="m15.5 8.5-2.3 4.7-4.7 2.3 2.3-4.7z"/>',
  bookmark: '<path d="M6 4.5A1.5 1.5 0 0 1 7.5 3h9A1.5 1.5 0 0 1 18 4.5V21l-6-4-6 4z"/>',
  search: '<circle cx="10.8" cy="10.8" r="6.8"/><path d="m16 16 5 5"/>',
  arrow: '<path d="M5 12h14m-6-6 6 6-6 6"/>',
  chevron: '<path d="m9 18 6-6-6-6"/>',
  spark: '<path d="m12 2 1.9 7.1L21 11l-7.1 1.9L12 20l-1.9-7.1L3 11l7.1-1.9z"/>',
  close: '<path d="M5 5 19 19M19 5 5 19"/>',
  check: '<path d="m4 12 5 5L20 6"/>',
  menu: '<path d="M4 7h16M4 12h16M4 17h16"/>',
  sliders: '<path d="M4 7h16M4 17h16"/><circle cx="9" cy="7" r="2"/><circle cx="15" cy="17" r="2"/>'
};
const icon = (name, size = 20) => `<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${icons[name]}</svg>`;
const escapeHtml = value => String(value).replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[char]);
const oldStorageKey = 'wikigames.library.v1';
let library = [];
try { localStorage.removeItem(oldStorageKey); } catch {}
const state = { view: 'explore', query: '', genre: 'Todos', sort: 'featured', localPlatform: 'Todas', localStatus: 'Todos', sceneTopic: 'Todos' };
const app = document.querySelector('#app');

app.innerHTML = `
  <div class="app-shell">
    <aside class="sidebar" id="sidebar">
      <a class="brand" href="#explorar" data-view="explore" aria-label="WikiGames, inicio"><span class="brand-mark">W<span>✦</span></span><span>Wiki<span class="brand-accent">Games</span><small>THE GAME ARCHIVE</small></span></a>
      <div class="sidebar-group"><p class="sidebar-label">MENÚ</p>
        <button class="nav-link active" data-view="explore">${icon('compass')}<span>Explorar</span></button>
        <button class="nav-link" data-view="all">${icon('grid')}<span>Todos los juegos</span></button>
        <button class="nav-link" data-view="library">${icon('bookmark')}<span>Mi biblioteca</span><span class="nav-count" id="library-count">0</span></button>
      </div>
      <div class="sidebar-group genre-nav"><p class="sidebar-label">GÉNEROS</p>
        ${genres.slice(1, 7).map(genre => `<button class="genre-link" data-genre-nav="${escapeHtml(genre)}"><span class="genre-dot"></span>${escapeHtml(genre)}</button>`).join('')}
      </div>
      <div class="sidebar-bottom"><div class="sidebar-note"><span class="note-icon">${icon('spark', 18)}</span><strong>Tu próxima aventura</strong><p>Un universo de juegos por descubrir, en un solo lugar.</p></div><span class="sidebar-foot">© 2026 WikiGames</span></div>
    </aside>

    <div class="main-column">
      <header class="topbar"><button class="mobile-menu icon-button" id="menu-button" aria-label="Abrir menú">${icon('menu')}</button><div class="topbar-path">WIKIGAMES <span>/</span> <strong id="breadcrumb">EXPLORAR</strong></div><div class="topbar-actions"><label class="search-box">${icon('search', 19)}<input id="search" type="search" placeholder="Buscar juegos, géneros, estudios..." autocomplete="off" aria-label="Buscar juegos"><kbd>⌘ K</kbd></label><div class="avatar" aria-label="Perfil local">WG</div></div></header>
      <main class="content">
        <section class="hero" id="hero"><div class="hero-grid"></div><div class="hero-orb"></div><div class="hero-arc hero-arc-one"></div><div class="hero-arc hero-arc-two"></div><div class="hero-content"><div class="eyebrow"><span class="eyebrow-line"></span> TU UNIVERSO GAMING EMPIEZA AQUÍ</div><h1>Hay un mundo<br><em>esperando</em> por ti.</h1><p>Descubre, explora y guarda los videojuegos que hacen de cada partida una historia inolvidable.</p><button class="hero-button" id="hero-action">Explorar juegos ${icon('arrow', 18)}</button></div><div class="hero-feature"><span class="feature-label">JUEGO DESTACADO <span>●</span> 01 / 03</span><strong>ELDEN RING</strong><span>Un mundo. Infinitas leyendas.</span></div><span class="hero-side-label">EXPLORE BEYOND THE ORDINARY — 2026</span></section>

        <section class="stats" aria-label="Datos del catálogo"><div><span class="stat-icon">✦</span><strong>${games.length}</strong><span>Juegos en el archivo</span></div><div><span class="stat-icon">◈</span><strong>${genres.length - 1}</strong><span>Géneros para explorar</span></div><div><span class="stat-icon">♡</span><strong id="saved-stat">0</strong><span>En tu biblioteca</span></div></section>

        <section class="catalog" id="catalog"><div class="section-heading"><div><div class="section-kicker"><span></span> EL ARCHIVO</div><h2 id="section-title">Descubre tu próximo juego<span>.</span></h2><p id="section-subtitle">Una selección de mundos que merece la pena explorar.</p></div><span class="result-count" id="result-count"></span></div>
          <div class="toolbar"><div class="filter-list" id="filters" aria-label="Filtrar por género"></div><label class="sort-box">${icon('sliders', 17)}<select id="sort" aria-label="Ordenar juegos"><option value="featured">Destacados</option><option value="score">Mejor valorados</option><option value="newest">Más recientes</option><option value="az">A — Z</option></select></label></div>
          <div class="game-grid" id="game-grid"></div>
        </section>
        <footer class="footer"><span class="footer-brand">W<span>✦</span> WikiGames</span><span>Hecho para quienes siempre quieren jugar una partida más.</span><span>© 2026</span></footer>
      </main>
    </div>
  </div><div class="modal-backdrop" id="modal-backdrop" hidden></div><div class="toast" id="toast" role="status" aria-live="polite"></div>`;
document.querySelector('[data-view="library"]').insertAdjacentHTML('afterend', `<button class="nav-link" data-view="local">${icon('grid')}<span>Mis discos</span><span class="nav-count" id="disk-count">0</span></button>`);
document.querySelector('[data-view="local"]').insertAdjacentHTML('afterend', `<button class="nav-link" data-view="scene">${icon('spark')}<span>SCENE</span></button>`);
document.querySelector('.section-heading').insertAdjacentHTML('beforeend', '<button class="scan-button" id="scan-button" hidden>Actualizar discos ↻</button>');

const grid = document.querySelector('#game-grid');
const filters = document.querySelector('#filters');
const search = document.querySelector('#search');
const modalBackdrop = document.querySelector('#modal-backdrop');

function cover(game, type = '') {
  const steamImage = game.steamAppId ? `https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/${game.steamAppId}/library_600x900.jpg` : '';
  const image = game.coverImage || steamImage;
  const imageTag = image ? `<img class="steam-cover" src="${escapeHtml(image)}" ${game.coverImage && steamImage ? `data-fallback="${steamImage}"` : ''} alt="Portada de ${escapeHtml(game.title)}" loading="${type ? 'eager' : 'lazy'}">` : '';
  return `<div class="game-art art-${game.art} ${type}">${imageTag}<span class="art-noise"></span><span class="art-symbol">${game.glyph}</span><span class="art-bottom"><span>${escapeHtml(game.studio)}</span><strong>${escapeHtml(game.title)}</strong></span></div>`;
}

function renderLocalCard(game) {
  return `<article class="game-card local-card"><button class="cover-button" data-open-local="${game.id}" aria-label="Ver ficha de ${escapeHtml(game.title)}">${cover({ ...game, art: 'local', glyph: '◆', studio: game.platform })}<span class="cover-overlay">Ver ficha ${icon('arrow', 17)}</span></button><button class="save-button local-favorite ${game.isFavorite ? 'saved' : ''}" data-local-flag="isFavorite" data-local-id="${game.id}" aria-label="${game.isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos'}" title="${game.isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos'}">${icon('bookmark', 18)}</button><div class="card-info"><div class="card-topline"><span>${escapeHtml(game.platform)}</span><span>${escapeHtml(game.drive)}</span></div><button class="card-title local-title" data-open-local="${game.id}">${escapeHtml(game.title)}</button>${gameWaveMatches[game.title]?.length ? '<span class="local-port-badge">Port disponible ↗</span>' : ''}${game.isCompleted ? '<span class="local-completed-badge">✓ Pasado</span>' : ''}<p class="local-path" title="${escapeHtml(game.sourcePath)}">${escapeHtml(game.sourcePath)}</p></div></article>`;
}

function renderLocal() {
  const query = state.query.trim().toLocaleLowerCase('es');
  const results = diskGames.filter(game => `${game.title} ${game.platform} ${game.drive}`.toLocaleLowerCase('es').includes(query) && (state.localPlatform === 'Todas' || game.platform === state.localPlatform) && (state.localStatus === 'Todos' || state.localStatus === 'Favoritos' && game.isFavorite || state.localStatus === 'Pasados' && game.isCompleted || state.localStatus === 'Pendientes' && !game.isCompleted));
  const platforms = ['Todas', ...['Switch', 'Wii U', 'Wii'].filter(platform => diskGames.some(game => game.platform === platform))];
  document.querySelector('#hero').hidden = true;
  document.querySelector('.stats').hidden = true;
  document.querySelector('#section-title').innerHTML = 'Juegos de mis discos<span>.</span>';
  document.querySelector('#section-subtitle').textContent = `${diskGames.filter(game => game.isFavorite).length} favoritos · ${diskGames.filter(game => game.isCompleted).length} pasados · Inventario de E: y G:`;
  document.querySelector('#breadcrumb').textContent = 'MIS DISCOS';
  document.querySelector('#result-count').textContent = `${results.length} ${results.length === 1 ? 'JUEGO' : 'JUEGOS'}`;
  document.querySelector('#disk-count').textContent = diskGames.length;
  filters.hidden = false;
  filters.innerHTML = `<div class="local-filter-group" aria-label="Plataformas">${platforms.map(platform => `<button class="filter-chip ${state.localPlatform === platform ? 'selected' : ''}" data-local-platform="${escapeHtml(platform)}">${escapeHtml(platform)}</button>`).join('')}</div><div class="local-filter-group" aria-label="Estado">${['Todos', 'Favoritos', 'Pasados', 'Pendientes'].map(status => `<button class="filter-chip ${state.localStatus === status ? 'selected' : ''}" data-local-status="${status}">${status}</button>`).join('')}</div>`;
  document.querySelector('.sort-box').hidden = true;
  document.querySelector('#scan-button').hidden = false;
  document.querySelectorAll('[data-view]').forEach(button => button.classList.toggle('active', button.dataset.view === 'local'));
  grid.innerHTML = results.length ? platforms.slice(1).map(platform => {
    const group = results.filter(game => game.platform === platform);
    return group.length ? `<h3 class="platform-heading">${escapeHtml(platform)} <span>${group.length} juegos</span></h3>${group.map(renderLocalCard).join('')}` : '';
  }).join('') : `<div class="empty-state"><span class="empty-symbol">◇</span><h3>${diskGames.length ? 'No hay juegos con estos filtros' : 'No hay juegos importados'}</h3><p>${diskGames.length ? 'Prueba con otra plataforma, estado o búsqueda.' : 'Pulsa “Actualizar discos” para importar desde E: y G:.'}</p></div>`;
}

function renderFilters() {
  filters.innerHTML = genres.slice(0, 7).map(genre => `<button class="filter-chip ${state.genre === genre ? 'selected' : ''}" data-genre="${escapeHtml(genre)}">${escapeHtml(genre)}</button>`).join('');
}

function renderScene() {
  document.querySelector('#hero').hidden = true;
  document.querySelector('.stats').hidden = true;
  document.querySelector('#section-title').innerHTML = 'Novedades de la SCENE<span>.</span>';
  document.querySelector('#section-subtitle').textContent = 'Últimos vídeos públicos de canales de consolas, homebrew y videojuegos.';
  document.querySelector('#breadcrumb').textContent = 'SCENE';
  document.querySelector('#scan-button').hidden = true;
  document.querySelector('.sort-box').hidden = true;
  filters.hidden = false;
  filters.innerHTML = ['Todos', 'Scene', 'Switch', 'PlayStation', 'Retro', 'Gaming'].map(topic => `<button class="filter-chip ${state.sceneTopic === topic ? 'selected' : ''}" data-scene-topic="${topic}">${topic}</button>`).join('');
  const query = state.query.toLocaleLowerCase('es');
  const videos = (sceneNews?.videos || []).filter(video => (state.sceneTopic === 'Todos' || video.topic === state.sceneTopic) && `${video.title} ${video.channel}`.toLocaleLowerCase('es').includes(query));
  document.querySelector('#result-count').textContent = `${videos.length} VÍDEOS`;
  document.querySelectorAll('[data-view]').forEach(button => button.classList.toggle('active', button.dataset.view === 'scene'));
  grid.innerHTML = videos.length ? videos.map(video => `<article class="scene-card"><a href="${escapeHtml(video.url)}" target="_blank" rel="noopener noreferrer"><img src="${escapeHtml(video.thumbnail)}" alt="Miniatura de ${escapeHtml(video.title)}" loading="lazy"><div class="scene-card-body"><span>${escapeHtml(video.channel)} · ${new Date(video.published).toLocaleDateString('es-ES')}</span><h3>${escapeHtml(video.title)}</h3><small>${escapeHtml(video.topic)} · Ver en YouTube ↗</small></div></a></article>`).join('') : `<div class="empty-state"><span class="empty-symbol">✦</span><h3>${sceneNews ? 'No hay vídeos con estos filtros' : 'Cargando novedades…'}</h3><p>${sceneNews ? 'Prueba con otro canal, tema o búsqueda.' : 'Consultando los canales públicos de YouTube.'}</p></div>`;
  const channels = (sceneNews?.channels || []).filter(channel => state.sceneTopic === 'Todos' || channel.topic === state.sceneTopic);
  grid.insertAdjacentHTML('afterend', `<div class="scene-channels" id="scene-channels"><strong>Canales seguidos</strong>${channels.map(channel => `<a href="${escapeHtml(channel.url)}" target="_blank" rel="noopener noreferrer">${escapeHtml(channel.name)} ↗</a>`).join('')}</div>`);
}

async function loadScene() {
  if (sceneNews && Date.now() - sceneLoadedAt < 20 * 60 * 1000) return;
  try {
    const response = await fetch('./api/scene');
    if (!response.ok) throw new Error('Scene feed failed');
    sceneNews = await response.json();
    sceneLoadedAt = Date.now();
  } catch { sceneNews = { videos: [], channels: [] }; showToast('No se pudieron cargar las novedades'); }
  if (state.view === 'scene') render();
}

function render() {
  document.querySelector('#scene-channels')?.remove();
  if (state.view === 'local') { renderLocal(); return; }
  if (state.view === 'scene') { renderScene(); return; }
  document.querySelector('#filters').hidden = false;
  document.querySelector('.sort-box').hidden = false;
  document.querySelector('#scan-button').hidden = true;
  document.querySelector('#disk-count').textContent = diskGames.length;
  const saved = state.view === 'library' ? library : null;
  const results = filterGames(games, { query: state.query, genre: state.genre, sort: state.sort, library: saved });
  const isLibrary = state.view === 'library';
  const localFavorites = isLibrary ? diskGames.filter(game => game.isFavorite && `${game.title} ${game.platform}`.toLocaleLowerCase('es').includes(state.query.toLocaleLowerCase('es'))) : [];
  document.querySelector('#hero').hidden = state.view !== 'explore' || !!state.query;
  document.querySelector('.stats').hidden = state.view !== 'explore' || !!state.query;
  document.querySelector('#section-title').innerHTML = isLibrary ? 'Tu biblioteca<span>.</span>' : state.query ? 'Resultados de búsqueda<span>.</span>' : state.view === 'all' ? 'Todos los juegos<span>.</span>' : 'Descubre tu próximo juego<span>.</span>';
  document.querySelector('#section-subtitle').textContent = isLibrary ? 'Tus favoritos del archivo y de tus discos.' : state.query ? `Buscando “${state.query}” en el archivo.` : state.view === 'all' ? 'Explora el archivo completo y encuentra tu próxima aventura.' : 'Una selección de mundos que merece la pena explorar.';
  document.querySelector('#breadcrumb').textContent = isLibrary ? 'MI BIBLIOTECA' : state.view === 'all' ? 'TODOS LOS JUEGOS' : 'EXPLORAR';
  document.querySelector('#result-count').textContent = `${results.length + localFavorites.length} ${results.length + localFavorites.length === 1 ? 'JUEGO' : 'JUEGOS'}${catalogSource ? ` · ${catalogSource}` : ''}`;
  document.querySelector('#library-count').textContent = library.length + diskGames.filter(game => game.isFavorite).length;
  document.querySelector('#saved-stat').textContent = library.length + diskGames.filter(game => game.isFavorite).length;
  document.querySelectorAll('[data-view]').forEach(button => button.classList.toggle('active', button.dataset.view === state.view));
  renderFilters();
  grid.innerHTML = results.length || localFavorites.length ? results.map(game => `<article class="game-card"><button class="cover-button" data-open="${game.id}" aria-label="Ver ${escapeHtml(game.title)}">${cover(game)}<span class="cover-overlay">Ver ficha ${icon('arrow', 17)}</span></button><button class="save-button ${library.includes(game.id) ? 'saved' : ''}" data-save="${game.id}" aria-label="${library.includes(game.id) ? 'Quitar de' : 'Añadir a'} mi biblioteca" title="${library.includes(game.id) ? 'Quitar de mi biblioteca' : 'Guardar en mi biblioteca'}">${icon('bookmark', 18)}</button><div class="card-info"><div class="card-topline"><span>${escapeHtml(game.genres[0])} <span class="dot-separator">·</span> ${game.year}</span><span class="score" title="Valoración de muestra"><span>★</span> ${game.score}</span></div><button class="card-title" data-open="${game.id}">${escapeHtml(game.title)}</button><div class="card-bottom"><span>${escapeHtml(game.studio)}</span><span>${icon('chevron', 16)}</span></div></div></article>`).join('') + localFavorites.map(renderLocalCard).join('') : `<div class="empty-state"><span class="empty-symbol">◇</span><h3>${isLibrary && !state.query ? 'Tu biblioteca espera su primer juego' : 'No encontramos juegos'}</h3><p>${isLibrary && !state.query ? 'Guarda los juegos que te interesan y aparecerán aquí.' : 'Prueba con otro nombre, género o filtro.'}</p><button id="empty-reset">${isLibrary && !state.query ? 'Explorar juegos' : 'Limpiar filtros'} ${icon('arrow', 16)}</button></div>`;
}

async function saveGame(id) {
  const game = games.find(item => item.id === id);
  if (!game) return;
  const wasSaved = library.includes(id);
  try {
    const response = await fetch(`./api/library/${id}`, { method: wasSaved ? 'DELETE' : 'PUT' });
    if (!response.ok) throw new Error('Library update failed');
    library = (await response.json()).items;
    render();
    if (!modalBackdrop.hidden) openGame(id);
    showToast(wasSaved ? `${game.title} se quitó de tu biblioteca` : `${game.title} se añadió a tu biblioteca`);
  } catch {
    showToast('No se pudo actualizar la biblioteca');
  }
}

let toastTimer;
function showToast(message) {
  const toast = document.querySelector('#toast');
  toast.textContent = message;
  toast.classList.add('visible');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove('visible'), 2800);
}

function showGameWavePorts(title) {
  const body = modalBackdrop.querySelector('.modal-body');
  body.querySelector('.gamewave-ports')?.remove();
  const ports = gameWaveMatches[title];
  if (!ports?.length) return;
  const section = document.createElement('section');
  section.className = 'gamewave-ports';
  section.innerHTML = `<h3>Ports disponibles en GameWave</h3>${ports.map(port => `<a href="${escapeHtml(port.url)}" target="_blank" rel="noopener noreferrer">${port.game ? `${escapeHtml(port.game)} (juego 1): ` : ''}${escapeHtml(port.name)} ↗</a>`).join('')}<a class="gamewave-catalog-link" href="https://gamewave.digital/ports/" target="_blank" rel="noopener noreferrer">Ver catálogo de GameWave ↗</a>`;
  (body.querySelector('.modal-tags') || body.querySelector('#modal-title')).after(section);
}

function openGame(id) {
  const game = games.find(item => item.id === id);
  if (!game) return;
  const saved = library.includes(id);
  modalBackdrop.innerHTML = `<section class="game-modal" role="dialog" aria-modal="true" aria-labelledby="modal-title"><button class="modal-close" data-close aria-label="Cerrar ficha">${icon('close', 21)}</button>${cover(game, 'modal-art')}<div class="modal-body"><div class="modal-eyebrow">FICHA DEL JUEGO <span>✦</span> ${game.year}</div><h2 id="modal-title">${escapeHtml(game.title)}</h2><p class="modal-description">${escapeHtml(game.description)}</p><div class="modal-tags">${game.genres.map(genre => `<span>${escapeHtml(genre)}</span>`).join('')}</div><div class="modal-facts"><div><span>ESTUDIO</span><strong>${escapeHtml(game.studio)}</strong></div><div><span>PLATAFORMAS</span><strong>${escapeHtml(game.platforms.join(' · '))}</strong></div><div><span>VALORACIÓN DE MUESTRA</span><strong><span class="score-star">★</span> ${game.score} / 100</strong></div></div><button class="modal-save ${saved ? 'is-saved' : ''}" data-save="${game.id}">${icon(saved ? 'check' : 'bookmark', 18)} ${saved ? 'Guardado en mi biblioteca' : 'Guardar en mi biblioteca'}</button></div></section>`;
  modalBackdrop.querySelector('.modal-body').insertAdjacentHTML('beforeend', `<a class="steamdb-link" href="https://steamdb.info/app/${game.steamAppId}/" target="_blank" rel="noopener noreferrer">Ver ficha en SteamDB ↗</a>`);
  if (game.screenshots?.length || game.videos?.length) {
    modalBackdrop.querySelector('.modal-body').insertAdjacentHTML('beforeend', `<section class="local-media catalog-media"><h3>Imágenes y vídeos</h3><div class="local-media-grid">${(game.screenshots || []).map(url => `<div class="local-media-item"><a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer"><img src="${escapeHtml(url)}" alt="Captura de ${escapeHtml(game.title)}" loading="lazy"></a></div>`).join('')}${(game.videos || []).map(video => `<div class="local-media-item video-item"><video controls preload="metadata" src="${escapeHtml(video.url)}" aria-label="${escapeHtml(video.title || 'Vídeo del juego')}"></video></div>`).join('')}</div></section>`);
  }
  showGameWavePorts(game.title);
  modalBackdrop.hidden = false;
  document.body.classList.add('modal-open');
  modalBackdrop.querySelector('[data-close]').focus();
}

function openLocalGame(id) {
  const game = diskGames.find(item => item.id === id);
  if (!game) return;
  const wiiId = game.platform === 'Wii' ? /\[([A-Z0-9]{6})\]/i.exec(game.sourcePath)?.[1]?.toUpperCase() : null;
  const gametdbId = /art\.gametdb\.com\/(?:switch|wiiu|wii)\/[^/]+\/[^/]+\/([A-Z0-9]{4,6})\./i.exec(game.coverImage || '')?.[1] || wiiId;
  const gametdbPlatform = game.platform === 'Wii U' ? 'WiiU' : game.platform;
  const imported = game.importedAt ? new Date(`${game.importedAt.replace(' ', 'T')}Z`).toLocaleDateString('es-ES') : '';
  modalBackdrop.innerHTML = `<section class="game-modal local-modal" data-local-modal="${game.id}" role="dialog" aria-modal="true" aria-labelledby="modal-title"><button class="modal-close" data-close aria-label="Cerrar ficha">${icon('close', 21)}</button>${cover({ ...game, art: 'local', glyph: '◆', studio: game.platform }, 'modal-art')}<div class="modal-body"><div class="modal-eyebrow">JUEGO DE MIS DISCOS</div><h2 id="modal-title">${escapeHtml(game.title)}</h2><div class="modal-tags"><span>${escapeHtml(game.platform)}</span><span>${escapeHtml(game.drive)}</span></div><div class="local-actions"><button class="local-action ${game.isFavorite ? 'active' : ''}" data-local-flag="isFavorite" data-local-id="${game.id}">${icon('bookmark', 16)} ${game.isFavorite ? 'En favoritos' : 'Añadir a favoritos'}</button><button class="local-action ${game.isCompleted ? 'active' : ''}" data-local-flag="isCompleted" data-local-id="${game.id}">${icon('check', 16)} ${game.isCompleted ? 'Pasado' : 'Marcar como pasado'}</button></div><div class="modal-facts"><div><span>PLATAFORMA</span><strong>${escapeHtml(game.platform)}</strong></div>${gametdbId ? `<div><span>ID DEL JUEGO</span><strong>${escapeHtml(gametdbId)}</strong></div>` : ''}<div><span>UBICACIÓN</span><strong class="local-source-path">${escapeHtml(game.sourcePath)}</strong></div>${imported ? `<div><span>AÑADIDO AL CATÁLOGO</span><strong>${escapeHtml(imported)}</strong></div>` : ''}</div><section class="local-media"><h3>Imágenes y vídeos</h3><div class="local-media-grid" id="local-media-grid"><p class="local-media-empty">Cargando…</p></div><form id="local-media-form" data-game-id="${game.id}"><label for="local-media-kind">Tipo</label><select id="local-media-kind" name="kind"><option value="image">Imagen</option><option value="video">Vídeo</option></select><label for="local-media-url">Enlace</label><input id="local-media-url" name="url" type="url" placeholder="https://…" required><button type="submit">Añadir</button></form><p class="local-media-hint">Admite imágenes, enlaces de YouTube y vídeos MP4/WebM. <a href="https://www.youtube.com/results?search_query=${encodeURIComponent(game.title + ' trailer gameplay')}" target="_blank" rel="noopener noreferrer">Buscar vídeos ↗</a></p></section>${gametdbId ? `<a class="local-external-link" href="https://www.gametdb.com/${gametdbPlatform}/${gametdbId}" target="_blank" rel="noopener noreferrer">Ver información en GameTDB ↗</a>` : ''}<button class="local-delete" data-delete-local="${game.id}">Eliminar del catálogo</button></div></section>`;
  showGameWavePorts(game.title);
  modalBackdrop.hidden = false;
  document.body.classList.add('modal-open');
  modalBackdrop.querySelector('[data-close]').focus();
  loadLocalMedia(game.id);
}

function videoEmbed(url) {
  try {
    const parsed = new URL(url);
    const id = parsed.hostname === 'youtu.be' ? parsed.pathname.slice(1) : ['youtube.com', 'www.youtube.com', 'm.youtube.com'].includes(parsed.hostname) ? parsed.searchParams.get('v') || /^\/(?:shorts|live|embed)\/([a-zA-Z0-9_-]{11})/.exec(parsed.pathname)?.[1] : null;
    if (id && /^[a-zA-Z0-9_-]{11}$/.test(id)) return `<iframe src="https://www.youtube-nocookie.com/embed/${id}" title="Vídeo del juego" loading="lazy" allowfullscreen></iframe>`;
    if (/\.(mp4|webm|ogg)$/i.test(parsed.pathname)) return `<video controls preload="metadata" src="${escapeHtml(url)}"></video>`;
  } catch {}
  return `<a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">Abrir vídeo ↗</a>`;
}

function showLocalMedia(id, media) {
  const grid = modalBackdrop.querySelector(`[data-local-modal="${id}"] #local-media-grid`);
  if (!grid) return;
  const game = diskGames.find(item => item.id === id);
  const coverImage = game?.coverImage ? `<div class="local-media-item"><a href="${escapeHtml(game.coverImage)}" target="_blank" rel="noopener noreferrer"><img src="${escapeHtml(game.coverImage)}" alt="Carátula de ${escapeHtml(game.title)}" loading="lazy"></a></div>` : '';
  grid.innerHTML = coverImage + media.map(item => `<div class="local-media-item ${item.kind === 'video' ? 'video-item' : ''}">${item.kind === 'image' ? `<a href="${escapeHtml(item.url)}" target="_blank" rel="noopener noreferrer"><img src="${escapeHtml(item.url)}" alt="Imagen del juego" loading="lazy"></a>` : videoEmbed(item.url)}<button data-remove-media="${item.id}" data-game-id="${id}" aria-label="Quitar ${item.kind === 'image' ? 'imagen' : 'vídeo'}">×</button></div>`).join('') || '<p class="local-media-empty">Aún no hay imágenes ni vídeos añadidos.</p>';
}

async function loadLocalMedia(id) {
  try {
    const response = await fetch(`./api/local-games/${id}/media`);
    if (!response.ok) throw new Error('Media load failed');
    showLocalMedia(id, (await response.json()).media);
  } catch { showLocalMedia(id, []); }
}

async function updateLocalFlag(id, flag) {
  const game = diskGames.find(item => item.id === id);
  if (!game || !['isFavorite', 'isCompleted'].includes(flag)) return;
  try {
    const response = await fetch(`./api/local-games/${id}`, { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ [flag]: !game[flag] }) });
    if (!response.ok) throw new Error('Update failed');
    diskGames = (await response.json()).games;
    render();
    if (modalBackdrop.querySelector(`[data-local-modal="${id}"]`)) openLocalGame(id);
    showToast(flag === 'isFavorite' ? 'Favoritos actualizados' : 'Estado actualizado');
  } catch { showToast('No se pudo actualizar el juego'); }
}

async function addLocalMedia(form) {
  const id = form.dataset.gameId;
  const input = Object.fromEntries(new FormData(form));
  try {
    const response = await fetch(`./api/local-games/${id}/media`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(input) });
    if (!response.ok) throw new Error('Invalid media');
    showLocalMedia(id, (await response.json()).media);
    form.reset();
    showToast('Contenido añadido');
  } catch { showToast('Introduce un enlace válido'); }
}

async function removeLocalMedia(id, mediaId) {
  if (!confirm('¿Quitar este contenido de la ficha?')) return;
  try {
    const response = await fetch(`./api/local-games/${id}/media/${mediaId}`, { method: 'DELETE' });
    if (!response.ok) throw new Error('Delete failed');
    showLocalMedia(id, (await response.json()).media);
  } catch { showToast('No se pudo quitar el contenido'); }
}

function closeModal() {
  modalBackdrop.hidden = true;
  modalBackdrop.innerHTML = '';
  document.body.classList.remove('modal-open');
}

async function refreshDisks() {
  const button = document.querySelector('#scan-button');
  button.disabled = true;
  button.textContent = 'Escaneando discos…';
  try {
    const response = await fetch('./api/local-games/scan', { method: 'POST' });
    if (!response.ok) throw new Error('Scan failed');
    const data = await response.json();
    diskGames = data.games;
    render();
    showToast(`${data.added} juegos nuevos importados`);
  } catch {
    showToast('No se pudieron escanear E: y G:');
  } finally {
    button.disabled = false;
    button.textContent = 'Actualizar discos ↻';
  }
}

async function deleteLocalGame(id) {
  const game = diskGames.find(item => item.id === id);
  if (!game || !confirm(`¿Eliminar “${game.title}” del catálogo? El archivo en ${game.drive} no se borrará.`)) return;
  try {
    const response = await fetch(`./api/local-games/${id}`, { method: 'DELETE' });
    if (!response.ok) throw new Error('Delete failed');
    diskGames = (await response.json()).games;
    closeModal();
    render();
    showToast(`${game.title} eliminado del catálogo`);
  } catch {
    showToast('No se pudo eliminar el registro');
  }
}

function setView(view) {
  state.view = view;
  state.genre = 'Todos';
  state.query = '';
  search.value = '';
  document.querySelector('#sidebar').classList.remove('open');
  render();
  if (view === 'scene') loadScene();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

document.addEventListener('click', event => {
  const view = event.target.closest('[data-view]');
  const genre = event.target.closest('[data-genre], [data-genre-nav]');
  const save = event.target.closest('[data-save]');
  const open = event.target.closest('[data-open]');
  const openLocal = event.target.closest('[data-open-local]');
  const localFlag = event.target.closest('[data-local-flag]');
  const localPlatform = event.target.closest('[data-local-platform]');
  const localStatus = event.target.closest('[data-local-status]');
  const sceneTopic = event.target.closest('[data-scene-topic]');
  const removeMedia = event.target.closest('[data-remove-media]');
  const deleteLocal = event.target.closest('[data-delete-local]');
  if (view) { event.preventDefault(); setView(view.dataset.view); }
  else if (genre) {
    state.genre = genre.dataset.genre || genre.dataset.genreNav;
    if (genre.dataset.genreNav) state.view = 'all';
    document.querySelector('#sidebar').classList.remove('open');
    render();
    document.querySelector('#catalog').scrollIntoView({ behavior: 'smooth' });
  } else if (localPlatform) { state.localPlatform = localPlatform.dataset.localPlatform; render(); }
  else if (localStatus) { state.localStatus = localStatus.dataset.localStatus; render(); }
  else if (sceneTopic) { state.sceneTopic = sceneTopic.dataset.sceneTopic; render(); }
  else if (localFlag) updateLocalFlag(localFlag.dataset.localId, localFlag.dataset.localFlag);
  else if (removeMedia) removeLocalMedia(removeMedia.dataset.gameId, removeMedia.dataset.removeMedia);
  else if (save) saveGame(save.dataset.save);
  else if (openLocal) openLocalGame(openLocal.dataset.openLocal);
  else if (open) openGame(open.dataset.open);
  else if (deleteLocal) deleteLocalGame(deleteLocal.dataset.deleteLocal);
  else if (event.target.closest('#scan-button')) refreshDisks();
  else if (event.target.closest('[data-close]') || event.target === modalBackdrop) closeModal();
  else if (event.target.closest('#hero-action')) document.querySelector('#catalog').scrollIntoView({ behavior: 'smooth' });
  else if (event.target.closest('#empty-reset')) {
    if (state.view === 'library' && !state.query) setView('explore');
    else { state.query = ''; state.genre = 'Todos'; search.value = ''; render(); }
  } else if (event.target.closest('#menu-button')) document.querySelector('#sidebar').classList.toggle('open');
});

document.addEventListener('submit', event => {
  const form = event.target.closest('#local-media-form');
  if (form) { event.preventDefault(); addLocalMedia(form); }
});

search.addEventListener('input', event => { state.query = event.target.value; render(); });
document.querySelector('#sort').addEventListener('change', event => { state.sort = event.target.value; render(); });
document.addEventListener('keydown', event => {
  if (event.key === 'Escape') { closeModal(); document.querySelector('#sidebar').classList.remove('open'); }
  if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k') { event.preventDefault(); search.focus(); }
});
document.addEventListener('load', event => {
  if (event.target.matches?.('.steam-cover')) event.target.parentElement.classList.add('has-image');
}, true);
document.addEventListener('error', event => {
  if (event.target.matches?.('.steam-cover')) {
    if (event.target.dataset.fallback) {
      event.target.src = event.target.dataset.fallback;
      delete event.target.dataset.fallback;
    } else event.target.remove();
  }
}, true);
render();

fetch('./api/local-games')
  .then(response => response.ok ? response.json() : null)
  .then(data => {
    if (!Array.isArray(data?.games)) return;
    diskGames = data.games;
    render();
  })
  .catch(() => {});

fetch('./api/library')
  .then(response => response.ok ? response.json() : null)
  .then(data => {
    if (!Array.isArray(data?.items)) return;
    library = data.items;
    render();
  })
  .catch(() => {});

fetch('./api/games')
  .then(response => response.ok ? response.json() : null)
  .then(catalog => {
    if (!catalog?.games?.length) return;
    games = catalog.games;
    catalogSource = catalog.gridCount ? 'STEAMGRIDDB' : catalog.source === 'steam' ? 'STEAM' : '';
    render();
  })
  .catch(() => {});

fetch('./api/ports')
  .then(response => response.ok ? response.json() : null)
  .then(data => {
    gameWaveMatches = data?.matches || {};
    render();
    const openTitle = !modalBackdrop.hidden && modalBackdrop.querySelector('#modal-title')?.textContent;
    if (openTitle) showGameWavePorts(openTitle);
  })
  .catch(() => {});
