extends "res://tests/gallery_driver.gd"
## Fotos focadas nas fachadas (antes/depois de mexer nos prédios).
## Uso: xvfb-run godot --path . res://tests/buildings.tscn -- --no-audio --out=/tmp/predios


func _gallery() -> void:
	var L := g.layout
	var W := WeatherManager.State
	g.ui.hud.visible = false
	var av := L.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 12, -20), 10.0, W.CLEAR, 0.3)
	await _shot("avenida")
	# vistas aéreas com câmera livre (fachadas inteiras)
	var cam := Camera3D.new()
	cam.fov = 60.0
	cam.far = 1500.0
	g.add_child(cam)
	for v in [[Vector3(4, 30, 90), Vector3(4, 4, -30), "aerea_avenida"], [Vector3(4, 16, 45), Vector3(30, 12, 5), "aerea_avenida_lado"],
			[Vector3(-3, 26, -100), Vector3(-3, 4, -210), "aerea_centro"]]:
		cam.global_position = av + (v[0] as Vector3)
		cam.look_at(av + (v[1] as Vector3), Vector3.UP)
		cam.make_current()
		await _wait(1.5)
		await _shot(str(v[2]))
	cam.queue_free()
	g.player.cam_rig.cam.make_current()
	await _go(av + Vector3(-3, 0, -150), av + Vector3(-3, 10, -220), 15.0, W.CLOUDY, 0.3)
	await _shot("centro")
	for poi in ["hospital", "mercado", "delegacia"]:
		var f := _front_of(poi, 20.0, 5.0)
		await _go(f[0], (f[1] as Vector3) + Vector3(0, 6, 0), 11.0, W.CLEAR, 0.3)
		await _shot(poi)
	await _go(Vector3(-600, 0, -420), Vector3(-600, 2, -500), 9.0, W.CLEAR, 0.02)
	await _shot("casas")
	# prédio residencial qualquer visto de perto
	var best := -1
	var bd := INF
	for i in L.buildings.size():
		var b: Dictionary = L.buildings[i]
		if str(b.get("type", "")) == "apartment" and b.has("rect"):
			var c := (b["rect"] as Rect2).get_center()
			var d := Vector2(c.x - av.x, c.y - av.z).length()
			if d < bd:
				bd = d
				best = i
	if best >= 0:
		var b: Dictionary = L.buildings[best]
		var r: Rect2 = b["rect"]
		var di := BuildingGen.door_info(b)
		var n: Vector3 = di[1]
		var p: Vector3 = (di[0] as Vector3) + n * 16.0 + Vector3(n.z, 0, -n.x) * 4.0
		await _go(p, Vector3(r.get_center().x, float(b["base"]) + 8.0, r.get_center().y), 13.0, W.CLEAR, 0.3)
		await _shot("apartamentos")
