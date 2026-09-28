// Ponto de entrada: renderizador, pos-processamento, qualidade grafica e laco principal.
import * as THREE from 'three';
import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js';
import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/examples/jsm/postprocessing/UnrealBloomPass.js';
import { OutputPass } from 'three/examples/jsm/postprocessing/OutputPass.js';
import { ShaderPass } from 'three/examples/jsm/postprocessing/ShaderPass.js';
import { RoomEnvironment } from 'three/examples/jsm/environments/RoomEnvironment.js';
import { Game } from './game.js';
import { UI } from './ui.js';
import { Input } from './input.js';
import { Audio } from './audio.js';

const GradeShader = {
  uniforms: { tDiffuse: { value: null }, uTime: { value: 0 } },
  vertexShader: 'varying vec2 vUv; void main(){ vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }',
  fragmentShader: `
    uniform sampler2D tDiffuse; uniform float uTime; varying vec2 vUv;
    float rnd(vec2 p){ return fract(sin(dot(p, vec2(12.9898,78.233)) + uTime) * 43758.5453); }
    void main(){
      vec3 c = texture2D(tDiffuse, vUv).rgb;
      float l = dot(c, vec3(0.299,0.587,0.114));
      c = mix(vec3(l), c, 1.08);                                   // saturacao
      c = mix(c * vec3(0.92,0.98,1.06), c * vec3(1.05,1.0,0.94), smoothstep(0.1,0.6,l)); // sombras frias, luzes quentes
      float v = smoothstep(0.95, 0.3, length((vUv - 0.5) * vec2(1.25, 1.0)));
      c *= mix(0.42, 1.0, v);
      c += (rnd(vUv * 731.0) - 0.5) * 0.018;
      gl_FragColor = vec4(c, 1.0);
    }`,
};

const canvas = document.getElementById('c');
const renderer = new THREE.WebGLRenderer({ canvas, antialias: false, powerPreference: 'high-performance' });
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFShadowMap;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1.2;
renderer.outputColorSpace = THREE.SRGBColorSpace;

const input = new Input(canvas);
const ui = new UI(document.getElementById('ui'), input);
const audio = new Audio();
const game = new Game(renderer, ui, input, audio);
const pmrem = new THREE.PMREMGenerator(renderer);
game.envMap = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;

const QUALITIES = ['Alta', 'Média', 'Baixa'];
let quality = 'Alta';
try { quality = localStorage.getItem('criptas-quality') || 'Alta'; } catch (e) { /* ignora */ }
if (!QUALITIES.includes(quality)) quality = 'Alta';
game.quality = quality;

let composer, renderPass, bloom, grade, rt;
function setupComposer() {
  if (composer) { composer.dispose(); rt.dispose(); }
  const q = quality;
  const pr = q === 'Alta' ? Math.min(devicePixelRatio, 1.5) : q === 'Média' ? Math.min(devicePixelRatio, 1) : 0.75;
  renderer.setPixelRatio(pr);
  renderer.setSize(innerWidth, innerHeight, false);
  rt = new THREE.WebGLRenderTarget(innerWidth * pr, innerHeight * pr, { type: THREE.HalfFloatType, samples: q === 'Alta' ? 4 : q === 'Média' ? 2 : 0 });
  composer = new EffectComposer(renderer, rt);
  renderPass = new RenderPass(game.scene, game.camera);
  composer.addPass(renderPass);
  if (q !== 'Baixa') { bloom = new UnrealBloomPass(new THREE.Vector2(innerWidth / 2, innerHeight / 2), 0.6, 0.5, 0.8); composer.addPass(bloom); }
  composer.addPass(new OutputPass());
  grade = new ShaderPass(GradeShader);
  composer.addPass(grade);
  const size = q === 'Alta' ? 2048 : q === 'Média' ? 1024 : 512;
  if (game.moon.shadow.mapSize.x !== size) { game.moon.shadow.mapSize.set(size, size); if (game.moon.shadow.map) { game.moon.shadow.map.dispose(); game.moon.shadow.map = null; } }
  resize();
}
function resize() {
  const pr = renderer.getPixelRatio();
  renderer.setSize(innerWidth, innerHeight, false);
  composer.setSize(innerWidth, innerHeight);
  game.camera.aspect = innerWidth / innerHeight;
  game.camera.fov = innerWidth < innerHeight ? 44 : 32;
  game.camera.updateProjectionMatrix();
  game.particles.setScale((innerHeight * pr) / (2 * Math.tan(THREE.MathUtils.degToRad(game.camera.fov) / 2)));
}
addEventListener('resize', () => composer && resize());

function setQuality(q) {
  quality = q; game.quality = q;
  try { localStorage.setItem('criptas-quality', q); } catch (e) { /* ignora */ }
  setupComposer();
}

// ---------- menus ----------
let bestFloor = 1;
try { bestFloor = +localStorage.getItem('criptas-best') || 1; } catch (e) { /* ignora */ }
function toTitle() {
  game.loadFloor(1, false, true);
  game.state = 'title';
  ui.setBoss(null);
  try { bestFloor = +localStorage.getItem('criptas-best') || 1; } catch (e) { /* ignora */ }
  ui.showTitle(bestFloor);
}
let perf = null;
ui.on = {
  play: () => { audio.init(); ui.hidePanels(); game.newGame(); perf = { t: 0, frames: 0 }; },
  controls: () => ui.showControls(() => ui.showTitle(bestFloor)),
  controlsP: () => ui.showControls(() => ui.showPause(game)),
  resume: () => { game.state = 'play'; ui.hidePanels(); },
  mute: () => { audio.setMuted(!audio.muted); ui.showPause(game); },
  quality: () => { setQuality(QUALITIES[(QUALITIES.indexOf(quality) + 1) % 3]); ui.showPause(game); },
  retry: () => { ui.hidePanels(); game.retryFloor(); },
  menu: () => { ui.hidePanels(); toTitle(); },
  next: () => { ui.hidePanels(); game.nextFloor(); },
};

setupComposer();
toTitle();

// ---------- laco ----------
let last = performance.now();
function frame(now) {
  requestAnimationFrame(frame);
  const dt = Math.min(0.05, (now - last) / 1000);
  last = now;
  input.poll();
  game.update(dt);
  renderPass.scene = game.scene;
  grade.uniforms.uTime.value = now * 0.001 % 100;
  composer.render();
  // ajuste automatico de qualidade nos primeiros segundos de jogo
  if (perf && game.state === 'play') {
    perf.t += dt; perf.frames++;
    if (perf.t > 6) {
      const fps = perf.frames / perf.t;
      if (fps < 32 && quality !== 'Baixa') { setQuality(QUALITIES[QUALITIES.indexOf(quality) + 1]); ui.toast(`Gráficos ajustados para "${quality}" (${Math.round(fps)} FPS)`); perf = { t: 0, frames: 0 }; }
      else perf = null;
    }
  }
}
requestAnimationFrame(frame);
window.__game = game;
