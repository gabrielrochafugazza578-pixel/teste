class_name Effects
## Efeitos visuais rapidos (particulas "puf" estilo desenho animado).

static var _mat_cache: Dictionary = {}


static func _material(color: Color, glow: float) -> StandardMaterial3D:
	var key := "%s_%s" % [color.to_html(), glow]
	if _mat_cache.has(key):
		return _mat_cache[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.vertex_color_use_as_albedo = true
	if glow > 0.0:
		m.emission_enabled = true
		m.emission = color
		m.emission_energy_multiplier = glow
	_mat_cache[key] = m
	return m


## Nuvenzinha de bolinhas que se espalham e somem.
static func poof(parent: Node, pos: Vector3, color: Color, amount := 14, speed := 3.0, size := 0.09, glow := 0.0) -> void:
	if parent == null or not parent.is_inside_tree():
		return
	var p := CPUParticles3D.new()
	p.one_shot = true
	p.explosiveness = 0.95
	p.amount = amount
	p.lifetime = 0.7
	var sm := SphereMesh.new()
	sm.radius = size
	sm.height = size * 2.0
	sm.radial_segments = 6
	sm.rings = 3
	sm.material = _material(color, glow)
	p.mesh = sm
	p.direction = Vector3.UP
	p.spread = 80.0
	p.initial_velocity_min = speed * 0.5
	p.initial_velocity_max = speed
	p.gravity = Vector3(0, -9.0, 0)
	p.damping_min = 1.0
	p.damping_max = 2.0
	var curve := Curve.new()
	curve.add_point(Vector2(0, 1))
	curve.add_point(Vector2(1, 0))
	p.scale_amount_curve = curve
	p.emitting = true
	parent.add_child(p)
	p.global_position = pos
	p.finished.connect(p.queue_free)
