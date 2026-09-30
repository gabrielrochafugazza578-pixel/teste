extends Node
## Dirige um teste de fumaça do jogo completo: abre a cena Game, espera o
## mundo, anda com o Caio, abre as telas, fabrica, salva e carrega.
## Uso: godot --path . res://tests/smoke_test.tscn -- --no-audio [--opening] [--shots=dir]

var mode := "gameplay"
var shots := ""
var errors: Array = []
var t0 := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		if a == "--opening":
			mode = "opening"
		elif a.begins_with("--shots="):
			shots = a.substr(8)
		elif a.begins_with("--cine-from="):
			Engine.set_meta("cine_from", a.substr(12))
		elif a == "--cine-log":
			Engine.set_meta("cine_log", true)
	if shots != "":
		DirAccess.make_dir_recursive_absolute(shots)
	t0 = Time.get_ticks_msec()
	_run()


func _log(s: String) -> void:
	print("[%6.1fs] %s" % [(Time.get_ticks_msec() - t0) / 1000.0, s])


func _shot(name: String) -> void:
	if shots == "" or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	if img:
		img.save_png(shots + "/" + name + ".png")
		_log("screenshot " + name)


func _wait(sec: float) -> void:
	await get_tree().create_timer(sec, true, false, true).timeout


func _run() -> void:
	await Assets.bake_all()
	AudioManager.generate_async()
	while AudioManager.generating:
		await get_tree().process_frame
	GameState.start_mode = "new"
	GameState.skip_opening = mode != "opening"
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	var g: Game = null
	var t := 0.0
	while t < 120.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		g = SaveManager.game as Game
		if g != null and g.ready_to_play:
			break
	if g == null or not g.ready_to_play:
		_log("FALHA: Game não ficou pronto")
		get_tree().quit(1)
		return
	_log("Game pronto. chunks=%d pos=%s" % [g.world.chunks.size(), str(g.player.global_position)])
	if mode == "opening":
		await _test_opening(g)
	else:
		await _test_gameplay(g)
	_log("FIM")
	get_tree().quit(0)


func _test_opening(g: Game) -> void:
	Engine.time_scale = 1.0
	var last_shot := ""
	g.cinematic.shot_started.connect(func(id: String) -> void:
		last_shot = id
		_log("tomada " + id)
		(func() -> void: await _wait(2.0); await _shot("cine_" + id)).call())
	var t := 0.0
	var lt := 0.0
	while g.cinematic != null and t < 600.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		if Engine.has_meta("cine_log") and t - lt > 2.0:
			lt = t
			var pl := g.player
			var q := PhysicsShapeQueryParameters3D.new()
			var cap := CapsuleShape3D.new()
			cap.radius = 0.34
			cap.height = 1.78
			q.shape = cap
			q.transform = Transform3D(Basis(), pl.global_position + Vector3(0, 0.89, 0))
			q.collision_mask = pl.collision_mask
			q.exclude = [pl.get_rid()]
			var hits := pl.get_world_3d().direct_space_state.intersect_shape(q, 8)
			var names: Array = []
			for h in hits:
				names.append(str(h.get("collider")) + "#" + str(h.get("shape")))
			_log("  sobreposições: %s · camada=%d máscara=%d · last_motion=%s" % [str(names), pl.collision_layer, pl.collision_mask, str(pl.get_last_motion())])
			_log("caio: fis=%s cine=%s alvo=%s vel=%s pos=%s chão=%s" % [str(pl.is_physics_processing()), str(pl.cinematic), str(pl.cine_target), str(pl.velocity.snapped(Vector3.ONE * 0.01)), str(pl.global_position.snapped(Vector3.ONE * 0.01)), str(pl.is_on_floor())])
	var p := g.player
	_log("Cinemática terminou em %.1fs. última=%s controle=%s cam_gameplay=%s pos=%s" % [t, last_shot, str(p.control_enabled), str(p.cam_rig.cam.current), str(p.global_position)])
	var ip := g.layout.poi_pos("inicio_gameplay")
	_log("distância até inicio_gameplay: %.1f m · missão: %s" % [Vector2(p.global_position.x, p.global_position.z).distance_to(Vector2(ip.x, ip.z)), MissionManager.tracked])
	await _wait(2.0)
	await _shot("apos_transicao")


func _teleport(g: Game, pos: Vector3) -> void:
	var p := g.player
	p.set_physics_process(false)
	p.global_position = pos
	p.velocity = Vector3.ZERO
	await g.world.wait_area(pos, 60.0, 30.0)
	await g.world.wait_spot(pos, 20.0)
	var q := PhysicsRayQueryParameters3D.create(pos + Vector3(0, 3, 0), pos + Vector3(0, -8, 0), 1)
	var hit := p.get_world_3d().direct_space_state.intersect_ray(q)
	if not hit.is_empty():
		p.global_position = (hit["position"] as Vector3) + Vector3(0, 0.1, 0)
	var probe: Array = []
	var ex: Array = [p.get_rid()]
	for k in 4:
		var q2 := PhysicsRayQueryParameters3D.create(pos + Vector3(0, 6, 0), pos + Vector3(0, -30, 0), 1)
		q2.exclude = ex
		var h2 := p.get_world_3d().direct_space_state.intersect_ray(q2)
		if h2.is_empty():
			break
		probe.append("%.2f(%s)" % [(h2["position"] as Vector3).y, str(h2["collider"]) if h2["collider"] else "rid"])
		ex.append(h2["rid"])
	_log("  sondagem: %s · altura terreno=%.2f ground_y=%.2f" % [str(probe), g.layout.height(pos.x, pos.z), g.world.ground_y(pos.x, pos.z)])
	var c := Vector2i(floori(pos.x / WorldLayout.CHUNK), floori(pos.z / WorldLayout.CHUNK))
	_log("  teleporte %s: chão=%s lod=%s" % [str(pos.snapped(Vector3.ONE * 0.1)), str(not hit.is_empty()), str((g.world.chunks[c] as Chunk).lod if g.world.chunks.has(c) else -9)])
	p.set_physics_process(true)
	await get_tree().physics_frame
	await get_tree().physics_frame
	_log("  após 2 quadros: pos=%s chão=%s" % [str(p.global_position.snapped(Vector3.ONE * 0.01)), str(p.is_on_floor())])


func _test_gameplay(g: Game) -> void:
	var p := g.player
	await _wait(2.0)
	await _shot("gameplay_inicio")
	_log("Missão rastreada: %s · objetivo: %s" % [MissionManager.tracked, str(MissionManager.current_objective(MissionManager.tracked).get("text", ""))])
	# anda para frente
	Input.action_press("move_forward")
	await _wait(3.0)
	Input.action_release("move_forward")
	_log("Após andar: pos=%s vel=%.2f chão=%s" % [str(p.global_position), p.velocity.length(), str(p.is_on_floor())])
	# telas
	g.ui.open_inventory(null, "", null, "")
	await _wait(0.5)
	await _shot("ui_inventario")
	g.ui.current.queue_free()
	await _wait(0.3)
	var m := MapScreen.new()
	m.game = g
	m.player = p
	g.ui.open(m, true)
	await _wait(0.5)
	await _shot("ui_mapa")
	m.queue_free()
	await _wait(0.3)
	var j := JournalScreen.new()
	j.game = g
	g.ui.open(j, true)
	await _wait(0.4)
	await _shot("ui_diario")
	j.queue_free()
	await _wait(0.3)
	# fabricação
	p.inventory.add("pano", 4, 1.0, {}, true)
	p.inventory.add("alcool", 2, 1.0, {}, true)
	var ok := Crafting.craft("r_pano_limpo", p, "")
	_log("Fabricar pano limpo: %s (tem %d)" % [str(ok), p.inventory.count("pano_limpo")])
	# save / load
	var saved := SaveManager.save_game("3")
	_log("Salvar slot 3: %s" % str(saved))
	var meta := SaveManager.read_meta("3")
	_log("Meta: %s" % str(meta))
	# teleporta para a cidade e espera streaming
	var cp := g.layout.poi_pos("avenida_central") + Vector3(4, 0.5, 30)
	await _teleport(g, cp)
	await _wait(3.0)
	_log("  saúde=%.0f fratura=%s" % [p.survival.health, str(p.survival.fracture > 0.0)])
	_log("Na cidade: chunks=%d infectados=%d npcs=%d" % [g.world.chunks.size(), g.director.active.size(), g.survivors.spawned.size()])
	_log("  malhas de personagem geradas: %d, %.0f ms no total (%.0f ms cada)" % [HumanoidBody.build_count, HumanoidBody.build_usec / 1000.0, HumanoidBody.build_usec / 1000.0 / maxf(HumanoidBody.build_count, 1)])
	await _shot("gameplay_cidade")
	# estádio (Remanescentes)
	var ep := g.layout.poi_pos("estadio") + Vector3(0, 0.5, 14)
	await _teleport(g, ep)
	await _wait(3.0)
	_log("Estádio: npcs=%d saúde=%.0f" % [g.survivors.spawned.size(), p.survival.health])
	for id in g.survivors.spawned.keys():
		var n: SurvivorNPC = g.survivors.spawned[id]
		_log("  %s (%s) estado=%d pos=%s" % [n.display_name, n.faction, n.state, str(n.global_position)])
		break
	await _shot("gameplay_estadio")
	# diálogo e troca
	var marta := g.survivors.get_npc("marta")
	if marta:
		EventBus.dialogue_requested.emit(marta)
		await _wait(0.6)
		var ds := g.ui.current as DialogueScreen
		_log("Diálogo com Marta aberto: %s" % str(ds != null))
		await _shot("ui_dialogo")
		if ds:
			ds.runner.choose(0)
			await _wait(0.3)
			if is_instance_valid(ds):
				ds.runner.end()
		await _wait(0.3)
	var zilda := g.survivors.get_npc("zilda")
	if zilda:
		EventBus.trade_requested.emit(zilda)
		await _wait(0.6)
		_log("Troca com Zilda: %s itens" % str(zilda.trade_inv.stacks.size() if zilda.trade_inv else -1))
		await _shot("ui_troca")
		if g.ui.current:
			g.ui.current.queue_free()
		await _wait(0.3)
	# veículo: picape do Tonho
	var op := g.layout.poi_pos("oficina") + Vector3(0, 0.5, 10)
	await _teleport(g, op)
	await _wait(3.0)
	_log("Veículos instanciados: %s" % str(g.vehicles.vehicles.keys()))
	# dirigir um veículo
	var av := g.layout.poi_pos("avenida_central") + Vector3(-3.5, 0.3, 90)
	await _teleport(g, av + Vector3(-6.0, 0.3, 0))
	var vs: Dictionary = g.vehicles._state("viatura_delegacia").duplicate(true)
	vs["pos"] = av
	vs["yaw"] = 0.0
	vs["fuel"] = 20.0
	vs["id"] = "teste_carro"
	vs["placed"] = false
	_log("  spawn pedido em %s" % str(vs["pos"]))
	var car: Vehicle = g.vehicles._spawn(vs)
	_log("  carro criado em %s" % str(car.global_position))
	for i in 8:
		await get_tree().physics_frame
		_log("  carro y=%.2f vel=%s freeze=%s sleeping=%s" % [car.global_position.y, str(car.linear_velocity.snapped(Vector3.ONE * 0.01)), str(car.freeze), str(car.sleeping)])
	_log("  antes de entrar no carro: saúde=%.0f" % p.survival.health)
	car.enter(p)
	Input.action_press("move_forward")
	await _wait(4.0)
	Input.action_release("move_forward")
	_log("Dirigindo: %.1f km/h · motor=%s · combustível=%.2f L · jogador no carro=%s" % [car.speed_kmh, str(car.engine_on), car.fuel, str(p.in_vehicle == car)])
	_log("  saúde ao descer: %.0f" % p.survival.health)
	p.exit_vehicle()
	await _wait(0.5)
	_log("Saiu do carro: pos=%s saúde=%.0f" % [str(p.global_position), p.survival.health])
	# estrutura (fogueira)
	p.inventory.add("kit_fogueira", 1, 1.0, {}, true)
	g.structures.setup(p, g.world)
	g.structures.begin("kit_fogueira")
	await _wait(0.6)
	g.structures._valid = true
	g.structures._confirm()
	_log("Estruturas salvas: %d" % GameState.structures.size())
	# Setor 7
	g._enter_setor7(false)
	await _wait(3.0)
	_log("Setor 7: subterrâneo=%s npcs=%s" % [str(g.is_underground()), str(g.survivors.spawned.keys().filter(func(k): return str(k) in ["lia", "helena", "leme"]))])
	_log("Setor 7: chão=%s y=%.2f (piso esperado ≈ %.2f) saúde=%.0f fratura=%s" % [str(p.is_on_floor()), p.global_position.y, g.setor7.global_position.y, p.survival.health, str(p.survival.fracture > 0.0)])
	if not p.is_on_floor() or absf(p.global_position.y - g.setor7.global_position.y) > 1.0:
		_log("FALHA: Caio não está no piso do Setor 7")
	await _shot("setor7")
	g._exit_setor7()
	await _wait(4.0)
	_log("De volta: pos=%s subterrâneo=%s" % [str(p.global_position), str(g.is_underground())])
	# túnel da serra: piso dentro do túnel
	var tp := Vector3(0.0, WorldLayout.TUNNEL_Y + 0.5, -1150.0)
	await _teleport(g, tp)
	await _wait(1.5)
	_log("Túnel: chão=%s y=%.2f (pista em %.1f)" % [str(p.is_on_floor()), p.global_position.y, WorldLayout.TUNNEL_Y])
	if p.global_position.y < WorldLayout.TUNNEL_Y - 1.0:
		_log("FALHA: Caio caiu pelo piso do túnel")
	# evento emergente
	g.events.trigger("viajante")
	await _wait(1.0)
	_log("Evento viajante: eventos ativos=%d" % g.events.active_events.size())
	# carrega o save
	SaveManager.load_game("3")
	var t := 0.0
	while t < 60.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		var ng := SaveManager.game as Game
		if ng != null and ng != g and ng.ready_to_play:
			_log("Carregado: pos=%s pano_limpo=%d" % [str(ng.player.global_position), ng.player.inventory.count("pano_limpo")])
			break
	SaveManager.delete_slot("3")
