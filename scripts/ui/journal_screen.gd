class_name JournalScreen
extends Control
## Diário: Missões (cartões com progresso dos objetivos), Progresso (capítulo,
## história, descobertas e estatísticas), Gravações da Dra. Helena (reouvir),
## Documentos, Pessoas (sobreviventes conhecidos) e Facções.

signal closed

var game: Node
var tabs: TabContainer
var mission_list: VBoxContainer
var mission_detail: VBoxContainer
var track_btn: Button
var _mission_ids: Array = []
var _sel_mission: String = ""


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.6))
	var p := UIKit.window(18)
	p.custom_minimum_size = Vector2(1300, 760)
	var v := UIKit.vbox(10)
	p.add_child(v)
	var ch: Dictionary = StoryDB.CHAPTERS.get(GameState.chapter, {})
	v.add_child(UIKit.header("book", "DIÁRIO", "Capítulo %d — %s" % [GameState.chapter, str(ch.get("title", ""))], "J", "Fechar"))
	tabs = TabContainer.new()
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.custom_minimum_size = Vector2(1260, 640)
	v.add_child(tabs)
	_build_missions()
	_build_progress()
	_build_logs()
	_build_notes()
	_build_people()
	_build_factions()
	add_child(UIKit.center(p))
	EventBus.ui_screen_opened.emit("journal")


func _build_missions() -> void:
	var h := UIKit.hbox(14)
	h.name = "Missões"
	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(440, 560)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mission_list = UIKit.vbox(6)
	mission_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(mission_list)
	h.add_child(sc)
	var dc := UIKit.card(18)
	dc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var dv := UIKit.vbox(10)
	dc.add_child(dv)
	mission_detail = UIKit.vbox(8)
	mission_detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dv.add_child(mission_detail)
	track_btn = UIKit.button("Rastrear esta missão", _track, 260)
	dv.add_child(track_btn)
	h.add_child(dc)
	tabs.add_child(h)
	_mission_ids.clear()
	var groups := [["Em andamento", MissionManager.active.keys(), "active"], ["Concluídas", MissionManager.completed.keys(), "done"],
		["Fracassadas", MissionManager.failed.keys(), "failed"]]
	for gr in groups:
		var ids: Array = gr[1]
		if ids.is_empty():
			continue
		# principais primeiro
		ids.sort_custom(func(a, b) -> bool: return str(MissionDB.get_mission(a)["type"]) == "main" and str(MissionDB.get_mission(b)["type"]) != "main")
		mission_list.add_child(UIKit.section("%s (%d)" % [gr[0], ids.size()]))
		for id in ids:
			mission_list.add_child(_mission_card(str(id), str(gr[2])))
			_mission_ids.append(id)
	if _mission_ids.is_empty():
		mission_list.add_child(UIKit.label("Nenhuma missão ainda.", 15, UITheme.TEXT_DIM))
	else:
		var first: String = MissionManager.tracked if MissionManager.tracked in _mission_ids else str(_mission_ids[0])
		_on_mission(first)


func _obj_progress(id: String) -> Vector2i:
	var m := MissionDB.get_mission(id)
	var total := 0
	var done := 0
	for o in m.get("objectives", []):
		if bool(o.get("optional", false)):
			continue
		total += 1
		if MissionManager.completed.has(id) or MissionManager.is_objective_done(id, str(o["id"])):
			done += 1
	return Vector2i(done, maxi(total, 1))


func _mission_card(id: String, status: String) -> Button:
	var m := MissionDB.get_mission(id)
	var main := str(m["type"]) == "main"
	var b := Button.new()
	b.toggle_mode = true
	b.custom_minimum_size = Vector2(420, 78)
	b.name = "M_" + id
	var inner := UIKit.vbox(4)
	inner.set_anchors_preset(Control.PRESET_FULL_RECT)
	inner.offset_left = 14
	inner.offset_right = -12
	inner.offset_top = 8
	inner.offset_bottom = -8
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var top := UIKit.hbox(8)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var gl := "star" if main else "flag"
	if status == "done":
		gl = "check"
	var col := UITheme.ACCENT if main else UITheme.TEXT
	if status == "done":
		col = UITheme.GOOD
	elif status == "failed":
		col = UITheme.DANGER
	top.add_child(UIGlyph.make(gl, 18, col))
	var tl := UIKit.label(str(m["title"]), 17, col if status != "done" else UITheme.TEXT_DIM)
	tl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	top.add_child(tl)
	if id == MissionManager.tracked:
		top.add_child(UIKit.chip("Rastreando", UITheme.ACCENT, 12))
	else:
		top.add_child(UIKit.chip("Principal" if main else "Secundária", UITheme.ACCENT if main else UITheme.TEXT_DIM, 12))
	inner.add_child(top)
	var pr := _obj_progress(id)
	var ph := UIKit.hbox(8)
	ph.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bar := UIKit.bar(UITheme.GOOD if status == "done" else UITheme.ACCENT, float(pr.y))
	bar.value = pr.x
	bar.custom_minimum_size = Vector2(250, 7)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ph.add_child(bar)
	var pl := UIKit.label("%d/%d objetivos" % [pr.x, pr.y], 13, UITheme.TEXT_DIM)
	pl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ph.add_child(pl)
	inner.add_child(ph)
	b.add_child(inner)
	b.pressed.connect(func() -> void: _on_mission(id))
	return b


func _on_mission(id: String) -> void:
	_sel_mission = id
	for c in mission_list.get_children():
		if c is Button:
			(c as Button).button_pressed = c.name == "M_" + id
	for c in mission_detail.get_children():
		c.queue_free()
	var m := MissionDB.get_mission(id)
	var ch := int(m.get("chapter", 1))
	var th := UIKit.hbox(10)
	th.add_child(UIKit.title(str(m["title"]), 26))
	var st := "Concluída" if MissionManager.completed.has(id) else ("Fracassada" if MissionManager.failed.has(id) else "Em andamento")
	var sc := UITheme.GOOD if st == "Concluída" else (UITheme.DANGER if st == "Fracassada" else UITheme.ACCENT)
	var chip := UIKit.chip(st, sc, 13)
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	th.add_child(chip)
	mission_detail.add_child(th)
	mission_detail.add_child(UIKit.label("Capítulo %d — %s" % [ch, StoryDB.CHAPTERS.get(ch, {}).get("title", "")], 15, UITheme.TEXT_DIM))
	var desc := UIKit.label(str(m.get("desc", "")), 17)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(700, 0)
	mission_detail.add_child(desc)
	mission_detail.add_child(UIKit.spacer(4))
	mission_detail.add_child(UIKit.section("Objetivos"))
	for o in m.get("objectives", []):
		var done := MissionManager.completed.has(id) or MissionManager.is_objective_done(id, str(o["id"]))
		var oh := UIKit.hbox(10)
		oh.add_child(UIGlyph.make("check" if done else "target", 18, UITheme.GOOD if done else UITheme.TEXT_DIM))
		var ol := UIKit.label(MissionManager.objective_text(id, o), 16, UITheme.TEXT_DIM if done else UITheme.TEXT)
		ol.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ol.custom_minimum_size = Vector2(640, 0)
		oh.add_child(ol)
		mission_detail.add_child(oh)
	track_btn.visible = MissionManager.is_active(id)
	track_btn.disabled = id == MissionManager.tracked
	track_btn.text = "Rastreando" if id == MissionManager.tracked else "Rastrear esta missão"


func _track() -> void:
	var id := _sel_mission
	if id != "" and MissionManager.is_active(id):
		MissionManager.tracked = id
		EventBus.mission_updated.emit(id)
		EventBus.toast("Rastreando: " + str(MissionDB.get_mission(id)["title"]), "mission")
		_on_mission(id)


## Progresso: capítulo atual, história, descobertas e estatísticas.
func _build_progress() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Progresso"
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var v := UIKit.vbox(12)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	# capítulos
	var cc := UIKit.card(16, UITheme.ACCENT)
	var cv := UIKit.vbox(8)
	cc.add_child(cv)
	var nch := StoryDB.CHAPTERS.size()
	var chd: Dictionary = StoryDB.CHAPTERS.get(GameState.chapter, {})
	cv.add_child(UIKit.label("CAPÍTULO %d DE %d" % [GameState.chapter, nch], 13, UITheme.ACCENT))
	cv.add_child(UIKit.title(str(chd.get("title", "")), 28))
	cv.add_child(UIKit.label(str(chd.get("sub", "")), 16, UITheme.TEXT_DIM))
	var steps := UIKit.hbox(6)
	for c in range(1, nch + 1):
		var seg := ColorRect.new()
		seg.custom_minimum_size = Vector2(0, 8)
		seg.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		seg.color = UITheme.GOOD if c < GameState.chapter else (UITheme.ACCENT if c == GameState.chapter else Color(0.2, 0.2, 0.2))
		seg.tooltip_text = "%d — %s" % [c, StoryDB.CHAPTERS[c]["title"]]
		steps.add_child(seg)
	cv.add_child(steps)
	v.add_child(cc)
	# história principal e descobertas
	var mains := 0
	var mains_done := 0
	for id in MissionDB.MISSIONS.keys():
		if str(MissionDB.MISSIONS[id].get("type", "")) == "main":
			mains += 1
			if MissionManager.completed.has(id):
				mains_done += 1
	var side_done := MissionManager.completed.size() - mains_done
	var pois := 0
	if game and game.world:
		pois = game.world.layout.pois.size()
	var bars := [
		["star", "História principal", mains_done, maxi(mains, 1), UITheme.ACCENT],
		["flag", "Locais descobertos", GameState.discovered.size(), maxi(pois, 1), Color(0.6, 0.75, 0.9)],
		["cassette", "Gravações da Dra. Helena", GameState.logs_found.size(), StoryDB.LOGS.size(), Color(0.75, 0.6, 0.9)],
		["document", "Documentos encontrados", GameState.notes_found.size(), maxi(StoryDB.NOTES.size(), 1), Color(0.85, 0.8, 0.6)],
	]
	var pc := UIKit.card(16)
	var pv := UIKit.vbox(10)
	pc.add_child(pv)
	pv.add_child(UIKit.section("Andamento"))
	for b in bars:
		var m := UIKit.meter(str(b[0]), "", b[4], 400.0, float(b[3]))
		var row: HBoxContainer = m[0]
		(row.get_child(1) as Label).text = str(b[1])
		(row.get_child(1) as Label).custom_minimum_size = Vector2(230, 0)
		(m[1] as ProgressBar).value = float(b[2])
		(m[2] as Label).text = "%d/%d" % [int(b[2]), int(b[3])]
		(m[2] as Label).custom_minimum_size = Vector2(70, 0)
		pv.add_child(row)
	v.add_child(pc)
	# estatísticas em cartões
	var s := GameState.stats
	var pt := GameState.playtime
	var stats := [
		["sun", "Dias sobrevividos", str(TimeManager.day)],
		["target", "Tempo de jogo", "%dh %02dmin" % [int(pt / 3600.0), int(fmod(pt / 60.0, 60.0))]],
		["knife", "Infectados abatidos", str(int(s.get("infected_killed", 0)))],
		["eye", "Abates furtivos", str(int(s.get("stealth_kills", 0)))],
		["wrench", "Itens fabricados", str(int(s.get("crafted", 0)))],
		["crate", "Estruturas construídas", str(int(s.get("built", 0)))],
		["backpack", "Contêineres revistados", str(int(s.get("looted", 0)))],
		["check", "Missões secundárias", str(maxi(side_done, 0))],
		["heart", "Mortes", str(int(s.get("deaths", 0)))],
	]
	v.add_child(UIKit.section("Estatísticas"))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	for st in stats:
		var card := UIKit.card(12)
		card.custom_minimum_size = Vector2(390, 74)
		var h := UIKit.hbox(12)
		card.add_child(h)
		var g := UIGlyph.make(str(st[0]), 34, UITheme.ACCENT.darkened(0.1))
		g.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(g)
		var sv := UIKit.vbox(0)
		sv.add_child(UIKit.label(str(st[2]), 24))
		sv.add_child(UIKit.label(str(st[1]), 13, UITheme.TEXT_DIM))
		h.add_child(sv)
		grid.add_child(card)
	v.add_child(grid)
	tabs.add_child(sc)


func _build_logs() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Gravações"
	var v := UIKit.vbox(6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	v.add_child(UIKit.label("Gravações da Dra. Helena Vasconcelos (%d/%d)" % [GameState.logs_found.size(), StoryDB.LOGS.size()], 16, UITheme.TEXT_DIM))
	for id in StoryDB.LOGS.keys():
		var d: Dictionary = StoryDB.LOGS[id]
		var found := GameState.logs_found.has(id)
		var card := UIKit.card(10, Color(0.75, 0.6, 0.9) if found else Color(0, 0, 0, 0))
		var h := UIKit.hbox(10)
		card.add_child(h)
		h.add_child(UIGlyph.make("cassette", 28, Color(0.75, 0.6, 0.9) if found else Color(0.3, 0.3, 0.3)))
		var l := UIKit.label(("%s — %s" % [d["title"], d["date"]]) if found else "??? — gravação não encontrada", 16, UITheme.TEXT if found else UITheme.TEXT_DIM)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(l)
		if found:
			var lid: String = id
			h.add_child(UIKit.button("Ouvir", func() -> void:
				StoryManager.play_log(lid)
				close(), 110, 15))
			h.add_child(UIKit.button("Transcrição", func() -> void: _show_text(str(d["title"]), "\n".join(d["lines"])), 150, 15))
		v.add_child(card)
	tabs.add_child(sc)


func _build_notes() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Documentos"
	var v := UIKit.vbox(6)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	if GameState.notes_found.is_empty():
		v.add_child(UIKit.label("Nenhum documento encontrado.", 16, UITheme.TEXT_DIM))
	for id in GameState.notes_found:
		var d := StoryDB.note_def(str(id))
		var card := UIKit.card(10, Color(0.85, 0.8, 0.6))
		var h := UIKit.hbox(10)
		card.add_child(h)
		h.add_child(UIGlyph.make("document", 26, Color(0.85, 0.8, 0.6)))
		var l := UIKit.label(str(d.get("title", id)), 16)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(l)
		h.add_child(UIKit.button("Ler", func() -> void: _show_text(str(d.get("title", "")), str(d.get("text", ""))), 110, 15))
		v.add_child(card)
	tabs.add_child(sc)


func _build_people() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Pessoas"
	var v := UIKit.vbox(8)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	var sm: SurvivorManager = game.survivors if game else null
	var any := false
	for id in NPCDB.NAMED.keys():
		if sm == null or not sm.memory.has(id) or not bool(sm.memory[id].get("met", false)):
			continue
		any = true
		var d := NPCDB.named(id)
		var m: Dictionary = sm.memory[id]
		var rel := float(m.get("rel", 0.0))
		var rel_t := "Confia em você" if rel > 40.0 else ("Amigável" if rel > 10.0 else ("Neutro" if rel > -20.0 else "Desconfiado"))
		var alive := bool(m.get("alive", true))
		var pn := UIKit.card(12, (UITheme.GOOD if rel > 10.0 else (UITheme.DANGER if rel < -20.0 else UITheme.TEXT_DIM)) if alive else Color(0.3, 0.3, 0.3))
		var ph := UIKit.hbox(12)
		pn.add_child(ph)
		ph.add_child(UIGlyph.make("people", 34, UITheme.ACCENT if alive else Color(0.4, 0.4, 0.4)))
		var pv := UIKit.vbox(2)
		ph.add_child(pv)
		pv.add_child(UIKit.label("%s%s" % [d["name"], ("  — " + FactionManager.faction_name(str(d["faction"]))) if str(d.get("faction", "")) != "" else ""], 17, UITheme.ACCENT))
		var bio := UIKit.label(str(d.get("bio", "")), 14)
		bio.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		bio.custom_minimum_size = Vector2(1100, 0)
		pv.add_child(bio)
		pv.add_child(UIKit.label("%s%s" % [rel_t, "" if bool(m.get("alive", true)) else "  ·  MORTO"], 13, UITheme.TEXT_DIM))
		v.add_child(pn)
	if not any:
		v.add_child(UIKit.label("Você ainda não conheceu ninguém.", 16, UITheme.TEXT_DIM))
	tabs.add_child(sc)


func _build_factions() -> void:
	var sc := ScrollContainer.new()
	sc.name = "Facções"
	var v := UIKit.vbox(10)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(v)
	for f in FactionManager.DEFS.keys():
		var d: Dictionary = FactionManager.DEFS[f]
		var st: Dictionary = FactionManager.state.get(f, {})
		var pn := UIKit.card(12, d["color"].lightened(0.2))
		var pv := UIKit.vbox(4)
		pn.add_child(pv)
		var h := UIKit.hbox(10)
		h.add_child(UIGlyph.make("flag", 22, d["color"].lightened(0.35)))
		var nl := UIKit.label(str(d["name"]), 18, d["color"].lightened(0.35))
		nl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(nl)
		var att := FactionManager.attitude(f)
		h.add_child(UIKit.label({"hostile": "HOSTIL", "wary": "Desconfiados", "neutral": "Neutros", "friendly": "Aliados"}[att], 15,
			UITheme.DANGER if att == "hostile" else (UITheme.GOOD if att == "friendly" else UITheme.TEXT)))
		pv.add_child(h)
		var desc := UIKit.label(str(d["desc"]), 14)
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.custom_minimum_size = Vector2(1080, 0)
		pv.add_child(desc)
		pv.add_child(UIKit.label("Líder: %s  ·  Base: %s  ·  Membros: %d  ·  Objetivo: %s" % [d["leader"], _poi_name(str(d["hq"])), int(st.get("members", 0)), d["goal"]], 13, UITheme.TEXT_DIM))
		var rh := UIKit.hbox(8)
		rh.add_child(UIKit.label("Reputação", 13, UITheme.TEXT_DIM))
		var rb := UIKit.bar(d["color"].lightened(0.2), 200.0)
		rb.value = FactionManager.rep(f) + 100.0
		rb.custom_minimum_size = Vector2(400, 8)
		rb.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		rh.add_child(rb)
		rh.add_child(UIKit.label("%+d" % int(FactionManager.rep(f)), 13, UITheme.TEXT))
		pv.add_child(rh)
		v.add_child(pn)
	tabs.add_child(sc)


func _poi_name(id: String) -> String:
	if game and game.world and game.world.layout.pois.has(id):
		return str(game.world.layout.pois[id]["name"])
	return id


func _show_text(title: String, text: String) -> void:
	var r := ReadableScreen.new()
	r.title_text = title
	r.body_text = text
	add_child(r)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("journal") or event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		for c in get_children():
			if c is ReadableScreen:
				return
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("journal")
	closed.emit()
	queue_free()
