class_name EnvironmentController
extends Node3D
## Céu, sol/lua, neblina, luz ambiente e pós-processamento. No Forward+ liga também
## SSAO, SSIL, SSR, SDFGI e neblina volumétrica (ver _apply_forward_plus).
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
	# a neblina cobre só parte do céu: azul no alto e nuvens visíveis (o próprio
	# shader do céu já clareia o horizonte)
	env.fog_sky_affect = 0.38
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
		if Settings.is_forward_plus():
			# o céu muda devagar: atualização incremental, com reflexo mais nítido
			env.sky.radiance_size = [Sky.RADIANCE_SIZE_64, Sky.RADIANCE_SIZE_64, Sky.RADIANCE_SIZE_128, Sky.RADIANCE_SIZE_256][clampi(rq, 0, 3)]
			env.sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL
		else:
			env.sky.radiance_size = [Sky.RADIANCE_SIZE_32, Sky.RADIANCE_SIZE_32, Sky.RADIANCE_SIZE_64, Sky.RADIANCE_SIZE_128][clampi(rq, 0, 3)]
			env.sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL if rq < 3 else Sky.PROCESS_MODE_REALTIME
	var cam := get_viewport().get_camera_3d() if is_inside_tree() else null
	if cam:
		cam.far = maxf(Settings.get_view_distance() + 300.0, 3400.0)
	_apply_forward_plus()


## Forward+ (Vulkan): o que o Godot tem de melhor, ligado pela qualidade.
## No Compatibility estes campos são ignorados pelo renderer.
func _apply_forward_plus() -> void:
	var fp := Settings.is_forward_plus()
	var pq := Settings.get_post_quality()
	var rq := Settings.get_reflection_quality()
	var gi := Settings.get_gi_quality()
	var sq := int(Settings.graphics["shadow_quality"])
	var rid := env.get_rid()
	# oclusão de ambiente: cantos, frestas e contato dos objetos com o chão
	env.ssao_enabled = fp and pq >= 1
	ShaderGlobals.set_value("ssao_active", 1.0 if env.ssao_enabled else 0.0)
	env.ssao_radius = 1.1
	env.ssao_intensity = 2.2
	env.ssao_power = 1.6
	env.ssao_detail = 0.6
	env.ssao_horizon = 0.06
	env.ssao_sharpness = 0.98
	env.ssao_light_affect = 0.0
	env.ssao_ao_channel_affect = 0.6
	if fp:
		RenderingServer.environment_set_ssao_quality([RenderingServer.ENV_SSAO_QUALITY_LOW, RenderingServer.ENV_SSAO_QUALITY_LOW,
			RenderingServer.ENV_SSAO_QUALITY_MEDIUM, RenderingServer.ENV_SSAO_QUALITY_HIGH][clampi(pq, 0, 3)], pq <= 2, 0.5, 2, 50.0, 300.0)
	# luz rebatida de tela (cor das superfícies vizinhas)
	env.ssil_enabled = fp and pq >= 3
	env.ssil_radius = 5.0
	env.ssil_intensity = 1.0
	env.ssil_sharpness = 0.98
	env.ssil_normal_rejection = 1.0
	if fp:
		RenderingServer.environment_set_ssil_quality(RenderingServer.ENV_SSIL_QUALITY_MEDIUM if pq < 3 or gi < 2 else RenderingServer.ENV_SSIL_QUALITY_HIGH, true, 0.5, 4, 50.0, 300.0)
	# reflexos de tela: poças, vidros, carros, piso encerado
	env.ssr_enabled = fp and rq >= 2
	env.ssr_max_steps = 96 if rq >= 3 else 56
	env.ssr_fade_in = 0.15
	env.ssr_fade_out = 2.0
	env.ssr_depth_tolerance = 0.25
	# iluminação global em tempo real (SDFGI): sol entrando pelas janelas, rebatida
	env.sdfgi_enabled = fp and gi >= 1
	env.sdfgi_use_occlusion = true
	env.sdfgi_read_sky_light = true
	env.sdfgi_bounce_feedback = 0.6
	env.sdfgi_cascades = 6 if gi >= 2 else 4
	env.sdfgi_min_cell_size = 0.2 if gi >= 2 else 0.3
	env.sdfgi_y_scale = Environment.SDFGI_Y_SCALE_75_PERCENT
	env.sdfgi_energy = 1.0
	env.sdfgi_normal_bias = 1.1
	env.sdfgi_probe_bias = 1.1
	if fp and gi >= 1:
		RenderingServer.environment_set_sdfgi_ray_count(RenderingServer.ENV_SDFGI_RAY_COUNT_64 if gi >= 2 else RenderingServer.ENV_SDFGI_RAY_COUNT_32)
		RenderingServer.environment_set_sdfgi_frames_to_converge(RenderingServer.ENV_SDFGI_CONVERGE_IN_15_FRAMES if gi >= 2 else RenderingServer.ENV_SDFGI_CONVERGE_IN_20_FRAMES)
		RenderingServer.environment_set_sdfgi_frames_to_update_light(RenderingServer.ENV_SDFGI_UPDATE_LIGHT_IN_8_FRAMES)
	# neblina volumétrica: feixes de sol e da lanterna no ar, bruma iluminada
	env.volumetric_fog_enabled = fp and pq >= 2
	env.volumetric_fog_albedo = Color(0.9, 0.9, 0.92)
	env.volumetric_fog_anisotropy = 0.55
	env.volumetric_fog_length = 96.0 if pq >= 3 else 64.0
	env.volumetric_fog_detail_spread = 2.0
	env.volumetric_fog_gi_inject = 0.6 if gi >= 1 else 0.0
	env.volumetric_fog_ambient_inject = 0.3
	env.volumetric_fog_sky_affect = 0.0
	env.volumetric_fog_temporal_reprojection_enabled = true
	if fp and pq >= 2:
		RenderingServer.environment_set_volumetric_fog_volume_size(160 if pq >= 3 else 96, 96 if pq >= 3 else 64)
		RenderingServer.environment_set_volumetric_fog_filter_active(true)
	if fp:
		# sombras com penumbra realista (PCSS) e resolução alta nas placas fortes
		RenderingServer.directional_shadow_atlas_set_size([1024, 2048, 4096, 4096, 8192][sq], true)
		sun.light_angular_distance = 0.5 if sq >= 2 else 0.0
		# brilho especular sem serrilhado em superfícies ásperas
		RenderingServer.screen_space_roughness_limiter_set_active(true, 0.25, 0.18)
		# tonemapper filmico do Godot 4.4+: cores e altas luzes mais naturais
		env.tonemap_mode = Environment.TONE_MAPPER_AGX
		env.tonemap_white = 12.0


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
	# céu "limpo" ainda tem umas nuvens de tempo bom (só no desenho do céu; a
	# luz do sol continua usando a cobertura real)
	sky_mat.set_shader_parameter("cloud_cover", maxf(clouds, 0.42))
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
	# direção e força do sol para o relevo dos materiais (sombra própria do
	# parallax: o rejunte e as frestas do lado oposto ao sol ficam na sombra)
	ShaderGlobals.set_value("sun_dir", light_dir)
	ShaderGlobals.set_value("sun_strength", clampf(sun.light_energy / 1.6, 0.0, 1.0) * sun.shadow_opacity * (1.0 - indoor))
	# --- ambiente ---------------------------------------------------------
	# luz do céu nas sombras: vem mais do zênite (azulado) que do horizonte alaranjado,
	# e dessaturada (céu de cidade, poeira) para não "lavar" tudo de branco
	var amb := zen.lerp(hor, 0.35)
	# a sombra sob céu limpo é quase neutra: o chão e as fachadas rebatem luz
	# quente que compensa o azul do céu (sem isso o lado na sombra fica azulado)
	amb = amb.lerp(Color(0.43, 0.44, 0.45), 0.5)
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
	# de dia o céu (e o chão rebatendo) ilumina bastante a sombra: sem isso o lado
	# sombreado de troncos, carros e paredes escuras virava preto
	var amb_out := lerpf(1.1, 0.98, dl) + twilight * 0.9
	# sol baixo (manhã cedo, fim de tarde): a luz direta rasante quase não chega
	# ao chão, mas o céu ainda está claro — sem isso encostas e sombras ficavam pretas
	var low_sun := (1.0 - smoothstep(0.08, 0.45, sh)) * smoothstep(-0.05, 0.08, sh)
	amb_out += low_sun * 0.3
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
	# com neblina volumétrica (Forward+) a de distância fica mais leve: as duas somam
	if env.volumetric_fog_enabled:
		fog_d *= 0.6
	# dia limpo: ar mais transparente (o véu cinza achatava o contraste de perto);
	# a perspectiva aérea continua nas distâncias grandes
	fog_d *= lerpf(1.0, 0.72, dl * (1.0 - clouds) * (1.0 - wm.fog) * (1.0 - wm.rain))
	env.fog_density = fog_d * lerpf(1.0, 0.35, indoor)
	env.fog_light_color = hor.lerp(Color(0.5, 0.52, 0.55), 0.3)
	env.fog_light_energy = 0.8 + dl * 0.35
	env.fog_sun_scatter = 0.12 * dl * (1.0 - clouds)
	# névoa baixa: bruma de madrugada/amanhecer e na chuva, rente ao chão da cidade
	var hr := TimeManager.hour
	var mist := smoothstep(3.5, 5.5, hr) * (1.0 - smoothstep(7.5, 9.5, hr))
	env.fog_height = 2.5
	env.fog_height_density = (mist * 0.06 + wm.rain * 0.025 + wm.fog * 0.04) * (1.0 - indoor)
	# neblina volumétrica (Forward+): ar levemente denso lá fora (feixes de sol,
	# faróis), bruma na chuva/neblina e poeira em suspensão dentro dos prédios
	if env.sdfgi_enabled:
		# o SDFGI substitui a luz ambiente: com a energia padrão a sombra das ruas e
		# da mata ficava quase preta (medido com a GI convergida). De dia 2,4; de
		# noite pouca luz rebatida (lua, lanterna)
		env.sdfgi_energy = lerpf(0.5, 2.4, dl) * float(Settings.graphics.get("gi_energy", 1.0))
	if env.volumetric_fog_enabled:
		env.volumetric_fog_ambient_inject = lerpf(0.05, 0.16, dl)
		# pôr/nascer do sol: o espalhamento para frente vira uma névoa laranja densa
		var vf := (0.0016 + clouds * 0.0014 + wm.fog * 0.02 + wm.rain * 0.004 + mist * 0.015) * (1.0 - dusk * 0.6)
		env.volumetric_fog_density = lerpf(vf, 0.012, indoor)
		env.volumetric_fog_albedo = Color(0.92, 0.92, 0.94).lerp(Color(0.8, 0.82, 0.86), clouds)
		env.volumetric_fog_emission = Color(0.0, 0.0, 0.0)
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
	# Forward+: a iluminação global já traz a luz do céu/lua rebatida; o "olho da
	# noite" precisa de bem menos ganho (senão a noite vira dia nublado)
	var night_gain := 1.35 if env.sdfgi_enabled else (1.7 if Settings.is_forward_plus() else 2.2)
	env.tonemap_exposure = exposure * bright * lerpf(1.05, night_gain, (1.0 - dl) * (1.0 - lit)) * adapt
	# com o sol baixo o olho também se acostuma (fora de casa): chão e encostas não afundam no preto
	# (com GI de verdade a encosta já recebe luz rebatida: ganho menor)
	env.tonemap_exposure *= 1.0 + low_sun * (0.1 if env.sdfgi_enabled else 0.28) * (1.0 - indoor)
	# AgX (Forward+) comprime mais os meios-tons que o ACES: compensa a exposição
	if env.tonemap_mode == Environment.TONE_MAPPER_AGX:
		env.tonemap_exposure *= 1.18
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
