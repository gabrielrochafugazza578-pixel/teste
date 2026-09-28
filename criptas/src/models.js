// Humanos com anatomia suave e articulacoes (quadril, joelho, tornozelo, ombro, cotovelo, punho),
// visuais de armadura do heroi, NPCs do Refugio, armas e arcos.
import * as THREE from 'three';
import { GEO, lathe, limb, blade, extrude, taperTube } from './geo.js';
import { M, Builder, Rig, template, ANIM } from './rig.js';
import { buildCreature } from './creatures.js';

export { Rig, M };

const TORSO = [[0, -0.07], [0.12, -0.07], [0.14, 0.03], [0.148, 0.14], [0.172, 0.27], [0.188, 0.37], [0.184, 0.44], [0.16, 0.5], [0.105, 0.545], [0.055, 0.565], [0, 0.57]];
const TORSO_F = [[0, -0.07], [0.14, -0.07], [0.15, 0.03], [0.13, 0.15], [0.15, 0.28], [0.165, 0.36], [0.16, 0.44], [0.14, 0.49], [0.095, 0.53], [0.05, 0.55], [0, 0.555]];

// ---------------- corpo base ----------------
function humanoid(b, D, m) {
  const r = {};
  const f = D.fem;
  r.hips = b.piv(null, 'hips', 0, D.legLen, 0);
  b.ball(r.hips, m.legs, [0, 0.01, 0], [f ? 0.17 : 0.155, 0.11, 0.11]);
  for (const side of [-1, 1]) {
    const L = side < 0 ? 'L' : 'R';
    const leg = r['leg' + L] = b.piv(r.hips, 'leg' + L, side * D.hipX, -0.02, 0);
    b.mesh(leg, limb(D.thighR, D.thighR * 0.7, D.thigh), m.legs);
    const knee = r['knee' + L] = b.piv(leg, 'knee' + L, 0, -D.thigh, 0);
    b.mesh(knee, limb(D.thighR * 0.7, D.shinR * 0.66, D.shin), m.legs);
    b.ball(knee, m.legs, [0, 0, 0.008], [D.thighR * 0.74, D.thighR * 0.74, D.thighR * 0.78]);
    const foot = r['foot' + L] = b.piv(knee, 'foot' + L, 0, -D.shin, 0);
    b.ball(foot, m.boots, [0, -0.035, 0.045], [0.052, 0.042, 0.115]);
    b.mesh(knee, GEO.cyl(1, 0.92, 16), m.boots, [0, -D.shin + 0.09, 0.004], [D.shinR * 0.95, 0.2, D.shinR]);
  }
  r.torso = b.piv(r.hips, 'torso', 0, 0.05, 0);
  b.mesh(r.torso, lathe(f ? 'torsoF' : 'torso', f ? TORSO_F : TORSO, 24), m.top, [0, 0, 0], [D.bulk * 0.96, 1, D.bulk * 0.7]);
  r.head = b.piv(r.torso, 'head', 0, D.torsoH, 0.01);
  b.mesh(r.head, GEO.cyl(0.9, 1, 14), m.skin, [0, 0.02, 0], [0.047, 0.1, 0.047]);
  if (!D.noFace) face(b, r.head, m, D);
  for (const side of [-1, 1]) {
    const L = side < 0 ? 'L' : 'R';
    const arm = r['arm' + L] = b.piv(r.torso, 'arm' + L, side * D.shX, D.torsoH - 0.075, 0);
    b.ball(arm, m.top, [0, 0, 0], [0.068 * D.bulk, 0.066, 0.068]);
    b.mesh(arm, limb(D.armR, D.armR * 0.84, D.upper), m.arms);
    const el = r['elbow' + L] = b.piv(arm, 'elbow' + L, 0, -D.upper, 0);
    b.mesh(el, limb(D.armR * 0.84, D.armR * 0.64, D.fore), m.fore || m.arms);
    const hand = r['hand' + L] = b.piv(el, 'hand' + L, 0, -D.fore - 0.035, 0.005);
    b.ball(hand, m.hands, [0, 0.005, 0], [0.036, 0.052, 0.027]);
    b.ball(hand, m.hands, [-side * 0.028, 0.012, 0.018], [0.014, 0.03, 0.014], [0.4, 0, side * 0.5]);
  }
  return r;
}

function face(b, head, m, D) {
  b.ball(head, m.skin, [0, 0.145, 0], [0.097, 0.117, 0.106]);
  b.ball(head, m.skin, [0, 0.085, 0.018], [0.078, 0.06, 0.088]);
  b.mesh(head, GEO.cone(10), m.skin, [0, 0.13, 0.103], [0.017, 0.045, 0.02], [Math.PI / 2 + 0.25, 0, 0]);
  for (const s of [-1, 1]) {
    b.ball(head, m.eye || M('eye'), [s * 0.035, 0.152, 0.087], [0.013, 0.011, 0.01]);
    b.ball(head, m.brow || m.hair || m.skin, [s * 0.036, 0.172, 0.09], [0.024, 0.007, 0.012], [0, 0, s * -0.15]);
    b.ball(head, m.skin, [s * 0.097, 0.14, -0.005], [0.014, 0.03, 0.022]);
  }
  b.ball(head, M('plain', { color: 0x7a3a34, rough: 0.5 }), [0, 0.083, 0.098], [0.022, 0.005, 0.008]);
  if (D.hair === 'short') b.mesh(head, GEO.hemiShell, m.hair, [0, 0.155, -0.01], [0.105, 0.126, 0.116], [-0.45, 0, 0]);
  if (D.hair === 'long') { b.mesh(head, GEO.hemiShell, m.hair, [0, 0.155, -0.01], [0.107, 0.128, 0.117], [-0.45, 0, 0]); b.mesh(head, limb(0.07, 0.05, 0.22), m.hair, [0, 0.16, -0.06], [1.1, 1, 0.7], [0.15, 0, 0]); }
  if (D.hair === 'bun') { b.mesh(head, GEO.hemiShell, m.hair, [0, 0.155, -0.01], [0.105, 0.127, 0.116], [-0.45, 0, 0]); b.ball(head, m.hair, [0, 0.2, -0.09], [0.05, 0.05, 0.05]); }
  if (D.beard) { b.ball(head, m.hair, [0, 0.07, 0.035], [0.082, D.beard === 'long' ? 0.085 : 0.058, 0.08]); b.ball(head, m.hair, [0, 0.1, 0.09], [0.04, 0.012, 0.015]); }
}

// capa de tecido (vertices animados por instancia)
function cape(b, parent, mat, w, h, y, z) {
  const g = new THREE.PlaneGeometry(w, h, 6, 12); g.translate(0, -h / 2, 0);
  const p = b.piv(parent, 'cape', 0, y, z);
  const mesh = b.mesh(p, g, mat, [0, 0, 0], 1, [0, 0, 0], true);
  mesh.userData.ownGeo = true; mesh.userData.cloth = { w, h };
  mesh.castShadow = true;
  return p;
}

export function updateCloth(rig, amt, t, drag = 0) {
  for (const m of rig.meshes) {
    const C = m.userData.cloth; if (!C) continue;
    const p = m.geometry.attributes.position, base = m.userData.base;
    for (let i = 0; i < p.count; i++) {
      const x = base[i * 3], y = base[i * 3 + 1], v = -y / C.h, v2 = Math.pow(v, 1.35);
      const wave = Math.sin(t * 4.2 + v * 5 + x * 4) * 0.028 * v * (0.35 + amt);
      p.setXYZ(i, x * (0.72 + 0.28 * v) + Math.sin(t * 3 + v * 3) * 0.012 * v, y * (1 - 0.05 * amt), -v2 * (0.05 + amt * 0.36 + drag) - wave - Math.abs(x) * 0.12 * (1 - v));
    }
    p.needsUpdate = true;
    m.geometry.computeVertexNormals();
  }
}

// ---------------- visuais do heroi (um por tipo de armadura) ----------------
const HERO_D = { legLen: 0.9, thigh: 0.44, shin: 0.42, hipX: 0.095, torsoH: 0.56, shX: 0.225, upper: 0.29, fore: 0.26, thighR: 0.085, shinR: 0.066, armR: 0.058, bulk: 1 };

function heroLook(look) {
  const b = new Builder('hero');
  const skin = M('skin'), hair = M('hair');
  let m, D = { ...HERO_D }, r;
  if (look === 'couro') {
    m = { skin, hair, legs: M('cloth_brown'), boots: M('leather_dark'), top: M('leather'), arms: M('cloth_brown'), fore: M('leather'), hands: M('leather_dark') };
    D.hair = 'short'; D.beard = 'short';
    r = humanoid(b, D, m);
    b.mesh(r.torso, GEO.torus(0.3, 28), M('leather_dark'), [0, 0.02, 0], [0.15, 0.108, 0.3], [Math.PI / 2, 0, 0]);
    b.mesh(r.torso, GEO.rbox(0.05, 0.04, 0.02, 0.008), M('gold'), [0, 0.02, 0.105]);
    b.mesh(r.torso, GEO.torus(0.45, 24), M('cloth_green'), [0, 0.53, -0.01], [0.085, 0.07, 0.2], [Math.PI / 2 + 0.2, 0, 0]);
    b.mesh(r.torso, GEO.cyl(1, 1, 14), M('leather_dark'), [0.08, 0.33, -0.15], [0.055, 0.46, 0.055], [0.2, 0, -0.5]);
    for (let i = 0; i < 5; i++) b.mesh(r.torso, GEO.cone(6), M('cloth_white'), [0.17 + (i % 3) * 0.018 - 0.02, 0.6 + (i % 2) * 0.02, -0.12 + (i % 2) * 0.02], [0.012, 0.06, 0.004], [0.2, 0, -0.5]);
    for (const s of [-1, 1]) b.mesh(r['arm' + (s < 0 ? 'L' : 'R')], GEO.hemi, M('leather'), [0, 0.01, 0], [0.078, 0.06, 0.08], [0, 0, s * 0.25]);
  } else if (look === 'malha') {
    m = { skin, hair, legs: M('chain'), boots: M('leather_dark'), top: M('chain'), arms: M('chain'), hands: M('leather_dark') };
    D.beard = 'short';
    r = humanoid(b, D, m);
    b.mesh(r.torso, lathe('surcoat', [[0.155, -0.08], [0.2, -0.3], [0.235, -0.44], [0.24, -0.45]], 24), M('cloth_blue', { double: true }), [0, 0.03, 0], [1, 1, 0.72]);
    b.mesh(r.torso, lathe('tabard', TORSO.slice(1, 8).map(([x, y]) => [x + 0.012, y]), 24), M('cloth_blue'), [0, 0, 0.004], [0.97, 1, 0.73]);
    b.mesh(r.torso, extrude('lion', s => { s.moveTo(0, 0.07); s.lineTo(0.05, 0.03); s.lineTo(0.035, -0.06); s.lineTo(0, -0.08); s.lineTo(-0.035, -0.06); s.lineTo(-0.05, 0.03); s.lineTo(0, 0.07); }, 0.01, 0.004), M('gold'), [0, 0.33, 0.132]);
    b.mesh(r.torso, GEO.torus(0.3, 28), M('leather_dark'), [0, 0.02, 0], [0.155, 0.11, 0.3], [Math.PI / 2, 0, 0]);
    b.mesh(r.head, GEO.hemiShell, M('chain'), [0, 0.14, -0.005], [0.116, 0.13, 0.122], [-0.5, 0, 0]);
    b.mesh(r.head, GEO.cyl(0.8, 1.25, 16, true), M('chain', { double: true }), [0, 0.03, -0.005], [0.085, 0.11, 0.09]);
    cape(b, r.torso, M('cloth_blue', { double: true }), 0.46, 0.95, 0.52, -0.13);
  } else if (look === 'placas') {
    const st = M('steel'), sd = M('steel_dark');
    m = { skin, hair, legs: st, boots: st, top: st, arms: st, hands: sd, fore: st };
    D.noFace = true;
    r = humanoid(b, D, m);
    for (let i = 0; i < 3; i++) b.mesh(r.torso, GEO.torus(0.18, 28), sd, [0, 0.06 + i * 0.05, 0], [0.152 + i * 0.004, 0.107, 0.12], [Math.PI / 2, 0, 0]);
    b.mesh(r.hips, GEO.cyl(0.155, 0.2, 20, true), M('steel', { double: true }), [0, -0.1, 0], [1, 0.17, 0.78]);
    b.mesh(r.head, lathe('greathelm', [[0, 0.02], [0.1, 0.02], [0.112, 0.08], [0.114, 0.17], [0.108, 0.23], [0.08, 0.27], [0.03, 0.29], [0, 0.29]], 24), st, [0, 0, 0], [1, 1, 1.06]);
    b.mesh(r.head, GEO.rbox(0.17, 0.014, 0.03, 0.006), M('dark'), [0, 0.165, 0.106]);
    b.mesh(r.head, GEO.rbox(0.014, 0.1, 0.03, 0.006), M('dark'), [0, 0.12, 0.112]);
    b.mesh(r.head, GEO.rbox(0.02, 0.2, 0.03, 0.008), M('gold'), [0, 0.19, 0.116]);
    b.mesh(r.head, taperTube('plume', [[0, 0.28, 0], [0, 0.36, -0.04], [0, 0.39, -0.14], [0, 0.34, -0.26], [0, 0.26, -0.32]], 0.035, 0.012, 20, 8), M('cloth_red'), [0, 0, 0]);
    for (const s of [-1, 1]) {
      const a = r['arm' + (s < 0 ? 'L' : 'R')];
      b.mesh(a, GEO.hemi, st, [s * 0.012, 0.02, 0], [0.1, 0.085, 0.105], [0, 0, s * 0.35]);
      b.mesh(a, GEO.hemi, st, [s * 0.02, -0.035, 0], [0.095, 0.07, 0.1], [0, 0, s * 0.55]);
      b.mesh(a, GEO.torus(0.3, 20), M('gold'), [s * 0.012, 0.018, 0], [0.098, 0.1, 0.08], [Math.PI / 2, 0, s * 0.35]);
      b.ball(r['elbow' + (s < 0 ? 'L' : 'R')], st, [0, 0, -0.01], [0.06, 0.06, 0.066]);
      b.mesh(r['knee' + (s < 0 ? 'L' : 'R')], GEO.hemi, st, [0, 0.01, 0.03], [0.085, 0.07, 0.08], [Math.PI / 2 - 0.3, 0, 0]);
    }
    cape(b, r.torso, M('cloth_red', { double: true }), 0.5, 1.0, 0.52, -0.14);
  } else if (look === 'andarilho') {
    m = { skin, hair, legs: M('cloth_brown'), boots: M('leather_dark'), top: M('cloth_green'), arms: M('cloth_green'), fore: M('leather'), hands: M('leather_dark') };
    D.beard = 'short'; D.hair = 'short';
    r = humanoid(b, D, m);
    b.mesh(r.torso, lathe('cloak', [[0.2, 0.47], [0.215, 0.3], [0.23, 0.05], [0.27, -0.3], [0.31, -0.5], [0.315, -0.52]], 24), M('cloth_green', { double: true }), [0, 0, -0.02], [1, 1, 0.78]);
    b.mesh(r.head, GEO.hemiShell, M('cloth_green', { double: true }), [0, 0.15, -0.03], [0.13, 0.15, 0.14], [-0.75, 0, 0]);
    b.mesh(r.torso, GEO.torus(0.4, 24), M('cloth_brown'), [0, 0.54, 0.0], [0.09, 0.08, 0.2], [Math.PI / 2 + 0.1, 0, 0]);
    b.mesh(r.torso, GEO.torus(0.3, 28), M('leather_dark'), [0, 0.03, 0], [0.155, 0.11, 0.25], [Math.PI / 2, 0, 0]);
  } else { // obsidiana
    const ob = M('obsidian', { emi: 1.6 });
    m = { skin, hair, legs: ob, boots: ob, top: ob, arms: ob, hands: M('steel_dark') };
    D.noFace = true;
    r = humanoid(b, D, m);
    b.mesh(r.head, lathe('obhelm', [[0, 0.02], [0.098, 0.02], [0.112, 0.1], [0.11, 0.2], [0.07, 0.27], [0, 0.28]], 20), ob, [0, 0, 0], [1, 1, 1.08]);
    b.mesh(r.head, GEO.rbox(0.13, 0.016, 0.03, 0.006), M('glow', { color: 0xff6a20, intensity: 5 }), [0, 0.165, 0.106]);
    for (const s of [-1, 1]) {
      b.mesh(r.head, taperTube('horn' + s, [[s * 0.08, 0.22, 0], [s * 0.16, 0.28, -0.02], [s * 0.2, 0.37, -0.06], [s * 0.19, 0.45, -0.12]], 0.03, 0.004, 16, 8), M('bone', { color: 0x5a5048 }), [0, 0, 0]);
      const a = r['arm' + (s < 0 ? 'L' : 'R')];
      b.mesh(a, GEO.hemi, ob, [s * 0.012, 0.02, 0], [0.105, 0.09, 0.11], [0, 0, s * 0.35]);
      for (let k = 0; k < 3; k++) b.mesh(a, GEO.cone(8), ob, [s * (0.03 + k * 0.02), 0.08 - k * 0.012, -0.03 + k * 0.03], [0.02, 0.09, 0.02], [0, 0, -s * (0.4 + k * 0.2)]);
    }
    b.mesh(r.hips, GEO.cyl(0.155, 0.21, 20, true), M('obsidian', { emi: 1.6, double: true }), [0, -0.1, 0], [1, 0.18, 0.78]);
    cape(b, r.torso, M('cloth_purple', { double: true }), 0.5, 1.0, 0.52, -0.14);
  }
  b.props = { legLen: D.legLen, baseArm: 0, look };
  return b;
}

export function makeHero(look = 'couro') {
  return Rig.from(template('hero:' + look, () => heroLook(look)));
}

// ---------------- NPCs ----------------
function npcBuild(kind) {
  const b = new Builder('npc');
  const D = { ...HERO_D };
  let m, r;
  if (kind === 'mercadora') {
    D.fem = true; D.hair = 'bun'; D.shX = 0.2; D.bulk = 0.9; D.armR = 0.05; D.thighR = 0.08;
    m = { skin: M('skin_dark'), hair: M('hair'), legs: M('cloth_purple'), boots: M('leather_dark'), top: M('cloth_purple'), arms: M('cloth_white'), hands: M('skin_dark') };
    r = humanoid(b, D, m);
    b.mesh(r.hips, lathe('dress', [[0.16, 0.05], [0.19, -0.2], [0.25, -0.55], [0.3, -0.86], [0.3, -0.88]], 24), M('cloth_purple', { double: true }), [0, 0, 0], [1, 1, 0.85]);
    b.mesh(r.torso, GEO.torus(0.5, 24), M('gold'), [0, 0.5, 0.02], [0.1, 0.09, 0.08], [Math.PI / 2 + 0.3, 0, 0]);
    b.mesh(r.torso, GEO.torus(0.35, 28), M('cloth_red'), [0, 0.04, 0], [0.15, 0.11, 0.3], [Math.PI / 2, 0, 0]);
  } else if (kind === 'ferreiro') {
    D.bulk = 1.18; D.shX = 0.25; D.armR = 0.07; D.beard = 'long';
    m = { skin: M('skin'), hair: M('hair_grey'), legs: M('cloth_brown'), boots: M('leather_dark'), top: M('skin'), arms: M('skin'), hands: M('skin') };
    r = humanoid(b, D, m);
    b.mesh(r.torso, lathe('apron', TORSO.slice(0, 7).map(([x, y]) => [x + 0.014, y]).concat([[0.12, 0.5]]), 24), M('leather'), [0, 0, 0.01], [1.14, 1, 0.8]);
    b.mesh(r.hips, lathe('apronLow', [[0.16, 0.0], [0.18, -0.3], [0.19, -0.5], [0.19, -0.52]], 20), M('leather', { double: true }), [0, 0, 0.03], [1, 1, 0.7]);
    b.props.tool = 'martelo';
  } else if (kind === 'escriba') {
    D.hair = 'short'; D.beard = 'long'; D.bulk = 0.92;
    m = { skin: M('skin'), hair: M('hair_grey'), legs: M('cloth_white'), boots: M('leather_dark'), top: M('cloth_white'), arms: M('cloth_white'), hands: M('skin') };
    r = humanoid(b, D, m);
    b.mesh(r.hips, lathe('robeLow', [[0.16, 0.05], [0.2, -0.3], [0.26, -0.86], [0.26, -0.88]], 24), M('cloth_white', { double: true }), [0, 0, 0], [1, 1, 0.85]);
    b.mesh(r.torso, lathe('stole', [[0.19, 0.48], [0.2, 0.2], [0.21, -0.1], [0.21, -0.12]], 20, true), M('cloth_blue', { double: true }), [0, 0, 0.02], [1, 1, 0.75]);
    b.mesh(r.handL, GEO.rbox(0.16, 0.2, 0.04, 0.01), M('leather_dark'), [0, -0.02, 0.05], 1, [0.3, 0, 0]);
  } else { // prisioneiro
    D.hair = 'short'; D.beard = 'short';
    m = { skin: M('skin'), hair: M('hair'), legs: M('rags'), boots: M('skin'), top: M('rags'), arms: M('skin'), hands: M('skin') };
    r = humanoid(b, D, m);
    for (const s of ['L', 'R']) b.mesh(r['hand' + s], GEO.torus(0.3, 16), M('iron'), [0, 0.04, 0], [0.045, 0.045, 0.045], [Math.PI / 2, 0, 0]);
  }
  Object.assign(b.props, { legLen: D.legLen, baseArm: 0 });
  return b;
}
export function makeNpc(kind) {
  const r = Rig.from(template('npc:' + kind, () => npcBuild(kind)));
  if (r.tool) { const w = makeWeapon(r.tool); w.rotation.x = Math.PI / 2; r.handR.add(w); }
  return r;
}

// ---------------- armas ----------------
function weaponBuild(kind, glow) {
  const b = new Builder('weapon');
  const g = b.root;
  const steel = M('steel'), leather = M('leather_dark'), gold = M('gold'), wood = M('wood'), iron = M('iron');
  const edge = glow ? M('glow', { color: glow, intensity: 1.4 }) : steel;
  const grip = (len, r = 0.018) => {
    b.mesh(g, GEO.cyl(1, 1.06, 12), leather, [0, 0, 0], [r, len, r]);
    for (let i = 0; i < 4; i++) b.mesh(g, GEO.torus(0.35, 12), leather, [0, -len / 2 + (i + 0.5) * len / 4, 0], [r * 1.05, r * 1.05, r * 1.05], [Math.PI / 2, 0, 0]);
  };
  if (kind === 'espada' || kind === 'adagas') {
    const long = kind === 'espada';
    grip(long ? 0.2 : 0.12);
    b.ball(g, gold, [0, long ? -0.125 : -0.08, 0], long ? 0.032 : 0.024);
    const gw = long ? 0.17 : 0.1;
    b.mesh(g, taperTube('guard' + kind, [[-gw, long ? 0.13 : 0.09, 0.02], [-gw * 0.4, long ? 0.115 : 0.075, 0], [0, long ? 0.11 : 0.07, 0], [gw * 0.4, long ? 0.115 : 0.075, 0], [gw, long ? 0.13 : 0.09, 0.02]], 0.017, 0.017, 16, 8, false), gold);
    for (const s of [-1, 1]) b.ball(g, gold, [s * gw, long ? 0.13 : 0.09, 0.02], 0.022);
    b.mesh(g, long ? blade('espada', 0.86, 0.074, 0.022) : blade('adaga', 0.38, 0.062, 0.02, { leaf: true }), edge, [0, long ? 0.12 : 0.08, 0]);
  } else if (kind === 'machado') {
    b.mesh(g, GEO.cyl(0.85, 1, 12), wood, [0, 0.3, 0], [0.026, 1.0, 0.026]);
    b.ball(g, iron, [0, -0.2, 0], 0.032);
    b.mesh(g, extrude('axe', s => { s.moveTo(0.02, -0.06); s.lineTo(0.12, -0.09); s.quadraticCurveTo(0.24, -0.16, 0.3, -0.22); s.quadraticCurveTo(0.36, 0, 0.3, 0.22); s.quadraticCurveTo(0.24, 0.16, 0.12, 0.09); s.lineTo(0.02, 0.06); s.lineTo(0.02, -0.06); }, 0.018, 0.01), edge, [0, 0.68, 0]);
    b.mesh(g, GEO.cyl(1, 1, 14), iron, [0, 0.68, 0], [0.04, 0.16, 0.04]);
    b.mesh(g, GEO.cone(8), iron, [-0.09, 0.68, 0], [0.025, 0.12, 0.018], [0, 0, Math.PI / 2]);
  } else if (kind === 'martelo') {
    b.mesh(g, GEO.cyl(0.85, 1, 12), wood, [0, 0.35, 0], [0.03, 1.1, 0.03]);
    b.mesh(g, GEO.cyl(1, 1, 22), iron, [0, 0.9, 0], [0.1, 0.36, 0.1], [0, 0, Math.PI / 2]);
    for (const s of [-1, 1]) { b.mesh(g, GEO.torus(0.18, 22), gold, [s * 0.14, 0.9, 0], [0.1, 0.1, 0.1], [0, Math.PI / 2, 0]); b.mesh(g, GEO.cyl(1, 1, 22), iron, [s * 0.19, 0.9, 0], [0.108, 0.02, 0.108], [0, 0, Math.PI / 2]); }
    b.mesh(g, GEO.cone(10), iron, [0, 1.08, 0], [0.035, 0.16, 0.035]);
  } else if (kind === 'lanca') {
    b.mesh(g, GEO.cyl(0.9, 1, 10), wood, [0, 0.45, 0], [0.022, 1.8, 0.022]);
    b.mesh(g, blade('lanca', 0.34, 0.1, 0.022, { leaf: true }), edge, [0, 1.34, 0]);
    b.mesh(g, GEO.cyl(0.8, 1, 12), gold, [0, 1.32, 0], [0.032, 0.07, 0.032]);
    b.mesh(g, GEO.cone(8), M('cloth_red'), [0, 1.24, 0], [0.04, 0.12, 0.04], [Math.PI, 0, 0]);
  } else if (kind === 'cajado') {
    b.mesh(g, taperTube('staff', [[0, -0.4, 0], [0.02, 0.2, 0.01], [-0.02, 0.7, -0.01], [0.01, 1.1, 0], [0.06, 1.3, 0]], 0.03, 0.022, 30, 8), wood);
    b.ball(g, M('glow', { color: glow || 0xb050ff, intensity: 5 }), [0.03, 1.42, 0], 0.09);
    for (let i = 0; i < 3; i++) { const a = i * 2.1; b.mesh(g, taperTube('prong' + i, [[0.05, 1.28, 0], [0.05 + Math.cos(a) * 0.09, 1.4, Math.sin(a) * 0.09], [0.03 + Math.cos(a) * 0.06, 1.52, Math.sin(a) * 0.06]], 0.014, 0.004, 10, 6), wood); }
  }
  return b;
}
export function makeWeapon(kind, glow = null) {
  const tpl = template(`w:${kind}:${glow}`, () => weaponBuild(kind, glow));
  return tpl.root.clone(true);
}

function bowBuild(cross) {
  const b = new Builder('bow');
  const g = b.root, wood = M('wood'), str = M('plain', { color: 0xd8d0c0, rough: 0.8 });
  if (cross) {
    b.mesh(g, GEO.rbox(0.07, 0.08, 0.62, 0.025), wood, [0, 0, 0.1]);
    b.mesh(g, taperTube('prod', [[-0.34, 0, 0.26], [-0.18, 0, 0.34], [0, 0, 0.36], [0.18, 0, 0.34], [0.34, 0, 0.26]], 0.02, 0.02, 20, 8, false), M('iron'));
    b.mesh(g, GEO.cyl(1, 1, 6), str, [0, 0, 0.26], [0.004, 0.68, 0.004], [0, 0, Math.PI / 2]);
    b.mesh(g, GEO.rbox(0.05, 0.1, 0.06, 0.015), M('iron'), [0, -0.07, 0.02]);
  } else {
    b.mesh(g, taperTube('bowlimbs', [[0, -0.46, -0.1], [0, -0.32, -0.01], [0, -0.1, 0.03], [0, 0.1, 0.03], [0, 0.32, -0.01], [0, 0.46, -0.1]], 0.016, 0.016, 30, 8, false), wood);
    b.mesh(g, GEO.cyl(1, 1, 12), M('leather_dark'), [0, 0, 0.03], [0.022, 0.14, 0.022]);
    b.mesh(g, GEO.cyl(1, 1, 6), str, [0, 0, -0.1], [0.0035, 0.92, 0.0035]);
  }
  return b;
}
export function makeBow(cross = false) { return template('bow:' + cross, () => bowBuild(cross)).root.clone(true); }

// ---------------- heroi: equipamentos ----------------
export function setHeroWeapon(r, kind, glow) {
  if (r.weapon) r.handR.remove(r.weapon);
  if (r.weapon2) { r.handL.remove(r.weapon2); r.weapon2 = null; }
  r.weaponKind = kind; r.weaponGlow = glow;
  r.weapon = makeWeapon(kind, glow);
  r.weapon.rotation.x = Math.PI / 2;
  r.handR.add(r.weapon);
  if (kind === 'adagas') { r.weapon2 = makeWeapon('adagas', glow); r.weapon2.rotation.x = Math.PI / 2; r.handL.add(r.weapon2); }
}
export function setHeroBow(r, cross) {
  if (r.bow) r.handL.remove(r.bow);
  r.bowCross = cross;
  r.bow = makeBow(cross);
  r.bow.visible = false;
  r.handL.add(r.bow);
}

export function addSilhouette(rig, color = 0x3a7bd5) {
  const mat = rig.silMat || new THREE.MeshBasicMaterial({ color, depthFunc: THREE.GreaterDepth, depthWrite: false });
  rig.silMat = mat;
  rig.root.traverse(mesh => {
    if (!mesh.isMesh || mesh.userData.sil || mesh.children.some(c => c.userData.sil)) return;
    const s = new THREE.Mesh(mesh.geometry, mat);
    s.renderOrder = 1; s.userData.sil = true; s.raycast = () => {}; s.layers.set(1);
    mesh.add(s); mesh.renderOrder = 2;
  });
}

// ---------------- fabrica ----------------
export function makeModel(type) {
  return Rig.from(template('c:' + type, () => buildCreature(type)));
}

// ---------------- locomocao humana ----------------
export function animateHumanoid(r, phase, amt, t) {
  const s = Math.sin(phase), c = Math.cos(phase);
  r.legL.rotation.set(s * 0.62 * amt, 0, -0.02);
  r.legR.rotation.set(-s * 0.62 * amt, 0, 0.02);
  r.kneeL.rotation.set(0.06 + Math.max(0, -c) * 1.1 * amt, 0, 0);
  r.kneeR.rotation.set(0.06 + Math.max(0, c) * 1.1 * amt, 0, 0);
  r.footL.rotation.x = -(r.legL.rotation.x + r.kneeL.rotation.x) * 0.55;
  r.footR.rotation.x = -(r.legR.rotation.x + r.kneeR.rotation.x) * 0.55;
  const breath = Math.sin(t * 1.7);
  r.armL.rotation.set((r.baseArm || 0) - s * 0.45 * amt, 0, -0.08 - breath * 0.012 * (1 - amt));
  r.armR.rotation.set((r.baseArm || 0) + s * 0.45 * amt, 0, 0.08 + breath * 0.012 * (1 - amt));
  r.armL.position.z = 0; r.armR.position.z = 0;
  r.elbowL.rotation.set(-(0.18 + Math.max(0, s) * 0.5 * amt), 0, 0);
  r.elbowR.rotation.set(-(0.18 + Math.max(0, -s) * 0.5 * amt), 0, 0);
  r.hips.position.set(0, r.legLen - 0.015 + Math.abs(c) * 0.035 * amt - 0.015 * amt, 0);
  r.hips.rotation.set(0, s * 0.09 * amt, 0);
  r.torso.rotation.set(0.05 * amt + breath * 0.012 * (1 - amt), -s * 0.15 * amt, 0);
  r.head.rotation.set(-0.03 * amt, s * 0.08 * amt, 0);
}
ANIM.humanoid = animateHumanoid;

export function animateWalk(r, phase, amt, t) {
  const f = ANIM[r.anim || 'humanoid'];
  if (f) f(r, phase, amt, t);
}
