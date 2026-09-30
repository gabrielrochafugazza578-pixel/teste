extends Node
## SaveManager — slots de salvamento (JSON), autosave e quicksave.
##
## Salva: GameState (mundo/decisões/contêineres/portas/estruturas/itens
## largados), tempo, clima, facções, missões, história e os dados da cena
## (jogador, inventário, veículos, sobreviventes, população de infectados),
## coletados via Game.collect_save().

const DIR := "user://saves"
const VERSION := 3
const SLOTS := ["auto", "quick", "1", "2", "3", "4", "5"]

var game: Node = null   # cena Game ativa (registra-se no _ready)
var _autosave_timer: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	DirAccess.make_dir_recursive_absolute(DIR)


func _process(delta: float) -> void:
	if game == null or not GameState.in_game or get_tree().paused:
		return
	_autosave_timer += delta
	if _autosave_timer > float(Settings.gameplay.get("autosave_minutes", 8.0)) * 60.0:
		autosave()


func slot_path(slot: String) -> String:
	return "%s/save_%s.json" % [DIR, slot]


func has_slot(slot: String) -> bool:
	return FileAccess.file_exists(slot_path(slot))


func autosave() -> void:
	_autosave_timer = 0.0
	if game != null and game.has_method("can_save") and game.can_save():
		save_game("auto")


func save_game(slot: String) -> bool:
	if game == null:
		return false
	var data := {
		"version": VERSION,
		"meta": {
			"slot": slot, "time": Time.get_datetime_string_from_system(false, true), "day": TimeManager.day,
			"hour": TimeManager.hour, "chapter": StoryManager.chapter, "playtime": GameState.playtime,
			"location": game.location_name() if game.has_method("location_name") else "",
			"chapter_title": StoryDB.CHAPTERS.get(StoryManager.chapter, {}).get("title", ""),
		},
		"state": GameState.to_dict(),
		"time": TimeManager.to_dict(),
		"weather": WeatherManager.to_dict(),
		"factions": FactionManager.to_dict(),
		"missions": MissionManager.to_dict(),
		"story": StoryManager.to_dict(),
		"scene": game.collect_save(),
	}
	var f := FileAccess.open(slot_path(slot), FileAccess.WRITE)
	if f == null:
		EventBus.toast("Falha ao salvar!", "warn")
		return false
	f.store_string(JSON.stringify(_encode(data), "\t"))
	f.close()
	EventBus.game_saved.emit(slot)
	EventBus.toast("Jogo salvo" + ("" if slot == "auto" else " (%s)" % slot_label(slot)), "save")
	return true


func slot_label(slot: String) -> String:
	match slot:
		"auto": return "Automático"
		"quick": return "Rápido"
	return "Slot " + slot


func read_meta(slot: String) -> Dictionary:
	var d := read(slot)
	return d.get("meta", {})


func read(slot: String) -> Dictionary:
	if not has_slot(slot):
		return {}
	var txt := FileAccess.get_file_as_string(slot_path(slot))
	var parsed = JSON.parse_string(txt)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return _decode(parsed)


func latest_slot() -> String:
	var best := ""
	var best_t := 0
	for s in SLOTS:
		if has_slot(s):
			var t := FileAccess.get_modified_time(slot_path(s))
			if t > best_t:
				best_t = t
				best = s
	return best


func delete_slot(slot: String) -> void:
	if has_slot(slot):
		DirAccess.remove_absolute(slot_path(slot))


## Carrega um slot: aplica dados globais e abre a cena Game (que lê o resto).
func load_game(slot: String) -> bool:
	var d := read(slot)
	if d.is_empty():
		EventBus.toast("Save inválido ou corrompido.", "warn")
		return false
	GameState.from_dict(d.get("state", {}))
	TimeManager.from_dict(d.get("time", {}))
	WeatherManager.from_dict(d.get("weather", {}))
	FactionManager.from_dict(d.get("factions", {}))
	MissionManager.from_dict(d.get("missions", {}))
	StoryManager.from_dict(d.get("story", {}))
	GameState.pending_save = d.get("scene", {})
	GameState.start_mode = "load"
	GameState.skip_opening = true
	EventBus.game_loaded.emit(slot)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	return true


# JSON não guarda Vector3/Color: converte recursivamente.
func _encode(v: Variant) -> Variant:
	match typeof(v):
		TYPE_FLOAT:
			return _enc_f(v)
		TYPE_VECTOR3:
			return {"__v3": [_enc_f(v.x), _enc_f(v.y), _enc_f(v.z)]}
		TYPE_VECTOR2:
			return {"__v2": [_enc_f(v.x), _enc_f(v.y)]}
		TYPE_COLOR:
			return {"__c": [v.r, v.g, v.b, v.a]}
		TYPE_DICTIONARY:
			var o := {}
			for k in v.keys():
				o[str(k)] = _encode(v[k])
			return o
		TYPE_ARRAY:
			var a: Array = []
			for e in v:
				a.append(_encode(e))
			return a
	return v


## JSON não representa INF/NaN (ex.: Vector3.INF = "sem destino").
func _enc_f(f: float) -> Variant:
	if is_inf(f):
		return {"__f": "inf" if f > 0.0 else "-inf"}
	if is_nan(f):
		return {"__f": "nan"}
	return f


func _dec_f(v: Variant) -> float:
	if typeof(v) == TYPE_DICTIONARY and (v as Dictionary).has("__f"):
		match str(v["__f"]):
			"inf": return INF
			"-inf": return -INF
		return NAN
	return float(v)


func _decode(v: Variant) -> Variant:
	match typeof(v):
		TYPE_DICTIONARY:
			if v.has("__f"):
				return _dec_f(v)
			if v.has("__v3"):
				return Vector3(_dec_f(v["__v3"][0]), _dec_f(v["__v3"][1]), _dec_f(v["__v3"][2]))
			if v.has("__v2"):
				return Vector2(_dec_f(v["__v2"][0]), _dec_f(v["__v2"][1]))
			if v.has("__c"):
				return Color(v["__c"][0], v["__c"][1], v["__c"][2], v["__c"][3])
			var o := {}
			for k in v.keys():
				o[k] = _decode(v[k])
			return o
		TYPE_ARRAY:
			var a: Array = []
			for e in v:
				a.append(_decode(e))
			return a
	return v
