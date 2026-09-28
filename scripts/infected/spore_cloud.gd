class_name SporeCloud
extends Node3D
## Nuvem de esporos do Hospedeiro: infecta quem respira sem máscara.

var life: float = 9.0
var radius: float = 3.6
var _tick: float = 0.0


func _ready() -> void:
	var p := GPUParticles3D.new()
	p.amount = int(26 * Settings.get_particle_multiplier()) + 8
	p.lifetime = 4.0
	p.preprocess = 1.5
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = radius * 0.6
	pm.direction = Vector3.UP
	pm.spread = 180.0
	pm.initial_velocity_min = 0.1
	pm.initial_velocity_max = 0.4
	pm.gravity = Vector3(0, 0.05, 0)
	pm.scale_min = 1.5
	pm.scale_max = 3.0
	var grad := Gradient.new()
	grad.set_color(0, Color(0.75, 0.7, 0.45, 0.0))
	grad.add_point(0.3, Color(0.7, 0.66, 0.4, 0.35))
	grad.set_color(grad.get_point_count() - 1, Color(0.6, 0.58, 0.35, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	var q := QuadMesh.new()
	q.material = Assets.particle_material(Assets.SPR_SMOKE, Color(0.8, 0.76, 0.5, 0.7))
	p.draw_pass_1 = q
	add_child(p)


func _process(delta: float) -> void:
	life -= delta
	_tick -= delta
	if _tick <= 0.0:
		_tick = 0.5
		for n in get_tree().get_nodes_in_group("player"):
			var pl := n as Player
			if pl == null or pl.global_position.distance_to(global_position) > radius:
				continue
			var protect := 0.0
			var head: Dictionary = pl.equipment.get("head", {})
			if not head.is_empty():
				protect = float(ItemDB.get_item(str(head["id"])).get("spore_protect", 0.0))
				head["cond"] = maxf(0.0, float(head.get("cond", 1.0)) - 0.02)
			if randf() > protect:
				pl.survival.infection = minf(100.0, maxf(pl.survival.infection, 1.0) + 1.2)
				if pl.survival.infection_incubation > 0.0:
					pl.survival.infection_incubation = 0.0
				pl.cam_rig.add_shake(0.03)
				if randf() < 0.3:
					AudioManager.play_3d("cough", pl.global_position, -4.0)
	if life <= 0.0:
		queue_free()
