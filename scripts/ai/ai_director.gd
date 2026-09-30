class_name AIDirector
extends Node
## Diretor de IA: população de infectados por células (dados), pool de nós,
## despacho de ruídos por evento, alertas em grupo, hordas e nível de ameaça.
##
## A cidade inteira é simulada como NÚMEROS por célula de 64 m; só existem
## nós perto do jogador (limite configurável). Longe dele, as populações
## migram atraídas por ruídos grandes (tiros, rojões, alarmes) a cada 20 s.

const SPAWN_R := 115.0
const DESPAWN_R := 170.0
const MIN_SPAWN_DIST := 24.0

const DENSITY := {"centro": 7.0, "centro_sul": 6.0, "bairro_alto": 5.0, "acacias": 4.0, "vila_operaria": 5.0,
	"industrial": 4.0, "parque_norte": 3.0, "periferia": 1.6, "rural": 0.8, "floresta": 0.9, "serra": 0.4, "rio": 1.2}

var player: Player = null
var world: World = null
var cells: Dictionary = {}
var pool: Array = []
var active: Array = []
var hotspots: Dictionary = {}      # poi -> {"n": int, "types": {}}
var safe_zones: Array = []         # [[Vector3, raio]]
var vision_mult: float = 1.0
var hearing_mult: float = 1.0
var roam: bool = false
var enabled: bool = true
var threat: float = 0.0
var max_suspicion: float = 0.0
var survivor_manager: Node = null
var _tick: float = 0.0
var _migrate_t: float = 20.0
var _horde_t: float = 240.0
var _rng := RandomNumberGenerator.new()
var _spawn_counter: int = 0


func _ready() -> void:
	_rng.randomize()
	EventBus.noise_emitted.connect(_on_noise)


func setup(p: Player, w: World) -> void:
	player = p
	world = w
	w.interior_ready.connect(_on_interior_ready)
	for id in ["estadio", "delegacia", "acampamento_rio", "igreja_despertos"]:
		safe_zones.append([w.poi_pos(id), 55.0 if id == "estadio" else 38.0])
	add_hotspot("hospital", 14, {"errante": 8, "febril": 3, "rastejante": 2, "sentinela": 1})
	add_hotspot("terminal", 10, {"errante": 7, "febril": 2, "colosso": 1})
	add_hotspot("mercado", 7, {"errante": 5, "febril": 2})
	add_hotspot("corvalis", 9, {"errante": 5, "sentinela": 2, "febril": 2})
	add_hotspot("escola", 5, {"errante": 3, "rastejante": 2})


func add_hotspot(poi: String, n: int, types: Dictionary) -> void:
	hotspots[poi] = {"n": n, "types": types}


# ---------------------------------------------------------------------------
# Células de população (dados)
# ---------------------------------------------------------------------------
func _cell(c: Vector2i) -> Dictionary:
	if cells.has(c):
		return cells[c]
	var center := Vector3((c.x + 0.5) * WorldLayout.CHUNK, 0, (c.y + 0.5) * WorldLayout.CHUNK)
	var dist := world.layout.district_at(center.x, center.z)
	var base: float = DENSITY.get(dist, 1.0)
	var r := Util.rng(Util.hash2(c.x, c.y, 4747))
	var n := int(round(base * r.randf_range(0.5, 1.4) * float(Settings.graphics.get("infected_density", 0.75))))
	var types := {}
	for i in n:
		var k := _pick_type(r, dist)
		types[k] = int(types.get(k, 0)) + 1
	# hotspots (hospital, terminal…)
	for poi in hotspots.keys():
		var pp := world.poi_pos(poi)
		if Vector2i(floori(pp.x / WorldLayout.CHUNK), floori(pp.z / WorldLayout.CHUNK)) == c:
			var h: Dictionary = hotspots[poi]
			var ht: Dictionary = h["types"]
			for k in ht.keys():
				types[k] = int(types.get(k, 0)) + int(ht[k])
	if GameState.cleared_cells.has("%d,%d" % [c.x, c.y]):
		var days := TimeManager.day - int(GameState.cleared_cells["%d,%d" % [c.x, c.y]])
		if days < 3:
			types = {}
	var d := {"types": types, "materialized": false}
	cells[c] = d
	return d


func _pick_type(r: RandomNumberGenerator, dist: String) -> String:
	var ch := StoryManager.chapter
	var evo := GameState.has_flag("evolution")
	var table := [["errante", 70.0], ["febril", 15.0 if ch <= 3 else 18.0], ["rastejante", 7.0], ["sentinela", 4.0 + ch * 1.0], ["colosso", 1.0 + ch * 0.6]]
	if evo:
		table.append(["hospedeiro", 10.0])
	if dist in ["rural", "floresta", "serra"]:
		table[2][1] = 12.0
	return str(Util.weighted_pick(table, r))


# ---------------------------------------------------------------------------
# Loop
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	if not enabled or player == null or world == null:
		return
	_tick -= delta
	if _tick > 0.0:
		return
	_tick = 0.5
	_update_modifiers()
	_despawn_far()
	if not player.cinematic:
		_spawn_near()
	_cleanup_dead()
	_update_threat()
	_migrate_t -= 0.5
	if _migrate_t <= 0.0:
		_migrate_t = 20.0
		_migrate()
	_horde_t -= 0.5
	if _horde_t <= 0.0:
		_horde_t = _rng.randf_range(300.0, 600.0)
		if TimeManager.is_night() and GameState.world_phase == GameState.Phase.POST and not player.cinematic:
			_spawn_horde()


func _update_modifiers() -> void:
	var night := TimeManager.is_night()
	var wm := WeatherManager
	vision_mult = (0.85 if night else 1.0) * (1.0 - wm.fog * 0.45) * (1.0 - wm.rain * 0.2)
	hearing_mult = (1.15 if night else 1.0) * (1.0 - wm.rain * 0.35)
	roam = night or wm.state == WeatherManager.State.FOG


func _cap() -> int:
	return Settings.get_infected_cap()


func _in_safe_zone(p: Vector3) -> bool:
	for z in safe_zones:
		if (z[0] as Vector3).distance_to(p) < float(z[1]):
			return true
	return false


func _spawn_near() -> void:
	if GameState.world_phase != GameState.Phase.POST:
		return
	var pp := player.global_position
	var pc := Vector2i(floori(pp.x / WorldLayout.CHUNK), floori(pp.z / WorldLayout.CHUNK))
	var cam := player.cam_rig.cam
	var budget := 3
	for dz in range(-2, 3):
		for dx in range(-2, 3):
			if budget <= 0 or active.size() >= _cap():
				return
			var c := pc + Vector2i(dx, dz)
			var center := Vector3((c.x + 0.5) * WorldLayout.CHUNK, pp.y, (c.y + 0.5) * WorldLayout.CHUNK)
			if center.distance_to(pp) > SPAWN_R:
				continue
			var cd := _cell(c)
			if cd["materialized"]:
				continue
			var types: Dictionary = cd["types"]
			var night := TimeManager.is_night()
			for k in types.keys():
				var n := int(types[k])
				var spawned := 0
				for i in n:
					if active.size() >= _cap():
						break
					var pos := _spawn_pos(c, cam)
					if pos == Vector3.INF:
						continue
					var dormant := not night and _rng.randf() < 0.55
					var inf := _get_from_pool()
					inf.activate(k, pos, _rng.randf() * TAU, _spawn_counter, Infected.S.DORMANT if dormant else (Infected.S.WANDER if roam else Infected.S.IDLE), world, self)
					inf.cell = c
					_spawn_counter += 1
					active.append(inf)
					spawned += 1
				types[k] = n - spawned
			cd["materialized"] = true
			budget -= 1


func _spawn_pos(c: Vector2i, cam: Camera3D) -> Vector3:
	var pp := player.global_position
	for attempt in 6:
		var p := Vector3((c.x + _rng.randf()) * WorldLayout.CHUNK, 0, (c.y + _rng.randf()) * WorldLayout.CHUNK)
		if world.layout.is_water(p.x, p.z):
			continue
		if world.layout.building_at(p, 0.6) >= 0:
			continue
		if _in_safe_zone(p):
			continue
		p.y = world.ground_y(p.x, p.z)
		var d := p.distance_to(pp)
		if d < MIN_SPAWN_DIST:
			continue
		if d < 70.0 and cam != null and cam.is_position_in_frustum(p + Vector3(0, 1, 0)):
			continue
		return p
	return Vector3.INF


func _get_from_pool() -> Infected:
	if not pool.is_empty():
		return pool.pop_back()
	var inf := Infected.new()
	world.get_parent().add_child(inf)
	return inf


func _despawn_far() -> void:
	var pp := player.global_position
	for i in range(active.size() - 1, -1, -1):
		var inf: Infected = active[i]
		if not is_instance_valid(inf):
			active.remove_at(i)
			continue
		if inf.scripted:
			continue
		if inf.global_position.distance_to(pp) > DESPAWN_R and not inf.is_chasing():
			active.remove_at(i)
			if inf.state != Infected.S.DEAD:
				var c := Vector2i(floori(inf.global_position.x / WorldLayout.CHUNK), floori(inf.global_position.z / WorldLayout.CHUNK))
				var cd := _cell(c)
				var types: Dictionary = cd["types"]
				types[inf.kind] = int(types.get(inf.kind, 0)) + 1
				cd["materialized"] = false
			inf.deactivate()
			pool.append(inf)
	# células distantes voltam a poder materializar
	for c in cells.keys():
		var center := Vector3((c.x + 0.5) * WorldLayout.CHUNK, pp.y, (c.y + 0.5) * WorldLayout.CHUNK)
		if center.distance_to(pp) > DESPAWN_R + 40.0:
			(cells[c] as Dictionary)["materialized"] = false


func _cleanup_dead() -> void:
	var cam := player.cam_rig.cam
	for i in range(active.size() - 1, -1, -1):
		var inf: Infected = active[i]
		if inf.state == Infected.S.DEAD and inf.dead_time() > 40.0:
			var visible_now := cam != null and cam.is_position_in_frustum(inf.global_position) and inf.global_position.distance_to(cam.global_position) < 60.0
			if not visible_now:
				active.remove_at(i)
				for ch in inf.get_children():
					if ch is LootContainer:
						ch.queue_free()
				inf.deactivate()
				pool.append(inf)


func on_infected_died(inf: Infected) -> void:
	# célula limpa?
	var c := inf.cell
	var remaining := 0
	for o in active:
		var oi := o as Infected
		if oi.cell == c and oi.state != Infected.S.DEAD:
			remaining += 1
	var cd := _cell(c)
	var left := 0
	for k in (cd["types"] as Dictionary).keys():
		left += int(cd["types"][k])
	if remaining == 0 and left == 0:
		GameState.cleared_cells["%d,%d" % [c.x, c.y]] = TimeManager.day


func on_infected_tier(_inf: Infected, _t: int) -> void:
	pass


func _update_threat() -> void:
	var pp := player.global_position
	var t := 0.0
	var ms := 0.0
	for o in active:
		var inf := o as Infected
		if inf.state == Infected.S.DEAD:
			continue
		var d := inf.global_position.distance_to(pp)
		if d > 40.0:
			continue
		if inf.is_chasing() and inf.target == player:
			t += (0.35 if inf.kind != "colosso" else 0.9) * (1.0 - d / 45.0)
		ms = maxf(ms, inf.suspicion * (1.0 - d / 40.0))
	threat = clampf(lerpf(threat, t, 0.5), 0.0, 1.0)
	max_suspicion = clampf(ms, 0.0, 1.0)
	EventBus.threat_level_changed.emit(threat)


# ---------------------------------------------------------------------------
# Eventos
# ---------------------------------------------------------------------------
func _on_noise(pos: Vector3, radius: float, source: Node, kind: StringName) -> void:
	if not enabled:
		return
	for o in active:
		var inf := o as Infected
		if inf.active and inf.state != Infected.S.DEAD:
			if inf.global_position.distance_squared_to(pos) < radius * radius * 9.0:
				inf.on_noise(pos, radius, kind, source)
	if survivor_manager and survivor_manager.has_method("on_noise"):
		survivor_manager.on_noise(pos, radius, source, kind)
	# ruídos enormes atraem populações abstratas
	if radius >= 60.0:
		var c := Vector2i(floori(pos.x / WorldLayout.CHUNK), floori(pos.z / WorldLayout.CHUNK))
		(_cell(c) as Dictionary)["attract"] = radius
		EventBus.horde_alerted.emit(pos, int(radius / 10.0))


func alert_area(pos: Vector3, radius: float, target_pos: Vector3, by: Node) -> void:
	for o in active:
		var inf := o as Infected
		if inf != by and inf.active and inf.global_position.distance_to(pos) < radius:
			inf.on_alert(target_pos, by)


func infected_near(pos: Vector3, radius: float) -> Array:
	var out: Array = []
	var r2 := radius * radius
	for o in active:
		var inf := o as Infected
		if inf.active and inf.state != Infected.S.DEAD and inf.global_position.distance_squared_to(pos) < r2:
			out.append(inf)
	return out


func npcs_near(pos: Vector3, radius: float) -> Array:
	if survivor_manager and survivor_manager.has_method("npcs_near"):
		return survivor_manager.npcs_near(pos, radius)
	return []


func _migrate() -> void:
	# populações seguem ruídos grandes para células vizinhas
	var moves: Array = []
	for c in cells.keys():
		var cd: Dictionary = cells[c]
		if not cd.has("attract"):
			continue
		cd["attract"] = float(cd["attract"]) - 20.0
		if float(cd["attract"]) <= 0.0:
			cd.erase("attract")
		for dz in range(-2, 3):
			for dx in range(-2, 3):
				var nc: Vector2i = c + Vector2i(dx, dz)
				if nc == c or not cells.has(nc):
					continue
				var nd: Dictionary = cells[nc]
				if nd["materialized"]:
					continue
				var nt: Dictionary = nd["types"]
				var n := int(nt.get("errante", 0))
				if n > 0:
					var mv := maxi(1, n / 3)
					moves.append([nc, c, mv])
	for m in moves:
		var from: Dictionary = cells[m[0]]
		var to: Dictionary = cells[m[1]]
		var ft: Dictionary = from["types"]
		var tt: Dictionary = to["types"]
		var mv := mini(int(m[2]), int(ft.get("errante", 0)))
		ft["errante"] = int(ft.get("errante", 0)) - mv
		tt["errante"] = int(tt.get("errante", 0)) + mv


func _spawn_horde() -> void:
	var pp := player.global_position
	var ang := _rng.randf() * TAU
	var start := pp + Vector3(cos(ang), 0, sin(ang)) * 105.0
	var goal := pp + Vector3(cos(ang + PI + _rng.randf_range(-0.6, 0.6)), 0, sin(ang + PI)) * 140.0
	if not WorldLayout.URBAN.has_point(Vector2(start.x, start.z)):
		return
	var n := _rng.randi_range(8, 14)
	EventBus.world_event.emit("horde", "Você ouve uma horda se movendo pela cidade…")
	AudioManager.play_2d("infected_groan", -8.0, 0.7)
	for i in n:
		if active.size() >= _cap() + 6:
			break
		var p := start + Vector3(_rng.randf_range(-6, 6), 0, _rng.randf_range(-6, 6))
		p.y = world.ground_y(p.x, p.z)
		var inf := _get_from_pool()
		inf.activate("errante" if _rng.randf() < 0.85 else "febril", p, 0.0, _spawn_counter, Infected.S.WANDER, world, self)
		_spawn_counter += 1
		inf.target_pos = goal + Vector3(_rng.randf_range(-8, 8), 0, _rng.randf_range(-8, 8))
		inf.home = goal
		inf.cell = Vector2i(floori(p.x / WorldLayout.CHUNK), floori(p.z / WorldLayout.CHUNK))
		active.append(inf)


## Spawn controlado (cinemática, missões). Não conta na população.
func spawn_scripted(kind: String, pos: Vector3, yaw: float, st: int, var_seed: int = -1) -> Infected:
	var inf := _get_from_pool()
	inf.activate(kind, pos, yaw, var_seed if var_seed >= 0 else _spawn_counter, st, world, self)
	_spawn_counter += 1
	inf.scripted = st == Infected.S.SCRIPTED
	inf.cell = Vector2i(floori(pos.x / WorldLayout.CHUNK), floori(pos.z / WorldLayout.CHUNK))
	active.append(inf)
	return inf


func release(inf: Infected) -> void:
	active.erase(inf)
	inf.deactivate()
	pool.append(inf)


func clear_all() -> void:
	for o in active:
		(o as Infected).deactivate()
		pool.append(o)
	active.clear()
	for c in cells.keys():
		(cells[c] as Dictionary)["materialized"] = false


func _on_interior_ready(bi: int, root: Node3D, data: Dictionary) -> void:
	if GameState.world_phase != GameState.Phase.POST or player == null or player.cinematic:
		return
	var b: Dictionary = world.layout.buildings[bi]
	var center: Vector2 = (b["rect"] as Rect2).get_center()
	var c := Vector2i(floori(center.x / WorldLayout.CHUNK), floori(center.y / WorldLayout.CHUNK))
	var cd := _cell(c)
	var types: Dictionary = cd["types"]
	var spawns: Array = data.get("spawns", [])
	if spawns.is_empty() or _in_safe_zone(Vector3(center.x, 0, center.y)):
		return
	var n := mini(spawns.size(), 1 + (1 if _rng.randf() < 0.5 else 0) + (2 if str(b["type"]) in ["hospital", "market", "lab"] else 0))
	for i in n:
		if active.size() >= _cap():
			break
		var k := ""
		for t in types.keys():
			if int(types[t]) > 0:
				k = t
				break
		if k == "":
			return
		var p: Vector3 = spawns[i]
		if p.distance_to(player.global_position) < 10.0:
			continue
		types[k] = int(types[k]) - 1
		var inf := _get_from_pool()
		inf.activate(k, p + Vector3(0, 0.05, 0), _rng.randf() * TAU, _spawn_counter, Infected.S.DORMANT, world, self)
		_spawn_counter += 1
		inf.cell = c
		active.append(inf)


func to_dict() -> Dictionary:
	var out := {}
	for c in cells.keys():
		var cd: Dictionary = cells[c]
		out["%d,%d" % [c.x, c.y]] = cd["types"]
	# infectados ativos voltam para as células ao salvar
	for o in active:
		var inf := o as Infected
		if inf.state == Infected.S.DEAD or inf.scripted:
			continue
		var c := Vector2i(floori(inf.global_position.x / WorldLayout.CHUNK), floori(inf.global_position.z / WorldLayout.CHUNK))
		var key := "%d,%d" % [c.x, c.y]
		if not out.has(key):
			out[key] = {}
		var t: Dictionary = (out[key] as Dictionary).duplicate()
		t[inf.kind] = int(t.get(inf.kind, 0)) + 1
		out[key] = t
	return out


func from_dict(d: Dictionary) -> void:
	cells.clear()
	for key in d.keys():
		var parts: PackedStringArray = str(key).split(",")
		if parts.size() != 2:
			continue
		var c := Vector2i(int(parts[0]), int(parts[1]))
		cells[c] = {"types": d[key], "materialized": false}
