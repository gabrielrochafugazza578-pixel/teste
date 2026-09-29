extends "res://tests/gallery_driver.gd"
## Fotos de iluminação/visibilidade: as mesmas situações antes e depois de mexer
## em exposição, ambiente e neblina (dia limpo, nublado, entardecer, noite,
## interior, túnel, Setor 7) e um close da grama.
## Uso: xvfb-run godot --path . res://tests/light.tscn -- --no-audio --out=/tmp/luz [--only=noite,interior]

var only: PackedStringArray = []


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--only="):
			only = a.substr(7).split(",")
	super._ready()


func _want(name: String) -> bool:
	return only.is_empty() or name in only


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	var ip := L.poi_pos("inicio_gameplay")
	var av := L.poi_pos("avenida_central")
	if _want("serra"):
		await _go(ip, ip + Vector3(0, 0, 60), 9.2, W.CLOUDY)
		await _shot("serra")
	if _want("grama"):
		# campo aberto na serra, câmera baixa olhando o mato
		await _go(ip + Vector3(-14, 0, 30), ip + Vector3(-30, 0, 60), 11.0, W.CLEAR, -0.22)
		await _shot("grama")
	if _want("avenida"):
		await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 8.6, W.CLEAR)
		await _shot("avenida")
	if _want("nublado"):
		await _go(av + Vector3(-3, 0, -150), av + Vector3(-3, 0, -220), 15.0, W.OVERCAST)
		await _shot("nublado")
	if _want("chuva"):
		await _go(av + Vector3(3, 0, 420), av + Vector3(3, 0, 360), 16.5, W.STORM)
		await _shot("chuva")
	if _want("entardecer"):
		await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, -20), 18.4, W.CLEAR)
		await _shot("entardecer")
	if _want("noite"):
		await _go(av + Vector3(-4, 0, 60), av + Vector3(-4, 0, 0), 22.5, W.CLEAR)
		await _shot("noite")
	if _want("lanterna"):
		await _go(av + Vector3(-4, 0, 60), av + Vector3(-4, 0, 0), 23.0, W.CLOUDY)
		g.player.equipment["light"] = Inventory.make_stack("lanterna", 1, 1.0, {"battery": 100.0})
		if not g.player.flashlight_on:
			g.player.toggle_flashlight()
		await _wait(1.5)
		var fl := g.player.flashlight
		_log("lanterna: on=%s vis=%s intree=%s pos=%s dir=%s energia=%.2f alcance=%.1f sombra=%s" % [g.player.flashlight_on,
			fl.is_visible_in_tree(), fl.is_inside_tree(), fl.global_position, -fl.global_transform.basis.z, fl.light_energy,
			fl.spot_range, fl.shadow_enabled])
		await _shot("lanterna")
		if "--dbg" in OS.get_cmdline_user_args():
			g.player.set_physics_process(false)
			g.player.body.visible = false
			await _shot("lanterna_sem_corpo")
			var sp := SpotLight3D.new()
			for prop in ["spot_range", "spot_angle", "spot_angle_attenuation", "spot_attenuation", "light_energy", "light_color"]:
				sp.set(prop, fl.get(prop))
			g.add_child(sp)
			sp.global_transform = fl.global_transform
			fl.visible = false
			await _wait(0.3)
			await _shot("copia_da_lanterna")
			_log("copia: pos=%s dir=%s" % [sp.global_position, -sp.global_transform.basis.z])
			sp.queue_free()
			fl.visible = true
			g.player.body.visible = true
			g.player.set_physics_process(true)
		if g.player.flashlight_on:
			g.player.toggle_flashlight()
	if _want("interior"):
		var bi := g.world.building_for_poi("mercado")
		if bi >= 0:
			var b: Dictionary = L.buildings[bi]
			var c := (b["rect"] as Rect2).get_center()
			var fp := Vector3(c.x, float(b["base"]), c.y)
			await _go(fp, fp + Vector3(0, 0, -10), 13.0, W.CLOUDY, -0.05)
			await _wait(1.5)
			await _shot("interior")
	if _want("tunel"):
		var tp := Vector3(0, WorldLayout.TUNNEL_Y, -1120)
		await _go(tp, tp + Vector3(0, 0, -40), 13.0, W.CLOUDY)
		await _shot("tunel")
	if _want("setor7"):
		g._enter_setor7(false)
		await _wait(4.0)
		await _shot("setor7")
		g._exit_setor7()
		await _wait(3.0)
