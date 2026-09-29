extends "res://tests/gallery_driver.gd"
## Fotos das ruas decoradas depois do surto (lixo, cones, carrinhos, cartazes,
## sangue discreto) e das marcas de combate (furos de bala, respingo, poça).
## Uso: xvfb-run godot --path . res://tests/streets.tscn -- --no-audio --out=/tmp/ruas


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	var av := L.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 10.0, W.CLEAR)
	await _shot("pre_avenida")
	GameState.set_phase(GameState.Phase.POST)
	await _wait(4.0)
	# pontos em ruas de verdade (segmentos do layout perto da avenida)
	var picks: Array = []
	var r := RandomNumberGenerator.new()
	r.seed = 7
	var segs := L.roads.duplicate()
	segs.shuffle()
	for seg in segs:
		if picks.size() >= 6:
			break
		if str(seg["kind"]) in ["highway", "tunnel", "bridge", "dirt"]:
			continue
		var a: Vector2 = seg["a"]
		var b: Vector2 = seg["b"]
		if a.distance_to(b) < 50.0 or (a + b).length() * 0.5 > 500.0 or not WorldLayout.URBAN.has_point((a + b) * 0.5):
			continue
		var ok := true
		for q in picks:
			if (q[0] as Vector3).distance_to(Vector3(a.x, 0, a.y)) < 120.0:
				ok = false
		if ok:
			var d := (b - a).normalized()
			var side := Vector2(-d.y, d.x) * (float(seg["hw"]) - 2.0)
			var p0 := a + d * 12.0 + side
			picks.append([Vector3(p0.x, 0, p0.y), Vector3(p0.x + d.x * 40.0, 0, p0.y + d.y * 40.0)])
	for v in picks:
		await _go(v[0], v[1], 10.5, W.CLOUDY, -0.16)
		await _wait(1.5)
		await _shot("pos_rua")
	# marcas de combate numa parede e no chão perto do jogador
	var p := g.player
	var from := p.global_position + Vector3(0, 1.3, 0)
	var space := p.get_world_3d().direct_space_state
	var best: Dictionary = {}
	for i in 16:
		var a := TAU * float(i) / 16.0
		var q := PhysicsRayQueryParameters3D.create(from, from + Vector3(cos(a), 0, sin(a)) * 30.0, 1)
		q.exclude = [p.get_rid()]
		var h := space.intersect_ray(q)
		if not h.is_empty() and absf((h["normal"] as Vector3).y) < 0.3 and (best.is_empty() or from.distance_to(h["position"]) < from.distance_to(best["position"])):
			best = h
	if not best.is_empty():
		var hp: Vector3 = best["position"]
		var hn: Vector3 = best["normal"]
		var side := hn.cross(Vector3.UP)
		for k in 9:
			Decals.bullet_hole(g, hp + side * randf_range(-0.6, 0.6) + Vector3(0, randf_range(-0.4, 0.4), 0), hn)
		Decals.splatter(g, hp + hn * 0.8, -hn, true, [p.get_rid()])
		Decals.pool(g, hp + hn * 1.2, [p.get_rid()])
		await _wait(8.0)
		p.set_physics_process(false)
		p.global_position = hp + hn * 3.2
		p.cam_rig.yaw = atan2(hn.x, hn.z)
		p.cam_rig.pitch = -0.25
		p.set_yaw(p.cam_rig.yaw)
		p.set_physics_process(true)
		await _wait(1.0)
		await _shot("marcas_combate")
	else:
		_log("sem parede perto para as marcas")
