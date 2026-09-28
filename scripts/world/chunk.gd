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
		var burned: bool = car["state"] == "burned"
		var key := str(car["type"]) + ("_b" if burned else "")
		if not by_type.has(key):
			by_type[key] = []
		by_type[key].append(car)
	for key in by_type.keys():
		var list: Array = by_type[key]
		var burned := str(key).ends_with("_b")
		var type := str(key).trim_suffix("_b")
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_colors = true
		mm.mesh = VehicleMeshBuilder.mesh(type, burned)
		mm.instance_count = list.size()
		for i in list.size():
			var car: Dictionary = list[i]
			mm.set_instance_transform(i, Transform3D(Basis(Vector3.UP, float(car["yaw"])), car["pos"]))
			var col: Color = car["color"]
			if burned:
				col = Color(0.12, 0.1, 0.09)
			elif phase == GameState.Phase.POST:
				col = col.lerp(Color(0.35, 0.32, 0.28), 0.35)
			mm.set_instance_color(i, col)
			var dims := VehicleMeshBuilder.dims(type)
			var sz := Vector3(float(dims["W"]), float(dims["roof"]) * 0.8, float(dims["L"]))
			p["colliders"].append([Transform3D(Basis(Vector3.UP, float(car["yaw"])), (car["pos"] as Vector3) + Vector3(0, sz.y * 0.5, 0)), sz])
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
	var cols: Array = p.get("colliders", [])
	if not cols.is_empty():
		phase_body = PhysicsServer3D.body_create()
		PhysicsServer3D.body_set_mode(phase_body, PhysicsServer3D.BODY_MODE_STATIC)
		PhysicsServer3D.body_set_space(phase_body, _space())
		PhysicsServer3D.body_set_collision_layer(phase_body, 1)
		PhysicsServer3D.body_set_collision_mask(phase_body, 0)
		_add_boxes(phase_body, cols, phase_shapes)


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
		var mi := MeshInstance3D.new()
		mi.mesh = mesh.to_mesh()
		mi.material_override = Assets.world_material("interior")
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
