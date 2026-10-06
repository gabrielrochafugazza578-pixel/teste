extends "res://tests/gallery_driver.gd"
## Tour curto para avaliar o visual (Forward+ é lento no Vulkan por software):
## rua de manhã, pôr do sol, interior de casa, noite com lanterna, chuva e mata.
## Uso: xvfb-run godot --path . --rendering-method forward_plus res://tests/fp_tour.tscn --
##      --no-audio --out=/tmp/tour [--preset=4] [--gfx=gi_quality:0] [--so=rua,interior]


func _quer(nome: String) -> bool:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--so="):
			return nome in a.substr(5).split(",")
	return true


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	var av := L.poi_pos("avenida_central")
	if _quer("rua"):
		await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 9.0, W.CLEAR)
		await _shot("rua_manha")
	if _quer("por"):
		await _go(av + Vector3(-3, 0, -150), av + Vector3(-3, 0, -220), 17.6, W.CLEAR)
		await _shot("por_do_sol")
	if _quer("interior"):
		# casa enterável mais perto da avenida, vista de dentro para a janela
		var best := -1
		var bd := INF
		for i in L.buildings.size():
			var b: Dictionary = L.buildings[i]
			if not bool(b.get("enterable", false)) or str(b.get("interior", b["type"])) != "house":
				continue
			var c := (b["rect"] as Rect2).get_center()
			var dd := Vector2(c.x - av.x, c.y - av.z).length()
			if dd < bd:
				bd = dd
				best = i
		if best >= 0:
			var di := BuildingGen.door_info(L.buildings[best])
			var door: Vector3 = di[0]
			var n: Vector3 = di[1]
			var c2 := (L.buildings[best]["rect"] as Rect2).get_center()
			# _go acharia o telhado (raio de cima): entra pela porta e põe o Caio no piso
			await _go(door + n * 2.5, door, 11.0, W.CLEAR, -0.05)
			var p := g.player
			p.set_physics_process(false)
			p.global_position = door - n * 2.2 + Vector3(0, 0.1, 0)
			var yaw := atan2(n.x, n.z)
			p.cam_rig.yaw = yaw
			p.set_yaw(yaw)
			p.set_physics_process(true)
			await _wait(2.5)
			await _shot("interior_dia")
	if _quer("noite"):
		await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 22.5, W.CLEAR)
		g.player.equipment["light"] = Inventory.make_stack("lanterna", 1, 1.0, {"battery": 100.0})
		if not g.player.flashlight_on:
			g.player.toggle_flashlight()
		await _wait(1.0)
		await _shot("noite_lanterna")
	if _quer("chuva"):
		await _go(av + Vector3(-3, 0, -150), av + Vector3(-3, 0, -220), 14.0, W.RAIN)
		await _wait(2.0)
		await _shot("chuva")
	if _quer("mata"):
		var ms := L.poi_pos("acampamento_floresta")
		await _go(ms + Vector3(12, 0, 8), ms, 12.5, W.CLEAR)
		await _shot("mata")
