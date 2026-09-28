// Jogador, inimigos, chefes e projeteis.
import * as THREE from 'three';
import { makeHero, setHeroWeapon, setHeroBow, setHeroArmor, addSilhouette, animateWalk, makeModel } from './models.js';
import { MELEE, BOWS, ARMORS, cdOf } from './items.js';
import { clamp, angleDiff, dampAngle, damp } from './util.js';
import { telegraph, lineTelegraph, lightning, makeBannerMesh } from './objects.js';
import { propMats } from './props.js';

const FWD = [-Math.SQRT1_2, -Math.SQRT1_2], RIGHT = [Math.SQRT1_2, -Math.SQRT1_2];
const ease = (t) => 1 - Math.pow(1 - clamp(t, 0, 1), 3);

// =============================== JOGADOR ===============================
export class Player {
  constructor(game) {
    this.game = game;
    this.rig = makeHero();
    this.x = 0; this.z = 0; this.y = 0; this.rot = 0; this.r = 0.35; this.fh = 0;
    this.level = 1; this.xp = 0; this.xpNext = 60; this.gold = 0; this.arrows = 40; this.maxArrows = 99;
    this.equip = { melee: null, bow: null, armor: null, arts: [null, null, null] };
    this.artCd = [0, 0, 0];
    this.atkCd = 0; this.shootCd = 0; this.rollCd = 0; this.potionCd = 0; this.potionMax = 25;
    this.rollT = 0; this.rollDir = [0, 1]; this.invuln = 0; this.flashT = 0;
    this.swingT = -1; this.shootT = 0; this.combo = 0; this.comboT = 0;
    this.phase = 0; this.moveAmt = 0; this.healLeft = 0; this.bannerBuff = 0; this.dead = false; this.deadT = 0;
    this.bladesT = 0; this.blades = null; this.stepT = 0; this.aimRot = 0; this.lastAimT = 0;
    this.hp = 100;
  }
  attach() {
    const g = this.game;
    g.scene.add(this.rig.root);
    if (!this.rig.silMat) addSilhouette(this.rig);
  }
  setEquip(slot, item) {
    if (slot === 'melee') { this.equip.melee = item; setHeroWeapon(this.rig, item.kind, item.affixes.includes('chamas') ? 0xff6020 : item.affixes.includes('trovao') ? 0x70c8ff : null); addSilhouetteLate(this.rig); }
    if (slot === 'bow') { this.equip.bow = item; setHeroBow(this.rig, item.kind === 'besta'); addSilhouetteLate(this.rig); }
    if (slot === 'armor') { const f = this.hp / this.maxHp; this.equip.armor = item; setHeroArmor(this.rig, ARMORS[item.kind]); this.hp = Math.min(this.maxHp, Math.max(1, f * this.maxHp)); }
  }
  get maxHp() { return 100 + (this.level - 1) * 12 + (this.equip.armor ? this.equip.armor.hp : 0); }
  get dr() { return this.equip.armor ? this.equip.armor.dr : 0; }
  has(slot, affix) { const it = this.equip[slot]; return !!(it && it.affixes.includes(affix)); }
  get dmgMult() { return (1 + 0.07 * (this.level - 1)) * (this.bannerBuff > 0 ? 1.4 : 1); }
  get speed() { const a = this.equip.armor; return 4.7 * (1 + (a ? ARMORS[a.kind].speed : 0)); }
  get rollMax() { return 1.1 * (this.has('armor', 'agil') ? 0.6 : 1) * (this.equip.armor && this.equip.armor.kind === 'andarilho' ? 0.75 : 1); }

  heal(n) {
    if (this.dead) return;
    const before = this.hp;
    this.hp = Math.min(this.maxHp, this.hp + n);
    const d = Math.round(this.hp - before);
    if (d > 0) this.game.floatText(this.x, this.y + 2.1, this.z, '+' + d, '#6dff7a');
  }
  gainXp(n) {
    this.xp += n;
    while (this.xp >= this.xpNext) {
      this.xp -= this.xpNext; this.level++; this.xpNext = Math.round(this.xpNext * 1.3 + 20);
      this.hp = this.maxHp;
      this.game.audio.play('levelup');
      this.game.ui.toast(`Nível ${this.level}! Vida e dano aumentados.`, '#ffd76a');
      this.game.particles.burst(this.x, this.y + 1, this.z, 50, [1, 0.85, 0.3], 4, 1, 0.3, -2);
    }
  }
  hurt(dmg, from) {
    if (this.dead || this.rollT > 0 || this.invuln > 0 || this.game.state !== 'play') return false;
    dmg *= 1 - this.dr;
    this.hp -= dmg;
    this.invuln = 0.45; this.flashT = 0.15;
    const g = this.game;
    g.audio.play('hurt'); g.shake(0.18); g.ui.hurtFlash();
    g.floatText(this.x, this.y + 2, this.z, '-' + Math.round(dmg), '#ff5a4a');
    g.particles.blood(this.x, this.y + 1.1, this.z, 6);
    if (from && from.hurt && this.has('armor', 'espinhos') && from.melee) from.hurt(dmg * 0.4 * (1 / (1 - this.dr)), { thorns: true });
    if (this.hp <= 0) { this.hp = 0; this.dead = true; this.deadT = 0; g.onPlayerDead(); }
    return true;
  }

  aimAssist(range, cone) {
    let best = null, bs = 1e9;
    for (const e of this.game.enemies) {
      if (e.dead) continue;
      const dx = e.x - this.x, dz = e.z - this.z, d = Math.hypot(dx, dz);
      if (d > range + e.r) continue;
      const ad = Math.abs(angleDiff(this.aimRot, Math.atan2(dx, dz)));
      if (ad > cone) continue;
      const s = d + ad * 2;
      if (s < bs) { bs = s; best = e; }
    }
    return best;
  }

  update(dt, input, time) {
    const g = this.game, rig = this.rig;
    this.flashT -= dt; rig.flash(this.flashT > 0 ? 1.5 : 0);
    if (this.dead) {
      this.deadT += dt;
      const k = ease(this.deadT * 2);
      rig.hips.rotation.x = -k * Math.PI / 2; rig.hips.position.y = rig.legH * (1 - k * 0.7);
      return;
    }
    for (const k of ['atkCd', 'shootCd', 'rollCd', 'potionCd', 'invuln', 'comboT', 'bannerBuff']) this[k] = Math.max(0, this[k] - dt);
    for (let i = 0; i < 3; i++) this.artCd[i] = Math.max(0, this.artCd[i] - dt);
    if (this.healLeft > 0) { const h = Math.min(this.healLeft, this.maxHp * 0.6 * dt); this.healLeft -= h; this.hp = Math.min(this.maxHp, this.hp + h); }
    if (this.has('armor', 'regen')) this.hp = Math.min(this.maxHp, this.hp + 1.5 * dt);

    // entrada de movimento
    let mx = input.ax * RIGHT[0] + input.ay * FWD[0], mz = input.ax * RIGHT[1] + input.ay * FWD[1];
    const ml = Math.hypot(mx, mz);
    if (ml > 1) { mx /= ml; mz /= ml; }
    // mira
    if (input.aim) { const dx = input.aim.x - this.x, dz = input.aim.z - this.z; if (Math.hypot(dx, dz) > 0.3) this.aimRot = Math.atan2(dx, dz); }
    else if (input.aimStick) this.aimRot = Math.atan2(input.aimStick[0] * RIGHT[0] + input.aimStick[1] * FWD[0], input.aimStick[0] * RIGHT[1] + input.aimStick[1] * FWD[1]);
    else {
      const t = this.nearestEnemy(9);
      if (t) this.aimRot = Math.atan2(t.x - this.x, t.z - this.z);
      else if (ml > 0.1) this.aimRot = Math.atan2(mx, mz);
    }

    let speed = this.speed;
    const cellType = g.cellType(this.x, this.z);
    if (cellType === 5) speed *= 0.65;
    if (this.slowT > 0) { this.slowT -= dt; speed *= 0.55; }

    if (this.rollT > 0) {
      this.rollT -= dt;
      g.moveEntity(this, this.rollDir[0] * 11.5 * dt, this.rollDir[1] * 11.5 * dt);
      this.rot = Math.atan2(this.rollDir[0], this.rollDir[1]);
      if (Math.random() < 0.5) g.particles.dust(this.x, this.y + 0.1, this.z, 1, [0.4, 0.38, 0.35], 0.3, 0.3);
    } else {
      if (input.pressed('roll') && this.rollCd <= 0) {
        this.rollT = 0.34; this.rollCd = this.rollMax; this.swingT = -1;
        this.rollDir = ml > 0.1 ? [mx / Math.max(ml, 1e-3), mz / Math.max(ml, 1e-3)] : [Math.sin(this.rot), Math.cos(this.rot)];
        g.audio.play('roll');
      }
      if (input.down('attack') && this.atkCd <= 0 && this.swingT < 0) this.melee();
      else if (input.down('shoot') && this.shootCd <= 0 && this.swingT < 0) this.shoot();
      if (input.pressed('potion')) this.usePotion();
      for (let i = 0; i < 3; i++) if (input.pressed('art' + (i + 1))) g.useArtifact(i);
      const busy = this.swingT >= 0 || this.shootT > 0;
      const k = busy ? 0.35 : 1;
      g.moveEntity(this, mx * speed * k * dt, mz * speed * k * dt);
      if (busy || (time - this.lastAimT < 0.4)) this.rot = dampAngle(this.rot, this.aimRot, 25, dt);
      else if (ml > 0.1) this.rot = dampAngle(this.rot, Math.atan2(mx, mz), 14, dt);
    }
    if (this.swingT >= 0) {
      this.swingT += dt;
      if (!this.swingHit && this.swingT >= this.swingDur * 0.45) { this.swingHit = true; this.doMeleeHit(); }
      if (this.swingT >= this.swingDur) this.swingT = -1;
    }
    this.shootT = Math.max(0, this.shootT - dt);

    // altura do chao
    const fy = g.floorAt(this.x, this.z);
    this.fh = g.cellH(this.x, this.z);
    this.y = damp(this.y, fy, 18, dt);

    // animacao
    const moving = this.rollT <= 0 && ml > 0.1;
    this.moveAmt = damp(this.moveAmt, moving ? ml : 0, 10, dt);
    this.phase += dt * speed * 2.1 * (moving ? 1 : 0.3);
    if (moving) { this.stepT -= dt; if (this.stepT <= 0) { this.stepT = 0.32; g.audio.play('step'); if (cellType === 5) g.particles.dust(this.x, this.y, this.z, 2, [0.5, 0.6, 0.65], 0.3, 0.8); } }
    this.animate(dt, time);
    rig.root.position.set(this.x, this.y, this.z);
    rig.root.rotation.y = this.rot;
    this.updateBlades(dt, time);
  }

  nearestEnemy(range) {
    let best = null, bd = range;
    for (const e of this.game.enemies) {
      if (e.dead || !e.awake) continue;
      const d = Math.hypot(e.x - this.x, e.z - this.z);
      if (d < bd && this.game.los(this.x, this.z, e.x, e.z)) { bd = d; best = e; }
    }
    return best;
  }

  animate(dt, time) {
    const r = this.rig;
    animateWalk(r, this.phase, this.moveAmt, time);
    r.hips.rotation.x = 0;
    if (r.bow) r.bow.visible = this.shootT > 0;
    if (r.weapon) r.weapon.visible = !(this.shootT > 0 && this.equip.melee && this.equip.melee.kind === 'lanca');
    r.cape.rotation.x = 0.1 + this.moveAmt * 0.6 + Math.sin(time * 5) * 0.04;
    if (this.rollT > 0) {
      const k = 1 - this.rollT / 0.34;
      r.hips.rotation.x = k * Math.PI * 2;
      r.hips.position.y = r.legH * 0.75;
      r.legL.rotation.x = -1.2; r.legR.rotation.x = -1.2; r.armL.rotation.x = -1; r.armR.rotation.x = -1;
      return;
    }
    // pose de guarda com a arma
    r.armR.rotation.x = Math.min(r.armR.rotation.x, -0.25);
    if (this.swingT >= 0) {
      const k = ease(this.swingT / this.swingDur);
      const kind = this.equip.melee.kind;
      if (kind === 'lanca') {
        const th = Math.sin(k * Math.PI);
        r.armR.rotation.x = -1.57; r.torso.rotation.y = -0.4 + th * 0.4; r.hips.position.z = th * 0.25;
        r.armR.position.z = th * 0.35;
      } else if (kind === 'martelo' || this.combo === 2) {
        r.armR.rotation.x = -3.0 + k * 2.6; r.armL.rotation.x = -3.0 + k * 2.6;
        r.torso.rotation.x = -0.2 + k * 0.5;
      } else if (kind === 'adagas') {
        const side = this.combo % 2 ? r.armL : r.armR;
        side.rotation.x = -1.5; side.rotation.y = (this.combo % 2 ? -1 : 1) * (1 - k * 2) * 0.9;
        r.torso.rotation.y = (this.combo % 2 ? -1 : 1) * (0.6 - k * 1.2);
      } else {
        const dir = this.combo === 1 ? -1 : 1;
        r.armR.rotation.x = -1.45; r.armR.rotation.z = 0.3;
        r.torso.rotation.y = dir * (1.1 - k * 2.3);
      }
    } else {
      r.armR.position.z = 0; r.hips.position.z = 0;
    }
    if (this.shootT > 0) {
      r.armL.rotation.x = -1.55; r.armL.rotation.y = 0.2;
      r.armR.rotation.x = -1.45; r.armR.rotation.y = -0.5;
      r.torso.rotation.y = 0.35;
      if (r.bow) r.bow.rotation.set(Math.PI / 2, 0, 0);
    }
  }

  melee() {
    const g = this.game, w = this.equip.melee, base = MELEE[w.kind];
    const cd = cdOf(w);
    this.combo = this.comboT > 0 ? (this.combo + 1) % base.combo : 0;
    this.comboT = cd + 0.4;
    this.atkCd = cd;
    this.swingT = 0; this.swingDur = Math.min(0.36, cd * 0.85); this.swingHit = false;
    this.lastAimT = g.time;
    const t = this.aimAssist(base.range + 1.2, 1.0);
    if (t) this.aimRot = Math.atan2(t.x - this.x, t.z - this.z);
    this.rot = dampAngle(this.rot, this.aimRot, 60, 0.05);
    g.audio.play(base.dmg > 20 ? 'swingHeavy' : 'swing');
  }
  doMeleeHit() {
    const g = this.game, w = this.equip.melee, base = MELEE[w.kind];
    const final = base.combo > 1 && this.combo === base.combo - 1;
    const range = base.range * (final ? 1.15 : 1), arc = base.arc;
    let dmg = w.dmg * this.dmgMult * (final ? 1.5 : 1);
    let hits = 0;
    g.slashFx(this, range, arc, final);
    for (const e of g.enemies) {
      if (e.dead) continue;
      const dx = e.x - this.x, dz = e.z - this.z, d = Math.hypot(dx, dz);
      if (d > range + e.r) continue;
      if (Math.abs(angleDiff(this.rot, Math.atan2(dx, dz))) > arc / 2 && d > e.r + 0.3) continue;
      const crit = Math.random() < 0.08 + (this.has('melee', 'critico') ? 0.15 : 0);
      const kn = (base.knock || 1) * (final ? 1.6 : 1);
      e.hurt(dmg * (crit ? 2 : 1), { crit, kx: dx / (d || 1) * 5 * kn, kz: dz / (d || 1) * 5 * kn, burn: this.has('melee', 'chamas'), melee: true });
      hits++;
      if (this.has('melee', 'vampiro')) this.heal(1 + dmg * 0.06);
      if (this.has('melee', 'trovao') && Math.random() < 0.2) g.chainLightning(e, dmg * 0.8, 3);
    }
    for (const p of g.pots) {
      if (p.dead) continue;
      const dx = p.x - this.x, dz = p.z - this.z, d = Math.hypot(dx, dz);
      if (d < range + 0.3 && Math.abs(angleDiff(this.rot, Math.atan2(dx, dz))) < arc / 2 + 0.3) p.smash();
    }
    if (hits) { g.hitstop(final ? 0.07 : 0.035); g.shake(final ? 0.12 : 0.05); }
  }
  shoot() {
    const g = this.game, b = this.equip.bow, base = BOWS[b.kind];
    if (this.arrows <= 0) { g.audio.play('deny'); g.ui.toast('Sem flechas!'); this.shootCd = 0.5; return; }
    this.arrows--;
    this.shootCd = cdOf(b); this.shootT = 0.32;
    this.lastAimT = g.time;
    const t = this.aimAssist(16, 0.35);
    if (t) this.aimRot = Math.atan2(t.x - this.x, t.z - this.z);
    this.rot = this.aimRot;
    const angs = this.has('bow', 'multi') ? [-0.18, 0, 0.18] : [0];
    for (const a of angs) {
      const ang = this.aimRot + a;
      g.spawnProjectile({
        type: 'arrow', owner: 'player', x: this.x + Math.sin(ang) * 0.5, y: this.y + 1.2, z: this.z + Math.cos(ang) * 0.5,
        dir: ang, speed: base.speed, dmg: b.dmg * this.dmgMult, pierce: base.pierce + (this.has('bow', 'perfura') ? 2 : 0),
        explosive: this.has('bow', 'explosiva'), burn: this.has('bow', 'chamas'), range: 22,
      });
    }
    g.audio.play('bow');
  }
  usePotion() {
    const g = this.game;
    if (this.potionCd > 0) { g.audio.play('deny'); return; }
    this.potionCd = this.potionMax; this.healLeft += this.maxHp * 0.6;
    g.audio.play('potion');
    g.particles.burst(this.x, this.y + 1, this.z, 30, [1, 0.3, 0.35], 2, 0.8, 0.25, -3);
  }
  updateBlades(dt, time) {
    const g = this.game;
    if (this.bladesT > 0) {
      this.bladesT -= dt;
      if (!this.blades) {
        this.blades = [];
        const mat = new THREE.MeshStandardMaterial({ color: 0xb0a8ff, emissive: 0x7a6aff, emissiveIntensity: 3, transparent: true, opacity: 0.85 });
        for (let i = 0; i < 3; i++) { const m = new THREE.Mesh(new THREE.BoxGeometry(0.08, 0.02, 0.9), mat); g.scene.add(m); this.blades.push(m); }
        this.bladeHit = new Map();
      }
      const power = this.bladePower || 1;
      this.blades.forEach((m, i) => {
        const a = time * 5 + (i / 3) * Math.PI * 2;
        const bx = this.x + Math.sin(a) * 1.7, bz = this.z + Math.cos(a) * 1.7;
        m.position.set(bx, this.y + 1, bz); m.rotation.y = a + Math.PI / 2;
        if (Math.random() < 0.5) g.particles.add.emit(bx, this.y + 1, bz, 0, 0, 0, 0.3, 0.2, 0.02, 0.6, 0.55, 1, 0.8, 0, 0);
        for (const e of g.enemies) {
          if (e.dead) continue;
          if (Math.hypot(e.x - bx, e.z - bz) < e.r + 0.5) {
            const last = this.bladeHit.get(e) || 0;
            if (time - last > 0.35) { this.bladeHit.set(e, time); e.hurt(9 * power * this.dmgMult, { kx: Math.sin(a) * 2, kz: Math.cos(a) * 2 }); }
          }
        }
      });
    } else if (this.blades) {
      for (const m of this.blades) { g.scene.remove(m); m.geometry.dispose(); }
      this.blades[0].material.dispose(); this.blades = null;
    }
  }
}
function addSilhouetteLate(rig) { // novas pecas (arma) tambem ganham silhueta
  if (!rig.silMat) return;
  for (const mesh of rig.meshes) {
    if (mesh.children.some(c => c.userData.sil)) continue;
    const s = new THREE.Mesh(mesh.geometry, rig.silMat); s.renderOrder = 1; s.userData.sil = true; mesh.add(s); mesh.renderOrder = 2;
  }
}

// =============================== INIMIGOS ===============================
export const ENEMY = {
  carnical: { name: 'Carniçal', hp: 42, dmg: 10, speed: 2.3, r: 0.4, range: 1.35, windup: 0.5, cd: 1.3, xp: 10, blood: [0.2, 0.28, 0.1], sound: 'hit', mass: 1 },
  esqueleto: { name: 'Esqueleto Arqueiro', hp: 28, dmg: 8, speed: 2.5, r: 0.35, ranged: true, prefer: 7, windup: 0.7, cd: 2.2, xp: 12, blood: [0.85, 0.82, 0.72], sound: 'boneHit', mass: 0.8 },
  aranha: { name: 'Aranha da Cripta', hp: 30, dmg: 9, speed: 3.5, r: 0.5, range: 3.6, lunge: true, windup: 0.4, cd: 1.8, xp: 12, blood: [0.25, 0.3, 0.08], sound: 'hit', mass: 0.8 },
  aranhinha: { name: 'Aranha Filhote', hp: 12, dmg: 5, speed: 4.2, r: 0.3, range: 1.0, windup: 0.25, cd: 1.0, xp: 3, blood: [0.25, 0.3, 0.08], sound: 'hit', mass: 0.5 },
  necromante: { name: 'Necromante', hp: 50, dmg: 12, speed: 2.0, r: 0.4, ranged: true, prefer: 8, windup: 0.8, cd: 2.6, xp: 28, blood: [0.4, 0.1, 0.5], sound: 'hit', mass: 1, summoner: true },
  esporo: { name: 'Esporo Inchado', hp: 22, dmg: 34, speed: 2.7, r: 0.45, range: 2.0, fuse: true, windup: 1.1, cd: 1, xp: 8, blood: [0.8, 0.75, 0.3], sound: 'hit', mass: 0.9 },
};
export const BOSS = {
  gorran: { name: 'Gorran, o Devorador', hp: 950, dmg: 22, speed: 2.4, r: 1.0, attacks: ['slam', 'charge', 'swipe', 'swipe'], summon: 'carnical', blood: [0.2, 0.28, 0.1], baseFloor: 1 },
  veshkara: { name: "Vesh'kara, Mãe da Teia", hp: 1050, dmg: 20, speed: 3.0, r: 1.2, attacks: ['leap', 'spit', 'bite', 'bite'], summon: 'aranhinha', blood: [0.35, 0.1, 0.4], baseFloor: 2 },
  colosso: { name: 'Colosso de Obsidiana', hp: 1400, dmg: 26, speed: 2.0, r: 1.1, attacks: ['slam', 'meteor', 'charge', 'swipe'], summon: 'esporo', blood: [1, 0.5, 0.1], baseFloor: 3 },
};
const hpScale = (f) => 1 + 0.45 * (f - 1);
const dmgScale = (f) => 1 + 0.3 * (f - 1);

export class Enemy {
  constructor(game, type, x, z, opts = {}) {
    this.game = game; this.type = type;
    const S = this.S = ENEMY[type];
    const f = game.floorNum;
    this.maxHp = this.hp = S.hp * hpScale(f) * (opts.elite ? 2.2 : 1);
    this.dmg = S.dmg * dmgScale(f) * (opts.elite ? 1.3 : 1);
    this.r = S.r; this.x = x; this.z = z; this.y = game.floorAt(x, z); this.fh = game.cellH(x, z);
    this.rot = Math.random() * Math.PI * 2; this.kx = 0; this.kz = 0;
    this.awake = !!opts.awake; this.dead = false; this.deadT = 0;
    this.state = 'move'; this.atkT = 0; this.cd = 1 + Math.random(); this.summonCd = 6;
    this.burnT = 0; this.burnDps = 0; this.freezeT = 0; this.stunT = 0; this.flashT = 0; this.slowT = 0;
    this.phase = Math.random() * 10; this.moveAmt = 0; this.strafe = Math.random() < 0.5 ? 1 : -1;
    this.melee = !S.ranged;
    this.rig = makeModel(type);
    if (opts.elite) { this.rig.root.scale.multiplyScalar(1.35); this.r *= 1.3; this.elite = true; }
    this.rig.root.position.set(x, this.y, z);
    game.scene.add(this.rig.root);
    this.spawnT = opts.spawnFx ? 0 : 1;
  }
  get name() { return this.S.name; }

  hurt(dmg, o = {}) {
    if (this.dead) return;
    const g = this.game;
    this.hp -= dmg;
    this.flashT = 0.12;
    this.wake();
    const m = 1 / (this.S.mass || 1);
    if (o.kx) { this.kx += o.kx * m; this.kz += o.kz * m; }
    if (o.burn) { this.burnT = 3; this.burnDps = Math.max(this.burnDps, dmg * 0.18); }
    if (o.stun) this.stunT = Math.max(this.stunT, o.stun);
    if (o.freeze) this.freezeT = Math.max(this.freezeT, o.freeze);
    g.floatText(this.x, this.y + 1.2 * this.rig.root.scale.y + 0.9, this.z, Math.round(dmg) + (o.crit ? '!' : ''), o.crit ? '#ffd23a' : o.fire ? '#ff9a3a' : o.dot ? '#ffae5a' : '#ffffff', o.crit);
    if (!o.dot) {
      const b = this.S.blood;
      g.particles.blood(this.x, this.y + 0.9, this.z, o.crit ? 14 : 7, b);
      g.audio.play(o.crit ? 'crit' : this.S.sound, 0.8);
    }
    if (this.hp <= 0) this.die();
  }
  wake() {
    if (this.awake) return;
    this.awake = true;
    for (const e of this.game.enemies) if (!e.awake && !e.dead && Math.hypot(e.x - this.x, e.z - this.z) < 7) { e.awake = true; }
  }
  die() {
    const g = this.game;
    this.dead = true; this.deadT = 0; this.hp = 0;
    g.player.gainXp(this.S.xp * (this.elite ? 3 : 1) * (1 + 0.2 * (g.floorNum - 1)));
    g.stats.kills++;
    g.audio.play('die', 0.7);
    if (this.type === 'esqueleto') g.particles.dust(this.x, this.y + 0.5, this.z, 12, [0.8, 0.78, 0.7], 0.6);
    if (this.type === 'esporo') g.particles.burst(this.x, this.y + 0.6, this.z, 20, [0.8, 0.75, 0.3], 2, 0.8, 0.3);
    const r = Math.random();
    if (r < 0.75) g.spawnGold(this.x, this.z, 1 + Math.floor(Math.random() * 3), 1.5);
    if (Math.random() < 0.07) g.spawnLoot('heart', this.x, this.z);
    if (Math.random() < 0.12) g.spawnLoot('arrows', this.x, this.z);
    if (Math.random() < (this.elite ? 0.6 : 0.03)) g.dropItem(this.x, this.z, { bonus: this.elite ? 0.4 : 0 });
  }

  update(dt, time) {
    const g = this.game, p = g.player, S = this.S, rig = this.rig;
    if (this.dead) {
      this.deadT += dt;
      const k = ease(this.deadT * 2.5);
      if (this.type === 'aranha' || this.type === 'aranhinha') { rig.root.rotation.z = k * Math.PI; rig.root.position.y = this.y + k * 0.3; }
      else if (this.type === 'esporo') { rig.root.scale.setScalar(1 - k); }
      else { if (rig.hips) { rig.hips.rotation.x = -k * Math.PI / 2; rig.hips.position.y = rig.legH * (1 - k * 0.75); } }
      if (this.deadT > 1.2) { rig.fade(Math.max(0, 1 - (this.deadT - 1.2) * 2)); rig.root.position.y -= dt * 0.4; }
      if (this.deadT > 1.8) { g.scene.remove(rig.root); rig.dispose(); this.removed = true; }
      return;
    }
    if (this.spawnT < 1) {
      this.spawnT += dt * 1.5;
      rig.root.scale.setScalar(ease(this.spawnT) * (this.elite ? 1.35 : 1) * (this.baseScale || 1));
      rig.root.position.set(this.x, this.y - (1 - this.spawnT) * 1.2, this.z);
      return;
    }
    // efeitos de estado
    this.flashT -= dt;
    rig.flash(this.flashT > 0 ? 2 : this.state === 'attack' && S.fuse ? (Math.sin(this.atkT * 30) > 0 ? 1.2 : 0) : 0);
    if (this.burnT > 0) {
      this.burnT -= dt;
      this.burnAcc = (this.burnAcc || 0) + dt;
      if (this.burnAcc > 0.5) { this.burnAcc = 0; this.hurt(this.burnDps * 0.5, { dot: true, fire: true }); if (this.dead) return; }
      if (Math.random() < dt * 20) g.particles.fire(this.x, this.y + 0.3 + Math.random() * 1.2, this.z, 1, 0.6);
    } else this.burnDps = 0;
    if (this.freezeT > 0) {
      this.freezeT -= dt; rig.tint(new THREE.Color(0x80d8ff), 0.7);
      if (this.freezeT <= 0) rig.tint(new THREE.Color(0xffffff), 0);
      if (Math.random() < dt * 5) g.particles.add.emit(this.x + (Math.random() - 0.5) * 0.6, this.y + Math.random() * 1.5, this.z + (Math.random() - 0.5) * 0.6, 0, 0.2, 0, 0.6, 0.12, 0.02, 0.6, 0.9, 1, 1, 0, 0);
      this.applyKnock(dt);
      return;
    }
    this.applyKnock(dt);
    const dx = p.x - this.x, dz = p.z - this.z, d = Math.hypot(dx, dz);
    if (!this.awake) {
      if (d < 11 && g.los(this.x, this.z, p.x, p.z)) this.wake();
      animateWalk(rig, this.phase, 0, time);
      this.place(dt);
      return;
    }
    if (this.stunT > 0) { this.stunT -= dt; animateWalk(rig, this.phase, 0, time); this.place(dt); if (Math.random() < dt * 6) g.particles.add.emit(this.x, this.y + 2, this.z, (Math.random() - 0.5), 0.5, (Math.random() - 0.5), 0.5, 0.15, 0.02, 1, 1, 0.5, 1, 0, 0); return; }
    this.cd -= dt; this.summonCd -= dt;
    let mvx = 0, mvz = 0;
    const toP = Math.atan2(dx, dz);
    const los = d < 16 && g.los(this.x, this.z, p.x, p.z);
    if (this.state === 'attack') {
      this.atkT += dt;
      this.rot = dampAngle(this.rot, toP, S.lunge && this.lunging ? 0 : 6, dt);
      this.attackUpdate(dt, d, dx, dz);
    } else if (!p.dead) {
      // escolha de movimento
      if (S.ranged) {
        if (d < S.prefer - 2.5 && los) { mvx = -dx / d; mvz = -dz / d; }
        else if (d > S.prefer + 1 || !los) { [mvx, mvz] = g.flowDir(this); }
        else { mvx = dz / d * this.strafe * 0.5; mvz = -dx / d * this.strafe * 0.5; if (Math.random() < dt * 0.4) this.strafe *= -1; }
        if (S.summoner && this.summonCd <= 0 && los && d < 12) { this.startAttack('summon'); }
        else if (this.cd <= 0 && los && d < S.prefer + 5) this.startAttack('shoot');
      } else {
        if (d < 2.2 && los) { mvx = dx / d; mvz = dz / d; } else [mvx, mvz] = g.flowDir(this);
        if (this.cd <= 0 && d < S.range + p.r + 0.2 && los) this.startAttack(S.fuse ? 'fuse' : S.lunge ? 'lunge' : 'melee');
      }
    }
    // separacao (inclui o jogador)
    {
      const ox = this.x - p.x, oz = this.z - p.z, od = Math.hypot(ox, oz), min = this.r + p.r;
      if (od < min && od > 0.001 && !p.dead) { const k = (min - od) / min; mvx += ox / od * k * 2; mvz += oz / od * k * 2; }
    }
    for (const o of g.enemies) {
      if (o === this || o.dead) continue;
      const ox = this.x - o.x, oz = this.z - o.z, od = Math.hypot(ox, oz), min = this.r + o.r;
      if (od < min && od > 0.001) { const k = (min - od) / min; mvx += ox / od * k * 1.5; mvz += oz / od * k * 1.5; }
    }
    const ml = Math.hypot(mvx, mvz);
    let spd = S.speed * (this.slowT > 0 ? 0.5 : 1) * (g.cellType(this.x, this.z) === 5 ? 0.7 : 1);
    if (this.slowT > 0) this.slowT -= dt;
    if (ml > 0.01 && this.state !== 'attack') {
      const n = Math.min(1, ml);
      g.moveEntity(this, mvx / ml * spd * n * dt, mvz / ml * spd * n * dt);
      const face = S.ranged && los && d < S.prefer + 3 ? toP : Math.atan2(mvx, mvz);
      this.rot = dampAngle(this.rot, face, 8, dt);
    } else if (this.state !== 'attack' && los) this.rot = dampAngle(this.rot, toP, 6, dt);
    const moving = ml > 0.05 && this.state !== 'attack';
    this.moveAmt = damp(this.moveAmt, moving ? 1 : 0, 8, dt);
    this.phase += dt * spd * 2.4 * (moving ? 1 : 0);
    animateWalk(rig, this.phase, this.moveAmt, time);
    this.attackPose();
    this.place(dt);
  }
  applyKnock(dt) {
    if (Math.abs(this.kx) + Math.abs(this.kz) > 0.05) {
      this.game.moveEntity(this, this.kx * dt, this.kz * dt);
      const k = Math.exp(-8 * dt); this.kx *= k; this.kz *= k;
    }
  }
  place(dt) {
    this.y = damp(this.y, this.game.floorAt(this.x, this.z), 15, dt);
    this.fh = this.game.cellH(this.x, this.z);
    this.rig.root.position.set(this.x, this.y + (this.hover || 0), this.z);
    this.rig.root.rotation.y = this.rot;
  }
  startAttack(kind) {
    this.state = 'attack'; this.atkKind = kind; this.atkT = 0; this.did = false; this.lunging = false;
    if (kind === 'fuse') this.game.audio.play('fuse');
    if (kind === 'summon') { this.game.audio.play('summon', 0.7); }
    if (kind === 'lunge') this.game.audio.play('hiss', 0.6);
  }
  endAttack(cd) { this.state = 'move'; this.cd = cd; this.lunging = false; }
  attackUpdate(dt, d, dx, dz) {
    const g = this.game, p = g.player, S = this.S;
    const w = this.atkKind === 'summon' ? 1.0 : S.windup;
    if (this.atkKind === 'melee') {
      if (!this.did && this.atkT >= w) {
        this.did = true;
        g.audio.play('swing', 0.6);
        const ad = Math.abs(angleDiff(this.rot, Math.atan2(dx, dz)));
        if (d < S.range + p.r + 0.35 && ad < 1.3) p.hurt(this.dmg, this);
      }
      if (this.atkT >= w + 0.35) this.endAttack(S.cd);
    } else if (this.atkKind === 'lunge') {
      if (this.atkT >= w && this.atkT < w + 0.3) {
        this.lunging = true;
        g.moveEntity(this, Math.sin(this.rot) * 10 * dt, Math.cos(this.rot) * 10 * dt);
        if (!this.did && d < this.r + p.r + 0.3) { this.did = true; p.hurt(this.dmg, this); }
      }
      if (this.atkT >= w + 0.6) this.endAttack(S.cd);
    } else if (this.atkKind === 'shoot') {
      if (!this.did && this.atkT >= w) {
        this.did = true;
        const lead = d / 14;
        const tx = p.x + (p.vx || 0) * lead * 0.5, tz = p.z + (p.vz || 0) * lead * 0.5;
        const ang = Math.atan2(tx - this.x, tz - this.z);
        if (this.type === 'necromante') {
          g.spawnProjectile({ type: 'bolt', owner: 'enemy', x: this.x + Math.sin(ang) * 0.6, y: this.y + 1.3, z: this.z + Math.cos(ang) * 0.6, dir: ang, speed: 7.5, dmg: this.dmg, homing: 1.4, range: 18 });
          g.audio.play('bolt', 0.8);
        } else {
          g.spawnProjectile({ type: 'arrow', owner: 'enemy', x: this.x + Math.sin(ang) * 0.5, y: this.y + 1.2, z: this.z + Math.cos(ang) * 0.5, dir: ang, speed: 14, dmg: this.dmg, range: 18 });
          g.audio.play('bow', 0.6);
        }
      }
      if (this.atkT >= w + 0.3) this.endAttack(S.cd * (0.8 + Math.random() * 0.4));
    } else if (this.atkKind === 'summon') {
      if (Math.random() < 0.6) g.particles.add.emit(this.x + (Math.random() - 0.5) * 2, this.y + 0.1, this.z + (Math.random() - 0.5) * 2, 0, 2, 0, 0.6, 0.3, 0.05, 0.6, 0.2, 1, 1, 0, 0);
      if (!this.did && this.atkT >= w) {
        this.did = true;
        const n = g.enemies.filter(e => !e.dead).length < 30 ? 2 : 0;
        for (let i = 0; i < n; i++) g.spawnEnemyNear(this.x, this.z, 'carnical', 2.5, true);
        this.summonCd = 11;
      }
      if (this.atkT >= w + 0.3) this.endAttack(1.2);
    } else if (this.atkKind === 'fuse') {
      const k = this.atkT / w;
      this.rig.root.scale.setScalar(1 + k * 0.35);
      if (this.atkT >= w) {
        this.explode();
      }
    }
  }
  explode() {
    const g = this.game, p = g.player;
    const R = 2.9;
    g.explosion(this.x, this.y + 0.5, this.z, R, [0.9, 0.8, 0.3]);
    const d = Math.hypot(p.x - this.x, p.z - this.z);
    if (d < R + p.r) p.hurt(this.dmg * (1 - 0.5 * d / R), this);
    for (const e of g.enemies) if (e !== this && !e.dead && Math.hypot(e.x - this.x, e.z - this.z) < R) e.hurt(this.dmg * 0.5, { kx: (e.x - this.x) * 3, kz: (e.z - this.z) * 3 });
    for (const pot of g.pots) if (!pot.dead && Math.hypot(pot.x - this.x, pot.z - this.z) < R) pot.smash();
    this.hp = 0;
    this.die();
    this.rig.root.visible = false;
    this.deadT = 1.5;
  }
  attackPose() {
    const r = this.rig;
    if (this.state !== 'attack') return;
    const k = this.atkT / (this.atkKind === 'summon' ? 1 : this.S.windup);
    if (this.type === 'aranha' || this.type === 'aranhinha') {
      r.body.rotation.x = this.atkT < this.S.windup ? -0.35 * Math.min(1, k) : 0.2;
      return;
    }
    if (this.type === 'esporo') return;
    if (this.atkKind === 'melee') {
      const up = k < 1 ? ease(k) : 1 - ease((this.atkT - this.S.windup) / 0.2);
      r.armL.rotation.x = r.armR.rotation.x = -1.3 - up * 1.5 + (k >= 1 ? 1.2 : 0);
      r.torso.rotation.x = k < 1 ? -0.2 * up : 0.35;
    } else if (this.atkKind === 'shoot') {
      if (this.type === 'esqueleto') { r.armL.rotation.x = -1.57; r.armR.rotation.x = -1.5; r.armR.rotation.y = -0.4 * Math.min(1, k); r.torso.rotation.y = 0.3; }
      else { r.armR.rotation.x = -1.2 - Math.min(1, k) * 1.4; }
    } else if (this.atkKind === 'summon') {
      r.armL.rotation.x = r.armR.rotation.x = -2.8; r.armL.rotation.z = -0.4; r.armR.rotation.z = 0.4;
    }
  }
  remove() { this.game.scene.remove(this.rig.root); this.rig.dispose(); this.removed = true; }
}

// =============================== CHEFE ===============================
export class Boss extends Enemy {
  constructor(game, type, x, z) {
    const B = BOSS[type];
    ENEMY[type] = { name: B.name, hp: B.hp, dmg: B.dmg, speed: B.speed, r: B.r, windup: 0.5, cd: 1.6, xp: 400, blood: B.blood, sound: 'hit', mass: 12 };
    super(game, type, x, z, {});
    const f = game.floorNum;
    this.maxHp = this.hp = B.hp * hpScale(f) / hpScale(B.baseFloor) * (f > B.baseFloor ? 1 + 0.1 * (f - B.baseFloor) : 1);
    this.dmg = B.dmg * dmgScale(f) / dmgScale(B.baseFloor);
    this.B = B; this.isBoss = true; this.phase2 = false; this.cd = 2; this.summonCd = 14;
    this.light = game.addLight(x, 5, z, { gorran: 0xb0ffa0, veshkara: 0xd8a0ff, colosso: 0xffa060 }[type], 0, 16, 0.05, true);
    this.rot = Math.PI / 4;
  }
  hurt(dmg, o = {}) {
    if (o.freeze) o.freeze *= 0.25;
    if (o.stun) o.stun = 0;
    super.hurt(dmg, o);
    if (!this.phase2 && this.hp < this.maxHp * 0.5 && !this.dead) {
      this.phase2 = true; this.game.audio.play('roar'); this.game.shake(0.5);
      this.game.ui.toast(`${this.B.name} está enfurecido!`, '#ff6a4a');
      this.summonCd = 0;
    }
  }
  wake() { if (this.game.bossActive) this.awake = true; }
  die() {
    const g = this.game;
    this.dead = true; this.deadT = 0; this.hp = 0;
    g.player.gainXp(300 * (1 + 0.25 * (g.floorNum - 1)));
    g.stats.kills++;
    g.audio.play('roar'); g.audio.play('explode');
    g.shake(0.8);
    g.particles.burst(this.x, this.y + 2, this.z, 120, [1, 0.7, 0.3], 8, 1.5, 0.5, 4);
    g.spawnGold(this.x, this.z, 40 + g.floorNum * 10, 5);
    g.dropItem(this.x, this.z, { rarity: 'unico' });
    g.dropItem(this.x, this.z, { bonus: 0.6 });
    g.spawnLoot('heart', this.x, this.z); g.spawnLoot('arrows', this.x, this.z);
    g.onBossDead(this);
    g.removeLight(this.light);
  }
  update(dt, time) {
    const g = this.game, p = g.player, rig = this.rig;
    if (this.dead || this.freezeT > 0) { super.update(dt, time); return; }
    if (!this.awake) { animateWalk(rig, this.phase, 0, time); this.place(dt); return; }
    this.light.intensity = Math.min(22, this.light.intensity + dt * 20);
    this.light.x = this.x + 1.5; this.light.y = this.y + 5.5; this.light.z = this.z + 1.5;
    this.flashT -= dt; rig.flash(this.flashT > 0 ? 1.2 : 0);
    if (this.burnT > 0) { this.burnT -= dt; this.burnAcc = (this.burnAcc || 0) + dt; if (this.burnAcc > 0.5) { this.burnAcc = 0; this.hurt(this.burnDps * 0.5, { dot: true, fire: true }); if (this.dead) return; } if (Math.random() < dt * 25) g.particles.fire(this.x, this.y + Math.random() * 3, this.z, 1, 1.2); }
    this.applyKnock(dt);
    const dx = p.x - this.x, dz = p.z - this.z, d = Math.hypot(dx, dz), toP = Math.atan2(dx, dz);
    const spd = this.S.speed * (this.phase2 ? 1.25 : 1);
    this.cd -= dt; this.summonCd -= dt;
    if (this.type === 'colosso' && Math.random() < dt * 6) g.particles.ember(this.x + (Math.random() - 0.5) * 2, this.y + 1 + Math.random() * 3, this.z + (Math.random() - 0.5) * 2);
    let moving = false;
    if (this.atk) this.bossAttack(dt, d, dx, dz, toP);
    else if (!p.dead) {
      if (d > 2.2) {
        let [mx, mz] = d < 6 ? [dx / d, dz / d] : g.flowDir(this);
        g.moveEntity(this, mx * spd * dt, mz * spd * dt);
        moving = true;
      }
      this.rot = dampAngle(this.rot, toP, 5, dt);
      if (this.cd <= 0) this.chooseAttack(d);
    }
    // corpo do chefe empurra o jogador
    const d2 = Math.hypot(p.x - this.x, p.z - this.z);
    if (!p.dead && d2 < this.r + p.r && !this.hover) {
      const push = (this.r + p.r - d2) * Math.min(1, dt * 12);
      const nx = d2 > 0.001 ? (p.x - this.x) / d2 : 1, nz = d2 > 0.001 ? (p.z - this.z) / d2 : 0;
      g.moveEntity(p, nx * push, nz * push);
    }
    this.moveAmt = damp(this.moveAmt, moving ? 1 : 0, 6, dt);
    this.phase += dt * spd * 2 * (moving ? 1 : 0);
    if (!this.atk || this.atk.anim !== 'custom') animateWalk(rig, this.phase, this.moveAmt, time);
    this.bossPose();
    this.place(dt);
  }
  chooseAttack(d) {
    const B = this.B;
    if (this.summonCd <= 0 && (this.phase2 || Math.random() < 0.3)) { this.atk = { name: 'summon', t: 0 }; this.summonCd = this.phase2 ? 12 : 18; this.game.audio.play('summon'); return; }
    let opts = B.attacks.filter(a => (['swipe', 'bite', 'slam'].includes(a) ? d < 4.5 : true));
    if (d > 6) opts = B.attacks.filter(a => ['charge', 'leap', 'spit', 'meteor'].includes(a));
    if (!opts.length) opts = B.attacks;
    const name = opts[Math.floor(Math.random() * opts.length)];
    this.atk = { name, t: 0, did: 0, ang: this.rot };
    const g = this.game, p = g.player;
    if (name === 'slam') { telegraph(g, this.x, this.z, 4, 1.0); }
    if (name === 'swipe' || name === 'bite') { telegraph(g, this.x + Math.sin(this.rot) * 1.6, this.z + Math.cos(this.rot) * 1.6, 2.3, name === 'bite' ? 0.45 : 0.6); }
    if (name === 'charge') { const a = Math.atan2(p.x - this.x, p.z - this.z); this.atk.ang = a; lineTelegraph(g, this.x, this.z, a, 12, 2.2, 0.8); g.audio.play('roar', 0.6); }
    if (name === 'leap') { this.atk.tx = p.x; this.atk.tz = p.z; this.atk.sx = this.x; this.atk.sz = this.z; telegraph(g, p.x, p.z, 3.2, 1.1, 0xc040ff); g.audio.play('hiss'); }
    if (name === 'meteor') {
      this.atk.targets = [];
      const n = this.phase2 ? 8 : 6;
      for (let i = 0; i < n; i++) {
        const a = Math.random() * Math.PI * 2, r = i === 0 ? 0 : 1.5 + Math.random() * 5;
        const tx = p.x + Math.cos(a) * r, tz = p.z + Math.sin(a) * r;
        if (!g.walkable(tx, tz)) continue;
        const delay = 0.2 + i * 0.12;
        this.atk.targets.push({ x: tx, z: tz, t: 1.3 + delay, done: false });
        setTimeoutGame(g, delay, () => telegraph(g, tx, tz, 1.7, 1.3, 0xff6a10));
      }
      g.audio.play('roar', 0.5);
    }
  }
  bossAttack(dt, d, dx, dz, toP) {
    const g = this.game, p = g.player, a = this.atk;
    a.t += dt;
    const sp = this.phase2 ? 1.2 : 1;
    const done = (cd) => { this.atk = null; this.cd = cd / sp; };
    switch (a.name) {
      case 'swipe': case 'bite': {
        const w = a.name === 'bite' ? 0.45 : 0.6;
        if (!a.did && a.t >= w) {
          a.did = 1; g.audio.play('swingHeavy');
          const ad = Math.abs(angleDiff(this.rot, toP));
          if (d < 3.4 + p.r && ad < 1.4) p.hurt(this.dmg * 0.8, this);
          g.shake(0.1);
        }
        if (a.t >= w + 0.4) done(1.1);
        break;
      }
      case 'slam': {
        if (!a.did && a.t >= 1.0) {
          a.did = 1;
          g.audio.play('slam'); g.shake(0.6);
          g.particles.dust(this.x, this.y + 0.2, this.z, 40, [0.5, 0.45, 0.4], 4, 1.5);
          if (this.type === 'colosso') g.particles.burst(this.x, this.y + 0.3, this.z, 50, [1, 0.5, 0.1], 6, 0.8, 0.4, 5);
          if (d < 4 + p.r) p.hurt(this.dmg * 1.2, this);
          g.shockwave(this.x, this.z, this.type === 'colosso' ? 11 : 9, this.dmg * 0.6, this.type === 'colosso' ? 0xff6a20 : 0xd0b080);
          if (this.phase2) setTimeoutGame(g, 0.45, () => g.shockwave(this.x, this.z, 9, this.dmg * 0.6, 0xff4020));
        }
        if (a.t >= 1.7) done(1.4);
        break;
      }
      case 'charge': {
        if (a.t < 0.8) { this.rot = dampAngle(this.rot, a.ang, 10, dt); break; }
        if (a.t < 1.65 && !a.stopped) {
          const vx = Math.sin(a.ang) * 15 * dt, vz = Math.cos(a.ang) * 15 * dt;
          const ox = this.x, oz = this.z;
          g.moveEntity(this, vx, vz);
          if (Math.random() < 0.8) g.particles.dust(this.x, this.y + 0.1, this.z, 2, [0.5, 0.45, 0.4], 0.8, 0.5);
          if (!a.did && d < this.r + p.r + 0.4) { a.did = 1; p.hurt(this.dmg * 1.1, this); p.slowT = 0.3; }
          if (Math.hypot(this.x - ox, this.z - oz) < Math.hypot(vx, vz) * 0.3) { a.stopped = true; a.stopT = a.t; g.shake(0.5); g.audio.play('slam'); g.particles.dust(this.x, this.y + 1, this.z, 25, [0.5, 0.45, 0.4], 2, 2); this.stunT = 0; }
        } else if (!a.stopped) { a.stopped = true; a.stopT = a.t; }
        if (a.stopped && a.t > a.stopT + (a.did ? 0.5 : 1.2)) done(1.2);
        break;
      }
      case 'leap': {
        const T0 = 0.3, T1 = 1.1;
        if (a.t > T0 && a.t < T1) {
          const k = (a.t - T0) / (T1 - T0);
          this.x = a.sx + (a.tx - a.sx) * k; this.z = a.sz + (a.tz - a.sz) * k;
          this.hover = Math.sin(k * Math.PI) * 3;
          this.rot = Math.atan2(a.tx - a.sx, a.tz - a.sz);
        }
        if (!a.did && a.t >= T1) {
          a.did = 1; this.hover = 0;
          if (!g.walkable(this.x, this.z)) { this.x = a.sx; this.z = a.sz; }
          g.audio.play('slam'); g.shake(0.5);
          g.particles.dust(this.x, this.y + 0.2, this.z, 35, [0.4, 0.35, 0.4], 3.2, 1.2);
          if (Math.hypot(p.x - this.x, p.z - this.z) < 3.2 + p.r) p.hurt(this.dmg * 1.1, this);
        }
        if (a.t >= T1 + 0.6) done(1.2);
        break;
      }
      case 'spit': {
        const vol = Math.floor(a.t / 0.45);
        if (vol > a.did && vol <= 3) {
          a.did = vol;
          const n = this.phase2 ? 7 : 5;
          for (let i = 0; i < n; i++) {
            const ang = toP + (i - (n - 1) / 2) * 0.22;
            g.spawnProjectile({ type: 'web', owner: 'enemy', x: this.x + Math.sin(ang) * 1.3, y: this.y + 1, z: this.z + Math.cos(ang) * 1.3, dir: ang, speed: 9, dmg: this.dmg * 0.45, slow: 1.5, range: 16 });
          }
          g.audio.play('hiss');
        }
        if (a.t >= 1.8) done(1.3);
        break;
      }
      case 'meteor': {
        for (const m of a.targets) {
          if (!m.done && a.t >= m.t) {
            m.done = true;
            g.explosion(m.x, g.floorAt(m.x, m.z) + 0.3, m.z, 1.7, [1, 0.5, 0.1], true);
            if (Math.hypot(p.x - m.x, p.z - m.z) < 1.7 + p.r) p.hurt(this.dmg * 0.9, this);
          } else if (!m.done && a.t >= m.t - 0.5) {
            const k = (m.t - a.t) / 0.5;
            g.particles.add.emit(m.x + k * 3, g.floorAt(m.x, m.z) + k * 12, m.z + k * 3, -6, -24, -6, 0.1, 1.2, 0.8, 1, 0.5, 0.15, 1, 0, 0);
          }
        }
        if (a.t >= 3.2) done(1.5);
        break;
      }
      case 'summon': {
        if (Math.random() < 0.8) g.particles.add.emit(this.x + (Math.random() - 0.5) * 4, this.y + 0.1, this.z + (Math.random() - 0.5) * 4, 0, 3, 0, 0.7, 0.4, 0.05, 0.8, 0.3, 1, 1, 0, 0);
        if (!a.did && a.t >= 1.1) {
          a.did = 1;
          const n = this.B.summon === 'aranhinha' ? 5 : this.B.summon === 'esporo' ? 3 : 3;
          for (let i = 0; i < n; i++) g.spawnEnemyNear(this.x, this.z, this.B.summon, 3.5, true);
          g.audio.play('roar', 0.5);
        }
        if (a.t >= 1.6) done(1.2);
        break;
      }
    }
  }
  bossPose() {
    const r = this.rig, a = this.atk;
    if (!a) { if (r.body && this.type === 'veshkara') r.body.rotation.x = 0; return; }
    if (this.type === 'veshkara') {
      if (a.name === 'leap') r.body.rotation.x = a.t < 0.3 ? 0.2 : -0.3;
      else if (a.name === 'bite') r.body.rotation.x = a.t < 0.45 ? -0.4 : 0.25;
      else if (a.name === 'spit') r.body.rotation.x = -0.25 + Math.sin(a.t * 14) * 0.08;
      else if (a.name === 'summon') r.abdomen.rotation.x = Math.sin(a.t * 20) * 0.1;
      return;
    }
    if (a.name === 'slam') {
      const k = a.t < 1 ? ease(a.t) : 1 - ease((a.t - 1) * 5);
      r.armL.rotation.x = r.armR.rotation.x = -0.3 - k * 2.8;
      r.torso.rotation.x = a.t < 1 ? -0.25 * k : 0.45;
    } else if (a.name === 'swipe') {
      const k = a.t / 0.6;
      r.armR.rotation.x = -1.5; r.armR.rotation.z = 0.2;
      r.torso.rotation.y = k < 1 ? 1.0 * ease(k) : 1.0 - ease((a.t - 0.6) * 5) * 2.2;
    } else if (a.name === 'charge') {
      r.torso.rotation.x = 0.5; r.armL.rotation.x = r.armR.rotation.x = 0.6;
      r.head.rotation.x = -0.4;
    } else if (a.name === 'summon' || a.name === 'meteor') {
      r.armL.rotation.x = r.armR.rotation.x = -2.9; r.armL.rotation.z = -0.5; r.armR.rotation.z = 0.5;
    }
  }
}

function setTimeoutGame(g, delay, fn) {
  let t = 0;
  g.effects.push({ update(dt) { t += dt; if (t >= delay) { fn(); return false; } return true; } });
}

// =============================== PROJETEIS ===============================
const projGeo = {
  shaft: new THREE.BoxGeometry(0.035, 0.035, 0.7),
  tip: new THREE.ConeGeometry(0.05, 0.14, 4),
  orb: new THREE.SphereGeometry(0.16, 10, 8),
};
export class Projectile {
  constructor(game, o) {
    Object.assign(this, o);
    this.game = game; this.dead = false; this.hitSet = new Set(); this.dist = 0;
    this.vx = Math.sin(o.dir) * o.speed; this.vz = Math.cos(o.dir) * o.speed;
    const M = propMats();
    if (o.type === 'arrow') {
      this.mesh = new THREE.Group();
      const s = new THREE.Mesh(projGeo.shaft, M.wood); this.mesh.add(s);
      const t = new THREE.Mesh(projGeo.tip, M.iron); t.rotation.x = Math.PI / 2; t.position.z = 0.4; this.mesh.add(t);
      if (o.burn || o.explosive) this.trail = [1, 0.5, 0.15];
      else if (o.owner === 'player') this.trail = [0.9, 0.85, 0.7];
    } else {
      const col = o.type === 'bolt' ? 0xc050ff : o.type === 'web' ? 0xe8e8f0 : 0xff6a10;
      const mat = o.type === 'web' ? new THREE.MeshStandardMaterial({ color: col, roughness: 0.8, transparent: true, opacity: 0.9 }) : new THREE.MeshStandardMaterial({ color: col, emissive: col, emissiveIntensity: 4 });
      this.mesh = new THREE.Mesh(projGeo.orb, mat);
      this.trail = o.type === 'bolt' ? [0.7, 0.3, 1] : o.type === 'web' ? null : [1, 0.5, 0.1];
      if (o.type === 'bolt') this.light = game.addLight(o.x, o.y, o.z, 0xb050ff, 6, 5, 0.2, true);
    }
    this.mesh.position.set(o.x, o.y, o.z);
    this.mesh.rotation.y = o.dir;
    game.scene.add(this.mesh);
  }
  update(dt) {
    const g = this.game, p = g.player;
    if (this.homing && !p.dead) {
      const want = Math.atan2(p.x - this.x, p.z - this.z);
      this.dir = this.dir + clamp(angleDiff(this.dir, want), -this.homing * dt, this.homing * dt);
      this.vx = Math.sin(this.dir) * this.speed; this.vz = Math.cos(this.dir) * this.speed;
    }
    const steps = 2;
    for (let s = 0; s < steps && !this.dead; s++) {
      this.x += this.vx * dt / steps; this.z += this.vz * dt / steps;
      this.dist += this.speed * dt / steps;
      if (g.blocksProjectile(this.x, this.z, this.y)) {
        g.particles.sparks(this.x, this.y, this.z, 5, [1, 0.8, 0.5], 2);
        if (this.type === 'arrow') g.audio.play('arrowHit', 0.4);
        if (this.explosive) this.boom();
        this.kill(); return;
      }
      if (this.owner === 'player') {
        for (const e of g.enemies) {
          if (e.dead || this.hitSet.has(e)) continue;
          const hr = e.r + 0.25 + (e.isBoss ? 0.5 : 0);
          if (Math.hypot(e.x - this.x, e.z - this.z) < hr) {
            this.hitSet.add(e);
            const crit = Math.random() < 0.1;
            e.hurt(this.dmg * (crit ? 2 : 1), { crit, kx: this.vx * 0.12, kz: this.vz * 0.12, burn: this.burn });
            if (this.explosive) this.boom();
            if (this.pierce-- <= 0) { this.kill(); return; }
          }
        }
        for (const pot of g.pots) if (!pot.dead && Math.hypot(pot.x - this.x, pot.z - this.z) < 0.4) { pot.smash(); }
      } else if (!p.dead && Math.hypot(p.x - this.x, p.z - this.z) < p.r + 0.2) {
        if (p.hurt(this.dmg, null)) { if (this.slow) p.slowT = this.slow; this.kill(); return; }
      }
    }
    if (this.dist > this.range) { this.kill(); return; }
    this.mesh.position.set(this.x, this.y, this.z);
    this.mesh.rotation.y = this.dir;
    if (this.trail && Math.random() < 0.8) g.particles.add.emit(this.x, this.y, this.z, 0, 0, 0, 0.25, this.type === 'arrow' ? 0.1 : 0.35, 0.02, this.trail[0], this.trail[1], this.trail[2], 0.7, 0, 0);
    if (this.light) { this.light.x = this.x; this.light.y = this.y; this.light.z = this.z; }
  }
  boom() {
    const g = this.game;
    g.explosion(this.x, this.y, this.z, 1.8, [1, 0.6, 0.2], true, 0.35);
    for (const e of g.enemies) if (!e.dead && Math.hypot(e.x - this.x, e.z - this.z) < 1.8 + e.r) e.hurt(this.dmg * 0.6, { kx: (e.x - this.x) * 2, kz: (e.z - this.z) * 2, fire: true });
    this.explosive = false;
  }
  kill() {
    this.dead = true; this.game.scene.remove(this.mesh);
    if (this.mesh.material) this.mesh.material.dispose();
    if (this.light) this.game.removeLight(this.light);
  }
}

export { makeBannerMesh };
