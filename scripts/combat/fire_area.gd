class_name FireArea
extends Node3D
## Fogo temporário (coquetel incendiário): dano em área, luz e partículas.

var owner_node: Node = null
var life: float = 7.0
var radius: float = 2.6
var _tick: float = 0.0
var light: OmniLight3D


func ignite(by: Node) -> void:
	owner_node = by
	add_to_group("heat_source")
	light = OmniLight3D.new()
	light.light_color = Color(1.0, 0.55, 0.2)
	light.light_energy = 3.0
	light.omni_range = 9.0
	light.position = Vector3(0, 0.8, 0)
	add_child(light)
	var p := GPUParticles3D.new()
	p.amount = int(40 * Settings.get_particle_multiplier()) + 10
	p.lifetime = 1.0
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = radius * 0.6
	pm.direction = Vector3.UP
	pm.initial_velocity_min = 1.0
	pm.initial_velocity_max = 2.4
	pm.gravity = Vector3(0, 1.0, 0)
	pm.scale_min = 0.6
	pm.scale_max = 1.3
	var grad := Gradient.new()
	grad.set_color(0, Color(1.0, 0.8, 0.35, 0.9))
	grad.set_color(1, Color(0.4, 0.1, 0.02, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.8, 0.8)
	q.material = Assets.particle_material(Assets.SPR_SMOKE, Color(1.0, 0.6, 0.25), true)
	p.draw_pass_1 = q
	add_child(p)
	AudioManager.attach_loop("amb_fire", self, 0.0, 30.0)
	EventBus.make_noise(global_position, 25.0, by, &"fire")


func is_heat_source() -> bool:
	return true


func _process(delta: float) -> void:
	life -= delta
	if light:
		light.light_energy = 2.6 + randf() * 0.8
	_tick -= delta
	if _tick <= 0.0:
		_tick = 0.5
		for n in get_tree().get_nodes_in_group("damageable"):
			var nd := n as Node3D
			if nd != null and nd.global_position.distance_to(global_position) < radius and n.has_method("receive_hit"):
				var info := DamageInfo.make(9.0, "fire", owner_node, nd.global_position - global_position)
				info.blockable = false
				n.receive_hit(info)
	if life <= 0.0:
		queue_free()
