class_name World
extends Node3D
## Mundo aberto com STREAMING por regiões.
##
## Anéis de detalhe ao redor do foco (jogador ou câmera da cinemática):
##   lod 0 (≤ ~110 m): interiores sob demanda, props, grama, colisão total
##   lod 1 (≤ ~260 m): prédios + árvores + colisão
##   lod 2 (≤ distância de visão): silhueta (terreno grosso + cascas)
## Dados gerados em WorkerThreadPool; a criação de nós é fatiada por frame
## com orçamento de microssegundos (Settings.get_stream_budget_usec()).

signal chunk_ready(coord: Vector2i)
signal interior_ready(building_id: int, root: Node3D, data: Dictionary)
signal area_ready

const MAX_JOBS := 2

class Job:
	extends RefCounted
	var kind: String = "chunk"   # chunk | phase | interior
	var coord: Vector2i
	var lod: int = 0
	var building: int = -1
	var task: int = -1
	var result: Dictionary = {}
	var opts: Dictionary = {}
	var gen: int = 0

var layout: WorldLayout
var chunks: Dictionary = {}
var pending: Dictionary = {}        # coord -> lod em geração
var jobs: Array = []
var apply_queue: Array = []         # [Callable]
var focus_points: Array = []        # posições extras (pré-carregamento da cinemática)
var forced_interiors: Dictionary = {}
var claimed_cars: Dictionary = {}
var ready_first: bool = false
var light_pool: Array = []
## Luz natural que entra pelas janelas dos interiores próximos (sem energia na cidade):
## claridade do céu de dia, luar à noite e a mancha do sol no piso quando ele bate na janela.
var window_pool: Array = []
var sunpatch_pool: Array = []
var _win_timer: float = 0.0
var _eval_timer: float = 0.0
var _last_focus := Vector3(INF, 0, INF)
var _light_timer: float = 0.0
var _phase_applied: int = -1
var stat_apply_usec: int = 0
var _gen: int = 0                   # incrementa em rebuild_all (descarta jobs antigos)
## Cinemática: amplia a distância de visão/streaming (tomadas aéreas).
var view_boost: float = 1.0


func _ready() -> void:
	EventBus.world_phase_changed.connect(_on_phase_changed)
	for i in 8:
		var l := OmniLight3D.new()
		l.light_color = Color(1.0, 0.78, 0.5)
		l.light_energy = 0.0
		l.omni_range = 16.0
		l.omni_attenuation = 1.4
		l.shadow_enabled = false
		l.visible = false
		add_child(l)
		light_pool.append(l)
	for i in 4:
		var s := SpotLight3D.new()
		s.shadow_enabled = false
		s.spot_angle = 68.0
		s.spot_angle_attenuation = 1.2
		s.spot_attenuation = 1.3
		s.light_specular = 0.15
		s.visible = false
		add_child(s)
		window_pool.append(s)
	for i in 2:
		var s := SpotLight3D.new()
		s.shadow_enabled = false
		s.spot_angle = 16.0
		s.spot_angle_attenuation = 0.6
		s.spot_attenuation = 0.4
		s.spot_range = 8.0
		s.light_specular = 0.3
		s.visible = false
		add_child(s)
		sunpatch_pool.append(s)


## Espera as tarefas de geração em andamento antes de sair (encerrar o jogo
## com tarefas soltas no WorkerThreadPool aborta o processo).
func _exit_tree() -> void:
	for j in jobs:
		if j.task >= 0:
			WorkerThreadPool.wait_for_task_completion(j.task)
	jobs.clear()


func setup(world_layout: WorldLayout) -> void:
	layout = world_layout
	PropLib.warm()
	MissionManager.poi_resolver = poi_pos


func poi_pos(id: String) -> Vector3:
	if layout == null:
		return Vector3.ZERO
	return layout.poi_pos(id)


func is_car_claimed(uid: String) -> bool:
	return claimed_cars.has(uid)


## Remove um carro estático do mundo (virou veículo dirigível): refaz a
## camada de fase do chunk sem ele.
func claim_car(uid: String, c: Vector2i) -> void:
	claimed_cars[uid] = true
	if chunks.has(c) and not _has_job("phase", c):
		_start_phase_job(c)


# ---------------------------------------------------------------------------
# Distâncias por configuração
# ---------------------------------------------------------------------------
func _r0() -> float:
	return 100.0 + 20.0 * float(Settings.graphics.get("object_distance", 1.0))


func _r1() -> float:
	return clampf(Settings.get_view_distance() * 0.55 * view_boost, 180.0, 380.0 * view_boost)


func _rv() -> float:
	return (Settings.get_view_distance() + 40.0) * view_boost


func desired_lod(c: Vector2i) -> int:
	var center := Vector3((c.x + 0.5) * WorldLayout.CHUNK, 0, (c.y + 0.5) * WorldLayout.CHUNK)
	var best := INF
	var f := SimScheduler.focus_position
	best = Vector2(center.x - f.x, center.z - f.z).length()
	var extra := INF
	for p in focus_points:
		var fp: Vector3 = p
		extra = minf(extra, Vector2(center.x - fp.x, center.z - fp.z).length())
	var lod := 3
	if best < _r0():
		lod = 0
	elif best < _r1():
		lod = 1
	elif best < _rv():
		lod = 2
	# pontos de pré-carga pedem no máximo lod 1 (e lod 0 bem perto)
	if extra < 70.0:
		lod = mini(lod, 0)
	elif extra < 160.0:
		lod = mini(lod, 1)
	elif extra < 320.0:
		lod = mini(lod, 2)
	return lod


# ---------------------------------------------------------------------------
# Loop
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	if layout == null:
		return
	var f := SimScheduler.focus_position
	ShaderGlobals.set_value("player_world_pos", f)
	_eval_timer -= delta
	if _eval_timer <= 0.0 or f.distance_to(_last_focus) > 10.0:
		_eval_timer = 0.35
		_last_focus = f
		_evaluate()
	_poll_jobs()
	_apply_budgeted()
	_light_timer -= delta
	if _light_timer <= 0.0:
		_light_timer = 0.5
		_update_light_pool()
	_win_timer -= delta
	if _win_timer <= 0.0:
		_win_timer = 0.2
		_update_window_lights()


func _evaluate() -> void:
	var f := SimScheduler.focus_position
	var rv := _rv()
	var r := int(ceil(rv / WorldLayout.CHUNK)) + 1
	var fc := Vector2i(floori(f.x / WorldLayout.CHUNK), floori(f.z / WorldLayout.CHUNK))
	var wanted: Array = []
	var coords: Array = []
	for dz in range(-r, r + 1):
		for dx in range(-r, r + 1):
			coords.append(fc + Vector2i(dx, dz))
	for p in focus_points:
		var fp: Vector3 = p
		var pc := Vector2i(floori(fp.x / WorldLayout.CHUNK), floori(fp.z / WorldLayout.CHUNK))
		var ring := 3 if view_boost <= 1.0 else 5
		for dz in range(-ring, ring + 1):
			for dx in range(-ring, ring + 1):
				coords.append(pc + Vector2i(dx, dz))
	var seen := {}
	for c in coords:
		if seen.has(c):
			continue
		seen[c] = true
		if absi(c.x) > 24 or absi(c.y) > 24:
			continue
		var lod := desired_lod(c)
		if lod > 2:
			continue
		var cur: int = chunks[c].lod if chunks.has(c) else -1
		if cur == lod or (pending.has(c) and pending[c] == lod):
			continue
		var center := Vector3((c.x + 0.5) * WorldLayout.CHUNK, 0, (c.y + 0.5) * WorldLayout.CHUNK)
		var pri := center.distance_to(f)
		for p in focus_points:
			pri = minf(pri, center.distance_to(p))
		wanted.append([pri - (200.0 if cur < 0 else 0.0) + lod * 30.0, c, lod])
	wanted.sort_custom(func(a, b): return a[0] < b[0])
	var free_slots := MAX_JOBS - _running_jobs()
	for w in wanted:
		if free_slots <= 0:
			break
		_start_chunk_job(w[1], w[2])
		free_slots -= 1
	# descarrega longe demais
	for c in chunks.keys():
		if not seen.has(c) or desired_lod(c) > 2:
			var ch: Chunk = chunks[c]
			chunks.erase(c)
			ch.queue_free()
			EventBus.chunk_unloaded.emit(c)
	# interiores
	_evaluate_interiors()
	# fase
	if _phase_applied != GameState.world_phase:
		_phase_applied = GameState.world_phase
		for c in chunks.keys():
			var ch: Chunk = chunks[c]
			if ch.lod == 0:
				ch.phase_built = -1
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		if ch.lod == 0 and ch.phase_built != GameState.world_phase and not _has_job("phase", c):
			if _running_jobs() < MAX_JOBS + 1:
				_start_phase_job(c)


func _running_jobs() -> int:
	return jobs.size()


func _has_job(kind: String, c: Vector2i, b: int = -1) -> bool:
	for j in jobs:
		if j.kind == kind and j.coord == c and (b < 0 or j.building == b):
			return true
	return false


func _opts() -> Dictionary:
	return {"veg_density": Settings.get_vegetation_density(), "grass": Settings.get_grass_distance() > 0.0,
		"relief": int(Settings.graphics.get("preset", 1)) != Settings.PRESET_VERY_LOW,
		"grass_density": Settings.get_vegetation_density(), "decay": GameState.world_phase == GameState.Phase.POST}


func _start_chunk_job(c: Vector2i, lod: int) -> void:
	var j := Job.new()
	j.kind = "chunk"
	j.coord = c
	j.lod = lod
	j.opts = _opts()
	j.opts["decay"] = 1.0 if GameState.world_phase == GameState.Phase.POST else 0.0
	j.gen = _gen
	var lay := layout
	j.task = WorkerThreadPool.add_task(func() -> void: j.result = ChunkBuilder.build(lay, c, lod, j.opts), false, "chunk")
	jobs.append(j)
	pending[c] = lod


func _start_phase_job(c: Vector2i) -> void:
	var j := Job.new()
	j.kind = "phase"
	j.coord = c
	var ph := GameState.world_phase
	j.lod = ph
	var lay := layout
	j.task = WorkerThreadPool.add_task(func() -> void: j.result = ChunkBuilder.build_phase(lay, c, ph), false, "phase")
	jobs.append(j)


func _start_interior_job(c: Vector2i, bi: int) -> void:
	var j := Job.new()
	j.kind = "interior"
	j.coord = c
	j.building = bi
	var b: Dictionary = layout.buildings[bi]
	j.task = WorkerThreadPool.add_task(func() -> void: j.result = InteriorGen.build(b), false, "interior")
	jobs.append(j)


func _poll_jobs() -> void:
	for i in range(jobs.size() - 1, -1, -1):
		var j: Job = jobs[i]
		if not WorkerThreadPool.is_task_completed(j.task):
			continue
		WorkerThreadPool.wait_for_task_completion(j.task)
		jobs.remove_at(i)
		if j.kind == "chunk" and j.gen != _gen:
			continue
		match j.kind:
			"chunk":
				_on_chunk_data(j)
			"phase":
				if chunks.has(j.coord):
					var ch: Chunk = chunks[j.coord]
					var res := j.result
					var ph := j.lod
					apply_queue.append(func() -> void:
						if is_instance_valid(ch):
							ch.apply_phase(res, ph))
			"interior":
				if chunks.has(j.coord):
					var ch2: Chunk = chunks[j.coord]
					var bi := j.building
					var data := j.result
					apply_queue.append(func() -> void: _apply_interior(ch2, bi, data))


func _on_chunk_data(j: Job) -> void:
	if desired_lod(j.coord) > 2:
		pending.erase(j.coord)
		return
	var ch := Chunk.new(j.coord, j.lod)
	ch.world = self
	var old: Chunk = chunks.get(j.coord, null)
	var steps := ch.make_steps(j.result)
	var c := j.coord
	apply_queue.append(func() -> void: add_child(ch))
	for s in steps:
		apply_queue.append(s)
	apply_queue.append(func() -> void:
		pending.erase(c)
		if old != null and is_instance_valid(old):
			# interiores e camada de fase passam para o chunk novo (ninguém cai
			# do piso de um interior durante a troca de LOD)
			if ch.lod == 0:
				_transfer_chunk_state(old, ch)
			old.queue_free()
		if desired_lod(c) > 2:
			ch.queue_free()
			return
		chunks[c] = ch
		if ch.lod == 0:
			_spawn_outdoor_story(ch)
		chunk_ready.emit(c)
		EventBus.chunk_loaded.emit(c))
	if old != null:
		# mantém o antigo até o novo ficar pronto
		chunks[c] = old


func _transfer_chunk_state(old: Chunk, ch: Chunk) -> void:
	for bi in old.interiors.keys():
		var it: Dictionary = old.interiors[bi]
		var n: Node = it["node"]
		if is_instance_valid(n):
			n.reparent(ch, true)
		ch.interiors[bi] = it
	old.interiors.clear()
	ch.story_spawned = old.story_spawned
	for k in old.get_children():
		if k is StoryObject or k is ItemPickup:
			k.reparent(ch, true)


func _apply_budgeted() -> void:
	var budget := Settings.get_stream_budget_usec()
	if not ready_first:
		budget = 60000
	var start := Time.get_ticks_usec()
	while not apply_queue.is_empty():
		var job: Callable = apply_queue.pop_front()
		job.call()
		if Time.get_ticks_usec() - start > budget:
			break
	stat_apply_usec = Time.get_ticks_usec() - start
	if not ready_first and jobs.is_empty() and apply_queue.is_empty() and not chunks.is_empty():
		ready_first = true
		area_ready.emit()


func is_area_ready(pos: Vector3, radius: float = 70.0, max_lod: int = 1) -> bool:
	var c0 := Vector2i(floori((pos.x - radius) / WorldLayout.CHUNK), floori((pos.z - radius) / WorldLayout.CHUNK))
	var c1 := Vector2i(floori((pos.x + radius) / WorldLayout.CHUNK), floori((pos.z + radius) / WorldLayout.CHUNK))
	for cx in range(c0.x, c1.x + 1):
		for cz in range(c0.y, c1.y + 1):
			var c := Vector2i(cx, cz)
			if desired_lod(c) > 2:
				continue
			if not chunks.has(c) or (chunks[c] as Chunk).lod > max_lod:
				return false
	return true


## Espera a região distante existir (qualquer LOD) — tomadas aéreas.
func wait_loaded(pos: Vector3, radius: float, timeout: float = 25.0) -> void:
	_eval_timer = 0.0
	var t := 0.0
	while not is_area_ready(pos, radius, 2) and t < timeout:
		await get_tree().process_frame
		t += get_process_delta_time()


## Ponto pronto para colocar o jogador: chunk em LOD 0 e, se estiver dentro
## de um prédio enterável, o interior já construído (em LOD 1 o prédio é um
## bloco sólido e empurraria o jogador para fora/baixo).
func is_spot_ready(pos: Vector3) -> bool:
	var c := Vector2i(floori(pos.x / WorldLayout.CHUNK), floori(pos.z / WorldLayout.CHUNK))
	if not chunks.has(c) or (chunks[c] as Chunk).lod != 0:
		return false
	var bi := layout.building_at(pos, 0.3)
	if bi >= 0 and bool(layout.buildings[bi].get("enterable", false)):
		return interior_root(bi) != null
	return true


func wait_spot(pos: Vector3, timeout: float = 20.0) -> void:
	if not focus_points.has(pos):
		focus_points.append(pos)
	_eval_timer = 0.0
	var t := 0.0
	while not is_spot_ready(pos) and t < timeout:
		await get_tree().process_frame
		t += get_process_delta_time()
	focus_points.erase(pos)


## Chunks próximos já com a camada da fase atual (carros, entulho...).
func is_phase_ready(pos: Vector3, radius: float = 50.0) -> bool:
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		if ch.lod != 0:
			continue
		var center := Vector2((c.x + 0.5) * WorldLayout.CHUNK, (c.y + 0.5) * WorldLayout.CHUNK)
		if center.distance_to(Vector2(pos.x, pos.z)) < radius + 46.0 and ch.phase_built != GameState.world_phase:
			return false
	return true


## Aguarda a região estar carregada (usado na cinemática e no carregamento).
func wait_area(pos: Vector3, radius: float = 70.0, timeout: float = 20.0) -> void:
	if not focus_points.has(pos):
		focus_points.append(pos)
	_eval_timer = 0.0
	var t := 0.0
	while (not is_area_ready(pos, radius) or not is_phase_ready(pos, radius * 0.7)) and t < timeout:
		await get_tree().process_frame
		t += get_process_delta_time()


## Descarta todos os chunks e regenera (troca de fase com a tela preta da
## cinemática: a geometria base também depende da fase).
func rebuild_all() -> void:
	for c in chunks.keys():
		(chunks[c] as Chunk).queue_free()
	chunks.clear()
	pending.clear()
	apply_queue.clear()
	_gen += 1
	_phase_applied = -1
	_eval_timer = 0.0
	_last_focus = Vector3(INF, 0, INF)


func clear_focus_points() -> void:
	focus_points.clear()


# ---------------------------------------------------------------------------
# Interiores
# ---------------------------------------------------------------------------
func force_interior(bi: int, on: bool = true) -> void:
	if on:
		forced_interiors[bi] = true
	else:
		forced_interiors.erase(bi)
	_eval_timer = 0.0


func _evaluate_interiors() -> void:
	var f := SimScheduler.focus_position
	var r_in := 42.0
	var r_out := 70.0
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		if ch.lod != 0:
			for bi in ch.interiors.keys():
				ch.remove_interior(bi)
			continue
		for bi in ch.enterables:
			var b: Dictionary = layout.buildings[bi]
			var center: Vector2 = (b["rect"] as Rect2).get_center()
			var d := Vector2(f.x, f.z).distance_to(center) - maxf((b["rect"] as Rect2).size.x, (b["rect"] as Rect2).size.y) * 0.5
			for p in focus_points:
				var fp: Vector3 = p
				d = minf(d, Vector2(fp.x, fp.z).distance_to(center) - 20.0)
			var want := d < r_in or forced_interiors.has(bi)
			if want and not ch.has_interior(bi) and not _has_job("interior", c, bi):
				if jobs.size() < MAX_JOBS + 2:
					_start_interior_job(c, bi)
			elif not want and d > r_out and ch.has_interior(bi):
				ch.remove_interior(bi)


func interior_markers(bi: int) -> Dictionary:
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		if ch.interiors.has(bi):
			return ch.interiors[bi]["markers"]
	return {}


func interior_root(bi: int) -> Node3D:
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		if ch.interiors.has(bi):
			return ch.interiors[bi]["node"]
	return null


func building_for_poi(poi: String) -> int:
	if layout.pois.has(poi):
		return int(layout.pois[poi].get("building", -1))
	return -1


## Marcador de interior de um POI (Transform3D) ou null.
func poi_marker(poi: String, marker: String) -> Variant:
	var bi := building_for_poi(poi)
	if bi < 0:
		return null
	var m := interior_markers(bi)
	return m.get(marker, null)


func _apply_interior(ch: Chunk, bi: int, data: Dictionary) -> void:
	if not is_instance_valid(ch) or ch.has_interior(bi):
		return
	var b: Dictionary = layout.buildings[bi]
	var root := ch.apply_interior(bi, data, b)
	_populate_interior(root, bi, data, b)
	interior_ready.emit(bi, root, data)


func _populate_interior(root: Node3D, bi: int, data: Dictionary, b: Dictionary) -> void:
	var dist: String = b["district"]
	var context: String = str(b.get("interior", b["type"]))
	for d in data["doors"]:
		var door := Door.new()
		root.add_child(door)
		var dd: Dictionary = d
		if context == "lab" and dd.get("name", "") == "lab_door":
			dd["key"] = ""
		door.setup(dd)
	for c in data["containers"]:
		var lc := LootContainer.new()
		var cd: Dictionary = c
		cd["district"] = dist
		root.add_child(lc)
		lc.setup(cd)
	var k := 0
	for p in data["pickups"]:
		k += 1
		var uid := "%d_p%d" % [bi, k]
		var kind := str(p.get("kind", "_floor"))
		var stacks := LootTables.roll_one(str(p["context"]), kind, uid, dist, Settings.loot_multiplier())
		if stacks.is_empty():
			continue
		var yaw := float(p.get("yaw", randf() * TAU))
		if not GameState.has_flag("picked_" + uid):
			var ip := ItemPickup.new()
			ip.uid = uid
			root.add_child(ip)
			ip.setup(stacks[0], p["pos"], false, yaw)
		# arma de fogo achada vem com um pouco de munição do lado
		var ammo := LootTables.ammo_for(stacks[0], uid)
		if not ammo.is_empty() and not GameState.has_flag("picked_" + uid + "a"):
			var ia := ItemPickup.new()
			ia.uid = uid + "a"
			root.add_child(ia)
			var side := Vector3(cos(yaw), 0, -sin(yaw)) * 0.28
			ia.setup(ammo, (p["pos"] as Vector3) + side, false, yaw + 0.7)
	var beds: Array = data["beds"]
	if not beds.is_empty():
		var st := Station.new()
		root.add_child(st)
		st.setup("bed", beds[0], 0.0, "bed_%d" % bi)
	var wbs: Array = data["workbenches"]
	if not wbs.is_empty():
		var wb := Station.new()
		root.add_child(wb)
		wb.setup("workbench", wbs[0], 0.0, "wb_%d" % bi)
	var powered := building_powered(bi)
	# religado no gerador depois do surto: uma das lâmpadas fica falhando
	var flick_pos := Vector3.INF
	var lamp_xfs: Array = (data.get("lamps", []) as Array).duplicate()
	if powered and GameState.world_phase != GameState.Phase.PRE and not lamp_xfs.is_empty():
		var fi := absi(Util.hash2(bi, 91)) % lamp_xfs.size()
		var fxf: Transform3D = lamp_xfs[fi]
		lamp_xfs.remove_at(fi)
		flick_pos = fxf.origin
		var fp := _lamp_panels([fxf])
		var fm := ((fp.multimesh.mesh as QuadMesh).material as StandardMaterial3D).duplicate() as StandardMaterial3D
		(fp.multimesh.mesh as QuadMesh).material = fm
		fp.name = "LampFlicker"
		root.add_child(fp)
		fp.set_meta("mat", fm)
	if powered and not lamp_xfs.is_empty():
		root.add_child(_lamp_panels(lamp_xfs))
	for s in data["screens"]:
		var q := QuadMesh.new()
		q.size = s["size"]
		var mi := MeshInstance3D.new()
		mi.mesh = q
		var mat := Assets.screen_material(int(s["style"]), randf() * 10.0)
		mat.set_shader_parameter("power", 1.0 if powered else 0.0)
		mi.material_override = mat
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var xf: Transform3D = s["xf"]
		# quad do Godot olha para +Z; nossos props olham para -Z
		mi.transform = Transform3D(xf.basis * Basis(Vector3.UP, PI), xf.origin)
		if s.has("name"):
			mi.name = str(s["name"])
		mi.add_to_group("screen")
		root.add_child(mi)
	for lb in data["labels"]:
		var l := Label3D.new()
		l.text = str(lb["text"])
		l.font_size = 48
		l.pixel_size = float(lb["size"]) / 48.0
		l.modulate = lb.get("color", Color(0.3, 0.3, 0.3))
		l.outline_size = 0
		l.shaded = true
		var xf: Transform3D = lb["xf"]
		l.transform = Transform3D(xf.basis * Basis(Vector3.UP, PI), xf.origin)
		root.add_child(l)
	# móveis com modelo escaneado (Poly Haven): uma MultiMesh por tipo
	var by_model := {}
	for e in data.get("models", []):
		var pa: Array = e
		if not by_model.has(pa[0]):
			by_model[pa[0]] = []
		(by_model[pa[0]] as Array).append(pa[1])
	for pn in by_model.keys():
		var lst: Array = by_model[pn]
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.mesh = PropLib.mesh(pn)
		mm.instance_count = lst.size()
		for i in lst.size():
			mm.set_instance_transform(i, lst[i])
		var mmi := MultiMeshInstance3D.new()
		mmi.name = "Modelo_" + str(pn)
		mmi.multimesh = mm
		root.add_child(mmi)
	# luminárias pendentes balançando com a corrente de ar das janelas quebradas
	for sxf: Transform3D in data.get("swing", []):
		var piv := Node3D.new()
		piv.transform = sxf
		var lm := MeshInstance3D.new()
		lm.mesh = Assets.cached_mesh("swing_pendant", func() -> Mesh: return PropLib.buf("pendant_lamp").to_mesh(Assets.world_material("interior")))
		piv.add_child(lm)
		root.add_child(piv)
		# pêndulo de ~0,7 m: período ~1,7 s; amplitude pequena, um pouco elíptica
		var amp := deg_to_rad(randf_range(1.5, 3.2))
		var per := randf_range(1.6, 1.85)
		piv.rotation.x = -amp
		var tw := piv.create_tween().set_loops()
		tw.tween_property(piv, "rotation:x", amp, per * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(piv, "rotation:x", -amp, per * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		var tz := piv.create_tween().set_loops()
		tz.tween_property(piv, "rotation:z", amp * 0.4, per * 0.53).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tz.tween_property(piv, "rotation:z", -amp * 0.4, per * 0.53).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var nlights := 0
	# luzes marcadas com "prio" (salão do laboratório) primeiro: o limite é baixo
	var lights: Array = (data["lights"] as Array).filter(func(l): return l.has("prio"))
	lights.append_array((data["lights"] as Array).filter(func(l): return not l.has("prio")))
	for li in lights:
		if not powered or nlights >= 5:
			break
		var ol := OmniLight3D.new()
		ol.position = li["pos"]
		ol.omni_range = float(li["range"])
		ol.light_energy = 0.9
		ol.light_color = Color(0.95, 0.97, 1.0) if context in ["lab", "hospital", "clinic", "office"] else Color(1.0, 0.85, 0.65)
		ol.shadow_enabled = false
		ol.add_to_group("interior_light")
		ol.set_meta("room_type", li.get("type", ""))
		root.add_child(ol)
		nlights += 1
	# a luz mais perto da lâmpada falhando pisca junto com ela
	if flick_pos != Vector3.INF:
		var best: OmniLight3D = null
		var bd := 8.0
		for c in root.get_children():
			if c is OmniLight3D and c.is_in_group("interior_light"):
				var dd := (c as OmniLight3D).position.distance_to(flick_pos)
				if dd < bd:
					bd = dd
					best = c
		_flicker(best, root.get_node_or_null("LampFlicker"))
	# posto: bombas
	if b["type"] == "gas_station":
		var di := BuildingGen.door_info(b)
		var p0: Vector3 = di[0]
		var n: Vector3 = di[1]
		var side := n.cross(Vector3.UP)
		for sx: float in [-1.0, 1.0]:
			var fp := FuelPump.new()
			root.add_child(fp)
			fp.setup(p0 + n * 7.0 + side * sx * 2.1, "pump_%d_%d" % [bi, int(sx)])
	# laboratório: elevador para o Setor 7
	var markers: Dictionary = data["markers"]
	if context == "lab" and markers.has("elevator"):
		var ev := Elevator.new()
		root.add_child(ev)
		var exf: Transform3D = markers["elevator"]
		ev.setup(exf.origin, exf.basis.get_euler().y, "setor7", "setor7")
	# objetos da história
	var poi: String = b["poi"]
	if poi != "":
		var spawns: Array = data["spawns"]
		var si := 0
		for o in StoryManager.pending_objects(poi):
			var od: Dictionary = o
			if od.has("chapter") and int(od["chapter"]) > StoryManager.chapter + 1:
				continue
			var pos: Vector3
			var mk: String = od.get("marker", "")
			if mk != "" and markers.has(mk):
				pos = (markers[mk] as Transform3D).origin
				if mk.ends_with("desk") and not mk.begins_with("helena_desk"):
					pos.y += 0.0
			elif not spawns.is_empty():
				pos = spawns[si % spawns.size()]
				si += 1
			else:
				pos = (markers["center"] as Transform3D).origin
			var so := StoryObject.new()
			root.add_child(so)
			so.setup(str(od["id"]), str(od["kind"]), pos + Vector3(0.0, 0.02, 0.0), randf() * TAU, str(od.get("item", "")))


func _spawn_outdoor_story(ch: Chunk) -> void:
	if ch.story_spawned:
		return
	ch.story_spawned = true
	var rect := Rect2(ch.coord.x * WorldLayout.CHUNK, ch.coord.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
	for id in layout.pois.keys():
		var p: Dictionary = layout.pois[id]
		if int(p["building"]) >= 0:
			continue
		var pos: Vector3 = p["pos"]
		if not rect.has_point(Vector2(pos.x, pos.z)):
			continue
		var i := 0
		for o in StoryManager.pending_objects(id):
			var od: Dictionary = o
			var so := StoryObject.new()
			ch.add_child(so)
			var off := Vector3(cos(i * 2.1) * 1.2, 0.0, sin(i * 2.1) * 1.2)
			if id == "tunel_manutencao":
				off = Vector3(-2.5 - i * 0.6, 0.0, 0.8)
			var gp := pos + off
			gp.y = ground_y(gp.x, gp.z) + 0.02
			if id == "tunel_manutencao":
				gp.y = WorldLayout.TUNNEL_Y + 0.02
			so.setup(str(od["id"]), str(od["kind"]), gp, randf() * TAU, str(od.get("item", "")))
			i += 1


# ---------------------------------------------------------------------------
# Consultas
# ---------------------------------------------------------------------------
## Altura do chão (usa cache do chunk se existir).
func ground_y(x: float, z: float) -> float:
	var c := Vector2i(floori(x / WorldLayout.CHUNK), floori(z / WorldLayout.CHUNK))
	if WorldLayout.URBAN.has_point(Vector2(x, z)):
		return layout.ground_height(x, z)
	if chunks.has(c):
		var ch: Chunk = chunks[c]
		if ch.h_res > 0 and ch.heights.size() == (ch.h_res + 1) * (ch.h_res + 1):
			var lx := (x - c.x * WorldLayout.CHUNK) / ch.h_cell
			var lz := (z - c.y * WorldLayout.CHUNK) / ch.h_cell
			var ix := clampi(int(lx), 0, ch.h_res - 1)
			var iz := clampi(int(lz), 0, ch.h_res - 1)
			var fx := clampf(lx - ix, 0.0, 1.0)
			var fz := clampf(lz - iz, 0.0, 1.0)
			var n := ch.h_res + 1
			var h00 := ch.heights[iz * n + ix]
			var h10 := ch.heights[iz * n + ix + 1]
			var h01 := ch.heights[(iz + 1) * n + ix]
			var h11 := ch.heights[(iz + 1) * n + ix + 1]
			var h := lerpf(lerpf(h00, h10, fx), lerpf(h01, h11, fx), fz)
			if layout.in_tunnel(Vector3(x, h, z)) or (absf(x) < WorldLayout.TUNNEL_HW and z < WorldLayout.TUNNEL_Z_SOUTH and z > WorldLayout.TUNNEL_Z_NORTH):
				return WorldLayout.TUNNEL_Y
			return h
	return layout.ground_height(x, z)


## Está sob um teto? (prédio, túnel)
func is_indoors(pos: Vector3) -> bool:
	if layout.in_tunnel(pos):
		return true
	var bi := layout.building_at(pos, -0.2)
	if bi < 0:
		return false
	var b: Dictionary = layout.buildings[bi]
	return pos.y < float(b["base"]) + BuildingGen.total_height(b) - 0.2


## Dentro de um prédio com energia (luzes acesas)?
func indoor_powered(pos: Vector3) -> bool:
	var bi := layout.building_at(pos, -0.2)
	if bi < 0 or not is_indoors(pos):
		return false
	return building_powered(bi)


func building_powered(bi: int) -> bool:
	return GameState.world_phase == GameState.Phase.PRE or GameState.has_flag("power_" + str(bi))


func acoustic_mode(pos: Vector3) -> String:
	if layout.in_tunnel(pos):
		return "tunnel"
	var bi := layout.building_at(pos, -0.2)
	if bi >= 0:
		var b: Dictionary = layout.buildings[bi]
		if pos.y < float(b["base"]) + BuildingGen.total_height(b):
			return "lab" if str(b.get("interior", "")) == "lab" else "indoor"
	return "outdoor"


func district_at(pos: Vector3) -> String:
	return layout.district_at(pos.x, pos.z)


func _on_phase_changed(p: int) -> void:
	_eval_timer = 0.0
	# interiores gerados na outra fase (arrumados x abandonados) são refeitos,
	# menos o prédio onde o jogador está agora
	var f := SimScheduler.focus_position
	for c in chunks.keys():
		var ch: Chunk = chunks[c]
		for bi in ch.interiors.keys():
			var d: Dictionary = ch.interiors[bi].get("data", {})
			if int(d.get("phase", p)) == p:
				continue
			var r: Rect2 = (layout.buildings[bi]["rect"] as Rect2).grow(2.0)
			if not r.has_point(Vector2(f.x, f.z)):
				ch.remove_interior(bi)


# ---------------------------------------------------------------------------
# Luz natural pelas janelas (só perto do jogador; sem sombras, baratas)
# ---------------------------------------------------------------------------
func _update_window_lights() -> void:
	var f := SimScheduler.focus_position
	var dl := TimeManager.daylight()
	var sh := TimeManager.sun_height()
	var sd := TimeManager.sun_direction()
	var wm := WeatherManager
	var clouds: float = wm.clouds
	var cand: Array = []
	# só com o jogador dentro de um prédio: de fora não se vê o interior, e cada luz a mais
	# conta no limite de luzes por malha do Compatibility (a lanterna não pode ficar de fora)
	if not is_indoors(f) or layout.in_tunnel(f):
		for l in window_pool:
			(l as SpotLight3D).visible = false
		for l in sunpatch_pool:
			(l as SpotLight3D).visible = false
		return
	var fc := Vector2i(floori(f.x / WorldLayout.CHUNK), floori(f.z / WorldLayout.CHUNK))
	for dz in range(-1, 2):
		for dx in range(-1, 2):
			var c := fc + Vector2i(dx, dz)
			if not chunks.has(c):
				continue
			var ch: Chunk = chunks[c]
			for bi in ch.interiors.keys():
				var d: Dictionary = ch.interiors[bi].get("data", {})
				for w in d.get("windows", []):
					var wp: Vector3 = w["pos"]
					# prioriza o mesmo andar do jogador
					var dy := absf(wp.y - 1.6 - f.y) * 3.0
					var dd := Vector2(wp.x - f.x, wp.z - f.z).length() + dy
					if dd < 16.0:
						cand.append([dd, w])
	cand.sort_custom(func(a, b): return float(a[0]) < float(b[0]))
	var low := int(Settings.graphics["preset"]) <= 1
	# lanterna + brilho dela + estas ≤ 6 (max_lights_per_object)
	var n_sky := 2 if low else 3
	var n_sun := 1
	# cor e força: céu de dia (branco-azulado, mais cinza nublado), âmbar no entardecer, luar à noite
	var dusk := clampf(1.0 - absf(sh) * 3.2, 0.0, 1.0) * smoothstep(-0.25, 0.05, sh)
	# a claridade que entra é rebatida da rua e dos prédios: neutra, levemente quente
	var sky_col := Color(1.0, 0.96, 0.9).lerp(Color(0.86, 0.88, 0.9), clouds * 0.6).lerp(Color(1.0, 0.78, 0.6), dusk * 0.45)
	var moon_col := Color(0.42, 0.5, 0.78)
	var day_e := 1.9 * dl * (1.0 - clouds * 0.35 - float(wm.darkness) * 0.3)
	var night_e := 0.16 * (1.0 - clouds * 0.65) * (1.0 - dl)
	var energy := day_e + night_e
	var col := moon_col.lerp(sky_col, clampf(dl * 1.6, 0.0, 1.0))
	var si := 0
	var pi := 0
	var sun_in := sh > 0.04 and clouds < 0.75
	var sun_e := (0.6 + dl * 2.2) * (1.0 - clouds * 0.8) * smoothstep(0.04, 0.12, sh)
	var sun_col := Color(1.0, 0.9, 0.74).lerp(Color(1.0, 0.68, 0.42), dusk * 0.8)
	for c in cand:
		var w: Dictionary = c[1]
		var wp: Vector3 = w["pos"]
		var n: Vector3 = w["n"]
		var boarded := bool(w.get("boarded", false))
		if si < n_sky:
			var l: SpotLight3D = window_pool[si]
			si += 1
			var aim := (n * 0.9 + Vector3.DOWN * 0.45).normalized()
			l.global_transform = Transform3D(Basis.looking_at(aim, Vector3.UP), wp)
			l.spot_range = float(w.get("depth", 4.0)) + 1.5
			l.light_color = col
			l.light_energy = energy * (0.3 if boarded else 1.0)
			l.visible = l.light_energy > 0.01
		# o sol só entra se estiver do lado de fora desta janela
		if sun_in and pi < n_sun and not boarded and sd.dot(-n) > 0.2:
			var s: SpotLight3D = sunpatch_pool[pi]
			pi += 1
			s.global_transform = Transform3D(Basis.looking_at(-sd, Vector3.UP if absf(sd.y) < 0.98 else Vector3.FORWARD), wp - n * 0.1)
			s.light_color = sun_col
			s.light_energy = sun_e
			s.visible = true
		if si >= n_sky and (pi >= n_sun or not sun_in):
			break
	for i in range(si, window_pool.size()):
		(window_pool[i] as SpotLight3D).visible = false
	for i in range(pi, sunpatch_pool.size()):
		(sunpatch_pool[i] as SpotLight3D).visible = false


# ---------------------------------------------------------------------------
# Luzes reais dos postes (apenas as mais próximas, quando há energia)
# ---------------------------------------------------------------------------
func _update_light_pool() -> void:
	var power: float = ShaderGlobals.get_value("city_power", 0.0)
	var night := 1.0 - TimeManager.daylight()
	var active := power > 0.5 and night > 0.45
	var f := SimScheduler.focus_position
	var candidates: Array = []
	if active:
		var fc := Vector2i(floori(f.x / WorldLayout.CHUNK), floori(f.z / WorldLayout.CHUNK))
		for dz in range(-1, 2):
			for dx in range(-1, 2):
				var c := fc + Vector2i(dx, dz)
				if chunks.has(c):
					for p in (chunks[c] as Chunk).lamps:
						var lp: Vector3 = p
						candidates.append([lp.distance_squared_to(f), lp])
		candidates.sort_custom(func(a, b): return a[0] < b[0])
	var max_lights := 4 if int(Settings.graphics["preset"]) <= 1 else 8
	for i in light_pool.size():
		var l: OmniLight3D = light_pool[i]
		if active and i < candidates.size() and i < max_lights and float(candidates[i][0]) < 90.0 * 90.0:
			l.visible = true
			l.global_position = (candidates[i][1] as Vector3) + Vector3(0, -0.6, 0)
			l.light_energy = 1.6 * power
		else:
			l.visible = false


## Difusores acesos das luminárias fluorescentes (um MultiMesh por interior).
## Lâmpada falhando: a luz e o difusor apagam juntos em pequenas rajadas.
func _flicker(ol: OmniLight3D, panel: Node) -> void:
	var mat: StandardMaterial3D = panel.get_meta("mat") if panel != null and panel.has_meta("mat") else null
	var owner_node: Node = ol if ol != null else panel
	if owner_node == null:
		return
	var e0 := ol.light_energy if ol != null else 0.0
	var cyc := randf_range(3.5, 6.0)
	var tw := owner_node.create_tween().set_loops()
	tw.tween_method(func(k: float) -> void:
		var v := _flicker_level(k)
		if ol:
			ol.light_energy = e0 * v
		if mat:
			mat.emission_energy_multiplier = 2.6 * v
			mat.albedo_color = Color(0.9, 0.92, 0.95) * lerpf(0.35, 1.0, v), 0.0, 1.0, cyc)


static func _flicker_level(k: float) -> float:
	# acesa quase o tempo todo; perto do fim do ciclo, 3 falhas rápidas e uma
	# "quase apagada" antes de voltar
	for w: Vector3 in [Vector3(0.62, 0.635, 0.0), Vector3(0.66, 0.70, 0.08), Vector3(0.715, 0.725, 0.0), Vector3(0.9, 0.93, 0.35)]:
		if k >= w.x and k < w.y:
			return w.z
	return 1.0


func _lamp_panels(xfs: Array) -> MultiMeshInstance3D:
	var q := QuadMesh.new()
	q.size = Vector2(1.16, 0.22)
	q.orientation = PlaneMesh.FACE_Y
	q.flip_faces = true
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.9, 0.92, 0.95)
	# acima de 1 para "estourar" como lâmpada de verdade (e acender o glow)
	m.emission_enabled = true
	m.emission = Color(0.93, 0.96, 1.0)
	m.emission_energy_multiplier = 2.6
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	q.material = m
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = q
	mm.instance_count = xfs.size()
	for i in xfs.size():
		mm.set_instance_transform(i, xfs[i])
	var mi := MultiMeshInstance3D.new()
	mi.name = "LampPanels"
	mi.multimesh = mm
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mi.add_to_group("lamp_panels")
	return mi
