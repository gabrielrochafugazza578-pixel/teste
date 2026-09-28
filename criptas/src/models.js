// Modelos de personagens feitos de blocos, com materiais realistas e articulacoes.
import * as THREE from 'three';
import { charTex } from './textures.js';

const geoCache = new Map();
function boxGeo(w, h, d) {
  const k = w.toFixed(3) + ',' + h.toFixed(3) + ',' + d.toFixed(3);
  if (!geoCache.has(k)) geoCache.set(k, new THREE.BoxGeometry(w, h, d));
  return geoCache.get(k);
}

export function makeMat(kind, o = {}) {
  if (kind === 'dark') return new THREE.MeshStandardMaterial({ color: 0x050404, roughness: 1 });
  if (kind === 'glow') return new THREE.MeshStandardMaterial({ color: o.color || 0xff3020, emissive: o.color || 0xff3020, emissiveIntensity: o.intensity || 4, roughness: 0.5 });
  const t = charTex(kind);
  const metal = ['steel', 'steel_dark', 'gold', 'iron'].includes(kind);
  const m = new THREE.MeshStandardMaterial({
    map: t.map, roughnessMap: t.roughnessMap, metalness: metal ? (kind === 'iron' ? 0.45 : kind === 'gold' ? 0.8 : 0.55) : 0,
    color: o.color || 0xffffff,
  });
  if (t.emissiveMap) { m.emissiveMap = t.emissiveMap; m.emissive = new THREE.Color(0xffffff); m.emissiveIntensity = o.emi || 2.5; }
  return m;
}

export class Rig {
  constructor(type) {
    this.type = type;
    this.root = new THREE.Group();
    this.mats = [];
    this.meshes = [];
    this.flashT = 0;
  }
  mat(kind, o) { const m = makeMat(kind, o); m.userData.baseEmissive = m.emissive.clone(); m.userData.baseEI = m.emissiveIntensity; this.mats.push(m); return m; }
  part(parent, w, h, d, mat, x = 0, y = 0, z = 0) {
    const m = new THREE.Mesh(boxGeo(w, h, d), mat);
    m.position.set(x, y, z);
    m.castShadow = true; m.receiveShadow = true;
    parent.add(m); this.meshes.push(m);
    return m;
  }
  pivot(parent, x = 0, y = 0, z = 0) { const g = new THREE.Group(); g.position.set(x, y, z); parent.add(g); return g; }
  flash(v) {
    for (const m of this.mats) {
      if (!m.userData.baseEmissive) continue;
      if (v > 0) { m.emissive.setRGB(v, v * 0.95, v * 0.9); m.emissiveIntensity = 1; if (m.emissiveMap) m.emissiveMap = m.emissiveMap; }
      else { m.emissive.copy(m.userData.baseEmissive); m.emissiveIntensity = m.userData.baseEI; }
    }
  }
  tint(color, k) { // congelado/queimando
    for (const m of this.mats) { if (!m.userData.baseColor) m.userData.baseColor = m.color.clone(); m.color.copy(m.userData.baseColor).lerp(color, k); }
  }
  fade(alpha) {
    for (const m of this.mats) { m.transparent = alpha < 1; m.opacity = alpha; m.depthWrite = alpha > 0.5; }
  }
  dispose() { for (const m of this.mats) m.dispose(); }
}

// ---------------- armas ----------------
export function makeWeapon(kind, rig, glow) {
  const g = new THREE.Group();
  const P = (w, h, d, m, x, y, z) => rig.part(g, w, h, d, m, x, y, z);
  const steel = rig.mat('steel'), leather = rig.mat('leather'), gold = rig.mat('gold'), wood = rig.mat('wood'), iron = rig.mat('iron');
  const blade = glow ? rig.mat('glow', { color: glow, intensity: 1.2 }) : steel;
  if (kind === 'espada' || kind === 'adagas') {
    const L = kind === 'espada' ? 0.85 : 0.42;
    P(0.05, 0.2, 0.05, leather, 0, 0, 0);
    P(0.08, 0.07, 0.08, gold, 0, -0.12, 0);
    P(kind === 'espada' ? 0.32 : 0.18, 0.05, 0.07, gold, 0, 0.12, 0);
    P(0.075, L, 0.022, blade, 0, 0.14 + L / 2, 0);
    P(0.045, 0.08, 0.018, blade, 0, 0.16 + L, 0);
  } else if (kind === 'machado') {
    P(0.055, 0.95, 0.055, wood, 0, 0.3, 0);
    P(0.04, 0.3, 0.28, blade, 0, 0.66, -0.13);
    P(0.05, 0.12, 0.1, iron, 0, 0.66, 0.06);
  } else if (kind === 'martelo') {
    P(0.06, 1.0, 0.06, wood, 0, 0.35, 0);
    P(0.26, 0.24, 0.42, iron, 0, 0.86, 0);
    P(0.27, 0.05, 0.43, gold, 0, 0.86, 0);
  } else if (kind === 'lanca') {
    P(0.05, 1.7, 0.05, wood, 0, 0.45, 0);
    P(0.09, 0.3, 0.02, blade, 0, 1.42, 0);
    P(0.14, 0.05, 0.05, gold, 0, 1.28, 0);
  } else if (kind === 'cajado') {
    P(0.06, 1.7, 0.06, wood, 0, 0.3, 0);
    const orb = new THREE.Mesh(new THREE.SphereGeometry(0.12, 12, 10), rig.mat('glow', { color: glow || 0xb050ff, intensity: 5 }));
    orb.position.y = 1.25; g.add(orb); rig.meshes.push(orb);
    P(0.2, 0.05, 0.05, iron, 0, 1.12, 0);
  }
  return g;
}

export function makeBow(rig, cross) {
  const g = new THREE.Group();
  const wood = rig.mat('wood'), str = rig.mat('bone', { color: 0xdddddd });
  if (cross) {
    rig.part(g, 0.08, 0.08, 0.6, wood, 0, 0, 0.1);
    rig.part(g, 0.7, 0.05, 0.06, rig.mat('iron'), 0, 0, 0.32);
    rig.part(g, 0.66, 0.01, 0.01, str, 0, 0.0, 0.26);
    return g;
  }
  const seg = [[0, 0, 0.0], [0.18, 0.02, 0.25], [0.34, 0.07, 0.5], [-0.18, 0.02, -0.25], [-0.34, 0.07, -0.5]];
  for (const [y, z, r] of seg) { const m = rig.part(g, 0.05, 0.2, 0.05, wood, 0, y, z); m.rotation.x = r; }
  rig.part(g, 0.01, 0.8, 0.01, str, 0, 0, -0.02);
  return g;
}

// ---------------- humanoide ----------------
function humanoid(type, P) {
  const r = new Rig(type);
  const s = P.scale || 1;
  r.root.scale.setScalar(s);
  r.legH = P.legH;
  r.hips = r.pivot(r.root, 0, P.legH, 0);
  r.legL = r.pivot(r.hips, -P.legX, 0, 0);
  r.legR = r.pivot(r.hips, P.legX, 0, 0);
  for (const leg of [r.legL, r.legR]) {
    r.part(leg, P.legW, P.legH, P.legW + 0.02, P.mLeg, 0, -P.legH / 2, 0);
    if (P.mBoot) r.part(leg, P.legW + 0.03, 0.14, P.legW + 0.1, P.mBoot, 0, -P.legH + 0.07, 0.03);
  }
  r.torso = r.pivot(r.hips, 0, 0, 0);
  r.part(r.torso, P.torsoW, P.torsoH, P.torsoD, P.mTorso, 0, P.torsoH / 2, 0);
  r.head = r.pivot(r.torso, 0, P.torsoH, 0);
  r.part(r.head, P.headS, P.headS, P.headS, P.mHead, 0, P.headS / 2, 0);
  const ax = P.torsoW / 2 + P.armW / 2 + 0.01;
  r.armL = r.pivot(r.torso, -ax, P.torsoH - 0.07, 0);
  r.armR = r.pivot(r.torso, ax, P.torsoH - 0.07, 0);
  for (const arm of [r.armL, r.armR]) {
    r.part(arm, P.armW, P.armH, P.armW, P.mArm, 0, -P.armH / 2 + 0.05, 0);
    if (P.mHand) r.part(arm, P.armW + 0.02, 0.13, P.armW + 0.02, P.mHand, 0, -P.armH + 0.02, 0);
  }
  r.handR = r.pivot(r.armR, 0, -P.armH + 0.02, 0.02);
  r.handL = r.pivot(r.armL, 0, -P.armH + 0.02, 0.02);
  r.baseArm = P.baseArm || 0;
  return r;
}

export function makeHero() {
  const r0 = new Rig('hero');
  const m = {
    steel: r0.mat('steel'), dark: r0.mat('steel_dark'), leather: r0.mat('leather'), blue: r0.mat('cloth_blue'), red: r0.mat('cloth_red'), black: r0.mat('dark'), gold: r0.mat('gold'),
  };
  const r = humanoid('hero', { legH: 0.72, legX: 0.13, legW: 0.2, torsoW: 0.52, torsoH: 0.6, torsoD: 0.3, headS: 0.42, armW: 0.17, armH: 0.58, mLeg: m.dark, mBoot: m.leather, mTorso: m.steel, mHead: m.steel, mArm: m.dark, mHand: m.leather });
  r.mats.push(...r0.mats);
  r.m = m;
  r.part(r.torso, 0.4, 0.46, 0.02, m.blue, 0, 0.28, 0.16);
  r.part(r.torso, 0.1, 0.12, 0.02, m.gold, 0, 0.36, 0.172);
  r.part(r.torso, 0.55, 0.08, 0.33, m.leather, 0, 0.04, 0);
  r.part(r.head, 0.3, 0.05, 0.02, m.black, 0, 0.23, 0.212);
  r.part(r.head, 0.05, 0.16, 0.02, m.black, 0, 0.14, 0.212);
  r.plume = r.part(r.head, 0.07, 0.14, 0.4, m.red, 0, 0.48, -0.02);
  r.pauldrons = [r.part(r.armL, 0.28, 0.17, 0.34, m.steel, 0, 0.03, 0), r.part(r.armR, 0.28, 0.17, 0.34, m.steel, 0, 0.03, 0)];
  r.cape = r.pivot(r.torso, 0, 0.58, -0.17);
  r.part(r.cape, 0.5, 0.95, 0.03, m.red, 0, -0.47, 0);
  r.weapon = null; r.bow = null;
  return r;
}

export function setHeroArmor(r, armor) {
  const c = {
    couro: [0x8a6040, 0x6a4a30], malha: [0xb0b4ba, 0x8a8e94], placas: [0xe8ecf2, 0xa0a4ac], andarilho: [0x5a7a5a, 0x3a4a3a], obsidiana: [0x6a4a8a, 0x3a2a4a],
  }[armor.look] || [0xffffff, 0xffffff];
  r.m.steel.color.set(c[0]); r.m.dark.color.set(c[1]);
  for (const m of r.mats) if (m.userData.baseColor) m.userData.baseColor = m.color.clone();
}

export function setHeroWeapon(r, kind, glow) {
  if (r.weapon) { r.handR.remove(r.weapon); }
  if (r.weapon2) { r.handL.remove(r.weapon2); r.weapon2 = null; }
  r.weapon = makeWeapon(kind, r, glow);
  r.weapon.rotation.x = Math.PI / 2;
  r.handR.add(r.weapon);
  if (kind === 'adagas') { r.weapon2 = makeWeapon('adagas', r, glow); r.weapon2.rotation.x = Math.PI / 2; r.handL.add(r.weapon2); }
}
export function setHeroBow(r, cross) {
  if (r.bow) r.handL.remove(r.bow);
  r.bow = makeBow(r, cross);
  r.bow.visible = false;
  r.handL.add(r.bow);
}

export function addSilhouette(rig, color = 0x3a7bd5) {
  const mat = new THREE.MeshBasicMaterial({ color, depthFunc: THREE.GreaterDepth, depthWrite: false });
  for (const mesh of [...rig.meshes]) {
    const s = new THREE.Mesh(mesh.geometry, mat);
    s.renderOrder = 1;
    s.userData.sil = true;
    mesh.add(s);
    mesh.renderOrder = 2;
  }
  rig.silMat = mat;
}

// ---------------- inimigos ----------------
export function makeCarnical(scale = 1, big = false) {
  const r0 = new Rig('carnical');
  const skin = r0.mat('skin_rot'), rags = r0.mat('rags'), eye = r0.mat('glow', { color: 0x9aff3a, intensity: 5 }), dark = r0.mat('dark');
  const r = humanoid('carnical', { scale, legH: 0.68, legX: 0.13, legW: 0.2, torsoW: big ? 0.66 : 0.5, torsoH: 0.62, torsoD: 0.3, headS: 0.4, armW: 0.16, armH: 0.64, mLeg: rags, mTorso: rags, mHead: skin, mArm: skin, baseArm: -1.35 });
  r.mats.push(...r0.mats);
  r.part(r.head, 0.08, 0.05, 0.02, eye, -0.09, 0.24, 0.201);
  r.part(r.head, 0.08, 0.05, 0.02, eye, 0.09, 0.24, 0.201);
  r.part(r.head, 0.26, 0.07, 0.02, dark, 0, 0.09, 0.201);
  r.part(r.torso, 0.3, 0.2, 0.02, skin, 0.05, 0.45, 0.155);
  if (big) {
    r.part(r.torso, 0.72, 0.18, 0.36, rags, 0, 0.62, -0.02);
    r.part(r.torso, 0.3, 0.25, 0.2, skin, 0, 0.5, -0.2);
  }
  r.head.rotation.z = 0.15;
  return r;
}

export function makeSkeleton(scale = 1) {
  const r0 = new Rig('esqueleto');
  const bone = r0.mat('bone'), dark = r0.mat('dark'), eye = r0.mat('glow', { color: 0xff5a30, intensity: 3 }), iron = r0.mat('iron');
  const r = humanoid('esqueleto', { scale, legH: 0.72, legX: 0.1, legW: 0.09, torsoW: 0.08, torsoH: 0.6, torsoD: 0.08, headS: 0.36, armW: 0.08, armH: 0.6, mLeg: bone, mTorso: bone, mHead: bone, mArm: bone });
  r.mats.push(...r0.mats);
  for (let i = 0; i < 4; i++) r.part(r.torso, 0.4 - i * 0.04, 0.045, 0.22, bone, 0, 0.5 - i * 0.1, 0.02);
  r.part(r.torso, 0.3, 0.1, 0.16, bone, 0, 0.02, 0);
  r.part(r.torso, 0.46, 0.06, 0.1, bone, 0, 0.58, 0);
  r.part(r.head, 0.09, 0.08, 0.02, dark, -0.08, 0.2, 0.181);
  r.part(r.head, 0.09, 0.08, 0.02, dark, 0.08, 0.2, 0.181);
  r.part(r.head, 0.04, 0.03, 0.01, eye, -0.08, 0.2, 0.19);
  r.part(r.head, 0.04, 0.03, 0.01, eye, 0.08, 0.2, 0.19);
  r.part(r.head, 0.24, 0.06, 0.02, dark, 0, 0.06, 0.181);
  r.part(r.head, 0.38, 0.1, 0.38, iron, 0, 0.36, 0);
  r.bow = makeBow(r); r.handL.add(r.bow); r.bow.rotation.x = Math.PI / 2; r.bow.rotation.z = 0;
  r.bow.rotation.set(Math.PI / 2, 0, 0);
  return r;
}

export function makeNecro(scale = 1) {
  const r0 = new Rig('necromante');
  const robe = r0.mat('robe'), purple = r0.mat('cloth_purple'), dark = r0.mat('dark'), eye = r0.mat('glow', { color: 0xc060ff, intensity: 6 }), skin = r0.mat('bone', { color: 0xaaa0a0 });
  const r = humanoid('necromante', { scale, legH: 0.7, legX: 0.12, legW: 0.2, torsoW: 0.54, torsoH: 0.66, torsoD: 0.34, headS: 0.4, armW: 0.18, armH: 0.62, mLeg: robe, mTorso: robe, mHead: robe, mArm: robe, mHand: skin });
  r.mats.push(...r0.mats);
  r.skirt = r.part(r.hips, 0.62, 0.72, 0.42, robe, 0, -0.34, 0);
  r.part(r.torso, 0.14, 0.62, 0.02, purple, 0, 0.3, 0.175);
  r.part(r.head, 0.3, 0.26, 0.02, dark, 0, 0.17, 0.205);
  r.part(r.head, 0.06, 0.04, 0.01, eye, -0.07, 0.2, 0.215);
  r.part(r.head, 0.06, 0.04, 0.01, eye, 0.07, 0.2, 0.215);
  r.part(r.head, 0.46, 0.1, 0.5, robe, 0, 0.44, -0.03);
  r.staff = makeWeapon('cajado', r, 0xb050ff);
  r.staff.position.y = -0.1;
  r.handR.add(r.staff);
  return r;
}

export function makeSpore(scale = 1) {
  const r = new Rig('esporo');
  r.root.scale.setScalar(scale);
  const f = r.mat('fungus'), cap = r.mat('fungus', { color: 0xb04030 }), eye = r.mat('glow', { color: 0xffe040, intensity: 5 }), dark = r.mat('dark');
  r.body = r.pivot(r.root, 0, 0.2, 0);
  r.part(r.body, 0.7, 0.62, 0.7, f, 0, 0.36, 0);
  r.cap = r.part(r.body, 0.98, 0.34, 0.98, cap, 0, 0.8, 0);
  r.part(r.body, 0.7, 0.12, 0.7, cap, 0, 1.0, 0);
  r.part(r.body, 0.1, 0.1, 0.02, eye, -0.14, 0.46, 0.351);
  r.part(r.body, 0.1, 0.1, 0.02, eye, 0.14, 0.46, 0.351);
  r.part(r.body, 0.3, 0.06, 0.02, dark, 0, 0.28, 0.351);
  r.legs = [];
  for (const [x, z] of [[-0.22, 0.2], [0.22, 0.2], [-0.22, -0.2], [0.22, -0.2]]) {
    const l = r.pivot(r.root, x, 0.24, z); r.part(l, 0.16, 0.26, 0.16, f, 0, -0.12, 0); r.legs.push(l);
  }
  return r;
}

export function makeSpider(scale = 1, queen = false) {
  const r = new Rig('aranha');
  r.root.scale.setScalar(scale);
  const ch = r.mat('chitin', { color: queen ? 0xc098d0 : 0xffffff }), eye = r.mat('glow', { color: queen ? 0xd040ff : 0xff2010, intensity: 6 }), hair = r.mat('hair');
  r.body = r.pivot(r.root, 0, 0.42, 0);
  r.abdomen = r.part(r.body, 0.78, 0.6, 0.86, ch, 0, 0.12, -0.5);
  r.part(r.body, 0.5, 0.08, 0.6, hair, 0, 0.44, -0.5);
  if (queen) { r.part(r.body, 0.12, 0.05, 0.2, eye, 0, 0.43, -0.42); r.part(r.body, 0.2, 0.05, 0.1, eye, 0, 0.43, -0.6); }
  r.part(r.body, 0.56, 0.34, 0.56, ch, 0, 0, 0.1);
  r.headM = r.part(r.body, 0.4, 0.3, 0.3, ch, 0, 0.02, 0.48);
  for (const [x, y] of [[-0.1, 0.1], [0.1, 0.1], [-0.15, 0.03], [0.15, 0.03], [-0.06, 0.02], [0.06, 0.02]]) r.part(r.body, 0.06, 0.06, 0.02, eye, x, y, 0.635);
  r.part(r.body, 0.06, 0.16, 0.06, hair, -0.08, -0.12, 0.62);
  r.part(r.body, 0.06, 0.16, 0.06, hair, 0.08, -0.12, 0.62);
  r.legs = [];
  for (let side = -1; side <= 1; side += 2) for (let i = 0; i < 4; i++) {
    const hip = r.pivot(r.body, side * 0.26, 0, 0.3 - i * 0.18);
    hip.rotation.y = side * (-0.6 + i * 0.4);
    const up = r.pivot(hip, 0, 0, 0);
    up.rotation.z = side * 0.7;
    r.part(up, 0.07, 0.07, 0.07, ch, 0, 0, 0);
    const seg1 = r.part(up, 0.55, 0.07, 0.07, ch, side * 0.27, 0, 0);
    const knee = r.pivot(up, side * 0.54, 0, 0);
    knee.rotation.z = -side * 1.9;
    r.part(knee, 0.62, 0.06, 0.06, ch, side * 0.3, 0, 0);
    r.legs.push({ hip, up, knee, side, i, seg1 });
  }
  return r;
}

export function makeColossus(scale = 2.6) {
  const r0 = new Rig('colosso');
  const obs = r0.mat('obsidian', { emi: 0.8 }), eye = r0.mat('glow', { color: 0xff8a20, intensity: 2.5 }), iron = r0.mat('iron');
  const r = humanoid('colosso', { scale, legH: 0.7, legX: 0.18, legW: 0.3, torsoW: 0.8, torsoH: 0.7, torsoD: 0.46, headS: 0.36, armW: 0.3, armH: 0.8, mLeg: obs, mTorso: obs, mHead: obs, mArm: obs, mHand: iron });
  r.mats.push(...r0.mats);
  r.part(r.torso, 1.0, 0.3, 0.5, obs, 0, 0.62, -0.04);
  r.part(r.head, 0.24, 0.05, 0.02, eye, 0, 0.2, 0.181);
  r.part(r.torso, 0.3, 0.3, 0.02, eye, 0, 0.4, 0.231);
  r.part(r.armL, 0.4, 0.34, 0.4, obs, 0, -0.66, 0);
  r.part(r.armR, 0.4, 0.34, 0.4, obs, 0, -0.66, 0);
  r.head.position.z = 0.08;
  return r;
}

export function makeModel(type, big = false) {
  switch (type) {
    case 'carnical': return makeCarnical(1);
    case 'esqueleto': return makeSkeleton(1);
    case 'necromante': return makeNecro(1);
    case 'esporo': return makeSpore(1);
    case 'aranha': return makeSpider(0.9);
    case 'aranhinha': return makeSpider(0.5);
    case 'gorran': return makeCarnical(2.3, true);
    case 'veshkara': return makeSpider(2.4, true);
    case 'colosso': return makeColossus(2.5);
  }
  return makeCarnical(1);
}

// animacao basica: caminhar (humanoides, aranha, esporo)
export function animateWalk(r, phase, amt, t) {
  if (r.legs && r.type === 'aranha') {
    for (const L of r.legs) {
      const p = phase * 1.6 + L.i * Math.PI / 2 + (L.side > 0 ? Math.PI : 0);
      L.hip.rotation.x = Math.sin(p) * 0.35 * amt;
      L.up.rotation.z = L.side * (0.7 + Math.max(0, Math.cos(p)) * 0.35 * amt);
    }
    r.body.position.y = 0.42 + Math.abs(Math.sin(phase * 3.2)) * 0.03 * amt;
    if (r.abdomen) r.abdomen.rotation.x = Math.sin(t * 2) * 0.05;
    return;
  }
  if (r.type === 'esporo') {
    r.legs.forEach((l, i) => { l.rotation.x = Math.sin(phase * 2 + (i % 2 ? Math.PI : 0) + (i > 1 ? Math.PI : 0)) * 0.7 * amt; });
    r.body.position.y = 0.2 + Math.abs(Math.sin(phase * 2)) * 0.07 * amt;
    r.body.rotation.z = Math.sin(phase) * 0.08 * amt;
    return;
  }
  const s = Math.sin(phase);
  r.legL.rotation.x = s * 0.75 * amt;
  r.legR.rotation.x = -s * 0.75 * amt;
  r.armL.rotation.x = r.baseArm - s * 0.55 * amt + (r.baseArm ? Math.sin(t * 3) * 0.08 : 0);
  r.armR.rotation.x = r.baseArm + s * 0.55 * amt + (r.baseArm ? Math.sin(t * 3 + 1) * 0.08 : 0);
  r.armL.rotation.z = 0; r.armR.rotation.z = 0;
  r.armL.rotation.y = 0; r.armR.rotation.y = 0;
  r.hips.position.y = r.legH + Math.abs(Math.cos(phase)) * 0.045 * amt;
  r.torso.rotation.set(0.05 * amt, 0, 0);
  r.hips.rotation.set(0, 0, 0);
  if (r.skirt) r.skirt.rotation.x = -s * 0.1 * amt;
  if (amt < 0.1) { // respiracao
    r.torso.rotation.x = Math.sin(t * 1.8) * 0.02;
    r.armL.rotation.z = -0.05 - Math.sin(t * 1.8) * 0.02; r.armR.rotation.z = 0.05 + Math.sin(t * 1.8) * 0.02;
  }
}
