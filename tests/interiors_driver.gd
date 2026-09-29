extends "res://tests/gallery_driver.gd"
## Fotos de dentro dos prédios (decoração abandonada, itens soltos, painel
## "Itens por perto"). Uso:
## xvfb-run godot --path . res://tests/interiors.tscn -- --no-audio --out=/tmp/interiores


func _gallery() -> void:
	var L := g.layout
	var av := L.poi_pos("avenida_central")
	var tipos := ["house", "apartment", "police", "hardware", "bar", "office", "grocery", "warehouse", "barn", "farmhouse"]
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--only="):
			tipos = Array(a.substr(7).split(","))
	var feitos := {}
	# prédio mais próximo da avenida de cada tipo de interior
	var order: Array = []
	for i in L.buildings.size():
		var b: Dictionary = L.buildings[i]
		if not bool(b.get("enterable", false)) or not b.has("rect"):
			continue
		var ctx := str(b.get("interior", b.get("type", "")))
		if not ctx in tipos:
			continue
		var c := (b["rect"] as Rect2).get_center()
		order.append([Vector2(c.x - av.x, c.y - av.z).length(), i, ctx])
	order.sort_custom(func(a, b): return float(a[0]) < float(b[0]))
	for e in order:
		var ctx: String = e[2]
		if feitos.has(ctx):
			continue
		feitos[ctx] = true
		await _visit(int(e[1]), ctx)


func _visit(bi: int, ctx: String) -> void:
	var b: Dictionary = g.layout.buildings[bi]
	var r: Rect2 = b["rect"]
	var di := BuildingGen.door_info(b)
	var door: Vector3 = di[0]
	var n: Vector3 = di[1]
	g.world.force_interior(bi, true)
	await _go(door + n * 3.0, door, 11.0, WeatherManager.State.CLEAR, 0.0)
	var t := 0.0
	while g.world.interior_root(bi) == null and t < 20.0:
		await _wait(0.25)
		t += 0.25
	var root := g.world.interior_root(bi)
	if root == null:
		_log("INTERIOR %s (%d): não carregou" % [ctx, bi])
		return
	var m := g.world.interior_markers(bi)
	var inside: Vector3 = (m["door_in"] as Transform3D).origin if m.has("door_in") else door - n * 1.5
	var center: Vector3 = (m["center"] as Transform3D).origin if m.has("center") else Vector3(r.get_center().x, inside.y, r.get_center().y)
	# conta o que tem lá dentro
	var npick := 0
	var armas: Array = []
	var labels := 0
	var verts := 0
	for ch in root.get_children():
		if ch is ItemPickup:
			npick += 1
			var id := str((ch as ItemPickup).stack.get("id", ""))
			if ItemDB.category(id) == "arma":
				armas.append(id)
		elif ch is Label3D:
			labels += 1
		elif ch is MeshInstance3D and (ch as MeshInstance3D).mesh is ArrayMesh:
			var am := (ch as MeshInstance3D).mesh as ArrayMesh
			for s in am.get_surface_count():
				verts += am.surface_get_array_len(s)
	_log("INTERIOR %-10s bi=%d itens=%d armas=%s pichacoes=%d vertices=%d" % [ctx, bi, npick, str(armas), labels, verts])
	if OS.get_cmdline_user_args().has("--diag"):
		var stack: Array = [root]
		while not stack.is_empty():
			var nd: Node = stack.pop_back()
			stack.append_array(nd.get_children())
			if nd is VisualInstance3D:
				var ab := (nd as VisualInstance3D).get_aabb()
				var gx := (nd as Node3D).global_transform
				var wab := gx * ab
				if wab.size.y > 1.3 and minf(wab.size.x, wab.size.z) < 0.3:
					_log("  ALTO: %s (%s) pai=%s aabb=%s" % [nd.name, nd.get_class(), nd.get_parent().get_class() + ":" + str(nd.get_parent().get_script().resource_path if nd.get_parent().get_script() else ""), str(wab)])
	# 1) jogador entrando (HUD com o painel de itens)
	g.ui.hud.visible = true
	var p := g.player
	p.set_physics_process(false)
	p.global_position = inside + Vector3(0, 0.05, 0)
	var d := center - inside
	var yaw := atan2(-d.x, -d.z)
	p.cam_rig.yaw = yaw
	p.cam_rig.pitch = -0.18
	p.set_yaw(yaw)
	p.set_physics_process(true)
	await _wait(2.0)
	await _shot("%s_entrada" % ctx)
	# 2) caminha até o item mais próximo do centro e mostra o destaque no painel
	var best: ItemPickup = null
	var bd := INF
	for ch in root.get_children():
		if ch is ItemPickup:
			var dd := (ch as ItemPickup).global_position.distance_to(inside)
			if dd < bd and dd > 1.5:
				bd = dd
				best = ch
	if best:
		var bp := best.global_position
		var dir := (bp - inside)
		dir.y = 0
		var stand := bp - dir.normalized() * 1.1
		stand.y = inside.y
		p.set_physics_process(false)
		p.global_position = stand + Vector3(0, 0.05, 0)
		var yw := atan2(-dir.x, -dir.z)
		p.cam_rig.yaw = yw
		p.cam_rig.pitch = -0.45
		p.set_yaw(yw)
		p.set_physics_process(true)
		await _wait(1.5)
		await _shot("%s_item_%s" % [ctx, str(best.stack.get("id", ""))])
	# 3) câmera livre de canto (sem HUD) para ver o cômodo inteiro
	g.ui.hud.visible = false
	var cam := Camera3D.new()
	cam.fov = 70.0
	g.add_child(cam)
	var cc := Vector3(center.x, inside.y, center.z)
	cam.global_position = inside + Vector3(0, 1.75, 0) - (cc - inside).normalized() * 0.4
	cam.look_at(cc + Vector3(0, 0.6, 0), Vector3.UP)
	cam.make_current()
	p.body.visible = false
	await _wait(0.8)
	await _shot("%s_comodo" % ctx)
	# dos cantos dos maiores cômodos, olhando na diagonal
	var data: Dictionary = {}
	for c in g.world.chunks.keys():
		var chk: Chunk = g.world.chunks[c]
		if chk.interiors.has(bi):
			data = chk.interiors[bi]["data"]
	var views: Array = data.get("room_views", []).duplicate()
	views.sort_custom(func(a, b): return float(a["area"]) > float(b["area"]))
	var done := {}
	var k := 0
	for v in views:
		if k >= 3:
			break
		if done.has(v["type"]):
			continue
		done[v["type"]] = true
		var a: Vector3 = v["a"]
		var bb: Vector3 = v["b"]
		cam.global_position = a + Vector3(0, 1.7, 0)
		cam.look_at(bb + Vector3(0, 0.5, 0), Vector3.UP)
		await _wait(0.4)
		await _shot("%s_%s" % [ctx, str(v["type"])])
		if OS.get_cmdline_user_args().has("--diag"):
			root.visible = false
			await _wait(0.2)
			await _shot("%s_%s_semint" % [ctx, str(v["type"])])
			root.visible = true
		k += 1
	p.body.visible = true
	cam.queue_free()
	p.cam_rig.cam.make_current()
	g.ui.hud.visible = true
	g.world.force_interior(bi, false)
