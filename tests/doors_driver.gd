extends "res://tests/gallery_driver.gd"
## Teste das portas: leva o Caio até a frente de várias casas/lojas, confere o
## aviso "Abrir porta", aperta E como o jogador, anda para dentro e verifica se
## entrou. Uso: xvfb-run godot --path . res://tests/doors.tscn -- --no-audio --out=/tmp/portas

var falhas := 0


func _gallery() -> void:
	var L := g.layout
	var av := L.poi_pos("avenida_central")
	var p := g.player
	# prédios enteráveis mais perto da avenida, de tipos variados
	var cands: Array = []
	for i in L.buildings.size():
		var b: Dictionary = L.buildings[i]
		if not bool(b.get("enterable", false)):
			continue
		var c := (b["rect"] as Rect2).get_center()
		cands.append([Vector2(c.x - av.x, c.y - av.z).length(), i])
	cands.sort_custom(func(a, bb): return a[0] < bb[0])
	var tipos := {}
	var lista: Array = []
	var so := OS.get_environment("PORTAS_TIPOS").split(",", false)
	for e in cands:
		if not so.is_empty():
			var bt: Dictionary = L.buildings[e[1]]
			if not str(bt.get("interior", bt["type"])) in so:
				continue
		var b: Dictionary = L.buildings[e[1]]
		var t := str(b.get("interior", b["type"]))
		if int(tipos.get(t, 0)) >= (3 if t == "house" else 1):
			continue
		tipos[t] = int(tipos.get(t, 0)) + 1
		lista.append(e[1])
		if lista.size() >= int(OS.get_environment("PORTAS_N") if OS.get_environment("PORTAS_N") != "" else "7"):
			break
	for bi in lista:
		await _testa(bi)
	_log("PORTAS: %d falha(s) em %d prédios" % [falhas, lista.size()])


func _testa(bi: int) -> void:
	var L := g.layout
	var b: Dictionary = L.buildings[bi]
	var di := BuildingGen.door_info(b)
	var door: Vector3 = di[0]
	var n: Vector3 = di[1]
	var t := str(b.get("interior", b["type"]))
	var stand := door + n * 2.2
	await _go(stand, door, 11.0, WeatherManager.State.CLEAR, -0.05)
	var w := 0.0
	while g.world.interior_root(bi) == null and w < 20.0:
		await _wait(0.25)
		w += 0.25
	var p := g.player
	await _wait(0.5)
	# porta mais perto da entrada
	var best: Door = null
	var bd := INF
	var root := g.world.interior_root(bi)
	if root:
		for c in root.get_children():
			if c is Door:
				var dd := (c as Door).global_position.distance_to(door)
				if dd < bd:
					bd = dd
					best = c
	var prompt := ""
	if p.current_interactable:
		prompt = p.current_interactable.get_prompt(p)
	_log("[%s #%d] interior=%s porta_mais_perto=%.2f m alvo=%s aviso='%s' estado=%s" % [t, bi, str(root != null), bd,
		str(p.current_interactable.get_class() if p.current_interactable else "nada"), prompt,
		("aberta" if best and best.is_open else ("trancada" if best and best.locked else "fechada")) if best else "-"])
	await _shot("%s_%d_a" % [t, bi])
	if best and not best.is_open:
		if best.locked:
			best.locked = false
			_log("  (destranquei para o teste)")
		p._begin_interact()
		await _wait(1.2)
		_log("  depois do E: porta aberta=%s" % str(best.is_open))
	# anda para dentro
	var to := door - n * 3.0 - p.global_position
	var yaw := atan2(-to.x, -to.z)
	p.cam_rig.yaw = yaw
	p.set_yaw(yaw)
	Input.action_press("move_forward")
	var t0 := 0.0
	while t0 < 4.0 and not g.world.is_indoors(p.global_position):
		await get_tree().physics_frame
		t0 += get_physics_process_delta_time()
	await _wait(0.6)
	Input.action_release("move_forward")
	var dentro := g.world.is_indoors(p.global_position)
	if not dentro:
		falhas += 1
		# o que está bloqueando: raios na altura do joelho, cintura e cabeça
		var ss := p.get_world_3d().direct_space_state
		for hgt: float in [0.3, 0.9, 1.6]:
			var a := Vector3(p.global_position.x, p.global_position.y + hgt, p.global_position.z)
			var q := PhysicsRayQueryParameters3D.create(a, a + (-n) * 2.0, p.collision_mask)
			q.exclude = [p.get_rid()]
			var hit := ss.intersect_ray(q)
			if hit.is_empty():
				_log("  raio h=%.1f: livre" % hgt)
			else:
				var col: Object = hit["collider"]
				_log("  raio h=%.1f: bate em %s (%s) shape=%d a %.2f m pos=%s" % [hgt, str(col), (col as Node).get_path() if col is Node else "rid", int(hit["shape"]),
					a.distance_to(hit["position"]), str((hit["position"] as Vector3).snapped(Vector3.ONE * 0.01))])
				var brid: RID = hit["rid"]
				var srid := PhysicsServer3D.body_get_shape(brid, int(hit["shape"]))
				var sxf := PhysicsServer3D.body_get_shape_transform(brid, int(hit["shape"]))
				var bxf: Transform3D = PhysicsServer3D.body_get_state(brid, PhysicsServer3D.BODY_STATE_TRANSFORM)
				_log("     forma tipo=%d dados=%s centro=%s base_corpo=%s" % [PhysicsServer3D.shape_get_type(srid), str(PhysicsServer3D.shape_get_data(srid)),
					str((bxf * sxf.origin).snapped(Vector3.ONE * 0.01)), str(bxf.origin.snapped(Vector3.ONE * 0.1))])
		_log("  máscara do jogador=%d camada=%d" % [p.collision_mask, p.collision_layer])
		var kc := p.move_and_collide(-n * 1.2, true)
		if kc:
			var cr := kc.get_collider_rid()
			var si := kc.get_collider_shape_index()
			var sr := PhysicsServer3D.body_get_shape(cr, si) if kc.get_collider() == null else RID()
			_log("  cápsula bate em %s shape=%d ponto=%s normal=%s dados=%s centro=%s" % [str(kc.get_collider()), si, str(kc.get_position().snapped(Vector3.ONE * 0.01)),
				str(kc.get_normal().snapped(Vector3.ONE * 0.01)), str(PhysicsServer3D.shape_get_data(sr)) if sr.is_valid() else "-",
				str(PhysicsServer3D.body_get_shape_transform(cr, si).origin.snapped(Vector3.ONE * 0.01)) if sr.is_valid() else "-"])
		else:
			_log("  cápsula: caminho livre")
	_log("  entrou=%s pos=%s dist_porta=%.2f" % [str(dentro), str(p.global_position.snapped(Vector3.ONE * 0.01)), Vector2(p.global_position.x - door.x, p.global_position.z - door.z).length()])
	await _shot("%s_%d_b" % [t, bi])
	if OS.get_environment("PORTAS_MOVEIS") != "":
		await moveis(bi)


## Fotos das animações de móveis: num interior já carregado, abre o contêiner
## mais perto de cada família (gaveta, porta, tampa) e fotografa.
func moveis(bi: int) -> void:
	var root := g.world.interior_root(bi)
	if root == null:
		return
	var p := g.player
	var feitos := {}
	for c in root.get_children():
		var lc := c as LootContainer
		if lc == null:
			continue
		var fam := "gaveta" if lc.kind in LootContainer.DRAWER_KINDS else ("porta" if lc.kind in LootContainer.DOOR_KINDS else ("tampa" if lc.kind in LootContainer.LID_KINDS else ""))
		if fam == "" or feitos.has(fam):
			continue
		feitos[fam] = true
		var fwd := -lc.global_transform.basis.z
		var eye := lc.global_position + fwd * 1.6 + Vector3(0, 0.5, 0)
		p.set_physics_process(false)
		p.global_position = lc.global_position + fwd * 1.3 - Vector3(0, lc._lift, 0)
		var cam := Camera3D.new()
		g.add_child(cam)
		cam.current = true
		cam.global_position = eye + fwd.cross(Vector3.UP) * 0.6
		cam.look_at(lc.global_position, Vector3.UP)
		g.ui.hud.visible = false
		await _wait(0.4)
		await _shot("movel_%s_%s_fechado" % [fam, lc.kind])
		lc._open_anim(false)
		await _wait(0.8)
		await _shot("movel_%s_%s_aberto" % [fam, lc.kind])
		cam.queue_free()
		p.cam_rig.cam.current = true
		g.ui.hud.visible = true
		p.set_physics_process(true)
		_log("  móvel %s (%s) animado" % [fam, lc.kind])
