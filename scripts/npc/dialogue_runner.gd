class_name DialogueRunner
extends RefCounted
## Executa uma árvore de DialogueDB para um NPC: escolhe o nó inicial,
## filtra opções por condição e aplica as ações escolhidas.

signal node_changed(text: String, options: Array)
signal finished
signal trade_opened(npc: SurvivorNPC)

var npc: SurvivorNPC
var player: Player
var manager: SurvivorManager
var tree: Dictionary
var node_id: String = ""
var options: Array = []


func _init(n: SurvivorNPC, p: Player, m: SurvivorManager) -> void:
	npc = n
	player = p
	manager = m
	tree = DialogueDB.tree(n.npc_id if n.named else "_generic")


func start() -> void:
	npc.begin_talk()
	if manager:
		manager.mark_met(npc.npc_id)
	for e in tree["entry"]:
		var ed: Dictionary = e
		if check(ed.get("if", {})):
			goto(str(ed["node"]))
			return
	goto(str(tree["entry"][-1]["node"]))


func goto(id: String) -> void:
	node_id = id
	var n: Dictionary = tree["nodes"].get(id, {})
	if n.is_empty():
		end()
		return
	var text := _resolve_text(str(n["text"]))
	options = []
	for o in n.get("opts", []):
		var od: Dictionary = o
		if check(od.get("if", {})):
			options.append(od)
	if options.is_empty():
		options.append({"t": "(Sair)", "do": {"end": true}})
	node_changed.emit(text, options)


func choose(index: int) -> void:
	if index < 0 or index >= options.size():
		return
	var o: Dictionary = options[index]
	var act: Dictionary = o.get("do", {})
	apply(act)
	if act.get("end", false) or act.get("trade", false):
		end()
		if act.get("trade", false):
			trade_opened.emit(npc)
		return
	if o.has("next"):
		goto(str(o["next"]))
	else:
		end()


func end() -> void:
	if npc and is_instance_valid(npc):
		npc.end_talk()
	finished.emit()


func _resolve_text(t: String) -> String:
	var r := Util.hash_str(npc.npc_id) + TimeManager.day * 7 + int(TimeManager.hour)
	match t:
		"RUMOR":
			return DialogueDB.rumor(r)
		"GREETING":
			var att := npc.attitude()
			var base := NPCDB.bark("greet_friendly" if att == "friendly" else "greet_neutral")
			if npc.faction != "":
				base += "  [%s]" % FactionManager.faction_name(npc.faction)
			if TimeManager.is_night():
				base += " " + NPCDB.bark("night")
			return base
		"STATUS":
			var st: Dictionary = FactionManager.state.get("remanescentes", {})
			var res: Dictionary = st.get("resources", {})
			var food := float(res.get("food", 0.0))
			var meds := float(res.get("meds", 0.0))
			var s := "Somos %d pessoas. " % int(st.get("members", 0))
			s += "Comida para poucos dias. " if food < 30.0 else "A comida está dando, por enquanto. "
			s += "Remédios quase acabando." if meds < 5.0 else "Remédio, temos o básico."
			return s
	return t


# ---------------------------------------------------------------------------
# Condições
# ---------------------------------------------------------------------------
func check(c: Dictionary) -> bool:
	for k in c.keys():
		var v = c[k]
		match str(k):
			"mission_obj":
				var mid: String = v[0]
				var ok := false
				for o in MissionManager.open_objectives(mid):
					if str(o["id"]) == str(v[1]):
						ok = true
				if not ok:
					return false
			"mission_active":
				if not MissionManager.is_active(str(v)):
					return false
			"mission_done":
				if not MissionManager.is_done(str(v)):
					return false
			"flag":
				if not GameState.has_flag(str(v)) or GameState.get_flag(str(v)) == false:
					return false
			"not_flag":
				if GameState.has_flag(str(v)) and GameState.get_flag(str(v)) != false:
					return false
			"rep":
				if FactionManager.rep(str(v[0])) < float(v[1]):
					return false
			"item":
				if player.inventory.count(str(v[0])) < int(v[1]):
					return false
			"item_any":
				if _any_food() == "":
					return false
			"decision":
				if GameState.decision(str(v[0])) != str(v[1]):
					return false
			"no_decision":
				if GameState.decision(str(v)) != "":
					return false
			"chapter_min":
				if StoryManager.chapter < int(v):
					return false
			"attitude":
				if npc.attitude() != str(v):
					return false
			"trader":
				if npc.trader != bool(v):
					return false
	return true


func _any_food() -> String:
	for s in player.inventory.stacks:
		if ItemDB.category(str(s["id"])) == "comida":
			return str(s["id"])
	return ""


# ---------------------------------------------------------------------------
# Ações
# ---------------------------------------------------------------------------
func apply(a: Dictionary) -> void:
	if a.has("take"):
		for it in a["take"]:
			player.inventory.remove(str(it[0]), int(it[1]))
	if a.get("talk", false):
		EventBus.talked_to.emit(npc.npc_id, node_id)
	if a.has("flags"):
		var fl: Dictionary = a["flags"]
		for f in fl.keys():
			GameState.set_flag(f, fl[f])
	if a.has("give"):
		for it in a["give"]:
			player.inventory.add(str(it[0]), int(it[1]), 1.0, {}, true)
			EventBus.toast("Recebido: %s x%d" % [ItemDB.item_name(str(it[0])), int(it[1])], "good")
	if a.has("rep"):
		var r: Dictionary = a["rep"]
		for f in r.keys():
			FactionManager.change_rep(f, float(r[f]))
	if a.has("start"):
		for m in a["start"]:
			MissionManager.start(str(m))
	if a.has("decision"):
		var d: Array = a["decision"]
		GameState.make_decision(str(d[0]), str(d[1]))
	if a.get("gift", false):
		var f := _any_food()
		if f != "":
			player.inventory.remove(f, 1)
			if manager:
				manager.change_rel(npc.npc_id, 20.0)
			if npc.faction != "":
				FactionManager.change_rep(npc.faction, 3.0)
			EventBus.npc_helped.emit(npc.npc_id)
	if a.get("follow", false) and manager:
		manager.set_following(npc.npc_id, true)
	if a.get("wait", false) and manager:
		manager.set_following(npc.npc_id, false)
	if a.has("relocate") and manager:
		manager.relocate(npc.npc_id, str(a["relocate"]))
	if a.has("ending"):
		EventBus.ending_requested.emit(str(a["ending"]))
	if manager:
		manager.change_rel(npc.npc_id, 2.0)
