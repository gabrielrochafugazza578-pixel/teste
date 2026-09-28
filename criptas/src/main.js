// Ponto de entrada: renderizador, pos-processamento, qualidade grafica e laco principal.
import * as THREE from 'three';
import { EffectComposer } from 'three/examples/jsm/postprocessing/EffectComposer.js';
import { RenderPass } from 'three/examples/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/examples/jsm/postprocessing/UnrealBloomPass.js';
import { OutputPass } from 'three/examples/jsm/postprocessing/OutputPass.js';
import { ShaderPass } from 'three/examples/jsm/postprocessing/ShaderPass.js';
import { RoomEnvironment } from 'three/examples/jsm/environments/RoomEnvironment.js';
import { Game } from './game.js';
import { generateHub } from './dungeon.js';
import { Mirror, LiveEnv } from './reflect.js';
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
renderer.shadowMap.autoUpdate = false;

const input = new Input(canvas);
const ui = new UI(document.getElementById('ui'), input);
const audio = new Audio();
const game = new Game(renderer, ui, input, audio);
const pmrem = new THREE.PMREMGenerator(renderer);
game.envMap = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;
const mirror = new Mirror(renderer);
game.mirror = mirror;

const QUALITIES = ['Ultra', 'Alta', 'Média', 'Baixa'];
const Q = {
  Ultra: { pr: 2, msaa: 4, bloom: true, mirror: 0.6, env: 256, envEvery: 3, pool: 16, shadows: 4, sun: 4096 },
  Alta: { pr: 1.5, msaa: 4, bloom: true, mirror: 0.45, env: 128, envEvery: 5, pool: 12, shadows: 2, sun: 2048 },
  Média: { pr: 1, msaa: 2, bloom: true, mirror: 0.33, env: 64, envEvery: 15, pool: 10, shadows: 0, sun: 1024 },
  Baixa: { pr: 0.75, msaa: 0, bloom: false, mirror: 0, env: 0, envEvery: 0, pool: 6, shadows: 0, sun: 512 },
};
let quality = 'Ultra';
try { quality = localStorage.getItem('criptas-quality-v2') || 'Ultra'; } catch (e) { /* ignora */ }
if (!QUALITIES.includes(quality)) quality = 'Ultra';
game.quality = quality;

let composer, renderPass, bloom, grade, rt;
function setupComposer() {
  if (composer) { composer.dispose(); rt.dispose(); }
  const q = Q[quality];
  const pr = Math.min(devicePixelRatio, q.pr);
  renderer.setPixelRatio(pr);
  renderer.setSize(innerWidth, innerHeight, false);
  rt = new THREE.WebGLRenderTarget(innerWidth * pr, innerHeight * pr, { type: THREE.HalfFloatType, samples: q.msaa });
  composer = new EffectComposer(renderer, rt);
  renderPass = new RenderPass(game.scene, game.camera);
  composer.addPass(renderPass);
  if (q.bloom) { bloom = new UnrealBloomPass(new THREE.Vector2(innerWidth / 2, innerHeight / 2), 0.55, 0.5, 0.82); composer.addPass(bloom); }
  composer.addPass(new OutputPass());
  grade = new ShaderPass(GradeShader);
  composer.addPass(grade);
  if (game.moon.shadow.mapSize.x !== q.sun) { game.moon.shadow.mapSize.set(q.sun, q.sun); if (game.moon.shadow.map) { game.moon.shadow.map.dispose(); game.moon.shadow.map = null; } }
  game.setLightQuality(q.pool, q.shadows);
  mirror.setup(q.mirror > 0, q.mirror);
  if (game.liveEnv) { game.liveEnv.rt.dispose(); game.liveEnv = null; }
  if (q.env) { game.liveEnv = new LiveEnv(renderer, q.env); game.liveEnv.every = q.envEvery; }
  if (game.scene) { game.scene.environment = game.liveEnv ? game.liveEnv.texture : game.envMap; game.scene.environmentIntensity = game.liveEnv ? 0.9 : 0.35; }
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
  mirror.resize();
}
addEventListener('resize', () => composer && resize());

function setQuality(q) {
  quality = q; game.quality = q;
  try { localStorage.setItem('criptas-quality-v2', q); } catch (e) { /* ignora */ }
  setupComposer();
}

// ---------- menus ----------
let bestFloor = 1;
function toTitle() {
  game.mode = 'hub';
  game.loadLevel(generateHub(1234), true);
  game.setupTitleScene();
  game.state = 'title';
  ui.setBoss(null);
  ui.showTitle(saveSummary(), Game.hasSave(), quality);
}
function saveSummary() {
  try { const s = JSON.parse(localStorage.getItem('criptas-save-v2')); return (s && s.summary) || { depth: s ? s.depth : 1 }; } catch (e) { return {}; }
}
let perf = null;
const st = (role, opt = {}) => ui.openStation(game, role, opt);
const act = (role, fn, extra = {}) => (b) => { const msg = fn(b); st(role, { ...extra(b), msg: msg || '' }); };
ui.on = {
  play: (b) => {
    if (Game.hasSave() && b && !b.dataset.ok) { b.dataset.ok = '1'; b.classList.add('warn'); b.textContent = 'Começar do zero? O progresso salvo será apagado'; return; }
    audio.init(); ui.hidePanels(); game.newGame(); perf = { t: 0, frames: 0 };
  },
  tquality: () => { setQuality(QUALITIES[(QUALITIES.indexOf(quality) + 1) % QUALITIES.length]); ui.showTitle(saveSummary(), Game.hasSave(), quality); },
  continue: () => { audio.init(); ui.hidePanels(); if (!game.loadSave()) game.newGame(); perf = { t: 0, frames: 0 }; },
  controls: () => ui.showControls(() => ui.showTitle(saveSummary(), Game.hasSave(), quality)),
  controlsP: () => ui.showControls(() => ui.showPause(game)),
  resume: () => { game.state = 'play'; ui.hidePanels(); },
  mute: () => { audio.setMuted(!audio.muted); ui.showPause(game); },
  quality: () => { setQuality(QUALITIES[(QUALITIES.indexOf(quality) + 1) % QUALITIES.length]); ui.showPause(game); },
  retry: () => { ui.hidePanels(); game.retryLevel(); },
  hub: () => { ui.hidePanels(); game.deathToHub(); },
  menu: () => { ui.hidePanels(); if (game.inHub) game.save(); toTitle(); },
  next: () => { ui.hidePanels(); game.levelComplete(); },
  close: () => game.closeMenu(),
  stab: (b) => st('shop', { tab: b.dataset.tab }),
  buyc: act('shop', b => game.buyConsumable(b.dataset.id), () => ({ tab: 'buy' })),
  buyi: act('shop', b => game.buyItem(+b.dataset.i), () => ({ tab: 'buy' })),
  sell: (b) => { game.sellItem(+b.dataset.i); if (b.dataset.back === 'bag') st('bag'); else st('shop', { tab: 'sell' }); },
  upg: act('smith', b => game.upgrade(b.dataset.s, b.dataset.i === '' ? undefined : +b.dataset.i), () => ({})),
  qacc: act('quests', b => game.acceptQuest(+b.dataset.i), () => ({})),
  qab: act('quests', b => { game.abandonQuest(+b.dataset.i); }, () => ({})),
  equip: (b) => { game.equipFromBag(+b.dataset.i, b.dataset.a !== undefined ? +b.dataset.a : undefined); st('bag'); },
  disc: (b) => { game.discard(+b.dataset.i); st('bag'); },
  travel: (b) => { const m = game.travelDimension(b.dataset.k); if (m) st('dims', { msg: m }); },
};

setupComposer();

// som: liberado no primeiro toque ou tecla depois de sair do menu
const unlockAudio = () => { if (game.state !== 'title') audio.init(); };
addEventListener('pointerdown', unlockAudio);
addEventListener('keydown', unlockAudio);

// quando a pagina e atualizada ao vivo, continua do mesmo andar com o mesmo equipamento
const hot = window.claude && window.claude.hot;
if (hot && hot.snapshot) hot.snapshot(() => { if (game.state !== 'title' && game.inHub) game.save(); return { resume: game.state !== 'title' }; });
const start = (data) => {
  if (data && data.resume && Game.hasSave()) {
    try { if (game.loadSave()) { ui.hidePanels(); return; } } catch (e) { /* estado antigo: volta ao menu */ }
  }
  toTitle();
};
if (hot && hot.ready) hot.ready(start); else start((hot && hot.data) || {});

// ---------- laco ----------
let last = performance.now();
function frame(now) {
  requestAnimationFrame(frame);
  const dt = Math.min(0.05, (now - last) / 1000);
  last = now;
  input.poll();
  game.update(dt);
  renderer.shadowMap.needsUpdate = true;
  const P = window.__perf;
  if (P) { renderer.info.autoReset = false; renderer.info.reset(); }
  mirror.render(game.scene, game.camera, 0);
  if (P) { P.mirror += renderer.info.render.calls; renderer.info.reset(); }
  if (game.liveEnv) { const p = game.player; game.liveEnv.update(game.scene, p.x, p.y + 1.3, p.z, p.rig.root); }
  if (P) { P.env += renderer.info.render.calls; renderer.info.reset(); }
  renderPass.scene = game.scene;
  grade.uniforms.uTime.value = now * 0.001 % 100;
  composer.render();
  if (P) { P.main += renderer.info.render.calls; P.tris += renderer.info.render.triangles; P.frames++; renderer.info.autoReset = true; }
  // ajuste automatico de qualidade nos primeiros segundos de jogo
  if (perf && game.state === 'play') {
    perf.t += dt; perf.frames++;
    if (perf.t > 6) {
      const fps = perf.frames / perf.t;
      if (fps < 24 && quality === 'Ultra') { setQuality('Alta'); ui.toast(`Gráficos ajustados para "Alta" (${Math.round(fps)} FPS). Pode voltar ao Ultra no menu de pausa.`); perf = { t: 0, frames: 0 }; }
      else perf = null;
    }
  }
}
requestAnimationFrame(frame);
window.__game = game;
