// Estado do jogo: andares, camera, luzes dinamicas, campo de fluxo para a IA, efeitos e eventos.
import * as THREE from 'three';
import { generateDungeon, C } from './dungeon.js';
import { buildWorld } from './voxmesh.js';
import { buildStaticProps } from './props.js';
import { THEMES, themeFor } from './themes.js';
import { Particles } from './particles.js';
import { Player, Enemy, Boss, Projectile, makeBannerMesh } from './entities.js';
import { Chest, Pot, Brazier, Gates, Portal, Altar, Loot, telegraph, lightning } from './objects.js';
import { makeItem, scoreOf, ARTIFACTS, cdOf } from './items.js';
import { RNG, clamp, damp } from './util.js';

const POOL = 12;
const CAM_OFF = new THREE.Vector3(11, 19.5, 11);

export class Game {
  constructor(renderer, ui, input, audio) {
    this.renderer = renderer; this.ui = ui; this.input = input; this.audio = audio;
    this.camera = new THREE.PerspectiveCamera(32, innerWidth / innerHeight, 0.5, 140);
    this.hemi = new THREE.HemisphereLight(0x5f6f94, 0x1b1612, 0.55);
    this.moon = new THREE.DirectionalLight(0x8fa3d6, 0.9);
    this.moon.castShadow = true;
    this.moon.shadow.mapSize.set(2048, 2048);
    const sc = this.moon.shadow.camera; sc.left = -22; sc.right = 22; sc.top = 22; sc.bottom = -22; sc.near = 1; sc.far = 70;
    this.moon.shadow.bias = -0.0006; this.moon.shadow.normalBias = 0.03;
    this.pool = [];
    for (let i = 0; i < POOL; i++) { const l = new THREE.PointLight(0xffffff, 0, 10, 2); this.pool.push(l); }
    this.playerLight = new THREE.PointLight(0xffd0a0, 6, 9, 2);
    this.scene = new THREE.Scene();
    this.particles = new Particles(this.scene);
    this.player = new Player(this);
    this.state = 'title';
    this.time = 0; this.hitstopT = 0; this.shakeAmt = 0; this.zoom = 1;
    this.camTarget = new THREE.Vector3();
    this.lights = []; this.effects = []; this.enemies = []; this.projectiles = []; this.loot = []; this.pots = []; this.chests = []; this.braziers = []; this.floatTexts = [];
    this.floorNum = 1;
    this.stats = { kills: 0, gold: 0, time: 0 };
    this.raycaster = new THREE.Raycaster();
    this.aimPlane = new THREE.Plane(new THREE.Vector3(0, 1, 0), 0);
    this.rng = new RNG(Date.now() & 0xffffff);
  }

  // ------------------------------------------------------------ andares
  newGame() {
    const p = this.player = new Player(this);
    const rng = this.rng;
    this.floorNum = 1;
    this.loadFloor(1, true);
    p.setEquip('melee', makeItem(rng, 1, { cat: 'melee', kind: 'espada', rarity: 'comum' }));
    p.setEquip('bow', makeItem(rng, 1, { cat: 'bow', kind: 'arco', rarity: 'comum' }));
    p.setEquip('armor', makeItem(rng, 1, { cat: 'armor', kind: 'couro', rarity: 'comum' }));
    p.equip.arts[0] = makeItem(rng, 1, { cat: 'artifact', kind: 'chamas', rarity: 'comum' });
    p.hp = p.maxHp;
    this.snapshot = this.snap();
    this.stats = { kills: 0, gold: 0, time: 0 };
  }
  snap() {
    const p = this.player;
    return JSON.stringify({ level: p.level, xp: p.xp, xpNext: p.xpNext, gold: p.gold, arrows: p.arrows, equip: p.equip });
  }
  restore(s) {
    const d = JSON.parse(s);
    const p = this.player = new Player(this);
    Object.assign(p, { level: d.level, xp: d.xp, xpNext: d.xpNext, gold: d.gold, arrows: d.arrows });
    p.setEquip('melee', d.equip.melee); p.setEquip('bow', d.equip.bow); p.setEquip('armor', d.equip.armor);
    p.equip.arts = d.equip.arts;
    p.hp = p.maxHp;
  }
  retryFloor() { this.restore(this.snapshot); this.loadFloor(this.floorNum, true); }
  nextFloor() { this.floorNum++; this.player.hp = this.player.maxHp; this.loadFloor(this.floorNum, false); this.snapshot = this.snap(); }

  loadFloor(n, keepPlayer, silent = false) {
    this.disposeFloor();
    this.floorNum = n;
    const themeKey = themeFor(n);
    const theme = this.theme = THEMES[themeKey];
    const seed = (this.rng.next() * 1e9) | 0;
    const dg = this.dg = generateDungeon(seed, n, themeKey);
    const scene = this.scene = new THREE.Scene();
    scene.background = new THREE.Color(theme.fog);
    scene.fog = new THREE.FogExp2(theme.fog, 0.028);
    if (this.envMap) { scene.environment = this.envMap; scene.environmentIntensity = 0.35; }
    scene.add(this.hemi, this.moon, this.moon.target, this.playerLight);
    this.hemi.color.set(theme.hemiSky); this.hemi.groundColor.set(theme.hemiGround); this.hemi.intensity = theme.hemi;
    this.moon.color.set(theme.moon); this.moon.intensity = theme.moonI;
    for (const l of this.pool) scene.add(l);
    this.particles.clear(); this.particles.attach(scene);
    this.world = buildWorld(dg); scene.add(this.world.group);
    const sp = buildStaticProps(dg);
    this.staticProps = sp; scene.add(sp.group);
    for (const f of sp.flames) scene.add(f);
    this.flames = sp.flames;
    this.lights = [];
    for (const l of sp.lights) this.addLight(l.x, l.y, l.z, l.color, l.intensity, l.dist, l.flicker);
    for (const l of dg.lightsExtra) this.addLight(l.x, l.y, l.z, l.color, l.intensity, l.dist, 0.2);
    if (dg.themeKey === 'forja' || dg.cell.some(c => c === C.LAVA)) this.addLavaLights();

    this.enemies = []; this.projectiles = []; this.loot = []; this.effects = []; this.floatTexts.forEach(f => f.el.remove()); this.floatTexts = [];
    this.pots = dg.pots.map(p => new Pot(this, p.x, p.z));
    this.chests = dg.chests.map(c => new Chest(this, c.x, c.z, c.big));
    this.braziers = dg.braziers.map(b => new Brazier(this, b.x, b.z));
    this.altar = dg.altar ? new Altar(this, dg.altar.x, dg.altar.z) : null;
    this.gates = new Gates(this, dg.gates);
    this.portal = null;
    for (const s of dg.spawns) this.enemies.push(new Enemy(this, s.type, s.x, s.z));
    const b = dg.boss;
    this.boss = new Boss(this, theme.boss, b.x + b.w / 2, b.z + b.d / 2);
    this.enemies.push(this.boss);
    this.bossActive = false; this.bossDead = false; this.litCount = 0;

    const p = this.player;
    p.x = Math.floor(dg.start.cx) + 0.5; p.z = Math.floor(dg.start.cz) + 0.5; p.y = this.floorAt(p.x, p.z); p.fh = this.cellH(p.x, p.z);
    p.dead = false; p.rollT = 0; p.swingT = -1; p.bladesT = 0; p.blades = null; p.rot = Math.PI / 4;
    p.rig.hips.rotation.set(0, 0, 0);
    p.attach();
    this.explored = new Uint8Array(dg.W * dg.D);
    this.flow = new Int16Array(dg.W * dg.D).fill(-1); this.flowT = 0; this.flowCell = -1;
    this.camTarget.set(p.x, p.y, p.z);
    this.stats.floorStart = this.stats.time;
    this.state = 'play';
    if (silent) return;
    this.ui.floorTitle(n, theme.name);
    if (n === 1) this.after(4.5, () => this.ui.toast(this.input.isTouch ? 'Arraste à esquerda para andar. Acenda os 3 braseiros (marcados no mapa).' : 'WASD move · clique ataca · botão direito atira · Espaço rola · E interage', '#d8ccb0'));
    if (n === 1) this.after(8, () => this.ui.toast('Acenda os 3 braseiros ancestrais — eles aparecem em laranja no minimapa.', '#ffb45a'));
    this.ui.setBoss(null);
    this.audio.setBoss(false);
    this.ui.buildMinimap(this);
    try { const best = +localStorage.getItem('criptas-best') || 0; if (n > best) localStorage.setItem('criptas-best', n); } catch (e) { /* sem armazenamento */ }
  }
  addLavaLights() {
    const dg = this.dg, seen = new Set();
    for (let z = 0; z < dg.D; z += 4) for (let x = 0; x < dg.W; x += 4) {
      let found = null;
      for (let dz = 0; dz < 4 && !found; dz++) for (let dx = 0; dx < 4; dx++) if (dg.cell[dg.idx(x + dx, z + dz)] === C.LAVA) { found = [x + dx, z + dz]; break; }
      if (found && !seen.has(found.join())) { seen.add(found.join()); this.addLight(found[0] + 0.5, 0.6, found[1] + 0.5, 0xff5a10, 12, 9, 0.5); }
    }
  }
  disposeFloor() {
    if (this.world) { this.world.dispose(); this.world = null; }
    if (this.staticProps) { this.staticProps.group.traverse(o => o.geometry && o.geometry.dispose()); this.staticProps = null; }
    for (const e of this.enemies) if (!e.removed) e.rig.dispose();
  }

  // ------------------------------------------------------------ luzes
  addLight(x, y, z, color, intensity, dist, flicker = 1, priority = false) {
    const l = { x, y, z, color: new THREE.Color(color), intensity, dist, flicker, phase: Math.random() * 100, priority };
    this.lights.push(l);
    return l;
  }
  removeLight(l) { const i = this.lights.indexOf(l); if (i >= 0) this.lights.splice(i, 1); }
  updateLights() {
    const t = this.time, cx = this.camTarget.x, cz = this.camTarget.z;
    const list = [];
    for (const l of this.lights) {
      if (l.intensity <= 0.01) continue;
      const d = Math.hypot(l.x - cx, l.z - cz);
      if (d > 30) continue;
      list.push([d - (l.priority ? 8 : 0), l]);
    }
    list.sort((a, b) => a[0] - b[0]);
    for (let i = 0; i < POOL; i++) {
      const pl = this.pool[i];
      if (i < list.length) {
        const l = list[i][1];
        const f = 1 + l.flicker * (Math.sin(t * 9 + l.phase) * 0.07 + Math.sin(t * 23 + l.phase * 3) * 0.05 + Math.sin(t * 3.1 + l.phase) * 0.04);
        pl.position.set(l.x, l.y, l.z);
        pl.color.copy(l.color);
        const fade = clamp((30 - list[i][0]) / 6, 0, 1);
        pl.intensity = l.intensity * f * fade;
        pl.distance = l.dist;
      } else pl.intensity = 0;
    }
    const p = this.player;
    this.playerLight.position.set(p.x, p.y + 2.2, p.z);
  }

  // ------------------------------------------------------------ mundo
  ci(x, z) { const ix = Math.floor(x), iz = Math.floor(z); if (ix < 0 || iz < 0 || ix >= this.dg.W || iz >= this.dg.D) return -1; return ix + iz * this.dg.W; }
  cellType(x, z) { const i = this.ci(x, z); return i < 0 ? 0 : this.dg.cell[i]; }
  cellH(x, z) { const i = this.ci(x, z); return i < 0 ? 0 : this.dg.h[i]; }
  floorAt(x, z) {
    const i = this.ci(x, z); if (i < 0) return 0;
    const c = this.dg.cell[i];
    if (c === C.WATER) return -0.55;
    if (c === C.PIT) return -4;
    if (c === C.LAVA) return -0.85;
    return this.dg.h[i];
  }
  walkIdx(i) {
    if (i < 0) return false;
    const c = this.dg.cell[i];
    return (c === C.FLOOR || c === C.WATER) && this.dg.solid[i] !== 1 && !(this.gates && this.gates.blocks(i));
  }
  walkable(x, z) { return this.walkIdx(this.ci(x, z)); }
  canStand(x, z, r, fh) {
    const dg = this.dg;
    for (const [ox, oz] of [[-r, -r], [r, -r], [-r, r], [r, r]]) {
      const i = this.ci(x + ox, z + oz);
      if (!this.walkIdx(i)) return false;
      if (Math.abs(dg.h[i] - fh) > 1) return false;
    }
    return true;
  }
  moveEntity(e, dx, dz) {
    const r = Math.min(e.r, 0.55) * 0.9;
    let moved = false;
    if (dx && this.canStand(e.x + dx, e.z, r, e.fh)) { e.x += dx; moved = true; }
    if (dz && this.canStand(e.x, e.z + dz, r, e.fh)) { e.z += dz; moved = true; }
    if (moved) e.fh = this.cellH(e.x, e.z);
    return moved;
  }
  los(ax, az, bx, bz) {
    const d = Math.hypot(bx - ax, bz - az), n = Math.ceil(d / 0.35);
    for (let i = 1; i < n; i++) {
      const t = i / n, c = this.cellType(ax + (bx - ax) * t, az + (bz - az) * t);
      if (c === C.WALL || c === C.PILLAR || c === C.VOID) return false;
    }
    return true;
  }
  blocksProjectile(x, z, y) {
    const i = this.ci(x, z); if (i < 0) return true;
    const c = this.dg.cell[i];
    if (c === C.WALL || c === C.PILLAR || c === C.VOID) return true;
    if (this.dg.solid[i] === 1 && y < this.dg.h[i] + 1.1) return true;
    if (this.gates && this.gates.blocks(i)) return true;
    return false;
  }
  computeFlow() {
    const dg = this.dg, p = this.player;
    const pc = this.ci(p.x, p.z);
    if (pc < 0) return;
    this.flowT -= this.dtLogic;
    if (this.flowT > 0 && pc === this.flowCell) return;
    this.flowT = 0.25; this.flowCell = pc;
    const W = dg.W, flow = this.flow; flow.fill(-1);
    const q = this.flowQ || (this.flowQ = new Int32Array(W * dg.D));
    let head = 0, tail = 0;
    q[tail++] = pc; flow[pc] = 0;
    while (head < tail) {
      const c = q[head++]; const d = flow[c];
      if (d > 55) continue;
      const cx = c % W, cz = (c / W) | 0;
      for (let dz = -1; dz <= 1; dz++) for (let dx = -1; dx <= 1; dx++) {
        if (!dx && !dz) continue;
        const n = (cx + dx) + (cz + dz) * W;
        if (flow[n] !== -1 || !this.walkIdx(n) || Math.abs(dg.h[n] - dg.h[c]) > 1) continue;
        if (dx && dz && (!this.walkIdx(cx + dx + cz * W) || !this.walkIdx(cx + (cz + dz) * W))) continue;
        flow[n] = d + 1; q[tail++] = n;
      }
    }
  }
  flowDir(e) {
    const dg = this.dg, W = dg.W, p = this.player;
    const c = this.ci(e.x, e.z);
    if (c < 0) return [0, 0];
    const fc = this.flow[c];
    if (fc <= 0) { if (fc === 0 || this.los(e.x, e.z, p.x, p.z)) { const dx = p.x - e.x, dz = p.z - e.z, d = Math.hypot(dx, dz) || 1; return [dx / d, dz / d]; } return [0, 0]; }
    let best = -1, bv = fc;
    const cx = c % W, cz = (c / W) | 0;
    for (let dz = -1; dz <= 1; dz++) for (let dx = -1; dx <= 1; dx++) {
      if (!dx && !dz) continue;
      const n = (cx + dx) + (cz + dz) * W;
      const v = this.flow[n];
      if (v >= 0 && v < bv) { bv = v; best = n; }
    }
    if (best < 0) return [0, 0];
    const tx = (best % W) + 0.5, tz = ((best / W) | 0) + 0.5;
    const dx = tx - e.x, dz = tz - e.z, d = Math.hypot(dx, dz) || 1;
    return [dx / d, dz / d];
  }

  // ------------------------------------------------------------ criacao
  spawnProjectile(o) { this.projectiles.push(new Projectile(this, o)); }
  spawnLoot(kind, x, z, data) { const l = new Loot(this, kind, x, z, data); this.loot.push(l); return l; }
  spawnGold(x, z, n, spread) {
    const value = 1 + Math.floor((this.floorNum - 1) / 2);
    const coins = Math.min(n, 14), per = Math.max(1, Math.round((n * value) / coins));
    for (let i = 0; i < coins; i++) this.spawnLoot('gold', x, z, per);
  }
  dropItem(x, z, opt = {}) { return this.spawnLoot('item', x, z, makeItem(this.rng, this.floorNum, opt)); }
  spawnEnemyNear(x, z, type, radius, awake, elite = false) {
    for (let t = 0; t < 14; t++) {
      const a = Math.random() * Math.PI * 2, r = radius * (0.5 + Math.random() * 0.5);
      const ex = x + Math.cos(a) * r, ez = z + Math.sin(a) * r;
      if (!this.walkable(ex, ez) || Math.abs(this.cellH(ex, ez) - this.cellH(x, z)) > 1) continue;
      const e = new Enemy(this, type, ex, ez, { awake, spawnFx: true, elite });
      this.enemies.push(e);
      this.particles.burst(ex, this.floorAt(ex, ez) + 0.2, ez, 25, [0.6, 0.2, 1], 2.5, 0.7, 0.3, -2);
      return e;
    }
    return null;
  }

  // ------------------------------------------------------------ efeitos
  floatText(x, y, z, text, color, big = false) {
    const el = this.ui.makeFloat(text, color, big);
    this.floatTexts.push({ wx: x, y, wz: z, el, t: 0, jx: (Math.random() - 0.5) * 0.6, big });
  }
  hitstop(t) { this.hitstopT = Math.max(this.hitstopT, t); }
  shake(a) {
    if (this.reducedMotion === undefined) { try { this.reducedMotion = matchMedia('(prefers-reduced-motion: reduce)').matches; } catch (e) { this.reducedMotion = false; } }
    if (this.reducedMotion) a *= 0.25;
    this.shakeAmt = Math.min(1, Math.max(this.shakeAmt, a));
  }
  slashFx(p, range, arc, final) {
    const col = p.has('melee', 'chamas') ? 0xff8a3a : p.has('melee', 'trovao') ? 0x9ad8ff : 0xfff2dc;
    const geo = new THREE.RingGeometry(range * 0.3, range, 24, 1, -Math.PI / 2 - arc / 2, arc);
    const mat = new THREE.MeshBasicMaterial({ color: col, transparent: true, opacity: final ? 0.6 : 0.4, blending: THREE.AdditiveBlending, depthWrite: false, side: THREE.DoubleSide });
    const m = new THREE.Mesh(geo, mat);
    m.rotation.order = 'YXZ'; m.rotation.x = -Math.PI / 2; m.rotation.y = p.rot;
    m.position.set(p.x, p.y + 0.95, p.z);
    this.scene.add(m);
    let t = 0;
    this.effects.push({ update: (dt) => { t += dt; mat.opacity = (final ? 0.6 : 0.4) * (1 - t / 0.18); m.scale.setScalar(1 + t * 1.2); if (t > 0.18) { this.scene.remove(m); geo.dispose(); mat.dispose(); return false; } return true; } });
  }
  explosion(x, y, z, R, col, small = false, vol = 1) {
    this.particles.burst(x, y, z, small ? 24 : 50, col, R * 2.2, 0.7, small ? 0.28 : 0.4, 2);
    this.particles.dust(x, y, z, small ? 8 : 20, [0.3, 0.28, 0.25], R, 1.5);
    this.particles.ring(x, y, z, R, 30, col, R * 2.5, 0.3);
    const L = this.addLight(x, y + 1, z, 0xff9a40, 40 * vol, R * 4, 0, true);
    let t = 0;
    this.effects.push({ update: (dt) => { t += dt; L.intensity = 40 * vol * Math.max(0, 1 - t / 0.35); if (t > 0.35) { this.removeLight(L); return false; } return true; } });
    this.audio.play('explode', vol * (small ? 0.5 : 1));
    this.shake(small ? 0.15 : 0.45);
  }
  shockwave(x, z, maxR, dmg, color) {
    const geo = new THREE.RingGeometry(0.8, 1, 48);
    const mat = new THREE.MeshBasicMaterial({ color, transparent: true, blending: THREE.AdditiveBlending, depthWrite: false, side: THREE.DoubleSide });
    const m = new THREE.Mesh(geo, mat); m.rotation.x = -Math.PI / 2;
    const y = this.floorAt(x, z) + 0.15;
    m.position.set(x, y, z); this.scene.add(m);
    let r = 0.5, hit = false;
    this.effects.push({
      update: (dt) => {
        r += dt * 8; m.scale.setScalar(r); mat.opacity = 1 - r / maxR;
        const p = this.player, d = Math.hypot(p.x - x, p.z - z);
        if (!hit && Math.abs(d - r) < 0.5 && Math.abs(p.y - y) < 1.2) { if (p.hurt(dmg, null)) hit = true; }
        for (let i = 0; i < 3; i++) { const a = Math.random() * Math.PI * 2; this.particles.dust(x + Math.cos(a) * r, y, z + Math.sin(a) * r, 1, [0.5, 0.45, 0.4], 0.2, 0.5); }
        if (r > maxR) { this.scene.remove(m); geo.dispose(); mat.dispose(); return false; }
        return true;
      },
    });
  }
  chainLightning(first, dmg, n) {
    const pts = [new THREE.Vector3(this.player.x, this.player.y + 1.4, this.player.z)];
    const hit = new Set();
    let cur = first;
    for (let k = 0; k < n && cur; k++) {
      hit.add(cur);
      pts.push(new THREE.Vector3(cur.x, cur.y + 1, cur.z));
      cur.hurt(dmg, { stun: 0.3 });
      let next = null, bd = 5.5;
      for (const e of this.enemies) { if (e.dead || hit.has(e)) continue; const d = Math.hypot(e.x - cur.x, e.z - cur.z); if (d < bd) { bd = d; next = e; } }
      cur = next;
    }
    lightning(this, pts);
    this.audio.play('zap');
  }
  useArtifact(i) {
    const p = this.player, it = p.equip.arts[i];
    if (!it) return;
    if (p.artCd[i] > 0) { this.audio.play('deny'); return; }
    p.artCd[i] = cdOf(it);
    const pw = it.power * p.dmgMult;
    const x = p.x, z = p.z, y = p.y;
    switch (it.kind) {
      case 'chamas': {
        this.audio.play('fire');
        let r = 0; const R = 4.8; const hit = new Set();
        const L = this.addLight(x, y + 1, z, 0xff7020, 18, 12, 0, true);
        this.effects.push({
          update: (dt) => {
            r += dt * 12;
            for (let k = 0; k < 7; k++) { const a = Math.random() * Math.PI * 2; this.particles.fire(x + Math.cos(a) * r, y + 0.25, z + Math.sin(a) * r, 1, 0.3, [0.9, 0.3, 0.05], 0.5); }
            for (const e of this.enemies) if (!e.dead && !hit.has(e) && Math.hypot(e.x - x, e.z - z) < r + e.r) { hit.add(e); e.hurt(30 * pw, { burn: true, fire: true, kx: (e.x - x) * 2, kz: (e.z - z) * 2 }); }
            L.intensity = 18 * (1 - r / R);
            if (r >= R) { this.removeLight(L); return false; }
            return true;
          },
        });
        for (const pot of this.pots) if (!pot.dead && Math.hypot(pot.x - x, pot.z - z) < R) pot.smash();
        break;
      }
      case 'raio': {
        let first = null, bd = 10;
        for (const e of this.enemies) { if (e.dead) continue; const d = Math.hypot(e.x - x, e.z - z); if (d < bd && this.los(x, z, e.x, e.z)) { bd = d; first = e; } }
        if (!first) { p.artCd[i] = 0.5; this.audio.play('deny'); this.ui.toast('Nenhum inimigo por perto.'); return; }
        this.chainLightning(first, 24 * pw, 6);
        break;
      }
      case 'estandarte': {
        const m = makeBannerMesh(); m.position.set(x, y, z); this.scene.add(m);
        const ring = new THREE.Mesh(new THREE.RingGeometry(4.6, 5, 48), new THREE.MeshBasicMaterial({ color: 0xff4a3a, transparent: true, opacity: 0.4, blending: THREE.AdditiveBlending, depthWrite: false }));
        ring.rotation.x = -Math.PI / 2; ring.position.set(x, y + 0.05, z); this.scene.add(ring);
        const L = this.addLight(x, y + 2.5, z, 0xff6040, 10, 8, 0.1, true);
        this.audio.play('banner');
        let t = 0;
        this.effects.push({
          update: (dt) => {
            t += dt;
            if (Math.hypot(p.x - x, p.z - z) < 5) { p.bannerBuff = 0.25; p.heal(0); p.hp = Math.min(p.maxHp, p.hp + 3 * dt * it.power); }
            if (Math.random() < dt * 10) { const a = Math.random() * Math.PI * 2; this.particles.add.emit(x + Math.cos(a) * 4.8, y + 0.1, z + Math.sin(a) * 4.8, 0, 1, 0, 0.8, 0.25, 0.05, 1, 0.35, 0.25, 1, 0, 0); }
            ring.material.opacity = 0.3 + Math.sin(t * 4) * 0.1;
            if (t > 8 * Math.min(1.6, it.power)) { this.scene.remove(m); this.scene.remove(ring); this.removeLight(L); return false; }
            return true;
          },
        });
        break;
      }
      case 'vendaval': {
        this.audio.play('wind');
        this.particles.ring(x, y + 0.6, z, 5, 60, [0.8, 0.95, 0.85], 10, 0.35);
        this.particles.dust(x, y + 0.2, z, 20, [0.6, 0.6, 0.55], 3, 1);
        for (const e of this.enemies) {
          if (e.dead) continue;
          const dx = e.x - x, dz = e.z - z, d = Math.hypot(dx, dz);
          if (d < 5.5) e.hurt(8 * pw, { kx: dx / (d || 1) * 16, kz: dz / (d || 1) * 16, stun: 1.3 });
        }
        for (const pr of this.projectiles) if (pr.owner === 'enemy' && Math.hypot(pr.x - x, pr.z - z) < 5) pr.kill();
        this.shake(0.2);
        break;
      }
      case 'laminas': p.bladesT = 8; p.bladePower = pw; this.audio.play('summon'); break;
      case 'gelo': {
        this.audio.play('freeze');
        this.particles.ring(x, y + 0.4, z, 6, 70, [0.6, 0.9, 1], 12, 0.3);
        this.particles.burst(x, y + 1, z, 40, [0.7, 0.95, 1], 3, 1, 0.2);
        const crystal = new THREE.Mesh(new THREE.OctahedronGeometry(0.5), new THREE.MeshStandardMaterial({ color: 0xaeeaff, emissive: 0x3aa8e0, emissiveIntensity: 2, roughness: 0.1, transparent: true, opacity: 0.85 }));
        crystal.scale.set(0.7, 1.6, 0.7); crystal.position.set(x, y + 0.9, z); this.scene.add(crystal);
        for (const e of this.enemies) if (!e.dead && Math.hypot(e.x - x, e.z - z) < 6.5) e.hurt(10 * pw, { freeze: 3 * Math.min(1.5, it.power) });
        let t = 0;
        this.effects.push({ update: (dt) => { t += dt; crystal.rotation.y += dt; if (t > 3) { this.scene.remove(crystal); crystal.geometry.dispose(); crystal.material.dispose(); this.particles.burst(x, y + 1, z, 20, [0.7, 0.95, 1], 2, 0.6, 0.2, 5); return false; } return true; } });
        break;
      }
    }
  }

  // ------------------------------------------------------------ eventos
  after(delay, fn) {
    let t = 0;
    this.effects.push({ update: (dt) => { t += dt; if (t >= delay) { fn(); return false; } return true; } });
  }
  onBrazierLit(b) {
    this.litCount++;
    const n = this.braziers.length;
    const left = n - this.litCount;
    this.ui.toast(left > 0 ? `Braseiro ancestral aceso! Faltam ${left}.` : 'Todos os braseiros estão acesos! O portão do guardião se abriu.', '#ffb45a');
    const count = 3 + Math.min(5, this.floorNum);
    for (let i = 0; i < count; i++) {
      const type = this.rng.weighted(this.theme.enemies);
      const elite = i === 0 && this.floorNum >= 2 && left === 0;
      this.after(0.6 + i * 0.25, () => this.spawnEnemyNear(b.x, b.z, type, 5, true, elite));
    }
    if (left === 0) this.after(1.5, () => this.gates.open());
  }
  onBossDead(boss) {
    this.bossDead = true; this.bossActive = false;
    this.audio.setBoss(false);
    this.ui.toast(`${boss.B.name} foi derrotado!`, '#ffd76a');
    this.after(2.5, () => { this.ui.setBoss(null); this.gates.open(); });
    this.after(3.2, () => {
      const b = this.dg.boss;
      this.portal = new Portal(this, b.x + b.w / 2 + 0.5, b.z + b.d / 2 + 0.5);
      this.audio.play('portal');
      this.ui.toast('Um portal se abriu no centro da arena.', '#8fd8ff');
    });
  }
  onPlayerDead() {
    this.audio.play('die');
    this.after(1.8, () => { if (this.player.dead) { this.state = 'dead'; this.ui.showDeath(this); } });
  }
  enterPortal() {
    if (this.state !== 'play') return;
    this.state = 'floorDone';
    this.audio.play('portal');
    this.ui.showFloorDone(this);
  }

  // ------------------------------------------------------------ interacao
  nearestInteract() {
    const p = this.player;
    let best = null, bd = 1.9;
    const test = (o, d0 = 1.9) => { if (!o || !o.prompt) return; const d = Math.hypot(o.x - p.x, o.z - p.z); if (d < Math.min(bd, d0)) { bd = d; best = o; } };
    for (const c of this.chests) test(c);
    for (const b of this.braziers) test(b, 2.1);
    test(this.altar, 2.1);
    test(this.portal, 2.4);
    for (const l of this.loot) if (l.kind === 'item' && !l.dead) test(l, 1.6);
    return best;
  }
  pickupItem(loot, slotChoice) {
    const p = this.player, it = loot.data;
    loot.remove();
    this.audio.play('pickup');
    let old = null;
    if (it.cat === 'artifact') {
      let slot = slotChoice;
      if (slot === undefined) {
        slot = p.equip.arts.findIndex(a => !a);
        if (slot < 0) { let ws = 1e9; p.equip.arts.forEach((a, i) => { const s = scoreOf(a); if (s < ws) { ws = s; slot = i; } }); }
      }
      old = p.equip.arts[slot]; p.equip.arts[slot] = it; p.artCd[slot] = Math.min(p.artCd[slot], 2);
    } else {
      old = p.equip[it.cat];
      p.setEquip(it.cat, it);
    }
    this.ui.toast(`Equipado: ${it.name}`, it.rarity === 'unico' ? '#ffb92e' : it.rarity === 'raro' ? '#4fb3ff' : '#e8e0d0');
    if (old) { const l = this.spawnLoot('item', p.x, p.z, old); l.vx *= 0.3; l.vz *= 0.3; l.t = 0; }
  }

  // ------------------------------------------------------------ laco principal
  update(dtReal) {
    const input = this.input;
    this.time += dtReal;
    if (this.state === 'title') { this.titleCam(dtReal); this.world && this.world.update(this.time); this.updateLights(); this.particles.update(dtReal); this.animateFlames(dtReal); return; }
    if (input.pressed('pause') && (this.state === 'play' || this.state === 'pause')) {
      if (this.state === 'play') { this.state = 'pause'; this.ui.showPause(this); } else { this.state = 'play'; this.ui.hidePanels(); }
    }
    if (this.state !== 'play' && this.state !== 'dead' && this.state !== 'floorDone') { input.endFrame(); return; }
    let dt = dtReal;
    if (this.hitstopT > 0) { this.hitstopT -= dtReal; dt *= 0.08; }
    this.dtLogic = dt;
    if (this.state === 'play') this.stats.time += dtReal;
    const p = this.player;

    // mira do mouse
    input.aim = null;
    if (input.mouseActive) {
      this.raycaster.setFromCamera(input.mouseNdc, this.camera);
      this.aimPlane.constant = -(p.y + 1);
      const hit = new THREE.Vector3();
      if (this.raycaster.ray.intersectPlane(this.aimPlane, hit)) input.aim = hit;
    }

    // interacao
    const near = this.state === 'play' && !p.dead ? this.nearestInteract() : null;
    this.near = near;
    if (near && near.kind === 'item' && near.data.cat === 'artifact' && input.down('interact')) {
      for (let i = 0; i < 3; i++) if (input.pressed('art' + (i + 1))) { input.consume('art' + (i + 1)); input.consume('interact'); this.pickupItem(near, i); this.near = null; }
    }
    if (this.near && input.pressed('interact')) {
      if (this.near.kind === 'item') this.pickupItem(this.near); else this.near.interact();
    }

    if (this.state === 'play' || p.dead) {
      const px = p.x, pz = p.z;
      p.update(dt, input, this.time);
      p.vx = (p.x - px) / Math.max(dt, 1e-4); p.vz = (p.z - pz) / Math.max(dt, 1e-4);
    }
    this.computeFlow();

    // chefe: entrada na arena
    const b = this.dg.boss;
    if (!this.bossActive && !this.bossDead && !this.gates.closed && p.x > b.x + 1.5 && p.x < b.x + b.w - 1.5 && p.z > b.z + 1.5 && p.z < b.z + b.d - 1.5) {
      this.bossActive = true;
      this.gates.close();
      this.boss.awake = true;
      this.audio.play('roar'); this.audio.setBoss(true);
      this.ui.setBoss(this.boss);
      this.ui.toast(this.boss.B.name, '#ff6a4a', true);
      this.shake(0.4);
    }

    for (const e of this.enemies) {
      if (!e.awake && !e.dead && Math.abs(e.x - p.x) + Math.abs(e.z - p.z) > 40) { e.rig.root.visible = false; continue; }
      e.rig.root.visible = !e.dead || e.deadT < 1.5;
      e.update(dt, this.time);
    }
    this.enemies = this.enemies.filter(e => !e.removed);
    for (const pr of this.projectiles) pr.update(dt);
    this.projectiles = this.projectiles.filter(pr => !pr.dead);
    for (const l of this.loot) l.update(dt, this.time);
    this.loot = this.loot.filter(l => !l.dead);
    for (const c of this.chests) c.update(dt);
    for (const bz of this.braziers) bz.update(dt, this.time);
    if (this.altar) this.altar.update(dt, this.time);
    this.gates.update(dt);
    if (this.portal) {
      this.portal.update(dt);
      if (Math.hypot(p.x - this.portal.x, p.z - this.portal.z) < 1.0 && this.state === 'play') this.enterPortal();
    }
    const fx = this.effects; this.effects = [];
    const keep = fx.filter(e => e.update(dt));
    this.effects = keep.concat(this.effects);
    this.world.update(this.time);
    this.animateFlames(dt);
    this.ambient(dt);
    this.particles.update(dt);
    this.updateCamera(dtReal);
    this.updateLights();
    this.updateExplored();
    this.updateFloats(dtReal);
    this.audio.update();
    this.ui.update(this);
    input.endFrame();
  }
  animateFlames(dt) {
    const t = this.time;
    if (!this.flames) return;
    for (let i = 0; i < this.flames.length; i++) {
      const f = this.flames[i], b = f.userData.base;
      const k = 1 + Math.sin(t * 15 + i * 1.7) * 0.08 + Math.sin(t * 27 + i) * 0.05;
      f.scale.set(0.34 * b * (2 - k), 0.6 * b * k, 1);
    }
  }
  ambient(dt) {
    const p = this.player;
    if (Math.random() < dt * 25) this.particles.mote(p.x + (Math.random() - 0.5) * 22, p.y + Math.random() * 4, p.z + (Math.random() - 0.5) * 22);
    for (const t of this.dg.torches) {
      if (Math.abs(t.x - p.x) + Math.abs(t.z - p.z) > 22) continue;
      if (Math.random() < dt * 2.5) this.particles.ember(t.x + t.nx * 0.02, t.y + 0.45, t.z + t.nz * 0.02);
      if (Math.random() < dt * 10) this.particles.fire(t.x + t.nx * 0.02, t.y + 0.2, t.z + t.nz * 0.02, 1, 0.08, [1, 0.5, 0.15], 0.28);
    }
    if (this.theme === THEMES.forja || this.dg.themeKey === 'forja') {
      if (Math.random() < dt * 12) this.particles.ember(p.x + (Math.random() - 0.5) * 20, -0.5, p.z + (Math.random() - 0.5) * 20, [1, 0.45, 0.1]);
    }
  }
  updateCamera(dt) {
    const p = this.player;
    const lead = this.input.aim ? 0.12 : 0;
    const tx = p.x + (this.input.aim ? (this.input.aim.x - p.x) * lead : 0);
    const tz = p.z + (this.input.aim ? (this.input.aim.z - p.z) * lead : 0);
    this.camTarget.x = damp(this.camTarget.x, tx, 6, dt);
    this.camTarget.z = damp(this.camTarget.z, tz, 6, dt);
    this.camTarget.y = damp(this.camTarget.y, p.y, 5, dt);
    const zoomT = (this.bossActive ? 1.2 : 1) * this.input.zoom;
    this.zoom = damp(this.zoom, zoomT, 3, dt);
    const s = this.shakeAmt;
    this.shakeAmt = Math.max(0, this.shakeAmt - dt * 2.2);
    const sx = (Math.random() - 0.5) * s * 0.6, sy = (Math.random() - 0.5) * s * 0.6;
    this.camera.position.set(this.camTarget.x + CAM_OFF.x * this.zoom + sx, this.camTarget.y + CAM_OFF.y * this.zoom + sy, this.camTarget.z + CAM_OFF.z * this.zoom - sx);
    this.camera.lookAt(this.camTarget.x, this.camTarget.y + 0.8, this.camTarget.z);
    // sombra acompanha a camera (alinhada aos texels)
    const snap = 44 / 2048;
    const mx = Math.round(this.camTarget.x / snap) * snap, mz = Math.round(this.camTarget.z / snap) * snap;
    this.moon.position.set(mx - 12, 26, mz + 4);
    this.moon.target.position.set(mx, 0, mz);
  }
  titleCam(dt) {
    if (!this.dg) return;
    const s = this.dg.start;
    const a = this.time * 0.06;
    const r = 20;
    this.camera.position.set(s.cx + Math.cos(a) * r, 16, s.cz + Math.sin(a) * r);
    this.camera.lookAt(s.cx, 0, s.cz);
    this.camTarget.set(s.cx, 0, s.cz);
    this.moon.position.set(s.cx - 12, 26, s.cz + 4); this.moon.target.position.set(s.cx, 0, s.cz);
    const p = this.player;
    p.rig.root.position.set(p.x, p.y, p.z);
  }
  updateExplored() {
    this.expT = (this.expT || 0) - this.dtLogic;
    if (this.expT > 0) return;
    this.expT = 0.15;
    const p = this.player, dg = this.dg, R = 8;
    let changed = false;
    const px = Math.floor(p.x), pz = Math.floor(p.z);
    for (let dz = -R; dz <= R; dz++) for (let dx = -R; dx <= R; dx++) {
      if (dx * dx + dz * dz > R * R) continue;
      const x = px + dx, z = pz + dz;
      if (x < 0 || z < 0 || x >= dg.W || z >= dg.D) continue;
      const i = x + z * dg.W;
      if (!this.explored[i]) { this.explored[i] = 1; changed = true; }
    }
    if (changed) this.ui.minimapDirty = true;
  }
  updateFloats(dt) {
    const v = new THREE.Vector3(), w = innerWidth, h = innerHeight;
    this.floatTexts = this.floatTexts.filter(f => { f.t += dt; if (f.t > 0.9) { f.el.remove(); return false; } return true; });
    for (const f of this.floatTexts) {
      v.set(f.wx, f.y + f.t * 1.4, f.wz).project(this.camera);
      f.el.style.opacity = String(Math.max(0, 1 - Math.max(0, f.t - 0.5) * 2.5));
      f.el.style.transform = `translate(${(v.x * 0.5 + 0.5) * w + f.jx * 30}px, ${(-v.y * 0.5 + 0.5) * h}px) translate(-50%, -50%) scale(${f.big ? 1.3 : 1})`;
    }
  }
}
