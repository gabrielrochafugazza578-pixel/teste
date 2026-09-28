// Converte a masmorra em blocos (voxels) e gera as malhas por pedaco,
// com oclusao de ambiente por vertice, variacao de tom e lava/agua animadas.
import * as THREE from 'three';
import { getAtlas, TILES, lavaTexture, waterNormal } from './textures.js';
import { C } from './dungeon.js';
import { hash2 } from './util.js';
import { patchMirror } from './reflect.js';

export const OFF = 5;
const H = OFF + 5;
const CH = 16;

const FACES = [ // dir, cantos [x,y,z,u,v]
  { dir: [-1, 0, 0], c: [[0, 1, 0, 0, 1], [0, 0, 0, 0, 0], [0, 1, 1, 1, 1], [0, 0, 1, 1, 0]] },
  { dir: [1, 0, 0], c: [[1, 1, 1, 0, 1], [1, 0, 1, 0, 0], [1, 1, 0, 1, 1], [1, 0, 0, 1, 0]] },
  { dir: [0, 1, 0], c: [[0, 1, 1, 1, 1], [1, 1, 1, 0, 1], [0, 1, 0, 1, 0], [1, 1, 0, 0, 0]], top: true },
  { dir: [0, 0, -1], c: [[1, 0, 0, 0, 0], [0, 0, 0, 1, 0], [1, 1, 0, 0, 1], [0, 1, 0, 1, 1]] },
  { dir: [0, 0, 1], c: [[0, 0, 1, 0, 0], [1, 0, 1, 1, 0], [0, 1, 1, 0, 1], [1, 1, 1, 1, 1]] },
];
const AO = [0.34, 0.56, 0.78, 1.0];

function weighted(list, r) {
  let tot = 0; for (const [, w] of list) tot += w;
  r *= tot;
  for (const [v, w] of list) { r -= w; if (r <= 0) return v; }
  return list[0][0];
}

export function buildWorld(dg) {
  const { W, D, cell, h, mat, thin, wallH, theme, seed } = dg;
  const side = new Uint8Array(W * D * H), top = new Uint8Array(W * D * H);
  const vi = (x, y, z) => x + z * W + y * W * D;
  const T = (name) => TILES[name] + 1;
  const set = (x, y, z, s, t) => { const i = vi(x, y, z); side[i] = s; top[i] = t || s; };

  for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) {
    const i = x + z * W, c = cell[i];
    const found = T(theme.foundation);
    if (c === C.FLOOR) {
      const ty = OFF - 1 + h[i];
      const m = T(mat[i]);
      if (thin[i]) { set(x, ty, z, m, m); continue; }
      for (let y = 0; y < ty; y++) set(x, y, z, found);
      set(x, ty, z, h[i] > 0 ? m : found, m);
    } else if (c === C.WATER || c === C.LAVA) {
      const bt = c === C.LAVA ? T('basalt') : T(theme.themeKey === 'minas' ? 'gravel' : 'gravel');
      for (let y = 0; y < OFF - 1; y++) set(x, y, z, found, bt);
    } else if (c === C.PIT) {
      if (!theme.voidPits) set(x, 0, z, found, T('gravel'));
    } else if (c === C.WALL) {
      const ty = OFF - 1 + wallH[i];
      for (let y = 0; y <= ty; y++) {
        const s = y < OFF - 1 ? found : T(weighted(theme.walls, hash2(x * 13 + y * 7, z, seed + 3)));
        set(x, y, z, s, y === ty ? T(theme.cap) : s);
      }
    } else if (c === C.PILLAR) { // coluna redonda feita em props.js; aqui so o chao
      const ty = OFF - 1 + h[i], m = T(mat[i] && mat[i] !== theme.pillar ? mat[i] : theme.floor[0][0]);
      for (let y = 0; y < ty; y++) set(x, y, z, found);
      set(x, ty, z, h[i] > 0 ? m : found, m);
    }
  }

  const solidAt = (x, y, z) => {
    if (x < 0 || z < 0 || x >= W || z >= D || y >= H) return false;
    if (y < 0) return true;
    return side[vi(x, y, z)] !== 0;
  };
  const voidAt = (x, z) => x < 0 || z < 0 || x >= W || z >= D || cell[x + z * W] === C.VOID;

  // deslocamento organico: cada canto da grade se move de forma deterministica (malha continua sem frestas)
  const hh = (a, b, c, s) => { let n = (a * 374761393 + b * 668265263 + c * 2147483647 + s * 1274126177) | 0; n = (n ^ (n >>> 13)) * 1274126177; return ((n ^ (n >>> 16)) >>> 0) / 4294967296 - 0.5; };
  const AH = theme.hub ? 0.1 : 0.16, AV = 0.22;
  const disp = (X, Y, Z, out) => {
    const up = Y > OFF + 1;
    out[0] = X + hh(X, Y, Z, 1) * AH * (up ? 1.25 : 1);
    out[1] = Y - OFF + (up ? hh(X, Y, Z, 2) * AV : 0);
    out[2] = Z + hh(X, Y, Z, 3) * AH * (up ? 1.25 : 1);
    return out;
  };
  const dv = [0, 0, 0];
  const atlas = getAtlas();
  const material = new THREE.MeshStandardMaterial({
    map: atlas.map, normalMap: atlas.normalMap, roughnessMap: atlas.roughnessMap,
    emissiveMap: atlas.emissiveMap, emissive: 0xffffff, emissiveIntensity: 1.6,
    vertexColors: true, metalness: 0, normalScale: new THREE.Vector2(1.1, 1.1),
  });
  patchMirror(material);
  const group = new THREE.Group();

  for (let cz = 0; cz < D; cz += CH) for (let cx = 0; cx < W; cx += CH) {
    const pos = [], uvs = [], col = [], ind = [];
    for (let z = cz; z < Math.min(D, cz + CH); z++) for (let x = cx; x < Math.min(W, cx + CH); x++) for (let y = 0; y < H; y++) {
      const i = vi(x, y, z);
      if (!side[i]) continue;
      for (const f of FACES) {
        const [dx, dy, dz] = f.dir;
        if (solidAt(x + dx, y + dy, z + dz)) continue;
        const tile = (f.top ? top[i] : side[i]) - 1;
        const [u0, v0, u1, v1] = atlas.uv(tile);
        let tint = 0.88 + hash2(x * 3 + y, z * 5 + y, seed) * 0.18;
        if (!f.top && voidAt(x + dx, z + dz)) tint *= 0.28;
        if (!f.top) tint *= 0.78 + 0.22 * Math.min(1, Math.max(0, (y - OFF + 1) / 3));
        const a = f.dir[0] ? 0 : f.dir[1] ? 1 : 2;
        const ua = (a + 1) % 3, va = (a + 2) % 3;
        const ao = [];
        const base = pos.length / 3;
        for (const c of f.c) {
          const p = [c[0], c[1], c[2]];
          const off = [x + dx, y + dy, z + dz];
          const du = [0, 0, 0], dv = [0, 0, 0];
          du[ua] = p[ua] ? 1 : -1; dv[va] = p[va] ? 1 : -1;
          const s1 = solidAt(off[0] + du[0], off[1] + du[1], off[2] + du[2]) ? 1 : 0;
          const s2 = solidAt(off[0] + dv[0], off[1] + dv[1], off[2] + dv[2]) ? 1 : 0;
          const cc = solidAt(off[0] + du[0] + dv[0], off[1] + du[1] + dv[1], off[2] + du[2] + dv[2]) ? 1 : 0;
          const lvl = s1 && s2 ? 0 : 3 - (s1 + s2 + cc);
          ao.push(lvl);
          disp(x + c[0], y + c[1], z + c[2], dv);
          pos.push(dv[0], dv[1], dv[2]);
          uvs.push(u0 + c[3] * (u1 - u0), v0 + c[4] * (v1 - v0));
          const k = AO[lvl] * tint;
          col.push(k, k, k);
        }
        if (ao[0] + ao[3] > ao[1] + ao[2]) ind.push(base, base + 1, base + 3, base, base + 3, base + 2);
        else ind.push(base, base + 1, base + 2, base + 2, base + 1, base + 3);
      }
    }
    if (!pos.length) continue;
    const g = new THREE.BufferGeometry();
    g.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3));
    g.setAttribute('uv', new THREE.Float32BufferAttribute(uvs, 2));
    g.setAttribute('color', new THREE.Float32BufferAttribute(col, 3));
    g.setIndex(ind);
    g.computeVertexNormals();
    g.computeBoundingSphere();
    const m = new THREE.Mesh(g, material);
    m.castShadow = true; m.receiveShadow = true;
    group.add(m);
  }

  // ---- lava e agua ----
  const liquids = [];
  const mkPlane = (type, y) => {
    const pos = [], uvs = [], ind = [];
    for (let z = 0; z < D; z++) for (let x = 0; x < W; x++) {
      if (cell[x + z * W] !== type) continue;
      // quadrados alargados cobrem as bordas deformadas; o UV vem da posicao no mundo, entao a parte
      // sobreposta e identica nos dois lados (sem cintilar)
      const b = pos.length / 3, e = 0.22;
      const x0 = x - e, x1 = x + 1 + e, z0 = z - e, z1 = z + 1 + e;
      pos.push(x0, y, z1, x1, y, z1, x0, y, z0, x1, y, z0);
      uvs.push(x0 * 0.25, z1 * 0.25, x1 * 0.25, z1 * 0.25, x0 * 0.25, z0 * 0.25, x1 * 0.25, z0 * 0.25);
      ind.push(b, b + 1, b + 2, b + 2, b + 1, b + 3);
    }
    if (!pos.length) return null;
    const g = new THREE.BufferGeometry();
    g.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3));
    g.setAttribute('uv', new THREE.Float32BufferAttribute(uvs, 2));
    g.setIndex(ind); g.computeVertexNormals(); g.computeBoundingSphere();
    return g;
  };
  let lavaMat = null, waterMat = null;
  const lg = mkPlane(C.LAVA, -0.82);
  if (lg) {
    const lt = lavaTexture();
    lavaMat = new THREE.MeshStandardMaterial({ map: lt, emissiveMap: lt, emissive: 0xffffff, emissiveIntensity: 0.95, roughness: 0.7 });
    const m = new THREE.Mesh(lg, lavaMat); m.receiveShadow = false; group.add(m); liquids.push(m);
  }
  const wg = mkPlane(C.WATER, theme.shallow ? -0.12 : -0.32);
  if (wg) {
    const wn = waterNormal();
    wn.repeat.set(0.6, 0.6);
    waterMat = new THREE.MeshStandardMaterial({ color: theme.water || 0x0b2428, roughness: 0.05, metalness: 0.0, normalMap: wn, normalScale: new THREE.Vector2(0.35, 0.35) });
    patchMirror(waterMat, { water: true });
    const m = new THREE.Mesh(wg, waterMat); m.receiveShadow = true; group.add(m); liquids.push(m);
  }

  const update = (t) => {
    if (lavaMat) { lavaMat.map.offset.set(Math.sin(t * 0.05) * 0.3, t * 0.02); lavaMat.emissiveIntensity = 0.95 + Math.sin(t * 1.3) * 0.12; }
    if (waterMat) { waterMat.normalMap.offset.set(t * 0.02, t * 0.013); }
  };
  const dispose = () => {
    group.traverse(o => { if (o.geometry) o.geometry.dispose(); });
    material.dispose(); if (lavaMat) { lavaMat.map.dispose(); lavaMat.dispose(); } if (waterMat) { waterMat.normalMap.dispose(); waterMat.dispose(); }
  };
  return { group, update, dispose, material };
}
