// Infraestrutura dos modelos: materiais, esqueleto articulado (pivos), cache de modelos
// (cada tipo e construido uma vez e clonado por instancia) e registro de animacoes.
import * as THREE from 'three';
import { charTex } from './textures.js';
import { GEO, bakeHierarchy } from './geo.js';

const METAL = { steel: 0.92, steel_dark: 0.9, gold: 1, iron: 0.7, chain: 0.85 };
const matCache = new Map();

// material base (compartilhado entre modelos-modelo; cada instancia recebe um clone)
export function M(kind, o = {}) {
  const key = kind + JSON.stringify(o);
  if (matCache.has(key)) return matCache.get(key);
  let m;
  if (kind === 'glow') m = new THREE.MeshStandardMaterial({ color: o.color ?? 0xff3020, emissive: o.color ?? 0xff3020, emissiveIntensity: o.intensity ?? 4, roughness: 0.4 });
  else if (kind === 'dark') m = new THREE.MeshStandardMaterial({ color: o.color ?? 0x060505, roughness: 1 });
  else if (kind === 'eye') m = new THREE.MeshPhysicalMaterial({ color: o.color ?? 0x0a0806, roughness: 0.2, clearcoat: 1, clearcoatRoughness: 0.2 });
  else if (kind === 'plain') m = new THREE.MeshStandardMaterial({ color: o.color ?? 0xffffff, roughness: o.rough ?? 0.6, metalness: o.metal ?? 0 });
  else {
    const t = charTex(kind);
    const phys = ['porcelain', 'carapace', 'carapace_ice', 'jelly', 'ice', 'crystal_void', 'scales', 'scales_red', 'obsidian'].includes(kind);
    const P = {
      map: t.map, roughnessMap: t.roughnessMap, normalMap: t.normalMap,
      metalness: METAL[kind] ?? 0, color: o.color ?? 0xffffff,
      normalScale: new THREE.Vector2(o.ns ?? 0.8, o.ns ?? 0.8),
    };
    m = phys ? new THREE.MeshPhysicalMaterial(P) : new THREE.MeshStandardMaterial(P);
    if (o.rough !== undefined) m.roughness = o.rough;
    if (kind === 'porcelain') { m.clearcoat = 1; m.clearcoatRoughness = 0.18; m.roughness = 0.35; }
    if (kind === 'carapace' || kind === 'carapace_ice') { m.clearcoat = 1; m.clearcoatRoughness = 0.22; m.iridescence = 0.9; m.iridescenceIOR = 1.6; m.iridescenceThicknessRange = [200, 600]; }
    if (kind === 'scales' || kind === 'scales_red') { m.clearcoat = 0.6; m.clearcoatRoughness = 0.3; }
    if (kind === 'obsidian') { m.clearcoat = 0.8; m.clearcoatRoughness = 0.2; }
    if (kind === 'jelly') { m.transparent = true; m.opacity = o.opacity ?? 0.55; m.roughness = 0.18; m.clearcoat = 1; m.clearcoatRoughness = 0.2; m.emissive = new THREE.Color(o.emi ?? 0x6aff40); m.emissiveIntensity = 0.35; m.side = THREE.DoubleSide; m.depthWrite = false; }
    if (kind === 'ice') { m.transparent = true; m.opacity = 0.88; m.roughness = 0.15; m.clearcoat = 1; m.clearcoatRoughness = 0.15; m.metalness = 0.05; }
    if (t.emissiveMap) { m.emissiveMap = t.emissiveMap; m.emissive = new THREE.Color(0xffffff); m.emissiveIntensity = o.emi ?? 2; }
    if (o.side) m.side = o.side;
  }
  if (o.double) m.side = THREE.DoubleSide;
  matCache.set(key, m);
  return m;
}

// ---------- construcao ----------
export class Builder {
  constructor(type) { this.type = type; this.root = new THREE.Group(); this.props = {}; }
  piv(parent, name, x = 0, y = 0, z = 0) {
    const g = new THREE.Group(); g.name = name || ''; g.position.set(x, y, z); (parent || this.root).add(g); return g;
  }
  // malha com posicao, escala e rotacao
  mesh(parent, geo, mat, p = [0, 0, 0], s = [1, 1, 1], r = [0, 0, 0], keep = false) {
    const m = new THREE.Mesh(typeof geo === 'function' ? geo() : geo, mat);
    m.position.set(p[0], p[1], p[2]);
    if (typeof s === 'number') m.scale.setScalar(s); else m.scale.set(s[0], s[1], s[2]);
    m.rotation.set(r[0], r[1], r[2]);
    m.castShadow = true; m.receiveShadow = true;
    if (keep) m.userData.keep = true;
    (parent || this.root).add(m);
    return m;
  }
  ball(parent, mat, p, s, r) { return this.mesh(parent, GEO.sphere, mat, p, s, r); }
}

const templates = new Map();
export function template(key, build) {
  if (!templates.has(key)) {
    const b = build();
    bakeHierarchy(b.root);
    b.root.updateMatrixWorld(true);
    templates.set(key, b);
  }
  return templates.get(key);
}

export class Rig {
  constructor(type) { this.type = type; this.root = new THREE.Group(); this.mats = []; this.meshes = []; this.flashT = 0; }
  static from(tpl) {
    const r = new Rig(tpl.type);
    r.root = tpl.root.clone(true);
    const map = new Map();
    r.root.traverse(o => {
      if (o.isMesh) {
        let m = map.get(o.material);
        if (!m) {
          m = o.material.clone();
          m.userData.baseEmissive = m.emissive ? m.emissive.clone() : null;
          m.userData.baseEI = m.emissiveIntensity;
          m.userData.baseOpacity = m.opacity; m.userData.baseTransparent = m.transparent;
          map.set(o.material, m);
        }
        o.material = m;
        if (o.userData.ownGeo) { o.geometry = o.geometry.clone(); o.userData.base = o.geometry.attributes.position.array.slice(); }
        r.meshes.push(o);
      }
      if (o.name) {
        const dot = o.name.indexOf('.');
        if (dot > 0) { const k = o.name.slice(0, dot); (r[k] || (r[k] = []))[+o.name.slice(dot + 1)] = o; }
        else r[o.name] = o;
      }
    });
    r.mats = [...map.values()];
    Object.assign(r, tpl.props);
    for (const k of Object.keys(tpl.props)) if (Array.isArray(tpl.props[k])) r[k] = tpl.props[k].slice();
    return r;
  }
  flash(v) {
    for (const m of this.mats) {
      if (!m.userData.baseEmissive) continue;
      if (v > 0) { m.emissive.setRGB(v, v * 0.95, v * 0.9); m.emissiveIntensity = 1; }
      else { m.emissive.copy(m.userData.baseEmissive); m.emissiveIntensity = m.userData.baseEI; }
    }
  }
  tint(color, k) {
    for (const m of this.mats) { if (!m.userData.baseColor) m.userData.baseColor = m.color.clone(); m.color.copy(m.userData.baseColor).lerp(color, k); }
  }
  fade(alpha) {
    for (const m of this.mats) {
      const bo = m.userData.baseOpacity ?? 1;
      m.transparent = alpha < 1 || m.userData.baseTransparent; m.opacity = bo * alpha; m.depthWrite = alpha > 0.5 && !m.userData.baseTransparent;
    }
  }
  dispose() { for (const m of this.mats) m.dispose(); }
}

// registro de animacoes de locomocao por tipo de modelo
export const ANIM = {};
