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
var override_fog: float = -1.0
var flash: float = 0.0
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
	env.tonemap_white = 6.0
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
		cam.far = Settings.get_view_distance() + 300.0


func set_indoor(v: bool) -> void:
	indoor_target = 1.0 if v else 0.0


func _process(delta: float) -> void:
	_update(delta)


func _update(delta: float) -> void:
	indoor = move_toward(indoor, indoor_target, delta * 1.5)
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
	var zen_night := Color(0.012, 0.018, 0.04)
	var hor_night := Color(0.05, 0.065, 0.1)
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
	sun.look_at_from_position(Vector3.ZERO, -light_dir, Vector3.UP if absf(light_dir.y) < 0.99 else Vector3.FORWARD)
	if night:
		sun.light_color = Color(0.55, 0.62, 0.8)
		sun.light_energy = 0.32 * (1.0 - clouds * 0.6) + flash * 2.5
	else:
		sun.light_color = Color(1.0, 0.95, 0.88).lerp(Color(1.0, 0.62, 0.38), dusk)
		sun.light_energy = (0.2 + dl * 1.25) * (1.0 - clouds * 0.55 - dark * 0.3) + flash * 2.0
	sun.shadow_opacity = clampf(1.0 - clouds * 0.6, 0.35, 1.0) if not night else 0.6
	# --- ambiente ---------------------------------------------------------
	var amb := hor.lerp(zen, 0.5)
	amb = amb.lerp(Color(0.2, 0.22, 0.25), 0.25)
	env.ambient_light_color = amb
	var night_amb := Color(0.09, 0.11, 0.16)
	env.ambient_light_color = amb.lerp(night_amb, 1.0 - dl)
	env.ambient_light_energy = lerpf(1.0, 0.95, dl) * lerpf(1.0, 0.45, indoor) + flash * 1.5
	env.ambient_light_sky_contribution = 0.0
	# --- neblina ------------------------------------------------------------
	var vd := Settings.get_view_distance()
	var base_fog := 2.2 / vd
	var fog_d := base_fog + wm.fog * 0.0085 + wm.rain * 0.0022
	if override_fog >= 0.0:
		fog_d = override_fog
	env.fog_density = fog_d * lerpf(1.0, 0.35, indoor)
	env.fog_light_color = hor.lerp(Color(0.5, 0.52, 0.55), 0.3)
	env.fog_light_energy = 0.6 + dl * 0.5
	env.fog_sun_scatter = 0.12 * dl * (1.0 - clouds)
	# --- cor / tonemap ---------------------------------------------------------
	env.adjustment_saturation = mood_saturation * lerpf(1.0, 0.8, clouds * 0.5)
	env.adjustment_contrast = 1.06
	env.adjustment_brightness = 1.0 + (1.0 - dl) * 0.06
	env.tonemap_exposure = exposure * lerpf(1.0, 1.25, 1.0 - dl) * lerpf(1.0, 1.35, indoor)
	ShaderGlobals.set_value("daylight", dl)
