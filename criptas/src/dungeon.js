// Gerador procedural de masmorras (salas, corredores A*, piscinas, pilares, tochas, objetos,
// inimigos e locais para missoes) e o mapa do Refugio.
import { RNG, hash2, vnoise } from './util.js';
import { THEMES } from './themes.js';

export const C = { VOID: 0, FLOOR: 1, WALL: 2, PIT: 3, LAVA: 4, WATER: 5, PILLAR: 6 };
const SOLID_PROPS = new Set(['barrel', 'crate', 'coffin', 'crystal', 'cart', 'anvil', 'stalagmite', 'rock', 'icespike', 'deadtree', 'obelisk', 'frozenbody']);

class Heap {
  constructor() { this.a = []; }
  push(k, p) { const a = this.a; a.push([k, p]); let i = a.length - 1; while (i > 0) { const j = (i - 1) >> 1; if (a[j][1] <= a[i][1]) break; [a[i], a[j]] = [a[j], a[i]]; i = j; } }
  pop() {
    const a = this.a; const top = a[0]; const last = a.pop();
    if (a.length) { a[0] = last; let i = 0; for (;;) { const l = i * 2 + 1, r = l + 1; let m = i; if (l < a.length && a[l][1] < a[m][1]) m = l; if (r < a.length && a[r][1] < a[m][1]) m = r; if (m === i) break; [a[i], a[m]] = [a[m], a[i]]; i = m; } }
    return top[0];
  }
  get size() { return this.a.length; }
}

function weighted(list, r) {
  let tot = 0; for (const [, w] of list) tot += w;
  r *= tot;
  for (const [v, w] of list) { r -= w; if (r <= 0) return v; }
  return list[0][0];
}

function base(W, D) {
  const N = W * D;
  return {
    W, D, N, idx: (x, z) => x + z * W, inb: (x, z) => x >= 0 && z >= 0 && x < W && z < D,
    cell: new Uint8Array(N), h: new Int8Array(N), mat: new Array(N).fill(null), room: new Int16Array(N).fill(-1),
    corr: new Uint8Array(N), solid: new Uint8Array(N), thin: new Uint8Array(N), wallH: new Uint8Array(N),
  };
}

// paredes em volta, materiais, tochas, estandartes e teias (comum a masmorras e ao Refugio)
function dress(d, theme, seed, rng) {
  const { W, D, cell, h, mat, wallH, corr, solid, room, idx, inb } = d;
  const open = (x, z) => { if (!inb(x, z)) return false; const c = cell[idx(x, z)]; return c !== C.VOID && c !== C.WALL; };
  for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) {
    if (cell[idx(x, z)] !== C.VOID) continue;
    let adj = false;
    for (let dz = -1; dz <= 1 && !adj; dz++) for (let dx = -1; dx <= 1; dx++) if (open(x + dx, z + dz)) { adj = true; break; }
    if (adj) cell[idx(x, z)] = C.WALL;
  }
  for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) {
    const i = idx(x, z);
    if (cell[i] === C.WALL) wallH[i] = (open(x - 1, z) || open(x, z - 1) || open(x - 1, z - 1)) ? 2 : 4;
    if (cell[i] === C.PILLAR) wallH[i] = 4;
  }
  const patch = (x, z, s) => vnoise(x * 0.17, z * 0.17, seed + s, 4096, 4096) * 0.8 + hash2(x, z, seed + s) * 0.2;
  for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) {
    const i = idx(x, z);
    if (cell[i] === C.FLOOR && !mat[i]) {
      if (corr[i]) mat[i] = patch(x, z, 1) < 0.62 ? theme.corridor : weighted(theme.floor, patch(z, x, 2));
      else mat[i] = weighted(theme.floor, patch(x, z, 2));
    }
    if (cell[i] === C.WALL) mat[i] = weighted(theme.walls, patch(x, z, 3));
    if (cell[i] === C.PILLAR) mat[i] = theme.pillar;
  }
  const torches = [];
  const tooClose = (list, x, z, dd) => list.some(t => Math.hypot(t.cx - x, t.cz - z) < dd);
  for (let z = 1; z < D - 1; z++) for (let x = 1; x < W - 1; x++) {
    const i = idx(x, z);
    if (cell[i] !== C.WALL || wallH[i] !== 4) continue;
    for (const [nx, nz] of [[1, 0], [0, 1]]) {
      const j = idx(x + nx, z + nz);
      if (cell[j] !== C.FLOOR || solid[j]) continue;
      if (hash2(x, z, seed + 9) < 0.35 || tooClose(torches, x, z, 6)) continue;
      torches.push({ cx: x, cz: z, x: x + 0.5 + nx * 0.62, y: h[j] + 2.1, z: z + 0.5 + nz * 0.62, nx, nz });
      break;
    }
  }
  const banners = [];
  if (theme.props.includes('banner') || theme.hub) {
    for (let z = 1; z < D - 1; z++) for (let x = 1; x < W - 1; x++) {
      const i = idx(x, z);
      if (cell[i] !== C.WALL || wallH[i] !== 4 || corr[i]) continue;
      for (const [nx, nz] of [[1, 0], [0, 1]]) {
        const j = idx(x + nx, z + nz);
        if (cell[j] !== C.FLOOR || corr[j] || room[j] < 0) continue;
        if (hash2(x, z, seed + 19) < 0.8 || tooClose(torches, x, z, 2) || tooClose(banners, x, z, 7)) continue;
        banners.push({ cx: x, cz: z, x: x + 0.5 + nx * 0.53, y: h[j] + 2.4, z: z + 0.5 + nz * 0.53, nx, nz });
        break;
      }
    }
  }
  const cobwebs = [];
  if (theme.props.includes('cobweb')) {
    for (let z = 1; z < D - 1; z++) for (let x = 1; x < W - 1; x++) {
      const i = idx(x, z);
      if (cell[i] !== C.FLOOR || solid[i]) continue;
      const a = idx(x - 1, z), b = idx(x, z - 1);
      if ((cell[a] === C.WALL && wallH[a] === 4) && (cell[b] === C.WALL && wallH[b] === 4) && hash2(x, z, seed + 29) < 0.55) cobwebs.push({ x, z, y: h[i] });
    }
  }
  const pillars = [];
  for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) if (cell[idx(x, z)] === C.PILLAR) pillars.push({ x: x + 0.5, z: z + 0.5, y: h[idx(x, z)] });
  void rng;
  return { torches, banners, cobwebs, pillars };
}

export function generateDungeon(seed, level, themeKey) {
  for (let attempt = 0; attempt < 24; attempt++) {
    const d = tryGenerate(seed + attempt * 7919, level, themeKey);
    if (d) return d;
  }
  throw new Error('falha ao gerar masmorra');
}

function tryGenerate(seed, level, themeKey) {
  const rng = new RNG(seed);
  const theme = THEMES[themeKey];
  const W = 140, D = 140;
  const d = base(W, D);
  const { N, idx, inb, cell, h, mat, room, corr, solid, thin } = d;

  const rooms = [];
  const place = (w, dd) => {
    for (let t = 0; t < 400; t++) {
      const x = rng.int(3, W - w - 4), z = rng.int(3, D - dd - 4);
      let ok = true;
      for (const r of rooms) if (x < r.x + r.w + 5 && x + w + 5 > r.x && z < r.z + r.d + 5 && z + dd + 5 > r.z) { ok = false; break; }
      if (ok) { const r = { x, z, w, d: dd, cx: x + w / 2, cz: z + dd / 2, type: 'normal', id: rooms.length }; rooms.push(r); return r; }
    }
    return null;
  };
  const boss = place(22, 22);
  boss.type = 'boss';
  for (let t = 0; t < 260 && rooms.length < 22; t++) place(rng.int(8, 16), rng.int(8, 16));
  if (rooms.length < 14) return null;
  for (const r of rooms) for (let z = r.z; z < r.z + r.d; z++) for (let x = r.x; x < r.x + r.w; x++) { cell[idx(x, z)] = C.FLOOR; room[idx(x, z)] = r.id; }
  // cantos irregulares nas salas comuns (menos cara de caixa)
  for (const r of rooms) {
    if (r.type === 'boss') continue;
    for (const [cx, cz, sx, sz] of [[r.x, r.z, 1, 1], [r.x + r.w - 1, r.z, -1, 1], [r.x, r.z + r.d - 1, 1, -1], [r.x + r.w - 1, r.z + r.d - 1, -1, -1]]) {
      const k = rng.int(0, 2);
      for (let a = 0; a < k; a++) for (let b = 0; b < k - a; b++) { const i = idx(cx + sx * a, cz + sz * b); cell[i] = C.VOID; room[i] = -1; }
    }
  }

  const others = rooms.filter(r => r !== boss);
  const rd = (a, b) => Math.hypot(a.cx - b.cx, a.cz - b.cz);
  let start = others[0];
  for (const r of others) if (rd(r, boss) > rd(start, boss)) start = r;
  start.type = 'start';

  const edges = [];
  const inTree = new Set([start]);
  while (inTree.size < others.length) {
    let best = null, bd = 1e9;
    for (const a of inTree) for (const b of others) if (!inTree.has(b)) { const dd = rd(a, b); if (dd < bd) { bd = dd; best = [a, b]; } }
    inTree.add(best[1]); edges.push(best);
  }
  for (let i = 0; i < others.length; i++) for (let j = i + 1; j < others.length; j++) {
    const a = others[i], b = others[j];
    if (rd(a, b) < 30 && !edges.some(e => (e[0] === a && e[1] === b) || (e[0] === b && e[1] === a)) && rng.chance(0.2)) edges.push([a, b]);
  }

  const bossPad = 3;
  const inBossPad = (x, z) => x >= boss.x - bossPad && x < boss.x + boss.w + bossPad && z >= boss.z - bossPad && z < boss.z + boss.d + bossPad;
  const astar = (sx, sz, tx, tz, avoidBoss) => {
    const g = new Float32Array(N).fill(1e9), came = new Int32Array(N).fill(-1), dir = new Int8Array(N).fill(-1);
    const heap = new Heap();
    const s = idx(sx, sz), goal = idx(tx, tz);
    g[s] = 0; heap.push(s, 0);
    const DX = [1, -1, 0, 0], DZ = [0, 0, 1, -1];
    while (heap.size) {
      const c = heap.pop();
      if (c === goal) break;
      const cx = c % W, cz = (c / W) | 0;
      for (let k = 0; k < 4; k++) {
        const nx = cx + DX[k], nz = cz + DZ[k];
        if (nx < 3 || nz < 3 || nx > W - 4 || nz > D - 4) continue;
        if (avoidBoss && inBossPad(nx, nz)) continue;
        const n = idx(nx, nz);
        let cost = cell[n] === C.FLOOR ? 0.6 : 1;
        if (dir[c] !== -1 && dir[c] !== k) cost += 2.5;
        const ng = g[c] + cost;
        if (ng < g[n]) { g[n] = ng; came[n] = c; dir[n] = k; heap.push(n, ng + Math.abs(nx - tx) + Math.abs(nz - tz)); }
      }
    }
    const path = [];
    let c = goal;
    if (came[c] === -1 && c !== s) return null;
    while (c !== -1) { path.push(c); if (c === s) break; c = came[c]; }
    return path;
  };
  const carve = (path) => {
    for (const p of path) {
      const px = p % W, pz = (p / W) | 0;
      for (let dz = -1; dz <= 1; dz++) for (let dx = -1; dx <= 1; dx++) {
        const i = idx(px + dx, pz + dz);
        if (cell[i] === C.VOID) { cell[i] = C.FLOOR; corr[i] = 1; }
      }
    }
  };
  for (const [a, b] of edges) {
    const p = astar(Math.floor(a.cx), Math.floor(a.cz), Math.floor(b.cx), Math.floor(b.cz), true);
    if (!p) return null;
    carve(p);
  }
  let near = others[0];
  for (const r of others) if (r !== start && rd(r, boss) < rd(near, boss)) near = r;
  const bp = astar(Math.floor(near.cx), Math.floor(near.cz), Math.floor(boss.cx), Math.floor(boss.cz), false);
  if (!bp) return null;
  carve(bp);

  const gates = [];
  for (let z = boss.z - 1; z <= boss.z + boss.d; z++) for (let x = boss.x - 1; x <= boss.x + boss.w; x++) {
    const ring = x === boss.x - 1 || x === boss.x + boss.w || z === boss.z - 1 || z === boss.z + boss.d;
    if (ring && cell[idx(x, z)] === C.FLOOR) gates.push({ x, z });
  }
  if (gates.length === 0 || gates.length > 8) return null;

  const pool = others.filter(r => r !== start);
  const braziers = [], bRooms = [];
  for (let k = 0; k < 3; k++) {
    let best = null, bs = -1;
    for (const r of pool) {
      if (r.type !== 'normal') continue;
      let s = rd(r, start) * 0.6;
      for (const o of bRooms) s = Math.min(s, rd(r, o));
      s += rng.range(0, 4);
      if (s > bs) { bs = s; best = r; }
    }
    if (!best) return null;
    best.type = 'brazier'; bRooms.push(best);
  }
  const rest = pool.filter(r => r.type === 'normal');
  if (rest.length) rest.sort((a, b) => b.w * b.d - a.w * a.d)[0].type = 'treasure';
  const rest2 = pool.filter(r => r.type === 'normal');
  if (rest2.length >= 2) rng.pick(rest2).type = 'altar';

  const nearCorr = (x, z, r) => { for (let dz = -r; dz <= r; dz++) for (let dx = -r; dx <= r; dx++) { const i = idx(x + dx, z + dz); if (inb(x + dx, z + dz) && corr[i]) return true; } return false; };
  const setPillar = (x, z) => { const i = idx(x, z); if (cell[i] === C.FLOOR && !nearCorr(x, z, 2)) { cell[i] = C.PILLAR; solid[i] = 1; } };
  const pk = theme.pool;
  const poolType = pk === 'lava' ? C.LAVA : (pk === 'water' || pk === 'swamp') ? C.WATER : pk === 'ice' ? C.FLOOR : C.PIT;
  const setPool = (i) => { if (pk === 'ice') { cell[i] = C.FLOOR; mat[i] = 'ice'; } else cell[i] = poolType; };

  const entities = { chests: [], pots: [], altar: null, spawns: [] };
  const props = [];
  const centerOf = (r) => ({ x: Math.floor(r.cx), z: Math.floor(r.cz) });

  for (const r of rooms) {
    if (r.type === 'boss') {
      for (let z = r.z + 3; z < r.z + r.d - 3; z += 4) { setPillar(r.x + 3, z); setPillar(r.x + r.w - 4, z); }
      for (let x = r.x + 7; x < r.x + r.w - 7; x += 4) { setPillar(x, r.z + 3); setPillar(x, r.z + r.d - 4); }
      if (poolType !== C.WATER && pk !== 'ice') {
        for (const [ox, oz] of [[1, 1], [r.w - 3, 1], [1, r.d - 3], [r.w - 3, r.d - 3]])
          for (let dz = 0; dz < 2; dz++) for (let dx = 0; dx < 2; dx++) { const x = r.x + ox + dx, z = r.z + oz + dz; if (!nearCorr(x, z, 2)) setPool(idx(x, z)); }
      }
      continue;
    }
    if (r.type === 'start') continue;
    const big = r.w >= 11 && r.d >= 11;
    const special = r.type === 'brazier' || r.type === 'treasure' || r.type === 'altar';
    if (special || (!big && rng.chance(0.3))) {
      const ix = Math.min(3, Math.floor(r.w / 3)), iz = Math.min(3, Math.floor(r.d / 3));
      for (let z = r.z + iz; z < r.z + r.d - iz; z++) for (let x = r.x + ix; x < r.x + r.w - ix; x++) {
        const i = idx(x, z); if (cell[i] === C.FLOOR) { h[i] = 1; mat[i] = theme.raised; }
      }
    } else if (big && rng.chance(pk === 'swamp' ? 0.8 : 0.55)) {
      // lago de formato organico
      const cx = r.cx, cz = r.cz, rx = r.w / 2 - 2.5, rz = r.d / 2 - 2.5;
      for (let z = r.z + 2; z < r.z + r.d - 2; z++) for (let x = r.x + 2; x < r.x + r.w - 2; x++) {
        const nx = (x + 0.5 - cx) / rx, nz = (z + 0.5 - cz) / rz;
        const n = vnoise(x * 0.3, z * 0.3, seed + 71, 4096, 4096) * 0.5;
        if (nx * nx + nz * nz < 0.75 + n) setPool(idx(x, z));
      }
      if (pk !== 'ice' && (poolType !== C.WATER || rng.chance(0.5))) {
        const horiz = r.w >= r.d;
        const mid = horiz ? Math.floor(r.cz) : Math.floor(r.cx);
        for (let a = 0; a < 2; a++) {
          if (horiz) for (let x = r.x + 1; x < r.x + r.w - 1; x++) { const i = idx(x, mid - 1 + a); if (cell[i] !== C.FLOOR) { cell[i] = C.FLOOR; thin[i] = 1; mat[i] = theme.bridge; } }
          else for (let z = r.z + 1; z < r.z + r.d - 1; z++) { const i = idx(mid - 1 + a, z); if (cell[i] !== C.FLOOR) { cell[i] = C.FLOOR; thin[i] = 1; mat[i] = theme.bridge; } }
        }
      }
    } else if (big) {
      for (let z = r.z + 2; z < r.z + r.d - 2; z += 3) { setPillar(r.x + 2, z); setPillar(r.x + r.w - 3, z); }
    }
    const c = centerOf(r);
    if (r.type === 'brazier') braziers.push({ x: c.x + 0.5, z: c.z + 0.5 });
    if (r.type === 'treasure') entities.chests.push({ x: c.x + 0.5, z: c.z + 0.5, big: true });
    if (r.type === 'altar') entities.altar = { x: c.x + 0.5, z: c.z + 0.5 };
  }
  // pantano: pocas rasas espalhadas pelo chao
  if (pk === 'swamp') {
    for (let z = 2; z < D - 2; z++) for (let x = 2; x < W - 2; x++) {
      const i = idx(x, z);
      if (cell[i] !== C.FLOOR || h[i] || thin[i] || inBossPad(x, z)) continue;
      if (vnoise(x * 0.21, z * 0.21, seed + 91, 4096, 4096) > 0.72) cell[i] = C.WATER;
    }
  }
  for (const b of braziers) solid[idx(Math.floor(b.x), Math.floor(b.z))] = 1;
  for (const ch of entities.chests) solid[idx(Math.floor(ch.x), Math.floor(ch.z))] = 1;
  if (entities.altar) solid[idx(Math.floor(entities.altar.x), Math.floor(entities.altar.z))] = 1;

  const deco = dress(d, theme, seed, rng);
  const lightsExtra = [];

  const free = (x, z) => { const i = idx(x, z); return cell[i] === C.FLOOR && !solid[i] && !thin[i] && !corr[i]; };
  for (const r of rooms) {
    if (r.type === 'boss') continue;
    const n = Math.floor((r.w * r.d) / 14);
    for (let k = 0; k < n; k++) {
      let x, z;
      const side = rng.int(0, 3);
      if (side === 0) { x = r.x; z = rng.int(r.z, r.z + r.d - 1); }
      else if (side === 1) { x = r.x + r.w - 1; z = rng.int(r.z, r.z + r.d - 1); }
      else if (side === 2) { z = r.z; x = rng.int(r.x, r.x + r.w - 1); }
      else { z = r.z + r.d - 1; x = rng.int(r.x, r.x + r.w - 1); }
      if (rng.chance(0.25)) { x = rng.int(r.x + 1, r.x + r.w - 2); z = rng.int(r.z + 1, r.z + r.d - 2); }
      if (!free(x, z) || nearCorr(x, z, 2)) continue;
      const type = rng.pick(theme.props);
      if (type === 'banner' || type === 'cobweb' || type === 'chains' || type === 'beam' || type === 'lily') continue;
      if (type === 'pot') { entities.pots.push({ x: x + 0.5, z: z + 0.5 }); solid[idx(x, z)] = 2; continue; }
      if (r.type === 'start' && SOLID_PROPS.has(type) && rng.chance(0.5)) continue;
      props.push({ type, x: x + 0.5, z: z + 0.5, y: h[idx(x, z)], rot: rng.range(0, Math.PI * 2), s: rng.range(0.85, 1.15), seed: rng.int(0, 1e6) });
      solid[idx(x, z)] = SOLID_PROPS.has(type) ? 1 : 2;
    }
    if (r.type === 'normal' && rng.chance(0.3)) {
      const x = rng.chance(0.5) ? r.x + 1 : r.x + r.w - 2, z = rng.chance(0.5) ? r.z + 1 : r.z + r.d - 2;
      if (free(x, z) && !nearCorr(x, z, 2)) { entities.chests.push({ x: x + 0.5, z: z + 0.5, big: false }); solid[idx(x, z)] = 1; }
    }
    for (let k = 0; k < 2; k++) {
      const x = rng.int(r.x, r.x + r.w - 1), z = rng.int(r.z, r.z + r.d - 1);
      if (free(x, z) && !nearCorr(x, z, 1)) { entities.pots.push({ x: x + 0.5, z: z + 0.5 }); solid[idx(x, z)] = 2; }
    }
  }
  if (theme.props.includes('lily')) for (let z = 1; z < D - 1; z++) for (let x = 1; x < W - 1; x++) {
    const i = idx(x, z);
    if (cell[i] === C.WATER && hash2(x, z, seed + 41) < 0.12) props.push({ type: 'lily', x: x + 0.3 + hash2(z, x, 3) * 0.4, z: z + 0.3 + hash2(x, z, 4) * 0.4, y: -0.3, rot: hash2(x, z, 5) * 6.28, s: 0.8 + hash2(x, z, 6) * 0.5 });
    else if (cell[i] === C.FLOOR && !solid[i] && !corr[i] && hash2(x, z, seed + 43) < 0.25 && [[1, 0], [-1, 0], [0, 1], [0, -1]].some(([a, b]) => cell[idx(x + a, z + b)] === C.WATER)) { props.push({ type: 'reeds', x: x + 0.5, z: z + 0.5, y: h[i], rot: hash2(x, z, 7) * 6.28, s: 0.8 + hash2(x, z, 8) * 0.4 }); solid[i] = 2; }
  }
  for (const p of props) if (p.type === 'crystal' || p.type === 'floatcrystal') lightsExtra.push({ x: p.x, y: p.y + 0.9, z: p.z, color: theme.dimension ? 0xb070ff : 0x5fd8ff, intensity: 3, dist: 6 });
  for (const p of props) if (p.type === 'mushroom') lightsExtra.push({ x: p.x, y: p.y + 0.6, z: p.z, color: 0x9ae8b0, intensity: 1.2, dist: 4 });

  const walkableCell = (x, z) => { const c = cell[idx(x, z)]; return (c === C.FLOOR || c === C.WATER) && solid[idx(x, z)] !== 1; };
  for (const r of rooms) {
    if (r.type === 'start' || r.type === 'boss') continue;
    const packs = r.type === 'treasure' ? 2 : 1 + (r.w * r.d > 150 ? 1 : 0);
    for (let pp = 0; pp < packs; pp++) {
      const count = Math.min(8, rng.int(2, 4) + Math.floor((level - 1) * 0.6));
      const px = rng.int(r.x + 1, r.x + r.w - 2), pz = rng.int(r.z + 1, r.z + r.d - 2);
      for (let k = 0; k < count; k++) {
        for (let t = 0; t < 12; t++) {
          const x = px + rng.int(-2, 2), z = pz + rng.int(-2, 2);
          if (x >= r.x && z >= r.z && x < r.x + r.w && z < r.z + r.d && walkableCell(x, z)) { entities.spawns.push({ type: rng.weighted(theme.enemies), x: x + rng.range(0.3, 0.7), z: z + rng.range(0.3, 0.7) }); break; }
        }
      }
    }
  }
  for (let t = 0; t < 45; t++) {
    const x = rng.int(3, W - 4), z = rng.int(3, D - 4);
    const i = idx(x, z);
    if (corr[i] && walkableCell(x, z) && Math.hypot(x - start.cx, z - start.cz) > 18 && !inBossPad(x, z) && rng.chance(0.4))
      entities.spawns.push({ type: rng.weighted(theme.enemies), x: x + 0.5, z: z + 0.5 });
  }

  const reach = new Uint8Array(N);
  const q = [idx(Math.floor(start.cx), Math.floor(start.cz))];
  if (!walkableCell(q[0] % W, (q[0] / W) | 0)) return null;
  reach[q[0]] = 1;
  while (q.length) {
    const c = q.pop(); const cx = c % W, cz = (c / W) | 0;
    for (const [dx, dz] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
      const nx = cx + dx, nz = cz + dz; const n = idx(nx, nz);
      if (!inb(nx, nz) || reach[n] || !walkableCell(nx, nz) || Math.abs(h[n] - h[c]) > 1) continue;
      reach[n] = 1; q.push(n);
    }
  }
  const adjReach = (x, z) => { for (const [dx, dz] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) if (reach[idx(x + dx, z + dz)]) return true; return false; };
  for (const b of braziers) if (!adjReach(Math.floor(b.x), Math.floor(b.z))) return null;
  if (!gates.some(g => reach[idx(g.x, g.z)])) return null;
  for (const ch of entities.chests) if (!adjReach(Math.floor(ch.x), Math.floor(ch.z))) { solid[idx(Math.floor(ch.x), Math.floor(ch.z))] = 0; ch.dead = true; }
  entities.chests = entities.chests.filter(c => !c.dead);
  if (entities.altar && !adjReach(Math.floor(entities.altar.x), Math.floor(entities.altar.z))) entities.altar = null;
  entities.spawns = entities.spawns.filter(s => reach[idx(Math.floor(s.x), Math.floor(s.z))]);

  // locais para objetos de missao (reliquia, prisioneiro)
  const spots = [];
  for (const r of rng.shuffle ? rng.shuffle(others.slice()) : others) {
    if (r.type !== 'normal') continue;
    for (let t = 0; t < 20; t++) {
      const x = rng.int(r.x + 1, r.x + r.w - 2), z = rng.int(r.z + 1, r.z + r.d - 2), i = idx(x, z);
      if (reach[i] && free(x, z) && !nearCorr(x, z, 1)) { spots.push({ x: x + 0.5, z: z + 0.5, room: r.id }); break; }
    }
  }

  return {
    ...d, seed, level, themeKey, theme, rooms, boss, start,
    gates, braziers, ...deco, props, lightsExtra, ...entities, spots,
  };
}

// ---------------- Refugio ----------------
export function generateHub(seed) {
  const theme = THEMES.refugio;
  const rng = new RNG(seed);
  const W = 52, D = 52;
  const d = base(W, D);
  const { idx, cell, h, mat, room, solid } = d;
  const cx = 26, cz = 26;
  for (let z = 4; z < D - 4; z++) for (let x = 4; x < W - 4; x++) {
    const dx = (x + 0.5 - cx) / 19, dz = (z + 0.5 - cz) / 18;
    const n = vnoise(x * 0.25, z * 0.25, seed, 4096, 4096) * 0.35;
    if (dx * dx + dz * dz < 0.9 + n) { cell[idx(x, z)] = C.FLOOR; room[idx(x, z)] = 0; }
  }
  // tablado de madeira ao redor da fogueira
  for (let z = cz - 3; z <= cz + 3; z++) for (let x = cx - 3; x <= cx + 3; x++) if (Math.hypot(x + 0.5 - cx, z + 0.5 - cz) < 3.4) mat[idx(x, z)] = 'cobble';
  // lago
  for (let z = cz + 8; z < cz + 13; z++) for (let x = cx - 5; x < cx + 5; x++) {
    const dx = (x + 0.5 - cx) / 5, dz = (z + 0.5 - (cz + 10.5)) / 2.6;
    if (dx * dx + dz * dz < 1) cell[idx(x, z)] = C.WATER;
  }
  // plataformas elevadas das lojas
  const plat = (x0, z0, w, dd, m) => { for (let z = z0; z < z0 + dd; z++) for (let x = x0; x < x0 + w; x++) { const i = idx(x, z); if (cell[i] === C.FLOOR) { h[i] = 1; mat[i] = m; } } };
  plat(cx - 13, cz - 9, 6, 5, 'planks');
  plat(cx + 7, cz - 9, 6, 5, 'polished');
  const P = (type, x, z, rot = 0, s = 1) => { const i = idx(Math.floor(x), Math.floor(z)); return { type, x, z, y: h[i], rot, s, seed: rng.int(0, 1e6) }; };
  const props = [
    P('tent', cx - 10, cz - 10.2, 0, 1.1), P('tent', cx + 10, cz - 10.2, 0, 1.1),
    P('crate', cx - 12.5, cz - 5.8, 0.3), P('barrel', cx - 7.6, cz - 5.6, 0), P('crate', cx - 13.2, cz - 7.8, 1.1),
    P('anvil', cx + 8.5, cz - 6.2, 0.2), P('forge', cx + 11.5, cz - 7.5, 0), P('barrel', cx + 7.5, cz - 8.8, 0),
    P('board', cx, cz - 12.5, 0, 1), P('bench', cx - 3.2, cz + 3.6, 0.6), P('bench', cx + 3.2, cz + 3.6, -0.6),
    P('bedroll', cx - 14, cz + 2, 1.2), P('bedroll', cx - 13, cz + 5.5, 1.6), P('barrel', cx + 15, cz + 3, 0), P('crate', cx + 14.6, cz + 5, 0.5),
    P('rock', cx - 16, cz - 2, 0, 1.4), P('rock', cx + 16.5, cz - 1, 1, 1.2), P('reeds', cx - 5.5, cz + 10.5, 0), P('reeds', cx + 5.3, cz + 11, 1),
    P('mushroom', cx - 15, cz + 9, 0), P('mushroom', cx + 15.5, cz + 8, 1), P('candles', cx - 1.5, cz - 12, 0), P('banner', cx, cz, 0),
  ].filter(p => p.type !== 'banner');
  for (const p of props) if (['crate', 'barrel', 'anvil', 'forge', 'board', 'rock', 'tent'].includes(p.type)) {
    const r = p.type === 'tent' ? 2 : p.type === 'board' ? 1 : 0;
    for (let dz = -r; dz <= r; dz++) for (let dx = -r; dx <= r; dx++) { if (p.type === 'tent' && dz > 0) continue; solid[idx(Math.floor(p.x) + dx, Math.floor(p.z) + dz)] = 1; }
  }
  const hubObj = {
    campfire: { x: cx + 0.5, z: cz + 0.5 },
    board: { x: cx + 0.5, z: cz - 11.8 },
    stall: { x: cx - 9.5, z: cz - 6.6 },
    forge: { x: cx + 10.5, z: cz - 6.6 },
    dimPortal: { x: cx - 11.5, z: cz + 3.5 },
    descent: { x: cx + 11.5, z: cz + 3.5 },
  };
  solid[idx(cx, cz)] = 1;
  for (const k of ['dimPortal', 'descent']) { const o = hubObj[k]; for (let dx = -1; dx <= 1; dx++) solid[idx(Math.floor(o.x) + dx, Math.floor(o.z) - 1)] = 1; }
  const npcs = [
    { kind: 'mercadora', x: cx - 9.5, z: cz - 7.6, rot: 0, role: 'shop', name: 'Ilsa, a Mercadora' },
    { kind: 'ferreiro', x: cx + 10.5, z: cz - 7.6, rot: 0, role: 'smith', name: 'Brom, o Ferreiro' },
    { kind: 'escriba', x: cx - 1.8, z: cz - 10.6, rot: 0.3, role: 'quests', name: 'Oren, o Escriba' },
  ];
  for (const n of npcs) solid[idx(Math.floor(n.x), Math.floor(n.z))] = 1;
  const deco = dress(d, theme, seed, rng);
  return {
    ...d, seed, level: 1, themeKey: 'refugio', theme, hub: true, rooms: [{ x: 4, z: 4, w: W - 8, d: D - 8, cx, cz, type: 'hub', id: 0 }],
    boss: null, start: { cx: cx + 0.5, cz: cz + 5.5 }, gates: [], braziers: [], ...deco, props, lightsExtra: [
      { x: cx + 0.5, y: 1.2, z: cz + 0.5, color: 0xff9a40, intensity: 26, dist: 16 },
    ], chests: [], pots: [], altar: null, spawns: [], spots: [], npcs, hubObj,
  };
}
