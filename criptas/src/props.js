// Objetos de cenario (estaticos, mesclados por material): formas arredondadas e organicas.
import * as THREE from 'three';
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js';
import { tileTexture, charTex, cobwebTexture, bannerTexture } from './textures.js';
import { GEO, lathe, limb, taperTube, rock, extrude } from './geo.js';
import { RNG } from './util.js';

let _mats = null;
export function propMats() {
  if (_mats) return _mats;
  const std = (o) => new THREE.MeshStandardMaterial(o);
  const phys = (o) => new THREE.MeshPhysicalMaterial(o);
  const ct = (k) => charTex(k);
  const planks = tileTexture('planks'), logt = tileTexture('log_side'), brick = tileTexture('brick'), stone = tileTexture('stone'), basalt = tileTexture('basalt'), moss = tileTexture('mossstone'), vc = tileTexture('voidcrystal');
  const iron = ct('iron'), bone = ct('bone'), gold = ct('gold'), cloth = ct('cloth_white'), clothR = ct('cloth_red'), plant = ct('plant'), plantD = ct('plant_dark');
  _mats = {
    wood: std({ map: planks.map, normalMap: planks.normalMap, roughnessMap: planks.roughnessMap }),
    darkwood: std({ map: logt.map, normalMap: logt.normalMap, color: 0x8a7a6a, roughness: 0.9 }),
    log: std({ map: logt.map, normalMap: logt.normalMap, roughness: 0.92 }),
    iron: std({ map: iron.map, roughnessMap: iron.roughnessMap, normalMap: iron.normalMap, metalness: 0.75 }),
    bone: std({ map: bone.map, normalMap: bone.normalMap, roughness: 0.7 }),
    stone: std({ map: brick.map, normalMap: brick.normalMap, roughnessMap: brick.roughnessMap }),
    rock: std({ map: stone.map, normalMap: stone.normalMap, roughness: 0.95 }),
    basalt: std({ map: basalt.map, normalMap: basalt.normalMap, roughness: 0.8 }),
    moss: std({ map: moss.map, normalMap: moss.normalMap, roughness: 0.95 }),
    gold: std({ map: gold.map, roughnessMap: gold.roughnessMap, normalMap: gold.normalMap, metalness: 1 }),
    wax: phys({ color: 0xe6d9bc, roughness: 0.45, sheen: 0.5 }),
    clay: std({ color: 0x8a4a2a, roughness: 0.8 }),
    clay2: std({ color: 0x6e5a3e, roughness: 0.8 }),
    bronze: std({ color: 0x8a6a3a, metalness: 0.85, roughness: 0.35 }),
    crystal: phys({ color: 0x5fc6ef, emissive: 0x1a8cc6, emissiveIntensity: 0.9, roughness: 0.08, clearcoat: 1, transparent: true, opacity: 0.9 }),
    crystalV: phys({ map: vc.map, color: 0xb080ff, emissive: 0x6a2ad0, emissiveIntensity: 1.1, roughness: 0.1, clearcoat: 1 }),
    ice: phys({ color: 0xbfe6f8, roughness: 0.05, clearcoat: 1, clearcoatRoughness: 0.03, transparent: true, opacity: 0.82, emissive: 0x1a3a50, emissiveIntensity: 0.3 }),
    ore: std({ color: 0xd8a640, metalness: 0.9, roughness: 0.35 }),
    dark: std({ color: 0x050505, roughness: 1 }),
    cloth: std({ map: cloth.map, normalMap: cloth.normalMap, roughness: 0.95, side: THREE.DoubleSide }),
    clothRed: std({ map: clothR.map, normalMap: clothR.normalMap, roughness: 0.95, side: THREE.DoubleSide }),
    paper: std({ color: 0xe8dcc0, roughness: 0.9, side: THREE.DoubleSide }),
    plant: std({ map: plant.map, normalMap: plant.normalMap, roughness: 0.85, side: THREE.DoubleSide }),
    plantDark: std({ map: plantD.map, normalMap: plantD.normalMap, roughness: 0.9 }),
    reed: std({ color: 0x5a6a2a, roughness: 0.8 }),
    shroom: std({ color: 0x8ad8b0, emissive: 0x30c880, emissiveIntensity: 0.55, roughness: 0.5 }),
    shroomStem: std({ color: 0xd8d0b8, roughness: 0.7 }),
    rune: std({ color: 0xc080ff, emissive: 0xa050ff, emissiveIntensity: 3 }),
    ember: std({ color: 0xff6a20, emissive: 0xff5010, emissiveIntensity: 3 }),
    thorn: std({ color: 0x2a3a18, roughness: 0.6 }),
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
  constructor() { this.parts = new Map(); this.m = new THREE.Matrix4(); this.q = new THREE.Quaternion(); this.e = new THREE.Euler(); this.p = new THREE.Vector3(); this.s = new THREE.Vector3(); }
  add(geo, matKey, x, y, z, rx = 0, ry = 0, rz = 0, sx = 1, sy = 1, sz = 1) {
    const g = geo.index ? geo.toNonIndexed() : geo.clone();
    this.e.set(rx, ry, rz, 'YXZ');
    this.m.compose(this.p.set(x, y, z), this.q.setFromEuler(this.e), this.s.set(sx, sy, sz));
    g.applyMatrix4(this.m);
    if (!this.parts.has(matKey)) this.parts.set(matKey, []);
    this.parts.get(matKey).push(g);
  }
  local(geo, matKey, o, lx, ly, lz, sx, sy, sz, rx = 0, ry = 0, rz = 0) {
    const c = Math.cos(o.rot), sn = Math.sin(o.rot), k = o.s || 1;
    const wx = o.x + (lx * c + lz * sn) * k, wz = o.z + (-lx * sn + lz * c) * k;
    this.add(geo, matKey, wx, o.y + ly * k, wz, rx, o.rot + ry, rz, sx * k, sy * k, sz * k);
  }
  bake(mats) {
    const group = new THREE.Group();
    for (const [key, list] of this.parts) {
      for (const g of list) {
        for (const k of Object.keys(g.attributes)) if (!['position', 'normal', 'uv'].includes(k)) g.deleteAttribute(k);
        if (!g.attributes.uv) g.setAttribute('uv', new THREE.Float32BufferAttribute(new Float32Array(g.attributes.position.count * 2), 2));
      }
      const merged = mergeGeometries(list, false);
      const mat = key.startsWith('banner') ? mats.banners[+key.slice(6)] : mats[key];
      const mesh = new THREE.Mesh(merged, mat);
      mesh.castShadow = !['web', 'shroom', 'rune', 'ember'].includes(key) && !key.startsWith('banner');
      mesh.receiveShadow = true;
      mesh.userData.propKey = key;
      group.add(mesh);
      list.forEach(g => g.dispose());
    }
    return group;
  }
}

const G = {
  box: new THREE.BoxGeometry(1, 1, 1),
  cyl: new THREE.CylinderGeometry(0.5, 0.5, 1, 16),
  cyl6: new THREE.CylinderGeometry(0.5, 0.5, 1, 6),
  cone: new THREE.ConeGeometry(0.5, 1, 12),
  cone6: new THREE.ConeGeometry(0.5, 1, 6),
  plane: new THREE.PlaneGeometry(1, 1),
  sphere: new THREE.SphereGeometry(0.5, 16, 12),
  torus: new THREE.TorusGeometry(0.5, 0.06, 8, 24),
  capsule: new THREE.CapsuleGeometry(0.5, 1, 4, 10),
  circle: new THREE.CircleGeometry(0.5, 16),
  rbox: GEO.rbox(1, 1, 1, 0.08),
  rbox2: GEO.rbox(1, 1, 1, 0.2),
};
const BARREL = lathe('barrel', [[0, 0], [0.27, 0], [0.3, 0.12], [0.33, 0.41], [0.3, 0.7], [0.27, 0.82], [0, 0.82]], 18);
const URN = lathe('urn', [[0, 0], [0.12, 0], [0.16, 0.06], [0.22, 0.22], [0.2, 0.4], [0.1, 0.52], [0.09, 0.6], [0.13, 0.64], [0, 0.64]], 16);
const PLINTH = lathe('plinth', [[0, 0], [0.5, 0], [0.5, 0.12], [0.42, 0.18], [0.42, 0.26], [0.36, 0.32], [0, 0.32]], 20);
const CAPITAL = lathe('capital', [[0, 0], [0.34, 0], [0.4, 0.08], [0.48, 0.14], [0.5, 0.24], [0, 0.24]], 20);
const SHAFT = lathe('shaft', [[0, 0], [0.36, 0], [0.37, 0.8], [0.35, 2.2], [0.32, 3.2], [0, 3.2]], 20);
const SHROOM = lathe('shroomcap', [[0, 0.02], [0.3, 0.0], [0.34, 0.05], [0.3, 0.14], [0.18, 0.22], [0, 0.25]], 18);
const BOWL = lathe('forge', [[0, 0], [0.7, 0], [0.75, 0.3], [0.68, 0.9], [0.4, 1.3], [0.25, 1.6], [0.25, 2.4], [0, 2.4]], 16);
const COFFIN = extrude('coffin', s => { s.moveTo(0, -0.8); s.lineTo(0.22, -0.8); s.lineTo(0.36, 0.25); s.lineTo(0.26, 0.8); s.lineTo(-0.26, 0.8); s.lineTo(-0.36, 0.25); s.lineTo(-0.22, -0.8); s.lineTo(0, -0.8); }, 0.4, 0.03);
const ANVIL = extrude('anvil', s => { s.moveTo(-0.15, 0); s.lineTo(0.15, 0); s.lineTo(0.12, 0.12); s.lineTo(0.3, 0.2); s.lineTo(0.3, 0.3); s.lineTo(0.55, 0.3); s.quadraticCurveTo(0.35, 0.22, 0.2, 0.2); s.lineTo(-0.3, 0.2); s.lineTo(-0.35, 0.3); s.lineTo(-0.3, 0.2); s.lineTo(-0.12, 0.12); s.lineTo(-0.15, 0); }, 0.22, 0.02);

export function buildStaticProps(dg) {
  const B = new Builder();
  const rng = new RNG(dg.seed + 555);
  const flames = [], lights = [];
  const addLight = (x, y, z, color, intensity, dist, flicker = 1) => lights.push({ x, y, z, color, intensity, dist, flicker, phase: rng.range(0, 100) });
  const th = dg.theme;

  for (const t of dg.torches) {
    const rot = Math.atan2(t.nx, t.nz);
    const o = { x: t.x - t.nx * 0.08, y: t.y - 0.45, z: t.z - t.nz * 0.08, rot, s: 1 };
    B.local(taperTube('bracket', [[0, 0.1, -0.16], [0, 0.0, -0.05], [0, 0.12, 0.04], [0, 0.3, 0.05]], 0.02, 0.018, 12, 6, false), 'iron', o, 0, 0, 0, 1, 1, 1);
    B.local(G.cyl, 'darkwood', o, 0, 0.35, 0.05, 0.07, 0.42, 0.07, 0.25, 0, 0);
    B.local(G.torus, 'clothRed', o, 0, 0.52, 0.1, 0.12, 0.12, 0.2, Math.PI / 2 + 0.25, 0, 0);
    B.local(G.sphere, 'darkwood', o, 0, 0.58, 0.11, 0.13, 0.1, 0.13);
    const f = makeFlame(1, 0xffe0b0);
    f.position.set(t.x + t.nx * 0.03, t.y + 0.35, t.z + t.nz * 0.03);
    flames.push(f);
    addLight(t.x + t.nx * 0.35, t.y + 0.35, t.z + t.nz * 0.35, th.torch, 14, 10);
  }
  for (const b of dg.banners) {
    const rot = Math.atan2(b.nx, b.nz);
    const k = rng.int(0, 2);
    B.add(G.plane, 'banner' + k, b.x, b.y - 0.7, b.z, 0, rot, 0, 0.8, 1.6, 1);
    B.add(G.cyl, 'iron', b.x + b.nx * 0.03, b.y + 0.12, b.z + b.nz * 0.03, 0, rot, Math.PI / 2, 0.05, 1.0, 0.05);
    for (const s of [-1, 1]) B.add(G.sphere, 'gold', b.x + b.nx * 0.03 + Math.cos(rot) * s * 0.5, b.y + 0.12, b.z + b.nz * 0.03 - Math.sin(rot) * s * 0.5, 0, 0, 0, 0.08, 0.08, 0.08);
  }
  for (const w of dg.cobwebs) B.add(G.plane, 'web', w.x + 0.4, w.y + 2.9, w.z + 0.4, -0.6, Math.PI / 4, 0, 1.3, 1.3, 1);

  // colunas redondas
  const pst = th.pillarStyle || 'stone';
  for (const p of dg.pillars) {
    const o = { x: p.x, y: p.y, z: p.z, rot: rng.range(0, 6.28), s: 1 };
    if (pst === 'stone') {
      B.local(PLINTH, 'stone', o, 0, 0, 0, 1, 1, 1);
      B.local(SHAFT, 'rock', o, 0, 0.3, 0, 1, 1, 1);
      B.local(CAPITAL, 'stone', o, 0, 3.5, 0, 1, 1, 1);
      B.local(G.rbox, 'stone', o, 0, 3.8, 0, 1.05, 0.2, 1.05);
    } else if (pst === 'wood') {
      B.local(G.cyl, 'log', o, 0, 2, 0, 0.62, 4, 0.62);
      for (const y of [0.4, 3.2]) B.local(G.torus, 'iron', o, 0, y, 0, 0.66, 0.66, 1.2, Math.PI / 2, 0, 0);
      B.local(G.rbox, 'wood', o, 0, 3.75, 0, 1.2, 0.22, 0.3);
      for (const s of [-1, 1]) B.local(G.rbox, 'wood', o, s * 0.35, 3.35, 0, 0.12, 0.7, 0.12, 0, 0, s * 0.7);
    } else if (pst === 'basalt') {
      for (let i = 0; i < 3; i++) { const a = i * 2.1, hh = 3.2 + rng.range(0, 1); B.local(G.cyl6, 'basalt', o, Math.cos(a) * 0.2, hh / 2, Math.sin(a) * 0.2, 0.46, hh, 0.46, 0, a, 0); }
      B.local(G.cyl6, 'ember', o, 0, 1.2, 0, 0.6, 0.04, 0.6);
    } else if (pst === 'ice') {
      B.local(lathe('icecol', [[0, 0], [0.55, 0], [0.4, 0.6], [0.3, 2], [0.36, 3.2], [0.5, 3.9], [0, 3.95]], 12), 'ice', o, 0, 0, 0, 1, 1, 1);
      for (let i = 0; i < 4; i++) { const a = i * 1.6 + 0.3; B.local(G.cone6, 'ice', o, Math.cos(a) * 0.45, 0.35, Math.sin(a) * 0.45, 0.18, 0.8, 0.18, Math.sin(a) * 0.5, 0, -Math.cos(a) * 0.5); }
    } else if (pst === 'tree') {
      B.local(taperTube('trunk' + (p.x | 0) % 3, [[0, 0, 0], [0.1, 1.2, 0.05], [-0.1, 2.5, 0], [0.05, 4, 0.1]], 0.42, 0.26, 16, 12), 'log', o, 0, 0, 0, 1, 1, 1);
      for (let i = 0; i < 5; i++) { const a = i * 1.26; B.local(taperTube('root' + i, [[0, 0.5, 0], [Math.cos(a) * 0.45, 0.2, Math.sin(a) * 0.45], [Math.cos(a) * 0.8, -0.05, Math.sin(a) * 0.8]], 0.14, 0.03, 8, 6), 'log', o, 0, 0, 0, 1, 1, 1); }
      for (let i = 0; i < 3; i++) { const a = i * 2.1 + 0.5; B.local(taperTube('branch' + i, [[0, 3.2, 0], [Math.cos(a) * 0.5, 3.6, Math.sin(a) * 0.5], [Math.cos(a) * 1.1, 3.9, Math.sin(a) * 1.1]], 0.12, 0.02, 10, 6), 'log', o, 0, 0, 0, 1, 1, 1); }
      B.local(G.sphere, 'plant', o, 0, 3.9, 0, 1.6, 0.5, 1.6);
    } else if (pst === 'crystal') {
      for (let i = 0; i < 4; i++) {
        const a = i * 1.57 + 0.4, hh = 2.6 + (i === 0 ? 1.3 : rng.range(0, 1)), r = i === 0 ? 0 : 0.25;
        const tx = Math.sin(a) * 0.25 * (i ? 1 : 0), tz = Math.cos(a) * 0.25 * (i ? 1 : 0);
        B.local(G.cyl6, 'crystalV', o, Math.cos(a) * r, hh / 2, Math.sin(a) * r, i ? 0.32 : 0.5, hh, i ? 0.32 : 0.5, tz * 0.4, 0, -tx * 0.4);
        B.local(G.cone6, 'crystalV', o, Math.cos(a) * r + tx * hh * 0.2, hh + 0.25, Math.sin(a) * r + tz * hh * 0.2, i ? 0.32 : 0.5, 0.5, i ? 0.32 : 0.5, tz * 0.4, 0, -tx * 0.4);
      }
      addLight(p.x, p.y + 2.5, p.z, 0xa060ff, 5, 7, 0.2);
    }
  }

  for (const p of dg.props) {
    const s = new RNG(p.seed || 1);
    switch (p.type) {
      case 'barrel':
        B.local(BARREL, 'wood', p, 0, 0, 0, 1, 1, 1);
        for (const y of [0.14, 0.68]) B.local(G.torus, 'iron', p, 0, y, 0, 0.62, 0.62, 0.9, Math.PI / 2, 0, 0);
        B.local(G.cyl, 'darkwood', p, 0, 0.815, 0, 0.54, 0.02, 0.54);
        break;
      case 'crate':
        B.local(G.rbox, 'wood', p, 0, 0.36, 0, 0.72, 0.72, 0.72);
        for (const [cx, cz] of [[-1, -1], [1, -1], [-1, 1], [1, 1]]) B.local(G.rbox, 'darkwood', p, cx * 0.33, 0.36, cz * 0.33, 0.1, 0.75, 0.1);
        B.local(G.rbox, 'darkwood', p, 0, 0.36, 0.36, 0.9, 0.08, 0.03, 0, 0, 0.78);
        break;
      case 'bones':
        for (let i = 0; i < 5; i++) {
          const a = s.range(0, Math.PI * 2), r = s.range(0, 0.3), len = s.range(0.2, 0.36);
          B.local(G.capsule, 'bone', p, Math.cos(a) * r, 0.03, Math.sin(a) * r, 0.035, len * 0.7, 0.035, Math.PI / 2, s.range(0, 3), 0);
        }
        if (s.chance(0.6)) skull(B, p, s.range(-0.2, 0.2), s.range(-0.2, 0.2));
        break;
      case 'skull': skull(B, p, 0, 0); break;
      case 'candles': {
        const n = s.int(3, 5);
        const c = Math.cos(p.rot), sn = Math.sin(p.rot);
        for (let i = 0; i < n; i++) {
          const a = s.range(0, Math.PI * 2), r = s.range(0.05, 0.3), hh = s.range(0.15, 0.4);
          const lx = Math.cos(a) * r, lz = Math.sin(a) * r;
          B.local(G.cyl, 'wax', p, lx, hh / 2, lz, 0.07, hh, 0.07);
          B.local(G.sphere, 'wax', p, lx + 0.02, hh * 0.7, lz, 0.03, 0.06, 0.03);
          const f = makeFlame(0.28, 0xfff0c0);
          f.position.set(p.x + (lx * c + lz * sn) * p.s, p.y + (hh + 0.07) * p.s, p.z + (-lx * sn + lz * c) * p.s);
          flames.push(f);
        }
        B.local(G.cyl, 'wax', p, 0, 0.01, 0, 0.5, 0.02, 0.5);
        addLight(p.x, p.y + 0.6, p.z, 0xffc070, 4, 5, 0.6);
        break;
      }
      case 'rubble':
        for (let i = 0; i < 6; i++) { const sz = s.range(0.1, 0.24); B.local(rock(s.int(1, 12), 1), 'rock', p, s.range(-0.35, 0.35), sz * 0.6, s.range(-0.35, 0.35), sz, sz * 0.8, sz, s.range(0, 3), s.range(0, 3), 0); }
        break;
      case 'rock':
        B.local(rock(s.int(1, 12), 2), th.dimension && p.type === 'rock' && th.pillarStyle === 'crystal' ? 'crystalV' : 'rock', p, 0, 0.3, 0, 0.5, 0.42, 0.45, 0, s.range(0, 3), 0);
        B.local(rock(s.int(13, 20), 1), 'rock', p, 0.3, 0.12, 0.2, 0.2, 0.16, 0.2, 0, s.range(0, 3), 0);
        break;
      case 'coffin':
        B.local(COFFIN, 'darkwood', p, 0, 0.2, 0, 1, 1, 1, Math.PI / 2, 0, 0);
        B.local(COFFIN, 'darkwood', p, 0.04, 0.45, 0.03, 1.04, 1.02, 0.25, Math.PI / 2, 0.1, 0.04);
        B.local(G.rbox, 'iron', p, 0.04, 0.5, 0.18, 0.06, 0.02, 0.5, 0, 0.1, 0.04);
        B.local(G.rbox, 'iron', p, 0.04, 0.5, 0.28, 0.3, 0.02, 0.06, 0, 0.1, 0.04);
        break;
      case 'urn':
        B.local(URN, s.chance(0.5) ? 'bronze' : 'clay2', p, 0, 0, 0, 1, 1, 1);
        break;
      case 'crystal': {
        const n = s.int(3, 6), mk = th.pillarStyle === 'crystal' ? 'crystalV' : 'crystal';
        for (let i = 0; i < n; i++) {
          const a = s.range(0, Math.PI * 2), hh = s.range(0.4, 1.1), w = s.range(0.12, 0.2);
          const tilt = s.range(0.1, 0.5), tx = Math.cos(a) * tilt, tz = Math.sin(a) * tilt;
          B.local(G.cyl6, mk, p, Math.cos(a) * 0.12 + tx * hh * 0.4, hh / 2, Math.sin(a) * 0.12 + tz * hh * 0.4, w, hh, w, tz, 0, -tx);
          B.local(G.cone6, mk, p, Math.cos(a) * 0.12 + tx * hh * 0.95, hh + w * 0.6, Math.sin(a) * 0.12 + tz * hh * 0.95, w, w * 2, w, tz, 0, -tx);
        }
        B.local(rock(3, 1), 'rock', p, 0, 0.05, 0, 0.35, 0.12, 0.35);
        break;
      }
      case 'floatcrystal':
        B.local(GEO.ico(0), 'crystalV', p, 0, 1.3, 0, 0.25, 0.5, 0.25, 0.2, s.range(0, 3), 0.1);
        B.local(GEO.ico(0), 'crystalV', p, 0.35, 0.9, 0.1, 0.1, 0.2, 0.1, 0.5, 0, 0.3);
        B.local(G.torus, 'rune', p, 0, 0.03, 0, 1.1, 1.1, 0.3, Math.PI / 2, 0, 0);
        break;
      case 'obelisk':
        B.local(lathe('obelisk', [[0, 0], [0.34, 0], [0.3, 0.3], [0.22, 2.6], [0, 3.0]], 4), 'basalt', p, 0, 0, 0, 1, 1, 1);
        B.local(G.box, 'rune', p, 0, 1.4, 0.2, 0.06, 1.6, 0.04, -0.03, 0, 0);
        break;
      case 'cart':
        B.local(G.rbox, 'wood', p, 0, 0.5, 0, 1.0, 0.45, 0.7);
        for (const [wx, wz] of [[-0.35, 0.38], [0.35, 0.38], [-0.35, -0.38], [0.35, -0.38]]) { B.local(G.torus, 'iron', p, wx, 0.2, wz, 0.4, 0.4, 0.9); B.local(G.cyl, 'darkwood', p, wx, 0.2, wz, 0.08, 0.06, 0.08, Math.PI / 2, 0, 0); }
        for (let i = 0; i < 6; i++) B.local(rock(i + 3, 1), 'ore', p, s.range(-0.3, 0.3), 0.76, s.range(-0.2, 0.2), 0.15, 0.13, 0.15);
        break;
      case 'anvil':
        B.local(G.cyl, 'log', p, 0, 0.2, 0, 0.55, 0.4, 0.55);
        B.local(ANVIL, 'iron', p, 0, 0.4, 0, 1, 1, 1);
        break;
      case 'stalagmite':
        for (let i = 0; i < 3; i++) { const a = s.range(0, 6.28), hh = s.range(0.6, 1.8), w = s.range(0.18, 0.32); B.local(lathe('stal' + i, [[0, 0], [1, 0], [0.7, 0.3], [0.35, 0.7], [0, 1]], 10), 'rock', p, Math.cos(a) * 0.2 * (i ? 1 : 0), 0, Math.sin(a) * 0.2 * (i ? 1 : 0), w, hh, w, s.range(-0.1, 0.1), 0, s.range(-0.1, 0.1)); }
        break;
      case 'icespike':
        for (let i = 0; i < 5; i++) { const a = s.range(0, 6.28), hh = s.range(0.5, 1.6), tilt = s.range(0, 0.5); B.local(G.cone6, 'ice', p, Math.cos(a) * 0.2, hh / 2 - 0.05, Math.sin(a) * 0.2, s.range(0.12, 0.24), hh, 0.2, Math.sin(a) * tilt, 0, -Math.cos(a) * tilt); }
        break;
      case 'frozenbody':
        B.local(G.rbox2, 'ice', p, 0, 0.55, 0, 0.7, 1.1, 0.6, 0, 0, 0.08);
        B.local(G.capsule, 'dark', p, 0, 0.55, 0, 0.14, 0.45, 0.12, 0, 0, 0.15);
        B.local(G.sphere, 'dark', p, 0.03, 0.95, 0, 0.16, 0.18, 0.16);
        break;
      case 'mushroom':
        for (let i = 0; i < s.int(2, 4); i++) { const a = s.range(0, 6.28), r = i ? s.range(0.15, 0.3) : 0, hh = s.range(0.25, 0.6), k = s.range(0.5, 1.1); B.local(G.cyl, 'shroomStem', p, Math.cos(a) * r, hh / 2, Math.sin(a) * r, 0.07 * k, hh, 0.07 * k); B.local(SHROOM, 'shroom', p, Math.cos(a) * r, hh - 0.03, Math.sin(a) * r, k, k, k); }
        break;
      case 'reeds':
        for (let i = 0; i < 9; i++) { const a = s.range(0, 6.28), r = s.range(0, 0.3), hh = s.range(0.5, 1.1); B.local(G.cone, 'reed', p, Math.cos(a) * r, hh / 2, Math.sin(a) * r, 0.03, hh, 0.03, s.range(-0.2, 0.2), 0, s.range(-0.2, 0.2)); if (i % 3 === 0) B.local(G.capsule, 'darkwood', p, Math.cos(a) * r, hh * 0.85, Math.sin(a) * r, 0.03, 0.08, 0.03); }
        break;
      case 'lily':
        B.local(G.circle, 'plant', p, 0, 0.005, 0, 0.6, 0.6, 1, -Math.PI / 2, 0, 0);
        if (s.chance(0.3)) B.local(G.sphere, 'clothRed', p, 0.05, 0.05, 0, 0.1, 0.07, 0.1);
        break;
      case 'deadtree':
        B.local(taperTube('dtree', [[0, 0, 0], [0.1, 0.9, 0.05], [-0.05, 1.8, 0.1], [0.15, 2.6, 0]], 0.2, 0.05, 14, 8), 'log', p, 0, 0, 0, 1, 1, 1);
        for (let i = 0; i < 4; i++) { const a = i * 1.57 + 0.3, y = 1.0 + i * 0.35; B.local(taperTube('dbr' + i, [[0, 0, 0], [Math.cos(a) * 0.4, 0.3, Math.sin(a) * 0.4], [Math.cos(a) * 0.8, 0.45, Math.sin(a) * 0.8]], 0.07, 0.01, 8, 5), 'log', p, 0, y, 0, 1, 1, 1); }
        break;
      // ---------- Refugio ----------
      case 'tent':
        B.local(lathe('tent', [[1.9, 0], [1.3, 1.2], [0.4, 2.4], [0.06, 2.7], [0, 2.72]], 8), 'cloth', p, 0, 0, 0, 1, 1, 0.8);
        B.local(G.cyl, 'darkwood', p, 0, 1.5, 0, 0.08, 3, 0.08);
        for (let i = 0; i < 4; i++) { const a = i * 1.57 + 0.78; B.local(G.cyl, 'darkwood', p, Math.cos(a) * 1.7, 0.2, Math.sin(a) * 1.35, 0.05, 0.5, 0.05); }
        B.local(G.plane, 'clothRed', p, 0, 2.9, 0.3, 0.4, 0.3, 1, 0, 0, 0);
        break;
      case 'forge':
        B.local(BOWL, 'stone', p, 0, 0, 0, 1, 1, 1);
        B.local(G.sphere, 'ember', p, 0, 0.55, 0.55, 0.55, 0.35, 0.3);
        { const f = makeFlame(1.6, 0xffc080); f.position.set(p.x, p.y + 0.8, p.z + 0.62); flames.push(f); }
        addLight(p.x, p.y + 1, p.z + 1, 0xff7a30, 16, 9, 0.6);
        break;
      case 'board':
        for (const sx of [-0.9, 0.9]) B.local(G.cyl, 'darkwood', p, sx, 1.1, 0, 0.1, 2.2, 0.1);
        B.local(G.rbox, 'wood', p, 0, 1.45, 0.02, 1.9, 1.1, 0.08);
        B.local(G.rbox, 'darkwood', p, 0, 2.1, 0.02, 2.1, 0.15, 0.2);
        for (let i = 0; i < 6; i++) B.local(G.plane, 'paper', p, -0.6 + (i % 3) * 0.6 + s.range(-0.08, 0.08), 1.2 + Math.floor(i / 3) * 0.48, 0.075, 0.38, 0.42, 1, 0, 0, s.range(-0.15, 0.15));
        break;
      case 'bench':
        B.local(G.rbox, 'wood', p, 0, 0.42, 0, 1.6, 0.12, 0.45);
        for (const sx of [-0.6, 0.6]) B.local(G.rbox, 'darkwood', p, sx, 0.2, 0, 0.12, 0.4, 0.4);
        break;
      case 'bedroll':
        B.local(G.capsule, 'clothRed', p, 0, 0.1, 0, 0.35, 1.1, 0.12, Math.PI / 2, 0, 0);
        B.local(G.capsule, 'cloth', p, 0, 0.15, -0.75, 0.16, 0.4, 0.16, 0, 0, Math.PI / 2);
        break;
    }
  }
  const group = B.bake(propMats());
  return { group, flames, lights };
}

function skull(B, p, lx, lz) {
  const o = { ...p, rot: p.rot + 0.5 };
  B.local(G.sphere, 'bone', o, lx, 0.12, lz - 0.02, 0.2, 0.19, 0.23);
  B.local(G.sphere, 'bone', o, lx, 0.06, lz + 0.06, 0.13, 0.08, 0.12);
  B.local(G.sphere, 'dark', o, lx - 0.045, 0.12, lz + 0.085, 0.055, 0.05, 0.03);
  B.local(G.sphere, 'dark', o, lx + 0.045, 0.12, lz + 0.085, 0.055, 0.05, 0.03);
}
void limb;
