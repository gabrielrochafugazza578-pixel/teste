extends Node
## Sonda de chão: compara a superfície visual das estradas com a colisão física.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/probe.tscn -- --no-audio

var t0 := 0
var g: Game


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	t0 = Time.get_ticks_msec()
	_run()


func _log(s: String) -> void:
	print("[%6.1fs] %s" % [(Time.get_ticks_msec() - t0) / 1000.0, s])


func _run() -> void:
	Settings.apply_preset(1)
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
	if not "--only-walls" in OS.get_cmdline_user_args():
		await _probe_roads()
	await _probe_walls()
	_log("FIM")
	get_tree().quit(0)


## Y da superfície desenhada da estrada em (x, z), como o chunk_builder a monta.
func _road_surface(x: float, z: float) -> float:
	var best := INF
	var best_y := NAN
	var p := Vector2(x, z)
	for r: Dictionary in g.layout.roads:
		var kind: String = r["kind"]
		if kind in ["street", "avenue"]:
			continue
		var a: Vector2 = r["a"]
		var b: Vector2 = r["b"]
		var ab := b - a
		var tt := clampf((p - a).dot(ab) / maxf(ab.length_squared(), 0.001), 0.0, 1.0)
		var d := p.distance_to(a + ab * tt)
		if d < float(r["hw"]) and d < best:
			best = d
			best_y = lerpf(float(r["ya"]), float(r["yb"]), tt)
	return best_y


func _probe_roads() -> void:
	var p := g.player
	p.set_physics_process(false)
	var worst := 0.0
	var bad := 0
	var total := 0
	var worst_at := ""
	for z0: float in [-1060.0, -1000.0, -940.0, -880.0, -820.0]:
		var c := Vector3(0.0, g.layout.height(0.0, z0) + 1.0, z0)
		p.global_position = c
		p.velocity = Vector3.ZERO
		await g.world.wait_area(c, 70.0, 40.0)
		await g.world.wait_spot(c, 25.0)
		var z := maxf(z0 - 40.0, WorldLayout.TUNNEL_Z_SOUTH + 6.0)
		while z <= z0 + 40.0:
			for x: float in [-4.5, -3.0, -0.4, 0.0, 0.4, 3.0, 4.5]:
				var q := PhysicsRayQueryParameters3D.create(Vector3(x, c.y + 10.0, z), Vector3(x, c.y - 30.0, z), 1)
				var hit := p.get_world_3d().direct_space_state.intersect_ray(q)
				if hit.is_empty():
					continue
				var phys: float = (hit["position"] as Vector3).y
				var vis := _road_surface(x, z)
				if is_nan(vis):
					continue
				if phys - vis > 0.5:
					continue   # caiu em cima de um prop (carro, entulho…), não no chão
				var d := absf(vis - phys)
				total += 1
				if d > 0.03:
					bad += 1
					if bad <= 12:
						_log("   ruim: x=%.1f z=%.1f fís=%.3f vis=%.3f Δ=%+.3f" % [x, z, phys, vis, vis - phys])
				if d > worst:
					worst = d
					worst_at = "x=%.1f z=%.1f fís=%.3f vis=%.3f" % [x, z, phys, vis]
			z += 1.3
	_log("amostras=%d  fora_de_3cm=%d  pior=%.3f m (%s)" % [total, bad, worst, worst_at])
	p.set_physics_process(true)


## Corre contra paredes (lado oposto à porta) e confere se alguém entra no prédio.
func _probe_walls() -> void:
	var p := g.player
	var r := Util.rng(4242)
	var picks: Array = []
	var tries := 0
	while picks.size() < 24 and tries < 4000:
		tries += 1
		var bi := r.randi() % g.layout.buildings.size()
		var b: Dictionary = g.layout.buildings[bi]
		var rc: Rect2 = b["rect"]
		if rc.size.x < 8.0 or rc.size.y < 8.0 or float(b["base"]) > 30.0:
			continue
		picks.append(bi)
	var inside := 0
	for bi: int in picks:
		var b: Dictionary = g.layout.buildings[bi]
		var rc: Rect2 = b["rect"]
		var di := BuildingGen.door_info(b)
		var door: Vector3 = di[0]
		var ctr := rc.get_center()
		var o := Vector2(door.x - ctr.x, door.z - ctr.y)
		if absf(o.x) / maxf(rc.size.x, 0.1) > absf(o.y) / maxf(rc.size.y, 0.1):
			o = Vector2(signf(o.x), 0.0)
		else:
			o = Vector2(0.0, signf(o.y))
		o = -o
		var wall_pt := Vector2(ctr.x + o.x * rc.size.x * 0.5, ctr.y + o.y * rc.size.y * 0.5)
		var start := wall_pt + o * 5.0
		var y := g.layout.ground_height(start.x, start.y)
		var pos := Vector3(start.x, y + 0.5, start.y)
		p.set_physics_process(false)
		p.global_position = pos
		p.velocity = Vector3.ZERO
		await g.world.wait_area(pos, 60.0, 40.0)
		await g.world.wait_spot(pos, 20.0)
		var q := PhysicsRayQueryParameters3D.create(pos + Vector3(0, 4, 0), pos + Vector3(0, -8, 0), 1)
		var hit := p.get_world_3d().direct_space_state.intersect_ray(q)
		if not hit.is_empty():
			p.global_position = (hit["position"] as Vector3) + Vector3(0, 0.05, 0)
		var yaw := atan2(o.x, o.y)   # de frente para a parede (direção -o)
		var d := Vector3(-o.x, 0, -o.y)
		yaw = atan2(-d.x, -d.z)
		p.cam_rig.yaw = yaw
		p.set_yaw(yaw)
		p.set_physics_process(true)
		Input.action_press("move_forward")
		Input.action_press("sprint")
		await get_tree().create_timer(2.6, true, false, true).timeout
		Input.action_release("move_forward")
		Input.action_release("sprint")
		var pp := Vector2(p.global_position.x, p.global_position.z)
		var deep := rc.grow(-0.8).has_point(pp)
		var dist_in := minf(minf(pp.x - rc.position.x, rc.end.x - pp.x), minf(pp.y - rc.position.y, rc.end.y - pp.y))
		if deep:
			inside += 1
		_log("  prédio %4d %s lado=(%+.0f,%+.0f) distância_da_parede=%.2f %s" % [bi, str(rc.size.snapped(Vector2.ONE * 0.1)), o.x, o.y, dist_in, "ATRAVESSOU" if deep else "ok"])
	_log("Paredes: %d testadas, %d atravessadas" % [picks.size(), inside])
