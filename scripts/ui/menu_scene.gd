class_name MenuScene
extends SubViewportContainer
## Fundo 3D do menu principal: uma rua de verdade do jogo (prédios do
## BuildingGen, asfalto e calçadas com os materiais em foto, entulho escaneado)
## no fim de tarde, com a cidade queimando no fim da avenida — fumaça, brasas e
## clarão alaranjado — e o Caio parado de costas, mochila nas costas, olhando.
## A câmera respira devagar. Tudo gerado aqui, sem vídeo.

var vp: SubViewport
var cam: Camera3D
var body: HumanoidBody
var _t: float = 0.0
var _fires: Array[OmniLight3D] = []
var _fire_e: Array[float] = []
var _cam_base := Vector3(-0.2, 1.62, 3.6)
var _look := Vector3(-2.4, 2.4, -40.0)


func _ready() -> void:
	stretch = true
	UIKit.full_rect(self)
	vp = SubViewport.new()
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_2X if Settings.is_forward_plus() else Viewport.MSAA_DISABLED
	vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	if Settings.is_forward_plus():
		vp.use_taa = true
	add_child(vp)
	# mesma "hora" do jogo: entardecer de apagão, rua molhada da chuva da tarde
	ShaderGlobals.set_value("daylight", 0.32)
	ShaderGlobals.set_value("wetness", 0.45)
	ShaderGlobals.set_value("rain_intensity", 0.0)
	ShaderGlobals.set_value("world_decay", 0.8)
	ShaderGlobals.set_value("city_power", 0.0)
	ShaderGlobals.set_value("ssao_active", 1.0 if Settings.is_forward_plus() else 0.0)
	RenderingServer.global_shader_parameter_set("wind", Vector4(1.0, 0.0, 0.35, 0.3))
	_environment()
	_street()
	_props()
	_skyline()
	_caio()
	cam = Camera3D.new()
	cam.fov = 48.0
	cam.near = 0.05
	cam.far = 900.0
	var ca := CameraAttributesPractical.new()
	ca.dof_blur_far_enabled = true
	ca.dof_blur_far_distance = 45.0
	ca.dof_blur_far_transition = 60.0
	ca.dof_blur_amount = 0.035
	cam.attributes = ca
	vp.add_child(cam)
	_update_cam()


func _environment() -> void:
	var env := Environment.new()
	var sky := Sky.new()
	var sm := ProceduralSkyMaterial.new()
	sm.sky_top_color = Color(0.1, 0.11, 0.16)
	sm.sky_horizon_color = Color(0.5, 0.29, 0.19)
	sm.sky_curve = 0.12
	sm.ground_horizon_color = Color(0.32, 0.2, 0.14)
	sm.ground_bottom_color = Color(0.05, 0.05, 0.05)
	sm.sun_angle_max = 18.0
	sm.sun_curve = 0.08
	sm.sky_energy_multiplier = 1.0
	sky.sky_material = sm
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.55 if not Settings.is_forward_plus() else 0.8
	env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	env.tonemap_mode = Environment.TONE_MAPPER_AGX if Settings.is_forward_plus() else Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.0
	env.glow_enabled = true
	env.glow_intensity = 0.7
	env.glow_bloom = 0.08
	env.glow_hdr_threshold = 1.1
	env.fog_enabled = true
	env.fog_light_color = Color(0.36, 0.26, 0.22)
	env.fog_density = 0.0065
	env.fog_sun_scatter = 0.12
	env.fog_aerial_perspective = 0.4
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.9
	env.adjustment_contrast = 1.08
	var dbg := OS.get_cmdline_user_args()
	if Settings.is_forward_plus():
		env.ssao_enabled = not "--menu-sem-ssao" in dbg
		env.ssao_radius = 1.2
		env.ssao_intensity = 1.6
		env.ssr_enabled = true
		env.ssr_max_steps = 48
		env.volumetric_fog_enabled = not "--menu-sem-vol" in dbg
		env.volumetric_fog_density = 0.0035
		env.volumetric_fog_albedo = Color(0.7, 0.58, 0.5)
		env.volumetric_fog_anisotropy = 0.6
		env.volumetric_fog_length = 160.0
		env.volumetric_fog_ambient_inject = 0.3
		# a neblina volumétrica já faz o papel da de distância: esta fica leve
		env.fog_density = 0.002
		env.tonemap_exposure = 1.25
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	# sol baixo no fim da avenida (contraluz: o Caio vira silhueta com borda)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-12.0, 179.5, 0.0)
	sun.light_color = Color(1.0, 0.56, 0.32)
	sun.light_energy = 1.35
	sun.shadow_enabled = not "--menu-sem-sombra" in dbg
	sun.directional_shadow_max_distance = 60.0
	# sol rasante: sem viés o asfalto se sombreia sozinho (acne) no Vulkan
	sun.shadow_bias = 0.08
	sun.shadow_normal_bias = 3.5
	sun.light_volumetric_fog_energy = 1.6
	vp.add_child(sun)
	# luz fria de preenchimento vinda do céu às costas da câmera
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-35.0, -20.0, 0.0)
	fill.light_color = Color(0.45, 0.55, 0.75)
	fill.light_energy = 0.25
	vp.add_child(fill)


## Duas quadras de avenida: asfalto, meio-fio, calçadas e prédios dos dois lados.
func _street() -> void:
	var shell := MeshBuf.new()
	var detail := MeshBuf.new()
	var ASP := Assets.uv2_code(Assets.L_ASPHALT)
	var CON := Assets.uv2_code(Assets.L_CONCRETE)
	var z0 := -230.0
	var z1 := 30.0
	shell.quad(Vector3(-6, 0, z0), Vector3(6, 0, z0), Vector3(6, 0, z1), Vector3(-6, 0, z1), Vector3.UP,
		Vector2(-6, z0), Vector2(6, z0), Vector2(6, z1), Vector2(-6, z1), ASP, 0.31, Color(0.9, 0.9, 0.9))
	for sx: float in [-1.0, 1.0]:
		detail.box(Vector3(sx * 8.0, 0.075, (z0 + z1) * 0.5), Vector3(4.0, 0.15, z1 - z0), CON, 0.2, Color(0.78, 0.77, 0.74))
		# faixa tracejada no meio da pista
	for k in range(0, 40):
		var z := z1 - 3.0 - k * 6.5
		detail.box(Vector3(0, 0.004, z), Vector3(0.15, 0.008, 3.0), CON, 0.4, Color(0.85, 0.8, 0.6))
	var rng := RandomNumberGenerator.new()
	rng.seed = 2026
	var kinds := [["apartment", Assets.WM_RES, Assets.L_PLASTER], ["commercial", Assets.WM_SHOP, Assets.L_BRICK],
		["office", Assets.WM_OFFICE, Assets.L_PANELS], ["apartment", Assets.WM_RES, Assets.L_BRICK],
		["commercial", Assets.WM_SHOP, Assets.L_PLASTER]]
	var tints := [Color(0.86, 0.84, 0.8), Color(0.78, 0.7, 0.62), Color(0.7, 0.74, 0.76), Color(0.9, 0.86, 0.74), Color(1, 1, 1)]
	for sx: float in [-1.0, 1.0]:
		var z := z1 - 4.0
		var i := 0
		while z > z0 + 20.0:
			var w := rng.randf_range(12.0, 20.0)
			var depth := rng.randf_range(12.0, 18.0)
			var k: Array = kinds[rng.randi() % kinds.size()]
			var floors := rng.randi_range(2, 7) if absf(z) < 80.0 else rng.randi_range(4, 11)
			var rect := Rect2(Vector2(10.0 if sx > 0 else -10.0 - depth, z - w), Vector2(depth, w))
			var b := {"id": i, "type": k[0], "rect": rect, "floors": floors, "fh": 3.0, "gfh": 3.6 if k[1] == Assets.WM_SHOP else 3.0,
				"roof": "flat", "facing": 3 if sx > 0 else 1, "enterable": false, "layer": k[2], "roof_layer": Assets.L_CONCRETE,
				"tint": tints[rng.randi() % tints.size()], "wmode": k[1], "seed": 4100 + i * 37 + int(sx * 11.0),
				"name": "", "poi": "", "district": "centro", "base": 0.15, "interior": k[0]}
			BuildingGen.build(b, shell, detail, 0, false, 2)
			z -= w + rng.randf_range(0.0, 2.5)
			i += 1
	var mi := MeshInstance3D.new()
	mi.mesh = shell.to_mesh(Assets.world_material("exterior"))
	vp.add_child(mi)
	var md := MeshInstance3D.new()
	md.mesh = detail.to_mesh(Assets.world_material("exterior"))
	vp.add_child(md)


## Entulho da rua: barreira, carro queimado, lixo, caixas, pneus, barris.
func _props() -> void:
	var placed := [["concrete_barrier", Vector3(-2.6, 0, -14.0), 12.0], ["concrete_barrier", Vector3(0.2, 0, -15.0), -8.0],
		["trash_bags", Vector3(6.6, 0.15, -6.0), 30.0], ["cardboard", Vector3(6.9, 0.15, -9.0), 70.0],
		["tire_single", Vector3(-4.4, 0, -4.5), 0.0], ["barrel", Vector3(-6.4, 0.15, -22.0), 0.0],
		["barrel", Vector3(-6.9, 0.15, -21.2), 40.0], ["trash_bin", Vector3(6.4, 0.15, -18.0), 0.0],
		["plastic_crate", Vector3(4.6, 0, -2.0), 25.0], ["jerrycan", Vector3(3.9, 0, -2.4), 80.0],
		["hydrant", Vector3(6.3, 0.15, -30.0), 0.0], ["concrete_barrier", Vector3(-1.0, 0, -48.0), 3.0]]
	for p in placed:
		var pm := PropLib.mesh(str(p[0]))
		if pm == null:
			continue
		var mi := MeshInstance3D.new()
		mi.mesh = pm
		mi.position = p[1]
		mi.rotation.y = deg_to_rad(float(p[2]))
		vp.add_child(mi)
	# carros abandonados (um queimado, ainda fumegando)
	for c in [[Vector3(-3.2, 0, -9.0), 0.25, "sedan", "wreck", Color(0.35, 0.4, 0.46)],
			[Vector3(3.4, 0, -27.0), -2.9, "hatch", "burned", Color(0.2, 0.2, 0.2)],
			[Vector3(-2.8, 0, -36.0), 0.05, "suv", "dusty", Color(0.62, 0.6, 0.55)]]:
		var cmi := MeshInstance3D.new()
		cmi.mesh = VehicleMeshBuilder.mesh(str(c[2]), c[3] == "burned", true, str(c[3]))
		var pm := (cmi.mesh.surface_get_material(0) as ShaderMaterial)
		if pm:
			pm = pm.duplicate() as ShaderMaterial
			pm.set_shader_parameter("paint_color", c[4])
			cmi.set_surface_override_material(0, pm)
		cmi.position = c[0]
		cmi.rotation.y = float(c[1])
		vp.add_child(cmi)
		if c[3] == "burned":
			vp.add_child(Chunk._smoke_emitter((c[0] as Vector3) + Vector3(0, 1.0, 0), 18, 1.6, Color(0.16, 0.16, 0.16, 0.85), 0.6, 1.0))


## Cidade queimando no fim da avenida: torres escuras, focos de incêndio com luz
## que tremula e colunas de fumaça.
func _skyline() -> void:
	var shell := MeshBuf.new()
	var detail := MeshBuf.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 14:
		var x := rng.randf_range(-120.0, 120.0)
		var z := rng.randf_range(-330.0, -260.0)
		var w := rng.randf_range(16.0, 30.0)
		var floors := rng.randi_range(10, 26)
		var b := {"id": 900 + i, "type": "tower", "rect": Rect2(Vector2(x - w * 0.5, z - w * 0.5), Vector2(w, w)), "floors": floors,
			"fh": 3.2, "gfh": 3.6, "roof": "flat", "facing": 2, "enterable": false, "layer": Assets.L_PANELS if i % 2 == 0 else Assets.L_PLASTER,
			"roof_layer": Assets.L_CONCRETE, "tint": Color(0.62, 0.62, 0.64), "wmode": Assets.WM_OFFICE, "seed": 9000 + i * 17,
			"name": "", "poi": "", "district": "centro", "base": 0.0, "interior": "tower"}
		BuildingGen.build(b, shell, detail, 1, false, 0)
	var mi := MeshInstance3D.new()
	mi.mesh = shell.to_mesh(Assets.world_material("exterior"))
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	vp.add_child(mi)
	for f in [Vector3(-38, 14, -250), Vector3(22, 30, -270), Vector3(70, 8, -240), Vector3(-6, 4, -170), Vector3(-90, 22, -280)]:
		var l := OmniLight3D.new()
		l.position = f
		l.light_color = Color(1.0, 0.45, 0.16)
		l.omni_range = 70.0
		l.omni_attenuation = 1.2
		l.light_energy = 6.0
		l.light_volumetric_fog_energy = 3.0
		vp.add_child(l)
		_fires.append(l)
		_fire_e.append(rng.randf() * 10.0)
		var sm := Chunk._smoke_emitter(f + Vector3(0, 2, 0), 26, 14.0, Color(0.1, 0.09, 0.09, 0.9), 3.0, 5.0)
		sm.visibility_aabb = AABB(Vector3(-60, -10, -60), Vector3(120, 140, 120))
		sm.lifetime = 14.0
		sm.preprocess = 14.0
		vp.add_child(sm)
	# brasas subindo perto da câmera
	var em := GPUParticles3D.new()
	em.amount = 70
	em.lifetime = 6.0
	em.preprocess = 6.0
	em.position = Vector3(0, 0.5, -8)
	em.visibility_aabb = AABB(Vector3(-20, -2, -20), Vector3(40, 20, 40))
	var q := QuadMesh.new()
	q.size = Vector2(0.035, 0.035)
	var qm := StandardMaterial3D.new()
	# ponto redondo e macio (não quadrado)
	var gt2 := GradientTexture2D.new()
	gt2.fill = GradientTexture2D.FILL_RADIAL
	gt2.fill_from = Vector2(0.5, 0.5)
	gt2.fill_to = Vector2(1.0, 0.5)
	var g2 := Gradient.new()
	g2.set_color(0, Color(1, 1, 1, 1))
	g2.set_color(1, Color(1, 1, 1, 0))
	gt2.gradient = g2
	gt2.width = 32
	gt2.height = 32
	qm.albedo_texture = gt2
	qm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	qm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	qm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	qm.albedo_color = Color(1.0, 0.55, 0.2)
	qm.emission_enabled = true
	qm.emission = Color(1.0, 0.45, 0.12)
	qm.emission_energy_multiplier = 4.0
	q.material = qm
	em.draw_pass_1 = q
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(12, 1, 14)
	pm.direction = Vector3(0.2, 1, 0)
	pm.spread = 25.0
	pm.initial_velocity_min = 0.4
	pm.initial_velocity_max = 1.1
	pm.gravity = Vector3(0.3, 0.12, 0.0)
	pm.turbulence_enabled = true
	pm.turbulence_noise_strength = 0.6
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 0))
	g.add_point(0.15, Color(1, 1, 1, 1))
	g.set_color(g.get_point_count() - 1, Color(1, 1, 1, 0))
	var gt := GradientTexture1D.new()
	gt.gradient = g
	pm.color_ramp = gt
	em.process_material = pm
	vp.add_child(em)


## Tambor com fogo ao lado do Caio: luz quente que tremula no rosto e no asfalto.
func _fire_barrel(pos: Vector3) -> void:
	var bm := PropLib.mesh("barrel")
	if bm:
		var mi := MeshInstance3D.new()
		mi.mesh = bm
		mi.position = pos
		vp.add_child(mi)
	var top := pos + Vector3(0, 0.95, 0)
	var l := OmniLight3D.new()
	l.position = top + Vector3(0, 0.5, 0)
	l.light_color = Color(1.0, 0.52, 0.2)
	l.omni_range = 9.0
	l.light_energy = 2.6
	l.shadow_enabled = true
	vp.add_child(l)
	_fires.append(l)
	_fire_e.append(3.3)
	var fl := GPUParticles3D.new()
	fl.amount = 40
	fl.lifetime = 0.9
	fl.position = top
	fl.visibility_aabb = AABB(Vector3(-1, -0.5, -1), Vector3(2, 3, 2))
	var q := QuadMesh.new()
	q.size = Vector2(0.32, 0.42)
	var qm := StandardMaterial3D.new()
	qm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	qm.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	qm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	qm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	qm.vertex_color_use_as_albedo = true
	var gt2 := GradientTexture2D.new()
	gt2.fill = GradientTexture2D.FILL_RADIAL
	gt2.fill_from = Vector2(0.5, 0.55)
	gt2.fill_to = Vector2(1.0, 0.55)
	var g2 := Gradient.new()
	g2.set_color(0, Color(1, 1, 1, 1))
	g2.set_color(1, Color(1, 1, 1, 0))
	gt2.gradient = g2
	qm.albedo_texture = gt2
	q.material = qm
	fl.draw_pass_1 = q
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = 0.18
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 10.0
	pm.initial_velocity_min = 0.6
	pm.initial_velocity_max = 1.1
	pm.gravity = Vector3(0, 0.6, 0)
	pm.scale_min = 0.6
	pm.scale_max = 1.2
	var g := Gradient.new()
	g.set_color(0, Color(1.0, 0.85, 0.45, 0.9))
	g.add_point(0.4, Color(1.0, 0.45, 0.12, 0.7))
	g.set_color(g.get_point_count() - 1, Color(0.4, 0.1, 0.02, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = g
	pm.color_ramp = gt
	fl.process_material = pm
	vp.add_child(fl)
	vp.add_child(Chunk._smoke_emitter(top + Vector3(0, 0.6, 0), 12, 1.2, Color(0.12, 0.11, 0.1, 0.7), 0.7, 1.2))


func _caio() -> void:
	_fire_barrel(Vector3(3.6, 0.0, -2.6))
	body = HumanoidBody.new()
	vp.add_child(body)
	body.setup(Appearance.caio(), 0)
	body.position = Vector3(1.75, 0.0, -0.4)
	body.rotation.y = deg_to_rad(14.0)
	body.anim_interval = 0.0
	body.tick(0.016)


func _process(delta: float) -> void:
	_t += delta
	if body:
		body.tick(delta)
	for i in _fires.size():
		var ph := _fire_e[i] + _t
		var base_e := 2.6 if _fires[i].omni_range < 20.0 else 5.0
		_fires[i].light_energy = base_e * (1.0 + sin(ph * 7.3) * 0.18 + sin(ph * 13.1 + 1.7) * 0.12 + sin(ph * 2.1) * 0.24)
	_update_cam()


func _update_cam() -> void:
	if cam == null:
		return
	# respiração lenta da câmera na mão e um travelling quase imperceptível
	var drift := Vector3(sin(_t * 0.11) * 0.35, sin(_t * 0.23) * 0.06 + sin(_t * 0.9) * 0.01, sin(_t * 0.07) * 0.25)
	cam.position = _cam_base + drift
	cam.look_at(_look + Vector3(sin(_t * 0.13) * 0.6, 0, 0), Vector3.UP)
