extends "res://tests/gallery_driver.gd"
## Teste de combate corpo a corpo: um infectado parado na frente do Caio,
## golpes de vários tipos; mede acerto, dano e quanto o alvo é empurrado.
## Uso: xvfb-run godot --path . res://tests/combat.tscn -- --no-audio --out=/tmp/combate


func _gallery() -> void:
	var av := g.layout.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, 0), 11.0, WeatherManager.State.CLEAR)
	g.director.clear_all()
	g.director.set_process(false)
	g.director.set_physics_process(false)
	var p := g.player
	p._invuln = 9999.0
	var casos := [["punhos", "", false], ["punhos", "", true], ["taco", "taco_beisebol", false],
		["taco", "taco_beisebol", true], ["marreta", "marreta", true], ["faca", "faca_cozinha", false]]
	for c in casos:
		await _golpe(c[0], c[1], c[2], 0.0, 1.3)
	# mira assistida: alvo 45° fora da câmera e um pouco longe
	await _golpe("assistido_45graus", "taco_beisebol", false, 45.0, 2.4)
	# combo: 3 cliques rápidos (o 3º vira finalização)
	await _combo()
	# infectado atacando por 6 s: não pode agarrar
	await _apanha()


func _alvo(dist: float, ang_deg: float) -> Infected:
	var p := g.player
	var fwd := p.cam_rig.flat_forward().rotated(Vector3.UP, deg_to_rad(ang_deg))
	var pos := p.global_position + fwd * dist
	pos.y = g.world.ground_y(pos.x, pos.z)
	var yaw := atan2(fwd.x, fwd.z)
	var inf := g.director.spawn_scripted("errante", pos, yaw, Infected.S.IDLE, 7)
	inf.hp = 1000.0
	inf.suspicion = 0.0
	await _wait(0.4)
	return inf


func _golpe(nome: String, arma: String, pesado: bool, ang: float, dist: float) -> void:
	var p := g.player
	p.equipment["weapon"] = {} if arma == "" else Inventory.make_stack(arma, 1, 1.0)
	p._update_weapon_visual()
	p.set_yaw(p.cam_rig.yaw)
	p.survival.stamina = 100.0
	var inf := await _alvo(dist, ang)
	var p0 := inf.global_position
	var hp0 := inf.hp
	inf.set_state(Infected.S.SCRIPTED)   # parado: o deslocamento medido é só o empurrão
	p._attack(pesado)
	var d := 0.0
	var shot := false
	var t := 0.0
	var ph := Vector3.INF   # posição no instante do acerto
	var th := 0.0
	while t < 2.2:
		await get_tree().process_frame
		t += get_process_delta_time()
		if ph == Vector3.INF and inf.hp < hp0:
			ph = inf.global_position
			th = t
		# só o deslize do empurrão (depois de ~0,8 s o infectado volta a andar sozinho)
		if ph != Vector3.INF and t - th < 0.8:
			d = maxf(d, Vector2(inf.global_position.x - ph.x, inf.global_position.z - ph.z).length())
		if not shot and t > (0.28 if not pesado else 0.45):
			shot = true
			await _shot("golpe_%s%s" % [nome, "_pesado" if pesado else ""])
	_log("GOLPE %-20s %-6s acertou=%s dano=%.1f empurrao=%.2f m estado=%d" % [nome, "pesado" if pesado else "leve",
		str(inf.hp < hp0), hp0 - inf.hp, d, inf.state])
	g.director.release(inf)
	p._busy_t = 0.0
	await _wait(0.3)


func _combo() -> void:
	var p := g.player
	p.equipment["weapon"] = Inventory.make_stack("cano_ferro", 1, 1.0)
	p._update_weapon_visual()
	p.survival.stamina = 100.0
	var inf := await _alvo(1.3, 0.0)
	inf.set_state(Infected.S.SCRIPTED)
	var hp0 := inf.hp
	var fins := 0
	var golpes := 0
	var hps: Array = []
	var last_combo := -1
	var t := 0.0
	# clica a cada 0,2 s por 2,4 s (cliques no meio do golpe vão para a fila)
	var next_click := 0.0
	while t < 3.4:
		await get_tree().process_frame
		t += get_process_delta_time()
		if t >= next_click and t < 2.4:
			next_click += 0.2
			p._attack(false)
		if p._attack_combo != last_combo and p._attack_combo > 0:
			last_combo = p._attack_combo
			golpes += 1
			if p.get("_attack_finisher") == true:
				fins += 1
		if hps.is_empty() or absf(float(hps[-1]) - inf.hp) > 0.01:
			hps.append(inf.hp)
	_log("COMBO golpes=%d finalizacoes=%d acertos=%d dano_total=%.1f" % [golpes, fins, hps.size() - 1, hp0 - inf.hp])
	g.director.release(inf)


func _apanha() -> void:
	var p := g.player
	p._invuln = 0.0
	p.survival.health = 100.0
	var inf := await _alvo(1.2, 0.0)
	inf.hp = 1000.0
	inf.target = p
	inf.set_state(Infected.S.CHASE)
	var hp_min := 100.0
	var travado := 0.0
	var t := 0.0
	while t < 6.0:
		await get_tree().process_frame
		var dt := get_process_delta_time()
		t += dt
		p.survival.health = maxf(p.survival.health, 40.0)
		hp_min = minf(hp_min, p.survival.health)
		if not p.control_enabled:
			travado += dt
	_log("APANHA 6s: controle_perdido=%.2fs (agarrão removido: deve ser ~0)" % travado)
	p._invuln = 9999.0
	g.director.release(inf)
