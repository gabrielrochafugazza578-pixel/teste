class_name DayNight
extends Node
## Ciclo de dia e noite: move o sol/lua, muda as cores do ceu, da neblina e da
## luz ambiente. time_of_day: 0 = meia-noite, 0.25 = amanhecer, 0.5 = meio-dia.

signal night_started
signal day_started

@export var day_length := 600.0   # segundos reais por dia completo
@export var time_of_day := 0.3
@export var paused := false

var sun: DirectionalLight3D
var env: Environment
var sky_mat: ShaderMaterial
var day_count := 1
var is_night := false
var night_factor := 0.0           # 0 = dia pleno, 1 = noite plena
var sun_dir := Vector3.UP
var cloud_time := 0.0

# paleta (sRGB)
const DAY_TOP := Color(0.33, 0.62, 1.0)
const DAY_HORIZON := Color(0.78, 0.92, 1.0)
const NIGHT_TOP := Color(0.03, 0.04, 0.13)
const NIGHT_HORIZON := Color(0.10, 0.12, 0.30)
const SUNSET_HORIZON := Color(1.0, 0.55, 0.38)
const SUNSET_TOP := Color(0.45, 0.42, 0.78)
const DAY_AMBIENT := Color(0.50, 0.56, 0.72)
const NIGHT_AMBIENT := Color(0.16, 0.19, 0.38)
const SUN_NOON := Color(1.0, 0.96, 0.86)
const SUN_LOW := Color(1.0, 0.62, 0.38)
const MOON_LIGHT := Color(0.55, 0.65, 1.0)


func setup(p_sun: DirectionalLight3D, p_env: Environment, p_sky: ShaderMaterial) -> void:
	sun = p_sun
	env = p_env
	sky_mat = p_sky
	is_night = _compute_night()
	_apply()


func _process(delta: float) -> void:
	cloud_time += delta
	if not paused:
		var before := time_of_day
		time_of_day += delta / day_length
		if time_of_day >= 1.0:
			time_of_day -= 1.0
		if time_of_day < before:
			day_count += 1
	var now_night := _compute_night()
	if now_night != is_night:
		is_night = now_night
		if is_night:
			night_started.emit()
		else:
			day_started.emit()
	_apply()


func _compute_night() -> bool:
	return time_of_day < 0.23 or time_of_day > 0.77


func clock_string() -> String:
	var minutes := int(time_of_day * 24.0 * 60.0)
	return "%02d:%02d" % [minutes / 60, minutes % 60]


func _apply() -> void:
	if sun == null:
		return
	var a := (time_of_day - 0.25) * TAU
	sun_dir = Vector3(cos(a), sin(a), 0.0)
	sun_dir = (Basis(Vector3.UP, deg_to_rad(-35.0)) * Basis(Vector3.RIGHT, deg_to_rad(-25.0)) * sun_dir).normalized()
	var e := sun_dir.y                      # elevacao do sol (-1..1)
	var day := smoothstep(-0.12, 0.22, e)
	night_factor = 1.0 - day
	var sunset := clampf(1.0 - absf(e) / 0.32, 0.0, 1.0)

	var top := NIGHT_TOP.lerp(DAY_TOP, day).lerp(SUNSET_TOP, sunset * 0.45)
	var horizon := NIGHT_HORIZON.lerp(DAY_HORIZON, day).lerp(SUNSET_HORIZON, sunset * 0.8)

	# luz: sol de dia, lua de noite (a troca acontece no horizonte, com energia ~0)
	var light_dir: Vector3
	if e > -0.04:
		light_dir = sun_dir
		sun.light_color = SUN_LOW.lerp(SUN_NOON, smoothstep(0.0, 0.45, e))
		sun.light_energy = smoothstep(-0.04, 0.18, e) * 1.05
	else:
		light_dir = -sun_dir
		sun.light_color = MOON_LIGHT
		sun.light_energy = smoothstep(0.04, 0.25, -e) * 0.35
	# a luz aponta na direcao oposta a posicao do astro
	var target := -light_dir
	var up := Vector3.UP if absf(target.y) < 0.99 else Vector3.FORWARD
	sun.basis = Basis.looking_at(target, up)

	RenderingServer.global_shader_parameter_set("night_factor", night_factor)
	env.ambient_light_color = NIGHT_AMBIENT.lerp(DAY_AMBIENT, day).lerp(Color(0.75, 0.6, 0.62), sunset * 0.25)
	env.fog_light_color = horizon
	env.background_energy_multiplier = 1.0

	if sky_mat:
		sky_mat.set_shader_parameter("top_color", top)
		sky_mat.set_shader_parameter("horizon_color", horizon)
		sky_mat.set_shader_parameter("ground_color", horizon)
		sky_mat.set_shader_parameter("sun_dir", sun_dir)
		sky_mat.set_shader_parameter("sun_color", SUN_LOW.lerp(SUN_NOON, smoothstep(0.0, 0.4, e)))
		sky_mat.set_shader_parameter("night", night_factor)
		sky_mat.set_shader_parameter("sunset", sunset)
		sky_mat.set_shader_parameter("cloud_time", cloud_time)
		sky_mat.set_shader_parameter("cloud_cover", lerpf(0.46, 0.56, night_factor))
		sky_mat.set_shader_parameter("cloud_light", Color(1, 1, 1).lerp(Color(0.22, 0.24, 0.42), night_factor).lerp(Color(1.0, 0.78, 0.66), sunset * 0.6))
		sky_mat.set_shader_parameter("cloud_shade", Color(0.72, 0.78, 0.93).lerp(Color(0.12, 0.13, 0.28), night_factor).lerp(Color(0.85, 0.5, 0.5), sunset * 0.5))
