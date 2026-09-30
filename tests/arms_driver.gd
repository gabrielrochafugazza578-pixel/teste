extends "res://tests/gallery_driver.gd"
## Armas na mão do Caio: fotos de lado (parado e mirando) e disparo contra um
## infectado parado (acerto, dano, munição gasta).
## Uso: xvfb-run godot --path . res://tests/arms.tscn -- --no-audio --out=/tmp/armas_mao

var ARMAS := ["revolver", "pistola_9mm", "submetralhadora", "espingarda_12", "espingarda_dupla", "carabina_22", "rifle_caca",
	"fuzil_policia", "besta", "arco", "katana", "picareta", "foice", "machadinha", "bastao_aluminio", "canivete", "soco_ingles", "taco_golfe"]


func _act(action: String, pressed: bool) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	g.player._unhandled_input(ev)


func _gallery() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--only="):
			ARMAS = Array(a.substr(7).split(","))
	var av := g.layout.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, 0), 11.0, WeatherManager.State.CLEAR)
	g.director.clear_all()
	g.director.set_process(false)
	g.director.set_physics_process(false)
	g.ui.hud.visible = true
	var p := g.player
	p._invuln = 9999.0
	var cam := Camera3D.new()
	cam.fov = 45.0
	g.add_child(cam)
	for id in ARMAS:
		p.equipment["weapon"] = Inventory.make_stack(id, 1, 1.0)
		p._update_weapon_visual()
		p.set_yaw(p.cam_rig.yaw)
		var def := ItemDB.get_item(id)
		var ranged := def.has("ranged")
		if ranged:
			p.inventory.add(str(def["ranged"]["ammo"]), 40, 1.0, {}, true)
		await _wait(0.5)
		# de lado, parado
		var fwd := p.cam_rig.flat_forward()
		var right := fwd.cross(Vector3.UP).normalized()
		var chest := p.global_position + Vector3(0, 1.2, 0)
		cam.global_position = chest + right * 2.3 + fwd * 0.6 + Vector3(0, 0.1, 0)
		cam.look_at(chest + fwd * 0.3, Vector3.UP)
		cam.make_current()
		await _shot("%s_parado" % id)
		if not ranged:
			p.cam_rig.cam.make_current()
			continue
		# mirando
		_act("block", true)
		await _wait(0.6)
		await _shot("%s_mirando_lado" % id)
		p.cam_rig.cam.make_current()
		# alvo a 9 m na frente
		var tp := p.global_position + fwd * 9.0
		tp.y = g.world.ground_y(tp.x, tp.z)
		var inf := g.director.spawn_scripted("errante", tp, atan2(-fwd.x, -fwd.z), Infected.S.IDLE, 7)
		inf.hp = 2000.0
		await _wait(0.5)
		inf.set_state(Infected.S.SCRIPTED)
		# mira no peito do alvo
		for it in 3:
			var d := (inf.global_position + Vector3(0, 1.25, 0)) - p.cam_rig.cam.global_position
			p.cam_rig.yaw = atan2(-d.x, -d.z)
			p.cam_rig.pitch = asin(clampf(d.normalized().y, -1, 1))
			await _wait(0.25)
		await _wait(0.8)
		var hp0 := inf.hp
		var a0 := p.inventory.count(str(def["ranged"]["ammo"]))
		var tiros := 3 if not bool(def["ranged"].get("auto", false)) else 1
		for k in tiros:
			_log("  antes do tiro %d: aiming=%s cd=%.2f estado=%s busy=%.2f" % [k, str(p.aiming), p._ranged_cd, p.state, p._busy_t])
			_act("attack", true)
			await _wait(0.05)
			if k == 0:
				await _shot("%s_disparo" % id)
			if bool(def["ranged"].get("auto", false)):
				await _wait(0.9)
			_act("attack", false)
			var tw := 0.0
			while p._ranged_cd > 0.0 and tw < 5.0:
				await _wait(0.1)
				tw += 0.1
		var a1 := p.inventory.count(str(def["ranged"]["ammo"]))
		_log("ARMA %-18s tiros=%d dano=%.0f zoom=%.2f fov=%.1f" % [id, a0 - a1, hp0 - inf.hp, p.cam_rig.aim_zoom, p.cam_rig.cam.fov])
		_act("block", false)
		g.director.release(inf)
		await _wait(0.4)
	cam.queue_free()
