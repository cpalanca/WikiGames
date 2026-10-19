export const sceneChannels = [
  { name: 'ViZoR RetroGames', handle: 'ViZoRRetrogames', topic: 'Scene' },
  { name: 'Alucardio - Mundo Switch', handle: 'Alucardiio', topic: 'Switch' },
  { name: 'CEREBELO GAMER', handle: 'cerebelogamer', topic: 'Scene' },
  { name: 'MODDED WARFARE', handle: 'MODDEDWARFARE', topic: 'Scene' },
  { name: 'NanospeedGamer', handle: 'NanospeedGamer', topic: 'PlayStation' },
  { name: 'Mundo Yakara', handle: 'MundoYakara', topic: 'Scene' },
  { name: 'Stabb67', handle: 'Stabb67', topic: 'Scene' },
  { name: 'Patex2k', handle: 'patex2k', topic: 'Gaming' },
  { name: 'Retro Game Corps', handle: 'RetroGameCorps', topic: 'Retro' },
  { name: 'Nintendo Files', handle: 'NintendoFiles', topic: 'Switch' },
  { name: 'GAMEBit NOW', handle: 'GAMEBitNOW', topic: 'Gaming' },
  { name: 'La Caverna del Gamer', id: 'UClNSdNAqetoA97IG9zvscow', topic: 'Gaming' },
  { name: 'Nintendo España', handle: 'NintendoES', topic: 'Switch' },
  { name: 'Nintendúo', handle: 'NintenduoESP', topic: 'Switch' },
  { name: 'MadokGames', handle: 'MadokGames', topic: 'Switch' },
  { name: 'Peter D Games', handle: 'PeterDGames', topic: 'Gaming' },
  { name: 'TheWizWiki', handle: 'TheWizWiki', topic: 'Scene' },
  { name: 'TheWizWiki Gaming', handle: 'Thewizwikigaming', topic: 'Gaming' }
];

const ids = new Map();
let cached = null;
let cachedAt = 0;

function decodeXml(text) {
  return text.replace(/&(?:amp|lt|gt|quot|apos|#\d+|#x[\da-f]+);/gi, entity => {
    const known = { '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"', '&apos;': "'" };
    if (known[entity]) return known[entity];
    const value = entity.startsWith('&#x') ? parseInt(entity.slice(3), 16) : parseInt(entity.slice(2), 10);
    return Number.isFinite(value) ? String.fromCodePoint(value) : entity;
  });
}

export function parseSceneFeed(xml, channel) {
  const videos = [];
  for (const match of xml.matchAll(/<entry>([\s\S]*?)<\/entry>/g)) {
    const entry = match[1];
    const id = /<yt:videoId>([a-zA-Z0-9_-]{11})<\/yt:videoId>/.exec(entry)?.[1];
    const title = /<title>([\s\S]*?)<\/title>/.exec(entry)?.[1];
    const published = /<published>([^<]+)<\/published>/.exec(entry)?.[1];
    if (!id || !title || !published) continue;
    videos.push({ id, title: decodeXml(title), published, channel: channel.name, topic: channel.topic, url: `https://www.youtube.com/watch?v=${id}`, thumbnail: `https://i.ytimg.com/vi/${id}/hqdefault.jpg` });
  }
  return videos;
}

async function channelId(channel, request) {
  if (channel.id) return channel.id;
  if (ids.has(channel.handle)) return ids.get(channel.handle);
  const response = await request(`https://www.youtube.com/@${channel.handle}/videos?ucbcb=1`, { signal: AbortSignal.timeout(10000) });
  if (!response.ok) throw new Error(`Channel ${channel.name}: ${response.status}`);
  const html = await response.text();
  const id = /feeds\/videos\.xml\?channel_id=(UC[a-zA-Z0-9_-]{22})/.exec(html)?.[1];
  if (!id) throw new Error(`Channel ${channel.name}: no feed ID`);
  ids.set(channel.handle, id);
  return id;
}

export async function getSceneNews(request = fetch, now = Date.now()) {
  if (cached && now - cachedAt < 20 * 60 * 1000) return cached;
  const videos = [];
  const queue = [...sceneChannels];
  async function worker() {
    while (queue.length) {
      const channel = queue.shift();
      try {
        const id = await channelId(channel, request);
        const response = await request(`https://www.youtube.com/feeds/videos.xml?channel_id=${id}`, { signal: AbortSignal.timeout(10000) });
        if (!response.ok) throw new Error(`Feed ${channel.name}: ${response.status}`);
        videos.push(...parseSceneFeed(await response.text(), channel).slice(0, 3));
      } catch (error) {
        console.warn(error.message);
      }
    }
  }
  await Promise.all(Array.from({ length: 4 }, worker));
  const result = { videos: videos.sort((a, b) => b.published.localeCompare(a.published)).slice(0, 30), channels: sceneChannels.map(channel => ({ name: channel.name, topic: channel.topic, url: channel.id ? `https://www.youtube.com/channel/${channel.id}` : `https://www.youtube.com/@${channel.handle}` })), updatedAt: new Date(now).toISOString() };
  if (result.videos.length || !cached) { cached = result; cachedAt = now; }
  return cached;
}
