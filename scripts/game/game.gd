class_name Game
extends Node3D
## Cena principal do jogo: monta mundo, ambiente, clima, jogador, IA,
## sobreviventes, veículos, estruturas, cinemática e interface; aplica o save
## carregado; checa objetivos por posição (2 Hz), descobertas de locais,
## interiores/acústica, elevador do Setor 7, sono, morte e finais.

var layout: WorldLayout
var world: World
var env: EnvironmentController
var weather_fx: WeatherFX
var player: Player
var director: AIDirector
var survivors: SurvivorManager
var vehicles: VehicleManager
var structures: StructureManager
var events: EventDirector
var ambience: AmbienceController
var cinematic: CinematicDirector = null
var ui: GameUI
var loading: LoadingScreen
var setor7: Setor7 = null
var waypoint: Vector3 = Vector3.INF
var transitioning: bool = false
var ready_to_play: bool = false
var _tick: float = 0.0
var _last_indoor: bool = false
var _dialogue_npc: Node = null


func _ready() -> void:
	SaveManager.game = self
	UITheme.apply_scale(get_tree())
	var cl := CanvasLayer.new()
	cl.layer = 50
	add_child(cl)
	loading = LoadingScreen.new()
	cl.add_child(loading)
	loading.set_progress(0.02, "Preparando Santa Aurora…")
	await get_tree().process_frame
	if not Assets.is_baked:
		loading.set_progress(0.05, "Gerando texturas…")
		await Assets.bake_all()
	if not AudioManager.is_ready:
		loading.set_progress(0.15, "Sintetizando sons…")
		AudioManager.generate_async()
		while AudioManager.generating:
			loading.set_progress(0.15 + AudioManager.progress * 0.2, "Sintetizando sons… %d%%" % int(AudioManager.progress * 100.0))
			await get_tree().process_frame
		if not AudioManager.is_ready:
			await AudioManager.audio_ready
	var new_game := GameState.start_mode != "load"
	if new_game:
		var skip := GameState.skip_opening
		GameState.new_game()
		GameState.skip_opening = skip
		MissionManager.reset()
		StoryManager.reset()
		FactionManager.reset()
		TimeManager.set_time(9.4, 1)
		GameState.world_phase = GameState.Phase.PRE if not GameState.skip_opening else GameState.Phase.POST
	loading.set_progress(0.38, "Gerando o mundo…")
	await get_tree().process_frame
	layout = WorldLayout.new()
	layout.generate(GameState.world_seed)
	_register_extra_pois()
	_apply_phase_globals()
	_build_scene()
	loading.set_progress(0.5, "Carregando a região…")
	var spawn := _spawn_point(new_game)
	player.global_position = spawn + Vector3(0, 0.1, 0)
	player.set_physics_process(false)   # sem chão até o mundo carregar
	SimScheduler.focus_node = player
	if new_game and not GameState.skip_opening:
		# a cinemática começa sobre a Avenida Central
		SimScheduler.focus_node = null
		SimScheduler.focus_position = layout.poi_pos("avenida_central")
		await world.wait_area(layout.poi_pos("avenida_central"), 90.0, 40.0)
	else:
		await world.wait_area(spawn, 80.0, 40.0)
	loading.set_progress(0.9, "Últimos ajustes…")
	if not new_game:
		_apply_save(GameState.pending_save)
		GameState.pending_save = {}
	await get_tree().process_frame
	loading.set_progress(1.0, "")
	GameState.in_game = true
	ready_to_play = true
	if new_game and not GameState.skip_opening:
		loading.get_parent().queue_free()
		_start_opening()
	else:
		ui.cine.fade.color.a = 1.0
		loading.get_parent().queue_free()
		player.set_physics_process(true)
		ui.cine.fade_to(0.0, 1.2)
		_begin_gameplay(new_game)


func _exit_tree() -> void:
	SimScheduler.clear_all()
	SimScheduler.focus_node = null
	SimScheduler.cinematic_mode = false
	if SaveManager.game == self:
		SaveManager.game = null
	GameState.in_game = false


func _register_extra_pois() -> void:
	var lab := layout.poi_pos("lab_nexus")
	layout.pois["setor7"] = {"id": "setor7", "pos": Setor7.origin_for(lab), "name": "Setor 7", "kind": "secret", "building": -1, "radius": 30.0}
	layout.pois["margem_sul"] = {"id": "margem_sul", "pos": Vector3(0, 0, 820), "name": "Margem sul do Rio Aurora", "kind": "area", "building": -1, "radius": 60.0}
	layout.pois["mirante_baixo"] = {"id": "mirante_baixo", "pos": Vector3(0, layout.ground_height(0, -820), -820), "name": "Pé da serra", "kind": "area", "building": -1, "radius": 30.0}


func _apply_phase_globals() -> void:
	match GameState.world_phase:
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


func _build_scene() -> void:
	env = EnvironmentController.new()
	env.name = "Environment"
	add_child(env)
	world = World.new()
	world.name = "World"
	add_child(world)
	world.setup(layout)
	player = Player.new()
	player.name = "Caio"
	add_child(player)
	player.world = world
	weather_fx = WeatherFX.new()
	weather_fx.name = "WeatherFX"
	add_child(weather_fx)
	weather_fx.camera = player.cam_rig.cam
	director = AIDirector.new()
	director.name = "AIDirector"
	add_child(director)
	director.setup(player, world)
	survivors = SurvivorManager.new()
	survivors.name = "Survivors"
	add_child(survivors)
	survivors.setup(player, world, director)
	vehicles = VehicleManager.new()
	vehicles.name = "Vehicles"
	add_child(vehicles)
	vehicles.setup(player, world)
	structures = StructureManager.new()
	structures.name = "Structures"
	add_child(structures)
	ambience = AmbienceController.new()
	ambience.name = "Ambience"
	add_child(ambience)
	ambience.world = world
	ambience.listener = player
	events = EventDirector.new()
	events.name = "Events"
	add_child(events)
	events.setup(self, player, world, director, survivors)
	ui = GameUI.new()
	ui.name = "UI"
	add_child(ui)
	ui.bind(self, player)
	player.cam_rig.cam.current = true
	SimScheduler.camera = player.cam_rig.cam
	EventBus.elevator_requested.connect(_on_elevator)
	EventBus.ending_requested.connect(_on_ending)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.ui_screen_closed.connect(_on_screen_closed)


func _spawn_point(new_game: bool) -> Vector3:
	if not new_game and GameState.pending_save.has("player"):
		var pd: Dictionary = GameState.pending_save["player"]
		if pd.has("pos"):
			return pd["pos"]
	if new_game and GameState.skip_opening:
		var p := layout.poi_pos("inicio_gameplay")
		p.y = layout.ground_height(p.x, p.z)
		return p
	var c := layout.poi_pos("chegada_caio")
	return Vector3(c.x, layout.ground_height(c.x, c.z), c.z)


# ---------------------------------------------------------------------------
# Abertura e início do gameplay
# ---------------------------------------------------------------------------
func _start_opening() -> void:
	cinematic = (load("res://scenes/cinematics/opening_cinematic.tscn") as PackedScene).instantiate() as CinematicDirector
	cinematic.name = "OpeningCinematic"
	add_child(cinematic)
	cinematic.setup(self)
	cinematic.finished.connect(func() -> void: _begin_gameplay(true))
	cinematic.play()


func _begin_gameplay(new_game: bool) -> void:
	GameState.set_phase(GameState.Phase.POST)
	_apply_phase_globals()
	GameState.in_game = true
	director.enabled = true
	ambience.start()
	AudioManager.music.start_layers()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.control_enabled = true
	if new_game:
		player.give_starting_kit()
		MissionManager.start("m1_retorno")
		StoryManager.start_chapter(1)
		GameState.discover("mirante")
		SaveManager.autosave()
	if cinematic:
		var c := cinematic
		cinematic = null
		c.queue_free.call_deferred()
	structures.setup(player, world)
	EventBus.hud_visibility.emit(true)


func _apply_save(d: Dictionary) -> void:
	if d.has("player"):
		player.from_dict(d["player"])
	director.from_dict(d.get("director", {}))
	survivors.from_dict(d.get("survivors", {}))
	vehicles.from_dict(d.get("vehicles", {}))
	events.from_dict(d.get("events", {}))
	if d.has("waypoint"):
		waypoint = d["waypoint"]
	# itens largados no mundo
	for di in GameState.dropped_items:
		var ip := ItemPickup.new()
		ip.uid = "drop_saved"
		add_child(ip)
		ip.setup(di["stack"], Util.v3(di["pos"]), true)
	if bool(d.get("underground", false)):
		_enter_setor7(false)


## Dados da cena para o SaveManager.
func collect_save() -> Dictionary:
	return {"player": player.to_dict(), "director": director.to_dict(), "survivors": survivors.to_dict(),
		"vehicles": vehicles.to_dict(), "events": events.to_dict(), "waypoint": waypoint, "underground": is_underground()}


func can_save() -> bool:
	if not ready_to_play or transitioning or player.cinematic or player.survival.dead:
		return false
	if cinematic != null:
		return false
	if director and director.threat > 0.5:
		return false
	if player.in_vehicle is Vehicle and (player.in_vehicle as Vehicle).speed_kmh > 5.0:
		return false
	return true


func location_name() -> String:
	if is_underground():
		return "Setor 7"
	var p := player.global_position
	var best := ""
	var bd := 99999.0
	for id in layout.pois.keys():
		var poi: Dictionary = layout.pois[id]
		var d := Vector2(p.x, p.z).distance_to(Vector2((poi["pos"] as Vector3).x, (poi["pos"] as Vector3).z))
		if d < float(poi.get("radius", 20.0)) * 1.5 and d < bd and str(poi["kind"]) not in ["district", "spawn"]:
			bd = d
			best = str(poi["name"])
	var dist := WorldLayout.district_name(world.district_at(p))
	return best + " — " + dist if best != "" else dist


func is_underground() -> bool:
	return setor7 != null and player.global_position.y < -20.0


# ---------------------------------------------------------------------------
# Loop leve (2 Hz)
# ---------------------------------------------------------------------------
func _process(delta: float) -> void:
	if not ready_to_play or player == null:
		return
	GameState.playtime += delta if not get_tree().paused else 0.0
	_tick -= delta
	if _tick > 0.0:
		return
	_tick = 0.5
	if player.cinematic:
		return
	var p := player.global_position
	MissionManager.check_position(p)
	# descobertas
	for id in layout.pois.keys():
		var poi: Dictionary = layout.pois[id]
		if str(poi["kind"]) in ["district", "spawn", "street"] or GameState.discovered.has(id):
			continue
		var pp: Vector3 = poi["pos"]
		if Vector2(p.x, p.z).distance_to(Vector2(pp.x, pp.z)) < minf(float(poi.get("radius", 20.0)), 45.0) and absf(p.y - pp.y) < 25.0:
			if GameState.discover(id):
				EventBus.location_discovered.emit(id)
	# interiores / acústica
	var indoor := world.is_indoors(p) or is_underground()
	player.indoors = indoor
	if indoor != _last_indoor:
		_last_indoor = indoor
		env.set_indoor(indoor)
	var ac := "underground" if is_underground() else world.acoustic_mode(p)
	AudioManager.set_environment(ac if ac != "underground" else "lab")
	ambience.mode = ac
	weather_fx.indoors = indoor
	# margem sul (travessia)
	if MissionManager.is_active("m4_ponte") and p.z > 760.0:
		events.on_crossed_river()


# ---------------------------------------------------------------------------
# Sono
# ---------------------------------------------------------------------------
func sleep(hours: float, _src: Node) -> void:
	if transitioning:
		return
	transitioning = true
	player.control_enabled = false
	await ui.cine.fade_to(1.0, 1.2).finished
	player.survival.sleeping = true
	var steps := int(ceil(hours * 2.0))
	for i in steps:
		var h := hours / float(steps)
		TimeManager.advance(h)
		player.survival.update(1.0, h)
		if player.survival.dead:
			break
		await get_tree().process_frame
	player.survival.sleeping = false
	EventBus.player_slept.emit(hours)
	transitioning = false
	if not player.survival.dead:
		SaveManager.save_game("auto")
	await ui.cine.fade_to(0.0, 1.5).finished
	if not player.survival.dead and not ui.is_screen_open():
		player.control_enabled = true
	EventBus.toast("Você dormiu %d horas. %s" % [int(hours), Util.format_time(TimeManager.hour)], "info")


# ---------------------------------------------------------------------------
# Diálogo: enquadra o NPC
# ---------------------------------------------------------------------------
func focus_dialogue(npc: Node) -> void:
	_dialogue_npc = npc
	var n := npc as Node3D
	var to := n.global_position - player.global_position
	player.set_yaw(atan2(-to.x, -to.z))
	player.cam_rig.align_to(Transform3D(Basis(Vector3.UP, atan2(-to.x, -to.z)), Vector3.ZERO))
	player.cam_rig.aim_target = 0.6


func _on_screen_closed(screen: String) -> void:
	if screen == "dialogue":
		player.cam_rig.aim_target = 0.0
		_dialogue_npc = null


# ---------------------------------------------------------------------------
# Setor 7 (elevador)
# ---------------------------------------------------------------------------
func _on_elevator(target: String, _src: Node) -> void:
	if transitioning:
		return
	if target == "setor7":
		_enter_setor7(true)
	else:
		_exit_setor7()


func _enter_setor7(with_fade: bool) -> void:
	transitioning = true
	player.control_enabled = false
	if with_fade:
		AudioManager.play_2d("vehicle_start", -8.0, 0.5)
		await ui.cine.fade_to(1.0, 1.0).finished
	director.enabled = false
	director.clear_all()
	if setor7 == null:
		setor7 = Setor7.new()
		setor7.name = "Setor7"
		add_child(setor7)
		setor7.global_position = layout.poi_pos("setor7")
		setor7.build(self)
		setor7.populate(survivors)
	setor7.populate_specimen(director)
	env.underground = true
	var arr: Transform3D = setor7.markers["arrival"]
	player.global_position = setor7.to_global(arr.origin) + Vector3(0, 0.05, 0)
	player.set_yaw(0.0)
	player.velocity = Vector3.ZERO
	player.cam_rig.align_to(Transform3D(Basis.IDENTITY, Vector3.ZERO))
	for i in 3:
		await get_tree().physics_frame
	transitioning = false
	player.control_enabled = true
	GameState.discover("setor7")
	EventBus.location_discovered.emit("setor7")
	if with_fade:
		await get_tree().create_timer(1.4).timeout
		ui.cine.fade_to(0.0, 1.2)
	else:
		ui.cine.fade_to(0.0, 0.5)


func _exit_setor7() -> void:
	transitioning = true
	player.control_enabled = false
	AudioManager.play_2d("vehicle_start", -8.0, 0.5)
	await ui.cine.fade_to(1.0, 1.0).finished
	env.underground = false
	var ev = world.poi_marker("lab_nexus", "elevator")
	var p := layout.poi_pos("lab_nexus")
	if ev != null:
		p = (ev as Transform3D).origin + (ev as Transform3D).basis * Vector3(0, 0, -1.4)
	player.global_position = p + Vector3(0, 0.1, 0)
	player.velocity = Vector3.ZERO
	# companheiros sobem junto
	for n in survivors.followers():
		(n as Node3D).global_position = p + Vector3(1.0, 0.1, 0.8)
	director.enabled = true
	await world.wait_area(p, 40.0, 10.0)
	transitioning = false
	player.control_enabled = true
	ui.cine.fade_to(0.0, 1.2)


func _on_enemy_killed(kind: String, _pos: Vector3, _killer: Node) -> void:
	if kind == "colosso" and is_underground():
		GameState.set_flag("s7_specimen_dead", true)


# ---------------------------------------------------------------------------
# Final
# ---------------------------------------------------------------------------
func _on_ending(ending_id: String) -> void:
	GameState.set_flag("ending", ending_id)
	GameState.set_flag("game_finished", true)
	await get_tree().create_timer(1.5).timeout
	player.control_enabled = false
	SaveManager.save_game("auto")
	var e := EndingScreen.new()
	e.ending = ending_id
	ui.screens.add_child(e)
	ui.current = e
