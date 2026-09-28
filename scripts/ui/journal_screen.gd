class_name JournalScreen
extends Control
## Diário: Missões (ativas/concluídas, objetivos), Gravações da Dra. Helena
## (reouvir), Documentos, Pessoas (sobreviventes conhecidos), Facções e
## Estatísticas.

signal closed

var game: Node
var tabs: TabContainer
var mission_list: ItemList
var mission_detail: RichTextLabel
var _mission_ids: Array = []


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.6))
	var p := UIKit.panel(18)
	p.custom_minimum_size = Vector2(1200, 700)
	var v := UIKit.vbox(8)
	p.add_child(v)
	v.add_child(UIKit.title("DIÁRIO", 26))
	tabs = TabContainer.new()
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.custom_minimum_size = Vector2(1160, 600)
	v.add_child(tabs)
	_build_missions()
	_build_logs()
	_build_notes()
	_build_people()
	_build_factions()
	_build_stats()
	add_child(UIKit.center(p))
	EventBus.ui_screen_opened.emit("journal")


func _build_missions() -> void:
	var h := UIKit.hbox(12)
	h.name = "Missões"
	mission_list = ItemList.new()
	mission_list.custom_minimum_size = Vector2(400, 560)
	mission_list.item_selected.connect(_on_mission)
	h.add_child(mission_list)
	var dv := UIKit.vbox(8)
	dv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_detail = RichTextLabel.new()
	mission_detail.bbcode_enabled = true
	mission_detail.custom_minimum_size = Vector2(700, 500)
	dv.add_child(mission_detail)
	dv.add_child(UIKit.button("Rastrear esta missão", _track, 260))
	h.add_child(dv)
	tabs.add_child(h)
	_mission_ids.clear()
	for id in MissionManager.active.keys():
		var m := MissionDB.get_mission(id)
		var i := mission_list.add_item(("◆ " if id == MissionManager.tracked else "   ") + str(m["title"]) + ("" if str(m["type"]) == "main" else "  (secundária)"))
		mission_list.set_item_custom_fg_color(i, UITheme.ACCENT if str(m["type"]) == "main" else UITheme.TEXT)
		_mission_ids.append(id)
	for id in MissionManager.completed.keys():
		var m := MissionDB.get_mission(id)
		var i := mission_list.add_item("✔ " + str(m["title"]))
		mission_list.set_item_custom_fg_color(i, UITheme.TEXT_DIM)
		_mission_ids.append(id)
	for id in MissionManager.failed.keys():
		var m := MissionDB.get_mission(id)
		var i := mission_list.add_item("✖ " + str(m["title"]))
		mission_list.set_item_custom_fg_color(i, UITheme.DANGER)
		_mission_ids.append(id)
	if mission_list.item_count > 0:
		mission_list.select(0)
		_on_mission(0)


func _on_mission(i: int) -> void:
	var id: String = _mission_ids[i]
	var m := MissionDB.get_mission(id)
	var t := "[b][color=#dcb86a]%s[/color][/b]\n[color=#999999]Capítulo %d — %s[/color]\n\n%s\n\n" % [m["title"], int(m.get("chapter", 1)),
		StoryDB.CHAPTERS.get(int(m.get("chapter", 1)), {}).get("title", ""), m.get("desc", "")]
	for o in m.get("objectives", []):
		var done := MissionManager.is_objective_done(id, str(o["id"]))
		var col := "#8fbf8f" if done else "#e6e0d0"
		t += "[color=%s]%s %s[/color]\n" % [col, "✔" if done else "○", MissionManager.objective_text(id, o)]
	mission_detail.text = t


func _track() -> void:
	var sel := mission_list.get_selected_items()
	if sel.is_empty():
		return
	var id: String = _mission_ids[sel[0]]
	if MissionManager.is_active(id):
		MissionManager.tracked = id
		EventBus.mission_updated.emit(id)
		EventBus.toast("Rastreando: " + str(MissionDB.get_mission(id)["title"]), "mission")


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
		var h := UIKit.hbox(10)
		var l := UIKit.label(("%s — %s" % [d["title"], d["date"]]) if found else "??? — gravação não encontrada", 16, UITheme.TEXT if found else UITheme.TEXT_DIM)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(l)
		if found:
			var lid: String = id
			h.add_child(UIKit.button("Ouvir", func() -> void:
				StoryManager.play_log(lid)
				close(), 110, 15))
			h.add_child(UIKit.button("Transcrição", func() -> void: _show_text(str(d["title"]), "\n".join(d["lines"])), 150, 15))
		v.add_child(h)
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
		var h := UIKit.hbox(10)
		var l := UIKit.label(str(d.get("title", id)), 16)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(l)
		h.add_child(UIKit.button("Ler", func() -> void: _show_text(str(d.get("title", "")), str(d.get("text", ""))), 110, 15))
		v.add_child(h)
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
		var pn := UIKit.panel(10)
		var pv := UIKit.vbox(2)
		pn.add_child(pv)
		pv.add_child(UIKit.label("%s%s" % [d["name"], ("  — " + FactionManager.faction_name(str(d["faction"]))) if str(d.get("faction", "")) != "" else ""], 17, UITheme.ACCENT))
		var bio := UIKit.label(str(d.get("bio", "")), 14)
		bio.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		bio.custom_minimum_size = Vector2(1080, 0)
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
		var pn := UIKit.panel(10)
		var pv := UIKit.vbox(3)
		pn.add_child(pv)
		var h := UIKit.hbox(10)
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
		var rb := UIKit.bar(d["color"].lightened(0.2), 200.0)
		rb.value = FactionManager.rep(f) + 100.0
		rb.custom_minimum_size = Vector2(400, 6)
		pv.add_child(rb)
		v.add_child(pn)
	tabs.add_child(sc)


func _poi_name(id: String) -> String:
	if game and game.world and game.world.layout.pois.has(id):
		return str(game.world.layout.pois[id]["name"])
	return id


func _build_stats() -> void:
	var v := UIKit.vbox(6)
	v.name = "Estatísticas"
	var s := GameState.stats
	var pt := GameState.playtime
	var lines := [
		["Tempo de jogo", "%dh %02dmin" % [int(pt / 3600.0), int(fmod(pt / 60.0, 60.0))]],
		["Dias sobrevividos", str(TimeManager.day)],
		["Infectados abatidos", str(int(s.get("infected_killed", 0)))],
		["Itens fabricados", str(int(s.get("crafted", 0)))],
		["Estruturas construídas", str(int(s.get("built", 0)))],
		["Contêineres revistados", str(int(s.get("looted", 0)))],
		["Locais descobertos", str(GameState.discovered.size())],
		["Gravações encontradas", "%d/%d" % [GameState.logs_found.size(), StoryDB.LOGS.size()]],
		["Mortes", str(int(s.get("deaths", 0)))],
	]
	for l in lines:
		var h := UIKit.hbox(10)
		var a := UIKit.label(str(l[0]), 16, UITheme.TEXT_DIM)
		a.custom_minimum_size = Vector2(320, 0)
		h.add_child(a)
		h.add_child(UIKit.label(str(l[1]), 16))
		v.add_child(h)
	tabs.add_child(v)


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
