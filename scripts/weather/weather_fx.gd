class_name WeatherFX
extends Node3D
## Efeitos visuais de clima que seguem a câmera: chuva (partículas GPU com
## quantidade por qualidade), detritos levados pelo vento e névoa baixa.
## Tudo desliga dentro de interiores/túnel para economizar GPU.

var rain: GPUParticles3D
var debris: GPUParticles3D
var mist: GPUParticles3D
var splash: GPUParticles3D
var camera: Camera3D
var indoors: bool = false


func _ready() -> void:
	rain = _make_rain()
	add_child(rain)
	debris = _make_debris()
	add_child(debris)
	mist = _make_mist()
	add_child(mist)
	splash = _make_splash()
	add_child(splash)
	EventBus.settings_changed.connect(_apply_quality)
	_apply_quality()


func _apply_quality() -> void:
	var q := Settings.get_weather_quality()
	var m := Settings.get_particle_multiplier()
	rain.amount = int([700, 1400, 2600, 4200][q] * clampf(m, 0.3, 1.5))
	debris.amount = int(12 + 30 * m)
	splash.amount = int([300, 560, 900, 1300][q] * clampf(m, 0.3, 1.5))
	mist.visible = q >= 2


func _make_rain() -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = 1400
	p.lifetime = 1.1
	p.preprocess = 1.0
	p.local_coords = false
	p.fixed_fps = 30
	p.visibility_aabb = AABB(Vector3(-25, -15, -25), Vector3(50, 35, 50))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(22, 1, 22)
	pm.direction = Vector3(0, -1, 0)
	pm.spread = 3.0
	pm.initial_velocity_min = 17.0
	pm.initial_velocity_max = 21.0
	pm.gravity = Vector3(0, -9.8, 0)
	pm.scale_min = 0.8
	pm.scale_max = 1.2
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.025, 0.55)
	var mat := Assets.particle_material(Assets.SPR_RAIN, Color(0.75, 0.8, 0.88, 0.45), false, BaseMaterial3D.BILLBOARD_FIXED_Y)
	q.material = mat
	p.draw_pass_1 = q
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	p.emitting = false
	return p


## Respingos da chuva no chão em volta do jogador: gotinhas que espirram
## para cima e caem de volta (coroa de respingo).
func _make_splash() -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = 160
	p.lifetime = 0.26
	p.local_coords = false
	p.fixed_fps = 30
	p.visibility_aabb = AABB(Vector3(-10, -2, -10), Vector3(20, 4, 20))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(7, 0.02, 7)
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 40.0
	pm.initial_velocity_min = 0.7
	pm.initial_velocity_max = 1.5
	pm.gravity = Vector3(0, -9.8, 0)
	pm.scale_min = 0.7
	pm.scale_max = 1.3
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 0.9))
	grad.set_color(grad.get_point_count() - 1, Color(1, 1, 1, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.07, 0.1)
	q.material = Assets.particle_material(Assets.SPR_SPARK, Color(0.55, 0.58, 0.62, 0.8))
	p.draw_pass_1 = q
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	p.emitting = false
	return p


func _make_debris() -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = 30
	p.lifetime = 7.0
	p.local_coords = false
	p.visibility_aabb = AABB(Vector3(-30, -5, -30), Vector3(60, 15, 60))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(26, 1.2, 26)
	pm.direction = Vector3(1, 0.2, 0)
	pm.spread = 30.0
	pm.initial_velocity_min = 1.0
	pm.initial_velocity_max = 3.5
	pm.gravity = Vector3(0, -0.4, 0)
	pm.angular_velocity_min = -200.0
	pm.angular_velocity_max = 200.0
	pm.turbulence_enabled = true
	pm.turbulence_noise_strength = 1.2
	pm.turbulence_noise_scale = 3.0
	pm.scale_min = 0.6
	pm.scale_max = 1.2
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.22, 0.3)
	q.material = Assets.debris_material(Assets.SPR_PAPER)
	p.draw_pass_1 = q
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return p


func _make_mist() -> GPUParticles3D:
	var p := GPUParticles3D.new()
	p.amount = 18
	p.lifetime = 14.0
	p.preprocess = 10.0
	p.local_coords = false
	p.visibility_aabb = AABB(Vector3(-60, -5, -60), Vector3(120, 20, 120))
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(45, 0.8, 45)
	pm.direction = Vector3(1, 0, 0)
	pm.initial_velocity_min = 0.3
	pm.initial_velocity_max = 0.8
	pm.gravity = Vector3.ZERO
	pm.scale_min = 6.0
	pm.scale_max = 11.0
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 0))
	grad.add_point(0.3, Color(1, 1, 1, 0.22))
	grad.add_point(0.7, Color(1, 1, 1, 0.2))
	grad.set_color(grad.get_point_count() - 1, Color(1, 1, 1, 0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(1, 1)
	q.material = Assets.particle_material(Assets.SPR_SMOKE, Color(0.75, 0.78, 0.8, 0.5))
	p.draw_pass_1 = q
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	p.emitting = false
	return p


func _process(_delta: float) -> void:
	if camera == null or not is_instance_valid(camera):
		camera = get_viewport().get_camera_3d()
		if camera == null:
			return
	var cp := camera.global_position
	var wm := WeatherManager
	rain.global_position = cp + Vector3(wm.wind_dir.x, 0, wm.wind_dir.y) * -3.0 + Vector3(0, 11, 0) + camera.global_transform.basis.z * -6.0
	var pm: ParticleProcessMaterial = rain.process_material
	pm.gravity = Vector3(wm.wind_dir.x * wm.wind * 6.0, -9.8, wm.wind_dir.y * wm.wind * 6.0)
	var raining := wm.rain > 0.08 and not indoors
	rain.emitting = raining
	if raining:
		rain.amount_ratio = clampf(wm.rain, 0.1, 1.0)
	var pl := get_tree().get_first_node_in_group("player") as Node3D
	if pl:
		splash.global_position = pl.global_position + Vector3(0, 0.03, 0) + camera.global_transform.basis.z * -3.0 * Vector3(1, 0, 1)
	splash.emitting = raining and pl != null and wm.rain > 0.2
	if splash.emitting:
		splash.amount_ratio = clampf(wm.rain, 0.2, 1.0)
		# sem iluminação no sprite: à noite os respingos ficam bem mais fracos
		var sm := (splash.draw_pass_1 as QuadMesh).material as StandardMaterial3D
		sm.albedo_color.a = 0.55 * lerpf(0.2, 1.0, TimeManager.daylight())
	debris.global_position = cp + Vector3(0, 0.8, 0)
	var dpm: ParticleProcessMaterial = debris.process_material
	dpm.direction = Vector3(wm.wind_dir.x, 0.15, wm.wind_dir.y)
	debris.emitting = wm.wind > 0.45 and not indoors and wm.rain < 0.5 and Settings.get_weather_quality() >= 1
	mist.global_position = cp + Vector3(0, 0.5, 0)
	mist.emitting = mist.visible and wm.fog > 0.5 and not indoors
