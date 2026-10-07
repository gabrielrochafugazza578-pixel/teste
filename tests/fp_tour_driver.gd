extends "res://tests/gallery_driver.gd"
## Tour curto para avaliar o visual (Forward+ é lento no Vulkan por software):
## rua de manhã, pôr do sol, interior de casa, noite com lanterna, chuva, lago e mata.
## Uso: xvfb-run godot --path . --rendering-method forward_plus res://tests/fp_tour.tscn --
##      --no-audio --out=/tmp/tour [--preset=4] [--gfx=gi_quality:0] [--so=rua,interior]
##      [--pontos] (~30 lugares espalhados pelo mapa, horas e climas variados)


## Antes de cada foto espera quadros de verdade (o SDFGI converge em ~15-20
## quadros; no Vulkan por software são vários segundos).
func _shot(name: String) -> void:
	var nf := 40
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--quadros="):
			nf = int(a.substr(10))
	for i in nf:
		await get_tree().process_frame
	await super._shot(name)


func _quer(nome: String) -> bool:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--so="):
			return nome in a.substr(5).split(",")
	return true


## Lugares espalhados: [poi, hora, clima, distância da fachada]
const PONTOS := [
	["hospital", 10.0, 0, 16.0], ["delegacia", 8.5, 1, 14.0], ["escola", 15.0, 0, 16.0],
	["estadio", 17.3, 0, 30.0], ["igreja_matriz", 7.0, 3, 18.0], ["mercado", 12.0, 2, 14.0],
	["posto_vila", 16.0, 0, 16.0], ["oficina", 13.0, 4, 12.0], ["terminal", 18.2, 0, 20.0],
	["clinica", 10.5, 1, 12.0], ["lab_nexus", 9.5, 0, 18.0], ["torre_radio", 6.6, 3, 18.0],
	["corvalis_hq", 14.0, 2, 20.0], ["igreja_despertos", 19.2, 0, 16.0], ["apartamento_helena", 11.0, 0, 12.0],
	["bunker", 15.5, 1, 14.0], ["cabanas_lago", 7.4, 3, 14.0], ["mirante", 17.8, 0, 10.0],
	["tunel", 12.0, 0, 14.0], ["ponte_velha", 10.0, 4, 16.0], ["checkpoint_ponte", 16.5, 2, 14.0],
	["praca", 13.0, 0, 14.0], ["centro", 21.5, 0, 10.0], ["acampamento_estrada", 9.0, 0, 12.0],
	["acampamento_rio", 15.0, 0, 12.0], ["lago_azul", 12.0, 0, 16.0], ["chegada_caio", 18.0, 1, 10.0],
	["avenida_central", 16.0, 5, 12.0], ["corvalis", 11.0, 0, 18.0], ["acampamento_floresta", 23.0, 0, 10.0],
	["tunel_manutencao", 14.5, 2, 12.0],
]


## Segunda leva (--pontos=extra): [poi, hora, clima, posição relativa, alvo relativo]
const EXTRA := [
	["mirante", 17.8, 0, Vector3(0, 0, 6), Vector3(0, -20, 120)],
	["chegada_caio", 16.5, 1, Vector3(0, 0, 18), Vector3(0, 2, -20)],
	["avenida_central", 9.5, 0, Vector3(-6, 0, 60), Vector3(0, 6, -40)],
	["praca", 18.4, 0, Vector3(14, 0, -10), Vector3(0, 3, 0)],
]


func _extra() -> void:
	for pt: Array in EXTRA:
		var c := g.layout.poi_pos(str(pt[0]))
		if c == Vector3.ZERO:
			continue
		await _go(c + (pt[3] as Vector3), c + (pt[4] as Vector3), float(pt[1]), int(pt[2]), -0.05)
		if g.player.flashlight_on:
			g.player.toggle_flashlight()
		await _wait(1.5)
		await _shot(str(pt[0]) + "_b")


func _pontos() -> void:
	if "--pontos=extra" in OS.get_cmdline_user_args():
		await _extra()
		return
	for pt: Array in PONTOS:
		var id := str(pt[0])
		if g.layout.poi_pos(id) == Vector3.ZERO:
			continue
		var fo := _front_of(id, float(pt[3]))
		var hour := float(pt[1])
		await _go(fo[0], fo[1], hour, int(pt[2]), -0.02)
		var night := hour >= 20.0 or hour < 5.5
		if night:
			g.player.equipment["light"] = Inventory.make_stack("lanterna", 1, 1.0, {"battery": 100.0})
			if not g.player.flashlight_on:
				g.player.toggle_flashlight()
		elif g.player.flashlight_on:
			g.player.toggle_flashlight()
		await _wait(1.5)
		await _shot(id)


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	if " ".join(OS.get_cmdline_user_args()).contains("--pontos"):
		await _pontos()
		return
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
	if _quer("lago"):
		var lk := L.poi_pos("cabanas_lago")
		await _go(lk + Vector3(10, 0, 10), Vector3(WorldLayout.LAKE_CENTER.x, 0, WorldLayout.LAKE_CENTER.y), 16.8, W.CLEAR)
		await _shot("lago")
	if _quer("mata"):
		var ms := L.poi_pos("acampamento_floresta")
		await _go(ms + Vector3(12, 0, 8), ms, 12.5, W.CLEAR)
		await _shot("mata")
