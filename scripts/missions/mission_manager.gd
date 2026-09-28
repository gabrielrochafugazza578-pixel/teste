extends Node
## MissionManager — progresso das missões por EVENTOS (sem polling pesado).
## Apenas objetivos "goto" usam checagem de posição a 2 Hz (feita pelo Game).

var active: Dictionary = {}      # id -> {"obj": índice do objetivo atual, "done": {obj_id: true}, "progress": {obj_id: n}}
var completed: Dictionary = {}
var failed: Dictionary = {}
var tracked: String = ""
## Resolve POI -> Vector3 (fornecido pelo World).
var poi_resolver: Callable = Callable()
## Resolve NPC -> Vector3 (fornecido pelo SurvivorManager).
var npc_resolver: Callable = Callable()
var inventory_provider: Callable = Callable()


func _ready() -> void:
	EventBus.item_picked.connect(func(_id, _q) -> void: _check_collect())
	EventBus.inventory_changed.connect(func(_o) -> void: _check_collect())
	EventBus.talked_to.connect(_on_talk)
	EventBus.log_found.connect(func(id: String) -> void: _progress_simple("log", id))
	EventBus.interacted.connect(func(id: String) -> void: _progress_simple("interact", id))
	EventBus.enemy_killed.connect(_on_kill)
	EventBus.story_flag_set.connect(_on_flag)
	EventBus.decision_made.connect(func(d: String, _c: String) -> void: _progress_simple("decision", d))
	EventBus.item_crafted.connect(func(id: String, _q: int) -> void: _progress_simple("craft", id))
	EventBus.vehicle_repaired.connect(func(id: String) -> void: _progress_simple("repair", id))


func reset() -> void:
	active = {}
	completed = {}
	failed = {}
	tracked = ""


func start(id: String) -> void:
	if active.has(id) or completed.has(id):
		return
	var m := MissionDB.get_mission(id)
	if m.is_empty():
		return
	active[id] = {"obj": 0, "done": {}, "progress": {}}
	if tracked == "" or str(m["type"]) == "main":
		tracked = id
	EventBus.mission_started.emit(id)
	EventBus.toast("Nova missão: " + str(m["title"]), "mission")
	AudioManager.play_ui("notify", -2.0)
	_skip_satisfied(id)


func is_active(id: String) -> bool:
	return active.has(id)


func is_done(id: String) -> bool:
	return completed.has(id)


func objectives(id: String) -> Array:
	return MissionDB.get_mission(id).get("objectives", [])


func current_objective(id: String) -> Dictionary:
	if not active.has(id):
		return {}
	var objs := objectives(id)
	var st: Dictionary = active[id]
	for i in objs.size():
		var o: Dictionary = objs[i]
		if not st["done"].has(o["id"]) and not o.get("optional", false):
			return o
	return {}


func objective_text(id: String, o: Dictionary) -> String:
	var t: String = o.get("text", "")
	if o.get("type", "") == "kill" and active.has(id):
		var n := int(active[id]["progress"].get(o["id"], 0))
		t = t.replace("(0/%d)" % int(o.get("count", 1)), "(%d/%d)" % [n, int(o.get("count", 1))])
	return t


func is_objective_done(id: String, obj_id: String) -> bool:
	return active.has(id) and active[id]["done"].has(obj_id) or completed.has(id)


## Objetivos atualmente "ativos" (o obrigatório atual + opcionais pendentes).
func open_objectives(id: String) -> Array:
	var out: Array = []
	if not active.has(id):
		return out
	var st: Dictionary = active[id]
	var reached_required := false
	for o in objectives(id):
		if st["done"].has(o["id"]):
			continue
		if o.get("optional", false):
			out.append(o)
		elif not reached_required:
			out.append(o)
			reached_required = true
	return out


func complete_objective(id: String, obj_id: String) -> void:
	if not active.has(id):
		return
	var st: Dictionary = active[id]
	if st["done"].has(obj_id):
		return
	st["done"][obj_id] = true
	EventBus.objective_completed.emit(id, obj_id)
	EventBus.mission_updated.emit(id)
	AudioManager.play_ui("notify", -6.0)
	# terminou todos os obrigatórios?
	var all_done := true
	for o in objectives(id):
		if not o.get("optional", false) and not st["done"].has(o["id"]):
			all_done = false
	if all_done:
		_complete(id)
	else:
		_skip_satisfied(id)


func _complete(id: String) -> void:
	var m := MissionDB.get_mission(id)
	active.erase(id)
	completed[id] = TimeManager.day
	EventBus.mission_completed.emit(id)
	EventBus.toast("Missão concluída: " + str(m["title"]), "mission")
	var oc: Dictionary = m.get("on_complete", {})
	var reps: Dictionary = oc.get("rep", {})
	for f in reps.keys():
		FactionManager.change_rep(f, float(reps[f]), str(m["title"]))
	var flags: Dictionary = oc.get("flags", {})
	for f in flags.keys():
		GameState.set_flag(f, flags[f])
	if inventory_provider.is_valid():
		var inv: Inventory = inventory_provider.call()
		for it in oc.get("items", []):
			inv.add(str(it[0]), int(it[1]), 1.0, {}, true)
	if int(oc.get("chapter", 0)) > 0:
		StoryManager.start_chapter(int(oc["chapter"]))
	for nxt in oc.get("start", []):
		start(nxt)
	if tracked == id:
		tracked = ""
		for a in active.keys():
			tracked = a
			if str(MissionDB.get_mission(a)["type"]) == "main":
				break
	SaveManager.autosave()


func fail(id: String, reason: String = "") -> void:
	if not active.has(id):
		return
	active.erase(id)
	failed[id] = reason
	EventBus.mission_failed.emit(id)
	EventBus.toast("Missão falhou: " + str(MissionDB.get_mission(id)["title"]), "warn")


## Marca objetivos já satisfeitos (ex.: item já no inventário).
func _skip_satisfied(id: String) -> void:
	_check_collect()


# ---------------------------------------------------------------------------
# Handlers
# ---------------------------------------------------------------------------
func _progress_simple(type: String, target: String) -> void:
	for id in active.keys().duplicate():
		for o in open_objectives(id):
			if o["type"] == type and str(o["target"]) == target:
				complete_objective(id, o["id"])


func _check_collect() -> void:
	if not inventory_provider.is_valid():
		return
	var inv: Inventory = inventory_provider.call()
	if inv == null:
		return
	for id in active.keys().duplicate():
		for o in open_objectives(id):
			if o["type"] == "collect" and inv.count(str(o["target"])) >= int(o.get("count", 1)):
				complete_objective(id, o["id"])


func _on_flag(f: String, v: Variant) -> void:
	if v != null and v != false:
		_progress_simple("flag", f)


func _on_talk(npc_id: String, topic: String) -> void:
	for id in active.keys().duplicate():
		for o in open_objectives(id):
			if o["type"] == "talk" and str(o["target"]) == npc_id:
				complete_objective(id, o["id"])
			elif o["type"] == "deliver" and str(o["target"]) == npc_id and inventory_provider.is_valid():
				var inv: Inventory = inventory_provider.call()
				var item: String = o["item"]
				var n := int(o.get("count", 1))
				if inv.count(item) >= n:
					inv.remove(item, n)
					EventBus.toast("Entregue: %s x%d" % [ItemDB.item_name(item), n], "info")
					complete_objective(id, o["id"])


func _on_kill(kind: String, pos: Vector3, killer: Node) -> void:
	if killer == null or not killer.is_in_group("player"):
		return
	for id in active.keys().duplicate():
		for o in open_objectives(id):
			if o["type"] != "kill":
				continue
			if str(o["target"]) != "any" and str(o["target"]) != kind:
				continue
			if o.has("area") and poi_resolver.is_valid():
				var ap: Vector3 = poi_resolver.call(str(o["area"]))
				if ap.distance_to(pos) > 90.0:
					continue
			var st: Dictionary = active[id]
			var n := int(st["progress"].get(o["id"], 0)) + 1
			st["progress"][o["id"]] = n
			EventBus.mission_updated.emit(id)
			if n >= int(o.get("count", 1)):
				complete_objective(id, o["id"])


## Chamado pelo Game ~2x/s com a posição do jogador.
func check_position(pos: Vector3) -> void:
	for id in active.keys().duplicate():
		for o in open_objectives(id):
			if o["type"] != "goto":
				continue
			var tp := target_position(o)
			if tp == Vector3.INF:
				continue
			var r := float(o.get("radius", 10.0))
			if Vector2(pos.x, pos.z).distance_to(Vector2(tp.x, tp.z)) < r:
				complete_objective(id, o["id"])


func target_position(o: Dictionary) -> Vector3:
	if o.has("pos"):
		var p: Array = o["pos"]
		return Vector3(p[0], p[1], p[2])
	var t: String = str(o.get("target", ""))
	match str(o.get("type", "")):
		"goto", "log", "interact", "kill":
			if o.has("area") and poi_resolver.is_valid():
				return poi_resolver.call(str(o["area"]))
			if poi_resolver.is_valid():
				var p: Vector3 = poi_resolver.call(_poi_for_target(o))
				if p != Vector3.ZERO:
					return p
		"talk", "deliver":
			if npc_resolver.is_valid():
				var p: Vector3 = npc_resolver.call(t)
				if p != Vector3.INF:
					return p
		"collect":
			if poi_resolver.is_valid():
				var poi := _item_poi(t)
				if poi != "":
					return poi_resolver.call(poi)
	return Vector3.INF


func _poi_for_target(o: Dictionary) -> String:
	var t: String = o.get("target", "")
	if o["type"] == "log":
		return str(StoryDB.log_def(t).get("poi", ""))
	if o["type"] == "interact":
		if t.begins_with("elevator_"):
			return "lab_nexus"
		if t == "radio_torre":
			return "torre_radio"
	return t


func _item_poi(item: String) -> String:
	for id in StoryDB.KEY_ITEMS.keys():
		if StoryDB.KEY_ITEMS[id]["item"] == item:
			return StoryDB.KEY_ITEMS[id]["poi"]
	for id in StoryDB.NOTES.keys():
		if StoryDB.NOTES[id].get("item", "") == item:
			return StoryDB.NOTES[id]["poi"]
	return ""


## Marcador do HUD para a missão rastreada.
func tracked_marker() -> Vector3:
	if tracked == "" or not active.has(tracked):
		return Vector3.INF
	var o := current_objective(tracked)
	if o.is_empty():
		return Vector3.INF
	return target_position(o)


func to_dict() -> Dictionary:
	return {"active": active, "completed": completed, "failed": failed, "tracked": tracked}


func from_dict(d: Dictionary) -> void:
	active = d.get("active", {})
	completed = d.get("completed", {})
	failed = d.get("failed", {})
	tracked = str(d.get("tracked", ""))
