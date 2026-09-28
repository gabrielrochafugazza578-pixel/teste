// Interface em HTML: HUD, minimapa, cartoes de itens, avisos e menus.
import { RARITY, ARTIFACTS, statLines, affixText, catName, scoreOf, cdOf } from './items.js';
import { C } from './dungeon.js';

const $ = (s, r = document) => r.querySelector(s);
const h = (tag, cls, html) => { const e = document.createElement(tag); if (cls) e.className = cls; if (html !== undefined) e.innerHTML = html; return e; };

const ICON = {
  chamas: '<svg viewBox="0 0 32 32"><path d="M16 3c2 6 9 9 9 17a9 9 0 0 1-18 0c0-5 3-7 4-11 1 3 2 4 4 5-1-4 0-8 1-11z" fill="#ff7a2e"/><path d="M16 14c1 3 5 5 5 9a5 5 0 0 1-10 0c0-3 3-5 5-9z" fill="#ffd36a"/></svg>',
  raio: '<svg viewBox="0 0 32 32"><path d="M19 2L6 18h8l-3 12 15-18h-9z" fill="#8fd8ff" stroke="#fff" stroke-width="1"/></svg>',
  estandarte: '<svg viewBox="0 0 32 32"><rect x="7" y="3" width="2.5" height="27" fill="#a07850"/><path d="M9.5 5h15l-4 6 4 6h-15z" fill="#d8352a"/><circle cx="15" cy="11" r="2.2" fill="#ffd36a"/></svg>',
  vendaval: '<svg viewBox="0 0 32 32" fill="none" stroke="#c8e8d0" stroke-width="2.5" stroke-linecap="round"><path d="M4 11h15a4 4 0 1 0-4-4"/><path d="M4 17h21a4 4 0 1 1-4 4"/><path d="M4 23h10"/></svg>',
  laminas: '<svg viewBox="0 0 32 32"><g fill="#a89cff"><path d="M16 2l2 12-2 2-2-2z"/><path d="M29 22l-11-5-.5-2.7 2.7-.8z" /><path d="M5 24l7-10 2.7.6.3 2.8z"/></g><circle cx="16" cy="16" r="2.5" fill="#fff"/></svg>',
  gelo: '<svg viewBox="0 0 32 32" stroke="#8ff0ff" stroke-width="2.4" stroke-linecap="round"><path d="M16 3v26M4.7 9.5l22.6 13M4.7 22.5l22.6-13"/><path d="M12 5l4 4 4-4M12 27l4-4 4 4" fill="none"/></svg>',
  pocao: '<svg viewBox="0 0 32 32"><rect x="12" y="2" width="8" height="5" rx="1" fill="#a07850"/><path d="M13 7h6v5l6 7a8 8 0 1 1-18 0l6-7z" fill="#c8d0d8" opacity=".5"/><path d="M8.5 19h15a8 8 0 1 1-15 0z" fill="#e0303a"/><circle cx="13" cy="21" r="1.6" fill="#ff9a9a"/></svg>',
  flecha: '<svg viewBox="0 0 32 32"><path d="M5 27L25 7" stroke="#d8c8a0" stroke-width="2.5"/><path d="M25 7l-7 1 6 6z" fill="#c0c8d0"/><path d="M5 27l1-6 2 4 4 2z" fill="#e05040"/></svg>',
  ouro: '<svg viewBox="0 0 32 32"><circle cx="16" cy="16" r="11" fill="#e8b440" stroke="#8a6010" stroke-width="2"/><circle cx="16" cy="16" r="6" fill="none" stroke="#fff3b0" stroke-width="1.5" opacity=".7"/></svg>',
  melee: '<svg viewBox="0 0 32 32"><path d="M24 3l5 0 0 5-15 15-5-5z" fill="#d0d6de"/><path d="M8 17l7 7-2 2-7-7z" fill="#e0b050"/><path d="M8 24l-4 4" stroke="#8a5a30" stroke-width="3"/></svg>',
  bow: '<svg viewBox="0 0 32 32" fill="none"><path d="M8 4c14 4 14 20 0 24" stroke="#b08050" stroke-width="3"/><path d="M8 4v24" stroke="#ddd" stroke-width="1"/></svg>',
  armor: '<svg viewBox="0 0 32 32"><path d="M6 6l6-3h8l6 3-2 8v13H8V14z" fill="#b8c0c8"/><path d="M12 3h8v6h-8z" fill="#606870"/></svg>',
};
export { ICON };

export class UI {
  constructor(root, input) {
    this.root = root; this.input = input; this.on = {};
    this.cache = {};
    root.innerHTML = `
      <div id="hurt"></div>
      <div id="bars"></div>
      <div id="floats"></div>
      <div id="hud" class="hidden">
        <div id="floorinfo"><div id="floorname"></div><div id="objective"></div></div>
        <div id="mapwrap"><canvas id="minimap" width="200" height="200"></canvas><div class="mapn">N</div></div>
        <div id="bossbar" class="hidden"><div id="bossname"></div><div class="bar"><div id="bossfill"></div><div id="bossghost"></div></div></div>
        <div id="toasts"></div>
        <div id="prompt" class="hidden"></div>
        <div id="bottom">
          <div id="xpbar"><div id="xpfill"></div><span id="lvl"></span></div>
          <div id="hotbar">
            <div class="slot big" id="s-potion" data-act="potion"><div class="ico">${ICON.pocao}</div><div class="cd"></div><kbd>Q</kbd></div>
            <div id="orb"><div id="orbfill"></div><div id="orbshine"></div><span id="hptext"></span><div id="rollpip"></div></div>
            <div class="slot" id="s-art0" data-act="art1"><div class="ico"></div><div class="cd"></div><kbd>1</kbd></div>
            <div class="slot" id="s-art1" data-act="art2"><div class="ico"></div><div class="cd"></div><kbd>2</kbd></div>
            <div class="slot" id="s-art2" data-act="art3"><div class="ico"></div><div class="cd"></div><kbd>3</kbd></div>
          </div>
          <div id="res"><span class="r">${ICON.flecha}<b id="arrows"></b></span><span class="r">${ICON.ouro}<b id="gold"></b></span></div>
          <div id="gear"></div>
        </div>
      </div>
      <div id="touch" class="hidden">
        <div class="tb" data-act="attack" style="right:20px;bottom:110px;width:84px;height:84px">⚔</div>
        <div class="tb" data-act="shoot" style="right:118px;bottom:40px">🏹</div>
        <div class="tb" data-act="roll" style="right:118px;bottom:140px">⟲</div>
        <div class="tb" data-act="interact" style="right:30px;bottom:210px">E</div>
        <div class="tb" data-act="pause" style="right:16px;top:230px;width:44px;height:44px">❚❚</div>
      </div>
      <div id="panel" class="hidden"></div>`;
    this.hud = $('#hud'); this.panel = $('#panel'); this.floats = $('#floats');
    this.mm = $('#minimap'); this.mctx = this.mm.getContext('2d');
    // botoes de toque e slots clicaveis
    for (const el of root.querySelectorAll('[data-act]')) {
      const a = el.dataset.act;
      const on = (e) => { e.preventDefault(); input.setTouch(a, true); el.classList.add('down'); };
      const off = (e) => { e.preventDefault(); input.setTouch(a, false); el.classList.remove('down'); };
      el.addEventListener('touchstart', on, { passive: false }); el.addEventListener('touchend', off); el.addEventListener('touchcancel', off);
      el.addEventListener('mousedown', (e) => { if (el.classList.contains('slot')) { input.setTouch(a, true); setTimeout(() => input.setTouch(a, false), 60); e.stopPropagation(); } });
    }
    if ('ontouchstart' in window || navigator.maxTouchPoints > 0) $('#touch').classList.remove('hidden');
  }

  // ---------------- menus ----------------
  showPanel(html, cls = '') {
    this.panel.className = cls; this.panel.innerHTML = `<div class="card">${html}</div>`;
    for (const b of this.panel.querySelectorAll('[data-go]')) b.addEventListener('click', () => this.on[b.dataset.go] && this.on[b.dataset.go](b));
  }
  hidePanels() { this.panel.className = 'hidden'; this.panel.innerHTML = ''; }
  showTitle(best) {
    this.hud.classList.add('hidden');
    this.showPanel(`
      <div class="logo"><span>Criptas</span><small>de</small><span>Valdor</span></div>
      <p class="sub">Desça às profundezas, acenda os braseiros ancestrais<br>e derrote os guardiões que dormem sob a pedra.</p>
      <button data-go="play" class="primary">Jogar</button>
      <button data-go="controls">Controles</button>
      ${best > 1 ? `<p class="best">Andar mais profundo alcançado: <b>${best}</b></p>` : ''}
      <p class="tiny">Tudo neste jogo — texturas, modelos, música e efeitos — é gerado por código.</p>`, 'title');
  }
  controlsHtml() {
    return `<h2>Controles</h2>
      <table class="keys">
        <tr><td><kbd>W</kbd><kbd>A</kbd><kbd>S</kbd><kbd>D</kbd> / setas</td><td>Mover</td></tr>
        <tr><td>Mouse</td><td>Mirar</td></tr>
        <tr><td>Botão esquerdo / <kbd>J</kbd></td><td>Ataque corpo a corpo (segure para combo)</td></tr>
        <tr><td>Botão direito / <kbd>K</kbd></td><td>Atirar com o arco</td></tr>
        <tr><td><kbd>Espaço</kbd> / <kbd>Shift</kbd></td><td>Rolar (invulnerável)</td></tr>
        <tr><td><kbd>Q</kbd></td><td>Poção de vida</td></tr>
        <tr><td><kbd>1</kbd> <kbd>2</kbd> <kbd>3</kbd></td><td>Artefatos</td></tr>
        <tr><td><kbd>E</kbd></td><td>Interagir / equipar item (segure <kbd>E</kbd> + <kbd>1-3</kbd> para escolher o slot do artefato)</td></tr>
        <tr><td>Roda do mouse</td><td>Zoom</td></tr>
        <tr><td><kbd>Esc</kbd> / <kbd>P</kbd></td><td>Pausa</td></tr>
      </table>
      <p class="tiny">Controle (gamepad): analógico esquerdo move, direito mira, X ataca, RT atira, A rola, B poção, Y interage, LB/LT/RB artefatos.<br>No celular: arraste no lado esquerdo para andar e use os botões à direita (a mira é automática).</p>
      <button data-go="back">Voltar</button>`;
  }
  showControls(back) { this.on.back = back; this.showPanel(this.controlsHtml(), 'title'); }
  showPause(game) {
    const q = game.quality;
    this.showPanel(`<h2>Pausado</h2>
      <button data-go="resume" class="primary">Continuar</button>
      <button data-go="controlsP">Controles</button>
      <button data-go="mute">Som: ${game.audio.muted ? 'desligado' : 'ligado'}</button>
      <button data-go="quality">Gráficos: ${q}</button>
      <button data-go="retry">Reiniciar andar</button>
      <button data-go="menu">Menu principal</button>
      ${this.statsHtml(game)}`);
  }
  statsHtml(g) {
    const p = g.player;
    const it = (x) => x ? `<span style="color:${RARITY[x.rarity].color}">${x.name}</span>` : '—';
    return `<div class="gearlist">
      <div>${ICON.melee}${it(p.equip.melee)}</div><div>${ICON.bow}${it(p.equip.bow)}</div><div>${ICON.armor}${it(p.equip.armor)}</div>
      ${p.equip.arts.map(a => `<div>${a ? ICON[a.kind] : '<span class="ph"></span>'}${it(a)}</div>`).join('')}
      <div class="lv">Nível ${p.level} · Vida ${Math.round(p.maxHp)} · Proteção ${Math.round(p.dr * 100)}%</div></div>`;
  }
  showDeath(g) {
    this.showPanel(`<h2 class="red">Você caiu</h2>
      <p class="sub">As sombras de ${g.theme.name} reclamam mais um aventureiro.</p>
      <div class="stats"><div><b>${g.floorNum}</b>andar</div><div><b>${g.stats.kills}</b>inimigos</div><div><b>${g.player.level}</b>nível</div></div>
      <button data-go="retry" class="primary">Tentar de novo</button>
      <button data-go="menu">Menu principal</button>
      <p class="tiny">Ao tentar de novo, o andar é recriado e você volta com o equipamento que tinha ao entrar nele.</p>`);
  }
  showFloorDone(g) {
    const t = Math.round(g.stats.time - (g.stats.floorStart || 0));
    const final = g.floorNum % 3 === 0;
    this.showPanel(`<h2>${final ? 'Vitória!' : `Andar ${g.floorNum} concluído`}</h2>
      ${final ? `<p class="sub">O Colosso de Obsidiana caiu e o coração da Forja Profunda se apagou. As Criptas de Valdor estão livres... por enquanto.<br>Mais abaixo, as profundezas continuam — e ficam mais cruéis.</p>` : `<p class="sub">O portal pulsa com uma luz fria. Algo pior espera lá embaixo.</p>`}
      <div class="stats"><div><b>${g.stats.kills}</b>inimigos</div><div><b>${g.player.gold}</b>ouro</div><div><b>${Math.floor(t / 60)}:${String(t % 60).padStart(2, '0')}</b>tempo</div><div><b>${g.player.level}</b>nível</div></div>
      <button data-go="next" class="primary">${final ? 'Descer às profundezas' : 'Descer'}</button>
      <button data-go="menu">Menu principal</button>`);
  }

  // ---------------- HUD ----------------
  floorTitle(n, name) {
    this.hud.classList.remove('hidden');
    $('#floorname').textContent = `Andar ${n} · ${name}`;
    this.bigTitle(`Andar ${n}`, name);
  }
  bigTitle(a, b) {
    const el = h('div', 'bigtitle', `<small>${a}</small>${b}`);
    this.root.appendChild(el);
    setTimeout(() => el.remove(), 4200);
  }
  toast(msg, color = '#e8e0d0', big = false) {
    const el = h('div', 'toast' + (big ? ' big' : ''), msg);
    el.style.color = color;
    const box = $('#toasts');
    box.appendChild(el);
    while (box.children.length > 4) box.firstChild.remove();
    setTimeout(() => { el.classList.add('out'); setTimeout(() => el.remove(), 600); }, big ? 3200 : 2600);
  }
  hurtFlash() { const e = $('#hurt'); e.classList.remove('on'); void e.offsetWidth; e.classList.add('on'); }
  makeFloat(text, color, big) { const el = h('div', 'float' + (big ? ' big' : ''), text); el.style.color = color; this.floats.appendChild(el); return el; }
  setBoss(b) { this.boss = b; $('#bossbar').classList.toggle('hidden', !b); if (b) { $('#bossname').textContent = b.B.name; this.bossGhost = 1; } }

  set(id, val, fn) { if (this.cache[id] !== val) { this.cache[id] = val; fn(val); } }
  update(g) {
    const p = g.player;
    const hpk = Math.max(0, p.hp / p.maxHp);
    this.set('hp', Math.round(hpk * 200), () => { $('#orbfill').style.transform = `translateY(${(1 - hpk) * 100}%)`; $('#orb').classList.toggle('low', hpk < 0.3); });
    this.set('hpt', `${Math.ceil(p.hp)}/${Math.round(p.maxHp)}`, v => $('#hptext').textContent = v);
    this.set('xp', Math.round(p.xp / p.xpNext * 100), v => $('#xpfill').style.width = v + '%');
    this.set('lvl', p.level, v => $('#lvl').textContent = 'Nível ' + v);
    this.set('arrows', p.arrows, v => { $('#arrows').textContent = v; $('#arrows').classList.toggle('empty', v === 0); });
    this.set('gold', p.gold, v => $('#gold').textContent = v);
    this.set('roll', p.rollCd > 0 ? Math.round(p.rollCd / p.rollMax * 20) : 0, v => { $('#rollpip').style.opacity = v ? 0.35 : 1; });
    this.cool('#s-potion', p.potionCd / p.potionMax, p.potionCd);
    for (let i = 0; i < 3; i++) {
      const a = p.equip.arts[i];
      this.set('art' + i, a ? a.id : 0, () => { const s = $('#s-art' + i); s.querySelector('.ico').innerHTML = a ? ICON[a.kind] : ''; s.classList.toggle('empty', !a); s.style.borderColor = a ? RARITY[a.rarity].color : ''; s.title = a ? a.name : ''; });
      this.cool('#s-art' + i, a ? p.artCd[i] / cdOf(a) : 0, p.artCd[i]);
    }
    // objetivo
    const lit = g.litCount, n = g.braziers.length;
    const obj = g.bossDead ? (g.portal ? 'Entre no portal para descer.' : 'O guardião caiu!') : g.bossActive ? `Derrote ${g.boss.B.name}.` : lit < n ? `Acenda os braseiros ancestrais: ${lit}/${n}` : 'Enfrente o guardião na grande arena.';
    this.set('obj', obj, v => $('#objective').textContent = v);
    // chefe
    if (this.boss) {
      const k = Math.max(0, this.boss.hp / this.boss.maxHp);
      this.bossGhost = Math.max(k, (this.bossGhost || 1) - 0.004);
      $('#bossfill').style.width = k * 100 + '%'; $('#bossghost').style.width = this.bossGhost * 100 + '%';
    }
    // prompt de interacao
    const near = g.near;
    const key = near ? (near.kind === 'item' ? 'i' + near.data.id + ':' + g.player.equip.arts.map(a => a && a.id).join() : near.prompt) : '';
    this.set('prompt', key, () => this.renderPrompt(g, near));
    this.drawMinimap(g);
    this.enemyBars(g);
  }
  enemyBars(g) {
    const box = this.barsBox || (this.barsBox = $('#bars'));
    this.barPool = this.barPool || [];
    const cam = g.camera, p = g.player, w = innerWidth, hh = innerHeight;
    const list = [];
    for (const e of g.enemies) {
      if (e.dead || e.isBoss || !e.awake || e.hp >= e.maxHp || !e.rig.root.visible) continue;
      if (Math.abs(e.x - p.x) + Math.abs(e.z - p.z) > 26) continue;
      list.push(e);
      if (list.length >= 24) break;
    }
    const v = this._v || (this._v = cam.position.clone());
    for (let i = 0; i < Math.max(list.length, this.barPool.length); i++) {
      let el = this.barPool[i];
      if (!el) { el = h('div', 'ebar', '<i></i>'); box.appendChild(el); this.barPool.push(el); }
      const e = list[i];
      if (!e) { if (el._on) { el.style.display = 'none'; el._on = false; } continue; }
      if (!el._on) { el.style.display = ''; el._on = true; }
      v.set(e.x, e.y + 1.35 * e.rig.root.scale.y + 0.75, e.z).project(cam);
      el.style.transform = `translate(${(v.x * 0.5 + 0.5) * w}px, ${(-v.y * 0.5 + 0.5) * hh}px) translate(-50%, -50%)`;
      el.firstChild.style.width = Math.max(0, e.hp / e.maxHp * 100) + '%';
      el.classList.toggle('elite', !!e.elite);
    }
  }
  cool(sel, k, secs) {
    const el = $(sel);
    const v = Math.round(Math.max(0, k) * 60);
    if (el._v === v) return; el._v = v;
    el.querySelector('.cd').style.height = (Math.max(0, Math.min(1, k)) * 100) + '%';
    el.classList.toggle('ready', v === 0);
  }
  renderPrompt(g, near) {
    const el = $('#prompt');
    if (!near) { el.classList.add('hidden'); return; }
    el.classList.remove('hidden');
    if (near.kind !== 'item') { el.className = 'simple'; el.innerHTML = `<kbd>E</kbd> ${near.prompt}`; return; }
    const it = near.data, R = RARITY[it.rarity], p = g.player;
    let cur = null, slotTxt = '';
    if (it.cat === 'artifact') {
      const empty = p.equip.arts.findIndex(a => !a);
      if (empty < 0) {
        let ws = 1e9, slot = 0; p.equip.arts.forEach((a, i) => { const s = scoreOf(a); if (s < ws) { ws = s; slot = i; } });
        cur = p.equip.arts[slot];
        slotTxt = `<div class="hint">Substitui o slot ${slot + 1}. Segure <kbd>E</kbd> e aperte <kbd>1</kbd>-<kbd>3</kbd> para escolher outro.</div>`;
      }
    } else cur = p.equip[it.cat];
    const lines = statLines(it), curLines = cur && cur.cat === it.cat ? statLines(cur) : null;
    const num = (s) => parseFloat(String(s).replace(',', '.').replace('+', ''));
    const rows = lines.map(([k, v], i) => {
      let d = '';
      if (curLines && curLines[i] && curLines[i][0] === k) {
        const a = num(v), b = num(curLines[i][1]);
        if (!isNaN(a) && !isNaN(b) && Math.abs(a - b) > 0.01) {
          const better = k === 'Recarga' ? a < b : a > b;
          d = `<i class="${better ? 'up' : 'dn'}">${better ? '▲' : '▼'}</i>`;
        }
      }
      return `<tr><td>${k}</td><td>${v} ${d}</td></tr>`;
    }).join('');
    const aff = affixText(it).map(t => `<li>${t}</li>`).join('');
    const desc = it.cat === 'artifact' ? `<div class="desc">${ARTIFACTS[it.kind].desc}</div>` : '';
    const delta = cur ? scoreOf(it) - scoreOf(cur) : 1;
    el.className = 'item';
    el.innerHTML = `<div class="ititle" style="color:${R.color}">${it.name}</div>
      <div class="icat">${R.name} · ${catName(it.cat)}</div>${desc}
      <table>${rows}</table>${aff ? `<ul>${aff}</ul>` : ''}
      ${cur ? `<div class="vs">Equipado: <span style="color:${RARITY[cur.rarity].color}">${cur.name}</span> ${delta > 0.5 ? '<i class="up">melhor</i>' : delta < -0.5 ? '<i class="dn">pior</i>' : ''}</div>` : ''}
      ${slotTxt}<div class="act"><kbd>E</kbd> Equipar</div>`;
    el.style.borderColor = R.color;
  }

  // ---------------- minimapa ----------------
  buildMinimap(g) {
    const dg = g.dg, S = 3;
    this.off = document.createElement('canvas'); this.off.width = dg.W * S; this.off.height = dg.D * S;
    this.minimapDirty = true;
  }
  drawMinimap(g) {
    const dg = g.dg, S = 3, off = this.off;
    if (!off) return;
    if (this.minimapDirty) {
      this.minimapDirty = false;
      const c = off.getContext('2d');
      c.clearRect(0, 0, off.width, off.height);
      const b = dg.boss;
      for (let z = 0; z < dg.D; z++) for (let x = 0; x < dg.W; x++) {
        const i = x + z * dg.W;
        if (!g.explored[i]) continue;
        const t = dg.cell[i];
        let col = null;
        if (t === C.FLOOR) {
          const inBoss = x >= b.x && x < b.x + b.w && z >= b.z && z < b.z + b.d;
          col = inBoss ? '#8a5a50' : dg.h[i] > 0 ? '#a89a86' : '#857a6c';
        } else if (t === C.WALL) col = '#2e2925';
        else if (t === C.PILLAR) col = '#3a342e';
        else if (t === C.WATER) col = '#2c5a68';
        else if (t === C.LAVA) col = '#d05a1a';
        else if (t === C.PIT) col = '#0c0b0a';
        if (col) { c.fillStyle = col; c.fillRect(x * S, z * S, S, S); }
      }
    }
    const ctx = this.mctx, W = this.mm.width, p = g.player;
    ctx.clearRect(0, 0, W, W);
    ctx.save();
    ctx.beginPath(); ctx.arc(W / 2, W / 2, W / 2 - 2, 0, Math.PI * 2); ctx.clip();
    ctx.fillStyle = 'rgba(8,7,6,0.8)'; ctx.fillRect(0, 0, W, W);
    ctx.translate(W / 2, W / 2); ctx.rotate(Math.PI / 4); ctx.scale(1.15, 1.15);
    ctx.translate(-p.x * S, -p.z * S);
    ctx.drawImage(off, 0, 0);
    const dot = (x, z, r, col, stroke) => { ctx.beginPath(); ctx.arc(x * S, z * S, r, 0, Math.PI * 2); ctx.fillStyle = col; ctx.fill(); if (stroke) { ctx.strokeStyle = stroke; ctx.lineWidth = 1.5; ctx.stroke(); } };
    const ex = (x, z) => g.explored[Math.floor(x) + Math.floor(z) * dg.W];
    for (const c of g.chests) if (!c.opened && ex(c.x, c.z)) dot(c.x, c.z, 3, '#e8b440');
    for (const l of g.loot) if (l.kind === 'item') dot(l.x, l.z, 2.5, RARITY[l.data.rarity].color);
    if (g.altar && ex(g.altar.x, g.altar.z)) dot(g.altar.x, g.altar.z, 3.5, '#ffd36a', '#fff');
    for (const e of g.enemies) if (!e.dead && e.awake && !e.isBoss && Math.hypot(e.x - p.x, e.z - p.z) < 24) dot(e.x, e.z, 2, '#e04030');
    const t = performance.now() / 1000;
    for (const b of g.braziers) dot(b.x, b.z, b.lit ? 4.5 : 3.5 + Math.sin(t * 4), b.lit ? '#ffcc50' : '#ff7a20', b.lit ? '#fff' : '#3a1a08');
    const bb = dg.boss;
    if (g.litCount >= g.braziers.length && !g.bossDead) {
      ctx.save(); ctx.translate((bb.x + bb.w / 2) * S, (bb.z + bb.d / 2) * S); ctx.rotate(-Math.PI / 4);
      ctx.font = 'bold 16px serif'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle'; ctx.fillStyle = '#ff5a40'; ctx.fillText('☠', 0, 0); ctx.restore();
    }
    if (g.boss && g.bossActive) dot(g.boss.x, g.boss.z, 5, '#ff3020', '#fff');
    if (g.portal) dot(g.portal.x, g.portal.z, 5 + Math.sin(t * 5), '#6fd8ff', '#fff');
    if (g.gates.closed) { ctx.fillStyle = '#c03020'; for (const c of dg.gates) if (ex(c.x, c.z)) ctx.fillRect(c.x * S, c.z * S, S, S); }
    // jogador
    ctx.save(); ctx.translate(p.x * S, p.z * S); ctx.rotate(Math.atan2(Math.cos(p.rot), Math.sin(p.rot)));
    ctx.beginPath(); ctx.moveTo(7, 0); ctx.lineTo(-4, 4.5); ctx.lineTo(-2, 0); ctx.lineTo(-4, -4.5); ctx.closePath();
    ctx.fillStyle = '#fff'; ctx.fill(); ctx.strokeStyle = '#1a3a7a'; ctx.lineWidth = 1.5; ctx.stroke();
    ctx.restore();
    ctx.restore();
  }
}
