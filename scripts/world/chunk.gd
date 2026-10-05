class_name Chunk
extends Node3D
## Nó de um chunk carregado. Recebe os dados gerados em thread e cria os
## recursos de GPU/física em passos pequenos (o RegionStreamer limita o
## tempo gasto por frame). Colisões via PhysicsServer3D (sem nós por caixa).

var coord: Vector2i
var lod: int = -1
var world: Node = null
var heights: PackedFloat32Array
var h_res: int = 0
var h_cell: float = 2.0
var body_rid: RID = RID()
var shape_rids: Array = []
var phase_node: Node3D
var phase_body: RID = RID()
var phase_shapes: Array = []
var phase_built: int = -1
var interiors: Dictionary = {}     # building id -> {"node": Node3D, "body": RID, "shapes": Array}
var enterables: Array = []
var lamps: Array = []
var story_spawned: bool = false
var cars: Array = []              # carros estáticos da camada de fase (dados)


func _init(c: Vector2i, level: int) -> void:
	coord = c
	lod = level
	name = "Chunk_%d_%d" % [c.x, c.y]


func _exit_tree() -> void:
	release()


func release() -> void:
	for s in shape_rids:
		PhysicsServer3D.free_rid(s)
	shape_rids.clear()
	if body_rid.is_valid():
		PhysicsServer3D.free_rid(body_rid)
		body_rid = RID()
	_free_phase()
	for bi in interiors.keys():
		_free_interior(bi)
	interiors.clear()


func _space() -> RID:
	return get_world_3d().space


# ---------------------------------------------------------------------------
# Passos de aplicação (cada um é curto)
# ---------------------------------------------------------------------------
func make_steps(d: Dictionary) -> Array:
	var steps: Array = []
	steps.append(_step_terrain.bind(d))
	steps.append(_step_ground.bind(d))
	steps.append(_step_shells.bind(d))
	steps.append(_step_trees.bind(d))
	if lod == 0:
		steps.append(_step_props.bind(d))
		steps.append(_step_grass.bind(d))
	return steps


func _ensure_body() -> void:
	if body_rid.is_valid():
		return
	body_rid = PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_mode(body_rid, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_set_space(body_rid, _space())
	PhysicsServer3D.body_set_collision_layer(body_rid, 1)
	PhysicsServer3D.body_set_collision_mask(body_rid, 0)


func _add_boxes(body: RID, list: Array, rids: Array) -> void:
	for c in list:
		var xf: Transform3D = c[0]
		var sz: Vector3 = c[1]
		if sz.x <= 0.01 or sz.y <= 0.01 or sz.z <= 0.01:
			continue
		var s := PhysicsServer3D.box_shape_create()
		PhysicsServer3D.shape_set_data(s, sz * 0.5)
		PhysicsServer3D.body_add_shape(body, s, xf)
		rids.append(s)


func _mesh_instance(mesh: Mesh, mat: Material, shadows: bool = true) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	if mat:
		mi.material_override = mat
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if shadows else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mi)
	return mi


func _step_terrain(d: Dictionary) -> void:
	var t: Dictionary = d["terrain"]
	var m := ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, t["arrays"])
	var mi := _mesh_instance(m, Assets.terrain_material(), lod <= 1)
	mi.name = "Terrain"
	heights = t["heights"]
	h_res = int(t["res"])
	h_cell = float(t["cell"])
	if t.has("faces"):
		_ensure_body()
		var s := PhysicsServer3D.concave_polygon_shape_create()
		PhysicsServer3D.shape_set_data(s, {"faces": t["faces"], "backface_collision": true})
		PhysicsServer3D.body_add_shape(body_rid, s, Transform3D.IDENTITY)
		shape_rids.append(s)
	var w: Array = t.get("water", [])
	if not w.is_empty():
		var wm := ArrayMesh.new()
		wm.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, w)
		var wi := _mesh_instance(wm, Assets.water_material(), false)
		wi.name = "Water"


func _step_ground(d: Dictionary) -> void:
	var g: MeshBuf = d["ground"]
	if not g.is_empty():
		var mi := _mesh_instance(g.to_mesh(), Assets.world_material("exterior"), lod == 0)
		mi.name = "Ground"
	if lod <= 1 and not g.colliders.is_empty():
		_ensure_body()
		_add_boxes(body_rid, g.colliders, shape_rids)


func _step_shells(d: Dictionary) -> void:
	var s: MeshBuf = d["shells"]
	var det: MeshBuf = d["details"]
	enterables = d.get("enterables", [])
	if not s.is_empty():
		var mi := _mesh_instance(s.to_mesh(), Assets.world_material("exterior"), true)
		mi.name = "Shells"
	if not det.is_empty():
		var di := _mesh_instance(det.to_mesh(), Assets.world_material("exterior"), true)
		di.name = "Details"
		di.visibility_range_end = Settings.get_detail_distance() * 2.2
	if lod <= 1:
		_ensure_body()
		_add_boxes(body_rid, s.colliders, shape_rids)
		_add_boxes(body_rid, det.colliders, shape_rids)
		_occluders(d)


func _occluders(d: Dictionary) -> void:
	if not Settings.graphics.get("occlusion_culling", true):
		return
	var layout: WorldLayout = world.layout
	var verts := PackedVector3Array()
	var idx := PackedInt32Array()
	for bi in layout.buildings_owned_by(coord):
		var b: Dictionary = layout.buildings[bi]
		var h := BuildingGen.total_height(b)
		if h < 5.0:
			continue
		var r: Rect2 = b["rect"]
		var base: float = b["base"]
		var r2 := r.grow(-0.4)
		var y0 := base + 0.2
		var y1 := base + h - 0.3
		var o := verts.size()
		for y: float in [y0, y1]:
			verts.append(Vector3(r2.position.x, y, r2.position.y))
			verts.append(Vector3(r2.end.x, y, r2.position.y))
			verts.append(Vector3(r2.end.x, y, r2.end.y))
			verts.append(Vector3(r2.position.x, y, r2.end.y))
		var q := [[0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7], [4, 5, 6, 7], [0, 3, 2, 1]]
		for f in q:
			idx.append(o + f[0]); idx.append(o + f[1]); idx.append(o + f[2])
			idx.append(o + f[0]); idx.append(o + f[2]); idx.append(o + f[3])
	if verts.is_empty():
		return
	var occ := ArrayOccluder3D.new()
	occ.set_arrays(verts, idx)
	var oi := OccluderInstance3D.new()
	oi.occluder = occ
	oi.name = "Occluders"
	add_child(oi)


func _step_trees(d: Dictionary) -> void:
	var trees: Dictionary = d.get("trees", {})
	var near_end := 95.0 * float(Settings.graphics.get("object_distance", 1.0))
	var far_end := Settings.get_tree_distance()
	for kind in trees.keys():
		var list: Array = trees[kind]
		if list.is_empty():
			continue
		if lod <= 1:
			var near := _multimesh(Vegetation.mesh(kind, 0), list, [], false)
			near.visibility_range_end = near_end
			near.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		var far := _multimesh(Vegetation.mesh(kind, 1), list, [], false)
		far.visibility_range_begin = near_end if lod <= 1 else 0.0
		far.visibility_range_end = far_end
		far.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if lod <= 1 and Settings.get_particle_multiplier() > 0.0:
		_falling_leaves(trees)


## Folhas soltando das copas e caindo girando (algumas árvores por chunk).
func _falling_leaves(trees: Dictionary) -> void:
	var n := 0
	for kind in ["broadleaf_big", "broadleaf"]:
		for xf: Transform3D in trees.get(kind, []):
			if n >= 3 or absi(Util.hash2(int(xf.origin.x * 3.0), int(xf.origin.z * 3.0), 51)) % 4 != 0:
				continue
			n += 1
			add_child(leaf_emitter(xf, kind))


## Lâmpadas do pisca-alerta nos quatro cantos do carro (frente em -Z).
static func _hazard_mesh(type: String) -> Mesh:
	return Assets.cached_mesh("hazard_" + type, func() -> Mesh:
		var dims := VehicleMeshBuilder.dims(type)
		var L := float(dims["L"])
		var hw := float(dims["W"]) * 0.5
		var deck := float(dims["deck"])
		var b := MeshBuf.new()
		for sg: float in [-1.0, 1.0]:
			b.box(Vector3(hw * 0.86 * sg, deck - 0.17, -L * 0.5 - 0.012), Vector3(0.15, 0.06, 0.03), 0.0)
			b.box(Vector3(hw * 0.97 * sg, deck - 0.2, -L * 0.5 + 0.2), Vector3(0.03, 0.05, 0.1), 0.0)
			b.box(Vector3(hw * 0.8 * sg, deck - 0.1, L * 0.5 + 0.012), Vector3(0.14, 0.06, 0.03), 0.0)
		var m := ShaderMaterial.new()
		m.shader = load("res://shaders/hazard_blink.gdshader")
		return b.to_mesh(m))


## Mastro com bandeira tremulando (frente de prédios públicos). `yaw` aponta o
## lado para onde o pano se estende.
static var _flag_mat: ShaderMaterial
static var _flag_mesh: PlaneMesh
const FLAG_H := 8.5


static func flag_node(pos: Vector3, yaw: float) -> Node3D:
	var root := Node3D.new()
	root.position = pos
	root.rotation.y = yaw
	var pole := MeshInstance3D.new()
	pole.mesh = Assets.cached_mesh("flag_pole", func() -> Mesh:
		var b := MeshBuf.new()
		var metal := Assets.uv2_code(Assets.L_METAL)
		b.cylinder(Transform3D.IDENTITY, 0.07, FLAG_H, 8, metal, 0.0, Color(0.85, 0.85, 0.84), true, 0.04)
		b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0, 0)), 0.2, 0.35, 8, Assets.uv2_code(Assets.L_CONCRETE), 0.0, Color(0.75, 0.74, 0.7), true, 0.16)
		b.box(Vector3(0, FLAG_H + 0.04, 0), Vector3(0.1, 0.08, 0.1), metal, 0.0, Color(0.7, 0.62, 0.3))
		return b.to_mesh(Assets.world_material("props")))
	root.add_child(pole)
	if _flag_mat == null:
		_flag_mat = ShaderMaterial.new()
		_flag_mat.shader = load("res://shaders/flag.gdshader")
		_flag_mesh = PlaneMesh.new()
		_flag_mesh.orientation = PlaneMesh.FACE_Z
		_flag_mesh.size = Vector2(1.95, 1.3)
		_flag_mesh.center_offset = Vector3(0.975, 0, 0)
		_flag_mesh.subdivide_width = 14
		_flag_mesh.subdivide_depth = 6
		_flag_mesh.material = _flag_mat
	var cloth := MeshInstance3D.new()
	cloth.mesh = _flag_mesh
	cloth.position = Vector3(0.06, FLAG_H - 0.75, 0)
	# a malha deforma no shader: caixa folgada para não sumir no recorte de visão
	cloth.custom_aabb = AABB(Vector3(-0.2, -1.5, -0.9), Vector3(2.5, 3.0, 1.8))
	cloth.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	root.add_child(cloth)
	pole.visibility_range_end = 220.0
	cloth.visibility_range_end = 160.0
	return root


static func leaf_emitter(xf: Transform3D, kind: String) -> GPUParticles3D:
	var s := xf.basis.get_scale().y
	var h := (9.0 if kind == "broadleaf_big" else 5.5) * 0.72 * s
	var cr := (4.2 if kind == "broadleaf_big" else 2.6) * s
	var lp := GPUParticles3D.new()
	lp.amount = maxi(4, int(12 * Settings.get_particle_multiplier()))
	# caem a ~0,8 m/s: vida = tempo até o chão
	lp.lifetime = clampf(h / 0.8, 4.0, 10.0)
	lp.preprocess = lp.lifetime
	lp.visibility_aabb = AABB(Vector3(-cr - 6, -h - 1, -cr - 6), Vector3(cr * 2 + 12, h + 3, cr * 2 + 12))
	var q := QuadMesh.new()
	q.size = Vector2(0.18, 0.18)
	q.material = Assets.leaf_particle_material()
	lp.draw_pass_1 = q
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(cr * 0.7, 0.4, cr * 0.7)
	pm.direction = Vector3(0.35, -1.0, 0.2)
	pm.spread = 30.0
	pm.initial_velocity_min = 0.55
	pm.initial_velocity_max = 0.85
	pm.gravity = Vector3(0.08, -0.06, 0.03)
	pm.angular_velocity_min = -160.0
	pm.angular_velocity_max = 160.0
	pm.scale_min = 0.7
	pm.scale_max = 1.3
	# folha: verde do pé, amarelada ou seca
	var grad := Gradient.new()
	grad.set_color(0, Color(0.45, 0.5, 0.22))
	grad.add_point(0.5, Color(0.66, 0.55, 0.22))
	grad.set_color(grad.get_point_count() - 1, Color(0.5, 0.33, 0.17))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_initial_ramp = gt
	lp.process_material = pm
	lp.position = xf.origin + Vector3(0, h, 0)
	lp.visibility_range_end = 70.0
	lp.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return lp


func _multimesh(mesh: Mesh, xforms: Array, colors: Array, _custom: bool) -> MultiMeshInstance3D:
	# O renderer Compatibility não expõe INSTANCE_CUSTOM de forma confiável:
	# usamos a cor da instância (COLOR já chega multiplicado no shader).
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = mesh
	mm.instance_count = xforms.size()
	for i in xforms.size():
		mm.set_instance_transform(i, xforms[i])
		if i < colors.size():
			var c: Color = colors[i]
			mm.set_instance_color(i, Color(c.r, c.g, c.b, 1.0))
		else:
			mm.set_instance_color(i, Color(1, 1, 1, 1))
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	add_child(mmi)
	return mmi


func _step_props(d: Dictionary) -> void:
	var props: Dictionary = d.get("props", {})
	var dd := Settings.get_detail_distance()
	for pn in props.keys():
		var e: Dictionary = props[pn]
		var mmi := _multimesh(PropLib.mesh(pn), e["xf"], e["col"], true)
		var big: bool = pn in ["lamp_post", "power_pole", "container", "bus_stop", "billboard", "radio_tower", "floodlight", "traffic_light", "wall_low"]
		mmi.visibility_range_end = dd * (2.6 if big else 1.4)
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if big else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var pc: Array = d.get("prop_colliders", [])
	if not pc.is_empty():
		_ensure_body()
		_add_boxes(body_rid, pc, shape_rids)
	# lâmpadas dos postes (emissivas, ligadas à rede)
	lamps = d.get("lamps", [])
	if not lamps.is_empty():
		var q := QuadMesh.new()
		q.size = Vector2(0.28, 0.5)
		q.orientation = PlaneMesh.FACE_Y
		q.material = Assets.power_emitter(0)
		var xfs: Array = []
		for p in lamps:
			xfs.append(Transform3D(Basis.IDENTITY, (p as Vector3) + Vector3(0, -0.07, 0)))
		var mmi := _multimesh(q, xfs, [], false)
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mmi.visibility_range_end = 400.0
	for fl in d.get("flags", []):
		add_child(flag_node(fl["pos"], float(fl["yaw"])))
	# letreiros
	for lb in d.get("labels", []):
		var l := Label3D.new()
		l.text = str(lb["text"])
		l.font_size = 48
		l.outline_size = 6
		l.pixel_size = float(lb["size"]) / 48.0
		l.modulate = Color(0.92, 0.9, 0.84)
		l.outline_modulate = Color(0.05, 0.05, 0.05, 0.9)
		l.shaded = true
		l.double_sided = false
		l.position = lb["pos"]
		l.rotation.y = float(lb["yaw"])
		l.visibility_range_end = 90.0 if float(lb["size"]) < 0.6 else 220.0
		l.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(l)


func _step_grass(d: Dictionary) -> void:
	var g: Array = d.get("grass", [])
	if g.is_empty():
		return
	var xfs: Array = []
	var cols: Array = []
	for e in g:
		xfs.append(e[0])
		cols.append(e[1])
	var mmi := _multimesh(Vegetation.grass_mesh(), xfs, cols, true)
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mmi.visibility_range_end = Settings.get_grass_distance() + 6.0
	mmi.name = "Grass"


# ---------------------------------------------------------------------------
# Camada de fase
# ---------------------------------------------------------------------------
func _free_phase() -> void:
	for s in phase_shapes:
		PhysicsServer3D.free_rid(s)
	phase_shapes.clear()
	if phase_body.is_valid():
		PhysicsServer3D.free_rid(phase_body)
		phase_body = RID()
	if phase_node and is_instance_valid(phase_node):
		phase_node.queue_free()
	phase_node = null


func apply_phase(p: Dictionary, phase: int) -> void:
	_free_phase()
	phase_built = phase
	phase_node = Node3D.new()
	phase_node.name = "Phase"
	add_child(phase_node)
	var props: Dictionary = p.get("props", {})
	for pn in props.keys():
		var e: Dictionary = props[pn]
		var mmi := _multimesh(PropLib.mesh(pn), e["xf"], e["col"], true)
		remove_child(mmi)
		phase_node.add_child(mmi)
		mmi.visibility_range_end = Settings.get_detail_distance() * 1.6
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# carros estáticos por tipo (instâncias com cor)
	cars = []
	var by_type := {}
	for car in p.get("cars", []):
		if world != null and world.has_method("is_car_claimed") and world.is_car_claimed(str(car["uid"])):
			continue
		cars.append(car)
		# aparência: limpo antes do surto; empoeirado, destruído ou queimado depois
		var look := "clean"
		if phase != GameState.Phase.PRE:
			look = "dusty"
			if car["state"] == "burned":
				look = "burned"
			elif car["state"] == "abandoned" and absi(Util.hash_str(str(car["uid"]))) % 10 < 6:
				look = "wreck"
			# alguns destroços tombados de lado ou capotados
			var hv := absi(Util.hash_str(str(car["uid"]) + "roll"))
			if look == "wreck" and hv % 9 == 0 and str(car["type"]) in ["compact", "sedan", "hatch", "suv", "pickup"]:
				car["roll"] = PI * 0.5 * (1.0 if hv % 2 == 0 else -1.0)
			elif look == "burned" and hv % 7 == 0 and str(car["type"]) in ["compact", "sedan", "hatch"]:
				car["roll"] = PI
		var key := str(car["type"]) + "|" + look
		if not by_type.has(key):
			by_type[key] = []
		by_type[key].append(car)
	for key in by_type.keys():
		var list: Array = by_type[key]
		var parts := str(key).split("|")
		var type := parts[0]
		var look := parts[1]
		var burned := look == "burned"
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_colors = true
		mm.mesh = VehicleMeshBuilder.mesh(type, burned, true, look)
		mm.instance_count = list.size()
		for i in list.size():
			var car: Dictionary = list[i]
			var dims := VehicleMeshBuilder.dims(type)
			var roll := float(car.get("roll", 0.0))
			var car_basis := Basis(Vector3.UP, float(car["yaw"])) * Basis(Vector3.RIGHT, float(car.get("pitch", 0.0))) * Basis(Vector3.BACK, roll)
			var cpos: Vector3 = car["pos"]
			if absf(roll) > 3.0:
				cpos.y += float(dims["roof"]) - 0.12      # capotado: apoiado no teto amassado
			elif absf(roll) > 1.0:
				cpos.y += float(dims["W"]) * 0.5          # de lado
			mm.set_instance_transform(i, Transform3D(car_basis, cpos))
			var col: Color = car["color"]
			if phase == GameState.Phase.POST and not burned:
				col = col.lerp(Color(0.35, 0.32, 0.28), 0.18)
			mm.set_instance_color(i, col)
			var sz := Vector3(float(dims["W"]), float(dims["roof"]) * 0.8, float(dims["L"]))
			p["colliders"].append([Transform3D(car_basis, cpos + car_basis * Vector3(0, sz.y * 0.5, 0)), sz])
		var mmi := MultiMeshInstance3D.new()
		mmi.multimesh = mm
		mmi.visibility_range_end = 260.0
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		phase_node.add_child(mmi)
	var vines: Array = p.get("vines", [])
	if not vines.is_empty():
		var mmi := _multimesh(Vegetation.mesh("vine", 0), vines, [], false)
		remove_child(mmi)
		phase_node.add_child(mmi)
		mmi.visibility_range_end = 120.0
		mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if phase == GameState.Phase.POST and Settings.get_particle_multiplier() > 0.0:
		_ambient_fx(by_type)
		# fogueira de acampamento abandonado: brasas ainda soltando um fio de fumaça
		if props.has("campfire"):
			for fxf: Transform3D in props["campfire"]["xf"]:
				phase_node.add_child(_smoke_emitter(fxf.origin + Vector3(0, 0.25, 0), 6, 0.8, Color(0.55, 0.55, 0.55, 0.3), 0.3, 0.55))
	var cols: Array = p.get("colliders", [])
	if not cols.is_empty():
		phase_body = PhysicsServer3D.body_create()
		PhysicsServer3D.body_set_mode(phase_body, PhysicsServer3D.BODY_MODE_STATIC)
		PhysicsServer3D.body_set_space(phase_body, _space())
		PhysicsServer3D.body_set_collision_layer(phase_body, 1)
		PhysicsServer3D.body_set_collision_mask(phase_body, 0)
		_add_boxes(phase_body, cols, phase_shapes)


## Coluna de fumaça (carro queimado ainda fumegando, brasas de fogueira).
static func _smoke_emitter(pos: Vector3, amount: int, size: float, col: Color, v0: float, v1: float) -> GPUParticles3D:
	var sm := GPUParticles3D.new()
	sm.amount = maxi(4, int(amount * Settings.get_particle_multiplier()))
	sm.lifetime = 7.0
	sm.preprocess = 7.0
	sm.visibility_aabb = AABB(Vector3(-6, -1, -6), Vector3(12, 16, 12))
	var q := QuadMesh.new()
	q.size = Vector2(size, size)
	q.material = Assets.particle_material(Assets.SPR_SMOKE, col)
	sm.draw_pass_1 = q
	var pm := ParticleProcessMaterial.new()
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = 0.35 * size / 1.4
	pm.direction = Vector3(0, 1, 0)
	pm.spread = 12.0
	pm.initial_velocity_min = v0
	pm.initial_velocity_max = v1
	pm.gravity = Vector3(0.25, 0.18, 0.1)
	pm.scale_min = 0.7
	pm.scale_max = 2.6
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 0.0))
	grad.add_point(0.15, Color(1, 1, 1, 0.55))
	grad.set_color(grad.get_point_count() - 1, Color(1, 1, 1, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	sm.process_material = pm
	sm.position = pos
	sm.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return sm


## Detalhes vivos depois do surto: fiapo de fumaça em alguns carros queimados
## (ainda fumegando) e papéis rolando com o vento nas ruas da cidade.
func _ambient_fx(by_type: Dictionary) -> void:
	var smokes := 0
	for key in by_type.keys():
		if not str(key).ends_with("|burned"):
			continue
		for car in by_type[key]:
			if smokes >= 2 or absi(Util.hash_str(str(car["uid"]) + "fumo")) % 3 != 0:
				continue
			smokes += 1
			phase_node.add_child(_smoke_emitter((car["pos"] as Vector3) + Vector3(0, 0.9, 0), 10, 1.4, Color(0.22, 0.21, 0.2, 0.42), 0.5, 0.9))
	# pisca-alerta: alguns carros abandonados ainda piscando (bateria viva)
	var blinks := 0
	for key in by_type.keys():
		var kp := str(key).split("|")
		if kp[1] == "burned" or kp[1] == "clean" or kp[0] == "bus":
			continue
		for car in by_type[key]:
			if blinks >= 2 or absf(float(car.get("roll", 0.0))) > 0.1 or absi(Util.hash_str(str(car["uid"]) + "pisca")) % 6 != 0:
				continue
			blinks += 1
			var mi := MeshInstance3D.new()
			mi.name = "Pisca"
			mi.mesh = _hazard_mesh(kp[0])
			mi.transform = Transform3D(Basis(Vector3.UP, float(car["yaw"])) * Basis(Vector3.RIGHT, float(car.get("pitch", 0.0))), car["pos"])
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			mi.visibility_range_end = 220.0
			phase_node.add_child(mi)
	# papéis ao vento (só na cidade, um emissor por chunk)
	var c := Vector3((coord.x + 0.5) * WorldLayout.CHUNK, 0, (coord.y + 0.5) * WorldLayout.CHUNK)
	if not WorldLayout.URBAN.has_point(Vector2(c.x, c.z)) or absi(Util.hash2(coord.x, coord.y, 77)) % 2 != 0:
		return
	var pp := GPUParticles3D.new()
	pp.amount = maxi(3, int(7 * Settings.get_particle_multiplier()))
	pp.lifetime = 6.0
	pp.preprocess = 6.0
	pp.visibility_aabb = AABB(Vector3(-40, -1, -40), Vector3(80, 8, 80))
	var q2 := QuadMesh.new()
	q2.size = Vector2(0.28, 0.2)
	q2.material = Assets.particle_material(Assets.SPR_PAPER, Color(0.85, 0.83, 0.78, 1.0))
	pp.draw_pass_1 = q2
	var pm2 := ParticleProcessMaterial.new()
	pm2.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm2.emission_box_extents = Vector3(WorldLayout.CHUNK * 0.45, 0.1, WorldLayout.CHUNK * 0.45)
	pm2.direction = Vector3(1, 0.35, 0.3)
	pm2.spread = 35.0
	pm2.initial_velocity_min = 1.2
	pm2.initial_velocity_max = 3.0
	pm2.gravity = Vector3(0.4, -0.9, 0.2)
	pm2.angular_velocity_min = -220.0
	pm2.angular_velocity_max = 220.0
	pp.process_material = pm2
	pp.position = c + Vector3(0, WorldLayout.CURB + 0.15, 0)
	pp.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	phase_node.add_child(pp)


# ---------------------------------------------------------------------------
# Interiores
# ---------------------------------------------------------------------------
func has_interior(bi: int) -> bool:
	return interiors.has(bi)


func _free_interior(bi: int) -> void:
	if not interiors.has(bi):
		return
	var e: Dictionary = interiors[bi]
	for s in e["shapes"]:
		PhysicsServer3D.free_rid(s)
	if (e["body"] as RID).is_valid():
		PhysicsServer3D.free_rid(e["body"])
	var n: Node = e["node"]
	if is_instance_valid(n):
		n.queue_free()


func remove_interior(bi: int) -> void:
	_free_interior(bi)
	interiors.erase(bi)


func apply_interior(bi: int, idata: Dictionary, b: Dictionary) -> Node3D:
	var root := Node3D.new()
	root.name = "Interior_%d" % bi
	add_child(root)
	var mesh: MeshBuf = idata["mesh"]
	if not mesh.is_empty():
		# em pedaços de ~8 m por andar: cada pedaço só recebe as luzes perto dele
		# (janelas, lanterna) e o renderer Compatibility tem limite de luzes por malha
		var parts: Dictionary = idata.get("mesh_parts", {})
		if parts.is_empty():
			parts = {0: mesh}
		for k in parts.keys():
			var mi := MeshInstance3D.new()
			mi.mesh = (parts[k] as MeshBuf).to_mesh()
			mi.material_override = Assets.world_material("interior")
			# forro e paredes têm uma face só: sombra dos dois lados, senão o sol atravessa o teto
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
			root.add_child(mi)
	var glass: MeshBuf = idata["glass"]
	if not glass.is_empty():
		var gi := MeshInstance3D.new()
		gi.mesh = glass.to_mesh()
		gi.material_override = Assets.glass_material(0.0, 0.25)
		gi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		gi.name = "Glass"
		root.add_child(gi)
	var panes: MeshBuf = idata["panes"]
	if not panes.is_empty():
		var pi := MeshInstance3D.new()
		pi.mesh = panes.to_mesh()
		pi.material_override = Assets.window_light_material()
		pi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		root.add_child(pi)
	var body := PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_mode(body, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_set_space(body, _space())
	PhysicsServer3D.body_set_collision_layer(body, 1)
	PhysicsServer3D.body_set_collision_mask(body, 0)
	var shapes: Array = []
	_add_boxes(body, mesh.colliders, shapes)
	interiors[bi] = {"node": root, "body": body, "shapes": shapes, "markers": idata.get("markers", {}), "data": idata}
	return root
