// Objetos de cenario (estaticos, mesclados por material) e objetos interativos.
import * as THREE from 'three';
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js';
import { tileTexture, charTex, cobwebTexture, bannerTexture } from './textures.js';
import { RNG } from './util.js';

let _mats = null;
export function propMats() {
  if (_mats) return _mats;
  const std = (o) => new THREE.MeshStandardMaterial(o);
  const planks = tileTexture('planks'), logt = tileTexture('log_side'), brick = tileTexture('brick'), stone = tileTexture('stone');
  const iron = charTex('iron'), bone = charTex('bone'), gold = charTex('gold');
  _mats = {
    wood: std({ map: planks.map, normalMap: planks.normalMap, roughnessMap: planks.roughnessMap }),
    darkwood: std({ map: logt.map, normalMap: logt.normalMap, color: 0x8a7a6a, roughness: 0.9 }),
    iron: std({ map: iron.map, roughnessMap: iron.roughnessMap, metalness: 0.75 }),
    bone: std({ map: bone.map, roughness: 0.75 }),
    stone: std({ map: brick.map, normalMap: brick.normalMap, roughnessMap: brick.roughnessMap }),
    rock: std({ map: stone.map, normalMap: stone.normalMap, roughness: 0.95 }),
    gold: std({ map: gold.map, roughnessMap: gold.roughnessMap, metalness: 1 }),
    wax: std({ color: 0xe6d9bc, roughness: 0.55 }),
    clay: std({ color: 0x8a4a2a, roughness: 0.85 }),
    clay2: std({ color: 0x6e5a3e, roughness: 0.85 }),
    crystal: std({ color: 0x5fc6ef, emissive: 0x1a8cc6, emissiveIntensity: 0.9, roughness: 0.15, metalness: 0.1, transparent: true, opacity: 0.92 }),
    ore: std({ color: 0xd8a640, metalness: 0.9, roughness: 0.35 }),
    dark: std({ color: 0x050505, roughness: 1 }),
    web: new THREE.MeshBasicMaterial({ map: cobwebTexture(), transparent: true, depthWrite: false, side: THREE.DoubleSide, opacity: 0.8 }),
    banners: [0, 1, 2].map(e => std({ map: bannerTexture(['#6d1510', '#1b2d5e', '#2a3d1c'][e], e), transparent: true, alphaTest: 0.5, side: THREE.DoubleSide, roughness: 0.95 })),
  };
  return _mats;
}

let _flameTex = null;
export function flameTexture() {
  if (_flameTex) return _flameTex;
  const c = document.createElement('canvas'); c.width = 64; c.height = 128;
  const g = c.getContext('2d');
  const gr = g.createRadialGradient(32, 88, 2, 32, 76, 40);
  gr.addColorStop(0, 'rgba(255,250,220,1)'); gr.addColorStop(0.25, 'rgba(255,200,90,0.95)');
  gr.addColorStop(0.55, 'rgba(255,110,20,0.55)'); gr.addColorStop(1, 'rgba(255,60,0,0)');
  g.fillStyle = gr;
  g.beginPath(); g.moveTo(32, 4); g.bezierCurveTo(58, 60, 60, 110, 32, 124); g.bezierCurveTo(4, 110, 6, 60, 32, 4); g.fill();
  _flameTex = new THREE.CanvasTexture(c); _flameTex.colorSpace = THREE.SRGBColorSpace;
  return _flameTex;
}
export function makeFlame(scale = 1, color = 0xffffff) {
  const m = new THREE.SpriteMaterial({ map: flameTexture(), color, blending: THREE.AdditiveBlending, depthWrite: false, transparent: true });
  const s = new THREE.Sprite(m);
  s.scale.set(0.34 * scale, 0.6 * scale, 1);
  s.userData.base = scale;
  return s;
}

class Builder {
  constructor() { this.parts = new Map(); this.m = new THREE.Matrix4(); }
  add(geo, matKey, x, y, z, rx = 0, ry = 0, rz = 0, sx = 1, sy = 1, sz = 1) {
    const g = geo.clone();
    const e = new THREE.Euler(rx, ry, rz, 'YXZ');
    this.m.compose(new THREE.Vector3(x, y, z), new THREE.Quaternion().setFromEuler(e), new THREE.Vector3(sx, sy, sz));
    g.applyMatrix4(this.m);
    if (!this.parts.has(matKey)) this.parts.set(matKey, []);
    this.parts.get(matKey).push(g);
  }
  // peca relativa a um objeto o = {x, y, z, rot, s}; (sx, sy, sz) = tamanho
  local(geo, matKey, o, lx, ly, lz, sx, sy, sz, rx = 0, ry = 0, rz = 0) {
    const c = Math.cos(o.rot), sn = Math.sin(o.rot), k = o.s || 1;
    const wx = o.x + (lx * c + lz * sn) * k, wz = o.z + (-lx * sn + lz * c) * k;
    this.add(geo, matKey, wx, o.y + ly * k, wz, rx, o.rot + ry, rz, sx * k, sy * k, sz * k);
  }
  bake(mats) {
    const group = new THREE.Group();
    for (const [key, list] of this.parts) {
      const geos = list.map(g => (g.index ? g.toNonIndexed() : g));
      for (const g of geos) for (const k of Object.keys(g.attributes)) if (!['position', 'normal', 'uv'].includes(k)) g.deleteAttribute(k);
      const merged = mergeGeometries(geos, false);
      const mat = key.startsWith('banner') ? mats.banners[+key.slice(6)] : mats[key];
      const mesh = new THREE.Mesh(merged, mat);
      mesh.castShadow = key !== 'web' && !key.startsWith('banner');
      mesh.receiveShadow = true;
      group.add(mesh);
      list.forEach(g => g.dispose());
    }
    return group;
  }
}

const G = {
  box: new THREE.BoxGeometry(1, 1, 1),
  cyl: new THREE.CylinderGeometry(0.5, 0.5, 1, 12),
  cyl6: new THREE.CylinderGeometry(0.5, 0.5, 1, 6),
  barrel: new THREE.CylinderGeometry(0.3, 0.3, 0.82, 14),
  cone: new THREE.ConeGeometry(0.5, 1, 6),
  plane: new THREE.PlaneGeometry(1, 1),
  sphere: new THREE.SphereGeometry(0.5, 8, 6),
};

export function buildStaticProps(dg) {
  const B = new Builder();
  const rng = new RNG(dg.seed + 555);
  const flames = [], lights = [];
  const addLight = (x, y, z, color, intensity, dist, flicker = 1) => lights.push({ x, y, z, color, intensity, dist, flicker, phase: rng.range(0, 100) });

  for (const t of dg.torches) {
    const rot = Math.atan2(t.nx, t.nz);
    B.add(G.box, 'iron', t.x - t.nx * 0.1, t.y - 0.35, t.z - t.nz * 0.1, 0, rot, 0, 0.16, 0.3, 0.04);
    B.add(G.cyl6, 'darkwood', t.x - t.nx * 0.04, t.y - 0.2, t.z - t.nz * 0.04, 0.35, rot, 0, 0.07, 0.5, 0.07);
    B.add(G.cyl6, 'iron', t.x, t.y + 0.04, t.z, 0, 0, 0, 0.15, 0.1, 0.15);
    const f = makeFlame(1, 0xffe0b0);
    f.position.set(t.x + t.nx * 0.02, t.y + 0.3, t.z + t.nz * 0.02);
    flames.push(f);
    addLight(t.x + t.nx * 0.35, t.y + 0.35, t.z + t.nz * 0.35, dg.theme.torch, 14, 10);
  }
  for (const b of dg.banners) {
    const rot = Math.atan2(b.nx, b.nz);
    const k = rng.int(0, 2);
    B.add(G.plane, 'banner' + k, b.x, b.y - 0.7, b.z, 0, rot, 0, 0.8, 1.6, 1);
    B.add(G.cyl6, 'iron', b.x + b.nx * 0.03, b.y + 0.12, b.z + b.nz * 0.03, 0, rot, Math.PI / 2, 0.05, 1.0, 0.05);
  }
  for (const w of dg.cobwebs) B.add(G.plane, 'web', w.x + 0.4, w.y + 2.9, w.z + 0.4, -0.6, Math.PI / 4, 0, 1.3, 1.3, 1);

  for (const p of dg.props) {
    switch (p.type) {
      case 'barrel':
        B.local(G.barrel, 'wood', p, 0, 0.41, 0, 1, 1, 1);
        B.local(G.cyl, 'iron', p, 0, 0.2, 0, 0.635, 0.05, 0.635);
        B.local(G.cyl, 'iron', p, 0, 0.62, 0, 0.635, 0.05, 0.635);
        B.local(G.cyl, 'darkwood', p, 0, 0.825, 0, 0.56, 0.02, 0.56);
        break;
      case 'crate':
        B.local(G.box, 'wood', p, 0, 0.36, 0, 0.72, 0.72, 0.72);
        for (const [cx, cz] of [[-1, -1], [1, -1], [-1, 1], [1, 1]]) B.local(G.box, 'darkwood', p, cx * 0.33, 0.36, cz * 0.33, 0.09, 0.74, 0.09);
        B.local(G.box, 'darkwood', p, 0, 0.36, 0.365, 0.9, 0.08, 0.02, 0, 0, 0.78);
        break;
      case 'bones':
        for (let i = 0; i < 5; i++) {
          const a = rng.range(0, Math.PI * 2), r = rng.range(0, 0.3);
          B.local(G.cyl6, 'bone', p, Math.cos(a) * r, 0.03, Math.sin(a) * r, 0.05, rng.range(0.25, 0.45), 0.05, Math.PI / 2, rng.range(0, 3), 0);
        }
        if (rng.chance(0.6)) skull(B, p, rng.range(-0.2, 0.2), rng.range(-0.2, 0.2));
        break;
      case 'skull': skull(B, p, 0, 0); break;
      case 'candles': {
        const n = rng.int(3, 5);
        const c = Math.cos(p.rot), s = Math.sin(p.rot);
        for (let i = 0; i < n; i++) {
          const a = rng.range(0, Math.PI * 2), r = rng.range(0.05, 0.3), hh = rng.range(0.15, 0.4);
          const lx = Math.cos(a) * r, lz = Math.sin(a) * r;
          B.local(G.cyl, 'wax', p, lx, hh / 2, lz, 0.07, hh, 0.07);
          const f = makeFlame(0.28, 0xfff0c0);
          f.position.set(p.x + (lx * c + lz * s) * p.s, p.y + (hh + 0.07) * p.s, p.z + (-lx * s + lz * c) * p.s);
          flames.push(f);
        }
        addLight(p.x, p.y + 0.6, p.z, 0xffc070, 4, 5, 0.6);
        break;
      }
      case 'rubble':
        for (let i = 0; i < 6; i++) {
          const sz = rng.range(0.12, 0.34);
          B.local(G.box, 'rock', p, rng.range(-0.35, 0.35), sz * 0.4, rng.range(-0.35, 0.35), sz, sz, sz, rng.range(0, 1), rng.range(0, 3), rng.range(0, 1));
        }
        break;
      case 'coffin':
        B.local(G.box, 'darkwood', p, 0, 0.22, 0, 0.7, 0.44, 1.6);
        B.local(G.box, 'darkwood', p, 0.06, 0.48, 0.05, 0.74, 0.08, 1.64, 0, 0.12, 0.04);
        B.local(G.box, 'iron', p, 0.06, 0.53, 0.2, 0.07, 0.02, 0.55, 0, 0.12, 0.04);
        B.local(G.box, 'iron', p, 0.06, 0.53, 0.32, 0.32, 0.02, 0.07, 0, 0.12, 0.04);
        break;
      case 'crystal': {
        const n = rng.int(3, 5);
        for (let i = 0; i < n; i++) {
          const a = rng.range(0, Math.PI * 2), hh = rng.range(0.5, 1.2);
          B.local(G.cone, 'crystal', p, Math.cos(a) * 0.15, hh / 2 - 0.05, Math.sin(a) * 0.15, 0.3, hh, 0.3, Math.cos(a) * 0.4, 0, Math.sin(a) * 0.4);
        }
        break;
      }
      case 'cart':
        B.local(G.box, 'iron', p, 0, 0.45, 0, 1.0, 0.5, 0.7);
        for (const [wx, wz] of [[-0.35, 0.38], [0.35, 0.38], [-0.35, -0.38], [0.35, -0.38]]) B.local(G.cyl, 'iron', p, wx, 0.16, wz, 0.32, 0.08, 0.32, Math.PI / 2);
        for (let i = 0; i < 6; i++) B.local(G.sphere, 'ore', p, rng.range(-0.3, 0.3), 0.72, rng.range(-0.2, 0.2), 0.26, 0.22, 0.26);
        break;
      case 'anvil':
        B.local(G.box, 'rock', p, 0, 0.2, 0, 0.45, 0.4, 0.45);
        B.local(G.box, 'iron', p, 0, 0.47, 0, 0.26, 0.16, 0.2);
        B.local(G.box, 'iron', p, 0, 0.6, 0, 0.7, 0.18, 0.3);
        B.local(G.cone, 'iron', p, 0.5, 0.62, 0, 0.2, 0.34, 0.2, 0, 0, -Math.PI / 2);
        break;
    }
  }
  const group = B.bake(propMats());
  return { group, flames, lights };
}

function skull(B, p, lx, lz) {
  const o = { ...p, rot: p.rot + 0.5 };
  B.local(G.box, 'bone', o, lx, 0.1, lz, 0.22, 0.2, 0.25);
  B.local(G.box, 'dark', o, lx - 0.05, 0.12, lz + 0.121, 0.06, 0.05, 0.02);
  B.local(G.box, 'dark', o, lx + 0.05, 0.12, lz + 0.121, 0.06, 0.05, 0.02);
}
