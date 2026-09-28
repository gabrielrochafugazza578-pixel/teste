// Objetos interativos (baus, vasos, braseiros, portoes, portal, altar), saques e efeitos visuais.
import * as THREE from 'three';
import { propMats, makeFlame } from './props.js';
import { ringTexture, charTex } from './textures.js';
import { Rig, makeWeapon, makeBow, makeMat } from './models.js';
import { RARITY } from './items.js';

let _ring = null;
const ringTex = () => (_ring || (_ring = ringTexture()));
const box = (w, h, d, m) => { const me = new THREE.Mesh(new THREE.BoxGeometry(w, h, d), m); me.castShadow = true; me.receiveShadow = true; return me; };

// ---------- bau ----------
export class Chest {
  constructor(game, x, z, big) {
    this.game = game; this.x = x; this.z = z; this.big = big; this.opened = false; this.t = 0;
    const M = propMats();
    const g = new THREE.Group();
    const s = big ? 1.15 : 0.9;
    const base = box(0.9, 0.48, 0.6, M.wood); base.position.y = 0.24; g.add(base);
    for (const x2 of [-0.44, 0.44]) { const b = box(0.06, 0.5, 0.62, big ? M.gold : M.iron); b.position.set(x2, 0.25, 0); g.add(b); }
    this.lid = new THREE.Group(); this.lid.position.set(0, 0.48, -0.3); g.add(this.lid);
    const lid = box(0.92, 0.22, 0.62, M.wood); lid.position.set(0, 0.11, 0.3); this.lid.add(lid);
    const band = box(0.94, 0.06, 0.64, big ? M.gold : M.iron); band.position.set(0, 0.2, 0.3); this.lid.add(band);
    const lock = box(0.12, 0.14, 0.04, M.gold); lock.position.set(0, 0.46, 0.31); g.add(lock);
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
].map(p => new THREE.Vector2(p[0], p[1])), 12);
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

// ---------- braseiro ancestral ----------
export class Brazier {
  constructor(game, x, z) {
    this.game = game; this.x = x; this.z = z; this.lit = false; this.t = 0;
    const M = propMats();
    const g = new THREE.Group();
    const ped = box(0.8, 0.7, 0.8, M.stone); ped.position.y = 0.35; g.add(ped);
    const ped2 = box(0.6, 0.2, 0.6, M.stone); ped2.position.y = 0.8; g.add(ped2);
    const bowl = new THREE.Mesh(new THREE.CylinderGeometry(0.55, 0.32, 0.32, 10, 1, true), M.iron);
    bowl.material = M.iron; bowl.position.y = 1.06; bowl.castShadow = true; g.add(bowl);
    const coal = new THREE.Mesh(new THREE.CylinderGeometry(0.5, 0.5, 0.05, 10), makeMat('glow', { color: 0x401005, intensity: 0.4 }));
    coal.position.y = 1.12; g.add(coal); this.coal = coal;
    const rune = new THREE.Mesh(new THREE.RingGeometry(0.9, 1.1, 32), new THREE.MeshBasicMaterial({ color: 0xff9a40, transparent: true, opacity: 0.35, blending: THREE.AdditiveBlending, depthWrite: false }));
    rune.rotation.x = -Math.PI / 2; rune.position.y = 0.03; g.add(rune); this.rune = rune;
    g.position.set(x, game.floorAt(x, z), z);
    this.mesh = g; game.scene.add(g);
    this.flame = makeFlame(3.2, 0xffd0a0); this.flame.position.set(x, g.position.y + 1.8, z); this.flame.visible = false; game.scene.add(this.flame);
    this.light = game.addLight(x, g.position.y + 2, z, 0xff8a3a, 0, 14, 1, true);
  }
  get prompt() { return this.lit ? null : 'Acender o braseiro'; }
  interact() {
    if (this.lit) return;
    this.lit = true; this.t = 0;
    this.flame.visible = true;
    this.coal.material.emissiveIntensity = 5;
    this.game.audio.play('brazier');
    this.game.particles.burst(this.x, this.mesh.position.y + 1.3, this.z, 60, [1, 0.6, 0.2], 6, 0.9, 0.4);
    this.game.onBrazierLit(this);
  }
  update(dt, time) {
    this.rune.material.opacity = this.lit ? 0.7 : 0.25 + Math.sin(time * 2) * 0.1;
    if (!this.lit) { if (Math.random() < dt * 4) this.game.particles.ember(this.x + (Math.random() - 0.5) * 0.6, this.mesh.position.y + 1.15, this.z + (Math.random() - 0.5) * 0.6); return; }
    this.t += dt;
    this.light.intensity = Math.min(30, this.t * 40) * (0.9 + Math.sin(time * 13) * 0.05 + Math.sin(time * 7.3) * 0.05);
    const f = 1 + Math.sin(time * 17) * 0.06;
    this.flame.scale.set(1.1 * f, 1.9 / f, 1);
    if (Math.random() < dt * 30) this.game.particles.fire(this.x, this.mesh.position.y + 1.2, this.z, 1, 0.7, [1, 0.45, 0.12], 0.8);
    if (Math.random() < dt * 8) this.game.particles.ember(this.x, this.mesh.position.y + 1.6, this.z);
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
uniform float t; varying vec2 vUv;
void main(){
  vec2 p = vUv*2.0-1.0; float r = length(p); if (r>1.0) discard;
  float a = atan(p.y,p.x);
  float s = sin(a*5.0 + r*12.0 - t*3.0)*0.5+0.5;
  float s2 = sin(a*3.0 - r*20.0 + t*2.0)*0.5+0.5;
  vec3 c = mix(vec3(0.25,0.05,0.6), vec3(0.3,0.9,1.0), s*s2);
  c += vec3(1.0)*pow(1.0-r,4.0);
  float alpha = smoothstep(1.0,0.8,r);
  gl_FragColor = vec4(c*1.6, alpha);
}`;
export class Portal {
  constructor(game, x, z) {
    this.game = game; this.x = x; this.z = z; this.t = 0;
    const g = new THREE.Group();
    const y = game.floorAt(x, z);
    this.uni = { t: { value: 0 } };
    const disc = new THREE.Mesh(new THREE.CircleGeometry(1.2, 48), new THREE.ShaderMaterial({ uniforms: this.uni, vertexShader: portalVS, fragmentShader: portalFS, transparent: true, side: THREE.DoubleSide, depthWrite: false }));
    disc.position.y = 1.5; g.add(disc); this.disc = disc;
    const M = propMats();
    const ring = new THREE.Mesh(new THREE.TorusGeometry(1.3, 0.14, 8, 32), M.stone);
    ring.position.y = 1.5; ring.castShadow = true; g.add(ring);
    for (let i = 0; i < 8; i++) {
      const a = (i / 8) * Math.PI * 2;
      const gem = new THREE.Mesh(new THREE.OctahedronGeometry(0.1), makeMat('glow', { color: 0x70e0ff, intensity: 4 }));
      gem.position.set(Math.cos(a) * 1.3, 1.5 + Math.sin(a) * 1.3, 0.12); g.add(gem);
    }
    const base = box(2.6, 0.2, 0.8, M.stone); base.position.y = 0.1; g.add(base);
    g.position.set(x, y, z);
    g.rotation.y = Math.PI / 4;
    this.mesh = g; game.scene.add(g);
    this.light = game.addLight(x, y + 1.5, z, 0x70b0ff, 20, 12, 0.2, true);
  }
  get prompt() { return 'Entrar no portal'; }
  interact() { this.game.enterPortal(); }
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
    const b = box(1.1, 0.9, 0.8, M.stone); b.position.y = 0.45; g.add(b);
    const t = box(1.3, 0.12, 1.0, M.stone); t.position.y = 0.96; g.add(t);
    const bowl = new THREE.Mesh(new THREE.CylinderGeometry(0.3, 0.2, 0.18, 12), M.gold); bowl.position.y = 1.1; bowl.castShadow = true; g.add(bowl);
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
  coin: new THREE.CylinderGeometry(0.1, 0.1, 0.03, 10),
  heart: new THREE.OctahedronGeometry(0.16),
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
  const r = new Rig('item');
  const g = new THREE.Group();
  const glow = item.affixes.includes('chamas') ? 0xff6a20 : item.affixes.includes('trovao') ? 0x80d0ff : null;
  if (item.cat === 'melee') { const w = makeWeapon(item.kind, r, item.rarity === 'unico' ? (glow || null) : null); w.rotation.z = 0.6; w.position.y = -0.3; g.add(w); g.scale.setScalar(0.9); }
  else if (item.cat === 'bow') { const b = makeBow(r, item.kind === 'besta'); b.rotation.z = 0.3; g.add(b); }
  else if (item.cat === 'armor') {
    const look = { couro: 'leather', malha: 'steel', placas: 'steel', andarilho: 'cloth_green', obsidiana: 'obsidian' }[item.kind];
    const m = r.mat(look);
    r.part(g, 0.5, 0.55, 0.28, m, 0, 0, 0);
    r.part(g, 0.24, 0.16, 0.3, m, -0.34, 0.2, 0); r.part(g, 0.24, 0.16, 0.3, m, 0.34, 0.2, 0);
  } else {
    const col = { chamas: 0xff6a20, raio: 0x80d0ff, estandarte: 0xff3030, vendaval: 0xc0ffd0, laminas: 0x9a8cff, gelo: 0x8ff0ff }[item.kind];
    r.part(g, 0.34, 0.44, 0.1, r.mat('leather'), 0, 0, 0);
    r.part(g, 0.3, 0.4, 0.11, r.mat('bone', { color: 0xf0e8d0 }), 0.01, 0, 0);
    const gem = new THREE.Mesh(new THREE.OctahedronGeometry(0.1), makeMat('glow', { color: col, intensity: 4 }));
    gem.position.z = 0.08; g.add(gem);
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
    else if (kind === 'arrows') {
      this.mesh = new THREE.Group();
      const r = new Rig('a');
      for (let i = 0; i < 5; i++) { const m = r.part(this.mesh, 0.025, 0.6, 0.025, M.wood, (i - 2) * 0.05, 0, 0); m.rotation.z = (i - 2) * 0.08; }
      r.part(this.mesh, 0.18, 0.06, 0.05, M.iron, 0, 0, 0);
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
