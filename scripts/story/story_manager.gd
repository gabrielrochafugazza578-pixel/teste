extends Node
## StoryManager — capítulos, registros encontrados (gravações/bilhetes),
## reprodução de gravações com legendas e efeitos de mundo por capítulo.

signal log_playing(log_id: String, line: String)
signal log_finished(log_id: String)

var chapter: int = 1
var playing_log: String = ""
var _log_lines: Array = []
var _line_timer: float = 0.0
var _static_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func reset() -> void:
	chapter = 1
	playing_log = ""
	_log_lines = []


func start_chapter(c: int) -> void:
	if c <= chapter and c != 1:
		return
	chapter = c
	GameState.chapter = c
	var info: Dictionary = StoryDB.CHAPTERS.get(c, {})
	EventBus.chapter_started.emit(c)
	EventBus.toast("CAPÍTULO %d — %s" % [c, info.get("title", "")], "chapter")
	if c >= 6:
		GameState.set_flag("evolution", true)


func is_found(id: String) -> bool:
	return GameState.logs_found.has(id) or GameState.notes_found.has(id)


## Chamado por StoryObject.
func collect(id: String, kind: String, item_id: String, player: Node) -> void:
	match kind:
		"audio":
			if not GameState.logs_found.has(id):
				GameState.logs_found.append(id)
			EventBus.log_found.emit(id)
			play_log(id)
		"note":
			if not GameState.notes_found.has(id):
				GameState.notes_found.append(id)
			var d := StoryDB.note_def(id)
			EventBus.note_found.emit(id)
			EventBus.readable_opened.emit(str(d.get("title", "")), str(d.get("text", "")))
			var it: String = d.get("item", "")
			if it != "" and player and player.has_method("give_item"):
				player.give_item(it, 1)
		_:
			GameState.set_flag("got_" + id, true)
			if item_id != "" and player and player.has_method("give_item"):
				player.give_item(item_id, 1)
				EventBus.toast("Obtido: " + ItemDB.item_name(item_id), "good")


func play_log(id: String) -> void:
	var d := StoryDB.log_def(id)
	if d.is_empty():
		return
	playing_log = id
	_log_lines = (d["lines"] as Array).duplicate()
	_line_timer = 0.8
	AudioManager.play_2d("tape_click", -2.0, 1.0, "Voice")
	_static_player = AudioManager.loop_2d("log_static", "radio_static", -22.0, "Voice")
	EventBus.subtitle.emit("[%s — %s]" % [d["title"], d["date"]], "Dra. Helena Vasconcelos", 2.5)


func stop_log() -> void:
	if playing_log == "":
		return
	var id := playing_log
	playing_log = ""
	_log_lines = []
	AudioManager.stop_loop("log_static")
	AudioManager.play_2d("tape_click", -4.0, 0.9, "Voice")
	log_finished.emit(id)


func _process(delta: float) -> void:
	if playing_log == "":
		return
	_line_timer -= delta
	if _line_timer <= 0.0:
		if _log_lines.is_empty():
			stop_log()
			return
		var line: String = _log_lines.pop_front()
		var dur := clampf(line.length() * 0.065, 2.8, 7.5)
		_line_timer = dur + 0.3
		EventBus.subtitle.emit(line, "Helena", dur)
		log_playing.emit(playing_log, line)


## Objetos de história ainda não coletados para um POI.
func pending_objects(poi: String) -> Array:
	var out: Array = []
	for o in StoryDB.objects_for_poi(poi):
		var id: String = o["id"]
		if o["kind"] == "audio" and GameState.logs_found.has(id):
			continue
		if o["kind"] == "note" and GameState.notes_found.has(id):
			continue
		if o["kind"] == "item" and GameState.has_flag("got_" + id):
			continue
		out.append(o)
	return out


func to_dict() -> Dictionary:
	return {"chapter": chapter}


func from_dict(d: Dictionary) -> void:
	chapter = int(d.get("chapter", 1))
	GameState.chapter = chapter
