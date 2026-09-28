// Reflexos: espelho planar do chao (pocas d'agua, gelo e pisos polidos refletem a cena, com
// desfoque pela rugosidade e fresnel) e mapa de ambiente dinamico capturado junto ao heroi.
import * as THREE from 'three';

export const MIRROR = {
  tMirror: { value: null },
  uMirrorMat: { value: new THREE.Matrix4() },
  uMirrorOn: { value: 0 },
  uPlaneY: { value: 0 },
  uWet: { value: 0.35 },
  uGloss: { value: 0 },
  uTime: { value: 0 },
  uRes: { value: new THREE.Vector2(1, 1) },
};

const NOISE = `
float mh(vec2 p){ return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float mn(vec2 p){ vec2 i = floor(p), f = fract(p); f = f * f * (3.0 - 2.0 * f);
  return mix(mix(mh(i), mh(i + vec2(1, 0)), f.x), mix(mh(i + vec2(0, 1)), mh(i + vec2(1, 1)), f.x), f.y); }
float puddle(vec2 p){ return mn(p * 0.23) * 0.62 + mn(p * 0.71 + 7.3) * 0.28 + mn(p * 2.3) * 0.1; }
`;

// injeta o reflexo em um MeshStandardMaterial (chao do mundo ou agua)
export function patchMirror(mat, opts = {}) {
  const water = !!opts.water;
  mat.onBeforeCompile = (sh) => {
    Object.assign(sh.uniforms, MIRROR);
    sh.vertexShader = sh.vertexShader
      .replace('#include <common>', '#include <common>\nvarying vec3 vWPos; varying vec3 vWNor;')
      .replace('#include <project_vertex>', '#include <project_vertex>\nvWPos = (modelMatrix * vec4(transformed, 1.0)).xyz; vWNor = normalize(mat3(modelMatrix) * objectNormal);');
    sh.fragmentShader = sh.fragmentShader
      .replace('#include <common>', `#include <common>
varying vec3 vWPos; varying vec3 vWNor;
uniform sampler2D tMirror; uniform mat4 uMirrorMat; uniform float uMirrorOn, uPlaneY, uWet, uGloss, uTime;
${NOISE}`)
      .replace('#include <roughnessmap_fragment>', `#include <roughnessmap_fragment>
float mTop = smoothstep(0.8, 0.95, vWNor.y) * (1.0 - smoothstep(0.03, 0.14, abs(vWPos.y - uPlaneY)));
float mWet = ${water ? '1.0' : 'mTop * smoothstep(1.0 - uWet, 1.0 - uWet + 0.07, puddle(vWPos.xz))'};
float mGloss = ${water ? '1.0' : 'mTop * uGloss'};
roughnessFactor = mix(roughnessFactor, ${water ? '0.04' : '0.05'}, max(mWet, mGloss * 0.85));`)
      .replace('#include <lights_fragment_end>', `#include <lights_fragment_end>
{
  float mStr = max(mWet, mGloss) * uMirrorOn;
  if (mStr > 0.001) {
    vec4 mp = uMirrorMat * vec4(vWPos, 1.0);
    vec2 ripple = ${water ? 'vec2(mn(vWPos.xz * 3.0 + uTime * 0.8) - 0.5, mn(vWPos.zx * 3.0 - uTime * 0.7) - 0.5) * 0.035' : 'vec2(mn(vWPos.xz * 6.0 + uTime * 0.3) - 0.5, mn(vWPos.zx * 6.0) - 0.5) * 0.006 * mWet'};
    vec2 muv = mp.xy / mp.w + normal.xy * ${water ? '0.02' : '0.012'} + ripple;
    float lod = mix(4.5, 0.0, max(mWet, mGloss * (1.0 - roughnessFactor)));
    vec4 rs = textureLod(tMirror, clamp(muv, 0.001, 0.999), lod);
    vec3 refl = rs.rgb / max(rs.a, 0.001);
    vec3 vd = normalize(vViewPosition);
    float fr = 0.04 + 0.96 * pow(1.0 - clamp(dot(normal, vd), 0.0, 1.0), 5.0);
    float k = mStr * mix(${water ? '0.55' : '0.42'}, 1.0, fr) * smoothstep(0.0, 0.6, rs.a);
    reflectedLight.indirectSpecular = mix(reflectedLight.indirectSpecular, refl, k);
    reflectedLight.directDiffuse *= 1.0 - mWet * ${water ? '0.0' : '0.45'};
    reflectedLight.indirectDiffuse *= 1.0 - mWet * ${water ? '0.0' : '0.5'};
  }
}`);
  };
  mat.customProgramCacheKey = () => (water ? 'mirror-water' : 'mirror-floor');
  mat.needsUpdate = true;
  return mat;
}

export class Mirror {
  constructor(renderer) {
    this.renderer = renderer;
    this.cam = new THREE.PerspectiveCamera();
    this.cam.layers.set(0);
    this.rt = null; this.scale = 0.5; this.enabled = false;
    this._v = new THREE.Vector3(); this._t = new THREE.Vector3(); this._p = new THREE.Plane(); this._up = new THREE.Vector3(0, 1, 0); this._planes = [this._p]; this._none = []; this._m3 = new THREE.Matrix3(); this._cc = new THREE.Color();
  }
  setup(enabled, scale) {
    this.enabled = enabled; this.scale = scale;
    MIRROR.uMirrorOn.value = enabled ? 1 : 0;
    this.resize();
  }
  resize() {
    if (!this.enabled) { if (this.rt) { this.rt.dispose(); this.rt = null; } MIRROR.tMirror.value = null; return; }
    const pr = this.renderer.getPixelRatio();
    const w = Math.max(64, Math.round(innerWidth * pr * this.scale)), h = Math.max(64, Math.round(innerHeight * pr * this.scale));
    if (this.rt && this.rt.width === w && this.rt.height === h) return;
    if (this.rt) this.rt.dispose();
    this.rt = new THREE.WebGLRenderTarget(w, h, { type: THREE.HalfFloatType, generateMipmaps: true, minFilter: THREE.LinearMipmapLinearFilter, magFilter: THREE.LinearFilter, samples: 0 });
    MIRROR.tMirror.value = this.rt.texture;
  }
  render(scene, camera, planeY = 0) {
    if (!this.enabled || !this.rt) return;
    const r = this.renderer, cam = this.cam;
    camera.updateMatrixWorld();
    const cp = this._v.setFromMatrixPosition(camera.matrixWorld);
    const look = this._t.set(0, 0, -1).applyMatrix3(this._m3.setFromMatrix4(camera.matrixWorld)).add(cp);
    cam.position.set(cp.x, 2 * planeY - cp.y, cp.z);
    cam.up.set(0, 1, 0).applyQuaternion(camera.quaternion);
    cam.up.y = -cam.up.y;
    cam.lookAt(look.x, 2 * planeY - look.y, look.z);
    cam.far = camera.far; cam.near = camera.near;
    cam.updateMatrixWorld();
    cam.projectionMatrix.copy(camera.projectionMatrix);
    MIRROR.uMirrorMat.value.set(0.5, 0, 0, 0.5, 0, 0.5, 0, 0.5, 0, 0, 0.5, 0.5, 0, 0, 0, 1)
      .multiply(cam.projectionMatrix).multiply(cam.matrixWorldInverse);
    MIRROR.uPlaneY.value = planeY;
    // corte por plano de recorte global: mantem o recorte de visao da camera (a projecao obliqua o desfazia)
    this._p.set(this._up, -(planeY + 0.02));
    const on = MIRROR.uMirrorOn.value;
    MIRROR.uMirrorOn.value = 0; // o chao nao reflete a si mesmo dentro do reflexo
    MIRROR.tMirror.value = null; // evita ler a textura em que se esta desenhando
    const bg = scene.background, cc = r.getClearColor(this._cc), ca = r.getClearAlpha();
    scene.background = null;
    r.setClearColor(0x000000, 0);
    r.setRenderTarget(this.rt);
    r.clear();
    r.clippingPlanes = this._planes;
    r.render(scene, cam);
    r.clippingPlanes = this._none;
    r.setRenderTarget(null);
    r.setClearColor(cc, ca);
    scene.background = bg;
    MIRROR.tMirror.value = this.rt.texture;
    MIRROR.uMirrorOn.value = on;
  }
}

// mapa de ambiente dinamico (reflexos locais em metais, gelo, olhos)
export class LiveEnv {
  constructor(renderer, size = 128) {
    this.renderer = renderer;
    this.rt = new THREE.WebGLCubeRenderTarget(size, { type: THREE.HalfFloatType, generateMipmaps: true, minFilter: THREE.LinearMipmapLinearFilter });
    this.cam = new THREE.CubeCamera(0.3, 24, this.rt);
    this.cam.layers.set(0);
    this.every = 4; this.n = 0; this.enabled = true;
  }
  get texture() { return this.rt.texture; }
  update(scene, x, y, z, hide) {
    if (!this.enabled) return;
    if (this.n++ % this.every) return;
    const was = hide ? hide.visible : true;
    if (hide) hide.visible = false;
    const on = MIRROR.uMirrorOn.value; MIRROR.uMirrorOn.value = 0;
    this.cam.position.set(x, y, z);
    this.cam.update(this.renderer, scene);
    MIRROR.uMirrorOn.value = on;
    if (hide) hide.visible = was;
  }
}
