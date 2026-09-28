// Gerador procedural de masmorras: salas, corredores (A*), piscinas, pilares,
// paredes, tochas, objetos e pontos de surgimento de inimigos.
import { RNG, hash2, vnoise } from './util.js';
import { THEMES } from './themes.js';

export const C = { VOID: 0, FLOOR: 1, WALL: 2, PIT: 3, LAVA: 4, WATER: 5, PILLAR: 6 };
const SOLID_PROPS = new Set(['barrel', 'crate', 'coffin', 'crystal', 'cart', 'anvil']);

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

export function generateDungeon(seed, floorNum, themeKey) {
  for (let attempt = 0; attempt < 20; attempt++) {
    const d = tryGenerate(seed + attempt * 7919, floorNum, themeKey);
    if (d) return d;
  }
  throw new Error('falha ao gerar masmorra');
}

function tryGenerate(seed, floorNum, themeKey) {
  const rng = new RNG(seed);
  const theme = THEMES[themeKey];
  const W = 96, D = 96, N = W * D;
  const idx = (x, z) => x + z * W;
  const inb = (x, z) => x >= 0 && z >= 0 && x < W && z < D;
  const cell = new Uint8Array(N), h = new Int8Array(N), mat = new Array(N).fill(null);
  const room = new Int16Array(N).fill(-1), corr = new Uint8Array(N), solid = new Uint8Array(N);
  const thin = new Uint8Array(N), wallH = new Uint8Array(N);

  // ---- salas ----
  const rooms = [];
  const place = (w, d) => {
    for (let t = 0; t < 300; t++) {
      const x = rng.int(3, W - w - 4), z = rng.int(3, D - d - 4);
      let ok = true;
      for (const r of rooms) if (x < r.x + r.w + 5 && x + w + 5 > r.x && z < r.z + r.d + 5 && z + d + 5 > r.z) { ok = false; break; }
      if (ok) { const r = { x, z, w, d, cx: x + w / 2, cz: z + d / 2, type: 'normal', id: rooms.length }; rooms.push(r); return r; }
    }
    return null;
  };
  const boss = place(20, 20);
  boss.type = 'boss';
  for (let t = 0; t < 120 && rooms.length < 14; t++) place(rng.int(8, 14), rng.int(8, 14));
  if (rooms.length < 8) return null;
  for (const r of rooms) for (let z = r.z; z < r.z + r.d; z++) for (let x = r.x; x < r.x + r.w; x++) { cell[idx(x, z)] = C.FLOOR; room[idx(x, z)] = r.id; }

  const others = rooms.filter(r => r !== boss);
  const rd = (a, b) => Math.hypot(a.cx - b.cx, a.cz - b.cz);
  let start = others[0];
  for (const r of others) if (rd(r, boss) > rd(start, boss)) start = r;
  start.type = 'start';

  // ---- ligacoes (arvore geradora minima + extras) ----
  const edges = [];
  const inTree = new Set([start]);
  while (inTree.size < others.length) {
    let best = null, bd = 1e9;
    for (const a of inTree) for (const b of others) if (!inTree.has(b)) { const dd = rd(a, b); if (dd < bd) { bd = dd; best = [a, b]; } }
    inTree.add(best[1]); edges.push(best);
  }
  for (let i = 0; i < others.length; i++) for (let j = i + 1; j < others.length; j++) {
    const a = others[i], b = others[j];
    if (rd(a, b) < 28 && !edges.some(e => (e[0] === a && e[1] === b) || (e[0] === b && e[1] === a)) && rng.chance(0.22)) edges.push([a, b]);
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

  // portoes do chefe: celulas de chao no anel ao redor da sala
  const gates = [];
  for (let z = boss.z - 1; z <= boss.z + boss.d; z++) for (let x = boss.x - 1; x <= boss.x + boss.w; x++) {
    const ring = x === boss.x - 1 || x === boss.x + boss.w || z === boss.z - 1 || z === boss.z + boss.d;
    if (ring && cell[idx(x, z)] === C.FLOOR) gates.push({ x, z });
  }
  if (gates.length === 0 || gates.length > 8) return null;

  // ---- tipos de sala ----
  const pool = others.filter(r => r !== start);
  const braziers = [];
  const bRooms = [];
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

  // ---- estrutura interna das salas ----
  const nearCorr = (x, z, r) => { for (let dz = -r; dz <= r; dz++) for (let dx = -r; dx <= r; dx++) { const i = idx(x + dx, z + dz); if (inb(x + dx, z + dz) && corr[i]) return true; } return false; };
  const setPillar = (x, z) => { const i = idx(x, z); if (cell[i] === C.FLOOR && !nearCorr(x, z, 2)) { cell[i] = C.PILLAR; solid[i] = 1; } };
  const poolType = theme.pool === 'lava' ? C.LAVA : theme.pool === 'water' ? C.WATER : C.PIT;

  const entities = { chests: [], pots: [], altar: null, spawns: [] };
  const props = [];
  const centerOf = (r) => ({ x: Math.floor(r.cx), z: Math.floor(r.cz) });

  for (const r of rooms) {
    if (r.type === 'boss') {
      for (let z = r.z + 3; z < r.z + r.d - 3; z += 4) { setPillar(r.x + 3, z); setPillar(r.x + r.w - 4, z); }
      for (let x = r.x + 7; x < r.x + r.w - 7; x += 4) { setPillar(x, r.z + 3); setPillar(x, r.z + r.d - 4); }
      if (poolType !== C.WATER) {
        for (const [ox, oz] of [[1, 1], [r.w - 3, 1], [1, r.d - 3], [r.w - 3, r.d - 3]])
          for (let dz = 0; dz < 2; dz++) for (let dx = 0; dx < 2; dx++) { const x = r.x + ox + dx, z = r.z + oz + dz; if (!nearCorr(x, z, 2)) cell[idx(x, z)] = poolType; }
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
    } else if (big && rng.chance(0.55)) {
      for (let z = r.z + 3; z < r.z + r.d - 3; z++) for (let x = r.x + 3; x < r.x + r.w - 3; x++) cell[idx(x, z)] = poolType;
      if (poolType !== C.WATER || rng.chance(0.5)) {
        const horiz = r.w >= r.d;
        const mid = horiz ? Math.floor(r.cz) : Math.floor(r.cx);
        for (let a = 0; a < 2; a++) {
          if (horiz) for (let x = r.x + 3; x < r.x + r.w - 3; x++) { const i = idx(x, mid - 1 + a); cell[i] = C.FLOOR; thin[i] = 1; mat[i] = theme.bridge; }
          else for (let z = r.z + 3; z < r.z + r.d - 3; z++) { const i = idx(mid - 1 + a, z); cell[i] = C.FLOOR; thin[i] = 1; mat[i] = theme.bridge; }
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
  for (const b of braziers) solid[idx(Math.floor(b.x), Math.floor(b.z))] = 1;
  for (const ch of entities.chests) solid[idx(Math.floor(ch.x), Math.floor(ch.z))] = 1;
  if (entities.altar) solid[idx(Math.floor(entities.altar.x), Math.floor(entities.altar.z))] = 1;

  // ---- paredes ----
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

  // ---- materiais (manchas coerentes em vez de sorteio por celula) ----
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

  // ---- tochas, estandartes e teias ----
  const torches = [], lightsExtra = [];
  const tooClose = (list, x, z, d) => list.some(t => Math.hypot(t.cx - x, t.cz - z) < d);
  for (let z = 1; z < D - 1; z++) for (let x = 1; x < W - 1; x++) {
    const i = idx(x, z);
    if (cell[i] !== C.WALL || wallH[i] !== 4) continue;
    for (const [nx, nz] of [[1, 0], [0, 1]]) {
      const j = idx(x + nx, z + nz);
      if (cell[j] !== C.FLOOR || solid[j]) continue;
      if (hash2(x, z, seed + 9) < 0.35 || tooClose(torches, x, z, 6)) continue;
      const fh = h[j];
      torches.push({ cx: x, cz: z, x: x + 0.5 + nx * 0.62, y: fh + 2.1, z: z + 0.5 + nz * 0.62, nx, nz });
      break;
    }
  }
  const banners = [];
  if (theme.props.includes('banner')) {
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
      if ((cell[a] === C.WALL && wallH[a] === 4) && (cell[b] === C.WALL && wallH[b] === 4) && hash2(x, z, seed + 29) < 0.55)
        cobwebs.push({ x, z, y: h[i] });
    }
  }

  // ---- objetos espalhados ----
  const free = (x, z) => { const i = idx(x, z); return cell[i] === C.FLOOR && !solid[i] && !thin[i] && !corr[i]; };
  for (const r of rooms) {
    if (r.type === 'boss') continue;
    const n = Math.floor((r.w * r.d) / 16);
    for (let k = 0; k < n; k++) {
      // prefere as bordas da sala
      let x, z;
      const side = rng.int(0, 3);
      if (side === 0) { x = r.x; z = rng.int(r.z, r.z + r.d - 1); }
      else if (side === 1) { x = r.x + r.w - 1; z = rng.int(r.z, r.z + r.d - 1); }
      else if (side === 2) { z = r.z; x = rng.int(r.x, r.x + r.w - 1); }
      else { z = r.z + r.d - 1; x = rng.int(r.x, r.x + r.w - 1); }
      if (rng.chance(0.25)) { x = rng.int(r.x + 1, r.x + r.w - 2); z = rng.int(r.z + 1, r.z + r.d - 2); }
      if (!free(x, z) || nearCorr(x, z, 2)) continue;
      const type = rng.pick(theme.props);
      if (type === 'banner' || type === 'cobweb' || type === 'chains') continue;
      if (type === 'pot') { entities.pots.push({ x: x + 0.5, z: z + 0.5 }); solid[idx(x, z)] = 2; continue; }
      if (r.type === 'start' && SOLID_PROPS.has(type) && rng.chance(0.5)) continue;
      props.push({ type, x: x + 0.5, z: z + 0.5, y: h[idx(x, z)], rot: rng.range(0, Math.PI * 2), s: rng.range(0.85, 1.15) });
      if (SOLID_PROPS.has(type)) solid[idx(x, z)] = 1;
      else solid[idx(x, z)] = 2; // ocupado mas atravessavel
    }
    if (r.type === 'normal' && rng.chance(0.3)) {
      const x = rng.chance(0.5) ? r.x : r.x + r.w - 1, z = rng.chance(0.5) ? r.z : r.z + r.d - 1;
      if (free(x, z) && !nearCorr(x, z, 2)) { entities.chests.push({ x: x + 0.5, z: z + 0.5, big: false }); solid[idx(x, z)] = 1; }
    }
    for (let k = 0; k < 2; k++) {
      const x = rng.int(r.x, r.x + r.w - 1), z = rng.int(r.z, r.z + r.d - 1);
      if (free(x, z) && !nearCorr(x, z, 1)) { entities.pots.push({ x: x + 0.5, z: z + 0.5 }); solid[idx(x, z)] = 2; }
    }
  }
  for (const p of props) if (p.type === 'crystal') lightsExtra.push({ x: p.x, y: p.y + 0.8, z: p.z, color: 0x5fd8ff, intensity: 3, dist: 6 });

  // ---- inimigos ----
  const walkableCell = (x, z) => { const c = cell[idx(x, z)]; return (c === C.FLOOR || c === C.WATER) && solid[idx(x, z)] !== 1; };
  for (const r of rooms) {
    if (r.type === 'start' || r.type === 'boss') continue;
    const packs = r.type === 'treasure' ? 2 : 1 + (r.w * r.d > 150 ? 1 : 0);
    for (let p = 0; p < packs; p++) {
      const count = Math.min(8, rng.int(2, 4) + Math.floor((floorNum - 1) * 0.6));
      const px = rng.int(r.x + 1, r.x + r.w - 2), pz = rng.int(r.z + 1, r.z + r.d - 2);
      const list = [];
      for (let k = 0; k < count; k++) {
        for (let t = 0; t < 12; t++) {
          const x = px + rng.int(-2, 2), z = pz + rng.int(-2, 2);
          if (x >= r.x && z >= r.z && x < r.x + r.w && z < r.z + r.d && walkableCell(x, z)) { list.push({ type: rng.weighted(theme.enemies), x: x + rng.range(0.3, 0.7), z: z + rng.range(0.3, 0.7) }); break; }
        }
      }
      entities.spawns.push(...list);
    }
  }
  for (let t = 0; t < 30; t++) {
    const x = rng.int(3, W - 4), z = rng.int(3, D - 4);
    const i = idx(x, z);
    if (corr[i] && walkableCell(x, z) && Math.hypot(x - start.cx, z - start.cz) > 18 && !inBossPad(x, z) && rng.chance(0.4))
      entities.spawns.push({ type: rng.weighted(theme.enemies), x: x + 0.5, z: z + 0.5 });
  }

  // ---- verificacao de conectividade ----
  const reach = new Uint8Array(N);
  const q = [idx(Math.floor(start.cx), Math.floor(start.cz))];
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

  return {
    W, D, seed, floorNum, themeKey, theme, cell, h, mat, room, corr, solid, thin, wallH, rooms, boss, start,
    gates, braziers, torches, banners, cobwebs, props, lightsExtra, ...entities,
    idx, inb,
  };
}

function weighted(list, r) {
  let tot = 0; for (const [, w] of list) tot += w;
  r *= tot;
  for (const [v, w] of list) { r -= w; if (r <= 0) return v; }
  return list[0][0];
}
