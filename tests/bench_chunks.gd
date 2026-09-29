extends Node
## Mede o custo de geração dos chunks (CPU) — base para o orçamento do i3-4130.

func _ready() -> void:
	print("inicio")
	await Assets.bake_all()
	print("bake ok")
	var layout := WorldLayout.new()
	var t := Time.get_ticks_usec()
	layout.generate(GameState.world_seed)
	print("layout: %.1f ms" % ((Time.get_ticks_usec() - t) / 1000.0))
	PropLib.warm()
	var coords := [Vector2i(0, 0), Vector2i(-9, -7), Vector2i(10, 0), Vector2i(0, -17), Vector2i(-19, -5), Vector2i(5, 16)]
	var opts := {"veg_density": 0.45, "grass": true, "grass_density": 0.45, "decay": 1.0}
	# custo do relevo das fachadas (triângulos da malha de detalhe, chunks do centro)
	for rel in [false, true]:
		opts["relief"] = rel
		var tris := 0
		var tt := 0.0
		var ap := layout.poi_pos("avenida_central")
		var ac := Vector2i(floori(ap.x / WorldLayout.CHUNK), floori(ap.z / WorldLayout.CHUNK))
		for c in [ac, ac + Vector2i(1, 0), ac + Vector2i(-1, 0), ac + Vector2i(0, 1), ac + Vector2i(0, -1), ac + Vector2i(1, -2)]:
			t = Time.get_ticks_usec()
			var dd := ChunkBuilder.build(layout, c, 0, opts)
			tt += (Time.get_ticks_usec() - t) / 1000.0
			tris += (dd["details"] as MeshBuf).idx.size() / 3 + (dd["shells"] as MeshBuf).idx.size() / 3
		print("relevo=%s: prédios %d triângulos em 6 chunks (%.0f/chunk), %.1f ms/chunk" % [str(rel), tris, tris / 6.0, tt / 6.0])
	opts["relief"] = true
	for lod in [0, 1, 2]:
		var total := 0.0
		for c in coords:
			t = Time.get_ticks_usec()
			var d := ChunkBuilder.build(layout, c, lod, opts)
			total += (Time.get_ticks_usec() - t) / 1000.0
		print("lod %d: média %.1f ms/chunk" % [lod, total / coords.size()])
	var tp := 0.0
	for c in coords:
		t = Time.get_ticks_usec()
		ChunkBuilder.build_phase(layout, c, GameState.Phase.POST)
		tp += (Time.get_ticks_usec() - t) / 1000.0
	print("fase: média %.1f ms/chunk" % (tp / coords.size()))
	var ti := 0.0
	var n := 0
	for b in layout.buildings:
		if b["enterable"] and n < 40:
			t = Time.get_ticks_usec()
			InteriorGen.build(b)
			ti += (Time.get_ticks_usec() - t) / 1000.0
			n += 1
	print("interior: média %.1f ms (%d prédios)" % [ti / maxi(n, 1), n])
	var lab: Dictionary = layout.buildings[int(layout.pois["lab_nexus"]["building"])]
	t = Time.get_ticks_usec()
	var li := InteriorGen.build(lab)
	print("laboratório: %.1f ms, marcadores=%s" % [(Time.get_ticks_usec() - t) / 1000.0, str(li["markers"].keys())])
	t = Time.get_ticks_usec()
	for i in 20:
		HumanoidMeshBuilder.build(Appearance.civilian(i), 0)
	print("humanoide lod0: %.1f ms" % ((Time.get_ticks_usec() - t) / 20000.0))
	get_tree().quit()
