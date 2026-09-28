// Criaturas originais das Criptas e das dimensoes: modelos organicos e suas animacoes.
import * as THREE from 'three';
import { GEO, lathe, limb, taperTube, wing, extrude } from './geo.js';
import { M, Builder, ANIM } from './rig.js';
import { wingTexture } from './textures.js';

const PI = Math.PI;

// ============================================================ RASTEJANTE (quadrupede palido)
function crawler(b, pal) {
  const skin = M(pal.skin), bone = M('bone', { color: 0x9a9080 }), dark = M('dark');
  const body = b.piv(null, 'body', 0, 0.62, 0);
  b.ball(body, skin, [0, 0.02, 0.06], [0.2, 0.17, 0.3]);
  b.ball(body, skin, [0, -0.02, -0.28], [0.15, 0.13, 0.17]);
  for (let i = 0; i < 7; i++) b.mesh(body, GEO.cone(8), bone, [0, 0.16 - Math.abs(i - 2) * 0.012, -0.3 + i * 0.09], [0.025, 0.07, 0.03], [-0.3, 0, 0]);
  for (let i = 0; i < 4; i++) for (const s of [-1, 1]) b.mesh(body, GEO.torus(0.14, 14, PI * 0.7), skin, [s * 0.02, -0.02, -0.05 + i * 0.08], [0.2, 0.16, 0.2], [0, s * PI / 2, -PI * 0.1]);
  const head = b.piv(body, 'head', 0, 0.06, 0.34);
  b.ball(head, skin, [0, 0.02, 0.1], [0.09, 0.1, 0.17]);
  b.ball(head, skin, [0, 0.07, 0.02], [0.08, 0.06, 0.1]);
  for (const s of [-1, 1]) b.ball(head, dark, [s * 0.07, 0.04, 0.16], [0.012, 0.03, 0.05]);
  const jaw = b.piv(head, 'jaw', 0, -0.04, 0.03);
  b.ball(jaw, skin, [0, -0.01, 0.1], [0.075, 0.035, 0.15]);
  b.ball(jaw, M('plain', { color: 0x301014, rough: 0.4 }), [0, 0.012, 0.1], [0.062, 0.018, 0.13]);
  for (let i = 0; i < 6; i++) { const a = (i / 5 - 0.5) * 1.8; b.mesh(head, GEO.cone(6), bone, [Math.sin(a) * 0.06, -0.035, 0.1 + Math.cos(a) * 0.14], [0.01, 0.045, 0.01], [PI, 0, 0]); }
  for (let side = 0; side < 2; side++) {
    const s = side ? 1 : -1;
    const fl = b.piv(body, 'fl.' + side, s * 0.16, 0, 0.26);
    b.mesh(fl, limb(0.05, 0.036, 0.36), skin);
    const fe = b.piv(fl, 'fe.' + side, 0, -0.36, 0);
    b.mesh(fe, limb(0.036, 0.028, 0.38), skin);
    const fh = b.piv(fe, 'fh.' + side, 0, -0.38, 0);
    for (let k = 0; k < 3; k++) b.mesh(fh, taperTube('claw' + k, [[0, 0, 0], [(k - 1) * 0.03, -0.05, 0.05], [(k - 1) * 0.04, -0.07, 0.13]], 0.012, 0.002, 8, 6, false), bone);
    const bl = b.piv(body, 'bl.' + side, s * 0.13, -0.05, -0.3);
    b.mesh(bl, limb(0.062, 0.045, 0.32), skin);
    const bk = b.piv(bl, 'bk.' + side, 0, -0.32, 0);
    b.mesh(bk, limb(0.045, 0.03, 0.33), skin);
    const bf = b.piv(bk, 'bf.' + side, 0, -0.33, 0);
    b.mesh(bf, limb(0.03, 0.024, 0.17), skin);
    b.ball(bf, skin, [0, -0.17, 0.04], [0.035, 0.02, 0.07]);
  }
  b.props = { anim: 'crawler' };
}
ANIM.crawler = (r, phase, amt, t) => {
  for (let i = 0; i < 2; i++) {
    const off = i ? PI : 0;
    const pf = phase + off, pb = phase + off + PI;
    r.fl[i].rotation.set(-0.55 + Math.sin(pf) * 0.42 * amt, 0, (i ? 1 : -1) * 0.12);
    r.fe[i].rotation.set(0.75 + Math.max(0, Math.cos(pf)) * 0.55 * amt, 0, 0);
    r.fh[i].rotation.set(-0.2, 0, 0);
    r.bl[i].rotation.set(-0.62 + Math.sin(pb) * 0.38 * amt, 0, 0);
    r.bk[i].rotation.set(1.3 + Math.max(0, Math.cos(pb)) * 0.45 * amt, 0, 0);
    r.bf[i].rotation.set(-0.78, 0, 0);
  }
  r.body.position.y = 0.6 + Math.abs(Math.sin(phase)) * 0.04 * amt + Math.sin(t * 2) * 0.01;
  r.body.rotation.set(Math.sin(phase * 2) * 0.03 * amt, 0, Math.sin(phase) * 0.06 * amt);
  r.head.rotation.set(0.15 + Math.sin(t * 1.3) * 0.08, Math.sin(t * 0.9) * 0.3 * (1 - amt), 0);
  r.jaw.rotation.x = 0.1 + Math.max(0, Math.sin(t * 2.3)) * 0.2;
};

// ============================================================ CARDO (planta atiradora)
function plant(b, pal, scale = 1) {
  const bark = M(pal.bark), thorn = M('bone', { color: pal.thorn || 0x3a3020 }), petal = M(pal.petal, { double: true });
  const body = b.piv(null, 'body', 0, 0, 0);
  for (let i = 0; i < 4; i++) {
    const a = i * PI / 2 + PI / 4;
    const lg = b.piv(body, 'legs.' + i, Math.sin(a) * 0.15, 0.32, Math.cos(a) * 0.15);
    lg.rotation.y = a;
    b.mesh(lg, taperTube('root', [[0, 0, 0], [0, -0.1, 0.12], [0, -0.26, 0.26], [0, -0.33, 0.36]], 0.07, 0.015, 12, 8, false), bark);
  }
  const stem = b.piv(body, 'stem', 0, 0, 0);
  b.mesh(stem, lathe('bulb', [[0, 0.22], [0.2, 0.28], [0.31, 0.52], [0.29, 0.82], [0.17, 1.02], [0.1, 1.12], [0, 1.15]], 20), bark);
  const rng = (k) => Math.abs(Math.sin(k * 12.9898) * 43758.5453) % 1;
  for (let i = 0; i < 24; i++) {
    const hgt = 0.35 + rng(i) * 0.6, a = rng(i + 50) * PI * 2;
    const rad = hgt < 0.55 ? 0.28 : hgt < 0.85 ? 0.29 : 0.18;
    const n = new THREE.Vector3(Math.sin(a), 0.25, Math.cos(a)).normalize();
    const q = new THREE.Quaternion().setFromUnitVectors(new THREE.Vector3(0, 1, 0), n), e = new THREE.Euler().setFromQuaternion(q);
    b.mesh(stem, GEO.cone(6), thorn, [Math.sin(a) * rad, hgt, Math.cos(a) * rad], [0.022, 0.13, 0.022], [e.x, e.y, e.z]);
  }
  const head = b.piv(stem, 'head', 0, 1.12, 0);
  for (let i = 0; i < 5; i++) {
    const yaw = b.piv(head, '', 0, 0, 0); yaw.rotation.y = i * PI * 2 / 5;
    const p = b.piv(yaw, 'petals.' + i, 0, 0, 0.04);
    b.ball(p, petal, [0, 0.01, 0.2], [0.12, 0.025, 0.23]);
  }
  b.ball(head, M('glow', { color: pal.core || 0xffc040, intensity: 3 }), [0, 0.04, 0], 0.09);
  for (let i = 0; i < 7; i++) { const a = i * 0.9; b.mesh(head, taperTube('stamen' + i, [[0, 0.02, 0], [Math.sin(a) * 0.05, 0.12, Math.cos(a) * 0.05], [Math.sin(a) * 0.07, 0.2, Math.cos(a) * 0.07]], 0.008, 0.004, 6, 5, false), M('plain', { color: 0xe8d070 })); }
  b.root.scale.setScalar(scale);
  b.props = { anim: 'plant' };
}
ANIM.plant = (r, phase, amt, t) => {
  r.legs.forEach((l, i) => { l.rotation.x = Math.sin(phase * 2 + i * 1.6) * 0.3 * amt; });
  r.stem.rotation.set(Math.sin(t * 1.3) * 0.04 + Math.sin(phase * 2) * 0.05 * amt, 0, Math.sin(t * 1.1) * 0.05);
  r.stem.position.y = Math.abs(Math.sin(phase * 2)) * 0.03 * amt;
  const open = r.petalOpen ?? 0.3;
  r.petals.forEach((p, i) => { p.rotation.x = -1.25 + open * 1.2 + Math.sin(t * 2 + i) * 0.05; });
};

// ============================================================ SERPE
const SEG = 14;
function serpent(b, pal, scale = 1, boss = false) {
  const sc = M(pal.scales), belly = M('plain', { color: pal.belly || 0x8a7a5a, rough: 0.5 }), eye = M('glow', { color: pal.eye || 0xffd030, intensity: 4 });
  for (let i = 0; i < SEG; i++) {
    const s = b.piv(null, 'seg.' + i, 0, 0, 0);
    const r = 0.17 * (1 - i / SEG * 0.72);
    b.ball(s, sc, [0, 0, 0], [r, r * 0.82, r * 1.45]);
    b.ball(s, belly, [0, -r * 0.35, 0], [r * 0.82, r * 0.5, r * 1.3]);
    if (i % 2 === 0 && i < SEG - 2) b.mesh(s, GEO.cone(6), M('bone', { color: pal.fin || 0x4a3a2a }), [0, r * 0.85, 0], [r * 0.18, r * 0.6, r * 0.5], [-0.4, 0, 0]);
  }
  const head = b.piv(null, 'head', 0, 0.3, 0.3);
  b.ball(head, sc, [0, 0.02, 0.08], [0.13, 0.09, 0.2]);
  b.ball(head, sc, [0, 0.04, -0.05], [0.14, 0.1, 0.12]);
  for (const s of [-1, 1]) {
    b.ball(head, eye, [s * 0.085, 0.07, 0.13], [0.025, 0.02, 0.03]);
    b.mesh(head, GEO.cone(6), M('bone'), [s * 0.04, -0.05, 0.22], [0.012, 0.06, 0.012], [PI - 0.2, 0, 0]);
    b.mesh(head, lathe('frill', [[0, 0], [0.1, 0.02], [0.16, 0.1], [0.18, 0.2], [0, 0.25]], 10), M(pal.frill || 'petal', { double: true }), [s * 0.11, 0.05, -0.08], [0.5, 1, 0.12], [0.3, 0, s * -1.1]);
    if (boss) b.mesh(head, taperTube('crest' + s, [[s * 0.06, 0.1, -0.02], [s * 0.1, 0.2, -0.1], [s * 0.1, 0.26, -0.24]], 0.03, 0.005, 12, 6), M('bone', { color: 0x6a5040 }));
  }
  const jaw = b.piv(head, 'jaw', 0, -0.03, 0);
  b.ball(jaw, sc, [0, -0.02, 0.08], [0.11, 0.04, 0.18]);
  b.ball(jaw, M('plain', { color: 0x401018, rough: 0.35 }), [0, 0.005, 0.08], [0.09, 0.02, 0.15]);
  b.root.scale.setScalar(scale);
  b.props = { anim: 'serpent' };
}
ANIM.serpent = (r, phase, amt, t) => {
  const ext = r.ext || 0;
  const sp = 0.2;
  let px = 0, pz = 0;
  for (let i = 0; i < SEG; i++) {
    const s = r.seg[i];
    const z = 0.1 - i * sp * (1 - ext * 0.35) + ext * 0.5;
    const A = (0.03 + i * 0.012) * (0.35 + amt * 0.8);
    const x = Math.sin(phase * 1.1 - i * 0.55 + t * (amt < 0.1 ? 1.2 : 0)) * A;
    const rr = 0.17 * (1 - i / SEG * 0.72);
    s.position.set(x, rr * 0.8, z);
    if (i > 0) s.rotation.y = Math.atan2(px - x, pz - z);
    px = x; pz = z;
  }
  const s0 = r.seg[0];
  const lift = 0.25 + (1 - amt) * 0.18 + ext * 0.1;
  r.head.position.set(s0.position.x * 0.6, lift + Math.sin(t * 2) * 0.02, s0.position.z + 0.22);
  r.head.rotation.set(0.25 - (1 - amt) * 0.3 + ext * 0.2, Math.sin(phase * 1.1 + 0.55) * 0.25 * amt + Math.sin(t * 0.8) * 0.2 * (1 - amt), 0);
  r.jaw.rotation.x = r.jawOpen ?? (0.05 + Math.max(0, Math.sin(t * 1.7)) * 0.12);
};

// ============================================================ BULBO DE MIASMA (agua-viva flutuante)
function jelly(b, pal) {
  const jm = M('jelly', { emi: pal.emi, opacity: 0.5 }), core = M('glow', { color: pal.core, intensity: 3 }), inner = M('glow', { color: pal.core, intensity: 0.9 });
  const body = b.piv(null, 'body', 0, 1.25, 0);
  const bell = b.piv(body, 'bell', 0, 0, 0);
  const bm = b.mesh(bell, lathe('bell', [[0, 0.34], [0.18, 0.32], [0.32, 0.22], [0.41, 0.05], [0.4, -0.04], [0.33, -0.01], [0.2, 0.04], [0, 0.06]], 28), jm);
  bm.userData.keep = true; bm.castShadow = false;
  b.ball(bell, core, [0, 0.14, 0], 0.11);
  for (let i = 0; i < 4; i++) { const a = i * PI / 2; b.ball(bell, inner, [Math.sin(a) * 0.13, 0.1, Math.cos(a) * 0.13], [0.06, 0.035, 0.1], [0, a, 0]); }
  for (let i = 0; i < 10; i++) { const a = i * PI / 5; b.ball(bell, jm, [Math.sin(a) * 0.38, -0.03, Math.cos(a) * 0.38], 0.04); }
  for (let i = 0; i < 8; i++) {
    const a = i * PI / 4 + 0.2;
    const t1 = b.piv(body, 'ten.' + i, Math.sin(a) * 0.3, -0.03, Math.cos(a) * 0.3);
    const m1 = b.mesh(t1, limb(0.028, 0.02, 0.45, 8), jm); m1.castShadow = false;
    const t2 = b.piv(t1, 'tent.' + i, 0, -0.45, 0);
    const m2 = b.mesh(t2, limb(0.02, 0.008, 0.5, 8), jm); m2.castShadow = false;
  }
  for (let i = 0; i < 3; i++) {
    const a = i * 2.1;
    const o = b.piv(body, 'oral.' + i, Math.sin(a) * 0.06, 0, Math.cos(a) * 0.06);
    const m = b.mesh(o, taperTube('oral', [[0, 0, 0], [0.05, -0.25, 0], [-0.04, -0.5, 0.03], [0.03, -0.75, 0]], 0.05, 0.012, 16, 8, false), M('jelly', { emi: pal.emi, opacity: 0.7 }));
    m.castShadow = false;
  }
  b.props = { anim: 'jelly' };
}
ANIM.jelly = (r, phase, amt, t) => {
  const puls = Math.sin(t * 3.2 + phase * 0.2);
  const sw = r.swell || 0;
  r.body.position.y = 1.2 + Math.sin(t * 1.6) * 0.1;
  r.bell.scale.set(1 + puls * 0.06 + sw * 0.45, 1 - puls * 0.08 + sw * 0.35, 1 + puls * 0.06 + sw * 0.45);
  r.body.rotation.set(0.12 * amt, 0, Math.sin(t * 0.9) * 0.05);
  for (let i = 0; i < 8; i++) {
    r.ten[i].rotation.set(0.3 * amt + Math.sin(t * 2.1 + i) * 0.18, 0, Math.cos(t * 1.7 + i * 1.3) * 0.15);
    r.tent[i].rotation.set(Math.sin(t * 2.6 + i * 0.7) * 0.35 + 0.2 * amt, 0, Math.sin(t * 2 + i) * 0.2);
  }
  r.oral.forEach((o, i) => { o.rotation.set(Math.sin(t * 1.5 + i) * 0.15 + 0.2 * amt, t * 0.3, 0); });
};

// ============================================================ VIDENTE SEM-ROSTO (e variantes)
function seer(b, pal, scale = 1, extra = {}) {
  const robe = M(pal.robe, { double: true }), mask = M(pal.mask), skin = M(pal.skin || 'skin_pale'), gold = M('gold'), glow = M('glow', { color: pal.glow, intensity: 4 });
  const body = b.piv(null, 'body', 0, 0.12, 0);
  b.mesh(body, lathe('robe', [[0.06, 1.62], [0.16, 1.56], [0.21, 1.42], [0.22, 1.2], [0.26, 0.8], [0.34, 0.4], [0.44, 0.06], [0.47, -0.02], [0.4, 0.0]], 28), robe);
  b.mesh(body, GEO.torus(0.25, 24), gold, [0, 1.12, 0], [0.225, 0.225, 0.2], [PI / 2, 0, 0]);
  for (let i = 0; i < 7; i++) b.mesh(body, GEO.cone(4), robe, [Math.sin(i * 0.9) * 0.42, 0.02, Math.cos(i * 0.9) * 0.42], [0.06, 0.16, 0.02], [PI, i * 0.9, 0]);
  const head = b.piv(body, 'head', 0, 1.62, 0.02);
  b.mesh(head, GEO.hemiShell, robe, [0, 0.12, -0.03], [0.15, 0.18, 0.16], [-0.3, 0, 0]);
  b.ball(head, mask, [0, 0.12, 0.03], [0.095, 0.125, 0.1]);
  b.mesh(head, GEO.rbox(0.006, 0.12, 0.01, 0.002), glow, [0, 0.12, 0.13]);
  if (extra.crown) for (let i = 0; i < 7; i++) { const a = (i - 3) * 0.32; b.mesh(head, GEO.cone(6), M('ice'), [Math.sin(a) * 0.1, 0.24 + (3 - Math.abs(i - 3)) * 0.02, Math.cos(a) * 0.04 - 0.02], [0.022, 0.16 + (3 - Math.abs(i - 3)) * 0.05, 0.022], [-0.15, 0, -a * 0.6]); }
  const halo = b.piv(body, 'halo', 0, 1.78, -0.2);
  b.mesh(halo, GEO.torus(0.06, 40), gold, [0, 0, 0], 0.26);
  for (let i = 0; i < 8; i++) { const a = i * PI / 4; b.mesh(halo, GEO.rbox(0.04, 0.06, 0.012, 0.005), glow, [Math.cos(a) * 0.26, Math.sin(a) * 0.26, 0], 1, [0, 0, a]); }
  const shoulders = [[0.19, 1.46, 0], [0.17, 1.28, 0.04]];
  let k = 0;
  for (const [x, y, z] of shoulders) for (const s of [-1, 1]) {
    const a = b.piv(body, 'arms.' + k, s * x, y, z);
    b.mesh(a, limb(0.045, 0.036, 0.4), robe);
    const f = b.piv(a, 'fore.' + k, 0, -0.4, 0);
    b.mesh(f, limb(0.03, 0.022, 0.38), skin);
    const h = b.piv(f, 'hand.' + k, 0, -0.38, 0);
    for (let j = 0; j < 3; j++) b.mesh(h, taperTube('finger' + j, [[0, 0, 0], [(j - 1) * 0.02, -0.06, 0.01], [(j - 1) * 0.025, -0.15, 0.04]], 0.009, 0.003, 8, 5, false), skin);
    k++;
  }
  if (extra.orbit) {
    const o = b.piv(body, 'orbit', 0, 1.1, 0);
    for (let i = 0; i < 6; i++) { const a = i * PI / 3; b.mesh(o, GEO.ico(0), M('crystal_void', { emi: 3 }), [Math.cos(a) * 0.75, Math.sin(a * 2) * 0.15, Math.sin(a) * 0.75], [0.07, 0.16, 0.07], [0, a, 0.3]); }
  }
  b.root.scale.setScalar(scale);
  b.props = { anim: 'seer' };
}
ANIM.seer = (r, phase, amt, t) => {
  r.body.position.y = 0.16 + Math.sin(t * 2) * 0.06;
  r.body.rotation.set(0.08 * amt, 0, Math.sin(t * 1.1) * 0.03);
  r.halo.rotation.z = t * 0.8;
  if (r.orbit) r.orbit.rotation.y = t * 1.2;
  const cast = r.cast || 0;
  r.arms.forEach((a, i) => {
    const s = i % 2 ? 1 : -1, lower = i >= 2;
    a.rotation.set(-0.25 - cast * (lower ? 1.2 : 2.6) + Math.sin(t * 1.5 + i) * 0.12, 0, s * (0.25 + (lower ? 0.2 : 0)) + s * cast * 0.4);
    r.fore[i].rotation.set(-0.5 - Math.sin(t * 1.8 + i * 0.7) * 0.2 + cast * 0.3, 0, 0);
  });
  r.head.rotation.set(Math.sin(t * 0.7) * 0.08, Math.sin(t * 0.5) * 0.25, Math.sin(t * 0.9) * 0.1);
};

// ============================================================ COURACADO (besouro blindado)
function beetle(b, pal, scale = 1) {
  const shell = M(pal.shell, pal.shellOpt || {}), hide = M(pal.hide || 'hide'), horn = M('bone', { color: pal.horn || 0x2a2420 }), eye = M('glow', { color: pal.eye || 0xff5020, intensity: 3 });
  const body = b.piv(null, 'body', 0, 0.48, 0);
  b.mesh(body, GEO.hemi, shell, [0, -0.02, -0.16], [0.5, 0.4, 0.46]);
  b.mesh(body, GEO.hemi, shell, [0, 0.0, 0.16], [0.44, 0.34, 0.3], [0.15, 0, 0]);
  b.ball(body, hide, [0, -0.06, 0], [0.42, 0.16, 0.56]);
  const head = b.piv(body, 'head', 0, 0.02, 0.44);
  b.mesh(head, GEO.hemi, shell, [0, -0.04, 0.02], [0.26, 0.2, 0.22], [0.5, 0, 0]);
  b.ball(head, hide, [0, -0.08, 0.06], [0.2, 0.12, 0.18]);
  b.mesh(head, taperTube('horn', [[0, 0.02, 0.1], [0, 0.16, 0.24], [0, 0.34, 0.3], [0, 0.46, 0.2]], 0.08, 0.008, 18, 10), horn);
  for (const s of [-1, 1]) {
    b.ball(head, eye, [s * 0.13, -0.02, 0.16], 0.028);
    b.mesh(head, taperTube('mand' + s, [[s * 0.08, -0.1, 0.17], [s * 0.12, -0.12, 0.3], [s * 0.04, -0.13, 0.38]], 0.028, 0.006, 10, 6), horn);
    b.mesh(head, GEO.cone(8), horn, [s * 0.16, 0.08, 0.02], [0.03, 0.14, 0.03], [0.4, 0, -s * 0.5]);
  }
  if (pal.spikes) for (let i = 0; i < 7; i++) b.mesh(body, GEO.cone(6), M(pal.spikes), [((i % 3) - 1) * 0.16, 0.32 + (i % 2) * 0.04, -0.3 + i * 0.09], [0.04, 0.22, 0.04], [-0.3, 0, ((i % 3) - 1) * 0.3]);
  for (let i = 0; i < 6; i++) {
    const s = i % 2 ? 1 : -1, z = 0.26 - Math.floor(i / 2) * 0.26;
    const l = b.piv(body, 'legs.' + i, s * 0.34, -0.08, z);
    b.mesh(l, limb(0.05, 0.036, 0.3, 10), hide);
    const kn = b.piv(l, 'lk.' + i, 0, -0.3, 0);
    b.mesh(kn, limb(0.036, 0.016, 0.34, 10), horn);
  }
  b.root.scale.setScalar(scale);
  b.props = { anim: 'beetle' };
}
ANIM.beetle = (r, phase, amt, t) => {
  for (let i = 0; i < 6; i++) {
    const s = i % 2 ? 1 : -1, grp = (i === 0 || i === 3 || i === 4) ? 0 : PI;
    const p = phase * 1.6 + grp;
    r.legs[i].rotation.set(0, Math.sin(p) * 0.35 * amt * s, s * (1.05 + Math.max(0, Math.cos(p)) * 0.25 * amt));
    r.lk[i].rotation.set(0, 0, -s * 1.75);
  }
  r.body.position.y = 0.48 + Math.abs(Math.sin(phase * 1.6)) * 0.02 * amt;
  r.body.rotation.set(r.lean || 0, 0, Math.sin(phase * 1.6) * 0.03 * amt);
  r.head.rotation.set(Math.sin(t * 1.4) * 0.06 + (r.lean || 0) * 0.8, Math.sin(t * 0.8) * 0.15 * (1 - amt), 0);
};

// ============================================================ MARIPOSA
function moth(b, pal, scale = 1) {
  const fur = M(pal.fur), eye = M('eye', { color: 0x1a0a08 }), leg = M('plain', { color: 0x2a2018, rough: 0.8 });
  const body = b.piv(null, 'body', 0, 1.4, 0);
  b.ball(body, fur, [0, 0, 0], [0.09, 0.09, 0.12]);
  for (let i = 0; i < 4; i++) b.ball(body, fur, [0, -0.01 - i * 0.01, -0.13 - i * 0.07], [0.075 - i * 0.012, 0.07 - i * 0.01, 0.06]);
  b.ball(body, fur, [0, 0.01, 0.12], 0.065);
  for (const s of [-1, 1]) {
    b.ball(body, eye, [s * 0.045, 0.02, 0.16], 0.036);
    b.mesh(body, taperTube('ant' + s, [[s * 0.02, 0.05, 0.16], [s * 0.08, 0.14, 0.24], [s * 0.14, 0.18, 0.3]], 0.008, 0.004, 10, 5, false), leg);
  }
  const wt = M('plain'); void wt;
  const wm = new THREE.MeshStandardMaterial({ map: wingTexture(pal.wing, pal.eyespot), transparent: true, alphaTest: 0.4, side: THREE.DoubleSide, roughness: 0.9 });
  const specs = [[0.02, 0.03, 0.55, 0.42, 0.1], [0.0, -0.08, 0.42, 0.34, -0.4]];
  let k = 0;
  for (const [z, y, w, h, rot] of specs) for (const s of [-1, 1]) {
    const p = b.piv(body, 'wings.' + k, s * 0.06, y + 0.04, z);
    const m = b.mesh(p, wing('moth' + w, w, h, 0.08), wm, [0, 0, 0], [s, 1, 1], [-PI / 2, 0, s * rot]);
    m.userData.keep = true;
    k++;
  }
  for (let i = 0; i < 6; i++) { const s = i % 2 ? 1 : -1; b.mesh(body, taperTube('mleg' + i, [[0, 0, 0], [s * 0.08, -0.08, 0], [s * 0.1, -0.18, 0.02]], 0.008, 0.004, 6, 4, false), leg, [0, -0.05, 0.05 - Math.floor(i / 2) * 0.05]); }
  b.root.scale.setScalar(scale);
  b.props = { anim: 'moth' };
}
ANIM.moth = (r, phase, amt, t) => {
  const f = Math.sin(t * 24 + phase);
  r.wings.forEach((w, i) => { const s = i % 2 ? 1 : -1; w.rotation.set(0, 0, s * (f * 0.85 + 0.15)); });
  r.body.position.y = 1.35 + Math.sin(t * 3.1 + phase) * 0.18 + (r.dive || 0) * -0.9;
  r.body.rotation.set(0.15 + Math.sin(t * 2) * 0.1 + (r.dive || 0) * 0.6, 0, Math.sin(t * 2.7) * 0.2);
};

// ============================================================ ESPREITADOR (fera quadrupede)
function beast(b, pal, scale = 1) {
  const hide = M(pal.hide), spike = M(pal.spike, { emi: 2.5 }), eye = M('glow', { color: pal.eye, intensity: 5 }), bone = M('bone', { color: 0xd8d0c0 });
  const body = b.piv(null, 'body', 0, 0.68, 0);
  b.ball(body, hide, [0, 0.03, 0.14], [0.19, 0.23, 0.3]);
  b.ball(body, hide, [0, 0.02, -0.26], [0.15, 0.17, 0.25]);
  for (let i = 0; i < 6; i++) b.mesh(body, GEO.cone(5), spike, [0, 0.2 + Math.sin(i * 0.6) * 0.03, -0.35 + i * 0.12], [0.03, 0.16 + (i % 2) * 0.06, 0.04], [-0.35, 0, (i % 2 ? 1 : -1) * 0.2]);
  const tail = b.piv(body, 'tail', 0, 0.05, -0.46);
  b.mesh(tail, taperTube('tail', [[0, 0, 0], [0, -0.05, -0.2], [0, -0.2, -0.4], [0, -0.28, -0.55]], 0.05, 0.01, 14, 8), hide);
  const head = b.piv(body, 'head', 0, 0.18, 0.4);
  b.mesh(head, limb(0.08, 0.07, 0.18), hide, [0, 0.0, -0.05], 1, [-1.1, 0, 0]);
  b.ball(head, hide, [0, 0.05, 0.12], [0.1, 0.1, 0.13]);
  b.ball(head, hide, [0, 0.02, 0.24], [0.06, 0.055, 0.12]);
  for (const s of [-1, 1]) {
    b.ball(head, eye, [s * 0.055, 0.08, 0.2], [0.018, 0.012, 0.02]);
    b.mesh(head, GEO.cone(5), spike, [s * 0.06, 0.16, 0.06], [0.025, 0.14, 0.025], [-0.6, 0, s * 0.35]);
  }
  const jaw = b.piv(head, 'jaw', 0, -0.02, 0.12);
  b.ball(jaw, hide, [0, -0.02, 0.1], [0.05, 0.03, 0.11]);
  for (let i = 0; i < 4; i++) b.mesh(head, GEO.cone(5), bone, [(i - 1.5) * 0.025, -0.02, 0.3], [0.007, 0.03, 0.007], [PI, 0, 0]);
  for (let side = 0; side < 2; side++) {
    const s = side ? 1 : -1;
    const fl = b.piv(body, 'fl.' + side, s * 0.12, -0.05, 0.26);
    b.mesh(fl, limb(0.06, 0.042, 0.33), hide);
    const fe = b.piv(fl, 'fe.' + side, 0, -0.33, 0);
    b.mesh(fe, limb(0.042, 0.03, 0.3), hide);
    b.ball(fe, hide, [0, -0.32, 0.03], [0.04, 0.025, 0.06]);
    const bl = b.piv(body, 'bl.' + side, s * 0.12, -0.02, -0.33);
    b.mesh(bl, limb(0.075, 0.05, 0.3), hide);
    const bk = b.piv(bl, 'bk.' + side, 0, -0.3, 0);
    b.mesh(bk, limb(0.045, 0.032, 0.28), hide);
    const bf = b.piv(bk, 'bf.' + side, 0, -0.28, 0);
    b.mesh(bf, limb(0.03, 0.024, 0.18), hide);
    b.ball(bf, hide, [0, -0.19, 0.03], [0.04, 0.025, 0.06]);
  }
  b.root.scale.setScalar(scale);
  b.props = { anim: 'beast' };
}
ANIM.beast = (r, phase, amt, t) => {
  for (let i = 0; i < 2; i++) {
    const off = i ? PI : 0;
    const pf = phase * 1.2 + off, pb = pf + PI * 0.85;
    r.fl[i].rotation.set(Math.sin(pf) * 0.55 * amt, 0, 0);
    r.fe[i].rotation.set(Math.max(0, Math.cos(pf)) * 0.9 * amt, 0, 0);
    r.bl[i].rotation.set(-0.4 + Math.sin(pb) * 0.5 * amt, 0, 0);
    r.bk[i].rotation.set(1.0 + Math.max(0, -Math.cos(pb)) * 0.4 * amt, 0, 0);
    r.bf[i].rotation.set(-0.72, 0, 0);
  }
  r.body.position.y = 0.66 + Math.abs(Math.sin(phase * 1.2)) * 0.05 * amt;
  r.body.rotation.set(Math.sin(phase * 2.4) * 0.04 * amt + (r.crouch || 0), 0, 0);
  r.tail.rotation.set(Math.sin(t * 2) * 0.1, Math.sin(t * 3 + phase) * 0.4, 0);
  r.head.rotation.set(-0.05 + Math.sin(t * 1.2) * 0.05 - (r.crouch || 0) * 0.6, Math.sin(t * 0.7) * 0.2 * (1 - amt), 0);
  r.jaw.rotation.x = r.jawOpen ?? 0.08;
};

// ============================================================ BRUTOS (chefes humanoides gigantes)
function brute(b, kind) {
  const obs = kind === 'colosso';
  const skin = obs ? M('obsidian', { emi: 1.3 }) : M('skin_pale', { color: 0xb8c0a8 });
  const belly = obs ? skin : M('belly');
  const bone = M('bone', { color: obs ? 0x3a3438 : 0xc8bca8 });
  const hips = b.piv(null, 'hips', 0, 0.62, 0);
  b.ball(hips, skin, [0, 0, 0], [0.24, 0.16, 0.18]);
  for (const side of [-1, 1]) {
    const L = side < 0 ? 'L' : 'R';
    const leg = b.piv(hips, 'leg' + L, side * 0.15, -0.02, 0);
    b.mesh(leg, limb(0.12, 0.09, 0.32), skin);
    const knee = b.piv(leg, 'knee' + L, 0, -0.32, 0);
    b.mesh(knee, limb(0.09, 0.08, 0.3), skin);
    const foot = b.piv(knee, 'foot' + L, 0, -0.3, 0);
    b.ball(foot, skin, [0, -0.02, 0.05], [0.1, 0.06, 0.16]);
  }
  const torso = b.piv(hips, 'torso', 0, 0.06, 0);
  b.mesh(torso, lathe('bruteTorso', [[0, -0.05], [0.22, -0.04], [0.26, 0.12], [0.3, 0.32], [0.36, 0.5], [0.34, 0.6], [0.22, 0.7], [0, 0.72]], 24), skin, [0, 0, 0], [1.05, 1, 0.8]);
  if (!obs) { b.ball(torso, belly, [0, 0.16, 0.12], [0.27, 0.25, 0.22]); }
  else { b.ball(torso, M('glow', { color: 0xff7a20, intensity: 4 }), [0, 0.44, 0.22], [0.1, 0.1, 0.06]); }
  for (let i = 0; i < 6; i++) b.mesh(torso, obs ? GEO.ico(0) : GEO.cone(6), bone, [((i % 3) - 1) * 0.16, 0.58 + (i > 2 ? -0.14 : 0), -0.2], obs ? [0.07, 0.14, 0.07] : [0.04, 0.22, 0.04], [-0.8, 0, ((i % 3) - 1) * 0.4]);
  const head = b.piv(torso, 'head', 0, 0.62, 0.14);
  if (obs) {
    b.mesh(head, GEO.ico(1), skin, [0, 0.12, 0], [0.16, 0.15, 0.15]);
    b.mesh(head, GEO.rbox(0.18, 0.025, 0.04, 0.01), M('glow', { color: 0xffa040, intensity: 6 }), [0, 0.13, 0.13]);
  } else {
    b.ball(head, skin, [0, 0.1, 0.02], [0.14, 0.13, 0.14]);
    b.ball(head, skin, [0, 0.03, 0.08], [0.12, 0.06, 0.1]);
    for (const s of [-1, 1]) b.ball(head, M('glow', { color: 0xc8ff60, intensity: 3 }), [s * 0.05, 0.13, 0.13], 0.018);
    for (let i = 0; i < 5; i++) b.mesh(head, GEO.cone(5), bone, [(i - 2) * 0.03, 0.02, 0.17], [0.012, 0.045, 0.012], [0.2, 0, 0]);
  }
  for (const side of [-1, 1]) {
    const L = side < 0 ? 'L' : 'R';
    const arm = b.piv(torso, 'arm' + L, side * 0.4, 0.56, 0);
    b.ball(arm, skin, [0, 0, 0], [0.17, 0.15, 0.16]);
    b.mesh(arm, limb(0.14, 0.11, 0.42), skin);
    const el = b.piv(arm, 'elbow' + L, 0, -0.42, 0);
    b.mesh(el, limb(0.12, 0.13, 0.42), skin);
    const hand = b.piv(el, 'hand' + L, 0, -0.5, 0);
    b.ball(hand, skin, [0, 0, 0], [0.13, 0.12, 0.12]);
    for (let k = 0; k < 3; k++) b.mesh(hand, GEO.cone(6), bone, [(k - 1) * 0.06, -0.1, 0.07], [0.022, 0.1, 0.022], [PI - 0.4, 0, 0]);
    if (obs) for (let k = 0; k < 3; k++) b.mesh(arm, GEO.ico(0), bone, [side * 0.1, 0.1 - k * 0.14, -0.05], [0.07, 0.1, 0.07], [0, k, side]);
  }
  b.root.scale.setScalar(obs ? 2.1 : 2.2);
  b.props = { anim: 'humanoid', legLen: 0.62, baseArm: -0.15 };
}

// ============================================================ FLOR ANCESTRAL (chefe estatico)
function flower(b) {
  const bark = M('plant_dark'), petal = M('petal', { double: true }), thorn = M('bone', { color: 0x3a3020 });
  const body = b.piv(null, 'body', 0, 0, 0);
  for (let i = 0; i < 7; i++) {
    const a = i * PI * 2 / 7;
    b.mesh(body, taperTube('broot' + i, [[0, 0.5, 0], [Math.sin(a) * 0.5, 0.3, Math.cos(a) * 0.5], [Math.sin(a) * 1.1, 0.05, Math.cos(a) * 1.1], [Math.sin(a) * 1.5, -0.1, Math.cos(a) * 1.5]], 0.22, 0.04, 16, 10), bark);
  }
  const stem = b.piv(body, 'stem', 0, 0, 0);
  b.mesh(stem, lathe('fstem', [[0, 0.2], [0.55, 0.4], [0.62, 1.0], [0.45, 1.7], [0.35, 2.2], [0, 2.3]], 24), bark);
  for (let i = 0; i < 30; i++) { const a = i * 2.4, hh = 0.5 + (i % 10) * 0.16; b.mesh(stem, GEO.cone(6), thorn, [Math.sin(a) * 0.55 * (1 - hh / 3), hh, Math.cos(a) * 0.55 * (1 - hh / 3)], [0.05, 0.3, 0.05], [Math.cos(a) * 1.2, 0, -Math.sin(a) * 1.2]); }
  const head = b.piv(stem, 'head', 0, 2.25, 0.1);
  for (let i = 0; i < 8; i++) {
    const yaw = b.piv(head, '', 0, 0, 0); yaw.rotation.y = i * PI / 4;
    const p = b.piv(yaw, 'petals.' + i, 0, 0, 0.3);
    b.ball(p, petal, [0, 0, 0.55], [0.36, 0.06, 0.62]);
  }
  const jaw = b.piv(head, 'jaw', 0, 0.1, 0);
  b.mesh(head, GEO.hemi, M('plant'), [0, 0.1, 0], [0.55, 0.45, 0.55], [PI, 0, 0]);
  b.mesh(jaw, GEO.hemi, M('plant'), [0, 0, 0], [0.55, 0.45, 0.55]);
  b.ball(head, M('glow', { color: 0xff3060, intensity: 3 }), [0, 0.1, 0], 0.35);
  for (let i = 0; i < 12; i++) { const a = i * PI / 6; b.mesh(jaw, GEO.cone(5), M('bone'), [Math.sin(a) * 0.48, 0.02, Math.cos(a) * 0.48], [0.04, 0.16, 0.04], [0, 0, 0]); b.mesh(head, GEO.cone(5), M('bone'), [Math.sin(a) * 0.48, 0.08, Math.cos(a) * 0.48], [0.04, 0.16, 0.04], [PI, 0, 0]); }
  for (let i = 0; i < 4; i++) {
    const a = i * PI / 2 + 0.4;
    const v = b.piv(stem, 'vines.' + i, Math.sin(a) * 0.45, 1.3, Math.cos(a) * 0.45);
    v.rotation.y = a;
    b.mesh(v, taperTube('vine', [[0, 0, 0], [0, 0.4, 0.5], [0, 0.3, 1.2], [0, -0.2, 1.8], [0, -0.6, 2.2]], 0.12, 0.03, 24, 8), bark);
  }
  b.props = { anim: 'flower' };
}
ANIM.flower = (r, phase, amt, t) => {
  r.stem.rotation.set(Math.sin(t * 0.8) * 0.04, 0, Math.sin(t * 0.6) * 0.05);
  r.jaw.rotation.x = -(r.jawOpen ?? (0.15 + Math.sin(t * 1.3) * 0.08));
  r.petals.forEach((p, i) => { p.rotation.x = -0.35 + Math.sin(t * 1.2 + i) * 0.08 - (r.jawOpen || 0) * 0.3; });
  r.vines.forEach((v, i) => { v.rotation.x = Math.sin(t * 1.4 + i * 1.7) * 0.25 + (r.lash === i ? -0.9 : 0); v.rotation.z = Math.sin(t * 1.1 + i) * 0.2; });
};

// ============================================================ fabrica
const PAL = {
  rastejante: { skin: 'skin_pale' },
  afogado: { skin: 'skin_drowned' },
  cardo: { bark: 'plant', petal: 'petal', core: 0xffc040 },
  cardo_gelo: { bark: 'plant_dark', petal: 'ice', core: 0x9fe8ff, thorn: 0xcfe8f0 },
  serpe: { scales: 'scales', frill: 'petal', eye: 0xffd030 },
  serpe_rubra: { scales: 'scales_red', frill: 'petal', eye: 0xff3020, belly: 0x5a3a2a },
  jelly: { emi: 0x6aff40, core: 0xb8ff50 },
  jelly_void: { emi: 0x9a40ff, core: 0xc080ff },
  seer: { robe: 'robe', mask: 'porcelain', glow: 0xc060ff },
  seer_ice: { robe: 'cloth_ice', mask: 'ice', glow: 0x80e8ff, skin: 'ice' },
  seer_void: { robe: 'crystal_void', mask: 'porcelain', glow: 0xa050ff, skin: 'crystal_void' },
  beetle: { shell: 'carapace', hide: 'hide', eye: 0xff5020 },
  beetle_ice: { shell: 'carapace_ice', hide: 'hide', eye: 0x80e0ff, spikes: 'ice', horn: 0xa0c0d0 },
  beetle_magma: { shell: 'obsidian', shellOpt: { emi: 1.5 }, hide: 'hide', eye: 0xffa020 },
  moth: { fur: 'moth', wing: '#7a6a52', eyespot: '#c05030' },
  moth_snow: { fur: 'cloth_white', wing: '#d8dce0', eyespot: '#5a8ab0' },
  beast_void: { hide: 'hide', spike: 'crystal_void', eye: 0xc070ff },
  beast_ice: { hide: 'fur_white', spike: 'ice', eye: 0x80e8ff },
};

export function buildCreature(type) {
  const b = new Builder(type);
  switch (type) {
    case 'rastejante': crawler(b, PAL.rastejante); b.root.scale.setScalar(1.15); break;
    case 'afogado': crawler(b, PAL.afogado); b.root.scale.setScalar(1.2); break;
    case 'cardo': plant(b, PAL.cardo); break;
    case 'cardo_gelo': plant(b, PAL.cardo_gelo); break;
    case 'serpe': serpent(b, PAL.serpe, 1); break;
    case 'serpezinha': serpent(b, PAL.serpe, 0.55); break;
    case 'veshkara': serpent(b, PAL.serpe_rubra, 2.7, true); break;
    case 'medusa': jelly(b, PAL.jelly); break;
    case 'medusa_vazio': jelly(b, PAL.jelly_void); break;
    case 'vidente': seer(b, PAL.seer); break;
    case 'aparicao': seer(b, PAL.seer_ice, 0.95); break;
    case 'ysra': seer(b, PAL.seer_ice, 2.1, { crown: true }); break;
    case 'arauto': seer(b, PAL.seer_void, 2.0, { orbit: true }); break;
    case 'couracado': beetle(b, PAL.beetle); break;
    case 'casco': beetle(b, PAL.beetle_ice); break;
    case 'couracado_magma': beetle(b, PAL.beetle_magma); break;
    case 'mariposa': moth(b, PAL.moth); break;
    case 'mariposa_neve': moth(b, PAL.moth_snow); break;
    case 'espreitador': beast(b, PAL.beast_void); break;
    case 'lobo_gelo': beast(b, PAL.beast_ice, 1.05); break;
    case 'gorran': brute(b, 'gorran'); break;
    case 'colosso': brute(b, 'colosso'); break;
    case 'flor': flower(b); break;
    default: crawler(b, PAL.rastejante);
  }
  return b;
}

// poses de ataque por tipo de animacao (k = 0..1 da preparacao, hit = depois do golpe)
export function attackPose(r, kind, k, after, t) {
  switch (r.anim) {
    case 'crawler': {
      const up = after ? Math.max(0, 1 - after * 5) : k;
      r.body.rotation.x = -0.75 * up + (after ? 0.25 * Math.max(0, 1 - after * 3) : 0);
      r.body.position.y += 0.25 * up;
      for (let i = 0; i < 2; i++) { r.fl[i].rotation.x = -0.55 - 1.4 * up + (after ? 0.8 : 0); r.fe[i].rotation.x = 0.3; }
      r.jaw.rotation.x = 0.2 + up * 0.5;
      break;
    }
    case 'plant': r.petalOpen = kind === 'shoot' ? 0.3 + Math.min(1, k) * 0.9 : 0.3; if (kind === 'shoot') r.stem.rotation.x = -0.15 * Math.min(1, k) + (after ? 0.25 : 0); break;
    case 'serpent': r.ext = after ? Math.max(0, 1 - after * 3) : -0.4 * k; r.jawOpen = 0.1 + k * 0.6; break;
    case 'jelly': r.swell = k; break;
    case 'seer': r.cast = kind === 'summon' ? 1 : Math.min(1, k * 1.3); break;
    case 'beetle': r.lean = kind === 'charge' ? 0.18 : 0.12 * k; break;
    case 'moth': r.dive = after ? Math.max(0, 1 - after * 3) : k * 0.3; break;
    case 'beast': r.crouch = after ? 0 : 0.2 * k; r.jawOpen = 0.1 + k * 0.5; break;
    default: return false;
  }
  return true;
}
export function resetPose(r) { r.petalOpen = 0.3; r.ext = 0; r.jawOpen = undefined; r.swell = 0; r.cast = 0; r.lean = 0; r.dive = 0; r.crouch = 0; r.lash = -1; }
