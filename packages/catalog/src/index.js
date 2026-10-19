const catalog = [
  { id: 'elden-ring', title: 'Elden Ring', year: 2022, genres: ['RPG', 'Acción'], platforms: ['PC', 'PlayStation', 'Xbox'], studio: 'FromSoftware', score: 96, badge: 'Imprescindible', art: 'elden', glyph: '✦', description: 'Un mundo abierto de fantasía oscura donde cada camino guarda un descubrimiento, un desafío y una historia por descifrar.' },
  { id: 'hollow-knight', title: 'Hollow Knight', year: 2017, genres: ['Metroidvania', 'Aventura'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Team Cherry', score: 94, badge: 'Favorito', art: 'hollow', glyph: '♜', description: 'Desciende a un reino olvidado de insectos y secretos. Explora caminos entrelazados y domina combates precisos.' },
  { id: 'hades', title: 'Hades', year: 2020, genres: ['Roguelike', 'Acción'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Supergiant Games', score: 93, badge: 'Premiado', art: 'hades', glyph: '⚡', description: 'Escapa del inframundo en una aventura que transforma cada intento en una nueva parte de la historia.' },
  { id: 'stardew-valley', title: 'Stardew Valley', year: 2016, genres: ['Simulación', 'RPG'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox', 'Móvil'], studio: 'ConcernedApe', score: 92, badge: 'Para relajarse', art: 'stardew', glyph: '✿', description: 'Cultiva, pesca y construye una nueva vida en una comunidad llena de personajes y pequeñas historias.' },
  { id: 'baldurs-gate-3', title: "Baldur's Gate 3", year: 2023, genres: ['RPG', 'Estrategia'], platforms: ['PC', 'PlayStation', 'Xbox'], studio: 'Larian Studios', score: 97, badge: 'Imprescindible', art: 'baldurs', glyph: '◈', description: 'Una aventura de fantasía moldeada por tus decisiones, con combates tácticos y personajes memorables.' },
  { id: 'celeste', title: 'Celeste', year: 2018, genres: ['Plataformas', 'Aventura'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Maddy Makes Games', score: 91, badge: 'Joyita indie', art: 'celeste', glyph: '▲', description: 'Acompaña a Madeline hasta la cima de una montaña en un viaje de precisión, perseverancia y descubrimiento personal.' },
  { id: 'outer-wilds', title: 'Outer Wilds', year: 2019, genres: ['Exploración', 'Aventura'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Mobius Digital', score: 95, badge: 'Por descubrir', art: 'outer', glyph: '☼', description: 'Explora un pequeño sistema solar atrapado en un bucle temporal y une las pistas de una antigua civilización.' },
  { id: 'disco-elysium', title: 'Disco Elysium', year: 2019, genres: ['RPG', 'Narrativa'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'ZA/UM', score: 94, badge: 'Narrativa', art: 'disco', glyph: '◎', description: 'Investiga un crimen en una ciudad en ruinas mientras tus propias habilidades discuten cada decisión.' },
  { id: 'portal-2', title: 'Portal 2', year: 2011, genres: ['Puzles', 'Aventura'], platforms: ['PC', 'PlayStation', 'Xbox'], studio: 'Valve', score: 95, badge: 'Clásico', art: 'portal', glyph: '◌', description: 'Resuelve rompecabezas espaciales con portales en laboratorios repletos de humor e ingenio.' },
  { id: 'tunic', title: 'Tunic', year: 2022, genres: ['Aventura', 'Acción'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Isometricorp Games', score: 89, badge: 'Por descubrir', art: 'tunic', glyph: '◇', description: 'Explora una tierra misteriosa, reconstruye un manual perdido y descubre los secretos que se esconden a simple vista.' },
  { id: 'slay-the-spire', title: 'Slay the Spire', year: 2019, genres: ['Estrategia', 'Roguelike'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox', 'Móvil'], studio: 'Mega Crit', score: 90, badge: 'Una partida más', art: 'spire', glyph: '♠', description: 'Construye un mazo diferente en cada ascenso y encuentra nuevas combinaciones para llegar a la cima.' },
  { id: 'sea-of-stars', title: 'Sea of Stars', year: 2023, genres: ['RPG', 'Aventura'], platforms: ['PC', 'Switch', 'PlayStation', 'Xbox'], studio: 'Sabotage Studio', score: 88, badge: 'Joyita indie', art: 'sea', glyph: '✧', description: 'Una aventura por turnos inspirada en los clásicos, con islas coloridas y una historia de amistad.' }
];

const steamAppIds = {
  'elden-ring': 1245620, 'hollow-knight': 367520, hades: 1145360,
  'stardew-valley': 413150, 'baldurs-gate-3': 1086940, celeste: 504230,
  'outer-wilds': 753640, 'disco-elysium': 632470, 'portal-2': 620,
  tunic: 553420, 'slay-the-spire': 646570, 'sea-of-stars': 1244090
};

export const games = catalog.map(game => ({ ...game, steamAppId: steamAppIds[game.id] }));

export const genres = ['Todos', 'RPG', 'Acción', 'Aventura', 'Estrategia', 'Roguelike', 'Exploración', 'Plataformas', 'Simulación', 'Puzles'];

export function filterGames(items, { query = '', genre = 'Todos', sort = 'featured', library = null } = {}) {
  const normalizedQuery = query.trim().toLocaleLowerCase('es');
  const matches = items.filter(game => {
    const haystack = [game.title, game.studio, ...game.genres, ...game.platforms].join(' ').toLocaleLowerCase('es');
    return (!normalizedQuery || haystack.includes(normalizedQuery)) &&
      (genre === 'Todos' || game.genres.includes(genre)) &&
      (!library || library.includes(game.id));
  });
  if (sort === 'score') return matches.sort((a, b) => b.score - a.score || a.title.localeCompare(b.title));
  if (sort === 'newest') return matches.sort((a, b) => b.year - a.year || a.title.localeCompare(b.title));
  if (sort === 'az') return matches.sort((a, b) => a.title.localeCompare(b.title));
  return matches;
}
