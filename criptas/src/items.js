// Itens: armas corpo a corpo, arcos, armaduras e artefatos, com raridade e encantamentos.
export const RARITY = {
  comum: { name: 'Comum', color: '#cfc8b8', hex: 0xcfc8b8, mult: 1, affixes: 0 },
  raro: { name: 'Raro', color: '#4fb3ff', hex: 0x3fa0ff, mult: 1.25, affixes: 1 },
  unico: { name: 'Único', color: '#ffb92e', hex: 0xffa01e, mult: 1.55, affixes: 2 },
};

export const MELEE = {
  espada: { name: 'Espada', dmg: 11, cd: 0.42, range: 2.0, arc: 2.0, combo: 3 },
  machado: { name: 'Machado', dmg: 18, cd: 0.66, range: 2.1, arc: 2.3, combo: 2 },
  adagas: { name: 'Adagas Gêmeas', dmg: 6.5, cd: 0.24, range: 1.7, arc: 1.6, combo: 4 },
  martelo: { name: 'Martelo de Guerra', dmg: 30, cd: 1.0, range: 2.4, arc: 2.9, combo: 1, knock: 2.5 },
  lanca: { name: 'Lança', dmg: 14, cd: 0.55, range: 3.1, arc: 0.9, combo: 2 },
};
export const BOWS = {
  arco: { name: 'Arco Curto', dmg: 9, cd: 0.38, speed: 24, pierce: 0 },
  arcolongo: { name: 'Arco Longo', dmg: 17, cd: 0.78, speed: 30, pierce: 1 },
  besta: { name: 'Besta Pesada', dmg: 25, cd: 1.1, speed: 34, pierce: 2 },
};
export const ARMORS = {
  couro: { name: 'Gibão de Couro', hp: 10, dr: 0.05, speed: 0.05, look: 'couro' },
  malha: { name: 'Cota de Malha', hp: 25, dr: 0.12, speed: 0, look: 'malha' },
  placas: { name: 'Armadura de Placas', hp: 45, dr: 0.2, speed: -0.06, look: 'placas' },
  andarilho: { name: 'Manto do Andarilho', hp: 15, dr: 0.06, speed: 0.1, look: 'andarilho' },
  obsidiana: { name: 'Couraça de Obsidiana', hp: 35, dr: 0.17, speed: -0.02, look: 'obsidiana' },
};
export const ARTIFACTS = {
  chamas: { name: 'Tomo das Chamas', cd: 12, desc: 'Libera um anel de fogo que queima os inimigos próximos.', color: '#ff7a2e' },
  raio: { name: 'Relâmpago Engarrafado', cd: 10, desc: 'Um raio salta entre até 6 inimigos.', color: '#8fd8ff' },
  estandarte: { name: 'Estandarte de Guerra', cd: 24, desc: 'Finca um estandarte: +40% de dano e cura contínua na área.', color: '#ff4a4a' },
  vendaval: { name: 'Chifre do Vendaval', cd: 8, desc: 'Empurra e atordoa todos os inimigos ao redor.', color: '#c8e8d0' },
  laminas: { name: 'Lâminas Espectrais', cd: 18, desc: 'Três lâminas fantasmas giram ao seu redor por 8 s.', color: '#9a8cff' },
  gelo: { name: 'Totem Gélido', cd: 16, desc: 'Congela os inimigos próximos por 3 segundos.', color: '#8ff0ff' },
};

const AFFIX = {
  melee: [
    ['chamas', 'Chamejante', 'Golpes incendeiam o alvo'],
    ['vampiro', 'Vampírico|Vampírica', 'Cada golpe recupera vida'],
    ['critico', 'Afiado|Afiada', '+15% de chance de crítico'],
    ['veloz', 'Ligeiro|Ligeira', 'Ataques 20% mais rápidos'],
    ['trovao', 'do Trovão', '20% de chance de lançar um raio'],
  ],
  bow: [
    ['multi', 'Tríplice', 'Dispara três flechas em leque'],
    ['perfura', 'Perfurante', 'Flechas atravessam +2 inimigos'],
    ['explosiva', 'Explosivo|Explosiva', 'Flechas explodem ao acertar'],
    ['chamas', 'Ígneo|Ígnea', 'Flechas incendeiam o alvo'],
  ],
  armor: [
    ['espinhos', 'de Espinhos', 'Devolve 40% do dano corpo a corpo'],
    ['regen', 'Restaurador|Restauradora', 'Regenera 1,5 de vida por segundo'],
    ['agil', 'Ágil', 'Rolamento recarrega 40% mais rápido'],
    ['guarda', 'Guardião|Guardiã', '+6% de redução de dano'],
  ],
  artifact: [
    ['poder', 'Potente', '+35% de poder'],
    ['recarga', 'Veloz', 'Recarga 25% menor'],
  ],
};

const UNIQUE_NAMES = {
  espada: ['Lâmina do Crepúsculo', 'Presa de Valdor', 'Juramento Partido'],
  machado: ['Machado do Carrasco', 'Racha-Ossos', 'Fúria do Norte'],
  adagas: ['Garras da Víbora', 'Sussurros Gêmeos', 'Ferroada Noturna'],
  martelo: ['Martelo do Trovão', 'Quebra-Montanhas', 'Sino do Juízo'],
  lanca: ['Lança do Alvorecer', 'Presa do Dragão', 'Vigia Eterna'],
  arco: ['Arco Sussurrante', 'Corda do Vento', 'Asa de Corvo'],
  arcolongo: ['Arco das Estrelas', 'Longa Vigília', 'Arco do Caçador Pálido'],
  besta: ['Besta do Inquisidor', 'Punho de Ferro', 'Viúva Negra'],
  couro: ['Pele do Lobo Sombrio', 'Gibão do Ladino'],
  malha: ['Cota do Cruzado', 'Malha de Mithral'],
  placas: ['Égide Rúnica', 'Bastião de Valdor'],
  andarilho: ['Manto do Viajante Eterno', 'Véu da Névoa'],
  obsidiana: ['Coração da Forja', 'Carapaça do Vulcão'],
};

export function rollRarity(rng, bonus = 0) {
  const r = rng.next();
  if (r < 0.05 + bonus * 0.15) return 'unico';
  if (r < 0.3 + bonus * 0.3) return 'raro';
  return 'comum';
}

export function makeItem(rng, floor, opt = {}) {
  const cat = opt.cat || rng.weighted([['melee', 4], ['bow', 2], ['armor', 3], ['artifact', 2]]);
  const rarity = opt.rarity || rollRarity(rng, opt.bonus || 0);
  const R = RARITY[rarity];
  const pw = (1 + 0.32 * (floor - 1)) * rng.range(0.92, 1.1) * R.mult;
  const table = { melee: MELEE, bow: BOWS, armor: ARMORS, artifact: ARTIFACTS }[cat];
  const kind = opt.kind || rng.pick(Object.keys(table));
  const base = table[kind];
  const affixes = [];
  const pool = [...AFFIX[cat]];
  for (let i = 0; i < R.affixes && pool.length; i++) affixes.push(pool.splice(Math.floor(rng.next() * pool.length), 1)[0][0]);
  const it = { id: Math.floor(rng.next() * 1e9), cat, kind, rarity, pw, affixes, floor };
  if (cat === 'melee') it.dmg = Math.round(base.dmg * pw * 10) / 10;
  if (cat === 'bow') it.dmg = Math.round(base.dmg * pw * 10) / 10;
  if (cat === 'armor') { it.hp = Math.round(base.hp * pw); it.dr = Math.min(0.45, base.dr * (0.9 + 0.1 * pw) + (affixes.includes('guarda') ? 0.06 : 0)); }
  if (cat === 'artifact') it.power = pw * (affixes.includes('poder') ? 1.35 : 1);
  it.up = 0;
  it.baseName = nameOf(it, rng);
  it.name = it.baseName;
  return it;
}

// aprimoramento no ferreiro: +12% de atributos por nivel (ate +5)
export const MAX_UP = 5;
export function upgradeItem(it) {
  if ((it.up || 0) >= MAX_UP) return false;
  it.up = (it.up || 0) + 1;
  const k = (1 + 0.12 * it.up) / (1 + 0.12 * (it.up - 1));
  if (it.dmg) it.dmg = Math.round(it.dmg * k * 10) / 10;
  if (it.hp) it.hp = Math.round(it.hp * k);
  if (it.dr) it.dr = Math.min(0.5, it.dr + 0.01);
  if (it.power) it.power *= k;
  it.name = (it.baseName || it.name.replace(/ \+\d$/, '')) + ' +' + it.up;
  return true;
}
export function upgradeCost(it) { return Math.round((45 + 30 * (it.floor || 1)) * (1 + (it.up || 0)) * RARITY[it.rarity].mult); }
export function priceOf(it) { return Math.round({ comum: 45, raro: 120, unico: 280 }[it.rarity] * (1 + 0.35 * ((it.floor || 1) - 1)) * (1 + 0.2 * (it.up || 0))); }
export function sellPrice(it) { return Math.max(3, Math.round(priceOf(it) * 0.35)); }

function nameOf(it, rng) {
  const base = { melee: MELEE, bow: BOWS, armor: ARMORS, artifact: ARTIFACTS }[it.cat][it.kind].name;
  if (it.rarity === 'unico' && UNIQUE_NAMES[it.kind]) return rng.pick(UNIQUE_NAMES[it.kind]);
  if (it.rarity === 'raro' && it.affixes.length) {
    const a = AFFIX[it.cat].find(x => x[0] === it.affixes[0]);
    if (it.cat === 'artifact') return base + ' (' + a[1] + ')';
    const [m, f] = a[1].includes('|') ? a[1].split('|') : [a[1], a[1]];
    const fem = /^(Espada|Lança|Cota|Armadura|Couraça|Besta|Adagas)/.test(base);
    let adj = fem ? f : m;
    if (base.startsWith('Adagas') && !adj.startsWith('d')) adj += 's';
    return base + ' ' + adj;
  }
  return base;
}

export function cdOf(it) {
  if (it.cat === 'melee') return MELEE[it.kind].cd * (it.affixes.includes('veloz') ? 0.8 : 1);
  if (it.cat === 'bow') return BOWS[it.kind].cd;
  if (it.cat === 'artifact') return ARTIFACTS[it.kind].cd * (it.affixes.includes('recarga') ? 0.75 : 1);
  return 0;
}

export function affixText(it) {
  return it.affixes.map(a => AFFIX[it.cat].find(x => x[0] === a)[2]);
}

export function statLines(it) {
  const L = [];
  if (it.up) L.push(['Aprimoramento', '+' + it.up]);
  if (it.cat === 'melee') {
    const b = MELEE[it.kind];
    L.push(['Dano', it.dmg.toFixed(1)], ['Velocidade', (1 / cdOf(it)).toFixed(1) + '/s'], ['Alcance', b.range.toFixed(1)]);
  } else if (it.cat === 'bow') {
    L.push(['Dano', it.dmg.toFixed(1)], ['Velocidade', (1 / cdOf(it)).toFixed(1) + '/s']);
  } else if (it.cat === 'armor') {
    const b = ARMORS[it.kind];
    L.push(['Vida', '+' + it.hp], ['Proteção', Math.round(it.dr * 100) + '%']);
    if (b.speed) L.push(['Movimento', (b.speed > 0 ? '+' : '') + Math.round(b.speed * 100) + '%']);
  } else {
    L.push(['Poder', Math.round(it.power * 100) + '%'], ['Recarga', cdOf(it).toFixed(0) + ' s']);
  }
  return L;
}

// numero para comparacao rapida
export function scoreOf(it) {
  if (!it) return 0;
  if (it.cat === 'melee' || it.cat === 'bow') return it.dmg / cdOf(it) * (1 + it.affixes.length * 0.12);
  if (it.cat === 'armor') return it.hp + it.dr * 200 + it.affixes.length * 8;
  return it.power * 10 + it.affixes.length * 3;
}

export function catName(cat) { return { melee: 'Arma corpo a corpo', bow: 'Arma à distância', armor: 'Armadura', artifact: 'Artefato' }[cat]; }
