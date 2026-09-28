// Sintetizador de efeitos e trilha ambiente (Web Audio), sem arquivos externos.
export class Audio {
  constructor() { this.ctx = null; this.muted = false; this.vol = 0.8; }
  init() {
    if (this.ctx) { if (this.ctx.state === 'suspended') this.ctx.resume(); return; }
    try { this.ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { return; }
    const c = this.ctx;
    this.master = c.createGain(); this.master.gain.value = this.vol;
    const comp = c.createDynamicsCompressor(); comp.threshold.value = -14; comp.ratio.value = 4;
    this.master.connect(comp); comp.connect(c.destination);
    this.sfx = c.createGain(); this.sfx.gain.value = 0.9; this.sfx.connect(this.master);
    this.music = c.createGain(); this.music.gain.value = 0.35; this.music.connect(this.master);
    // reverb simples (convolucao com ruido decaindo)
    this.rev = c.createConvolver();
    const len = c.sampleRate * 2.2, buf = c.createBuffer(2, len, c.sampleRate);
    for (let ch = 0; ch < 2; ch++) { const d = buf.getChannelData(ch); for (let i = 0; i < len; i++) d[i] = (Math.random() * 2 - 1) * Math.pow(1 - i / len, 3); }
    this.rev.buffer = buf;
    const rg = c.createGain(); rg.gain.value = 0.35; this.rev.connect(rg); rg.connect(this.master);
    this.noise = c.createBuffer(1, c.sampleRate, c.sampleRate);
    const nd = this.noise.getChannelData(0); for (let i = 0; i < nd.length; i++) nd[i] = Math.random() * 2 - 1;
    this.startAmbient();
  }
  setMuted(m) { this.muted = m; if (this.master) this.master.gain.value = m ? 0 : this.vol; }
  get t() { return this.ctx.currentTime; }
  ok() { return this.ctx && !this.muted; }

  env(g, t, a, peak, d) { g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(peak, t + a); g.gain.exponentialRampToValueAtTime(0.0001, t + a + d); }
  osc(type, f0, f1, dur, vol, dest, delay = 0, revAmt = 0.2) {
    const c = this.ctx, t = this.t + delay;
    const o = c.createOscillator(), g = c.createGain();
    o.type = type; o.frequency.setValueAtTime(f0, t); if (f1 !== f0) o.frequency.exponentialRampToValueAtTime(Math.max(1, f1), t + dur);
    this.env(g, t, 0.005, vol, dur);
    o.connect(g); g.connect(dest || this.sfx);
    if (revAmt) { const r = c.createGain(); r.gain.value = revAmt; g.connect(r); r.connect(this.rev); }
    o.start(t); o.stop(t + dur + 0.05);
  }
  nz(dur, vol, type, f0, f1, q = 1, delay = 0, revAmt = 0.25) {
    const c = this.ctx, t = this.t + delay;
    const s = c.createBufferSource(); s.buffer = this.noise; s.loop = true;
    const f = c.createBiquadFilter(); f.type = type; f.Q.value = q;
    f.frequency.setValueAtTime(f0, t); f.frequency.exponentialRampToValueAtTime(Math.max(20, f1), t + dur);
    const g = c.createGain(); this.env(g, t, 0.004, vol, dur);
    s.connect(f); f.connect(g); g.connect(this.sfx);
    if (revAmt) { const r = c.createGain(); r.gain.value = revAmt; g.connect(r); r.connect(this.rev); }
    s.start(t, Math.random() * 0.5); s.stop(t + dur + 0.05);
  }
  play(name, v = 1) {
    if (!this.ok()) return;
    const r = () => 0.9 + Math.random() * 0.2;
    switch (name) {
      case 'swing': this.nz(0.16, 0.35 * v, 'bandpass', 900 * r(), 3500, 1.5); break;
      case 'swingHeavy': this.nz(0.3, 0.45 * v, 'bandpass', 400 * r(), 1500, 1.2); break;
      case 'hit': this.osc('sine', 180 * r(), 60, 0.12, 0.5 * v); this.nz(0.08, 0.35 * v, 'lowpass', 3000, 400); break;
      case 'crit': this.osc('square', 900, 300, 0.1, 0.12 * v); this.osc('sine', 200, 50, 0.2, 0.6 * v); this.nz(0.12, 0.4 * v, 'highpass', 2000, 800); break;
      case 'boneHit': this.nz(0.07, 0.4 * v, 'bandpass', 2500 * r(), 1200, 4); this.osc('triangle', 500 * r(), 200, 0.06, 0.2 * v); break;
      case 'bow': this.osc('triangle', 260 * r(), 90, 0.12, 0.25 * v); this.nz(0.14, 0.15 * v, 'highpass', 3000, 6000); break;
      case 'arrowHit': this.nz(0.05, 0.3 * v, 'bandpass', 1800, 900, 3); break;
      case 'hurt': this.osc('sawtooth', 220, 110, 0.18, 0.18 * v); this.nz(0.15, 0.3 * v, 'lowpass', 1500, 300); break;
      case 'roll': this.nz(0.25, 0.25 * v, 'bandpass', 500, 1400, 0.8); break;
      case 'plantHit': this.nz(0.09, 0.4 * v, 'bandpass', 700 * r(), 300, 2); this.osc('triangle', 160 * r(), 80, 0.1, 0.3 * v); break;
      case 'squish': this.nz(0.14, 0.35 * v, 'lowpass', 1200 * r(), 200, 3); this.osc('sine', 300 * r(), 90, 0.12, 0.25 * v); break;
      case 'glass': this.osc('sine', 2200 * r(), 1800, 0.18, 0.1 * v, null, 0, 0.5); this.osc('sine', 3300 * r(), 2600, 0.12, 0.06 * v, null, 0.02, 0.5); this.nz(0.06, 0.2 * v, 'highpass', 4000, 6000); break;
      case 'shell': this.nz(0.08, 0.45 * v, 'bandpass', 1400 * r(), 700, 5); this.osc('square', 220 * r(), 120, 0.06, 0.08 * v); break;
      case 'thorn': this.nz(0.1, 0.25 * v, 'highpass', 2500, 5000); this.osc('triangle', 500 * r(), 250, 0.08, 0.12 * v); break;
      case 'anvil': this.osc('sine', 880, 870, 0.8, 0.25 * v, null, 0, 0.5); this.osc('sine', 1320, 1300, 0.6, 0.12 * v, null, 0, 0.5); this.osc('sine', 2210, 2200, 0.4, 0.06 * v, null, 0, 0.5); this.nz(0.05, 0.4 * v, 'highpass', 3000, 5000); break;
      case 'coin': this.osc('sine', 1800 * r(), 1800, 0.06, 0.12 * v, null, 0, 0.3); this.osc('sine', 2400 * r(), 2400, 0.12, 0.1 * v, null, 0.05, 0.3); break;
      case 'pickup': this.osc('triangle', 520, 520, 0.1, 0.2 * v); this.osc('triangle', 780, 780, 0.2, 0.2 * v, null, 0.08); break;
      case 'potion': for (let i = 0; i < 5; i++) this.osc('sine', 300 + Math.random() * 500, 800, 0.08, 0.15 * v, null, i * 0.06); break;
      case 'die': this.osc('sawtooth', 160 * r(), 40, 0.45, 0.15 * v); this.nz(0.3, 0.2 * v, 'lowpass', 900, 100); break;
      case 'explode': this.nz(0.9, 0.9 * v, 'lowpass', 1800, 60, 0.7); this.osc('sine', 90, 30, 0.6, 0.8 * v); break;
      case 'fire': this.nz(0.7, 0.5 * v, 'lowpass', 400, 2400, 0.7); this.osc('sawtooth', 80, 160, 0.5, 0.1 * v); break;
      case 'zap': for (let i = 0; i < 6; i++) this.nz(0.05, 0.4 * v, 'highpass', 3000 + Math.random() * 3000, 1500, 1, i * 0.035); this.osc('square', 120, 60, 0.3, 0.12 * v); break;
      case 'freeze': this.osc('sine', 2000, 900, 0.5, 0.12 * v); this.nz(0.6, 0.25 * v, 'highpass', 5000, 2500); break;
      case 'wind': this.nz(0.7, 0.5 * v, 'bandpass', 300, 1400, 0.6); break;
      case 'chest': this.osc('triangle', 150, 120, 0.3, 0.3 * v); this.nz(0.4, 0.15 * v, 'bandpass', 700, 300, 3); [660, 880, 1100, 1320].forEach((f, i) => this.osc('sine', f, f, 0.3, 0.1 * v, null, 0.25 + i * 0.07, 0.5)); break;
      case 'pot': this.nz(0.2, 0.5 * v, 'bandpass', 1500, 600, 1.5); this.osc('triangle', 700 * r(), 300, 0.1, 0.2 * v); break;
      case 'brazier': this.nz(1.2, 0.6 * v, 'lowpass', 300, 3000, 0.6); [220, 330, 440].forEach((f, i) => this.osc('sine', f, f, 1.2, 0.1 * v, null, i * 0.1, 0.6)); break;
      case 'gate': this.nz(1.4, 0.5 * v, 'lowpass', 200, 90, 1); for (let i = 0; i < 8; i++) this.osc('square', 60 + Math.random() * 20, 50, 0.06, 0.1 * v, null, i * 0.15); break;
      case 'levelup': [392, 523, 659, 784, 1046].forEach((f, i) => this.osc('triangle', f, f, 0.35, 0.18 * v, null, i * 0.09, 0.5)); break;
      case 'roar': this.osc('sawtooth', 90, 50, 1.4, 0.3 * v); this.osc('sawtooth', 93, 48, 1.4, 0.3 * v); this.nz(1.3, 0.5 * v, 'lowpass', 600, 150, 0.6); break;
      case 'slam': this.osc('sine', 70, 25, 0.7, 1 * v); this.nz(0.6, 0.7 * v, 'lowpass', 800, 60); break;
      case 'summon': this.osc('sine', 200, 600, 0.6, 0.15 * v, null, 0, 0.8); this.osc('sine', 300, 900, 0.6, 0.1 * v, null, 0.1, 0.8); break;
      case 'bolt': this.osc('sine', 700, 200, 0.3, 0.15 * v); this.nz(0.25, 0.15 * v, 'bandpass', 1200, 400, 3); break;
      case 'fuse': for (let i = 0; i < 6; i++) this.osc('square', 500 + i * 120, 500 + i * 120, 0.05, 0.08 * v, null, i * 0.18); break;
      case 'hiss': this.nz(0.35, 0.3 * v, 'highpass', 4000, 2000, 1); break;
      case 'portal': this.osc('sine', 110, 440, 1.5, 0.2 * v, null, 0, 0.8); this.osc('sine', 165, 660, 1.5, 0.15 * v, null, 0.2, 0.8); break;
      case 'step': this.nz(0.05, 0.05 * v, 'lowpass', 600 * r(), 200, 1, 0, 0.05); break;
      case 'deny': this.osc('square', 180, 150, 0.15, 0.1 * v); break;
      case 'banner': [262, 330, 392].forEach((f, i) => this.osc('sawtooth', f, f, 0.5, 0.08 * v, null, i * 0.05, 0.4)); break;
    }
  }

  // ------ trilha ambiente: drone + acordes lentos + gotas ------
  startAmbient() {
    const c = this.ctx;
    const lp = c.createBiquadFilter(); lp.type = 'lowpass'; lp.frequency.value = 500; lp.connect(this.music);
    const lfo = c.createOscillator(), lg = c.createGain(); lfo.frequency.value = 0.07; lg.gain.value = 200; lfo.connect(lg); lg.connect(lp.frequency); lfo.start();
    this.drone = [];
    for (const f of [55, 55.4, 82.4]) { const o = c.createOscillator(); o.type = 'sawtooth'; o.frequency.value = f; const g = c.createGain(); g.gain.value = 0.08; o.connect(g); g.connect(lp); o.start(); this.drone.push(o); }
    this.padBus = c.createGain(); this.padBus.gain.value = 0.6; this.padBus.connect(lp);
    const rgain = c.createGain(); rgain.gain.value = 0.5; this.padBus.connect(rgain); rgain.connect(this.rev);
    this.chords = [[220, 261.6, 329.6], [174.6, 220, 261.6], [196, 246.9, 293.7], [164.8, 196, 246.9]];
    this.chordI = 0; this.nextChord = 0; this.nextDrip = 2;
    this.bossMode = false; this.beat = 0; this.nextBeat = 0;
  }
  setBoss(on) { this.bossMode = on; }
  update() {
    if (!this.ctx || this.muted) return;
    const t = this.t;
    if (t > this.nextChord) {
      const ch = this.chords[this.chordI++ % this.chords.length];
      for (const f of ch) {
        const o = this.ctx.createOscillator(), g = this.ctx.createGain();
        o.type = 'triangle'; o.frequency.value = f * (this.bossMode ? 0.5 : 1);
        g.gain.setValueAtTime(0.0001, t); g.gain.exponentialRampToValueAtTime(0.06, t + 2.5); g.gain.exponentialRampToValueAtTime(0.0001, t + 8.5);
        o.connect(g); g.connect(this.padBus); o.start(t); o.stop(t + 9);
      }
      this.nextChord = t + 8;
    }
    if (t > this.nextDrip && !this.bossMode) {
      this.osc('sine', 1200 + Math.random() * 900, 700, 0.12, 0.05, this.music, 0, 1);
      this.nextDrip = t + 2 + Math.random() * 6;
    }
    if (this.bossMode && t > this.nextBeat) {
      const b = this.beat++ % 8;
      if (b === 0 || b === 3 || b === 5) this.osc('sine', 80, 35, 0.35, 0.5, this.music, 0, 0.3);
      if (b === 4) this.nz(0.2, 0.25, 'bandpass', 1200, 500, 1);
      if (b % 2 === 1) this.nz(0.04, 0.06, 'highpass', 7000, 6000, 1, 0, 0);
      this.nextBeat = t + 0.22;
    }
  }
}
