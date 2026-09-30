extends Node
## GameState — estado persistente da sessão de jogo (mundo + narrativa).
##
## Guarda apenas DADOS (serializáveis). Os nós do mundo leem/escrevem aqui:
## contêineres saqueados, portas, estruturas construídas, itens largados,
## descobertas, decisões e flags de história. O SaveManager serializa tudo.

enum Phase { PRE, SILENCE, POST }

const WORLD_SEED := 19870412

var world_seed: int = WORLD_SEED
var world_phase: int = Phase.POST
var chapter: int = 1
var flags: Dictionary = {}
var decisions: Dictionary = {}
var discovered: Dictionary = {}
var logs_found: Array = []
var notes_found: Array = []
var containers: Dictionary = {}     # uid -> {"items": Array, "opened": bool}
var doors: Dictionary = {}          # uid -> {"open": bool, "locked": bool, "barricade": float}
var dropped_items: Array = []       # [{"pos": [x,y,z], "stack": {...}}]
var structures: Array = []          # [{"type": id, "pos": [..], "rot": y, "data": {}}]
var cleared_cells: Dictionary = {}  # "x,z" -> dia em que foi limpo
var killed_uniques: Dictionary = {}
var stats: Dictionary = {}
var playtime: float = 0.0
var start_mode: String = "new"      # "new" | "load"
var pending_save: Dictionary = {}   # dados carregados aguardando a cena Game
var skip_opening: bool = false
var in_game: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	reset()


func _process(delta: float) -> void:
	if in_game and not get_tree().paused:
		playtime += delta


func reset() -> void:
	world_seed = WORLD_SEED
	world_phase = Phase.POST
	chapter = 1
	flags = {}
	decisions = {}
	discovered = {}
	logs_found = []
	notes_found = []
	containers = {}
	doors = {}
	dropped_items = []
	structures = []
	cleared_cells = {}
	killed_uniques = {}
	stats = {"kills": 0, "infected_killed": 0, "distance": 0.0, "crafted": 0, "days": 0,
		"looted": 0, "stealth_kills": 0, "deaths": 0}
	playtime = 0.0
	pending_save = {}


func new_game() -> void:
	reset()
	start_mode = "new"
	skip_opening = false


# --- Flags / decisões --------------------------------------------------------
func set_flag(flag: String, value: Variant = true) -> void:
	flags[flag] = value
	EventBus.story_flag_set.emit(flag, value)


func has_flag(flag: String) -> bool:
	return flags.has(flag) and flags[flag] != false and flags[flag] != null


func get_flag(flag: String, default: Variant = null) -> Variant:
	return flags.get(flag, default)


func make_decision(decision_id: String, choice: String) -> void:
	decisions[decision_id] = choice
	EventBus.decision_made.emit(decision_id, choice)


func decision(decision_id: String) -> String:
	return str(decisions.get(decision_id, ""))


func discover(location_id: String) -> bool:
	if discovered.has(location_id):
		return false
	discovered[location_id] = TimeManager.day if TimeManager else 0
	EventBus.location_discovered.emit(location_id)
	return true


func add_stat(key: String, amount: float = 1.0) -> void:
	stats[key] = float(stats.get(key, 0.0)) + amount


func set_phase(phase: int) -> void:
	if world_phase == phase:
		return
	world_phase = phase
	EventBus.world_phase_changed.emit(phase)


# --- Contêineres / portas / estruturas ------------------------------------------------
func container_state(uid: String) -> Dictionary:
	return containers.get(uid, {})


func store_container(uid: String, items: Array, opened: bool = true) -> void:
	containers[uid] = {"items": items.duplicate(true), "opened": opened}


func door_state(uid: String) -> Dictionary:
	return doors.get(uid, {})


func store_door(uid: String, state: Dictionary) -> void:
	doors[uid] = state.duplicate()


func add_structure(type_id: String, pos: Vector3, rot_y: float, data: Dictionary = {}) -> int:
	structures.append({"type": type_id, "pos": [pos.x, pos.y, pos.z], "rot": rot_y, "data": data})
	return structures.size() - 1


func add_dropped(pos: Vector3, stack: Dictionary) -> void:
	dropped_items.append({"pos": [pos.x, pos.y, pos.z], "stack": stack.duplicate(true)})


func remove_dropped_near(pos: Vector3, item_id: String) -> void:
	for i in range(dropped_items.size() - 1, -1, -1):
		var d: Dictionary = dropped_items[i]
		var p := Vector3(d["pos"][0], d["pos"][1], d["pos"][2])
		if p.distance_to(pos) < 0.6 and str(d["stack"].get("id", "")) == item_id:
			dropped_items.remove_at(i)
			return


# --- Serialização --------------------------------------------------------------
func to_dict() -> Dictionary:
	return {
		"world_seed": world_seed, "world_phase": world_phase, "chapter": chapter,
		"flags": flags, "decisions": decisions, "discovered": discovered,
		"logs_found": logs_found, "notes_found": notes_found, "containers": containers,
		"doors": doors, "dropped_items": dropped_items, "structures": structures,
		"cleared_cells": cleared_cells, "killed_uniques": killed_uniques, "stats": stats,
		"playtime": playtime,
	}


func from_dict(d: Dictionary) -> void:
	reset()
	world_seed = int(d.get("world_seed", WORLD_SEED))
	world_phase = int(d.get("world_phase", Phase.POST))
	chapter = int(d.get("chapter", 1))
	flags = d.get("flags", {})
	decisions = d.get("decisions", {})
	discovered = d.get("discovered", {})
	logs_found = d.get("logs_found", [])
	notes_found = d.get("notes_found", [])
	containers = d.get("containers", {})
	doors = d.get("doors", {})
	dropped_items = d.get("dropped_items", [])
	structures = d.get("structures", [])
	cleared_cells = d.get("cleared_cells", {})
	killed_uniques = d.get("killed_uniques", {})
	var s: Dictionary = d.get("stats", {})
	for k in s.keys():
		stats[k] = s[k]
	playtime = float(d.get("playtime", 0.0))
