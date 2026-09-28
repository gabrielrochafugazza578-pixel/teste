// Sistema de particulas em GPU (pontos): faiscas/fogo aditivos e poeira/sangue normais.
import * as THREE from 'three';
import { softDot } from './textures.js';

const VS = `
attribute float size; attribute vec4 pcolor;
varying vec4 vColor;
uniform float uScale;
void main(){
  vColor = pcolor;
  vec4 mv = modelViewMatrix * vec4(position, 1.0);
  gl_PointSize = size * uScale / -mv.z;
  gl_Position = projectionMatrix * mv;
}`;
const FS = `
uniform sampler2D map; varying vec4 vColor;
void main(){
  vec4 t = texture2D(map, gl_PointCoord);
  gl_FragColor = vec4(vColor.rgb, vColor.a * t.a);
  if (gl_FragColor.a < 0.004) discard;
}`;

class Pool {
  constructor(max, additive, tex) {
    this.max = max; this.n = 0;
    this.p = new Float32Array(max * 3); this.v = new Float32Array(max * 3);
    this.c = new Float32Array(max * 4); this.s = new Float32Array(max);
    this.life = new Float32Array(max); this.maxLife = new Float32Array(max);
    this.size0 = new Float32Array(max); this.size1 = new Float32Array(max);
    this.grav = new Float32Array(max); this.drag = new Float32Array(max);
    this.col0 = new Float32Array(max * 4);
    const g = new THREE.BufferGeometry();
    this.aPos = new THREE.BufferAttribute(this.p, 3); this.aPos.setUsage(THREE.DynamicDrawUsage);
    this.aCol = new THREE.BufferAttribute(this.c, 4); this.aCol.setUsage(THREE.DynamicDrawUsage);
    this.aSize = new THREE.BufferAttribute(this.s, 1); this.aSize.setUsage(THREE.DynamicDrawUsage);
    g.setAttribute('position', this.aPos); g.setAttribute('pcolor', this.aCol); g.setAttribute('size', this.aSize);
    g.boundingSphere = new THREE.Sphere(new THREE.Vector3(), 1e5);
    this.uniforms = { map: { value: tex }, uScale: { value: 400 } };
    const mat = new THREE.ShaderMaterial({
      uniforms: this.uniforms, vertexShader: VS, fragmentShader: FS, transparent: true, depthWrite: false,
      blending: additive ? THREE.AdditiveBlending : THREE.NormalBlending,
    });
    this.points = new THREE.Points(g, mat);
    this.points.frustumCulled = false;
    this.points.renderOrder = 5;
    g.setDrawRange(0, 0);
  }
  emit(x, y, z, vx, vy, vz, life, size0, size1, r, g, b, a, grav = 0, drag = 0) {
    let i = this.n;
    if (i >= this.max) { i = Math.floor(Math.random() * this.max); } else this.n++;
    this.p[i * 3] = x; this.p[i * 3 + 1] = y; this.p[i * 3 + 2] = z;
    this.v[i * 3] = vx; this.v[i * 3 + 1] = vy; this.v[i * 3 + 2] = vz;
    this.life[i] = life; this.maxLife[i] = life; this.size0[i] = size0; this.size1[i] = size1;
    this.col0[i * 4] = r; this.col0[i * 4 + 1] = g; this.col0[i * 4 + 2] = b; this.col0[i * 4 + 3] = a;
    this.grav[i] = grav; this.drag[i] = drag;
  }
  update(dt) {
    let i = 0;
    while (i < this.n) {
      this.life[i] -= dt;
      if (this.life[i] <= 0) { this.copy(this.n - 1, i); this.n--; continue; }
      const k = 1 - this.life[i] / this.maxLife[i];
      const dr = Math.exp(-this.drag[i] * dt);
      this.v[i * 3] *= dr; this.v[i * 3 + 2] *= dr; this.v[i * 3 + 1] = this.v[i * 3 + 1] * dr - this.grav[i] * dt;
      this.p[i * 3] += this.v[i * 3] * dt; this.p[i * 3 + 1] += this.v[i * 3 + 1] * dt; this.p[i * 3 + 2] += this.v[i * 3 + 2] * dt;
      if (this.p[i * 3 + 1] < -0.95 && this.grav[i] > 0) { this.p[i * 3 + 1] = -0.95; this.v[i * 3 + 1] *= -0.3; }
      this.s[i] = this.size0[i] + (this.size1[i] - this.size0[i]) * k;
      const fade = k < 0.1 ? k / 0.1 : 1 - (k - 0.1) / 0.9;
      this.c[i * 4] = this.col0[i * 4]; this.c[i * 4 + 1] = this.col0[i * 4 + 1]; this.c[i * 4 + 2] = this.col0[i * 4 + 2];
      this.c[i * 4 + 3] = this.col0[i * 4 + 3] * fade;
      i++;
    }
    const g = this.points.geometry;
    g.setDrawRange(0, this.n);
    this.aPos.needsUpdate = true; this.aCol.needsUpdate = true; this.aSize.needsUpdate = true;
  }
  copy(from, to) {
    if (from === to) return;
    for (let k = 0; k < 3; k++) { this.p[to * 3 + k] = this.p[from * 3 + k]; this.v[to * 3 + k] = this.v[from * 3 + k]; }
    for (let k = 0; k < 4; k++) { this.c[to * 4 + k] = this.c[from * 4 + k]; this.col0[to * 4 + k] = this.col0[from * 4 + k]; }
    this.s[to] = this.s[from]; this.life[to] = this.life[from]; this.maxLife[to] = this.maxLife[from];
    this.size0[to] = this.size0[from]; this.size1[to] = this.size1[from]; this.grav[to] = this.grav[from]; this.drag[to] = this.drag[from];
  }
  clear() { this.n = 0; this.points.geometry.setDrawRange(0, 0); }
}

export class Particles {
  constructor(scene) {
    const tex = softDot();
    this.add = new Pool(3000, true, tex);
    this.norm = new Pool(2000, false, tex);
    scene.add(this.add.points); scene.add(this.norm.points);
  }
  setScale(s) { this.add.uniforms.uScale.value = s; this.norm.uniforms.uScale.value = s; }
  update(dt) { this.add.update(dt); this.norm.update(dt); }
  clear() { this.add.clear(); this.norm.clear(); }
  attach(scene) { scene.add(this.add.points); scene.add(this.norm.points); }

  sparks(x, y, z, n = 10, col = [1, 0.7, 0.3], speed = 5) {
    for (let i = 0; i < n; i++) {
      const a = Math.random() * Math.PI * 2, e = Math.random() * 0.8 + 0.2, s = speed * (0.4 + Math.random());
      this.add.emit(x, y, z, Math.cos(a) * s * (1 - e * 0.5), e * s, Math.sin(a) * s * (1 - e * 0.5), 0.3 + Math.random() * 0.4, 0.12, 0.02, col[0], col[1], col[2], 1, 12, 2);
    }
  }
  blood(x, y, z, n = 8, col = [0.35, 0.05, 0.04]) {
    for (let i = 0; i < n; i++) {
      const a = Math.random() * Math.PI * 2, s = 1 + Math.random() * 3;
      this.norm.emit(x, y, z, Math.cos(a) * s, 1 + Math.random() * 3, Math.sin(a) * s, 0.5 + Math.random() * 0.5, 0.14, 0.08, col[0], col[1], col[2], 1, 12, 1);
    }
  }
  dust(x, y, z, n = 10, col = [0.45, 0.42, 0.38], r = 0.5, up = 1) {
    for (let i = 0; i < n; i++) {
      const a = Math.random() * Math.PI * 2, s = Math.random() * 1.5 * r;
      this.norm.emit(x + Math.cos(a) * r * 0.5, y, z + Math.sin(a) * r * 0.5, Math.cos(a) * s, Math.random() * up, Math.sin(a) * s, 0.8 + Math.random() * 0.8, 0.3, 0.9, col[0], col[1], col[2], 0.35, -0.2, 2);
    }
  }
  fire(x, y, z, n = 1, spread = 0.1, col = [1, 0.5, 0.15], size = 0.5) {
    for (let i = 0; i < n; i++)
      this.add.emit(x + (Math.random() - 0.5) * spread, y, z + (Math.random() - 0.5) * spread, (Math.random() - 0.5) * 0.3, 0.8 + Math.random() * 1.2, (Math.random() - 0.5) * 0.3, 0.35 + Math.random() * 0.4, size, 0.05, col[0], col[1], col[2], 0.6, -0.5, 1);
  }
  ember(x, y, z, col = [1, 0.55, 0.2]) {
    this.add.emit(x, y, z, (Math.random() - 0.5) * 0.4, 0.6 + Math.random() * 0.8, (Math.random() - 0.5) * 0.4, 1.2 + Math.random() * 1.5, 0.06, 0.02, col[0], col[1], col[2], 1, -0.1, 0.5);
  }
  ring(x, y, z, radius, n, col, speed = 4, size = 0.3) {
    for (let i = 0; i < n; i++) {
      const a = (i / n) * Math.PI * 2;
      this.add.emit(x + Math.cos(a) * radius * 0.2, y, z + Math.sin(a) * radius * 0.2, Math.cos(a) * speed, 0.3 + Math.random() * 0.5, Math.sin(a) * speed, radius / speed, size, size * 0.3, col[0], col[1], col[2], 1, 0, 0);
    }
  }
  burst(x, y, z, n, col, speed = 3, life = 0.6, size = 0.25, grav = 0) {
    for (let i = 0; i < n; i++) {
      const a = Math.random() * Math.PI * 2, b = Math.random() * Math.PI - Math.PI / 2, s = speed * (0.3 + Math.random() * 0.7);
      this.add.emit(x, y, z, Math.cos(a) * Math.cos(b) * s, Math.sin(b) * s + 1, Math.sin(a) * Math.cos(b) * s, life * (0.6 + Math.random() * 0.6), size, size * 0.1, col[0], col[1], col[2], 1, grav, 1.5);
    }
  }
  mote(x, y, z) { // poeira flutuando no ar
    this.norm.emit(x, y, z, (Math.random() - 0.5) * 0.15, (Math.random() - 0.3) * 0.1, (Math.random() - 0.5) * 0.15, 4 + Math.random() * 4, 0.05, 0.05, 0.8, 0.75, 0.65, 0.35, 0, 0);
  }
}
