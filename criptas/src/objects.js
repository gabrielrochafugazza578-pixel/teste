// Objetos interativos (baus, vasos, braseiros, portoes, portal, altar), saques e efeitos visuais.
import * as THREE from 'three';
import { propMats, makeFlame } from './props.js';
import { ringTexture, charTex } from './textures.js';
import { makeWeapon, makeBow, makeNpc, animateWalk, M as makeMatK } from './models.js';
import { GEO, lathe, taperTube } from './geo.js';
import { RARITY } from './items.js';

let _ring = null;
const ringTex = () => (_ring || (_ring = ringTexture()));
const box = (w, h, d, m) => { const me = new THREE.Mesh(GEO.rbox(w, h, d, Math.min(w, h, d) * 0.2), m); me.castShadow = true; me.receiveShadow = true; return me; };
const mesh = (geo, m) => { const me = new THREE.Mesh(geo, m); me.castShadow = true; me.receiveShadow = true; return me; };
const makeMat = (kind, o) => makeMatK(kind, o);

// ---------- bau ----------
export class Chest {
  constructor(game, x, z, big) {
    this.game = game; this.x = x; this.z = z; this.big = big; this.opened = false; this.t = 0;
    const M = propMats();
    const g = new THREE.Group();
    const s = big ? 1.15 : 0.9;
    const band = big ? M.gold : M.iron;
    const base = mesh(GEO.rbox(0.9, 0.48, 0.6, 0.05), M.wood); base.position.y = 0.24; g.add(base);
    for (const x2 of [-0.42, 0.42]) { const b = mesh(GEO.rbox(0.07, 0.5, 0.63, 0.02), band); b.position.set(x2, 0.25, 0); g.add(b); }
    this.lid = new THREE.Group(); this.lid.position.set(0, 0.48, -0.3); g.add(this.lid);
    const lid = mesh(new THREE.CylinderGeometry(0.3, 0.3, 0.9, 16, 1, false, 0, Math.PI), M.wood); lid.rotation.z = Math.PI / 2; lid.rotation.y = Math.PI / 2; lid.position.set(0, 0, 0.3); lid.scale.set(1, 1, 0.55); this.lid.add(lid);
    for (const x2 of [-0.42, 0.42]) { const b = mesh(new THREE.TorusGeometry(0.3, 0.025, 6, 16, Math.PI), band); b.rotation.y = Math.PI / 2; b.position.set(x2, 0, 0.3); b.scale.set(1, 0.55, 1); this.lid.add(b); }
    const lock = mesh(GEO.rbox(0.12, 0.14, 0.05, 0.02), M.gold); lock.position.set(0, 0.46, 0.31); g.add(lock);
    g.scale.setScalar(s);
    g.position.set(x, game.floorAt(x, z), z);
    g.rotation.y = Math.PI / 4 + (Math.random() - 0.5) * 0.4;
    this.mesh = g; game.scene.add(g);
    this.glow = game.addLight(x, g.position.y + 0.9, z, 0xffc060, 0, 3);
  }
  get prompt() { return this.opened ? null : 'Abrir baú'; }
  interact() {
    if (this.opened) return;
    this.opened = true; this.t = 0;
    const g = this.game;
    g.audio.play('chest');
    const n = this.big ? 22 + Math.floor(Math.random() * 12) : 8 + Math.floor(Math.random() * 8);
    g.spawnGold(this.x, this.z, n, 3);
    g.dropItem(this.x, this.z, { bonus: this.big ? 0.7 : 0.25 });
    if (this.big) g.dropItem(this.x, this.z, { bonus: 0.3 });
    if (Math.random() < 0.6) g.spawnLoot('arrows', this.x, this.z);
    this.glow.intensity = 4;
    g.onChestOpened(this);
  }
  update(dt) {
    if (this.opened && this.t < 1) {
      this.t += dt * 2;
      this.lid.rotation.x = -1.9 * Math.min(1, this.t) * (1 + Math.sin(Math.min(1, this.t) * Math.PI) * 0.15);
      this.game.particles.sparks(this.x, this.mesh.position.y + 0.7, this.z, 2, [1, 0.85, 0.4], 3);
    }
    if (this.opened) this.glow.intensity = Math.max(0, this.glow.intensity - dt * 1.5);
  }
}

// ---------- vaso quebravel ----------
const potGeo = new THREE.LatheGeometry([
  [0, 0], [0.16, 0], [0.24, 0.1], [0.27, 0.25], [0.22, 0.42], [0.12, 0.5], [0.13, 0.58], [0.16, 0.6], [0, 0.6],
].map(p => new THREE.Vector2(p[0], p[1])), 16);
export class Pot {
  constructor(game, x, z) {
    this.game = game; this.x = x; this.z = z; this.dead = false; this.r = 0.3;
    const M = propMats();
    this.mesh = new THREE.Mesh(potGeo, Math.random() < 0.5 ? M.clay : M.clay2);
    this.mesh.castShadow = true; this.mesh.receiveShadow = true;
    const s = 0.8 + Math.random() * 0.5;
    this.mesh.scale.setScalar(s);
    this.mesh.position.set(x, game.floorAt(x, z), z);
    game.scene.add(this.mesh);
  }
  smash() {
    if (this.dead) return;
    this.dead = true;
    const g = this.game;
    g.scene.remove(this.mesh);
    g.audio.play('pot');
    g.particles.blood(this.x, this.mesh.position.y + 0.3, this.z, 12, [0.45, 0.25, 0.15]);
    g.particles.dust(this.x, this.mesh.position.y + 0.2, this.z, 6);
    const r = Math.random();
    if (r < 0.45) g.spawnGold(this.x, this.z, 1 + Math.floor(Math.random() * 4), 1.5);
    else if (r < 0.62) g.spawnLoot('arrows', this.x, this.z);
    else if (r < 0.72) g.spawnLoot('heart', this.x, this.z);
    const c = g.dg.idx(Math.floor(this.x), Math.floor(this.z));
    if (g.dg.solid[c] === 2) g.dg.solid[c] = 0;
  }
}

// ---------- objetivo do andar: braseiro / cristal / totem / selo ----------
const FLAME_COL = { catacumbas: [0xff8a3a, 0xffd0a0], minas: [0xff8a3a, 0xffd0a0], forja: [0xff6a20, 0xffc080], geleira: [0x70d8ff, 0xc0f0ff], pantano: [0x70ff60, 0xc0ffa0], vazio: [0xb060ff, 0xe0c0ff] };
export class Brazier {
  constructor(game, x, z) {
    this.game = game; this.x = x; this.z = z; this.lit = false; this.t = 0;
    const M = propMats();
    const tk = game.dg.themeKey;
    const [lc, fc] = FLAME_COL[tk] || FLAME_COL.catacumbas;
    this.col = lc;
    const g = new THREE.Group();
    if (tk === 'geleira' || tk === 'vazio') {
      const mat = tk === 'geleira' ? M.ice : M.crystalV;
      g.add(mesh(lathe('bzped', [[0, 0], [0.55, 0], [0.5, 0.2], [0.3, 0.35], [0.3, 0.6], [0.45, 0.7], [0, 0.72]], 16), tk === 'geleira' ? M.rock : M.basalt));
      const cr = mesh(new THREE.OctahedronGeometry(0.4, 0), mat); cr.scale.set(0.8, 1.6, 0.8); cr.position.y = 1.5; g.add(cr); this.spin = cr;
      this.coal = cr;
    } else if (tk === 'pantano') {
      const tot = mesh(taperTube('totem', [[0, 0, 0], [0.05, 0.6, 0], [-0.03, 1.2, 0.02], [0, 1.7, 0]], 0.28, 0.2, 12, 10), M.log); g.add(tot);
      for (let i = 0; i < 3; i++) { const r = mesh(new THREE.TorusGeometry(0.26, 0.03, 6, 16), M.rune); r.rotation.x = Math.PI / 2; r.position.y = 0.5 + i * 0.4; g.add(r); }
      const mask = mesh(new THREE.SphereGeometry(0.2, 12, 10), M.bone); mask.scale.set(1, 1.2, 0.6); mask.position.set(0, 1.35, 0.18); g.add(mask);
      this.coal = mask;
    } else {
      g.add(mesh(lathe('bzped2', [[0, 0], [0.5, 0], [0.48, 0.12], [0.3, 0.25], [0.24, 0.7], [0.34, 0.85], [0.3, 0.9], [0, 0.9]], 18), M.stone));
      const bowl = mesh(lathe('bzbowl', [[0.1, 0], [0.34, 0.02], [0.55, 0.26], [0.58, 0.34], [0.5, 0.3], [0.3, 0.1], [0, 0.08]], 18), M.iron); bowl.position.y = 0.88; g.add(bowl);
      const coal = mesh(new THREE.CylinderGeometry(0.48, 0.48, 0.05, 16), makeMat('glow', { color: 0x401005, intensity: 0.4 }));
      coal.position.y = 1.12; g.add(coal); this.coal = coal;
    }
    const rune = new THREE.Mesh(new THREE.RingGeometry(0.9, 1.1, 40), new THREE.MeshBasicMaterial({ color: lc, transparent: true, opacity: 0.35, blending: THREE.AdditiveBlending, depthWrite: false }));
    rune.rotation.x = -Math.PI / 2; rune.position.y = 0.03; g.add(rune); this.rune = rune;
    g.position.set(x, game.floorAt(x, z), z);
    this.mesh = g; game.scene.add(g);
    this.flame = makeFlame(3.2, fc); this.flame.position.set(x, g.position.y + 1.8, z); this.flame.visible = false; game.scene.add(this.flame);
    this.light = game.addLight(x, g.position.y + 2, z, lc, 0, 14, 1, true);
  }
  get prompt() { const o = this.game.theme.obj; return this.lit ? null : `${o.verb} o ${o.noun}`; }
  interact() {
    if (this.lit) return;
    this.lit = true; this.t = 0;
    this.flame.visible = true;
    if (this.coal.material.emissiveIntensity !== undefined) { this.coal.material = this.coal.material.clone(); this.coal.material.emissive = new THREE.Color(this.col); this.coal.material.emissiveIntensity = 4; }
    this.game.audio.play('brazier');
    const c = this._c || (this._c = new THREE.Color(this.col));
    this.game.particles.burst(this.x, this.mesh.position.y + 1.3, this.z, 60, [c.r, c.g, c.b], 6, 0.9, 0.4);
    this.game.onBrazierLit(this);
  }
  update(dt, time) {
    this.rune.material.opacity = this.lit ? 0.7 : 0.25 + Math.sin(time * 2) * 0.1;
    if (this.spin) { this.spin.rotation.y += dt * (this.lit ? 2 : 0.4); this.spin.position.y = 1.5 + Math.sin(time * 1.5) * 0.08; }
    const c = this._c || (this._c = new THREE.Color(this.col));
    if (!this.lit) { if (Math.random() < dt * 4) this.game.particles.ember(this.x + (Math.random() - 0.5) * 0.6, this.mesh.position.y + 1.15, this.z + (Math.random() - 0.5) * 0.6, [c.r, c.g, c.b]); return; }
    this.t += dt;
    this.light.intensity = Math.min(30, this.t * 40) * (0.9 + Math.sin(time * 13) * 0.05 + Math.sin(time * 7.3) * 0.05);
    const f = 1 + Math.sin(time * 17) * 0.06;
    this.flame.scale.set(1.1 * f, 1.9 / f, 1);
    if (Math.random() < dt * 30) this.game.particles.fire(this.x, this.mesh.position.y + 1.2, this.z, 1, 0.7, [c.r, c.g, c.b], 0.8);
    if (Math.random() < dt * 8) this.game.particles.ember(this.x, this.mesh.position.y + 1.6, this.z, [c.r, c.g, c.b]);
  }
}

// ---------- portoes do chefe ----------
export class Gates {
  constructor(game, cells) {
    this.game = game; this.cells = cells; this.closed = true; this.h = 0; this.target = 0;
    const M = propMats();
    this.group = new THREE.Group();
    const bar = new THREE.CylinderGeometry(0.045, 0.045, 3, 6);
    const set = new Set(cells.map(c => c.x + ',' + c.z));
    for (const c of cells) {
      const g = new THREE.Group();
      const horiz = set.has((c.x + 1) + ',' + c.z) || set.has((c.x - 1) + ',' + c.z);
      for (let i = 0; i < 4; i++) {
        const m = new THREE.Mesh(bar, M.iron); m.castShadow = true;
        const o = -0.375 + i * 0.25;
        if (horiz) m.position.set(o, 1.5, 0); else m.position.set(0, 1.5, o);
        g.add(m);
      }
      const cross = box(horiz ? 1 : 0.08, 0.1, horiz ? 0.08 : 1, M.iron); cross.position.y = 2.2; g.add(cross);
      const cross2 = box(horiz ? 1 : 0.08, 0.1, horiz ? 0.08 : 1, M.iron); cross2.position.y = 0.6; g.add(cross2);
      g.position.set(c.x + 0.5, game.floorAt(c.x + 0.5, c.z + 0.5), c.z + 0.5);
      this.group.add(g);
    }
    game.scene.add(this.group);
    this.key = new Set(cells.map(c => game.dg.idx(c.x, c.z)));
  }
  blocks(ci) { return this.closed && this.key.has(ci); }
  open() { if (!this.closed) return; this.closed = false; this.target = -3.1; this.game.audio.play('gate'); this.game.shake(0.3); }
  close() { if (this.closed) return; this.closed = true; this.target = 0; this.game.audio.play('gate'); this.game.shake(0.4); }
  update(dt) {
    const prev = this.h;
    this.h += Math.sign(this.target - this.h) * Math.min(Math.abs(this.target - this.h), dt * 2.2);
    this.group.position.y = this.h;
    if (Math.abs(prev - this.h) > 0.001 && Math.random() < 0.5) {
      const c = this.cells[Math.floor(Math.random() * this.cells.length)];
      this.game.particles.dust(c.x + 0.5, this.game.floorAt(c.x + 0.5, c.z + 0.5), c.z + 0.5, 2);
    }
  }
}

// ---------- portal de saida ----------
const portalVS = `varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }`;
const portalFS = `
uniform float t; uniform float hue; varying vec2 vUv;
void main(){
  vec2 p = vUv*2.0-1.0; float r = length(p); if (r>1.0) discard;
  float a = atan(p.y,p.x);
  float s = sin(a*5.0 + r*12.0 - t*3.0)*0.5+0.5;
  float s2 = sin(a*3.0 - r*20.0 + t*2.0)*0.5+0.5;
  vec3 c = mix(vec3(0.25,0.05,0.6), mix(vec3(0.3,0.9,1.0), vec3(1.0,0.45,0.9), hue), s*s2);
  c += vec3(1.0)*pow(1.0-r,4.0);
  float alpha = smoothstep(1.0,0.8,r);
  gl_FragColor = vec4(c*1.6, alpha);
}`;
export class Portal {
  constructor(game, x, z, kind = 'exit', label = 'Entrar no portal') {
    this.game = game; this.x = x; this.z = z; this.t = 0; this.kind = kind; this.label = label;
    const g = new THREE.Group();
    const y = game.floorAt(x, z);
    this.uni = { t: { value: 0 }, hue: { value: 0 } };
    const disc = new THREE.Mesh(new THREE.CircleGeometry(1.2, 48), new THREE.ShaderMaterial({ uniforms: this.uni, vertexShader: portalVS, fragmentShader: portalFS, transparent: true, side: THREE.DoubleSide, depthWrite: false }));
    disc.position.y = 1.5; g.add(disc); this.disc = disc;
    const M = propMats();
    const ring = new THREE.Mesh(new THREE.TorusGeometry(1.3, 0.16, 12, 40), M.stone);
    ring.position.y = 1.5; ring.castShadow = true; g.add(ring);
    for (let i = 0; i < 12; i++) { const a = (i / 12) * Math.PI * 2; const st = mesh(GEO.rbox(0.32, 0.26, 0.4, 0.06), M.rock); st.position.set(Math.cos(a) * 1.32, 1.5 + Math.sin(a) * 1.32, 0); st.rotation.z = a; g.add(st); }
    for (let i = 0; i < 8; i++) {
      const a = (i / 8) * Math.PI * 2;
      const gem = new THREE.Mesh(new THREE.OctahedronGeometry(0.1), makeMat('glow', { color: 0x70e0ff, intensity: 4 }));
      gem.position.set(Math.cos(a) * 1.3, 1.5 + Math.sin(a) * 1.3, 0.12); g.add(gem);
    }
    const base = box(2.8, 0.22, 0.9, M.stone); base.position.y = 0.11; g.add(base);
    g.position.set(x, y, z);
    g.rotation.y = Math.PI / 4;
    this.mesh = g; game.scene.add(g);
    this.light = game.addLight(x, y + 1.5, z, kind === 'dim' ? 0xb070ff : 0x70b0ff, 20, 12, 0.2, true);
    if (kind === 'dim') this.uni.hue.value = 1;
  }
  get prompt() { return this.label; }
  interact() { this.game.usePortal(this); }
  update(dt) {
    this.t += dt; this.uni.t.value = this.t;
    const s = Math.min(1, this.t * 1.5);
    this.mesh.scale.setScalar(s);
    if (Math.random() < dt * 25) {
      const a = Math.random() * Math.PI * 2;
      this.game.particles.add.emit(this.x + Math.cos(a) * 1.3 * 0.7, this.mesh.position.y + 1.5 + Math.sin(a) * 1.3, this.z - Math.cos(a) * 1.3 * 0.7, 0, 0.5, 0, 1, 0.2, 0.02, 0.4, 0.8, 1, 1, 0, 0);
    }
  }
}

// ---------- altar das oferendas ----------
export class Altar {
  constructor(game, x, z) {
    this.game = game; this.x = x; this.z = z; this.uses = 0;
    this.price = 50 + 25 * game.floorNum;
    const M = propMats();
    const g = new THREE.Group();
    g.add(mesh(lathe('altar', [[0, 0], [0.62, 0], [0.6, 0.12], [0.42, 0.25], [0.36, 0.8], [0.6, 0.92], [0.64, 1.0], [0, 1.0]], 20), M.stone));
    const bowl = mesh(lathe('altarbowl', [[0.05, 0], [0.2, 0.02], [0.32, 0.14], [0.34, 0.2], [0.28, 0.17], [0, 0.1]], 18), M.gold); bowl.position.y = 1.0; g.add(bowl);
    this.orb = new THREE.Mesh(new THREE.OctahedronGeometry(0.16), makeMat('glow', { color: 0xffc040, intensity: 5 }));
    this.orb.position.y = 1.55; g.add(this.orb);
    g.position.set(x, game.floorAt(x, z), z);
    g.rotation.y = Math.PI / 4;
    this.mesh = g; game.scene.add(g);
    game.addLight(x, g.position.y + 1.7, z, 0xffc060, 6, 6, 0.3);
  }
  get prompt() { return `Oferenda: ${this.price} de ouro por um item`; }
  interact() {
    const g = this.game, p = g.player;
    if (p.gold < this.price) { g.audio.play('deny'); g.ui.toast('Ouro insuficiente para a oferenda.'); return; }
    p.gold -= this.price; this.uses++;
    g.audio.play('chest');
    g.particles.burst(this.x, this.mesh.position.y + 1.5, this.z, 40, [1, 0.8, 0.3], 4, 0.8, 0.3);
    g.dropItem(this.x, this.z, { bonus: 0.6 });
    this.price = Math.round(this.price * 1.5);
  }
  update(dt, time) { this.orb.rotation.y += dt * 2; this.orb.position.y = 1.55 + Math.sin(time * 2) * 0.08; }
}

// ---------- saques ----------
const lootGeo = {
  coin: new THREE.CylinderGeometry(0.1, 0.1, 0.03, 16),
  heart: new THREE.SphereGeometry(0.15, 16, 12),
  frag: new THREE.OctahedronGeometry(0.2, 0),
  beam: new THREE.CylinderGeometry(0.1, 0.25, 5, 10, 1, true),
};
let _beamTex = null;
function beamTex() {
  if (_beamTex) return _beamTex;
  const c = document.createElement('canvas'); c.width = 4; c.height = 64;
  const g = c.getContext('2d'); const gr = g.createLinearGradient(0, 0, 0, 64);
  gr.addColorStop(0, 'rgba(255,255,255,0)'); gr.addColorStop(0.7, 'rgba(255,255,255,0.5)'); gr.addColorStop(1, 'rgba(255,255,255,1)');
  g.fillStyle = gr; g.fillRect(0, 0, 4, 64);
  _beamTex = new THREE.CanvasTexture(c); return _beamTex;
}

export function itemModel(item) {
  const g = new THREE.Group();
  const glow = item.affixes.includes('chamas') ? 0xff6a20 : item.affixes.includes('trovao') ? 0x80d0ff : null;
  if (item.cat === 'melee') { const w = makeWeapon(item.kind, item.rarity === 'unico' ? glow : null); w.rotation.z = 0.6; w.position.y = -0.3; g.add(w); g.scale.setScalar(0.9); }
  else if (item.cat === 'bow') { const b = makeBow(item.kind === 'besta'); b.rotation.z = 0.3; g.add(b); }
  else if (item.cat === 'armor') {
    const look = { couro: 'leather', malha: 'chain', placas: 'steel', andarilho: 'cloth_green', obsidiana: 'obsidian' }[item.kind];
    const m = makeMat(look);
    g.add(mesh(lathe('itemtorso', [[0, -0.28], [0.2, -0.28], [0.22, -0.05], [0.26, 0.15], [0.24, 0.26], [0.1, 0.3], [0, 0.3]], 16), m));
    for (const s of [-1, 1]) { const p = mesh(GEO.hemi(), m); p.scale.set(0.13, 0.1, 0.14); p.position.set(s * 0.26, 0.22, 0); p.rotation.z = s * 0.4; g.add(p); }
    g.children[0].scale.z = 0.6;
  } else {
    const col = { chamas: 0xff6a20, raio: 0x80d0ff, estandarte: 0xff3030, vendaval: 0xc0ffd0, laminas: 0x9a8cff, gelo: 0x8ff0ff }[item.kind];
    const glowM = makeMat('glow', { color: col, intensity: 4 });
    if (item.kind === 'raio') { g.add(mesh(lathe('bottle', [[0, 0], [0.14, 0], [0.18, 0.12], [0.16, 0.26], [0.06, 0.34], [0.05, 0.44], [0, 0.44]], 16), new THREE.MeshPhysicalMaterial({ color: 0xaad8ff, roughness: 0.05, transparent: true, opacity: 0.45, clearcoat: 1 }))); const core = mesh(new THREE.SphereGeometry(0.1, 12, 10), glowM); core.position.y = 0.14; g.add(core); g.position.y = -0.2; }
    else if (item.kind === 'vendaval') { g.add(mesh(taperTube('horn', [[0, -0.2, 0], [0.12, 0, 0], [0.1, 0.2, 0.05], [-0.05, 0.3, 0.1]], 0.12, 0.03, 16, 10), makeMat('bone'))); }
    else if (item.kind === 'gelo') { const c = mesh(new THREE.OctahedronGeometry(0.2, 0), makeMat('ice')); c.scale.set(0.7, 1.4, 0.7); g.add(c); }
    else {
      g.add(mesh(GEO.rbox(0.34, 0.44, 0.1, 0.03), makeMat('leather')));
      const pg = mesh(GEO.rbox(0.3, 0.4, 0.11, 0.02), makeMat('bone', { color: 0xf0e8d0 })); pg.position.x = 0.015; g.add(pg);
      const gem = mesh(new THREE.OctahedronGeometry(0.1), glowM); gem.position.z = 0.08; g.add(gem);
    }
  }
  return g;
}

export class Loot {
  constructor(game, kind, x, z, data) {
    this.game = game; this.kind = kind; this.x = x; this.z = z; this.data = data;
    this.y = game.floorAt(x, z) + 0.6; this.vy = 3 + Math.random() * 2;
    const a = Math.random() * Math.PI * 2, s = kind === 'item' ? 1.2 : 1 + Math.random() * 2.5;
    this.vx = Math.cos(a) * s; this.vz = Math.sin(a) * s;
    this.t = 0; this.dead = false; this.grounded = false;
    const M = propMats();
    if (kind === 'gold') { this.mesh = new THREE.Mesh(lootGeo.coin, M.gold); this.mesh.rotation.x = Math.PI / 2; }
    else if (kind === 'heart') { this.mesh = new THREE.Mesh(lootGeo.heart, makeMat('glow', { color: 0xff2a3a, intensity: 3 })); }
    else if (kind === 'fragment') { this.mesh = new THREE.Mesh(lootGeo.frag, M.crystalV); this.mesh.scale.set(0.8, 1.4, 0.8); this.light = game.addLight(x, this.y, z, 0xb070ff, 4, 4, 0.2); }
    else if (kind === 'arrows') {
      this.mesh = new THREE.Group();
      for (let i = 0; i < 5; i++) { const m = mesh(new THREE.CylinderGeometry(0.014, 0.014, 0.6, 6), M.wood); m.position.x = (i - 2) * 0.05; m.rotation.z = (i - 2) * 0.08; this.mesh.add(m); }
      const band = mesh(new THREE.TorusGeometry(0.1, 0.025, 6, 16), M.leather || M.iron); band.rotation.x = Math.PI / 2; band.scale.set(1.1, 0.5, 1); this.mesh.add(band);
      this.mesh.rotation.z = Math.PI / 2.3;
    } else if (kind === 'item') {
      this.mesh = new THREE.Group();
      this.model = itemModel(data); this.mesh.add(this.model);
      const R = RARITY[data.rarity];
      const bm = new THREE.MeshBasicMaterial({ color: R.hex, map: beamTex(), transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, side: THREE.DoubleSide, opacity: 0.8 });
      this.beam = new THREE.Mesh(lootGeo.beam, bm); this.beam.position.y = 2.0;
      this.beam.rotation.x = Math.PI; // gradiente forte embaixo
      this.mesh.add(this.beam);
      this.light = game.addLight(x, this.y, z, R.hex, data.rarity === 'comum' ? 0 : 4, 4, 0.1);
    }
    this.mesh.traverse(o => { if (o.isMesh && o !== this.beam) o.castShadow = true; });
    this.mesh.position.set(x, this.y, z);
    game.scene.add(this.mesh);
  }
  get prompt() { return this.kind === 'item' ? 'item' : null; }
  update(dt, time) {
    const g = this.game, p = g.player;
    this.t += dt;
    const fy = g.floorAt(this.x, this.z);
    if (!this.grounded) {
      this.vy -= 18 * dt;
      const nx = this.x + this.vx * dt, nz = this.z + this.vz * dt;
      if (g.walkable(nx, nz)) { this.x = nx; this.z = nz; } else { this.vx *= -0.4; this.vz *= -0.4; }
      this.y += this.vy * dt;
      const rest = fy + (this.kind === 'item' ? 0.55 : 0.12);
      if (this.y < rest) { this.y = rest; if (Math.abs(this.vy) < 2) { this.grounded = true; this.vy = 0; } else { this.vy *= -0.35; this.vx *= 0.6; this.vz *= 0.6; if (this.kind === 'gold') g.audio.play('coin', 0.25); } }
    }
    const d = Math.hypot(p.x - this.x, p.z - this.z);
    if (this.kind !== 'item' && this.t > 0.5 && !p.dead) {
      const mag = this.kind === 'gold' ? 3.5 : 2.2;
      if (d < mag) {
        const k = (1 - d / mag) * 14 + 4;
        this.x += (p.x - this.x) / d * k * dt; this.z += (p.z - this.z) / d * k * dt;
        this.y += ((p.y + 0.8) - this.y) * Math.min(1, dt * 6);
        this.grounded = true;
      }
      if (d < 0.5) { this.collect(); return; }
    }
    this.mesh.position.set(this.x, this.y + (this.grounded ? Math.sin(time * 3 + this.x) * 0.06 : 0), this.z);
    if (this.kind === 'gold') this.mesh.rotation.z += dt * 4;
    else if (this.kind === 'fragment') { this.mesh.rotation.y += dt * 2; if (this.light) { this.light.x = this.x; this.light.z = this.z; } }
    else if (this.kind === 'item') { this.model.rotation.y += dt * 1.5; this.beam.material.opacity = 0.55 + Math.sin(time * 3) * 0.2; if (this.light) { this.light.x = this.x; this.light.z = this.z; } }
    else this.mesh.rotation.y += dt * 2;
    if (this.kind === 'heart' && Math.random() < dt * 5) g.particles.add.emit(this.x, this.y, this.z, 0, 0.6, 0, 0.6, 0.12, 0.02, 1, 0.2, 0.3, 1, 0, 0);
  }
  collect() {
    const g = this.game, p = g.player;
    this.remove();
    if (this.kind === 'gold') { p.gold += this.data || 1; g.audio.play('coin', 0.6); }
    if (this.kind === 'arrows') { p.arrows = Math.min(p.maxArrows, p.arrows + 8); g.audio.play('pickup'); g.floatText(p.x, p.y + 2, p.z, '+8 flechas', '#d8d0b0'); }
    if (this.kind === 'heart') { p.heal(p.maxHp * 0.2); g.audio.play('potion', 0.6); }
    if (this.kind === 'fragment') { p.fragments += this.data || 1; g.audio.play('levelup', 0.6); g.floatText(p.x, p.y + 2, p.z, '+' + (this.data || 1) + ' fragmento', '#c9a0ff'); g.ui.toast('Fragmento dimensional obtido! Use-o no Portal das Dimensões do Refúgio.', '#c9a0ff'); }
  }
  remove() {
    this.dead = true; this.game.scene.remove(this.mesh);
    if (this.light) this.game.removeLight(this.light);
  }
}

// ---------- efeitos ----------
export function telegraph(game, x, z, radius, time, color = 0xff3020) {
  const m = new THREE.Mesh(new THREE.CircleGeometry(1, 40), new THREE.MeshBasicMaterial({ map: ringTex(), color, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, opacity: 0 }));
  m.rotation.x = -Math.PI / 2;
  m.position.set(x, game.floorAt(x, z) + 0.04, z);
  m.scale.setScalar(radius);
  m.renderOrder = 3;
  game.scene.add(m);
  const inner = new THREE.Mesh(new THREE.CircleGeometry(1, 40), new THREE.MeshBasicMaterial({ color, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, opacity: 0.25 }));
  inner.rotation.x = -Math.PI / 2; inner.position.copy(m.position); inner.position.y += 0.005; inner.scale.setScalar(0.01);
  game.scene.add(inner);
  let t = 0;
  game.effects.push({
    update(dt) {
      t += dt; const k = Math.min(1, t / time);
      m.material.opacity = Math.min(1, t * 5) * 0.9; inner.scale.setScalar(radius * k);
      if (t >= time) { game.scene.remove(m); game.scene.remove(inner); m.geometry.dispose(); m.material.dispose(); inner.geometry.dispose(); inner.material.dispose(); return false; }
      return true;
    },
  });
}
export function lineTelegraph(game, x, z, angle, len, width, time, color = 0xff3020) {
  const m = new THREE.Mesh(new THREE.PlaneGeometry(width, len), new THREE.MeshBasicMaterial({ color, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, opacity: 0.35 }));
  m.rotation.x = -Math.PI / 2; m.rotation.z = -angle;
  const cx = x + Math.sin(angle) * len / 2, cz = z + Math.cos(angle) * len / 2;
  m.rotation.order = 'YXZ'; m.rotation.set(-Math.PI / 2, 0, 0); m.rotateOnWorldAxis(new THREE.Vector3(0, 1, 0), angle);
  m.position.set(cx, game.floorAt(x, z) + 0.05, cz);
  game.scene.add(m);
  let t = 0;
  game.effects.push({ update(dt) { t += dt; m.material.opacity = 0.2 + 0.3 * Math.abs(Math.sin(t * 12)); if (t >= time) { game.scene.remove(m); m.geometry.dispose(); m.material.dispose(); return false; } return true; } });
}

export function lightning(game, pts, color = 0x9fdcff) {
  const verts = [];
  for (let i = 0; i < pts.length - 1; i++) {
    const a = pts[i], b = pts[i + 1];
    let prev = a;
    const n = 6;
    for (let k = 1; k <= n; k++) {
      const t = k / n;
      const p = k === n ? b : new THREE.Vector3(a.x + (b.x - a.x) * t + (Math.random() - 0.5) * 0.5, a.y + (b.y - a.y) * t + (Math.random() - 0.5) * 0.5, a.z + (b.z - a.z) * t + (Math.random() - 0.5) * 0.5);
      verts.push(prev.x, prev.y, prev.z, p.x, p.y, p.z); prev = p;
    }
  }
  const g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.Float32BufferAttribute(verts, 3));
  const mat = new THREE.LineBasicMaterial({ color, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false });
  const line = new THREE.LineSegments(g, mat);
  game.scene.add(line);
  const L = game.addLight(pts[0].x, pts[0].y, pts[0].z, color, 25, 10, 0, true);
  let t = 0;
  game.effects.push({ update(dt) { t += dt; mat.opacity = 1 - t / 0.3; L.intensity = 25 * (1 - t / 0.3); if (t > 0.3) { game.scene.remove(line); g.dispose(); mat.dispose(); game.removeLight(L); return false; } return true; } });
}

export function makeBannerMesh() {
  const M = propMats();
  const g = new THREE.Group();
  const pole = new THREE.Mesh(new THREE.CylinderGeometry(0.04, 0.04, 2.6, 6), M.darkwood); pole.position.y = 1.3; pole.castShadow = true; g.add(pole);
  const flag = new THREE.Mesh(new THREE.PlaneGeometry(0.7, 1.2), M.banners[0]); flag.position.set(0.37, 1.9, 0); flag.castShadow = true; g.add(flag);
  const top = new THREE.Mesh(new THREE.OctahedronGeometry(0.1), M.gold); top.position.y = 2.65; g.add(top);
  return g;
}
export { ringTex };

// ---------- NPCs do Refugio ----------
export class Npc {
  constructor(game, n) {
    this.game = game; this.x = n.x; this.z = n.z; this.role = n.role; this.name = n.name; this.baseRot = n.rot || 0;
    this.rig = makeNpc(n.kind);
    this.rig.root.position.set(n.x, game.floorAt(n.x, n.z), n.z);
    this.rig.root.rotation.y = this.baseRot;
    game.scene.add(this.rig.root);
    this.t = Math.random() * 10;
  }
  get prompt() { return { shop: `Falar com ${this.name} (loja)`, smith: `Falar com ${this.name} (aprimorar)`, quests: `Falar com ${this.name} (missões)` }[this.role]; }
  interact() { this.game.openStation(this.role); }
  update(dt) {
    this.t += dt;
    const p = this.game.player, d = Math.hypot(p.x - this.x, p.z - this.z);
    const want = d < 5 ? Math.atan2(p.x - this.x, p.z - this.z) : this.baseRot;
    let r = this.rig.root.rotation.y; const diff = Math.atan2(Math.sin(want - r), Math.cos(want - r));
    this.rig.root.rotation.y = r + diff * Math.min(1, dt * 3);
    animateWalk(this.rig, 0, 0, this.t);
    if (this.role === 'smith') { const k = Math.max(0, Math.sin(this.t * 2.2)); this.rig.armR.rotation.x = -0.4 - k * 1.6; this.rig.elbowR.rotation.x = -0.6; if (k > 0.98 && !this.hit) { this.hit = true; this.game.particles.sparks(this.x - 1.9, this.game.floorAt(this.x, this.z) + 1.05, this.z + 1.3, 5, [1, 0.7, 0.3], 2); } if (k < 0.5) this.hit = false; }
  }
}

// ---------- estacao interativa (quadro de missoes, fogueira) ----------
export class Station {
  constructor(game, x, z, role, label, r = 2.2) { this.game = game; this.x = x; this.z = z; this.role = role; this.label = label; this.range = r; }
  get prompt() { return this.label; }
  interact() { this.game.openStation(this.role); }
}

// ---------- prisioneiro (missao de resgate) ----------
export class Prisoner {
  constructor(game, x, z, quest) {
    this.game = game; this.x = x; this.z = z; this.quest = quest; this.freed = false; this.t = 0;
    this.rig = makeNpc('prisioneiro');
    const y = game.floorAt(x, z);
    this.rig.root.position.set(x, y, z);
    game.scene.add(this.rig.root);
    const M = propMats();
    const cage = new THREE.Group();
    for (let i = 0; i < 12; i++) { const a = i / 12 * Math.PI * 2; const b = mesh(new THREE.CylinderGeometry(0.025, 0.025, 2.2, 6), M.iron); b.position.set(Math.cos(a) * 0.62, 1.1, Math.sin(a) * 0.62); cage.add(b); }
    for (const yy of [0.05, 2.2]) { const r = mesh(new THREE.TorusGeometry(0.62, 0.04, 6, 24), M.iron); r.rotation.x = Math.PI / 2; r.position.y = yy; cage.add(r); }
    const top = mesh(new THREE.ConeGeometry(0.66, 0.4, 16), M.iron); top.position.y = 2.4; cage.add(top);
    cage.position.set(x, y, z); game.scene.add(cage); this.cage = cage;
    this.light = game.addLight(x, y + 2.5, z, 0xffe0a0, 5, 5, 0.3);
    game.dg.solid[game.dg.idx(Math.floor(x), Math.floor(z))] = 1;
  }
  get prompt() { return this.freed ? null : 'Libertar o prisioneiro'; }
  interact() {
    if (this.freed) return;
    this.freed = true;
    const g = this.game;
    g.audio.play('gate'); g.particles.dust(this.x, this.cage.position.y + 1, this.z, 20, [0.5, 0.45, 0.4], 2, 1);
    g.ui.toast('"Obrigado, aventureiro! Que a última chama te guie."', '#e8dcc0');
    g.onQuestEvent('rescue', this.quest);
  }
  update(dt) {
    this.t += dt;
    animateWalk(this.rig, 0, 0, this.t);
    if (!this.freed) { this.rig.armL.rotation.x = this.rig.armR.rotation.x = -0.6; this.rig.elbowL.rotation.x = this.rig.elbowR.rotation.x = -1.4; }
    else if (this.cage.position.y > -3) { this.cage.position.y -= dt * 1.5; this.rig.armR.rotation.x = -2.6 + Math.sin(this.t * 8) * 0.3; }
  }
}

// ---------- reliquia (missao de busca) ----------
export class Relic {
  constructor(game, x, z, quest) {
    this.game = game; this.x = x; this.z = z; this.quest = quest; this.taken = false;
    const M = propMats();
    const g = new THREE.Group();
    g.add(mesh(lathe('relped', [[0, 0], [0.4, 0], [0.36, 0.1], [0.2, 0.2], [0.18, 0.8], [0.34, 0.9], [0, 0.92]], 16), M.stone));
    const box2 = mesh(GEO.rbox(0.36, 0.28, 0.26, 0.05), M.gold); box2.position.y = 1.08; g.add(box2);
    const lid = mesh(new THREE.CylinderGeometry(0.13, 0.13, 0.36, 12, 1, false, 0, Math.PI), M.gold); lid.rotation.z = Math.PI / 2; lid.rotation.y = Math.PI / 2; lid.position.y = 1.22; g.add(lid);
    const gem = mesh(new THREE.OctahedronGeometry(0.07), makeMat('glow', { color: 0xff4060, intensity: 5 })); gem.position.set(0, 1.1, 0.14); g.add(gem);
    const y = game.floorAt(x, z);
    g.position.set(x, y, z); game.scene.add(g); this.mesh = g;
    this.light = game.addLight(x, y + 1.6, z, 0xffd070, 7, 6, 0.2, true);
    game.dg.solid[game.dg.idx(Math.floor(x), Math.floor(z))] = 1;
  }
  get prompt() { return this.taken ? null : `Pegar: ${this.quest.relicName}`; }
  interact() {
    if (this.taken) return;
    this.taken = true;
    const g = this.game;
    this.mesh.children.slice(1).forEach(c => c.visible = false);
    g.removeLight(this.light);
    g.audio.play('levelup', 0.7);
    g.particles.burst(this.x, this.mesh.position.y + 1.2, this.z, 40, [1, 0.85, 0.4], 3, 0.8, 0.3);
    g.onQuestEvent('relic', this.quest);
  }
  update(dt, time) { if (!this.taken) { this.mesh.children[1].position.y = 1.08 + Math.sin(time * 2) * 0.03; if (Math.random() < dt * 6) this.game.particles.add.emit(this.x, this.mesh.position.y + 1.3, this.z, (Math.random() - 0.5) * 0.4, 0.8, (Math.random() - 0.5) * 0.4, 1, 0.1, 0.02, 1, 0.85, 0.4, 1, 0, 0); } }
}
