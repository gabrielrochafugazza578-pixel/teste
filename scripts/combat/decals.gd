class_name Decals
extends RefCounted
## Marcas que ficam no mundo depois do combate: furos de bala nas paredes e no
## chão, respingos de sangue no chão/parede atrás de quem apanhou e a poça que se
## espalha embaixo de um corpo. Quads finos alinhados à superfície (o renderer
## Compatibility não tem Decal), com limite fixo: a marca mais antiga é reciclada.

const MAX_HOLES := 48
const MAX_BLOOD := 36

static var _holes: Array = []
static var _blood: Array = []
static var _tex_hole: ImageTexture
static var _tex_blood: Array = []
static var _mat_hole: StandardMaterial3D
static var _mat_blood: Array = []
static var _quad: QuadMesh


static func _setup() -> void:
	if _quad != null:
		return
	_quad = QuadMesh.new()
	_quad.size = Vector2(1, 1)
	_tex_hole = ImageTexture.create_from_image(_hole_image())
	_mat_hole = _make_mat(_tex_hole)
	for i in 3:
		var t := ImageTexture.create_from_image(_blood_image(1234 + i * 77))
		_tex_blood.append(t)
		_mat_blood.append(_make_mat(t))


static func _make_mat(t: Texture2D) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_texture = t
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	m.alpha_scissor_threshold = 0.5
	m.roughness = 0.4
	m.cull_mode = BaseMaterial3D.CULL_BACK
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return m


static func _hole_image() -> Image:
	var n := 32
	var img := Image.create(n, n, true, Image.FORMAT_RGBA8)
	var c := Vector2(n, n) * 0.5
	for y in n:
		for x in n:
			var d := Vector2(x + 0.5, y + 0.5).distance_to(c) / (n * 0.5)
			var a := atan2(y - c.y, x - c.x)
			var edge := 0.78 + 0.18 * sin(a * 5.0) * sin(a * 3.0 + 1.0)
			var col := Color(0, 0, 0, 0)
			if d < 0.22:
				col = Color(0.02, 0.02, 0.02, 1)
			elif d < 0.34:
				col = Color(0.12, 0.11, 0.1, 1)
			elif d < edge:
				# reboco lascado em volta do furo
				col = Color(0.55, 0.53, 0.5, 1).darkened(0.25 * (1.0 - d))
			img.set_pixel(x, y, col)
	img.generate_mipmaps()
	return img


static func _blood_image(sd: int) -> Image:
	var n := 96
	var img := Image.create(n, n, true, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = sd
	var noise := FastNoiseLite.new()
	noise.seed = sd
	noise.frequency = 0.09
	var drops: Array = []
	for i in 10:
		var a := r.randf() * TAU
		var dd := r.randf_range(0.55, 0.9)
		drops.append([Vector2(cos(a), sin(a)) * dd, r.randf_range(0.03, 0.08)])
	for y in n:
		for x in n:
			var p := (Vector2(x + 0.5, y + 0.5) / float(n)) * 2.0 - Vector2.ONE
			var v := 0.5 - p.length() * 0.62 + noise.get_noise_2d(x, y) * 0.32
			for dr in drops:
				var q: Vector2 = dr[0]
				v = maxf(v, float(dr[1]) - p.distance_to(q))
			if v > 0.0:
				var dark := clampf(v * 2.2, 0.0, 1.0)
				img.set_pixel(x, y, Color(0.34, 0.035, 0.03).lerp(Color(0.16, 0.012, 0.01), dark))
			else:
				img.set_pixel(x, y, Color(0.3, 0.03, 0.02, 0))
	img.generate_mipmaps()
	return img


static func _place(parent: Node, pos: Vector3, normal: Vector3, size: float, mat: Material, list: Array, max_n: int) -> MeshInstance3D:
	if parent == null or not parent.is_inside_tree():
		return null
	_setup()
	while list.size() >= max_n:
		var old: Variant = list.pop_front()
		if is_instance_valid(old):
			(old as Node).queue_free()
	var mi := MeshInstance3D.new()
	mi.mesh = _quad
	mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	var n := normal.normalized()
	var up := Vector3.UP if absf(n.y) < 0.95 else Vector3.FORWARD
	var basis := Basis.looking_at(-n, up)
	basis = basis.rotated(n, randf() * TAU)
	mi.global_transform = Transform3D(basis.scaled(Vector3(size, size, 1.0)), pos + n * 0.012)
	list.append(mi)
	return mi


## Furo de bala onde o tiro bateu em algo que não é gente.
static func bullet_hole(parent: Node, pos: Vector3, normal: Vector3) -> void:
	_place(parent, pos, normal, randf_range(0.06, 0.09), _mat_hole_ref(), _holes, MAX_HOLES)


static func _mat_hole_ref() -> Material:
	_setup()
	return _mat_hole


## Respingo depois de um golpe/tiro na carne: procura parede logo atrás do alvo
## (até 1,6 m) e, se não houver, o chão.
static func splatter(parent: Node, from: Vector3, dir: Vector3, strong: bool, exclude: Array = []) -> void:
	if parent == null or not parent.is_inside_tree() or not (parent is Node3D):
		return
	_setup()
	var space := (parent as Node3D).get_world_3d().direct_space_state
	var d := Vector3(dir.x, 0, dir.z).normalized()
	if d.length() < 0.1:
		d = Vector3.FORWARD
	var q := PhysicsRayQueryParameters3D.create(from, from + d * 1.6 + Vector3(0, -0.3, 0), 1)
	q.exclude = exclude
	var hit := space.intersect_ray(q)
	if not hit.is_empty() and absf((hit["normal"] as Vector3).y) < 0.5:
		_place(parent, hit["position"], hit["normal"], randf_range(0.35, 0.6) * (1.3 if strong else 1.0), _mat_blood[randi() % _mat_blood.size()], _blood, MAX_BLOOD)
		return
	if randf() > (0.8 if strong else 0.45):
		return
	var g := from + d * randf_range(0.4, 1.1)
	var dq := PhysicsRayQueryParameters3D.create(g + Vector3(0, 0.5, 0), g + Vector3(0, -2.5, 0), 1)
	dq.exclude = exclude
	var gh := space.intersect_ray(dq)
	if not gh.is_empty():
		_place(parent, gh["position"], gh["normal"], randf_range(0.3, 0.55) * (1.3 if strong else 1.0), _mat_blood[randi() % _mat_blood.size()], _blood, MAX_BLOOD)


## Poça que se espalha devagar embaixo de um corpo.
static func pool(parent: Node, pos: Vector3, exclude: Array = []) -> void:
	if parent == null or not parent.is_inside_tree() or not (parent is Node3D):
		return
	_setup()
	var space := (parent as Node3D).get_world_3d().direct_space_state
	var dq := PhysicsRayQueryParameters3D.create(pos + Vector3(0, 0.6, 0), pos + Vector3(0, -2.0, 0), 1)
	dq.exclude = exclude
	var gh := space.intersect_ray(dq)
	if gh.is_empty():
		return
	var mi := _place(parent, gh["position"], gh["normal"], 0.2, _mat_blood[randi() % _mat_blood.size()], _blood, MAX_BLOOD)
	if mi == null:
		return
	var target := randf_range(1.0, 1.5)
	var tw := mi.create_tween()
	var b0 := mi.global_transform.basis.orthonormalized()
	var o := mi.global_position
	tw.tween_method(func(s: float) -> void:
		if is_instance_valid(mi):
			mi.global_transform = Transform3D(b0.scaled(Vector3(s, s, 1.0)), o), 0.2, target, 6.0).set_delay(0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)


static func clear() -> void:
	for l in [_holes, _blood]:
		for m in l:
			if is_instance_valid(m):
				(m as Node).queue_free()
		l.clear()
