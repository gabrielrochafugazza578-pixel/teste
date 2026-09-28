// Geometrias suaves reutilizaveis (em cache): membros afunilados, torno, laminas extrudadas,
// tubos curvos afunilados, rochas deformadas e mescla de malhas.
import * as THREE from 'three';
import { mergeGeometries } from 'three/examples/jsm/utils/BufferGeometryUtils.js';
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry.js';
import { RNG } from './util.js';

const cache = new Map();
const memo = (k, f) => { if (!cache.has(k)) cache.set(k, f()); return cache.get(k); };
const V2 = (x, y) => new THREE.Vector2(x, y);

export const GEO = {
  sphere: () => memo('sphere', () => new THREE.SphereGeometry(1, 24, 16)),
  sphereLo: () => memo('sphereLo', () => new THREE.SphereGeometry(1, 12, 8)),
  hemi: () => memo('hemi', () => new THREE.SphereGeometry(1, 24, 10, 0, Math.PI * 2, 0, Math.PI / 2)),
  hemiShell: () => memo('hemiShell', () => { const g = new THREE.SphereGeometry(1, 24, 12, 0, Math.PI * 2, 0, Math.PI * 0.62); return g; }),
  cyl: (rt = 1, rb = 1, seg = 18, open = false) => memo(`cyl${rt.toFixed(3)},${rb.toFixed(3)},${seg},${open}`, () => new THREE.CylinderGeometry(rt, rb, 1, seg, 1, open)),
  cone: (seg = 12) => memo('cone' + seg, () => new THREE.ConeGeometry(1, 1, seg)),
  torus: (tube = 0.25, seg = 24, arc = Math.PI * 2) => memo(`torus${tube},${seg},${arc.toFixed(2)}`, () => new THREE.TorusGeometry(1, tube, 10, seg, arc)),
  rbox: (w, h, d, r = 0.04) => memo(`rbox${w},${h},${d},${r}`, () => new RoundedBoxGeometry(w, h, d, 3, r)),
  plane: () => memo('plane', () => new THREE.PlaneGeometry(1, 1)),
  ico: (detail = 1) => memo('ico' + detail, () => new THREE.IcosahedronGeometry(1, detail)),
  capsule: (r, len) => memo(`cap${r},${len}`, () => new THREE.CapsuleGeometry(r, len, 6, 16)),
};

// torno a partir de pontos [raio, altura]
export function lathe(key, pts, seg = 20) {
  return memo('lathe:' + key, () => new THREE.LatheGeometry(pts.map(p => V2(p[0], p[1])), seg));
}

// membro afunilado que desce a partir do pivo (topo em y=0, base em y=-len), com pontas arredondadas
export function limb(rTop, rBot, len, seg = 16) {
  return memo(`limb${rTop.toFixed(3)},${rBot.toFixed(3)},${len.toFixed(3)},${seg}`, () => {
    const pts = [];
    const n = 5;
    for (let i = 0; i <= n; i++) { const a = (i / n) * Math.PI / 2; pts.push(V2(Math.sin(a) * rBot, -len - Math.cos(a) * rBot * 0.6 + rBot * 0.6)); }
    for (let i = 1; i <= 6; i++) { const t = i / 7; const r = rBot + (rTop - rBot) * t; const bulge = Math.sin(t * Math.PI) * (rTop + rBot) * 0.06; pts.push(V2(r + bulge, -len * (1 - t))); }
    for (let i = 0; i <= n; i++) { const a = Math.PI / 2 - (i / n) * Math.PI / 2; pts.push(V2(Math.sin(a) * rTop, Math.cos(a) * rTop * 0.6)); }
    pts[0].x = 0; pts[pts.length - 1].x = 0;
    return new THREE.LatheGeometry(pts, seg);
  });
}

// lamina extrudada com chanfro (espadas, adagas, pontas de lanca)
export function blade(key, len, width, thick, opts = {}) {
  return memo('blade:' + key, () => {
    const s = new THREE.Shape();
    const w = width / 2, tip = opts.tip ?? len * 0.18, fuller = opts.leaf;
    s.moveTo(-w * 0.8, 0);
    if (fuller) { s.bezierCurveTo(-w * 1.4, len * 0.35, -w * 1.2, len * 0.7, 0, len); s.bezierCurveTo(w * 1.2, len * 0.7, w * 1.4, len * 0.35, w * 0.8, 0); }
    else { s.lineTo(-w, len * 0.12); s.lineTo(-w * 0.92, len - tip); s.lineTo(0, len); s.lineTo(w * 0.92, len - tip); s.lineTo(w, len * 0.12); s.lineTo(w * 0.8, 0); }
    s.lineTo(-w * 0.8, 0);
    const g = new THREE.ExtrudeGeometry(s, { depth: thick * 0.25, bevelEnabled: true, bevelThickness: thick * 0.38, bevelSize: w * 0.35, bevelSegments: 2, steps: 1, curveSegments: 10 });
    g.translate(0, 0, -thick * 0.125);
    g.computeVertexNormals();
    return g;
  });
}

// forma 2D extrudada generica
export function extrude(key, draw, depth, bevel = 0.02) {
  return memo('ext:' + key, () => {
    const s = new THREE.Shape(); draw(s);
    const g = new THREE.ExtrudeGeometry(s, { depth, bevelEnabled: bevel > 0, bevelThickness: bevel, bevelSize: bevel, bevelSegments: 2, curveSegments: 12 });
    g.translate(0, 0, -depth / 2); g.computeVertexNormals();
    return g;
  });
}

// tubo curvo afunilado ao longo de pontos
export function taperTube(key, points, r0, r1, seg = 24, radial = 10, closed = true) {
  return memo('tube:' + key, () => {
    const curve = new THREE.CatmullRomCurve3(points.map(p => new THREE.Vector3(p[0], p[1], p[2])));
    const frames = curve.computeFrenetFrames(seg, false);
    const pos = [], nor = [], uv = [], idx = [];
    for (let i = 0; i <= seg; i++) {
      const t = i / seg, c = curve.getPointAt(t), N = frames.normals[i], B = frames.binormals[i];
      const r = r0 + (r1 - r0) * t;
      for (let j = 0; j <= radial; j++) {
        const a = (j / radial) * Math.PI * 2, cs = Math.cos(a), sn = Math.sin(a);
        const nx = cs * N.x + sn * B.x, ny = cs * N.y + sn * B.y, nz = cs * N.z + sn * B.z;
        pos.push(c.x + nx * r, c.y + ny * r, c.z + nz * r); nor.push(nx, ny, nz); uv.push(j / radial, t);
      }
    }
    for (let i = 0; i < seg; i++) for (let j = 0; j < radial; j++) {
      const a = i * (radial + 1) + j, b = a + radial + 1;
      idx.push(a, b, a + 1, b, b + 1, a + 1);
    }
    if (closed) {
      const c = curve.getPointAt(0), base = pos.length / 3;
      pos.push(c.x, c.y, c.z); nor.push(0, -1, 0); uv.push(0.5, 0);
      for (let j = 0; j < radial; j++) idx.push(base, j + 1, j);
    }
    const g = new THREE.BufferGeometry();
    g.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3));
    g.setAttribute('normal', new THREE.Float32BufferAttribute(nor, 3));
    g.setAttribute('uv', new THREE.Float32BufferAttribute(uv, 2));
    g.setIndex(idx);
    return g;
  });
}

// rocha organica: icosaedro deformado por ruido
export function rock(seed, detail = 2, rough = 0.28) {
  return memo(`rock${seed},${detail},${rough}`, () => {
    const g = new THREE.IcosahedronGeometry(1, detail);
    const rng = new RNG(seed);
    const ks = Array.from({ length: 6 }, () => [rng.range(-1, 1), rng.range(-1, 1), rng.range(-1, 1), rng.range(1.5, 4), rng.range(0, 6)]);
    const p = g.attributes.position, v = new THREE.Vector3();
    for (let i = 0; i < p.count; i++) {
      v.fromBufferAttribute(p, i).normalize();
      let d = 0;
      for (const k of ks) d += Math.sin((v.x * k[0] + v.y * k[1] + v.z * k[2]) * k[3] + k[4]);
      v.multiplyScalar(1 + d / ks.length * rough * 2);
      p.setXYZ(i, v.x, v.y, v.z);
    }
    g.computeVertexNormals();
    return g;
  });
}

// asa (plano recortado curvado)
export function wing(key, w, h, curve = 0.15) {
  return memo('wing:' + key, () => {
    const g = new THREE.PlaneGeometry(w, h, 8, 8);
    const p = g.attributes.position;
    for (let i = 0; i < p.count; i++) { const x = p.getX(i); p.setZ(i, -Math.pow(Math.abs(x) / w, 2) * curve); }
    g.translate(w / 2, 0, 0);
    g.computeVertexNormals();
    return g;
  });
}

// mescla as malhas filhas diretas de cada no que compartilham material (menos chamadas de desenho)
export function bakeHierarchy(root) {
  const nodes = [];
  root.traverse(o => nodes.push(o));
  for (const node of nodes) {
    const groups = new Map();
    for (const c of node.children) {
      if (!c.isMesh || c.children.length || c.userData.keep || c.isSkinnedMesh) continue;
      if (!groups.has(c.material)) groups.set(c.material, []);
      groups.get(c.material).push(c);
    }
    for (const [mat, list] of groups) {
      if (list.length < 2) continue;
      const geos = list.map(m => {
        m.updateMatrix();
        let g = m.geometry.index ? m.geometry.toNonIndexed() : m.geometry.clone();
        for (const k of Object.keys(g.attributes)) if (!['position', 'normal', 'uv'].includes(k)) g.deleteAttribute(k);
        if (!g.attributes.uv) g.setAttribute('uv', new THREE.Float32BufferAttribute(new Float32Array(g.attributes.position.count * 2), 2));
        g.applyMatrix4(m.matrix);
        return g;
      });
      const merged = mergeGeometries(geos, false);
      geos.forEach(g => g.dispose());
      if (!merged) continue;
      const mesh = new THREE.Mesh(merged, mat);
      mesh.castShadow = true; mesh.receiveShadow = true;
      mesh.userData.baked = true;
      for (const m of list) node.remove(m);
      node.add(mesh);
    }
  }
}
