// Missoes do quadro do Refugio: cacadas, elites, tesouros, guardioes, reliquias, resgates e dimensoes.
import { ENEMY, BOSS } from './entities.js';
import { THEMES, themeFor, DIMENSIONS } from './themes.js';

const RELICS = ['Relicário de São Valdor', 'Cálice Partido de Orn', 'Coroa de Espinhos Dourados', 'Tomo dos Nomes Perdidos', 'Sino da Primeira Chama'];
const SCOUTS = ['o batedor Kael', 'a caçadora Mirela', 'o monge Tobias', 'a cartógrafa Yvaine', 'o ferreiro-aprendiz Dario'];

let uid = 1;
export function makeQuestOffers(rng, depth, have = []) {
  const theme = THEMES[themeFor(depth)];
  const pool = ['hunt', 'hunt', 'elite', 'chests', 'boss', 'relic', 'rescue', 'dimension'];
  const out = [];
  const used = new Set(have.map(q => q.type));
  for (let t = 0; t < 30 && out.length < 3; t++) {
    const type = rng.pick(pool);
    if ((type === 'relic' || type === 'rescue' || type === 'boss' || type === 'dimension') && (used.has(type) || out.some(q => q.type === type))) continue;
    const q = { id: uid++ + Math.floor(rng.next() * 1e6), type, have: 0, done: false, depth };
    const lv = depth;
    const gold = (n) => Math.round(n * (1 + 0.3 * (lv - 1)));
    if (type === 'hunt') {
      const list = theme.enemies.map(e => e[0]).filter(e => ENEMY[e]);
      q.target = rng.pick(list); q.need = rng.int(8, 15);
      q.title = `Caçada: ${ENEMY[q.target].name}`; q.desc = `Derrote ${q.need} criaturas do tipo ${ENEMY[q.target].name} (em qualquer andar ou dimensão).`;
      q.reward = { gold: gold(q.need * 9), xp: 60 * lv };
    } else if (type === 'elite') {
      q.need = rng.int(2, 4); q.title = 'Caçador de campeões'; q.desc = `Derrote ${q.need} inimigos de elite (os de barra dourada).`;
      q.reward = { gold: gold(120), xp: 90 * lv, item: 'raro' };
    } else if (type === 'chests') {
      q.need = rng.int(3, 5); q.title = 'Saqueador de tumbas'; q.desc = `Abra ${q.need} baús.`;
      q.reward = { gold: gold(90), xp: 50 * lv };
    } else if (type === 'boss') {
      const b = BOSS[theme.boss];
      q.target = theme.boss; q.need = 1; q.title = `Guardião: ${b.name.split(',')[0]}`; q.desc = `Derrote ${b.name}, guardião do Andar ${depth}.`;
      q.reward = { gold: gold(200), xp: 150 * lv, fragments: 1 };
    } else if (type === 'relic') {
      q.relicName = rng.pick(RELICS); q.need = 1; q.title = 'Relíquia perdida'; q.desc = `Encontre o ${q.relicName} no próximo andar (brilha em dourado no minimapa).`;
      q.reward = { gold: gold(160), xp: 100 * lv, item: rng.chance(0.35) ? 'unico' : 'raro' };
    } else if (type === 'rescue') {
      q.scout = rng.pick(SCOUTS); q.need = 1; q.title = 'Resgate'; q.desc = `Liberte ${q.scout}, preso numa jaula no próximo andar.`;
      q.reward = { gold: gold(140), xp: 110 * lv, fragments: 1 };
    } else {
      q.need = 1; q.title = 'Além do véu'; q.desc = `Derrote o guardião de qualquer dimensão (${DIMENSIONS.map(d => THEMES[d].name).join(', ')}).`;
      q.reward = { gold: gold(260), xp: 220 * lv, item: 'unico', fragments: 1 };
    }
    out.push(q);
  }
  return out;
}

export function rewardText(r) {
  const p = [];
  if (r.gold) p.push(`${r.gold} ouro`);
  if (r.xp) p.push(`${r.xp} XP`);
  if (r.item) p.push(r.item === 'unico' ? 'item Único' : 'item Raro');
  if (r.fragments) p.push(`${r.fragments} fragmento${r.fragments > 1 ? 's' : ''} dimensional`);
  return p.join(' · ');
}
