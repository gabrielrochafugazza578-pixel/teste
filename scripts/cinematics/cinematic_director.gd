class_name CinematicDirector
extends Node3D
## Diretor da cinemática de abertura — tudo em tempo real no motor.
##
## A timeline vem de cinematics/opening.json (editável). Cada tomada vira uma
## Animation num AnimationPlayer: trilhas de posição da câmera e do alvo do
## olhar (no referencial de uma âncora do mundo), FOV e trilha de métodos que
## dispara os eventos (atores, sons, luzes, efeitos, fase do mundo...).
## Se existir cinematics/opening_library.tres (gerada por tools/bake_cinematic.gd
## e editável no editor), ela substitui as trilhas geradas do JSON.
##
## Usa o MESMO mundo, os MESMOS personagens/materiais do gameplay. A última
## tomada funde a câmera da cena na câmera de gameplay e devolve o controle
## ao Caio exatamente onde ele está (sem tela preta, sem teleporte).

signal finished
signal shot_started(shot_id: String)

const JSON_PATH := "res://cinematics/opening.json"
const LIB_PATH := "res://cinematics/opening_library.tres"
const LIB_NAME := "opening"

var game: Node
var world: World
var player: Player
var ai: Node
var overlay: CinematicOverlay
var ambience: AmbienceController

var data: Dictionary = {}
var anchor: Node3D
var rig: Node3D
var look: Node3D
var cam: Camera3D
var anim: AnimationPlayer
var cam_fov: float = 60.0
var ground_mode: bool = false
var _hidden_props: Array = []      # [MultiMesh, índice, Transform3D] escondidos da lente
var follow_caio: bool = false
var running: bool = false
var skipping: bool = false
var done: bool = false

var actors: Dictionary = {}
var props: Array = []
var life: CityLife
var _shake: float = 0.0
var _alarm: bool = false
var _flicker_t: float = 0.0
var _flash_t: float = 0.0
var _heli: Array = []          # [{"node", "from", "to", "t", "dur"}]
var _drives: Array = []        # [{"node", "from", "to", "t", "dur"}]
var _blackout_r: float = -1.0
var _blackout_speed: float = 0.0
var _handoff_t: float = -1.0
var _handoff_dur: float = 3.0
var _cine_xf := Transform3D.IDENTITY
var _cur_scene: Dictionary = {}
var _cur_shot: Dictionary = {}
var _phase_now: int = -1
var _interior_bi: int = -1
var _noise := FastNoiseLite.new()
var _t: float = 0.0
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	# reaproveita os nós da cena editável (scenes/cinematics/opening_cinematic.tscn)
	anchor = get_node_or_null("Anchor") as Node3D
	if anchor == null:
		anchor = Node3D.new()
		anchor.name = "Anchor"
		add_child(anchor)
	rig = anchor.get_node_or_null("Rig") as Node3D
	if rig == null:
		rig = Node3D.new()
		rig.name = "Rig"
		anchor.add_child(rig)
	look = anchor.get_node_or_null("Look") as Node3D
	if look == null:
		look = Node3D.new()
		look.name = "Look"
		anchor.add_child(look)
	cam = get_node_or_null("CineCamera") as Camera3D
	if cam == null:
		cam = Camera3D.new()
		cam.name = "CineCamera"
		add_child(cam)
	cam.top_level = true
	cam.near = 0.1
	cam.far = 3400.0
	anim = get_node_or_null("AnimationPlayer") as AnimationPlayer
	if anim == null:
		anim = AnimationPlayer.new()
		anim.name = "AnimationPlayer"
		add_child(anim)
	anim.root_node = NodePath("..")
	life = CityLife.new()
	add_child(life)
	_noise.frequency = 1.4
	_rng.seed = 77


func setup(g: Node) -> void:
	game = g
	world = g.world
	player = g.player
	ai = g.director
	overlay = g.ui.cine
	ambience = g.ambience
	life.setup(world)
	load_timeline()
	overlay.skip_requested.connect(skip)


# ---------------------------------------------------------------------------
# Timeline -> AnimationLibrary
# ---------------------------------------------------------------------------
func load_timeline(path: String = JSON_PATH) -> void:
	var txt := FileAccess.get_file_as_string(path)
	var parsed = JSON.parse_string(txt)
	data = parsed if typeof(parsed) == TYPE_DICTIONARY else {"scenes": []}
	# prioridade: biblioteca salva na cena editável > .tres gerado > JSON
	if anim.has_animation_library(LIB_NAME):
		return
	var lib: AnimationLibrary = null
	if ResourceLoader.exists(LIB_PATH):
		lib = load(LIB_PATH) as AnimationLibrary
	if lib == null:
		lib = build_library(data)
	anim.add_animation_library(LIB_NAME, lib)


## Constrói uma Animation por tomada (usado também pela ferramenta de bake).
static func build_library(d: Dictionary) -> AnimationLibrary:
	var lib := AnimationLibrary.new()
	var scenes: Array = d.get("scenes", [])
	for si in scenes.size():
		var sc: Dictionary = scenes[si]
		var shots: Array = sc.get("shots", [])
		for shi in shots.size():
			var sh: Dictionary = shots[shi]
			lib.add_animation(str(sh["id"]), build_shot(sh, si, shi))
	return lib


static func build_shot(sh: Dictionary, si: int, shi: int) -> Animation:
	var a := Animation.new()
	a.length = float(sh.get("dur", 5.0))
	var tp := a.add_track(Animation.TYPE_VALUE)
	a.track_set_path(tp, NodePath("Anchor/Rig:position"))
	var tl := a.add_track(Animation.TYPE_VALUE)
	a.track_set_path(tl, NodePath("Anchor/Look:position"))
	var tf := a.add_track(Animation.TYPE_VALUE)
	a.track_set_path(tf, NodePath(".:cam_fov"))
	for t in [tp, tl, tf]:
		a.track_set_interpolation_type(t, Animation.INTERPOLATION_CUBIC)
		a.value_track_set_update_mode(t, Animation.UPDATE_CONTINUOUS)
	var keys: Array = sh.get("cam", [])
	# chaves intermediarias com suavização (ease-in/out entre as chaves do JSON)
	for k in keys.size():
		var k0: Array = keys[k]
		var t0 := float(k0[0])
		var p0 := _v(k0[1])
		var l0 := _v(k0[2])
		var f0 := float(k0[3])
		a.track_insert_key(tp, t0, p0)
		a.track_insert_key(tl, t0, l0)
		a.track_insert_key(tf, t0, f0)
		if k + 1 < keys.size():
			var k1: Array = keys[k + 1]
			var t1 := float(k1[0])
			for s: float in [0.2, 0.4, 0.6, 0.8]:
				var e := smoothstep(0.0, 1.0, s)
				a.track_insert_key(tp, lerpf(t0, t1, s), p0.lerp(_v(k1[1]), e))
				a.track_insert_key(tl, lerpf(t0, t1, s), l0.lerp(_v(k1[2]), e))
				a.track_insert_key(tf, lerpf(t0, t1, s), lerpf(f0, float(k1[3]), e))
	var tm := a.add_track(Animation.TYPE_METHOD)
	a.track_set_path(tm, NodePath("."))
	var evs: Array = sh.get("events", [])
	for ei in evs.size():
		var ev: Array = evs[ei]
		a.track_insert_key(tm, clampf(float(ev[0]), 0.0, a.length), {"method": "_ev", "args": [si, shi, ei]})
	return a


static func _v(a) -> Vector3:
	if a is Array and (a as Array).size() >= 3:
		return Vector3(float(a[0]), float(a[1]), float(a[2]))
	return Vector3.ZERO


# ---------------------------------------------------------------------------
# Âncoras (+Z = frente)
# ---------------------------------------------------------------------------
func frame(spec: String) -> Transform3D:
	var parts := spec.split(":")
	match parts[0]:
		"poi":
			return Transform3D(Basis.IDENTITY, world.poi_pos(parts[1]))
		"door":
			var bi := world.building_for_poi(parts[1])
			if bi < 0:
				return Transform3D(Basis.IDENTITY, world.poi_pos(parts[1]))
			var di := BuildingGen.door_info(world.layout.buildings[bi])
			var n: Vector3 = di[1]
			n.y = 0.0
			n = n.normalized()
			var x := Vector3.UP.cross(n).normalized()
			return Transform3D(Basis(x, Vector3.UP, n), di[0])
		"marker":
			var m = world.poi_marker(parts[1], parts[2])
			if m == null:
				return Transform3D(Basis.IDENTITY, world.poi_pos(parts[1]))
			var mt: Transform3D = m
			return Transform3D(Basis(Vector3.UP, mt.basis.get_euler().y + PI), mt.origin)
		"caio", "caio_follow":
			return Transform3D(Basis(Vector3.UP, player._yaw + PI), player.global_position)
	return Transform3D.IDENTITY


func frame_point(spec: String, off) -> Vector3:
	var f := frame(spec)
	var p := f * _v(off)
	if not spec.begins_with("marker") and absf(_v(off).y) < 0.01 and world:
		p.y = world.ground_y(p.x, p.z)
	return p


func frame_dir(spec: String, yaw_deg: float) -> float:
	var f := frame(spec)
	var y := deg_to_rad(yaw_deg)
	var d := f.basis * Vector3(sin(y), 0.0, cos(y))
	return atan2(-d.x, -d.z)


func _anchor_pos(spec: String) -> Vector3:
	return frame(spec).origin


# ---------------------------------------------------------------------------
# Execução
# ---------------------------------------------------------------------------
func play() -> void:
	running = true
	done = false
	skipping = false
	GameState.in_game = true
	player.set_cinematic(true)
	player.visible = false
	player.set_physics_process(false)
	cam.current = true
	SimScheduler.camera = cam
	SimScheduler.cinematic_mode = true
	SimScheduler.focus_node = cam
	if ai:
		ai.enabled = false
	world.view_boost = 1.5
	if game.env:
		game.env.fog_scale = 1.7
	overlay.letterbox_target = 1.0
	overlay.skippable = true
	overlay.fade.color.a = 1.0
	EventBus.cinematic_started.emit(str(data.get("id", "opening")))
	EventBus.hud_visibility.emit(false)
	ambience.start()
	var scenes: Array = data.get("scenes", [])
	# depuração/testes: começar de uma cena específica (Engine meta "cine_from")
	var first := 0
	var from_id := str(Engine.get_meta("cine_from", "")) if Engine.has_meta("cine_from") else ""
	for si in scenes.size():
		if str((scenes[si] as Dictionary).get("id", "")) == from_id:
			first = si
	var last := scenes.size() - 1
	var to_id := str(Engine.get_meta("cine_to", "")) if Engine.has_meta("cine_to") else ""
	for si in scenes.size():
		if str((scenes[si] as Dictionary).get("id", "")) == to_id:
			last = si
	for si in range(first, last + 1):
		if skipping:
			return
		await _enter_scene(si)
		var shots: Array = (scenes[si] as Dictionary).get("shots", [])
		for shi in shots.size():
			if skipping:
				return
			await _play_shot(si, shi)
	if not skipping and not done:
		_complete_handoff()


func _enter_scene(si: int) -> void:
	var sc: Dictionary = data["scenes"][si]
	var prev := _cur_scene
	_cur_scene = sc
	var phase := {"PRE": GameState.Phase.PRE, "SILENCE": GameState.Phase.SILENCE, "POST": GameState.Phase.POST}.get(str(sc.get("phase", "POST")), GameState.Phase.POST) as int
	var need_black := si == 0 or sc.has("card") or phase != _phase_now or str(sc.get("interior", "")) != str(prev.get("interior", "")) or sc.has("fade_in")
	if need_black and overlay.fade.color.a < 0.99:
		await overlay.fade_to(1.0, 0.7).finished
	if skipping:
		return
	_clear_scene_objects(prev.get("keep", false))
	# fase do mundo
	if phase != _phase_now:
		var was_post := _phase_now == GameState.Phase.POST
		_apply_phase(phase)
		if phase == GameState.Phase.POST and not was_post and _phase_now != -1:
			world.rebuild_all()
		_phase_now = phase
	if game.env:
		game.env.exposure = float(sc.get("exposure", 1.0))
		game.env.fog_scale = float(sc.get("fog_scale", 1.7))
		# cidade "normal" mais viva; depois do colapso, a paleta dessatura
		game.env.mood_saturation = float(sc.get("saturation", 0.85))
		game.env.env.fog_sky_affect = float(sc.get("sky_fog", 0.65))
	# luz de preenchimento presa à câmera (cenas noturnas)
	var fill := cam.get_node_or_null("Fill") as OmniLight3D
	if sc.has("fill"):
		if fill == null:
			fill = OmniLight3D.new()
			fill.name = "Fill"
			fill.shadow_enabled = false
			cam.add_child(fill)
		var fa: Array = sc["fill"]
		fill.light_energy = float(fa[0])
		fill.omni_range = float(fa[1])
		fill.light_color = Color(0.75, 0.8, 1.0)
		fill.position = Vector3(0, 1.5, 2.0)
		fill.visible = true
	elif fill:
		fill.visible = false
	TimeManager.locked_hour = float(sc.get("hour", 12.0))
	TimeManager.set_time(float(sc.get("hour", 12.0)))
	var ws := {"CLEAR": WeatherManager.State.CLEAR, "CLOUDY": WeatherManager.State.CLOUDY, "OVERCAST": WeatherManager.State.OVERCAST,
		"RAIN": WeatherManager.State.RAIN, "STORM": WeatherManager.State.STORM, "FOG": WeatherManager.State.FOG}
	WeatherManager.set_weather(int(ws.get(str(sc.get("weather", "CLEAR")), WeatherManager.State.CLEAR)), true, true)
	if sc.has("music"):
		AudioManager.music.play_cue(str(sc["music"]), 0.8)
	# interior
	if _interior_bi >= 0 and str(sc.get("interior", "")) == "":
		world.force_interior(_interior_bi, false)
		_interior_bi = -1
	if str(sc.get("interior", "")) != "":
		_interior_bi = world.building_for_poi(str(sc["interior"]))
		if _interior_bi >= 0:
			world.force_interior(_interior_bi, true)
	# luz de dentro/fora (o jogo só atualiza isso fora da cinemática)
	if game.env:
		var inside := _interior_bi >= 0
		if not inside:
			game.env.emergency = 0.0
		game.env.set_indoor(inside)
		game.env.set_indoor_lit(inside and world.building_powered(_interior_bi) and not bool(sc.get("power_out", false)))
		if need_black:
			game.env.snap_indoor()
	# posiciona a câmera na 1a tomada e espera o mundo carregar
	var shots: Array = sc.get("shots", [])
	world.clear_focus_points()
	if not shots.is_empty():
		_prepare_shot(shots[0])
	for sh in shots:
		var spec: String = (sh as Dictionary).get("anchor", "world")
		if spec.begins_with("caio"):
			continue
		var p := _anchor_pos(spec) if not spec.begins_with("marker") else world.poi_pos(spec.split(":")[1])
		world.focus_points.append(p)
	for sh in shots:
		var spec: String = (sh as Dictionary).get("anchor", "world")
		if spec.begins_with("caio") or skipping:
			continue
		var p := world.poi_pos(spec.split(":")[1]) if spec.split(":").size() > 1 else Vector3.ZERO
		await world.wait_area(p, 55.0, 14.0)
		# "focus": pontos do trajeto (relativos à âncora) que também precisam
		# estar carregados — voos longos saem de perto da âncora
		if not spec.begins_with("marker"):
			for fp in (sh as Dictionary).get("focus", []):
				await world.wait_area(frame(spec) * _v(fp), 60.0, 14.0)
	if sc.has("preload") and not shots.is_empty():
		# tomadas aéreas: a cidade inteira à vista precisa existir (LOD distante)
		var spec0: String = (shots[0] as Dictionary).get("anchor", "world")
		if not spec0.begins_with("caio") and not skipping:
			await world.wait_loaded(_anchor_pos(spec0), float(sc["preload"]), 25.0)
	if _interior_bi >= 0:
		var t := 0.0
		while world.interior_root(_interior_bi) == null and t < 15.0 and not skipping:
			await get_tree().process_frame
			t += get_process_delta_time()
		# marcadores válidos: reposiciona a câmera da 1a tomada
		if not shots.is_empty():
			_prepare_shot(shots[0])
		_set_lamps(world.building_powered(_interior_bi) and not bool(sc.get("power_out", false)))
	if sc.has("card"):
		var c: Array = sc["card"]
		overlay.show_card(str(c[0]), str(c[1]), float(c[2]))
		await get_tree().create_timer(float(c[2]) + 2.6).timeout
	# eventos de preparação
	for ev in sc.get("setup", []):
		_run_event(ev as Array, 0)
	for i in 8:
		await get_tree().process_frame
	if skipping:
		return
	if overlay.fade.color.a > 0.01:
		overlay.fade_to(0.0, float(sc.get("fade_in", 1.0)))


func _prepare_shot(sh: Dictionary) -> void:
	var spec: String = sh.get("anchor", "world")
	anchor.global_transform = frame(spec)
	follow_caio = spec == "caio_follow"
	ground_mode = bool(sh.get("ground", false))
	var keys: Array = sh.get("cam", [])
	if not keys.is_empty():
		rig.position = _v(keys[0][1])
		look.position = _v(keys[0][2])
		cam_fov = float(keys[0][3])
	_update_camera(0.0)


func _play_shot(si: int, shi: int) -> void:
	var sh: Dictionary = data["scenes"][si]["shots"][shi]
	_cur_shot = sh
	_prepare_shot(sh)
	shot_started.emit(str(sh["id"]))
	EventBus.cinematic_shot.emit(str(data.get("id", "opening")), str(sh["id"]))
	var dur := float(sh.get("dur", 5.0))
	_handoff_t = -1.0
	if sh.has("handoff"):
		_handoff_dur = float(sh["handoff"])
		_handoff_t = 0.0
	_clear_camera_path(sh)
	anim.play(LIB_NAME + "/" + str(sh["id"]))
	var t := 0.0
	while t < dur and not skipping and anim.is_playing():
		await get_tree().process_frame
		t += get_process_delta_time()
		if _handoff_t >= 0.0:
			_handoff_t = clampf((t - (dur - _handoff_dur)) / _handoff_dur, 0.0, 1.0)
			if _handoff_t >= 1.0:
				break
	_restore_camera_path()


## Esconde árvores/postes/lixeiras (instâncias de MultiMesh dos chunks) que
## ficariam colados na lente ao longo do trajeto da câmera desta tomada —
## a posição dos props é procedural, então a tomada nunca "nasce" atrás de um
## tronco. Restaurado ao fim da tomada.
func _clear_camera_path(sh: Dictionary) -> void:
	_restore_camera_path()
	if world == null or str(sh.get("anchor", "")) == "caio_follow":
		return
	var keys: Array = sh.get("cam", [])
	if keys.is_empty():
		return
	var fr := anchor.global_transform
	var pts: Array = []
	for i in keys.size():
		var p: Vector3 = fr * _v(keys[i][1])
		if bool(sh.get("ground", false)):
			p.y += world.ground_y(p.x, p.z) - fr.origin.y
		pts.append(p)
		if i + 1 < keys.size():
			var q: Vector3 = fr * _v(keys[i + 1][1])
			pts.append(p.lerp(q, 0.5))
	var lo := Vector2(INF, INF)
	var hi := Vector2(-INF, -INF)
	for p: Vector3 in pts:
		lo = Vector2(minf(lo.x, p.x), minf(lo.y, p.z))
		hi = Vector2(maxf(hi.x, p.x), maxf(hi.y, p.z))
	var box := Rect2(lo, hi - lo).grow(3.0)
	for c: Vector2i in world.chunks.keys():
		var cr := Rect2(c.x * WorldLayout.CHUNK, c.y * WorldLayout.CHUNK, WorldLayout.CHUNK, WorldLayout.CHUNK)
		if not cr.intersects(box):
			continue
		for n in (world.chunks[c] as Node).get_children():
			var mmi := n as MultiMeshInstance3D
			if mmi == null or mmi.multimesh == null:
				continue
			var mm := mmi.multimesh
			var aabb := mm.mesh.get_aabb() if mm.mesh else AABB()
			# grama e flores ficam (baixas); só esconde o que tem altura de gente
			if aabb.size.y < 1.2:
				continue
			for i in mm.instance_count:
				var xf := mm.get_instance_transform(i)
				var o := mmi.global_transform * xf.origin
				if not box.has_point(Vector2(o.x, o.z)):
					continue
				for k in pts.size():
					var p: Vector3 = pts[k]
					var dmin := Vector2(o.x - p.x, o.z - p.z).length()
					if k + 1 < pts.size():
						dmin = minf(dmin, Util.dist_point_segment_2d(Vector2(o.x, o.z), Vector2(p.x, p.z), Vector2((pts[k + 1] as Vector3).x, (pts[k + 1] as Vector3).z)))
					var top := o.y + aabb.end.y * xf.basis.get_scale().y
					if dmin < 1.9 and p.y > o.y - 0.5 and p.y < top + 1.0:
						_hidden_props.append([mm, i, xf])
						mm.set_instance_transform(i, Transform3D(Basis.from_scale(Vector3.ONE * 0.0001), xf.origin))
						break


func _restore_camera_path() -> void:
	for e: Array in _hidden_props:
		var mm: MultiMesh = e[0]
		if is_instance_valid(mm):
			mm.set_instance_transform(int(e[1]), e[2])
	_hidden_props.clear()


func _apply_phase(phase: int) -> void:
	GameState.set_phase(phase)
	match phase:
		GameState.Phase.PRE:
			ShaderGlobals.set_value("world_decay", 0.0)
			ShaderGlobals.set_value("veg_growth", 0.0)
			ShaderGlobals.set_value("city_power", 1.0)
		GameState.Phase.SILENCE:
			ShaderGlobals.set_value("world_decay", 0.35)
			ShaderGlobals.set_value("veg_growth", 0.25)
			ShaderGlobals.set_value("city_power", 0.0)
		_:
			ShaderGlobals.set_value("world_decay", 1.0)
			ShaderGlobals.set_value("veg_growth", 1.0)
			ShaderGlobals.set_value("city_power", 0.0)
	ShaderGlobals.set_value("blackout_radius", 0.0)


# ---------------------------------------------------------------------------
# Câmera por frame
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	_t += delta
	if not running:
		return
	if follow_caio:
		var target := frame("caio")
		anchor.global_transform = anchor.global_transform.interpolate_with(target, 1.0 - exp(-delta * 3.0))
	_update_camera(delta)
	_update_fx(delta)


func _update_camera(delta: float) -> void:
	var p := rig.global_position
	var l := look.global_position
	if ground_mode and world:
		var base_y := anchor.global_position.y
		p.y += world.ground_y(p.x, p.z) - base_y
		l.y += world.ground_y(l.x, l.z) - base_y
	_shake = maxf(0.0, _shake - delta * 0.8)
	var sh := Vector3(_noise.get_noise_2d(_t * 20.0, 3.0), _noise.get_noise_2d(_t * 20.0, 9.0), 0.0) * _shake * 0.3 * float(Settings.accessibility.get("camera_shake", 1.0))
	var xf := Transform3D(Basis.IDENTITY, p)
	if p.distance_to(l) > 0.01:
		xf = xf.looking_at(l, Vector3.UP)
	xf.origin += xf.basis * sh
	_cine_xf = xf
	var fov := cam_fov
	if _handoff_t > 0.0 and player:
		# funde a câmera da cena na câmera de gameplay (atrás do ombro do Caio)
		player.cam_rig.align_to(Transform3D(Basis(Vector3.UP, player._yaw), Vector3.ZERO))
		var gxf := player.cam_rig.cam.global_transform
		var s := smoothstep(0.0, 1.0, _handoff_t)
		xf = xf.interpolate_with(gxf, s)
		fov = lerpf(cam_fov, player.cam_rig.cam.fov, s)
	cam.global_transform = xf
	cam.fov = fov


func _update_fx(delta: float) -> void:
	# giroflex
	_flash_t += delta
	for n in get_tree().get_nodes_in_group("cine_flash"):
		var l := n as OmniLight3D
		var ph := 0.0 if l.name == "Flash0" else PI
		l.light_energy = 3.0 * maxf(0.0, sin(_flash_t * 9.0 + ph))
	# alarme: luzes do interior piscam em vermelho
	if _alarm or _flicker_t > 0.0:
		_flicker_t = maxf(0.0, _flicker_t - delta)
		var root := world.interior_root(_interior_bi) if _interior_bi >= 0 else null
		if root:
			for c in root.get_children():
				if c is OmniLight3D and c.is_in_group("interior_light"):
					var ol := c as OmniLight3D
					if _alarm:
						ol.light_color = Color(1.0, 0.12, 0.08)
						ol.light_energy = 0.3 + 1.4 * maxf(0.0, sin(_t * 5.0))
					else:
						ol.light_energy = 0.9 if _rng.randf() > 0.35 else 0.05
		# o ambiente pulsa junto: corredor e salas sem luz própria também ficam vermelhos
		if _alarm and game.env:
			game.env.emergency = 0.45 + 0.55 * maxf(0.0, sin(_t * 5.0))
	# helicópteros e veículos em movimento
	for h in _heli:
		h["t"] = float(h["t"]) + delta
		var k := clampf(float(h["t"]) / float(h["dur"]), 0.0, 1.0)
		var node: Node3D = h["node"]
		var from: Vector3 = h["from"]
		var to: Vector3 = h["to"]
		node.global_position = from.lerp(to, k)
		var dir := (to - from).normalized()
		node.rotation.y = atan2(-dir.x, -dir.z)
		node.rotation.x = -0.12
		var rotor := node.get_node_or_null("Rotor") as Node3D
		if rotor:
			rotor.rotation.y += delta * 28.0
		var blink := node.get_node_or_null("Blink") as OmniLight3D
		if blink:
			blink.light_energy = 3.0 if fmod(_t, 1.0) < 0.1 else 0.0
	for d in _drives:
		d["t"] = float(d["t"]) + delta
		var k := clampf(float(d["t"]) / float(d["dur"]), 0.0, 1.0)
		var e := 1.0 - pow(1.0 - k, 2.0)
		var node: Node3D = d["node"]
		var from: Vector3 = d["from"]
		var to: Vector3 = d["to"]
		var p := from.lerp(to, e)
		p.y = world.ground_y(p.x, p.z)
		node.global_position = p
	# onda de apagão
	if _blackout_r >= 0.0:
		_blackout_r += _blackout_speed * delta
		ShaderGlobals.set_value("blackout_radius", _blackout_r)
		if _blackout_r > 2600.0:
			_blackout_r = -1.0
			ShaderGlobals.set_value("city_power", 0.0)
			ShaderGlobals.set_value("blackout_radius", 0.0)


# ---------------------------------------------------------------------------
# Eventos
# ---------------------------------------------------------------------------
func _ev(si: int, shi: int, ei: int) -> void:
	if skipping or not running:
		return
	var ev: Array = data["scenes"][si]["shots"][shi]["events"][ei]
	if Engine.has_meta("cine_log"):
		print("[cine] evento ", ev)
	_run_event(ev, 1)


## ev = [tempo?, ação, args...] (setup: [ação, args...])
func _run_event(ev: Array, start: int) -> void:
	if ev.size() <= start:
		return
	var act := str(ev[start])
	var a := ev.slice(start + 1)
	match act:
		"card":
			if str(a[0]) != "":
				overlay.show_card(str(a[0]), str(a[1]), float(a[2]))
		"sound":
			AudioManager.play_2d(str(a[0]), float(a[1]))
		"sound3d":
			AudioManager.play_3d(str(a[0]), frame_point(str(a[1]), a[2]), float(a[3]), 1.0, 90.0)
		"subtitle":
			EventBus.subtitle.emit(str(a[0]), str(a[1]), float(a[2]))
		"music":
			AudioManager.music.play_cue(str(a[0]), 0.8)
		"shake":
			_shake = maxf(_shake, float(a[0]))
		"alarm":
			_alarm = bool(a[0])
			if _alarm:
				AudioManager.loop_2d("cine_alarm", "alarm", -8.0, "SFX")
			else:
				AudioManager.stop_loop("cine_alarm")
				_emergency_steady()
		"lights":
			# queda de energia: difusores apagam, só as luzes de emergência piscam
			_alarm = true
			_set_lamps(false)
		"flicker":
			_alarm = false
			_flicker_t = float(a[1])
		"door":
			var root := world.interior_root(world.building_for_poi(str(a[0])))
			if root:
				for c in root.get_children():
					if c is Door and (c as Door).target_id == "door_" + str(a[1]):
						(c as Door).set_open(bool(a[2]))
		"sparks":
			CineFX.sparks(self, frame(str(a[0])) * _v(a[1]))
		"smoke":
			props.append(CineFX.smoke(self, frame(str(a[0])) * _v(a[1]), true))
		"smoke_column":
			props.append(CineFX.smoke_column(self, frame_point(str(a[0]), a[1])))
		"papers":
			props.append(CineFX.papers(self, frame_point(str(a[0]), a[1]) + Vector3(0, 0.3, 0)))
		"tv":
			props.append(CineFX.tv(self, frame_point(str(a[0]), a[1]), frame_dir(str(a[0]), float(a[2]))))
		"actor":
			_spawn_actor(str(a[0]), str(a[1]), str(a[2]), a[3], float(a[4]), str(a[5]) if a.size() > 5 else "")
		"actors_clear":
			_clear_actors()
		"place":
			var ac := actors.get(str(a[0]), null) as CineActor
			if ac:
				var p := frame(str(a[1])) * _v(a[2])
				ac.place(p, frame_dir(str(a[1]), float(a[3])))
		"walk":
			var ac := actors.get(str(a[0]), null) as CineActor
			if ac:
				ac.walk_to(frame(str(a[1])) * _v(a[2]), float(a[3]))
		"face":
			var ac := actors.get(str(a[0]), null) as CineActor
			if ac:
				ac.face(frame(str(a[1])) * _v(a[2]))
		"anim":
			if str(a[0]) == "caio":
				player.body.play(str(a[1]), 1.0)
			else:
				var ac := actors.get(str(a[0]), null) as CineActor
				if ac:
					ac.play(str(a[1]))
		"infect":
			var ac := actors.get(str(a[0]), null) as CineActor
			if ac:
				ac.infect(float(a[1]), float(a[2]))
		"traffic":
			var on = a[0]
			if on is bool and not on:
				life.set_traffic(false, Vector3.ZERO)
			else:
				life.set_traffic(true, _anchor_pos(str(a[1])), str(on) == "panic")
		"crowd":
			var spec := str(a[1]) if a.size() > 1 else "world"
			life.set_crowd(str(a[0]), _anchor_pos(spec), frame(spec))
		"anim_crowd":
			life.anim_crowd(str(a[0]))
		"crowd_at":
			for ac in life.crowd_at(frame(str(a[0])), str(a[1]), int(a[2])):
				props.append(ac)
		"vehicle":
			var v := _vehicle(str(a[1]), frame_point(str(a[2]), a[3]), frame_dir(str(a[2]), float(a[4])), bool(a[5]))
			actors[str(a[0])] = v
		"drive":
			var from := frame_point(str(a[2]), a[3])
			var to := frame_point(str(a[2]), a[4])
			var dir := (to - from).normalized()
			var v := _vehicle(str(a[1]), from, atan2(-dir.x, -dir.z), true)
			actors[str(a[0])] = v
			_drives.append({"node": v, "from": from, "to": to, "t": 0.0, "dur": float(a[5])})
		"helicopter":
			var h := CineFX.helicopter(self)
			props.append(h)
			var from := frame(str(a[0])) * _v(a[1])
			var to := frame(str(a[0])) * _v(a[2])
			h.global_position = from
			AudioManager.attach_loop("helicopter", h, 2.0, 220.0)
			_heli.append({"node": h, "from": from, "to": to, "t": 0.0, "dur": float(a[3])})
		"blackout":
			ShaderGlobals.set_value("blackout_origin", frame_point(str(a[0]), a[1]))
			_blackout_r = 0.0
			_blackout_speed = float(a[2])
		"barricade":
			_barricade(frame_point(str(a[0]), a[1]))
		"infected":
			if ai and ai.has_method("spawn_scripted"):
				var inf: Infected = ai.spawn_scripted(str(a[0]), frame_point(str(a[1]), a[2]), frame_dir(str(a[1]), float(a[3])), Infected.S.WANDER, _rng.randi() % 1000)
				props.append(inf)
		"ambience":
			match str(a[0]):
				"city":
					ambience.phase_override = GameState.Phase.PRE
					ambience.panic = 0.0
					ambience.mode = "outdoor"
				"lab":
					ambience.mode = "lab"
					ambience.panic = 0.0
				"panic":
					ambience.phase_override = GameState.Phase.PRE
					ambience.panic = 1.0
					ambience.mode = "outdoor"
				"silence":
					ambience.phase_override = GameState.Phase.SILENCE
					ambience.panic = 0.0
					ambience.mode = "outdoor"
				_:
					ambience.phase_override = -1
					ambience.panic = 0.0
					ambience.mode = "outdoor"
		"caio":
			var p := _floor_at(frame_point(str(a[0]), a[1]))
			player.global_position = p + Vector3(0, 0.08, 0)
			player.set_yaw(frame_dir(str(a[0]), float(a[2])))
			player.velocity = Vector3.ZERO
			player.visible = true
			player.set_physics_process(true)
			player.body.force_update()
		"caio_walk":
			player.cinematic_walk_to(frame_point(str(a[0]), a[1]), float(a[2]))
		"caio_face":
			player.cinematic_face(frame_point(str(a[0]), a[1]) - player.global_position)
		"screens":
			pass
		_:
			push_warning("Cinemática: evento desconhecido '%s'" % act)


## Chão real (colisão) sob um ponto — evita colocar o Caio dentro do piso.
func _floor_at(p: Vector3) -> Vector3:
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(p + Vector3(0, 2.5, 0), p + Vector3(0, -6.0, 0), 1)
	var hit := space.intersect_ray(q)
	if not hit.is_empty():
		return hit["position"]
	return p


func _appearance(spec: String) -> Dictionary:
	var p := spec.split(":")
	match p[0]:
		"helena": return Appearance.helena()
		"patient": return Appearance.patient()
		"researcher": return Appearance.researcher(int(p[1]) if p.size() > 1 else 1)
		"police": return Appearance.police(int(p[1]) if p.size() > 1 else 1)
		"paramedic": return Appearance.paramedic(int(p[1]) if p.size() > 1 else 1)
		"civilian": return Appearance.civilian(int(p[1]) if p.size() > 1 else 1)
	return Appearance.civilian(Util.hash_str(spec) % 1000)


func _spawn_actor(id: String, ap: String, spec: String, off, yaw: float, anim_name: String) -> CineActor:
	var a := CineActor.new()
	add_child(a)
	a.setup(_appearance(ap), world, 0)
	a.place(frame(spec) * _v(off), frame_dir(spec, yaw))
	if anim_name != "":
		a.play(anim_name)
	actors[id] = a
	return a


func _vehicle(type: String, pos: Vector3, yaw: float, lights: bool) -> Node3D:
	var root := Node3D.new()
	add_child(root)
	var mi := MeshInstance3D.new()
	mi.mesh = VehicleMeshBuilder.mesh(type)
	var col := Color(0.95, 0.95, 0.93)
	if type == "police":
		col = Color(0.92, 0.92, 0.95)
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.metallic = 0.3
	m.roughness = 0.35
	mi.set_surface_override_material(0, m)
	root.add_child(mi)
	root.global_position = pos
	root.rotation.y = yaw
	if lights:
		CineFX.lightbar(root, float(VehicleMeshBuilder.dims(type)["roof"]))
		if type == "ambulance":
			AudioManager.attach_loop("siren", root, -2.0, 140.0)
	props.append(root)
	return root


func _barricade(p: Vector3) -> void:
	var root := Node3D.new()
	add_child(root)
	root.global_position = p
	for i in 5:
		var mi := MeshInstance3D.new()
		mi.mesh = PropLib.mesh("sandbags" if i % 2 == 0 else "concrete_barrier")
		mi.position = Vector3(-6.0 + i * 3.0, 0, 0)
		root.add_child(mi)
	props.append(root)
	var v := _vehicle("police", p + Vector3(8.5, 0, -3.0), 0.4, true)
	for k in 2:
		var a := _spawn_actor("pm_%d" % k, "police:%d" % (20 + k), "world", [p.x - 3.0 + k * 5.0, p.y, p.z + 1.2], 0.0, "guard_idle")
		props.append(a)


func _clear_actors() -> void:
	for id in actors.keys():
		var n: Variant = actors[id]
		if is_instance_valid(n):
			n.queue_free()
	actors.clear()


## Liga/desliga os difusores das luminárias e a luz ambiente "acesa" do interior.
func _set_lamps(on: bool) -> void:
	var root := world.interior_root(_interior_bi) if _interior_bi >= 0 else null
	if root:
		for n in root.get_children():
			if n.is_in_group("lamp_panels"):
				(n as Node3D).visible = on
	if game.env:
		game.env.set_indoor_lit(on)
		if not on:
			game.env.indoor_lit = 0.0
		game.env.emergency = 0.0 if on else 0.6


## Depois do alarme: luz de emergência vermelha fixa; o isolamento tem luz própria.
func _emergency_steady() -> void:
	var root := world.interior_root(_interior_bi) if _interior_bi >= 0 else null
	if root == null:
		return
	for c in root.get_children():
		if c is OmniLight3D and c.is_in_group("interior_light"):
			var ol := c as OmniLight3D
			if str(ol.get_meta("room_type", "")) == "isolation":
				ol.light_color = Color(0.85, 0.95, 1.0)
				ol.light_energy = 1.3
			else:
				ol.light_color = Color(1.0, 0.16, 0.1)
				ol.light_energy = 0.55
	if game.env:
		game.env.emergency = 0.6


func _clear_scene_objects(keep: bool = false) -> void:
	if keep:
		return
	for p in props:
		if is_instance_valid(p):
			if p is Infected:
				if ai:
					ai.release(p)
			else:
				(p as Node).queue_free()
	props.clear()
	_heli.clear()
	_drives.clear()
	_alarm = false
	AudioManager.stop_loop("cine_alarm")


# ---------------------------------------------------------------------------
# Fim / pular
# ---------------------------------------------------------------------------
func _complete_handoff() -> void:
	if done:
		return
	done = true
	running = false
	anim.stop()
	_clear_scene_objects()
	_clear_actors()
	life.clear_all()
	life.set_crowd("off", Vector3.ZERO)
	if _interior_bi >= 0:
		world.force_interior(_interior_bi, false)
		_interior_bi = -1
	world.clear_focus_points()
	world.view_boost = 1.0
	if game.env:
		game.env.fog_scale = 1.0
		game.env.exposure = 1.0
		game.env.mood_saturation = 0.85
		game.env.env.fog_sky_affect = 0.65
		game.env.emergency = 0.0
		game.env.set_indoor_lit(false)
	player.cam_rig.align_to(Transform3D(Basis(Vector3.UP, player._yaw), Vector3.ZERO))
	player.cam_rig.cam.current = true
	SimScheduler.camera = player.cam_rig.cam
	SimScheduler.cinematic_mode = false
	SimScheduler.focus_node = player
	player.set_cinematic(false)
	player.visible = true
	player.set_physics_process(true)
	overlay.letterbox_target = 0.0
	ambience.phase_override = -1
	ambience.panic = 0.0
	TimeManager.locked_hour = -1.0
	WeatherManager.locked = false
	AudioManager.music.stop_cue()
	AudioManager.music.start_layers()
	EventBus.hud_visibility.emit(true)
	EventBus.cinematic_finished.emit(str(data.get("id", "opening")))
	EventBus.gameplay_control_given.emit()
	finished.emit()


func skip() -> void:
	if skipping or done:
		return
	skipping = true
	anim.stop()
	await overlay.fade_to(1.0, 0.6).finished
	_clear_scene_objects()
	_clear_actors()
	life.clear_all()
	life.set_crowd("off", Vector3.ZERO)
	if _phase_now != GameState.Phase.POST:
		_apply_phase(GameState.Phase.POST)
		world.rebuild_all()
		_phase_now = GameState.Phase.POST
	TimeManager.locked_hour = -1.0
	TimeManager.set_time(17.6)
	WeatherManager.set_weather(WeatherManager.State.CLOUDY, true, false)
	# o Caio fica no alto da descida, olhando para a cidade
	var p := world.poi_pos("mirante").lerp(world.poi_pos("inicio_gameplay"), 0.35)
	p.y = world.ground_y(p.x, p.z)
	world.clear_focus_points()
	await world.wait_area(p, 40.0, 15.0)
	p = _floor_at(p) + Vector3(0, 0.08, 0)
	player.global_position = p
	var d := world.poi_pos("inicio_gameplay") - world.poi_pos("mirante")
	player.set_yaw(atan2(-d.x, -d.z))
	world.clear_focus_points()
	SimScheduler.focus_node = player
	await world.wait_area(p, 60.0, 15.0)
	for i in 6:
		await get_tree().process_frame
	_complete_handoff()
	EventBus.subtitle.emit("", "", 0.0)
	overlay.fade_to(0.0, 1.2)
