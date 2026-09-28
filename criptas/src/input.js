// Entrada: teclado, mouse, toque (joystick virtual) e controle (gamepad).
import * as THREE from 'three';

const MAP = {
  up: ['KeyW', 'ArrowUp'], down: ['KeyS', 'ArrowDown'], left: ['KeyA', 'ArrowLeft'], right: ['KeyD', 'ArrowRight'],
  attack: ['M0', 'KeyJ'], shoot: ['M2', 'KeyK', 'KeyL'], roll: ['Space', 'ShiftLeft', 'ShiftRight'],
  potion: ['KeyQ', 'KeyH'], art1: ['Digit1', 'Numpad1'], art2: ['Digit2', 'Numpad2'], art3: ['Digit3', 'Numpad3'],
  interact: ['KeyE', 'KeyF', 'Enter'], pause: ['Escape', 'KeyP'], bag: ['KeyI', 'KeyB', 'Tab'], skip: ['Escape'], journal: ['KeyO'], store: ['KeyG'],
};
const PAD = { roll: [0], potion: [1], attack: [2, 5], interact: [3], shoot: [7], art1: [4], art2: [6], art3: [8], pause: [9] };

export class Input {
  constructor(canvas) {
    this.keys = new Set(); this.pressedSet = new Set(); this.consumed = new Set();
    this.mouseNdc = new THREE.Vector2(); this.mouseActive = false;
    this.zoom = 1; this.ax = 0; this.ay = 0; this.aim = null; this.aimStick = null;
    this.touch = { id: null, ox: 0, oy: 0, x: 0, y: 0 }; this.touchActions = new Set(); this.isTouch = false;
    this.padPrev = new Set();
    const down = (c) => { if (!this.keys.has(c)) this.pressedSet.add(c); this.keys.add(c); };
    const up = (c) => this.keys.delete(c);
    addEventListener('keydown', (e) => {
      if (e.code === 'Tab' || e.code === 'Space' || e.code.startsWith('Arrow')) e.preventDefault();
      if (!e.repeat) down(e.code);
    });
    addEventListener('keyup', (e) => up(e.code));
    addEventListener('blur', () => { this.keys.clear(); this.touchActions.clear(); });
    // no celular o navegador gera eventos de mouse "falsos" depois de cada toque: eles nao podem virar mira
    this.lastTouch = -1e9;
    const fromTouch = (e) => performance.now() - this.lastTouch < 1200 || (e.sourceCapabilities && e.sourceCapabilities.firesTouchEvents);
    try { if (matchMedia('(pointer: coarse)').matches && !matchMedia('(any-pointer: fine)').matches) this.isTouch = true; } catch (e) { /* ignora */ }
    addEventListener('touchstart', () => { this.isTouch = true; this.mouseActive = false; this.lastTouch = performance.now(); }, { capture: true, passive: true });
    addEventListener('touchend', () => { this.lastTouch = performance.now(); }, { capture: true, passive: true });
    canvas.addEventListener('mousedown', (e) => { if (fromTouch(e)) return; this.isTouch = false; this.mouseActive = true; down('M' + e.button); });
    addEventListener('mouseup', (e) => up('M' + e.button));
    addEventListener('mousemove', (e) => {
      if (fromTouch(e)) return;
      this.mouseNdc.set((e.clientX / innerWidth) * 2 - 1, -(e.clientY / innerHeight) * 2 + 1);
      if (!this.isTouch || Math.abs(e.movementX) + Math.abs(e.movementY) > 2) { this.isTouch = false; this.mouseActive = true; }
    });
    canvas.addEventListener('contextmenu', (e) => e.preventDefault());
    addEventListener('wheel', (e) => { this.zoom = Math.min(1.35, Math.max(0.7, this.zoom + Math.sign(e.deltaY) * 0.06)); }, { passive: true });
    // joystick virtual: metade esquerda da tela
    canvas.addEventListener('touchstart', (e) => {
      this.isTouch = true; this.mouseActive = false;
      for (const t of e.changedTouches) {
        if (t.clientX < innerWidth * 0.5 && this.touch.id === null) { this.touch = { id: t.identifier, ox: t.clientX, oy: t.clientY, x: t.clientX, y: t.clientY }; }
      }
      e.preventDefault();
    }, { passive: false });
    canvas.addEventListener('touchmove', (e) => {
      for (const t of e.changedTouches) if (t.identifier === this.touch.id) { this.touch.x = t.clientX; this.touch.y = t.clientY; }
      e.preventDefault();
    }, { passive: false });
    const end = (e) => { for (const t of e.changedTouches) if (t.identifier === this.touch.id) this.touch.id = null; };
    canvas.addEventListener('touchend', end); canvas.addEventListener('touchcancel', end);
  }
  setTouch(action, on) {
    if (on) { if (!this.touchActions.has(action)) this.pressedSet.add('T:' + action); this.touchActions.add(action); }
    else this.touchActions.delete(action);
  }
  codes(a) { return MAP[a] || []; }
  down(a) {
    if (this.touchActions.has(a)) return true;
    if (this.padDown && this.padDown.has(a)) return true;
    return this.codes(a).some(c => this.keys.has(c));
  }
  pressed(a) {
    if (this.consumed.has(a)) return false;
    if (this.pressedSet.has('T:' + a) || this.pressedSet.has('P:' + a)) return true;
    return this.codes(a).some(c => this.pressedSet.has(c));
  }
  consume(a) { this.consumed.add(a); }
  poll() {
    let ax = 0, ay = 0;
    if (this.down('left')) ax -= 1; if (this.down('right')) ax += 1;
    if (this.down('up')) ay += 1; if (this.down('down')) ay -= 1;
    if (this.touch.id !== null) {
      const dx = this.touch.x - this.touch.ox, dy = this.touch.y - this.touch.oy, R = 55;
      const l = Math.hypot(dx, dy);
      if (l > 8) { const k = Math.min(1, l / R) / l; ax += dx * k; ay -= dy * k; }
    }
    this.aimStick = null;
    this.padDown = new Set();
    let pads = [];
    try { pads = navigator.getGamepads ? navigator.getGamepads() : []; } catch (e) { pads = []; } // bloqueado em alguns frames
    for (const gp of pads) {
      if (!gp) continue;
      const dz = (v) => (Math.abs(v) < 0.18 ? 0 : v);
      ax += dz(gp.axes[0]); ay -= dz(gp.axes[1]);
      const rx = dz(gp.axes[2] || 0), ry = dz(gp.axes[3] || 0);
      if (Math.hypot(rx, ry) > 0.35) { this.aimStick = [rx, -ry]; this.mouseActive = false; }
      for (const [a, btns] of Object.entries(PAD)) {
        if (btns.some(b => gp.buttons[b] && gp.buttons[b].pressed)) {
          this.padDown.add(a);
          if (!this.padPrev.has(a)) this.pressedSet.add('P:' + a);
        }
      }
      if (gp.buttons[12] && gp.buttons[12].pressed) ay += 1;
      if (gp.buttons[13] && gp.buttons[13].pressed) ay -= 1;
      if (gp.buttons[14] && gp.buttons[14].pressed) ax -= 1;
      if (gp.buttons[15] && gp.buttons[15].pressed) ax += 1;
      if (this.padDown.size || Math.abs(gp.axes[0]) > 0.3 || Math.abs(gp.axes[1]) > 0.3) this.mouseActive = false;
      break;
    }
    this.padPrev = this.padDown;
    const l = Math.hypot(ax, ay);
    if (l > 1) { ax /= l; ay /= l; }
    this.ax = ax; this.ay = ay;
  }
  endFrame() { this.pressedSet.clear(); this.consumed.clear(); }
}
