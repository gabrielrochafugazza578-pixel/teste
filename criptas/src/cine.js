// Cutscenes: sequencias de tomadas de camera com barras de cinema, legendas e cartoes de nome.
import * as THREE from 'three';

const ss = (t) => t * t * (3 - 2 * t);
const V = (a) => new THREE.Vector3(a[0], a[1], a[2]);

export class Cine {
  // shot: { dur, from, to, lookFrom, lookTo, text, speaker, name, sub, black, flash, shake, onStart, onUpdate, toGame, slow }
  constructor(game, shots, opt = {}) {
    this.game = game; this.shots = shots; this.opt = opt;
    this.i = -1; this.t = 0; this.done = false;
    this.pos = new THREE.Vector3(); this.look = new THREE.Vector3();
    this.next();
  }
  next() {
    const g = this.game, cam = g.camera;
    this.i++; this.t = 0;
    const s = this.shots[this.i];
    if (!s) { this.finish(); return; }
    const first = this.i === 0;
    if (first) { const d = new THREE.Vector3(); cam.getWorldDirection(d); this.look.copy(cam.position).addScaledVector(d, 20); }
    if (s.toGame && !s.from) s.from = cam.position.toArray();
    s._from = V(s.from || cam.position.toArray()); s._to = V(s.to || s.from || cam.position.toArray());
    const lf = s.lookFrom || s.lookTo, lt = s.lookTo || s.lookFrom;
    s._lf = lf ? V(lf) : this.look.clone(); s._lt = lt ? V(lt) : this.look.clone();
    if (!s.from && !s.to) { s._from.copy(cam.position); s._to.copy(cam.position); }
    g.ui.cineShot(s);
    if (s.onStart) s.onStart();
  }
  update(dt) {
    if (this.done) return false;
    const s = this.shots[this.i], g = this.game;
    this.t += dt;
    const k = Math.min(1, this.t / s.dur), e = s.linear ? k : ss(k);
    if (s.toGame) { const p = g.gameCamPose(); s._to.copy(p.pos); s._lt.copy(p.look); }
    this.pos.lerpVectors(s._from, s._to, e);
    this.look.lerpVectors(s._lf, s._lt, e);
    if (s.orbit) { const a = s.orbit.a0 + (s.orbit.a1 - s.orbit.a0) * e, c = s.orbit.c; this.pos.set(c[0] + Math.cos(a) * s.orbit.r, c[1] + s.orbit.h, c[2] + Math.sin(a) * s.orbit.r); this.look.set(c[0], c[1] + (s.orbit.ly ?? 1), c[2]); }
    const sh = s.shake ? s.shake * (1 - k) : 0;
    g.camera.position.set(this.pos.x + (Math.random() - 0.5) * sh, this.pos.y + (Math.random() - 0.5) * sh, this.pos.z + (Math.random() - 0.5) * sh);
    g.camera.lookAt(this.look);
    g.camTarget.set(this.look.x, g.player.y, this.look.z);
    if (s.onUpdate) s.onUpdate(k, dt);
    if (k >= 1) this.next();
    return !this.done;
  }
  skip() { this.finish(); }
  finish() {
    if (this.done) return;
    this.done = true;
    this.game.ui.cineEnd();
    if (this.opt.onEnd) this.opt.onEnd();
  }
}
