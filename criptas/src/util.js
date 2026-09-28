// Utilitarios: numeros aleatorios com semente, ruido tileavel e matematica.

export function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export class RNG {
  constructor(seed) { this.f = mulberry32(seed >>> 0); }
  next() { return this.f(); }
  range(a, b) { return a + (b - a) * this.f(); }
  int(a, b) { return Math.floor(a + (b - a + 1) * this.f()); }
  pick(arr) { return arr[Math.floor(this.f() * arr.length)]; }
  chance(p) { return this.f() < p; }
  weighted(list) { // [[valor, peso], ...]
    let tot = 0; for (const [, w] of list) tot += w;
    let r = this.f() * tot;
    for (const [v, w] of list) { r -= w; if (r <= 0) return v; }
    return list[list.length - 1][0];
  }
}

export function hash2(x, y, seed = 0) {
  let h = (x * 374761393 + y * 668265263 + seed * 982451653) | 0;
  h = Math.imul(h ^ (h >>> 13), 1274126177);
  h = h ^ (h >>> 16);
  return (h >>> 0) / 4294967296;
}

const mod = (a, n) => ((a % n) + n) % n;

// ruido de valor tileavel com periodo (px, py)
export function vnoise(x, y, seed, px, py) {
  const xi = Math.floor(x), yi = Math.floor(y);
  const xf = x - xi, yf = y - yi;
  const u = xf * xf * (3 - 2 * xf), v = yf * yf * (3 - 2 * yf);
  const x0 = mod(xi, px), x1 = mod(xi + 1, px), y0 = mod(yi, py), y1 = mod(yi + 1, py);
  const a = hash2(x0, y0, seed), b = hash2(x1, y0, seed), c = hash2(x0, y1, seed), d = hash2(x1, y1, seed);
  return a + (b - a) * u + (c - a) * v + (a - b - c + d) * u * v;
}

// fbm tileavel: (u,v) em [0,1), period = numero de celulas na oitava base
export function fbm(u, v, seed, period = 4, oct = 4) {
  let s = 0, a = 0.5, f = 1, n = 0;
  for (let i = 0; i < oct; i++) {
    const p = period * f;
    s += a * vnoise(u * p, v * p, seed + i * 31, p, p);
    n += a; a *= 0.5; f *= 2;
  }
  return s / n;
}

// voronoi tileavel: retorna [d1, d2, id]
export function voronoi(u, v, seed, n, jitter = 0.9) {
  const x = u * n, y = v * n;
  const xi = Math.floor(x), yi = Math.floor(y);
  let d1 = 9, d2 = 9, id = 0;
  for (let j = -1; j <= 1; j++) for (let i = -1; i <= 1; i++) {
    const cx = xi + i, cy = yi + j;
    const wx = mod(cx, n), wy = mod(cy, n);
    const px = cx + 0.5 + (hash2(wx, wy, seed) - 0.5) * jitter;
    const py = cy + 0.5 + (hash2(wx, wy, seed + 7) - 0.5) * jitter;
    const dx = px - x, dy = py - y;
    const d = Math.sqrt(dx * dx + dy * dy);
    if (d < d1) { d2 = d1; d1 = d; id = wx + wy * 131; } else if (d < d2) d2 = d;
  }
  return [d1, d2, id];
}

export const clamp = (v, a, b) => (v < a ? a : v > b ? b : v);
export const lerp = (a, b, t) => a + (b - a) * t;
export const smooth = (a, b, x) => { const t = clamp((x - a) / (b - a), 0, 1); return t * t * (3 - 2 * t); };
export const damp = (a, b, k, dt) => lerp(a, b, 1 - Math.exp(-k * dt));
export function angleDiff(a, b) { let d = b - a; while (d > Math.PI) d -= Math.PI * 2; while (d < -Math.PI) d += Math.PI * 2; return d; }
export function dampAngle(a, b, k, dt) { return a + angleDiff(a, b) * (1 - Math.exp(-k * dt)); }
export const dist2 = (ax, az, bx, bz) => { const dx = ax - bx, dz = az - bz; return Math.sqrt(dx * dx + dz * dz); };
