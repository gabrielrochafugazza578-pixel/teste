class_name CineFX
extends RefCounted
## Efeitos e props da abertura: faíscas, fumaça, colunas de fumaça,
## papéis ao vento, helicóptero, TV de plantão, veículos de emergência com
## giroflex e sirene. Reutilizam os mesmos materiais/partículas do jogo.


static func _particles(amount: int, life: float, sprite: int, color: Color, additive: bool, size: Vector2 = Vector2(0.4, 0.4)) -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = maxi(4, int(amount * Settings.get_particle_multiplier()))
	p.lifetime = life
	var q := QuadMesh.new()
	q.size = size
	q.material = Assets.particle_material(sprite, color, additive)
	p.draw_pass_1 = q
	return p


static func sparks(parent: Node, pos: Vector3) -> Node3D:
	var p := _particles(40, 0.7, Assets.SPR_SPARK, Color(1.0, 0.75, 0.35), true, Vector2(0.08, 0.08))
	p.one_shot = true
	p.explosiveness = 0.9
	var pm := ParticleProcessMaterial.new()
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 70.0
	pm.initial_velocity_min = 2.0
	pm.initial_velocity_max = 5.0
	pm.gravity = Vector3(0, -9.0, 0)
	p.process_material = pm
	parent.add_child(p)
	p.global_position = pos
	p.emitting = true
	var l := OmniLight3D.new()
	l.light_color = Color(1.0, 0.7, 0.4)
	l.light_energy = 3.0
	l.omni_range = 5.0
	p.add_child(l)
	var tw := p.create_tween()
	tw.tween_property(l, "light_energy", 0.0, 0.5)
	AudioManager.play_3d("sparks", pos, 0.0)
	p.get_tree().create_timer(2.0).timeout.connect(p.queue_free)
	return p


static func smoke(parent: Node, pos: Vector3, dense: bool = false) -> Node3D:
	var p := _particles(30 if dense else 18, 5.0, Assets.SPR_SMOKE, Color(0.55, 0.55, 0.56, 0.5), false, Vector2(1.6, 1.6))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = 0.4
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 30.0
	pm.initial_velocity_min = 0.3
	pm.initial_velocity_max = 0.9
	pm.gravity = Vector3(0, 0.25, 0)
	pm.scale_min = 0.8
	pm.scale_max = 2.4
	var grad := Gradient.new()
	grad.set_color(0, Color(0.6, 0.6, 0.6, 0.0))
	grad.add_point(0.25, Color(0.55, 0.55, 0.55, 0.45))
	grad.set_color(grad.get_point_count() - 1, Color(0.5, 0.5, 0.5, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	parent.add_child(p)
	p.global_position = pos
	return p


static func smoke_column(parent: Node, pos: Vector3) -> Node3D:
	var p := _particles(40, 14.0, Assets.SPR_SMOKE, Color(0.18, 0.17, 0.17, 0.75), false, Vector2(9.0, 9.0))
	p.preprocess = 10.0
	p.visibility_aabb = AABB(Vector3(-40, -5, -40), Vector3(80, 160, 80))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = 3.0
	pm.direction = Vector3(0.15, 1, 0)
	pm.spread = 10.0
	pm.initial_velocity_min = 5.0
	pm.initial_velocity_max = 8.0
	pm.gravity = Vector3(1.2, 0.3, 0.3)
	pm.scale_min = 1.0
	pm.scale_max = 3.2
	p.process_material = pm
	parent.add_child(p)
	p.global_position = pos
	return p


static func papers(parent: Node, pos: Vector3) -> Node3D:
	var p := _particles(26, 6.0, Assets.SPR_PAPER, Color(0.9, 0.88, 0.8), false, Vector2(0.25, 0.3))
	p.preprocess = 3.0
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(8, 0.2, 8)
	pm.direction = Vector3(0, 0.3, -1)
	pm.spread = 40.0
	pm.initial_velocity_min = 1.0
	pm.initial_velocity_max = 3.0
	pm.gravity = Vector3(0, -0.6, -0.8)
	pm.angular_velocity_min = -200.0
	pm.angular_velocity_max = 200.0
	p.process_material = pm
	parent.add_child(p)
	p.global_position = pos
	return p


## TV de plantão num suporte (fachada de loja de eletrônicos).
static func tv(parent: Node, pos: Vector3, yaw: float) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	root.global_position = pos
	root.rotation.y = yaw
	var b := MeshBuf.new()
	var met := Assets.uv2_code(Assets.L_METAL)
	b.box(Vector3(0, 0.55, 0), Vector3(0.08, 1.1, 0.08), met, 0.1, Color(0.2, 0.2, 0.22))
	b.box(Vector3(0, 0.02, 0), Vector3(0.6, 0.04, 0.5), met, 0.1, Color(0.2, 0.2, 0.22))
	b.box(Vector3(0, 1.45, 0.03), Vector3(1.3, 0.78, 0.07), met, 0.3, Color(0.05, 0.05, 0.06))
	var mi := MeshInstance3D.new()
	mi.mesh = b.to_mesh(Assets.world_material("props"))
	root.add_child(mi)
	var q := QuadMesh.new()
	q.size = Vector2(1.2, 0.68)
	var s := MeshInstance3D.new()
	s.mesh = q
	var vp := _news_screen(root)
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = vp.get_texture()
	mat.emission_enabled = true
	mat.emission_texture = vp.get_texture()
	mat.emission_energy_multiplier = 1.4
	mat.roughness = 0.25
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	s.material_override = mat
	# QuadMesh olha para +Z; a TV olha para -Z (frente do prop)
	s.transform = Transform3D(Basis(Vector3.UP, PI), Vector3(0, 1.45, -0.01))
	root.add_child(s)
	var l := OmniLight3D.new()
	l.light_color = Color(0.4, 0.55, 1.0)
	l.light_energy = 0.8
	l.omni_range = 3.5
	l.position = Vector3(0, 1.45, -0.6)
	root.add_child(l)
	return root


## Tela do plantão (2D numa SubViewport): faixa URGENTE, canal ao vivo, manchete,
## alerta e letreiro rolando — texto de verdade, não barras no lugar das letras.
static func _news_screen(root: Node3D) -> SubViewport:
	var vp := SubViewport.new()
	vp.size = Vector2i(960, 544)
	vp.disable_3d = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(vp)
	var bg := TextureRect.new()
	var gt := GradientTexture2D.new()
	var gr := Gradient.new()
	gr.set_color(0, Color(0.05, 0.09, 0.2))
	gr.set_color(1, Color(0.01, 0.02, 0.05))
	gt.gradient = gr
	gt.fill_from = Vector2(0.2, 0.0)
	gt.fill_to = Vector2(0.8, 1.0)
	bg.texture = gt
	bg.size = Vector2(960, 544)
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	vp.add_child(bg)
	var white := Color(0.97, 0.97, 0.95)
	var red := Color(0.82, 0.08, 0.07)
	# canal e "ao vivo"
	_news_label(vp, "TV AURORA", Vector2(36, 26), 30, white)
	var live := ColorRect.new()
	live.color = red
	live.position = Vector2(740, 28)
	live.size = Vector2(186, 40)
	vp.add_child(live)
	_news_label(vp, "● AO VIVO", Vector2(756, 30), 26, white)
	# alerta
	var tri := Polygon2D.new()
	tri.polygon = PackedVector2Array([Vector2(150, 150), Vector2(240, 306), Vector2(60, 306)])
	tri.color = Color(0.98, 0.78, 0.1)
	vp.add_child(tri)
	_news_label(vp, "!", Vector2(136, 200), 84, Color(0.08, 0.06, 0.02))
	# manchete
	var tag := ColorRect.new()
	tag.color = red
	tag.position = Vector2(290, 150)
	tag.size = Vector2(196, 44)
	vp.add_child(tag)
	_news_label(vp, "URGENTE", Vector2(306, 152), 30, white)
	_news_label(vp, "QUARENTENA TOTAL", Vector2(288, 206), 62, white)
	_news_label(vp, "Prefeitura de Santa Aurora decreta isolamento", Vector2(290, 290), 26, Color(0.8, 0.85, 0.95))
	_news_label(vp, "Evitem hospitais  •  Permaneçam em casa", Vector2(290, 326), 26, Color(0.8, 0.85, 0.95))
	# letreiro rolando
	var band := ColorRect.new()
	band.color = Color(0.55, 0.04, 0.04)
	band.position = Vector2(0, 446)
	band.size = Vector2(960, 58)
	vp.add_child(band)
	var clock := ColorRect.new()
	clock.color = Color(0.06, 0.06, 0.08)
	clock.position = Vector2(0, 446)
	clock.size = Vector2(130, 58)
	var tick := _news_label(vp, "PLANTÃO  •  Hospitais lotados no centro  •  Toque de recolher a partir das 20h  •  Exército bloqueia saídas da cidade  •  Não se aproxime de pessoas com febre ou tosse  •  ", Vector2(960, 456), 28, white)
	vp.add_child(clock)
	_news_label(vp, "19:24", Vector2(24, 456), 28, white)
	var tw := root.create_tween().set_loops()
	tw.tween_property(tick, "position:x", -1900.0, 22.0).from(960.0)
	return vp


static func _news_label(vp: SubViewport, text: String, pos: Vector2, size: int, col: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", col)
	vp.add_child(l)
	return l


## Helicóptero simples (fuselagem, cauda, rotor girando, holofote).
static func helicopter(parent: Node) -> Node3D:
	var root := Node3D.new()
	parent.add_child(root)
	var b := MeshBuf.new()
	var met := Assets.uv2_code(Assets.L_METAL)
	var dark := Color(0.12, 0.14, 0.16)
	b.box(Vector3(0, 0, 0), Vector3(1.8, 1.7, 4.2), met, 0.2, dark)
	b.box(Vector3(0, 0.25, -2.4), Vector3(1.4, 1.1, 1.0), met, 0.2, Color(0.2, 0.3, 0.35))
	b.box(Vector3(0, 0.35, 4.3), Vector3(0.35, 0.4, 4.6), met, 0.2, dark)
	b.box(Vector3(0, 1.0, 6.4), Vector3(0.12, 1.4, 0.8), met, 0.2, dark)
	for sx: float in [-0.8, 0.8]:
		b.box(Vector3(sx, -1.1, 0), Vector3(0.08, 0.08, 3.4), met, 0.2, dark)
	var mi := MeshInstance3D.new()
	mi.mesh = b.to_mesh(Assets.world_material("props"))
	root.add_child(mi)
	var rotor := MeshInstance3D.new()
	var rb := MeshBuf.new()
	rb.box(Vector3(0, 0, 0), Vector3(0.25, 0.04, 10.5), met, 0.1, Color(0.08, 0.08, 0.08))
	rb.box(Vector3(0, 0, 0), Vector3(10.5, 0.04, 0.25), met, 0.1, Color(0.08, 0.08, 0.08))
	rotor.mesh = rb.to_mesh(Assets.world_material("props"))
	rotor.position = Vector3(0, 1.05, 0)
	rotor.name = "Rotor"
	root.add_child(rotor)
	var spot := SpotLight3D.new()
	spot.spot_range = 90.0
	spot.spot_angle = 12.0
	spot.light_energy = 12.0
	spot.light_color = Color(0.95, 0.97, 1.0)
	spot.rotation = Vector3(-1.1, 0, 0)
	spot.position = Vector3(0, -1.0, -1.8)
	spot.shadow_enabled = false
	root.add_child(spot)
	var blink := OmniLight3D.new()
	blink.light_color = Color(1, 0.1, 0.1)
	blink.omni_range = 4.0
	blink.position = Vector3(0, -0.9, 0)
	blink.name = "Blink"
	root.add_child(blink)
	return root


## Luzes de giroflex para ambulância/viatura.
static func lightbar(vehicle_node: Node3D, height: float) -> void:
	for k in 2:
		var l := OmniLight3D.new()
		l.light_color = Color(1.0, 0.1, 0.08) if k == 0 else Color(0.15, 0.3, 1.0)
		l.light_energy = 2.5
		l.omni_range = 9.0
		l.position = Vector3(-0.5 + k * 1.0, height + 0.25, 0)
		l.name = "Flash%d" % k
		l.add_to_group("cine_flash")
		vehicle_node.add_child(l)
