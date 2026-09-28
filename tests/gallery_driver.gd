extends Node
## Galeria: abre o jogo de verdade (mesma cena Game do gameplay), visita vários
## cenários com hora/clima diferentes e salva screenshots da câmera de jogo.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/gallery.tscn -- --no-audio --out=/tmp/galeria [--preset=1]

var out := "user://galeria"
var preset := 1
var t0 := 0
var n := 0
var g: Game


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out = a.substr(6)
		elif a.begins_with("--preset="):
			preset = int(a.substr(9))
	DirAccess.make_dir_recursive_absolute(out)
	t0 = Time.get_ticks_msec()
	_run()


func _log(s: String) -> void:
	print("[%6.1fs] %s" % [(Time.get_ticks_msec() - t0) / 1000.0, s])


func _wait(sec: float) -> void:
	await get_tree().create_timer(sec, true, false, true).timeout


func _shot(name: String) -> void:
	for i in 3:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	if img:
		n += 1
		img.save_png("%s/%02d_%s.png" % [out, n, name])
		_log("foto %02d %s" % [n, name])


func _run() -> void:
	Settings.apply_preset(preset)
	await Assets.bake_all()
	AudioManager.generate_async()
	while AudioManager.generating:
		await get_tree().process_frame
	GameState.start_mode = "new"
	GameState.skip_opening = true
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
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
	_log("Game pronto (preset %d)" % preset)
	await _gallery()
	_log("FIM: %d fotos" % n)
	get_tree().quit(0)


## Leva o Caio até `pos` com segurança (espera o chão carregar) e aponta a
## câmera para `look` (ou usa `yaw`).
func _go(pos: Vector3, look: Vector3, hour: float, weather: int, pitch: float = -0.1) -> void:
	TimeManager.set_time(hour)
	WeatherManager.set_weather(weather, true, true)
	var p := g.player
	p._invuln = 9999.0
	p.survival.health = 100.0
	p.set_physics_process(false)
	p.global_position = pos + Vector3(0, 0.6, 0)
	p.velocity = Vector3.ZERO
	await g.world.wait_area(pos, 70.0, 40.0)
	await g.world.wait_spot(pos, 25.0)
	var q := PhysicsRayQueryParameters3D.create(pos + Vector3(0, 4, 0), pos + Vector3(0, -10, 0), 1)
	var hit := p.get_world_3d().direct_space_state.intersect_ray(q)
	if not hit.is_empty():
		p.global_position = (hit["position"] as Vector3) + Vector3(0, 0.05, 0)
	var d := look - p.global_position
	var yaw := atan2(-d.x, -d.z)
	p.cam_rig.yaw = yaw
	p.cam_rig.pitch = pitch
	p.set_yaw(yaw)
	p.set_physics_process(true)
	await _wait(2.5)


func _street_near(poi: String, radius: float = 26.0) -> Vector3:
	var c := g.layout.poi_pos(poi)
	var r := Util.rng(hash(poi))
	var best := c
	for i in 40:
		var pp := g.layout.random_street_point(r, c, radius)
		if g.layout.block_at(pp.x, pp.z) < 0 and g.layout.building_at(pp, 1.5) < 0:
			best = pp
			break
	return best


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	var hud := g.ui.hud
	# 1. início do jogo, descendo a serra
	var ip := L.poi_pos("inicio_gameplay")
	await _go(ip, ip + Vector3(0, 0, 60), 9.2, W.CLOUDY)
	await _shot("serra_descida_manha")
	# 2. vista do mirante (camada distante: a cidade lá embaixo)
	var mp := L.poi_pos("mirante")
	hud.visible = false
	await _go(mp + Vector3(-2, 0, 0), mp + Vector3(0, -20, 400), 17.3, W.CLEAR, -0.05)
	await _shot("mirante_por_do_sol")
	hud.visible = true
	# 3. avenida central de manhã
	var av := L.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 8.6, W.CLEAR)
	await _shot("avenida_central_manha")
	# 4. centro à tarde
	await _go(av + Vector3(-3, 0, -150), av + Vector3(-3, 0, -220), 15.0, W.CLOUDY)
	await _shot("centro_tarde")
	# 5. hospital
	var hp := L.poi_pos("hospital")
	await _go(_street_near("hospital"), hp, 11.0, W.OVERCAST)
	await _shot("hospital")
	# 6. mercado
	var mk := L.poi_pos("mercado")
	await _go(_street_near("mercado"), mk, 13.0, W.CLEAR)
	await _shot("mercado")
	# 7. delegacia
	var dl := L.poi_pos("delegacia")
	await _go(_street_near("delegacia"), dl, 16.2, W.CLOUDY)
	await _shot("delegacia")
	# 8. posto da serra
	var ps := L.poi_pos("posto_norte")
	await _go(ps + Vector3(-18, 0, 14), ps, 10.0, W.CLEAR)
	await _shot("posto_serra")
	# 9. acampamento do estádio (Remanescentes)
	var es := L.poi_pos("estadio")
	await _go(es + Vector3(0, 0, 16), es, 17.4, W.CLEAR)
	await _shot("estadio_remanescentes")
	# 10. diálogo com a Marta
	var marta := g.survivors.get_npc("marta")
	if marta:
		EventBus.dialogue_requested.emit(marta)
		await _wait(1.0)
		await _shot("dialogo_marta")
		var ds := g.ui.current as DialogueScreen
		if ds:
			ds.runner.end()
		await _wait(0.5)
	# 11. bairro residencial
	await _go(Vector3(-600, 0, -420), Vector3(-600, 0, -500), 9.0, W.CLEAR)
	await _shot("jardim_das_acacias")
	# 12. distrito industrial / Corvalis com neblina
	var cv := L.poi_pos("corvalis")
	await _go(_street_near("corvalis", 60.0), cv, 7.2, W.FOG)
	await _shot("corvalis_neblina")
	# 13. rio e ponte velha
	var pv := L.poi_pos("ponte_velha")
	await _go(pv + Vector3(-40, 0, -30), pv, 12.0, W.CLOUDY)
	await _shot("rio_ponte_velha")
	# 14. cabanas do lago azul ao entardecer
	var lk := L.poi_pos("cabanas_lago")
	await _go(lk + Vector3(10, 0, 10), Vector3(WorldLayout.LAKE_CENTER.x, 0, WorldLayout.LAKE_CENTER.y), 18.1, W.CLEAR)
	await _shot("lago_azul_entardecer")
	# 15. fazenda
	var fz := L.poi_pos("fazenda_boa_vista")
	await _go(fz + Vector3(-22, 0, 20), fz + Vector3(10, 0, 0), 10.5, W.CLEAR)
	await _shot("fazenda_boa_vista")
	# 16. floresta
	var fl := L.poi_pos("acampamento_floresta")
	await _go(fl + Vector3(12, 0, 8), fl, 12.5, W.FOG)
	await _shot("mata_do_sabia")
	# 17. torre de rádio na serra (vista)
	var tr := L.poi_pos("torre_radio")
	hud.visible = false
	await _go(tr + Vector3(0, 0, 14), Vector3(0, 0, 0), 16.0, W.CLOUDY, -0.04)
	await _shot("torre_radio_vista")
	hud.visible = true
	# 18. tempestade no centro sul
	await _go(av + Vector3(3, 0, 420), av + Vector3(3, 0, 360), 16.5, W.STORM)
	await _shot("tempestade_centro_sul")
	# 19. noite na avenida com a lanterna
	await _go(av + Vector3(-4, 0, 60), av + Vector3(-4, 0, 0), 22.5, W.CLEAR)
	g.player.flashlight_on = true
	g.player.flashlight.visible = true
	await _wait(1.0)
	await _shot("noite_lanterna")
	g.player.flashlight_on = false
	g.player.flashlight.visible = false
	# 20. infectados na rua
	await _go(av + Vector3(2, 0, -60), av + Vector3(2, 0, -100), 14.0, W.OVERCAST)
	await _wait(2.0)
	var best: Node3D = null
	var bd := INF
	for inf in g.director.active:
		if inf is Node3D and is_instance_valid(inf):
			var dd := (inf as Node3D).global_position.distance_to(g.player.global_position)
			if dd < bd:
				bd = dd
				best = inf
	if best:
		var ipos := best.global_position
		var dir := (g.player.global_position - ipos)
		dir.y = 0.0
		dir = dir.normalized() if dir.length() > 0.1 else Vector3.BACK
		await _go(ipos + dir * 9.0, ipos, 14.0, W.OVERCAST)
	await _shot("infectados")
	# 21. dirigindo
	var cp := av + Vector3(-3.5, 0.3, 150)
	await _go(cp + Vector3(-6.0, 0, 0), cp + Vector3(0, 0, -40), 11.5, W.CLEAR)
	var vs: Dictionary = g.vehicles._state("viatura_delegacia").duplicate(true)
	vs["pos"] = cp
	vs["yaw"] = 0.0
	vs["fuel"] = 30.0
	vs["id"] = "galeria_carro"
	vs["placed"] = false
	var car: Vehicle = g.vehicles._spawn(vs)
	for i in 6:
		await get_tree().physics_frame
	car.enter(g.player)
	Input.action_press("move_forward")
	await _wait(3.5)
	await _shot("dirigindo_viatura")
	Input.action_release("move_forward")
	g.player.exit_vehicle()
	await _wait(0.5)
	# 22. túnel da serra
	var tp := Vector3(0, WorldLayout.TUNNEL_Y, -1120)
	await _go(tp, tp + Vector3(0, 0, -40), 13.0, W.CLOUDY)
	await _shot("tunel_da_serra")
	# 23. Setor 7 (laboratório subterrâneo)
	g._enter_setor7(false)
	await _wait(4.0)
	await _shot("setor7_laboratorio")
	g._exit_setor7()
	await _wait(4.0)
	# 24–26. telas
	g.ui.open_inventory(null, "", null, "")
	await _wait(0.8)
	await _shot("tela_inventario")
	g.ui.current.queue_free()
	await _wait(0.4)
	var m := MapScreen.new()
	m.game = g
	m.player = g.player
	g.ui.open(m, true)
	await _wait(0.8)
	await _shot("tela_mapa")
	m.queue_free()
	await _wait(0.4)
	var j := JournalScreen.new()
	j.game = g
	g.ui.open(j, true)
	await _wait(0.6)
	await _shot("tela_diario")
	j.queue_free()
