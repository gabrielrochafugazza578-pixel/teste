// Texturas procedurais: atlas dos blocos (cor, relevo/normal, rugosidade, emissao)
// e texturas avulsas para personagens, lava, agua e particulas.
import * as THREE from 'three';
import { fbm, voronoi, hash2, vnoise, clamp, smooth, lerp, RNG } from './util.js';

const T = 64, PAD = 8, CELL = T + PAD * 2, COLS = 8;
export const TILES = {};
const defs = [];
const def = (name, gen) => { TILES[name] = defs.length; defs.push({ name, gen }); };

function mixc(o, c, t) { o.r = lerp(o.r, c[0], t); o.g = lerp(o.g, c[1], t); o.b = lerp(o.b, c[2], t); }

function makeCracks(seed, count = 3) {
  const out = new Float32Array(T * T);
  const rng = new RNG(seed);
  for (let k = 0; k < count; k++) {
    let x = rng.range(0, T), y = rng.range(0, T), a = rng.range(0, Math.PI * 2);
    const len = rng.int(18, 40);
    for (let s = 0; s < len; s++) {
      a += rng.range(-0.6, 0.6);
      x += Math.cos(a); y += Math.sin(a);
      for (let j = -1; j <= 1; j++) for (let i = -1; i <= 1; i++) {
        const px = ((Math.round(x) + i) % T + T) % T, py = ((Math.round(y) + j) % T + T) % T;
        const w = i === 0 && j === 0 ? 1 : 0.35 * (1 - s / len);
        out[py * T + px] = Math.max(out[py * T + px], w);
      }
      if (rng.chance(0.06)) a += rng.range(-1.2, 1.2);
    }
  }
  return out;
}

function brickGen(P) {
  const cracks = P.crack ? makeCracks(P.seed + 99, P.crack) : null;
  const bw = P.bw || 32, bh = P.bh || 16;
  return (u, v, o, x, y) => {
    const row = Math.floor(y / bh), off = (row % 2) * (bw / 2);
    const xx = (x + off) % T, col = Math.floor(xx / bw);
    const bx = xx - col * bw, by = y - row * bh;
    const n = fbm(u, v, P.seed, 8, 4);
    const d = Math.min(bx + 0.5, bw - bx - 0.5, by + 0.5, bh - by - 0.5) + (n - 0.5) * 2.2;
    const edge = smooth(0.6, 3.0, d);
    const hv = hash2(col, row, P.seed);
    const tone = 1 + (hv - 0.5) * P.var + (n - 0.5) * 0.4;
    const speck = hash2(x, y, P.seed + 3) < 0.05 ? 0.82 : 1;
    const m = P.mortar;
    o.r = lerp(m[0], P.base[0] * tone * speck, edge);
    o.g = lerp(m[1], P.base[1] * tone * speck, edge);
    o.b = lerp(m[2], P.base[2] * tone * speck, edge);
    const chip = fbm(u, v, P.seed + 11, 16, 2);
    o.h = 0.12 + edge * (0.62 + chip * 0.18) + (n - 0.5) * 0.2;
    o.ro = lerp(0.97, 0.78 + n * 0.15, edge);
    if (P.moss) {
      const mn = fbm(u, v, P.seed + 50, 4, 5) + (1 - edge) * 0.14 + (y / T) * 0.08;
      const mm = smooth(0.66 - P.moss * 0.2, 0.72 - P.moss * 0.2, mn);
      if (mm > 0) {
        const g2 = fbm(u, v, P.seed + 80, 16, 3);
        mixc(o, [0.15 + g2 * 0.1, 0.25 + g2 * 0.15, 0.07 + g2 * 0.04], mm);
        o.h = lerp(o.h, 0.75 + g2 * 0.2, mm); o.ro = lerp(o.ro, 1, mm);
      }
    }
    if (cracks) {
      const c = cracks[y * T + x];
      if (c > 0) { o.r *= 1 - 0.75 * c; o.g *= 1 - 0.75 * c; o.b *= 1 - 0.75 * c; o.h -= 0.55 * c; }
    }
  };
}

function slabGen(P) { // lajes irregulares (voronoi)
  return (u, v, o) => {
    const [d1, d2, id] = voronoi(u, v, P.seed, P.n, P.jit || 0.8);
    const n = fbm(u, v, P.seed + 5, 8, 4);
    const e = d2 - d1 + (n - 0.5) * 0.06;
    const edge = smooth(0.02, P.soft || 0.12, e);
    const tone = 1 + (hash2(id, 3, P.seed) - 0.5) * P.var + (n - 0.5) * 0.35;
    o.r = lerp(P.grout[0], P.base[0] * tone, edge);
    o.g = lerp(P.grout[1], P.base[1] * tone, edge);
    o.b = lerp(P.grout[2], P.base[2] * tone, edge);
    o.h = 0.1 + edge * 0.6 + (n - 0.5) * 0.2 + (P.dome ? (1 - d1 * 1.5) * P.dome : 0);
    o.ro = lerp(0.98, P.rough || 0.8, edge);
  };
}

function woodGrain(u, v, seed) {
  return vnoise(u * 3, v * 40, seed, 3, 40) * 0.6 + vnoise(u * 6, v * 90, seed + 1, 6, 90) * 0.4;
}

// ---------- definicoes dos blocos ----------
def('brick', brickGen({ seed: 11, base: [0.46, 0.45, 0.43], var: 0.3, mortar: [0.2, 0.19, 0.18] }));
def('brick_mossy', brickGen({ seed: 11, base: [0.44, 0.44, 0.4], var: 0.3, mortar: [0.18, 0.2, 0.15], moss: 1 }));
def('brick_cracked', brickGen({ seed: 12, base: [0.43, 0.42, 0.41], var: 0.35, mortar: [0.19, 0.18, 0.17], crack: 4 }));
def('flagstone', slabGen({ seed: 21, n: 3, base: [0.42, 0.4, 0.37], grout: [0.13, 0.12, 0.11], var: 0.3 }));
def('cobble', slabGen({ seed: 23, n: 6, base: [0.47, 0.46, 0.44], grout: [0.14, 0.13, 0.12], var: 0.45, dome: 0.35, soft: 0.2 }));
def('slate', (u, v, o) => {
  const [d1, d2, id] = voronoi(u, v, 31, 2, 0.6);
  const n = fbm(u, v, 32, 8, 5);
  const edge = smooth(0.01, 0.06, d2 - d1);
  const tone = 0.85 + hash2(id, 1, 31) * 0.3 + (n - 0.5) * 0.3;
  o.r = 0.2 * tone * (0.6 + 0.4 * edge); o.g = 0.21 * tone * (0.6 + 0.4 * edge); o.b = 0.24 * tone * (0.6 + 0.4 * edge);
  o.h = 0.3 + edge * 0.4 + n * 0.3; o.ro = 0.75 + n * 0.2;
});
function stoneBase(u, v, o, seed) {
  const n = fbm(u, v, seed, 4, 6);
  const [d1, d2] = voronoi(u, v, seed + 3, 5, 1);
  const crack = 1 - smooth(0.0, 0.05, d2 - d1);
  const tone = 0.7 + n * 0.6;
  o.r = 0.42 * tone; o.g = 0.38 * tone; o.b = 0.34 * tone;
  o.r *= 1 - crack * 0.5; o.g *= 1 - crack * 0.5; o.b *= 1 - crack * 0.5;
  o.h = n * 0.8 - crack * 0.4 + fbm(u, v, seed + 9, 16, 2) * 0.2;
  o.ro = 0.88;
}
def('stone', (u, v, o) => stoneBase(u, v, o, 41));
def('stone_ore', (u, v, o) => {
  stoneBase(u, v, o, 43);
  const [d1, , id] = voronoi(u, v, 45, 7, 0.9);
  const has = hash2(id, 9, 45) < 0.35;
  if (has && d1 < 0.2) {
    const t = smooth(0.2, 0.1, d1);
    mixc(o, [0.95, 0.72, 0.25], t);
    o.h += t * 0.3; o.ro = lerp(o.ro, 0.25, t);
  }
});
def('dirt', (u, v, o) => {
  const n = fbm(u, v, 51, 6, 5);
  const t = 0.65 + n * 0.7;
  o.r = 0.34 * t; o.g = 0.25 * t; o.b = 0.17 * t;
  o.h = n * 0.6; o.ro = 0.97;
  const [d1, , id] = voronoi(u, v, 53, 10, 1);
  if (d1 < 0.22 && hash2(id, 2, 53) < 0.5) {
    const k = smooth(0.22, 0.12, d1);
    mixc(o, [0.45 * (0.8 + hash2(id, 5, 1) * 0.4), 0.42, 0.38], k);
    o.h += k * 0.35;
  }
});
def('gravel', slabGen({ seed: 61, n: 12, base: [0.4, 0.38, 0.36], grout: [0.14, 0.13, 0.12], var: 0.6, dome: 0.5, soft: 0.25, jit: 1 }));
def('planks', (u, v, o, x, y) => {
  const row = Math.floor(y / 16), by = y - row * 16;
  const seam = Math.floor(hash2(row, 1, 71) * T);
  const dx = Math.min(Math.abs(x - seam), T - Math.abs(x - seam));
  const g = woodGrain(u + row * 0.37, v, 71 + row);
  const tone = (0.8 + hash2(row, 2, 71) * 0.35) * (0.7 + g * 0.6);
  o.r = 0.46 * tone; o.g = 0.31 * tone; o.b = 0.18 * tone;
  const gap = Math.min(by + 0.5, 16 - by - 0.5, dx + 0.5);
  const e = smooth(0.4, 1.6, gap);
  o.r *= 0.35 + 0.65 * e; o.g *= 0.35 + 0.65 * e; o.b *= 0.35 + 0.65 * e;
  o.h = 0.2 + e * 0.5 + g * 0.2; o.ro = 0.8;
  const nx1 = (seam + 3) % T, nx2 = (seam - 4 + T) % T;
  if ((x === nx1 || x === nx2) && (by === 4 || by === 11)) { o.r = o.g = o.b = 0.12; o.ro = 0.4; o.h = 0.8; }
});
def('log_side', (u, v, o) => {
  const g = vnoise(u * 14, v * 3, 81, 14, 3) * 0.7 + vnoise(u * 28, v * 6, 82, 28, 6) * 0.3;
  const r = Math.pow(Math.abs(g * 2 - 1), 0.6);
  const t = 0.55 + r * 0.6;
  o.r = 0.3 * t; o.g = 0.21 * t; o.b = 0.13 * t;
  o.h = r * 0.8; o.ro = 0.95;
});
def('log_top', (u, v, o) => {
  const dx = u - 0.5, dy = v - 0.5, r = Math.sqrt(dx * dx + dy * dy);
  const n = fbm(u, v, 91, 4, 3);
  const ring = 0.5 + 0.5 * Math.sin((r + n * 0.05) * 90);
  const t = 0.75 + ring * 0.3;
  o.r = 0.55 * t; o.g = 0.4 * t; o.b = 0.24 * t;
  o.h = ring * 0.3; o.ro = 0.85;
  if (r > 0.42) { const k = smooth(0.42, 0.46, r); mixc(o, [0.2, 0.14, 0.09], k); o.h = 0.2 + k * 0.4; }
});
def('darkbrick', brickGen({ seed: 101, base: [0.3, 0.2, 0.17], var: 0.35, mortar: [0.08, 0.06, 0.06], crack: 2 }));
def('basalt', slabGen({ seed: 111, n: 4, base: [0.19, 0.18, 0.18], grout: [0.05, 0.05, 0.05], var: 0.3, soft: 0.08, rough: 0.9 }));
def('basalt_glow', (u, v, o) => {
  const [d1, d2, id] = voronoi(u, v, 121, 4, 0.8);
  const n = fbm(u, v, 122, 8, 4);
  const e = d2 - d1 + (n - 0.5) * 0.05;
  const tone = 0.8 + hash2(id, 1, 121) * 0.4;
  o.r = 0.17 * tone; o.g = 0.15 * tone; o.b = 0.14 * tone;
  o.h = 0.2 + smooth(0.0, 0.1, e) * 0.6 + n * 0.2; o.ro = 0.9;
  const glow = smooth(0.06, 0.0, e) * (0.6 + 0.4 * n);
  if (glow > 0) {
    mixc(o, [1, 0.45, 0.1], glow);
    o.er = 1.0 * glow; o.eg = 0.32 * glow; o.eb = 0.04 * glow; o.h -= glow * 0.3;
  }
});
def('obsidian', (u, v, o) => {
  const n = fbm(u, v, 131, 3, 6);
  const ridge = Math.pow(1 - Math.abs(n * 2 - 1), 6);
  const [d1] = voronoi(u, v, 133, 3, 1);
  o.r = 0.06 + ridge * 0.12; o.g = 0.045 + ridge * 0.05; o.b = 0.09 + ridge * 0.16;
  o.h = d1 * 0.35 + ridge * 0.1; o.ro = 0.38 + (1 - ridge) * 0.2;
});
def('polished', (u, v, o, x, y) => {
  const cx = Math.floor(x / 32), cy = Math.floor(y / 32);
  const dark = (cx + cy) % 2 === 0;
  const n = fbm(u, v, 141 + (dark ? 0 : 5), 3, 6);
  const vein = Math.pow(1 - Math.abs(n * 2 - 1), 10);
  const base = dark ? [0.14, 0.13, 0.16] : [0.46, 0.44, 0.41];
  const vc = dark ? [0.4, 0.38, 0.42] : [0.2, 0.19, 0.2];
  o.r = base[0]; o.g = base[1]; o.b = base[2];
  mixc(o, vc, vein * 0.8);
  const bx = x % 32, by = y % 32;
  const gd = Math.min(bx + 0.5, 32 - bx - 0.5, by + 0.5, 32 - by - 0.5);
  const e = smooth(0.4, 1.4, gd);
  o.r *= 0.4 + 0.6 * e; o.g *= 0.4 + 0.6 * e; o.b *= 0.4 + 0.6 * e;
  o.h = 0.3 + e * 0.5; o.ro = lerp(0.9, 0.28, e);
});
def('bone_wall', (u, v, o) => { // parede de ossos das catacumbas
  const [d1, d2, id] = voronoi(u, v, 151, 5, 0.9);
  const n = fbm(u, v, 152, 8, 3);
  const e = smooth(0.0, 0.18, d2 - d1);
  const skull = hash2(id, 4, 151) < 0.25;
  const t = 0.75 + hash2(id, 2, 151) * 0.3 + n * 0.2;
  o.r = 0.72 * t * (0.3 + 0.7 * e); o.g = 0.66 * t * (0.3 + 0.7 * e); o.b = 0.54 * t * (0.3 + 0.7 * e);
  o.h = e * 0.6 + (1 - d1 * 1.6) * 0.3; o.ro = 0.8;
  if (skull && d1 < 0.3) { // orbitas escuras
    const s = hash2(id, 8, 151) * 0.1;
    const [dd] = voronoi(u + 0.03, v + s * 0.1, 151, 5, 0.9);
    if (Math.abs(dd - d1) < 0.02 && d1 > 0.06 && d1 < 0.16) { o.r *= 0.2; o.g *= 0.2; o.b *= 0.2; o.h -= 0.3; }
  }
});

// ---------- dimensoes ----------
def('ice', (u, v, o) => {
  const n = fbm(u, v, 161, 3, 5);
  const [d1, d2] = voronoi(u, v, 163, 3, 1);
  const c = smooth(0.025, 0.0, d2 - d1);
  const deep = fbm(u, v, 165, 2, 3);
  o.r = 0.42 + n * 0.12 + deep * 0.08; o.g = 0.6 + n * 0.12 + deep * 0.06; o.b = 0.74 + n * 0.1;
  mixc(o, [0.92, 0.97, 1], c * 0.7);
  const bub = hash2(Math.floor(u * 64), Math.floor(v * 64), 167) < 0.012 ? 1 : 0;
  if (bub) mixc(o, [0.9, 0.96, 1], 0.6);
  o.h = 0.55 - c * 0.35 + n * 0.08; o.ro = 0.05 + c * 0.25 + n * 0.05;
});
def('snow', (u, v, o) => {
  const n = fbm(u, v, 171, 6, 5), n2 = fbm(u, v, 172, 24, 2);
  const t = 0.86 + n * 0.1 + n2 * 0.05;
  o.r = t * 0.94; o.g = t * 0.97; o.b = t; o.h = n * 0.6 + n2 * 0.2; o.ro = 0.92 - n2 * 0.2;
  if (hash2(Math.floor(u * 64), Math.floor(v * 64), 173) < 0.03) { o.ro = 0.2; o.r = o.g = o.b = 1; }
});
def('icewall', slabGen({ seed: 181, n: 3, base: [0.46, 0.64, 0.78], grout: [0.24, 0.36, 0.48], var: 0.25, soft: 0.1, rough: 0.12, dome: 0.3 }));
def('frost', (u, v, o) => {
  stoneBase(u, v, o, 191);
  o.r = o.r * 0.7 + 0.08; o.g = o.g * 0.8 + 0.12; o.b = o.b * 0.95 + 0.2;
  const f = smooth(0.55, 0.7, fbm(u, v, 193, 4, 4));
  mixc(o, [0.85, 0.92, 0.98], f); o.ro = lerp(o.ro, 0.3, f);
});
def('mud', (u, v, o) => {
  const n = fbm(u, v, 201, 5, 5), n2 = fbm(u, v, 202, 20, 2);
  const t = 0.6 + n * 0.7;
  o.r = 0.2 * t; o.g = 0.15 * t; o.b = 0.1 * t;
  const wet = smooth(0.5, 0.62, fbm(u, v, 203, 3, 3));
  o.r *= 1 - wet * 0.35; o.g *= 1 - wet * 0.3; o.b *= 1 - wet * 0.25;
  o.h = n * 0.5 + n2 * 0.2 - wet * 0.2; o.ro = lerp(0.9, 0.18, wet);
  const [d1, , id] = voronoi(u, v, 205, 9, 1);
  if (d1 < 0.16 && hash2(id, 3, 205) < 0.4) { const k = smooth(0.16, 0.08, d1); mixc(o, [0.32, 0.3, 0.26], k); o.h += k * 0.4; o.ro = lerp(o.ro, 0.8, k); }
});
def('mossstone', (u, v, o) => {
  slabGen({ seed: 211, n: 5, base: [0.36, 0.38, 0.33], grout: [0.1, 0.12, 0.08], var: 0.4, dome: 0.35, soft: 0.2 })(u, v, o);
  const mm = smooth(0.52, 0.62, fbm(u, v, 213, 4, 5));
  if (mm > 0) { const g2 = fbm(u, v, 214, 16, 3); mixc(o, [0.14 + g2 * 0.1, 0.26 + g2 * 0.14, 0.06], mm); o.h += mm * 0.15; o.ro = lerp(o.ro, 1, mm); }
});
def('swampwall', brickGen({ seed: 221, base: [0.3, 0.34, 0.27], var: 0.35, mortar: [0.1, 0.12, 0.08], moss: 2, crack: 2 }));
def('voidtile', (u, v, o, x, y) => {
  const n = fbm(u, v, 231, 3, 5);
  o.r = 0.05 + n * 0.04; o.g = 0.035 + n * 0.03; o.b = 0.09 + n * 0.06;
  const gd = Math.min(x + 0.5, 64 - x - 0.5, y + 0.5, 64 - y - 0.5);
  const seam = smooth(1.4, 0.3, gd) * 0.6;
  if (seam > 0) { o.er = 0.3 * seam; o.eg = 0.12 * seam; o.eb = 0.6 * seam; mixc(o, [0.45, 0.28, 0.8], seam); }
  if (hash2(x, y, 233) < 0.006) { o.er = o.eg = o.eb = 0.9; }
  o.h = 0.5 - seam * 0.3; o.ro = 0.08 + n * 0.05;
});
def('voidcrystal', (u, v, o) => {
  const [d1, d2, id] = voronoi(u, v, 241, 4, 0.9);
  const n = fbm(u, v, 242, 6, 3);
  const e = smooth(0.0, 0.06, d2 - d1);
  const tone = 0.7 + hash2(id, 1, 241) * 0.5;
  o.r = 0.2 * tone; o.g = 0.1 * tone; o.b = 0.36 * tone;
  const vein = smooth(0.035, 0.0, d2 - d1) * smooth(0.4, 0.6, n);
  if (vein > 0) { o.er = 0.7 * vein; o.eg = 0.3 * vein; o.eb = 1.0 * vein; mixc(o, [0.75, 0.45, 1], vein); }
  o.h = e * 0.5 + (1 - d1) * 0.3; o.ro = 0.12 + (1 - e) * 0.25;
});

// ---------- construcao do atlas ----------
function renderTile(gen) {
  const n = T * T;
  const alb = new Float32Array(n * 3), hgt = new Float32Array(n), rou = new Float32Array(n), emi = new Float32Array(n * 3);
  const o = {};
  for (let y = 0; y < T; y++) for (let x = 0; x < T; x++) {
    o.r = o.g = o.b = 0.5; o.h = 0.5; o.ro = 0.9; o.er = o.eg = o.eb = 0;
    gen((x + 0.5) / T, (y + 0.5) / T, o, x, y);
    const i = y * T + x;
    alb[i * 3] = o.r; alb[i * 3 + 1] = o.g; alb[i * 3 + 2] = o.b;
    hgt[i] = o.h; rou[i] = o.ro; emi[i * 3] = o.er; emi[i * 3 + 1] = o.eg; emi[i * 3 + 2] = o.eb;
  }
  const nor = new Float32Array(n * 3);
  const S = 2.4;
  for (let y = 0; y < T; y++) for (let x = 0; x < T; x++) {
    const hl = hgt[y * T + ((x + T - 1) % T)], hr = hgt[y * T + ((x + 1) % T)];
    const hu = hgt[((y + T - 1) % T) * T + x], hd = hgt[((y + 1) % T) * T + x];
    let nx = -(hr - hl) * S, ny = (hd - hu) * S, nz = 1;
    const l = Math.hypot(nx, ny, nz); nx /= l; ny /= l; nz /= l;
    const i = (y * T + x) * 3;
    nor[i] = nx * 0.5 + 0.5; nor[i + 1] = ny * 0.5 + 0.5; nor[i + 2] = nz * 0.5 + 0.5;
  }
  return { alb, hgt, rou, emi, nor };
}

let _atlas = null, _tileData = null;
export function tileData() {
  if (!_tileData) _tileData = defs.map(d => renderTile(d.gen));
  return _tileData;
}

function toCanvas(w, h, fill) {
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  const ctx = c.getContext('2d');
  const img = ctx.createImageData(w, h);
  fill(img.data);
  ctx.putImageData(img, 0, 0);
  return c;
}

export function getAtlas() {
  if (_atlas) return _atlas;
  const data = tileData();
  const rows = Math.ceil(defs.length / COLS);
  const W = COLS * CELL, H = rows * CELL;
  const mk = (pick, srgb) => {
    const c = toCanvas(W, H, (d) => {
      for (let t = 0; t < data.length; t++) {
        const ox = (t % COLS) * CELL, oy = Math.floor(t / COLS) * CELL;
        for (let py = 0; py < CELL; py++) for (let px = 0; px < CELL; px++) {
          const tx = ((px - PAD) % T + T) % T, ty = ((py - PAD) % T + T) % T;
          const v = pick(data[t], ty * T + tx);
          const k = ((oy + py) * W + ox + px) * 4;
          d[k] = clamp(v[0], 0, 1) * 255; d[k + 1] = clamp(v[1], 0, 1) * 255; d[k + 2] = clamp(v[2], 0, 1) * 255; d[k + 3] = 255;
        }
      }
    });
    const tex = new THREE.CanvasTexture(c);
    tex.colorSpace = srgb ? THREE.SRGBColorSpace : THREE.NoColorSpace;
    tex.anisotropy = 8;
    tex.minFilter = THREE.LinearMipmapLinearFilter;
    tex.magFilter = THREE.LinearFilter;
    return tex;
  };
  const tmp = [0, 0, 0];
  const map = mk((td, i) => { tmp[0] = td.alb[i * 3]; tmp[1] = td.alb[i * 3 + 1]; tmp[2] = td.alb[i * 3 + 2]; return tmp; }, true);
  const normalMap = mk((td, i) => { tmp[0] = td.nor[i * 3]; tmp[1] = td.nor[i * 3 + 1]; tmp[2] = td.nor[i * 3 + 2]; return tmp; }, false);
  const roughnessMap = mk((td, i) => { tmp[0] = tmp[1] = tmp[2] = td.rou[i]; return tmp; }, false);
  const emissiveMap = mk((td, i) => { tmp[0] = td.emi[i * 3]; tmp[1] = td.emi[i * 3 + 1]; tmp[2] = td.emi[i * 3 + 2]; return tmp; }, true);
  const uv = (t) => {
    const ox = (t % COLS) * CELL + PAD, oy = Math.floor(t / COLS) * CELL + PAD;
    const e = 0.5;
    return [(ox + e) / W, 1 - (oy + T - e) / H, (ox + T - e) / W, 1 - (oy + e) / H];
  };
  _atlas = { map, normalMap, roughnessMap, emissiveMap, uv };
  return _atlas;
}

// textura avulsa de um bloco (para objetos de cena)
const _tileTex = {};
export function tileTexture(name, repeat = 1) {
  const key = name + ':' + repeat;
  if (_tileTex[key]) return _tileTex[key];
  const td = tileData()[TILES[name]];
  const mk = (arr, srgb, mono) => {
    const c = toCanvas(T, T, (d) => {
      for (let i = 0; i < T * T; i++) {
        if (mono) { d[i * 4] = d[i * 4 + 1] = d[i * 4 + 2] = clamp(arr[i], 0, 1) * 255; }
        else { d[i * 4] = clamp(arr[i * 3], 0, 1) * 255; d[i * 4 + 1] = clamp(arr[i * 3 + 1], 0, 1) * 255; d[i * 4 + 2] = clamp(arr[i * 3 + 2], 0, 1) * 255; }
        d[i * 4 + 3] = 255;
      }
    });
    const t = new THREE.CanvasTexture(c);
    t.wrapS = t.wrapT = THREE.RepeatWrapping; t.repeat.set(repeat, repeat);
    t.colorSpace = srgb ? THREE.SRGBColorSpace : THREE.NoColorSpace;
    t.anisotropy = 4;
    return t;
  };
  _tileTex[key] = { map: mk(td.alb, true), normalMap: mk(td.nor, false), roughnessMap: mk(td.rou, false, true) };
  return _tileTex[key];
}

// ---------- texturas de personagens ----------
const _charTex = {};
const CHAR = {
  steel: { base: [0.58, 0.6, 0.63], var: 0.18, sc: 6, scratch: true, hammer: true },
  steel_dark: { base: [0.26, 0.27, 0.3], var: 0.2, sc: 6, scratch: true, hammer: true },
  gold: { base: [0.88, 0.68, 0.3], var: 0.16, sc: 6, scratch: true },
  iron: { base: [0.24, 0.23, 0.23], var: 0.3, sc: 8, rust: true, hammer: true },
  chain: { base: [0.5, 0.52, 0.55], var: 0.15, sc: 8, rings: true },
  cloth_blue: { base: [0.1, 0.18, 0.4], var: 0.22, sc: 16, weave: true },
  cloth_red: { base: [0.48, 0.07, 0.06], var: 0.22, sc: 16, weave: true },
  cloth_green: { base: [0.13, 0.26, 0.15], var: 0.22, sc: 16, weave: true },
  cloth_purple: { base: [0.24, 0.09, 0.32], var: 0.28, sc: 16, weave: true },
  cloth_white: { base: [0.72, 0.68, 0.6], var: 0.18, sc: 16, weave: true },
  cloth_brown: { base: [0.3, 0.2, 0.12], var: 0.25, sc: 16, weave: true },
  leather: { base: [0.36, 0.22, 0.12], var: 0.3, sc: 8, leather: true },
  leather_dark: { base: [0.16, 0.11, 0.08], var: 0.3, sc: 8, leather: true },
  skin: { base: [0.78, 0.56, 0.44], var: 0.1, sc: 6, skin: true },
  skin_dark: { base: [0.46, 0.3, 0.22], var: 0.1, sc: 6, skin: true },
  skin_pale: { base: [0.66, 0.66, 0.6], var: 0.16, sc: 5, veins: [0.32, 0.36, 0.42], skin: true },
  skin_drowned: { base: [0.36, 0.44, 0.4], var: 0.22, sc: 5, veins: [0.14, 0.2, 0.18], skin: true },
  rags: { base: [0.3, 0.26, 0.2], var: 0.5, sc: 10, weave: true, holes: true },
  bone: { base: [0.82, 0.78, 0.66], var: 0.18, sc: 8, pores: true },
  robe: { base: [0.1, 0.09, 0.12], var: 0.25, sc: 12, weave: true },
  hair: { base: [0.14, 0.09, 0.05], var: 0.4, sc: 24, fiber: true },
  hair_grey: { base: [0.45, 0.43, 0.4], var: 0.3, sc: 24, fiber: true },
  wood: { base: [0.42, 0.28, 0.16], var: 0.3, sc: 4, grain: true },
  plant: { base: [0.2, 0.3, 0.13], var: 0.3, sc: 6, fiber: true },
  plant_dark: { base: [0.12, 0.16, 0.08], var: 0.3, sc: 6, fiber: true },
  petal: { base: [0.5, 0.1, 0.18], var: 0.25, sc: 6, veins: [0.8, 0.3, 0.35] },
  scales: { base: [0.22, 0.27, 0.2], var: 0.25, sc: 6, scales: true },
  scales_red: { base: [0.35, 0.12, 0.1], var: 0.25, sc: 6, scales: true },
  fur: { base: [0.34, 0.29, 0.24], var: 0.3, sc: 28, fiber: true },
  fur_white: { base: [0.82, 0.86, 0.9], var: 0.18, sc: 28, fiber: true },
  cloth_ice: { base: [0.66, 0.78, 0.88], var: 0.16, sc: 16, weave: true },
  hide: { base: [0.2, 0.2, 0.24], var: 0.25, sc: 6, leather: true },
  belly: { base: [0.56, 0.46, 0.4], var: 0.3, sc: 5, blotch: [0.42, 0.26, 0.28], skin: true, stitches: true },
  porcelain: { base: [0.9, 0.88, 0.84], var: 0.04, sc: 4, porcelain: true },
  ice: { base: [0.62, 0.82, 0.92], var: 0.14, sc: 5, cracksLight: true },
  crystal_void: { base: [0.16, 0.1, 0.3], var: 0.25, sc: 4, veinGlow: [0.65, 0.3, 1] },
  carapace: { base: [0.13, 0.11, 0.15], var: 0.25, sc: 4, plates: true },
  carapace_ice: { base: [0.5, 0.66, 0.78], var: 0.2, sc: 4, plates: true },
  chitin: { base: [0.3, 0.24, 0.2], var: 0.3, sc: 5, plates: true },
  obsidian: { base: [0.08, 0.06, 0.1], var: 0.3, sc: 4, lava: true },
  moth: { base: [0.5, 0.44, 0.36], var: 0.3, sc: 24, fiber: true },
  jelly: { base: [0.55, 0.8, 0.5], var: 0.2, sc: 5, veins: [0.8, 1, 0.6] },
};
export function charTex(kind) {
  if (_charTex[kind]) return _charTex[kind];
  const P = CHAR[kind] || CHAR.steel;
  const S = 128, seed = kind.length * 97 + kind.charCodeAt(0) * 7 + kind.charCodeAt(kind.length - 1);
  const rough = new Float32Array(S * S), emi = new Float32Array(S * S * 3), hgt = new Float32Array(S * S);
  let hasEmi = false;
  const scr = P.scratch ? makeCracks(seed, 5) : null;
  const col = toCanvas(S, S, (d) => {
    for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
      const u = (x + 0.5) / S, v = (y + 0.5) / S, i = y * S + x;
      let n = fbm(u, v, seed, P.sc, 4);
      if (P.grain) n = woodGrain(u, v, seed);
      if (P.fiber) n = vnoise(u * P.sc, v * P.sc * 0.25, seed, P.sc, P.sc * 0.25) * 0.6 + fbm(u, v, seed + 1, P.sc, 2) * 0.4;
      const t = 1 + (n - 0.5) * P.var * 2;
      let r = P.base[0] * t, g = P.base[1] * t, b = P.base[2] * t;
      let ro = 0.8, h = n * 0.5;
      if (P.weave) { const w = ((x + y) % 4 < 2 ? 1 : 0.88) * ((x - y + 256) % 4 < 2 ? 1 : 0.93); r *= w; g *= w; b *= w; ro = 0.95; h = w * 0.6; }
      if (P.hammer) { const [d1] = voronoi(u, v, seed + 2, 7, 1); h = 0.5 + d1 * 0.35; }
      if (P.scratch) { ro = 0.26 + n * 0.18; const s = scr[i % (64 * 64)] || 0; if (s > 0) { r *= 1 + s * 0.3; g *= 1 + s * 0.3; b *= 1 + s * 0.3; h -= s * 0.2; } }
      if (P.rings) {
        const rx = ((x + (Math.floor(y / 6) % 2) * 3) % 6) - 2.5, ry = (y % 6) - 2.5, rr = Math.hypot(rx, ry);
        const ring = smooth(1.4, 2.0, rr) * smooth(3.2, 2.5, rr);
        const k = 0.35 + ring * 0.75; r *= k; g *= k; b *= k; h = ring; ro = 0.35 + (1 - ring) * 0.4;
      }
      if (P.leather) { const cr = fbm(u, v, seed + 3, 24, 2); h = n * 0.4 + cr * 0.3; ro = 0.62 + cr * 0.2; }
      if (P.skin) { ro = 0.55 + n * 0.1; h = n * 0.2 + fbm(u, v, seed + 9, 32, 2) * 0.1; }
      if (P.rust) { const rr = smooth(0.55, 0.7, fbm(u, v, seed + 4, 4, 4)); r = lerp(r, 0.4, rr); g = lerp(g, 0.2, rr); b = lerp(b, 0.1, rr); ro = 0.45 + rr * 0.45; }
      if (P.blotch) { const bl = smooth(0.58, 0.7, fbm(u, v, seed + 6, 4, 4)); r = lerp(r, P.blotch[0], bl); g = lerp(g, P.blotch[1], bl); b = lerp(b, P.blotch[2], bl); }
      if (P.stitches) { const sy = Math.abs(y - S * 0.5); if (sy < 1.5) { r *= 0.35; g *= 0.3; b *= 0.3; h -= 0.3; } if (sy < 5 && x % 10 < 2) { r = 0.1; g = 0.08; b = 0.07; h += 0.2; } }
      if (P.veins) { const [d1, d2] = voronoi(u, v, seed + 7, 4, 1); const vn = smooth(0.04, 0.0, d2 - d1) * smooth(0.3, 0.6, fbm(u, v, seed + 8, 6, 3)); r = lerp(r, P.veins[0], vn); g = lerp(g, P.veins[1], vn); b = lerp(b, P.veins[2], vn); h += vn * 0.2; }
      if (P.holes && fbm(u, v, seed + 8, 6, 3) > 0.7) { r *= 0.3; g *= 0.3; b *= 0.3; }
      if (P.pores) { if (hash2(x, y, seed) < 0.05) { r *= 0.7; g *= 0.7; b *= 0.7; h -= 0.2; } ro = 0.7; }
      if (P.plates) { const [d1, d2] = voronoi(u, v, seed, 3, 0.7); const e = smooth(0, 0.08, d2 - d1); r = r * (0.4 + 0.6 * e) + (1 - d1) * 0.05; g *= 0.4 + 0.6 * e; b *= 0.4 + 0.6 * e; ro = 0.22 + (1 - e) * 0.4; h = e * 0.8 + (1 - d1) * 0.2; }
      if (P.scales) {
        const row = Math.floor(y / 8), xx = x + (row % 2) * 4, cx = Math.floor(xx / 8) * 8 + 4 - (row % 2) * 4, cy = row * 8;
        const dd = Math.hypot(x - cx, (y - cy) * 1.2) / 6.5;
        const e = smooth(1.0, 0.8, dd);
        const k = 0.55 + e * 0.5 + (1 - dd) * 0.2; r *= k; g *= k; b *= k; h = e * (1 - dd * 0.5); ro = 0.35 + (1 - e) * 0.3;
      }
      if (P.porcelain) { ro = 0.12; h = 0.5; const cr = scr ? 0 : 0; void cr; }
      if (P.cracksLight) { const [d1, d2] = voronoi(u, v, seed + 3, 5, 1); const c = smooth(0.03, 0.0, d2 - d1); r = lerp(r, 0.95, c * 0.6); g = lerp(g, 1, c * 0.6); b = lerp(b, 1, c * 0.6); ro = 0.06 + c * 0.2; h = 0.5 - c * 0.3; }
      if (P.spots) { const [d1, , id] = voronoi(u, v, seed, 5, 1); if (d1 < 0.25 && hash2(id, 1, seed) < 0.6) { const k = smooth(0.25, 0.18, d1); r = lerp(r, P.spots[0], k); g = lerp(g, P.spots[1], k); b = lerp(b, P.spots[2], k); } }
      if (P.lava || P.veinGlow) {
        const vc = P.veinGlow || [1, 0.4, 0.05];
        const [d1, d2] = voronoi(u, v, seed, 4, 0.9);
        const gl = smooth(0.035, 0.0, d2 - d1);
        ro = 0.18 + (1 - gl) * 0.2;
        if (gl > 0) { hasEmi = true; r = lerp(r, vc[0], gl); g = lerp(g, vc[1], gl); b = lerp(b, vc[2], gl); emi[i * 3] = gl * vc[0]; emi[i * 3 + 1] = gl * vc[1] * 0.9; emi[i * 3 + 2] = gl * vc[2]; h -= gl * 0.3; }
      }
      rough[i] = ro; hgt[i] = h;
      d[i * 4] = clamp(r, 0, 1) * 255; d[i * 4 + 1] = clamp(g, 0, 1) * 255; d[i * 4 + 2] = clamp(b, 0, 1) * 255; d[i * 4 + 3] = 255;
    }
  });
  const wrap = (tx) => { tx.wrapS = tx.wrapT = THREE.RepeatWrapping; tx.anisotropy = 4; return tx; };
  const map = wrap(new THREE.CanvasTexture(col)); map.colorSpace = THREE.SRGBColorSpace;
  const rc = toCanvas(S, S, (d) => { for (let i = 0; i < S * S; i++) { d[i * 4] = d[i * 4 + 1] = d[i * 4 + 2] = clamp(rough[i], 0, 1) * 255; d[i * 4 + 3] = 255; } });
  const roughnessMap = wrap(new THREE.CanvasTexture(rc));
  const nc = toCanvas(S, S, (d) => {
    const K = 3;
    for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
      const dx = (hgt[y * S + (x + 1) % S] - hgt[y * S + (x + S - 1) % S]) * K;
      const dy = (hgt[((y + 1) % S) * S + x] - hgt[((y + S - 1) % S) * S + x]) * K;
      const l = Math.hypot(dx, dy, 1), i = (y * S + x) * 4;
      d[i] = (-dx / l * 0.5 + 0.5) * 255; d[i + 1] = (dy / l * 0.5 + 0.5) * 255; d[i + 2] = (1 / l * 0.5 + 0.5) * 255; d[i + 3] = 255;
    }
  });
  const normalMap = wrap(new THREE.CanvasTexture(nc));
  let emissiveMap = null;
  if (hasEmi) {
    const ec = toCanvas(S, S, (d) => { for (let i = 0; i < S * S; i++) { d[i * 4] = clamp(emi[i * 3], 0, 1) * 255; d[i * 4 + 1] = clamp(emi[i * 3 + 1], 0, 1) * 255; d[i * 4 + 2] = clamp(emi[i * 3 + 2], 0, 1) * 255; d[i * 4 + 3] = 255; } });
    emissiveMap = wrap(new THREE.CanvasTexture(ec)); emissiveMap.colorSpace = THREE.SRGBColorSpace;
  }
  _charTex[kind] = { map, roughnessMap, normalMap, emissiveMap };
  return _charTex[kind];
}

// asas de mariposa com ocelos
export const wingTexture = (base, eye) => canvas2d(128, 128, (g, w, h) => {
  g.clearRect(0, 0, w, h);
  g.fillStyle = base;
  g.beginPath(); g.moveTo(4, 64); g.bezierCurveTo(20, 4, 110, 0, 124, 30); g.bezierCurveTo(128, 70, 90, 120, 40, 110); g.bezierCurveTo(20, 104, 6, 84, 4, 64); g.fill();
  for (let i = 0; i < 900; i++) { g.fillStyle = `rgba(${Math.random() < 0.5 ? '0,0,0' : '255,240,220'},${Math.random() * 0.08})`; g.fillRect(Math.random() * w, Math.random() * h, 2, 2); }
  g.strokeStyle = 'rgba(40,30,20,0.5)'; g.lineWidth = 1.2;
  for (let k = 0; k < 6; k++) { g.beginPath(); g.moveTo(6, 64); g.quadraticCurveTo(50, 40 + k * 8, 120 - k * 6, 20 + k * 16); g.stroke(); }
  const cx = 80, cy = 58;
  const gr = g.createRadialGradient(cx, cy, 2, cx, cy, 20);
  gr.addColorStop(0, '#111'); gr.addColorStop(0.3, eye); gr.addColorStop(0.55, '#f4e6c8'); gr.addColorStop(0.7, '#2a1a10'); gr.addColorStop(1, 'rgba(0,0,0,0)');
  g.globalCompositeOperation = 'source-atop'; g.fillStyle = gr; g.beginPath(); g.arc(cx, cy, 20, 0, Math.PI * 2); g.fill();
  g.globalCompositeOperation = 'source-over';
});

// ---------- lava / agua ----------
export function lavaTexture() {
  const S = 128;
  const c = toCanvas(S, S, (d) => {
    for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
      const u = x / S, v = y / S;
      const n = fbm(u, v, 201, 4, 5);
      const [d1, d2] = voronoi(u, v, 203, 5, 1);
      const crust = smooth(0.02, 0.2, d2 - d1) * smooth(0.35, 0.65, n);
      const hot = 1 - crust;
      const r = lerp(0.1, 1.0, hot), g = lerp(0.02, 0.22 + 0.4 * hot * hot, hot), b = lerp(0.01, 0.02 + 0.12 * Math.pow(hot, 4), hot);
      const i = (y * S + x) * 4;
      d[i] = r * 255; d[i + 1] = g * 255; d[i + 2] = b * 255; d[i + 3] = 255;
    }
  });
  const t = new THREE.CanvasTexture(c); t.colorSpace = THREE.SRGBColorSpace; t.wrapS = t.wrapT = THREE.RepeatWrapping;
  return t;
}

export function waterNormal() {
  const S = 128;
  const h = new Float32Array(S * S);
  for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) h[y * S + x] = fbm(x / S, y / S, 301, 4, 5);
  const c = toCanvas(S, S, (d) => {
    for (let y = 0; y < S; y++) for (let x = 0; x < S; x++) {
      const dx = (h[y * S + (x + 1) % S] - h[y * S + (x + S - 1) % S]) * 6;
      const dy = (h[((y + 1) % S) * S + x] - h[((y + S - 1) % S) * S + x]) * 6;
      const l = Math.hypot(dx, dy, 1), i = (y * S + x) * 4;
      d[i] = (-dx / l * 0.5 + 0.5) * 255; d[i + 1] = (dy / l * 0.5 + 0.5) * 255; d[i + 2] = (1 / l * 0.5 + 0.5) * 255; d[i + 3] = 255;
    }
  });
  const t = new THREE.CanvasTexture(c); t.wrapS = t.wrapT = THREE.RepeatWrapping;
  return t;
}

// ---------- texturas com alfa ----------
function canvas2d(w, h, draw) {
  const c = document.createElement('canvas'); c.width = w; c.height = h;
  draw(c.getContext('2d'), w, h);
  const t = new THREE.CanvasTexture(c); t.colorSpace = THREE.SRGBColorSpace;
  return t;
}
export const softDot = () => canvas2d(64, 64, (g, w) => {
  const gr = g.createRadialGradient(w / 2, w / 2, 0, w / 2, w / 2, w / 2);
  gr.addColorStop(0, 'rgba(255,255,255,1)'); gr.addColorStop(0.35, 'rgba(255,255,255,0.6)'); gr.addColorStop(1, 'rgba(255,255,255,0)');
  g.fillStyle = gr; g.fillRect(0, 0, w, w);
});
export const cobwebTexture = () => canvas2d(128, 128, (g) => {
  g.strokeStyle = 'rgba(230,230,235,0.55)'; g.lineWidth = 1;
  const cx = 0, cy = 0;
  for (let i = 0; i <= 8; i++) { const a = (i / 8) * Math.PI / 2; g.beginPath(); g.moveTo(cx, cy); g.lineTo(Math.cos(a) * 128, Math.sin(a) * 128); g.stroke(); }
  for (let r = 12; r < 128; r += 11 + r * 0.08) {
    g.beginPath();
    for (let i = 0; i <= 8; i++) { const a = (i / 8) * Math.PI / 2; const rr = r * (0.92 + 0.08 * Math.sin(i * 3 + r)); const x = Math.cos(a) * rr, y = Math.sin(a) * rr; i ? g.lineTo(x, y) : g.moveTo(x, y); }
    g.stroke();
  }
});
export const ringTexture = () => canvas2d(128, 128, (g, w) => {
  const gr = g.createRadialGradient(w / 2, w / 2, 0, w / 2, w / 2, w / 2);
  gr.addColorStop(0, 'rgba(255,255,255,0.15)'); gr.addColorStop(0.82, 'rgba(255,255,255,0.35)');
  gr.addColorStop(0.92, 'rgba(255,255,255,1)'); gr.addColorStop(1, 'rgba(255,255,255,0)');
  g.fillStyle = gr; g.fillRect(0, 0, w, w);
});
export const bannerTexture = (color, emblem) => canvas2d(64, 128, (g, w, h) => {
  g.fillStyle = color; g.fillRect(0, 0, w, h);
  for (let i = 0; i < 400; i++) { g.fillStyle = `rgba(0,0,0,${Math.random() * 0.12})`; g.fillRect(Math.random() * w, Math.random() * h, 2, 2); }
  g.fillStyle = 'rgba(210,170,70,0.9)';
  g.fillRect(4, 4, w - 8, 3); g.fillRect(4, h - 26, w - 8, 3);
  g.save(); g.translate(w / 2, h * 0.42); g.fillStyle = 'rgba(215,180,80,0.95)';
  if (emblem === 0) { g.beginPath(); g.moveTo(0, -18); g.lineTo(14, 0); g.lineTo(0, 18); g.lineTo(-14, 0); g.closePath(); g.fill(); g.fillStyle = color; g.fillRect(-3, -8, 6, 16); }
  else if (emblem === 1) { g.beginPath(); g.arc(0, 0, 14, 0, Math.PI * 2); g.fill(); g.fillStyle = color; g.beginPath(); g.arc(4, -3, 11, 0, Math.PI * 2); g.fill(); }
  else { g.fillRect(-2, -20, 4, 34); g.fillRect(-12, -10, 24, 4); }
  g.restore();
  // franja rasgada
  g.clearRect(0, h - 20, w, 20);
  g.fillStyle = color;
  for (let x = 0; x < w; x += 8) { g.beginPath(); g.moveTo(x, h - 21); g.lineTo(x + 8, h - 21); g.lineTo(x + 4, h - 4 - Math.random() * 8); g.fill(); }
});
