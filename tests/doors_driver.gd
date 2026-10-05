extends "res://tests/gallery_driver.gd"
## Teste das portas: leva o Caio até a frente de várias casas/lojas, confere o
## aviso "Abrir porta", aperta E como o jogador, anda para dentro e verifica se
## entrou. Uso: xvfb-run godot --path . res://tests/doors.tscn -- --no-audio --out=/tmp/portas

var falhas := 0


func _gallery() -> void:
	var L := g.layout
	# FOTO_POI=id: só uma foto olhando para o ponto de interesse (fumaça, props)
	if OS.get_environment("FOTO_POI") != "":
		var pp := L.poi_pos(OS.get_environment("FOTO_POI"))
		await _go(pp + Vector3(5.5, 0, 5.5), pp + Vector3(0, 1.2, 0), 15.0, WeatherManager.State.CLEAR, -0.1)
		await _wait(2.0)
		var em := 0
		for n in g.world.find_children("*", "GPUParticles3D", true, false):
			if (n as Node3D).global_position.distance_to(pp) < 3.0:
				em += 1
				var gp := n as GPUParticles3D
				_log("  emissor %s pos=%s emitting=%s amount=%d visível=%s lifetime=%.1f pai=%s cam=%s" % [gp.name, str(gp.global_position.snapped(Vector3.ONE * 0.1)), str(gp.emitting), gp.amount,
					str(gp.is_visible_in_tree()), gp.lifetime, gp.get_parent().name, str(get_viewport().get_camera_3d().global_position.snapped(Vector3.ONE * 0.1))])
		_log("POI: %d emissores de partícula a menos de 3 m (fase=%d)" % [em, GameState.world_phase])
		if OS.get_environment("FOTO_SEM_OCLUSAO") != "":
			get_viewport().use_occlusion_culling = false
			_log("  oclusão desligada (estava %s)" % str(ProjectSettings.get_setting("rendering/occlusion_culling/use_occlusion_culling")))
		if OS.get_environment("FOTO_TESTE") != "":
			var t := Chunk._smoke_emitter(pp + Vector3(1.5, 0.25, 0), 16, 1.1, Color(0.4, 0.4, 0.4, 0.42), 0.35, 0.6)
			g.add_child(t)
			await _wait(3.0)
		await _shot("poi_" + OS.get_environment("FOTO_POI"))
		return
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
	if OS.get_environment("PORTAS_PISCA") != "":
		await pisca()


## Carro abandonado com pisca-alerta, à noite.
func pisca() -> void:
	TimeManager.set_time(21.5)
	var best: Node3D = null
	var bd := INF
	for n in g.world.find_children("Pisca*", "MeshInstance3D", true, false):
		var dd := (n as Node3D).global_position.distance_to(g.player.global_position)
		if dd < bd:
			bd = dd
			best = n
	_log("PISCA: %d carros piscando no mundo carregado; mais perto a %.0f m" % [g.world.find_children("Pisca*", "MeshInstance3D", true, false).size(), bd])
	if best == null:
		return
	var f := -best.global_transform.basis.z
	var cam := Camera3D.new()
	g.add_child(cam)
	cam.current = true
	cam.global_position = best.global_position + f * 6.5 + best.global_transform.basis.x * 2.5 + Vector3(0, 1.6, 0)
	cam.look_at(best.global_position + Vector3(0, 0.7, 0), Vector3.UP)
	g.ui.hud.visible = false
	for i in 3:
		await _wait(0.33)
		await _shot("pisca_%d" % i)


func _testa(bi: int) -> void:
	var L := g.layout
	var b: Dictionary = L.buildings[bi]
	var di := BuildingGen.door_info(b)
	var door: Vector3 = di[0]
	var n: Vector3 = di[1]
	var t := str(b.get("interior", b["type"]))
	var stand := door + n * 2.2
	if OS.get_environment("PORTAS_ENERGIA") != "":
		GameState.set_flag("power_%d" % bi, true)
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
	if OS.get_environment("PORTAS_ENERGIA") != "":
		var r2 := g.world.interior_root(bi)
		var fl: Node = r2.get_node_or_null("LampFlicker") if r2 else null
		var lights: Array = r2.find_children("*", "OmniLight3D", true, false) if r2 else []
		var mn := INF
		var mx := 0.0
		for i in 40:
			await _wait(0.15)
			for l in lights:
				mn = minf(mn, (l as OmniLight3D).light_energy)
				mx = maxf(mx, (l as OmniLight3D).light_energy)
		_log("  energia: luzes=%d lâmpada_falhando=%s energia min=%.2f max=%.2f" % [lights.size(), str(fl != null), mn, mx])
	if OS.get_environment("PORTAS_MOVEIS") != "":
		await moveis(bi)
	if OS.get_environment("PORTAS_ITENS") != "":
		await itens(bi)
	if OS.get_environment("PORTAS_BANDEIRA") != "" and str(b["type"]) in ChunkBuilder.FLAG_TYPES:
		var side := n.cross(Vector3.UP)
		var pole := door + n * 1.7 + side * (float(di[2]) * 0.5 + 2.2)
		var cam := Camera3D.new()
		g.add_child(cam)
		cam.current = true
		cam.global_position = pole + n * 9.0 + side * 3.0 + Vector3(0, 2.5, 0)
		cam.look_at(pole + Vector3(0, 5.8, 0), Vector3.UP)
		g.ui.hud.visible = false
		await _wait(1.0)
		await _shot("%s_%d_bandeira" % [t, bi])
		cam.queue_free()
		p.cam_rig.cam.current = true
		g.ui.hud.visible = true


## Item na mira (contorno pulsando) e o voo até a mão ao pegar.
func itens(bi: int) -> void:
	var root := g.world.interior_root(bi)
	if root == null:
		return
	var p := g.player
	var best: ItemPickup = null
	var bd := INF
	for c in get_tree().get_nodes_in_group("item_pickup"):
		var ip := c as ItemPickup
		if ip == null or not root.is_ancestor_of(ip):
			continue
		var dd := ip.global_position.distance_to(p.global_position)
		if dd < bd:
			bd = dd
			best = ip
	if best == null:
		_log("  itens: nenhum item no interior")
		return
	var to := best.global_position - p.global_position
	to.y = 0.0
	var stand := best.global_position - to.normalized() * 1.1
	p.global_position = Vector3(stand.x, p.global_position.y, stand.z)
	var yaw := atan2(-to.x, -to.z)
	p.cam_rig.yaw = yaw
	p.set_yaw(yaw)
	p.cam_rig.pitch = -0.55
	await _wait(0.8)
	_log("  itens: alvo=%s aviso='%s' destaque=%s" % [str(best.label_text()), p.current_interactable.get_prompt(p) if p.current_interactable else "-",
		str(best.mesh_node.material_overlay != null)])
	await _shot("item_%d_mira" % bi)
	if p.current_interactable == best:
		p._begin_interact()
		await _wait(0.1)
		await _shot("item_%d_pegando" % bi)


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
