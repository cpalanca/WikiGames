# WikiGames

Monorepo para una wiki y base de datos de videojuegos. La web funciona sin instalar dependencias; el catálogo vive en un paquete separado y los juegos incluidos son datos de ejemplo editables.

## Estructura

- `apps/web`: interfaz web, servidor local, inventario SQLite, conexión con Steam y compilación estática.
- `packages/catalog`: datos, filtros y pruebas del catálogo.

## Uso

Requiere Node.js 24.15 o superior; se usa su módulo SQLite integrado.

En Windows, ejecutar `start.cmd` desde el Explorador o desde PowerShell:

```powershell
.\start.cmd
```

Abrir `http://localhost:3000` mientras la ventana siga abierta. Esta app se sirve con Node; la URL local de Herd no arranca este monorepo.

En otros sistemas:

```bash
npm run dev
```

Para generar una versión estática en `apps/web/dist`:

```bash
npm run build
npm test
```

El servidor consulta los detalles públicos de Steam para los juegos del catálogo y guarda la respuesta en memoria durante seis horas. Sin configuración adicional, las portadas se cargan desde la CDN de Steam. Si Steam no responde, se muestran los datos de ejemplo y las portadas gráficas de reserva. SteamDB no ofrece una API pública: cada ficha incluye un enlace a su página correspondiente, sin extraer datos de SteamDB.

Para usar portadas de SteamGridDB, genera una clave en sus preferencias y arranca el servidor con `STEAMGRIDDB_API_KEY` en el entorno. En PowerShell:

```powershell
$env:STEAMGRIDDB_API_KEY = 'TU_CLAVE'
.\start.cmd
```

La clave queda en el servidor y no se envía al navegador. Se elige una imagen vertical estática de 600 × 900 píxeles; si falta o falla, se usa la portada de Steam.

La base SQLite está en `apps/web/data/wikigames.sqlite` y está excluida de Git. La tabla `library_items` guarda los favoritos y no importó el antiguo `localStorage`; la web borra esa clave al abrirse. La tabla `local_games` contiene las fichas detectadas en E: y G: (título, plataforma y ruta), sin copiar los archivos. La vista **Mis discos** permite volver a escanear y eliminar fichas. La eliminación solo afecta a SQLite; `excluded_local_games` evita que un juego eliminado reaparezca en escaneos posteriores.

Las carátulas del inventario se guardan como URL en `local_games.cover_url`. Ejecutar `npm.cmd run covers:sync` para asociarlas: primero usa las imágenes de Wii de `G:\WII\config\images`, y para Switch, Wii U y juegos Wii restantes busca por título en los índices públicos de [GameTDB](https://www.gametdb.com/) y comprueba que la imagen exista. Las imágenes de Wii se sirven desde el disco original, sin copiarlas. La sincronización requiere Internet; las portadas ya asociadas permanecen en SQLite. Eden, Yuzu y Ryujinx no tenían archivos de carátulas reutilizables en sus carpetas de caché consultadas el 2026-10-19.

En **Mis discos**, pulsar la carátula o el título abre una ficha con plataforma, ID disponible y ubicación. El enlace a GameTDB lleva a la información externa del juego. La opción discreta **Eliminar del catálogo** está al final de la ficha y pide confirmación; solo borra la fila de SQLite.

**Mis discos** permite filtrar por Switch, Wii y Wii U y por estado (favoritos, pasados y pendientes). Los botones de favorito y pasado se guardan en `local_games.is_favorite` e `is_completed`; los favoritos locales aparecen también en **Mi biblioteca**. Cada ficha muestra su carátula y permite añadir enlaces de imágenes o vídeos (YouTube, MP4 y WebM) a `local_game_media`. Quitar un enlace o una ficha no borra archivos originales.

Las fichas de los juegos destacados muestran automáticamente capturas y vídeos cuando Steam Store los incluye en su respuesta pública.

Las fichas con ports documentados en [GameWave](https://gamewave.digital/ports/) muestran los enlaces directos a sus proyectos. El servidor consulta `catalog.json` de GameWave y guarda el resultado en memoria 24 horas. Solo asocia títulos exactos normalizados de `gameNames` y omite entradas desactivadas o importaciones comunitarias sin revisión; si GameWave no responde, la web sigue funcionando sin esos enlaces.

La sección **SCENE** reúne vídeos recientes de una selección de canales de la lista facilitada por el usuario. El servidor consulta sus feeds públicos de YouTube, los ordena por fecha y guarda el resultado en memoria 20 minutos. No utiliza la cuenta personal de YouTube ni requiere clave de API.

Para repetir la importación desde la terminal, ejecutar `npm.cmd run import:local`. Se revisan carpetas de Switch en E:, paquetes de `E:\NSP`, juegos Wii en `G:\WII\wbfs` y Wii U en `G:\WII U\DATA\ALL`. También se puede pulsar **Actualizar discos** en la web. La importación inicial añadió 146 fichas. No hay cuentas; la biblioteca es única para esta instalación local.

Si se borra una fila de `local_games` directamente con SQL, un disparador añade su `game_key` a `excluded_local_games`. Para volver a importar ese juego, borrar su clave de `excluded_local_games` y ejecutar de nuevo la importación.

Las valoraciones del catálogo destacado son datos de muestra. Para añadir juegos a ese catálogo, editar `packages/catalog/src/index.js` e incluir su Steam App ID. La compilación estática muestra el catálogo de ejemplo, pero el inventario de discos, la biblioteca y la actualización desde Steam o SteamGridDB requieren el servidor Node. En PowerShell, usar `npm.cmd` para otros scripts si la política de ejecución bloquea `npm.ps1`.
