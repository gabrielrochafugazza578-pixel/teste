class_name EnvironmentController
extends Node3D
## Céu, sol/lua, neblina, luz ambiente e pós-processamento (GL Compatibility).
## Um único DirectionalLight3D faz sol de dia e lua de noite (1 mapa de
## sombras apenas). Tudo é derivado do TimeManager + WeatherManager.

var env: Environment
var world_env: WorldEnvironment
var sun: DirectionalLight3D
var sky_mat: ShaderMaterial
var indoor: float = 0.0
var indoor_target: float = 0.0
var mood_saturation: float = 0.85
var exposure: float = 1.0
## Lanterna do jogador acesa (Game atualiza): ajusta a adaptação ao escuro.
var torch_on: bool = false
var override_fog: float = -1.0
var flash: float = 0.0
var underground: bool = false   # Setor 7: sem sol/céu
var fog_scale: float = 1.0      # cinemática: neblina de distância mais leve
var _last_sq: int = -1


func _ready() -> void:
	sky_mat = Assets.sky_material()
	var sky := Sky.new()
	sky.sky_material = sky_mat
	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_white = 8.0
	env.fog_enabled = true
	env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
	env.fog_sky_affect = 0.65
	env.adjustment_enabled = true
	world_env = WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)
	sun = DirectionalLight3D.new()
	sun.name = "Sun"
	sun.shadow_enabled = true
	sun.directional_shadow_blend_splits = true
	sun.shadow_bias = 0.04
	sun.shadow_normal_bias = 1.4
	sun.light_angular_distance = 0.6
	add_child(sun)
	EventBus.settings_changed.connect(_apply_settings)
	EventBus.lightning_strike.connect(func(_p: Vector3) -> void: flash = 1.0)
	_apply_settings()
	_update(0.0)


func _apply_settings() -> void:
	var sp := Settings.get_shadow_params()
	sun.shadow_enabled = bool(sp["enabled"])
	sun.directional_shadow_max_distance = float(sp["distance"])
	match int(sp["splits"]):
		1: sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
		2: sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
		_: sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
	sun.directional_shadow_split_1 = 0.12
	sun.directional_shadow_split_2 = 0.3
	sun.directional_shadow_split_3 = 0.55
	var pq := Settings.get_post_quality()
	env.glow_enabled = pq >= 1
	env.glow_intensity = 0.55
	env.glow_strength = 1.0
	env.glow_bloom = 0.04 if pq >= 2 else 0.0
	env.glow_hdr_threshold = 1.05
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
	env.set_glow_level(0, 0.0)
	env.set_glow_level(1, 1.0)
	env.set_glow_level(2, 0.8 if pq >= 2 else 0.0)
	env.set_glow_level(3, 0.5 if pq >= 3 else 0.0)
	var rq := Settings.get_reflection_quality()
	if rq <= 0:
		env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	else:
		env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
		env.sky.radiance_size = [Sky.RADIANCE_SIZE_32, Sky.RADIANCE_SIZE_32, Sky.RADIANCE_SIZE_64, Sky.RADIANCE_SIZE_128][clampi(rq, 0, 3)]
		env.sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL if rq < 3 else Sky.PROCESS_MODE_REALTIME
	var cam := get_viewport().get_camera_3d() if is_inside_tree() else null
	if cam:
		cam.far = maxf(Settings.get_view_distance() + 300.0, 3400.0)


func set_indoor(v: bool) -> void:
	indoor_target = 1.0 if v else 0.0


## Prédio com energia (antes do surto ou gerador ligado): luminárias acesas,
## ambiente claro e neutro em vez da penumbra do apagão.
var indoor_lit: float = 0.0
var indoor_lit_target: float = 0.0


func set_indoor_lit(v: bool) -> void:
	indoor_lit_target = 1.0 if v else 0.0


## Iluminação de emergência (cinemática do laboratório): ambiente vermelho
## escuro em todos os cômodos; 0 = desligada.
var emergency: float = 0.0


## Troca imediata (atrás de um corte para preto da cinemática).
func snap_indoor() -> void:
	indoor = indoor_target
	indoor_lit = indoor_lit_target


var _sun_dir := Vector3.ZERO


func _process(delta: float) -> void:
	_update(delta)


func _update(delta: float) -> void:
	indoor = move_toward(indoor, indoor_target, delta * 1.5)
	indoor_lit = move_toward(indoor_lit, indoor_lit_target, delta * 1.5)
	var lit := indoor * indoor_lit
	flash = maxf(0.0, flash - delta * 3.5)
	var wm := WeatherManager
	var dl := TimeManager.daylight()
	var sh := TimeManager.sun_height()
	var sd := TimeManager.sun_direction()
	var dusk := clampf(1.0 - absf(sh) * 3.2, 0.0, 1.0) * smoothstep(-0.25, 0.05, sh)
	var clouds: float = wm.clouds
	var dark: float = wm.darkness
	# --- cores do céu -----------------------------------------------------------
	var zen_day := Color(0.2, 0.38, 0.68)
	var hor_day := Color(0.62, 0.7, 0.78)
	var zen_night := Color(0.02, 0.03, 0.06)
	var hor_night := Color(0.075, 0.095, 0.145)
	var zen := zen_night.lerp(zen_day, dl)
	var hor := hor_night.lerp(hor_day, dl)
	hor = hor.lerp(Color(0.95, 0.52, 0.3), dusk * 0.75)
	zen = zen.lerp(Color(0.35, 0.3, 0.45), dusk * 0.35)
	var grey := Color(0.5, 0.52, 0.55) * (0.25 + dl * 0.75)
	zen = zen.lerp(grey * 0.85, clouds * 0.75)
	hor = hor.lerp(grey, clouds * 0.7)
	zen = zen.darkened(dark * 0.55)
	hor = hor.darkened(dark * 0.45)
	sky_mat.set_shader_parameter("zenith_color", zen)
	sky_mat.set_shader_parameter("horizon_color", hor)
	sky_mat.set_shader_parameter("ground_color", hor.darkened(0.55))
	sky_mat.set_shader_parameter("cloud_cover", clouds)
	sky_mat.set_shader_parameter("cloud_dark", dark)
	sky_mat.set_shader_parameter("cloud_light", Color(0.95, 0.93, 0.9).lerp(Color(1.0, 0.7, 0.5), dusk) * (0.12 + dl * 0.88))
	sky_mat.set_shader_parameter("cloud_shadow", Color(0.36, 0.38, 0.44) * (0.1 + dl * 0.9))
	sky_mat.set_shader_parameter("star_strength", (1.0 - dl) * (1.0 - clouds * 0.8))
	sky_mat.set_shader_parameter("sun_color", Color(1.0, 0.92, 0.8).lerp(Color(1.0, 0.55, 0.3), dusk))
	sky_mat.set_shader_parameter("moon_dir", Vector3(-sd.x, absf(sd.y) * 0.6 + 0.3, -sd.z).normalized())
	sky_mat.set_shader_parameter("flash", flash * 0.6)
	sky_mat.set_shader_parameter("haze", 0.25 + wm.fog * 0.5)
	# --- sol / lua ----------------------------------------------------------
	var night := sh < -0.05
	var light_dir := sd if not night else Vector3(-sd.x, absf(sd.y) * 0.6 + 0.35, -sd.z).normalized()
	# a direção da luz anda em passos de 0,15° (≈1 s de jogo): girar o sol um
	# pouquinho a cada quadro faz os texels do mapa de sombra "rastejarem" e as
	# bordas das sombras tremem; em passos quase não se nota
	if _sun_dir == Vector3.ZERO or _sun_dir.angle_to(light_dir) > deg_to_rad(0.15):
		_sun_dir = light_dir
		sun.look_at_from_position(Vector3.ZERO, -light_dir, Vector3.UP if absf(light_dir.y) < 0.99 else Vector3.FORWARD)
	# sol some e a lua entra a partir de zero: sem salto de luz na troca de direção
	if night:
		# luar: frio e fraco; a cidade não tem energia, então a noite é escura de verdade
		sun.light_color = Color(0.5, 0.6, 0.88)
		sun.light_energy = 0.5 * smoothstep(-0.05, -0.2, sh) * (1.0 - clouds * 0.6) + flash * 2.5
	else:
		sun.light_color = Color(1.0, 0.93, 0.82).lerp(Color(1.0, 0.6, 0.34), dusk)
		sun.light_energy = (0.3 + dl * 1.45) * smoothstep(-0.05, 0.04, sh) * (1.0 - clouds * 0.45 - dark * 0.25) + flash * 2.0
	sun.shadow_opacity = clampf(1.0 - clouds * 0.6, 0.35, 1.0) if not night else 0.6
	# --- ambiente ---------------------------------------------------------
	# luz do céu nas sombras: vem mais do zênite (azulado) que do horizonte alaranjado,
	# e dessaturada (céu de cidade, poeira) para não "lavar" tudo de branco
	var amb := zen.lerp(hor, 0.35)
	amb = amb.lerp(Color(0.4, 0.42, 0.45), 0.3)
	# noite: só o luar e o céu estrelado (sem luz de rua)
	var night_amb := Color(0.085, 0.1, 0.155)
	var amb_c := amb.lerp(night_amb, 1.0 - dl)
	# dentro: a pouca luz que sobra é rebatida (neutra/quente), não o azul do céu
	amb_c = amb_c.lerp(Color(0.46, 0.44, 0.41) * (0.25 + dl * 0.75), indoor * 0.7)
	# luz fluorescente: branca levemente fria, igual de dia e de noite
	amb_c = amb_c.lerp(Color(0.8, 0.84, 0.88), lit * 0.85)
	env.ambient_light_color = amb_c
	# crepúsculo: o céu ainda clareia um pouco depois que o sol se põe
	var twilight := smoothstep(-0.26, -0.03, sh) * (1.0 - smoothstep(-0.03, 0.12, sh))
	# dentro dos prédios quase não chega céu: quem ilumina são as janelas e a lanterna
	var amb_out := lerpf(1.1, 0.82, dl) + twilight * 0.9
	var amb_in := lerpf(0.2, 0.13, dl) + twilight * 0.08
	amb_in = lerpf(amb_in, 0.5, indoor_lit)
	# luz de emergência: vermelho escuro rebatido pelas paredes
	var em := emergency * indoor
	if em > 0.0:
		amb_c = amb_c.lerp(Color(0.62, 0.1, 0.08), clampf(em, 0.0, 1.0) * 0.85)
		env.ambient_light_color = amb_c
		amb_in = maxf(amb_in, 0.42 * em)
	env.ambient_light_energy = lerpf(amb_out, amb_in, indoor) + flash * 1.5
	env.ambient_light_sky_contribution = 0.0
	# --- neblina ------------------------------------------------------------
	var vd := Settings.get_view_distance()
	var base_fog := 1.45 / (vd * fog_scale)
	var fog_d := base_fog + wm.fog * 0.0085 + wm.rain * 0.0022
	if override_fog >= 0.0:
		fog_d = override_fog
	env.fog_density = fog_d * lerpf(1.0, 0.35, indoor)
	env.fog_light_color = hor.lerp(Color(0.5, 0.52, 0.55), 0.3)
	env.fog_light_energy = 0.8 + dl * 0.35
	env.fog_sun_scatter = 0.12 * dl * (1.0 - clouds)
	# névoa baixa: bruma de madrugada/amanhecer e na chuva, rente ao chão da cidade
	var hr := TimeManager.hour
	var mist := smoothstep(3.5, 5.5, hr) * (1.0 - smoothstep(7.5, 9.5, hr))
	env.fog_height = 2.5
	env.fog_height_density = (mist * 0.06 + wm.rain * 0.025 + wm.fog * 0.04) * (1.0 - indoor)
	# --- cor / tonemap ---------------------------------------------------------
	env.adjustment_saturation = mood_saturation * lerpf(0.95, 0.8, clouds * 0.5)
	env.adjustment_contrast = lerpf(1.0, 1.1, dl)
	env.adjustment_brightness = 1.0
	var bright := Settings.get_brightness()
	# o olho se adapta um pouco ao escuro (sem auto-exposição no renderer Compatibility)
	var adapt := lerpf(1.0, lerpf(lerpf(1.1, 1.45, dl), 1.0, indoor_lit), indoor)
	# lanterna acesa em lugar fechado: a vista se acostuma com o facho (sem estourar de perto)
	if torch_on:
		adapt *= lerpf(1.0, 0.72, indoor * (1.0 - dl))
	# o "olho" da noite só vale fora ou no escuro; sob luz acesa a exposição é a do dia
	env.tonemap_exposure = exposure * bright * lerpf(1.05, 2.2, (1.0 - dl) * (1.0 - lit)) * adapt
	if underground:
		sun.visible = false
		env.background_mode = Environment.BG_COLOR
		env.background_color = Color(0.01, 0.01, 0.012)
		env.ambient_light_color = Color(0.17, 0.18, 0.21)
		env.ambient_light_energy = 1.0
		env.fog_density = 0.004
		env.fog_height_density = 0.0
		env.fog_light_color = Color(0.1, 0.1, 0.11)
		env.tonemap_exposure = exposure * bright * 1.45
		dl = 0.0
	elif not sun.visible:
		sun.visible = true
		env.background_mode = Environment.BG_SKY
	ShaderGlobals.set_value("daylight", dl)
