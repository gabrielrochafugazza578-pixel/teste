class_name MenuScene
extends SubViewportContainer
## Fundo 3D do menu principal: um apartamento abandonado no quarto andar, no fim
## da tarde. O sol baixo entra pela janela quebrada em feixes (neblina
## volumétrica no Forward+), a poeira brilha dentro da luz, a cortina rasgada
## balança com o vento e lá fora a cidade queima. O Caio está sentado no chão,
## encostado na parede, olhando pela janela. A câmera respira devagar.
## Tudo montado aqui com os materiais e modelos do jogo, sem vídeo.

const W := 5.4          # largura do cômodo (x de -W/2 a W/2)
const D := 5.6          # profundidade (a parede da janela fica em z = -D)
const H := 2.8
const WIN_X := Vector2(-0.95, 1.45)
const WIN_Y := Vector2(0.88, 2.42)
const STREET_Y := -13.0  # a rua lá embaixo (quarto andar)

const CURTAIN_SHADER := """
shader_type spatial;
render_mode cull_disabled, diffuse_burley, specular_schlick_ggx;
uniform vec3 color : source_color = vec3(0.6, 0.53, 0.43);
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform float height = 1.8;
varying float v_low;
void vertex() {
	// 0 no varão, 1 na barra: o pano solto balança mais embaixo
	float low = clamp(0.5 - VERTEX.y / height, 0.0, 1.0);
	float t = TIME;
	float gust = 0.55 + 0.45 * sin(t * 0.37) * sin(t * 0.23 + 1.3);
	float w = sin(t * 1.3 + VERTEX.x * 2.1 + VERTEX.y * 1.4) * 0.5 + sin(t * 2.3 + VERTEX.y * 3.1) * 0.25;
	VERTEX.z += (0.1 + w * 0.07) * gust * low * low + sin(VERTEX.x * 17.0) * 0.022 * (1.0 - low * 0.4);
	VERTEX.x += sin(t * 0.9 + VERTEX.y * 2.0) * 0.035 * gust * low;
	v_low = low;
}
void fragment() {
	float n = texture(noise_tex, UV * vec2(2.7, 0.9)).g;
	float n2 = texture(noise_tex, UV * vec2(5.0, 7.0) + 0.3).r;
	// barra esfarrapada e alguns rasgos (o ruído fica em ~0,32 ± 0,09 no R)
	if (UV.y > 0.86 + (n - 0.47) * 0.5 || n2 > 0.5) {
		discard;
	}
	vec3 c = color * (0.8 + n * 0.4);
	c *= mix(1.0, 0.6, smoothstep(0.55, 1.0, UV.y));
	vec3 nrm = normalize(cross(dFdy(VERTEX), dFdx(VERTEX)));
	NORMAL = FRONT_FACING ? nrm : -nrm;
	ALBEDO = c;
	ROUGHNESS = 0.95;
	// o sol atravessa o tecido fino
	BACKLIGHT = c * 0.75;
}
"""

var vp: SubViewport
var cam: Camera3D
var body: HumanoidBody
var _t: float = 0.0
var _fires: Array[OmniLight3D] = []
var _fire_e: Array[float] = []
var _cam_base := Vector3(-1.05, 1.18, 0.35)
var _look := Vector3(1.05, 1.3, -3.4)
var _fp := false


func _ready() -> void:
	stretch = true
	UIKit.full_rect(self)
	_fp = Settings.is_forward_plus()
	vp = SubViewport.new()
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_4X if _fp else Viewport.MSAA_2X
	vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	if _fp:
		vp.use_taa = true
	add_child(vp)
	ShaderGlobals.set_value("daylight", 0.5)
	ShaderGlobals.set_value("wetness", 0.0)
	ShaderGlobals.set_value("rain_intensity", 0.0)
	ShaderGlobals.set_value("world_decay", 1.0)
	ShaderGlobals.set_value("city_power", 0.0)
	ShaderGlobals.set_value("sun_strength", 0.0)
	ShaderGlobals.set_value("ssao_active", 1.0 if _fp else 0.0)
	RenderingServer.global_shader_parameter_set("wind", Vector4(1.0, 0.0, 0.35, 0.3))
	_environment()
	_room()
	_window()
	_furniture()
	_outside()
	_dust()
	if not _fp:
		_fake_shaft()
	_caio()
	cam = Camera3D.new()
	cam.fov = 50.0
	cam.near = 0.03
	cam.far = 1200.0
	var ca := CameraAttributesPractical.new()
	# foco no Caio: o fundo da janela e a cidade lá fora desfocam de leve
	ca.dof_blur_far_enabled = true
	ca.dof_blur_far_distance = 7.5
	ca.dof_blur_far_transition = 12.0
	ca.dof_blur_near_enabled = true
	ca.dof_blur_near_distance = 0.6
	ca.dof_blur_near_transition = 0.5
	ca.dof_blur_amount = 0.06
	cam.attributes = ca
	vp.add_child(cam)
	_update_cam()


func _environment() -> void:
	var env := Environment.new()
	var sky := Sky.new()
	var sm := ProceduralSkyMaterial.new()
	sm.sky_top_color = Color(0.2, 0.2, 0.27)
	sm.sky_horizon_color = Color(0.98, 0.55, 0.28)
	sm.sky_curve = 0.09
	sm.ground_horizon_color = Color(0.55, 0.32, 0.2)
	sm.ground_bottom_color = Color(0.08, 0.06, 0.05)
	sm.sun_angle_max = 24.0
	sm.sun_curve = 0.06
	sm.sky_energy_multiplier = 1.3
	sky.sky_material = sm
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	# dentro do cômodo quase toda a luz é a do sol que entra e a que rebate:
	# o céu ilumina pouco
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 0.2 if _fp else 0.55
	env.ambient_light_sky_contribution = 0.6
	env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	env.tonemap_mode = Environment.TONE_MAPPER_AGX if _fp else Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.0
	env.glow_enabled = true
	env.glow_intensity = 0.65
	env.glow_bloom = 0.1
	env.glow_hdr_threshold = 1.0
	env.fog_enabled = true
	env.fog_light_color = Color(0.62, 0.42, 0.3)
	env.fog_density = 0.004
	env.fog_sun_scatter = 0.3
	env.fog_aerial_perspective = 0.5
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.92
	env.adjustment_contrast = 1.06
	var dbg := OS.get_cmdline_user_args()
	if _fp:
		env.ssao_enabled = not "--menu-sem-ssao" in dbg
		env.ssao_radius = 0.9
		env.ssao_intensity = 2.0
		env.ssao_detail = 0.8
		env.ssil_enabled = true
		env.ssil_radius = 3.0
		env.ssil_intensity = 1.2
		env.ssr_enabled = true
		env.ssr_max_steps = 64
		env.sdfgi_enabled = not "--menu-sem-gi" in dbg and int(Settings.graphics.get("gi_quality", 0)) > 0
		env.sdfgi_use_occlusion = true
		env.sdfgi_min_cell_size = 0.08
		env.sdfgi_cascades = 4
		env.sdfgi_energy = 0.75
		env.sdfgi_bounce_feedback = 0.6
		env.volumetric_fog_enabled = not "--menu-sem-vol" in dbg
		env.volumetric_fog_density = 0.0012
		env.volumetric_fog_albedo = Color(0.85, 0.75, 0.66)
		env.volumetric_fog_anisotropy = 0.6
		# só o cômodo: grade fina perto da câmera (feixes nítidos)
		env.volumetric_fog_length = 14.0
		env.volumetric_fog_detail_spread = 1.6
		env.volumetric_fog_ambient_inject = 0.0
		# a luz indireta (SDFGI) acenderia a poeira do cômodo inteiro por igual
		# e os feixes sumiriam: só o sol direto acende a neblina
		env.volumetric_fog_gi_inject = 0.0
		env.fog_density = 0.0015
		env.tonemap_exposure = 1.3
		# poeira suspensa no cômodo: os feixes de sol ficam visíveis
		var fv := FogVolume.new()
		fv.size = Vector3(W, H, D + 0.3)
		fv.position = Vector3(0, H * 0.5, -D * 0.5)
		var fm := FogMaterial.new()
		fm.density = 0.06
		fm.albedo = Color(0.9, 0.82, 0.72)
		fm.edge_fade = 0.05
		fv.material = fm
		vp.add_child(fv)
		# grade da neblina mais fina (feixes com borda): só no menu, que é leve
		RenderingServer.environment_set_volumetric_fog_volume_size(144, 96)
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	# sol baixo atrás da cidade: entra pela janela, desenha o vão no chão e
	# alcança as pernas do Caio
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-21.0, 196.0, 0.0)
	sun.light_color = Color(1.0, 0.6, 0.33)
	sun.light_energy = 4.5
	sun.shadow_enabled = not "--menu-sem-sombra" in dbg
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
	sun.directional_shadow_max_distance = 40.0
	sun.shadow_bias = 0.03
	sun.shadow_normal_bias = 1.2
	sun.shadow_blur = 1.4
	sun.light_volumetric_fog_energy = 3.5
	sun.light_angular_distance = 0.6
	vp.add_child(sun)
	# luz que rebate do chão iluminado (quente, sem sombra) e um resto de céu
	# frio pela porta do corredor
	var bounce := OmniLight3D.new()
	bounce.position = Vector3(0.9, 0.35, -2.4)
	bounce.light_color = Color(1.0, 0.68, 0.45)
	bounce.light_energy = 0.3 if _fp else 0.9
	bounce.omni_range = 5.5
	bounce.omni_attenuation = 1.4
	bounce.light_volumetric_fog_energy = 0.0
	bounce.light_specular = 0.1
	vp.add_child(bounce)
	var cool := OmniLight3D.new()
	cool.position = Vector3(-2.2, 1.6, 0.6)
	cool.light_color = Color(0.5, 0.6, 0.8)
	cool.light_energy = 0.25
	cool.omni_range = 4.5
	cool.light_volumetric_fog_energy = 0.0
	cool.light_specular = 0.05
	vp.add_child(cool)


## Cômodo: piso de tábuas, paredes de reboco (com o papel de parede velho e os
## buracos do material "interior"), teto, vão da porta para o corredor escuro.
func _room() -> void:
	var b := MeshBuf.new()
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var PLA := Assets.uv2_code(Assets.L_PLASTER)
	var wall_c := Color(0.8, 0.74, 0.62)
	var hw := W * 0.5
	var zf := 1.4
	b.quad(Vector3(-hw, 0, -D), Vector3(hw, 0, -D), Vector3(hw, 0, zf), Vector3(-hw, 0, zf), Vector3.UP,
		Vector2(-hw, -D), Vector2(hw, -D), Vector2(hw, zf), Vector2(-hw, zf), WOOD, 0.37, Color(0.82, 0.7, 0.58))
	b.quad(Vector3(-hw, H, zf), Vector3(hw, H, zf), Vector3(hw, H, -D), Vector3(-hw, H, -D), Vector3.DOWN,
		Vector2(-hw, zf), Vector2(hw, zf), Vector2(hw, -D), Vector2(-hw, -D), PLA, 0.51, Color(0.72, 0.7, 0.66))
	# parede da janela (vista de dentro)
	b.wall_with_holes(Vector2(-hw, -D), Vector2(hw, -D), 0.0, H, Vector3.BACK,
		[[WIN_X.x + hw, WIN_X.y + hw, WIN_Y.x, WIN_Y.y]], PLA, 0.03, wall_c)
	# lado de fora da mesma parede e a espessura do vão (reboco)
	b.wall_with_holes(Vector2(hw, -D - 0.24), Vector2(-hw, -D - 0.24), 0.0, H, Vector3.FORWARD,
		[[hw - WIN_X.y, hw - WIN_X.x, WIN_Y.x, WIN_Y.y]], PLA, 0.6, Color(0.6, 0.58, 0.55))
	b.box(Vector3((WIN_X.x + WIN_X.y) * 0.5, WIN_Y.y + 0.01, -D - 0.12), Vector3(WIN_X.y - WIN_X.x, 0.02, 0.24), PLA, 0.03, wall_c, 8)
	for x: float in [WIN_X.x - 0.01, WIN_X.y + 0.01]:
		b.box(Vector3(x, (WIN_Y.x + WIN_Y.y) * 0.5, -D - 0.12), Vector3(0.02, WIN_Y.y - WIN_Y.x, 0.24), PLA, 0.03, wall_c, 3)
	# parede esquerda com a porta para o corredor (escuro, dá profundidade)
	b.wall_with_holes(Vector2(-hw, 1.4), Vector2(-hw, -D), 0.0, H, Vector3.RIGHT, [[2.3, 3.25, 0.0, 2.1]], PLA, 0.03, wall_c)
	# corredor atrás da porta
	b.wall(Vector2(-hw - 1.5, 0.0), Vector2(-hw - 1.5, -3.0), 0.0, H, Vector3.RIGHT, PLA, 0.4, Color(0.55, 0.52, 0.48))
	b.wall(Vector2(-hw - 1.5, -3.0), Vector2(-hw, -3.0), 0.0, H, Vector3.BACK, PLA, 0.4, Color(0.55, 0.52, 0.48))
	b.wall(Vector2(-hw, 0.0), Vector2(-hw - 1.5, 0.0), 0.0, H, Vector3.FORWARD, PLA, 0.4, Color(0.55, 0.52, 0.48))
	b.quad(Vector3(-hw - 1.5, 0.002, -3.0), Vector3(-hw, 0.002, -3.0), Vector3(-hw, 0.002, 0.0), Vector3(-hw - 1.5, 0.002, 0.0), Vector3.UP,
		Vector2(0, -3), Vector2(1.5, -3), Vector2(1.5, 0), Vector2(0, 0), WOOD, 0.2, Color(0.6, 0.5, 0.42))
	b.quad(Vector3(-hw - 1.5, H, 0.0), Vector3(-hw, H, 0.0), Vector3(-hw, H, -3.0), Vector3(-hw - 1.5, H, -3.0), Vector3.DOWN,
		Vector2(0, 0), Vector2(1.5, 0), Vector2(1.5, -3), Vector2(0, -3), PLA, 0.2, Color(0.5, 0.5, 0.48))
	# parede direita e a de trás da câmera
	b.wall(Vector2(hw, -D), Vector2(hw, zf), 0.0, H, Vector3.LEFT, PLA, 0.03, wall_c)
	b.wall(Vector2(hw, zf), Vector2(-hw, zf), 0.0, H, Vector3.FORWARD, PLA, 0.03, wall_c)
	# laje por cima do teto (sem fresta de luz entre o teto e as paredes)
	b.box(Vector3(0, H + 0.15, -D * 0.5 + 0.1), Vector3(W + 0.6, 0.3, D + 3.0), PLA, 0.1, Color(0.5, 0.5, 0.5))
	# rodapé de madeira
	b.box(Vector3(hw - 0.01, 0.06, -D * 0.5 + zf * 0.5), Vector3(0.02, 0.12, D + zf), WOOD, 0.5, Color(0.5, 0.38, 0.28), 2)
	b.box(Vector3(0, 0.06, -D + 0.01), Vector3(W, 0.12, 0.02), WOOD, 0.5, Color(0.5, 0.38, 0.28), 16)
	# papéis, cacos e poeira no chão (folhas finas um pouco acima das tábuas)
	var r := RandomNumberGenerator.new()
	r.seed = 77
	for i in 26:
		var p := Vector3(r.randf_range(-2.3, 2.3), 0.0, r.randf_range(-5.2, -0.6))
		var sz := Vector2(r.randf_range(0.15, 0.3), r.randf_range(0.2, 0.32))
		var xf := Transform3D(Basis(Vector3.UP, r.randf() * TAU), p + Vector3(0, 0.003 + i * 0.0002, 0))
		b.box_xf(xf, Vector3(sz.x, 0.002, sz.y), Assets.uv2_code(Assets.L_FABRIC), 0.8, Color(0.85, 0.82, 0.74).darkened(r.randf() * 0.3), 4)
	var mi := MeshInstance3D.new()
	mi.mesh = b.to_mesh(Assets.world_material("interior"))
	# paredes e teto têm uma face só: sem isso o sol atravessaria o teto pelo
	# lado de fora (a sombra só sai da face da frente)
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
	vp.add_child(mi)


## Janela: caixilho de madeira quebrado, um resto de vidro sujo, varão e cortina
## rasgada que o vento empurra para dentro.
func _window() -> void:
	var b := MeshBuf.new()
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var fc := Color(0.55, 0.45, 0.36)
	var cx := (WIN_X.x + WIN_X.y) * 0.5
	var z := -D - 0.08
	var ww := WIN_X.y - WIN_X.x
	var wh := WIN_Y.y - WIN_Y.x
	b.box(Vector3(cx, WIN_Y.x - 0.02, z + 0.04), Vector3(ww + 0.16, 0.05, 0.34), WOOD, 0.3, fc)
	b.box(Vector3(cx, WIN_Y.y - 0.03, z), Vector3(ww, 0.06, 0.07), WOOD, 0.3, fc)
	for x: float in [WIN_X.x + 0.03, WIN_X.y - 0.03]:
		b.box(Vector3(x, (WIN_Y.x + WIN_Y.y) * 0.5, z), Vector3(0.06, wh, 0.07), WOOD, 0.3, fc)
	# folha da janela aberta, torta, com o caixilho no meio
	var leaf := Transform3D(Basis(Vector3.UP, deg_to_rad(-38.0)), Vector3(WIN_X.y - 0.02, WIN_Y.x + wh * 0.5, z + 0.02))
	for k in 4:
		var e: Vector3 = [Vector3(0.0, wh * 0.5 - 0.03, 0), Vector3(0.0, -wh * 0.5 + 0.03, 0), Vector3(-0.03, 0, 0), Vector3(-ww * 0.45, 0, 0)][k]
		var s: Vector3 = [Vector3(ww * 0.46, 0.05, 0.05), Vector3(ww * 0.46, 0.05, 0.05), Vector3(0.05, wh, 0.05), Vector3(0.05, wh, 0.05)][k]
		var off := Vector3(-ww * 0.23, 0, 0) if k < 2 else Vector3.ZERO
		b.box_xf(leaf * Transform3D(Basis(), e + off), s, WOOD, 0.3, fc)
	# tábuas pregadas por fora do vão (alguém tentou fechar a janela): a luz do
	# sol entra só pelas frestas e vira feixes na poeira
	var r := RandomNumberGenerator.new()
	r.seed = 1312
	var boards := [[WIN_Y.x + 0.2, 4.0, 0.15], [WIN_Y.x + 0.62, -3.0, 0.13], [WIN_Y.x + 1.02, 2.5, 0.14], [WIN_Y.x + 1.4, -5.0, 0.12]]
	for bd in boards:
		var y: float = bd[0]
		var ang := deg_to_rad(float(bd[1]))
		var bw: float = bd[2]
		var xf := Transform3D(Basis(Vector3.FORWARD, ang), Vector3(cx + r.randf_range(-0.05, 0.05), y, -D - 0.27))
		b.box_xf(xf, Vector3(ww + 0.35, bw, 0.025), WOOD, r.randf(), Color(0.6, 0.5, 0.4).darkened(r.randf() * 0.25))
		# pregos
		for sx: float in [-1.0, 1.0]:
			b.box_xf(xf * Transform3D(Basis(), Vector3(sx * (ww * 0.5 + 0.1), 0, 0.016)), Vector3(0.012, 0.012, 0.01),
				Assets.uv2_code(Assets.L_METAL), 0.5, Color(0.3, 0.28, 0.26))
	# varão
	b.tube(Vector3(WIN_X.x - 0.3, WIN_Y.y + 0.14, -D + 0.1), Vector3(WIN_X.y + 0.3, WIN_Y.y + 0.14, -D + 0.1), 0.012, 0.012, 6,
		Assets.uv2_code(Assets.L_METAL), 0.2, Color(0.4, 0.38, 0.36))
	var mi := MeshInstance3D.new()
	mi.mesh = b.to_mesh(Assets.world_material("props_interior"))
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
	vp.add_child(mi)
	# resto de vidro sujo na folha aberta
	var g := MeshInstance3D.new()
	var qm := QuadMesh.new()
	qm.size = Vector2(ww * 0.4, wh * 0.45)
	g.mesh = qm
	var gm := StandardMaterial3D.new()
	gm.albedo_color = Color(0.62, 0.6, 0.55, 0.28)
	gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	gm.roughness = 0.35
	gm.metallic_specular = 0.7
	gm.cull_mode = BaseMaterial3D.CULL_DISABLED
	g.material_override = gm
	g.transform = leaf * Transform3D(Basis(), Vector3(-ww * 0.24, wh * 0.2, 0))
	vp.add_child(g)
	# cortina: um pano de cada lado, o esquerdo rasgado e solto
	var sh := Shader.new()
	sh.code = CURTAIN_SHADER
	for side in 2:
		var cm := MeshInstance3D.new()
		var pm := PlaneMesh.new()
		var cw := 0.95 if side == 0 else 0.6
		var ch := 1.95 if side == 0 else 1.75
		pm.size = Vector2(cw, ch)
		pm.orientation = PlaneMesh.FACE_Z
		pm.subdivide_width = 18
		pm.subdivide_depth = 34
		cm.mesh = pm
		var mat := ShaderMaterial.new()
		mat.shader = sh
		mat.set_shader_parameter("noise_tex", Assets.noise_tex)
		mat.set_shader_parameter("height", ch)
		mat.set_shader_parameter("color", Color(0.62, 0.55, 0.44) if side == 0 else Color(0.5, 0.48, 0.42))
		cm.material_override = mat
		var x := WIN_X.x + 0.25 if side == 0 else WIN_X.y + 0.05
		cm.position = Vector3(x, WIN_Y.y + 0.13 - ch * 0.5, -D + 0.14)
		cm.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		vp.add_child(cm)


## Móveis largados (modelos escaneados do jogo): colchão no chão, poltrona
## virada, estante, cadeira caída, caixas.
func _furniture() -> void:
	var items := [["armchair", Vector3(-1.75, 0, -4.55), 160.0, Vector3.ZERO], ["bookshelf", Vector3(-2.48, 0, -4.2), 90.0, Vector3.ZERO],
		["chair", Vector3(-0.6, 0.22, -3.3), 25.0, Vector3(0, 0, 90)], ["table_small", Vector3(2.15, 0, -4.9), 10.0, Vector3.ZERO],
		["cardboard", Vector3(-1.9, 0, -0.9), 30.0, Vector3.ZERO], ["cardboard", Vector3(-2.15, 0.0, -0.4), -10.0, Vector3.ZERO],
		["plastic_crate", Vector3(1.55, 0, -0.75), 15.0, Vector3.ZERO], ["jerrycan", Vector3(2.2, 0, -0.8), 70.0, Vector3.ZERO],
		["plant_pot", Vector3(1.0, 0, -5.25), 0.0, Vector3.ZERO]]
	for it in items:
		var m := PropLib.mesh(str(it[0]))
		if m == null:
			continue
		var mi := MeshInstance3D.new()
		mi.mesh = m
		mi.position = it[1]
		mi.rotation_degrees = Vector3((it[3] as Vector3).x, float(it[2]), (it[3] as Vector3).z)
		vp.add_child(mi)
	# colchão velho encostado na parede direita
	var b := MeshBuf.new()
	b.box(Vector3(2.12, 0.06, -3.75), Vector3(0.92, 0.12, 1.9), Assets.uv2_code(Assets.L_FABRIC), 0.7, Color(0.5, 0.46, 0.38))
	b.box_xf(Transform3D(Basis(Vector3.UP, 0.25), Vector3(2.05, 0.135, -3.4)), Vector3(0.8, 0.03, 1.0), Assets.uv2_code(Assets.L_FABRIC), 0.2, Color(0.3, 0.33, 0.36))
	b.box(Vector3(2.2, 0.16, -4.45), Vector3(0.55, 0.08, 0.36), Assets.uv2_code(Assets.L_FABRIC), 0.3, Color(0.66, 0.62, 0.56))
	var mi2 := MeshInstance3D.new()
	mi2.mesh = b.to_mesh(Assets.world_material("props_interior"))
	vp.add_child(mi2)


## Lá fora: prédios do outro lado da rua (quatro andares abaixo) e a cidade
## queimando no horizonte, com focos de fogo e colunas de fumaça.
func _outside() -> void:
	var near := MeshBuf.new()
	var near_d := MeshBuf.new()
	var r := RandomNumberGenerator.new()
	r.seed = 404
	var kinds := [["apartment", Assets.WM_RES, Assets.L_PLASTER], ["apartment", Assets.WM_RES, Assets.L_BRICK], ["office", Assets.WM_OFFICE, Assets.L_PANELS]]
	var x := -36.0
	var i := 0
	while x < 40.0:
		var w := r.randf_range(12.0, 18.0)
		var k: Array = kinds[r.randi() % kinds.size()]
		var b := {"id": 700 + i, "type": k[0], "rect": Rect2(Vector2(x, -D - 38.0 - r.randf_range(0.0, 6.0)), Vector2(w, 14.0)),
			"floors": r.randi_range(2, 3), "fh": 3.0, "gfh": 3.4, "roof": "flat", "facing": 0, "enterable": false, "layer": k[2],
			"roof_layer": Assets.L_CONCRETE, "tint": Color(0.8, 0.76, 0.7), "wmode": k[1], "seed": 5200 + i * 31,
			"name": "", "poi": "", "district": "centro", "base": 0.15, "interior": k[0]}
		BuildingGen.build(b, near, near_d, 0, false, 2)
		x += w + r.randf_range(1.0, 4.0)
		i += 1
	var far := MeshBuf.new()
	var far_d := MeshBuf.new()
	for j in 22:
		var fx := r.randf_range(-260.0, 260.0)
		var fz := r.randf_range(-420.0, -160.0)
		var fw := r.randf_range(18.0, 34.0)
		var b := {"id": 900 + j, "type": "tower", "rect": Rect2(Vector2(fx - fw * 0.5, fz - fw * 0.5), Vector2(fw, fw)),
			"floors": r.randi_range(8, 28), "fh": 3.2, "gfh": 3.6, "roof": "flat", "facing": 0, "enterable": false,
			"layer": Assets.L_PANELS if j % 2 == 0 else Assets.L_PLASTER, "roof_layer": Assets.L_CONCRETE, "tint": Color(0.6, 0.6, 0.62),
			"wmode": Assets.WM_OFFICE, "seed": 9100 + j * 17, "name": "", "poi": "", "district": "centro", "base": 0.0, "interior": "tower"}
		BuildingGen.build(b, far, far_d, 1, false, 0)
	for m in [near, near_d, far]:
		var mi := MeshInstance3D.new()
		mi.mesh = (m as MeshBuf).to_mesh(Assets.world_material("exterior"))
		mi.position.y = STREET_Y
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		vp.add_child(mi)
	# rua lá embaixo
	var st := MeshBuf.new()
	st.quad(Vector3(-80, 0, -D - 36), Vector3(80, 0, -D - 36), Vector3(80, 0, -D), Vector3(-80, 0, -D), Vector3.UP,
		Vector2(-80, -D - 36), Vector2(80, -D - 36), Vector2(80, -D), Vector2(-80, -D), Assets.uv2_code(Assets.L_ASPHALT), 0.3, Color(0.85, 0.85, 0.85))
	var smi := MeshInstance3D.new()
	smi.mesh = st.to_mesh(Assets.world_material("exterior"))
	smi.position.y = STREET_Y
	vp.add_child(smi)
	for f in [Vector3(-60, 18, -260), Vector3(35, 32, -300), Vector3(110, 10, -230), Vector3(-15, 6, -170), Vector3(-140, 26, -330)]:
		var p: Vector3 = f + Vector3(0, STREET_Y, 0)
		var l := OmniLight3D.new()
		l.position = p
		l.light_color = Color(1.0, 0.45, 0.16)
		l.omni_range = 80.0
		l.omni_attenuation = 1.2
		l.light_energy = 7.0
		l.light_volumetric_fog_energy = 2.0
		vp.add_child(l)
		_fires.append(l)
		_fire_e.append(r.randf() * 10.0)
		var sm := Chunk._smoke_emitter(p + Vector3(0, 2, 0), 26, 16.0, Color(0.12, 0.1, 0.1, 0.9), 3.5, 6.0)
		sm.visibility_aabb = AABB(Vector3(-80, -10, -80), Vector3(160, 180, 160))
		sm.lifetime = 16.0
		sm.preprocess = 16.0
		vp.add_child(sm)


## Compatibility (sem neblina volumétrica): o feixe de sol é um volume aditivo
## da janela até o chão, com bordas suaves e um pouco de poeira passando.
func _fake_shaft() -> void:
	var sh := Shader.new()
	sh.code = """
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform vec3 color : source_color = vec3(1.0, 0.62, 0.32);
void fragment() {
	float edge = pow(sin(UV.x * 3.14159), 3.0);
	float along = smoothstep(0.0, 0.25, UV.y) * smoothstep(1.0, 0.35, UV.y);
	float n = texture(noise_tex, vec2(UV.x * 1.5, UV.y * 0.6 - TIME * 0.01)).g;
	float fres = abs(dot(NORMAL, VIEW));
	ALBEDO = color * edge * along * (0.6 + n * 0.8) * 0.045 * fres * fres;
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("noise_tex", Assets.noise_tex)
	var dir := Basis.from_euler(Vector3(deg_to_rad(-21.0), deg_to_rad(196.0), 0.0)) * Vector3.FORWARD
	var start := Vector3((WIN_X.x + WIN_X.y) * 0.5, (WIN_Y.x + WIN_Y.y) * 0.5, -D)
	var length := 5.5
	for k in 3:
		var q := MeshInstance3D.new()
		var qm := QuadMesh.new()
		qm.size = Vector2(WIN_X.y - WIN_X.x, length)
		q.mesh = qm
		q.material_override = mat
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var y_axis := -dir
		var x_axis := Vector3.RIGHT.rotated(dir, k * PI / 3.0)
		x_axis = (x_axis - y_axis * x_axis.dot(y_axis)).normalized()
		var z_axis := x_axis.cross(y_axis).normalized()
		q.transform = Transform3D(Basis(x_axis, y_axis, z_axis), start + dir * length * 0.5)
		vp.add_child(q)


## Poeira no ar: pontinhos acesos só onde o sol bate (material com luz), à
## deriva bem devagar.
func _dust() -> void:
	var em := GPUParticles3D.new()
	em.amount = 420
	em.lifetime = 14.0
	em.preprocess = 14.0
	em.position = Vector3(0.9, 1.3, -3.2)
	em.visibility_aabb = AABB(Vector3(-4, -2, -4), Vector3(8, 4, 8))
	var q := QuadMesh.new()
	q.size = Vector2(0.012, 0.012)
	var qm := StandardMaterial3D.new()
	var gt := GradientTexture2D.new()
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.5)
	gt.fill_to = Vector2(1.0, 0.5)
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	gt.gradient = g
	gt.width = 32
	gt.height = 32
	qm.albedo_texture = gt
	qm.albedo_color = Color(1.0, 0.95, 0.85, 0.55)
	qm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	qm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	qm.vertex_color_use_as_albedo = true
	q.material = qm
	em.draw_pass_1 = q
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(1.7, 1.1, 2.2)
	pm.direction = Vector3(0.2, 0.3, 0.1)
	pm.spread = 180.0
	pm.initial_velocity_min = 0.005
	pm.initial_velocity_max = 0.03
	pm.gravity = Vector3(0.0, -0.002, 0.0)
	pm.turbulence_enabled = true
	pm.turbulence_noise_strength = 0.08
	pm.turbulence_noise_speed = Vector3(0.02, 0.01, 0.02)
	pm.scale_min = 0.5
	pm.scale_max = 1.4
	var cg := Gradient.new()
	cg.set_color(0, Color(1, 1, 1, 0))
	cg.add_point(0.2, Color(1, 1, 1, 1))
	cg.add_point(0.8, Color(1, 1, 1, 1))
	cg.set_color(cg.get_point_count() - 1, Color(1, 1, 1, 0))
	var ct := GradientTexture1D.new()
	ct.gradient = cg
	pm.color_ramp = ct
	em.process_material = pm
	vp.add_child(em)


func _caio() -> void:
	body = HumanoidBody.new()
	vp.add_child(body)
	body.setup(Appearance.caio(), 0)
	# sentado no chão, de costas (com a mochila) para a parede direita, de frente
	# para o cômodo, a cabeça virada para a janela
	body.position = Vector3(W * 0.5 - 0.55, 0.0, -2.35)
	body.rotation.y = deg_to_rad(90.0)
	body.anim_interval = 0.0
	if body.animator:
		body.animator.play("sit_floor")
	body.tick(0.016)


func _process(delta: float) -> void:
	_t += delta
	if body:
		body.tick(delta)
	for i in _fires.size():
		var ph := _fire_e[i] + _t
		_fires[i].light_energy = 7.0 * (1.0 + sin(ph * 7.3) * 0.15 + sin(ph * 13.1 + 1.7) * 0.1 + sin(ph * 2.1) * 0.22)
	_update_cam()


func _update_cam() -> void:
	if cam == null:
		return
	# câmera na mão, respirando devagar, e um travelling quase imperceptível
	var drift := Vector3(sin(_t * 0.09) * 0.22, sin(_t * 0.21) * 0.04 + sin(_t * 0.83) * 0.008, sin(_t * 0.06) * 0.18)
	cam.position = _cam_base + drift
	cam.look_at(_look + Vector3(sin(_t * 0.11) * 0.12, sin(_t * 0.17) * 0.05, 0), Vector3.UP)
