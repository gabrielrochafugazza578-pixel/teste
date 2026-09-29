class_name HitFx
extends RefCounted
## Respingo curto no ponto do golpe (CPUParticles3D, some sozinho).
## Barato: 8–16 partículas, sem sombra, vida < 0,6 s.

static var _mesh: QuadMesh
static var _mat_blood: StandardMaterial3D
static var _mat_dust: StandardMaterial3D


static func _setup() -> void:
	if _mesh != null:
		return
	_mesh = QuadMesh.new()
	_mesh.size = Vector2(0.05, 0.05)
	_mat_blood = StandardMaterial3D.new()
	_mat_blood.albedo_color = Color(0.22, 0.03, 0.03)
	_mat_blood.roughness = 0.35
	_mat_blood.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	_mat_dust = _mat_blood.duplicate()
	_mat_dust.albedo_color = Color(0.5, 0.47, 0.42)


static func spawn(parent: Node, pos: Vector3, dir: Vector3, strong: bool, flesh: bool = true) -> void:
	if parent == null or not parent.is_inside_tree():
		return
	_setup()
	var p := CPUParticles3D.new()
	p.one_shot = true
	p.explosiveness = 0.95
	p.amount = maxi(4, int((16 if strong else 9) * clampf(Settings.get_particle_multiplier(), 0.4, 1.5)))
	p.lifetime = 0.55
	p.mesh = _mesh
	p.material_override = _mat_blood if flesh else _mat_dust
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	p.direction = (dir.normalized() + Vector3(0, 0.6, 0)).normalized()
	p.spread = 38.0
	p.initial_velocity_min = 1.4
	p.initial_velocity_max = 3.6 if strong else 2.4
	p.gravity = Vector3(0, -9.8, 0)
	p.scale_amount_min = 0.6
	p.scale_amount_max = 1.6 if strong else 1.1
	parent.add_child(p)
	p.global_position = pos
	p.emitting = true
	p.get_tree().create_timer(1.2, false).timeout.connect(p.queue_free)
