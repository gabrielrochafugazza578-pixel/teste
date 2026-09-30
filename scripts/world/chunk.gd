class_name Chunk
extends Node3D
## Um pedaco 16x16 do mundo: malha do terreno, colisao e decoracoes.

var key: Vector2i
var dens: PackedFloat32Array
var mats: PackedByteArray
var ymin: int
var ymax: int
var mesh_data: Dictionary
var version := 0            # aumenta a cada modificacao (descarta remeshes antigos)
var remesh_pending := false

var mesh_instance: MeshInstance3D
var body: StaticBody3D
var shape_node: CollisionShape3D
var collision_enabled := false
var collision_dirty := true


func setup(k: Vector2i) -> void:
	key = k
	name = "Chunk_%d_%d" % [k.x, k.y]
	position = Vector3(k.x * WorldGen.N, 0.0, k.y * WorldGen.N)
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)


func apply_mesh(mesh: ArrayMesh, data: Dictionary) -> void:
	mesh_instance.mesh = mesh
	mesh_data = data
	collision_dirty = true


## Cria/atualiza a colisao. Retorna true se fez trabalho pesado.
func update_collision(want: bool) -> bool:
	if not want:
		if collision_enabled and body:
			body.process_mode = Node.PROCESS_MODE_DISABLED
			shape_node.disabled = true
		collision_enabled = false
		return false
	var worked := false
	if body == null:
		body = StaticBody3D.new()
		body.collision_layer = 1
		shape_node = CollisionShape3D.new()
		body.add_child(shape_node)
		add_child(body)
	if collision_dirty:
		var faces := ChunkMesher.collision_faces(mesh_data)
		if faces.is_empty():
			shape_node.shape = null
		else:
			var shape := ConcavePolygonShape3D.new()
			shape.set_faces(faces)
			shape_node.shape = shape
		collision_dirty = false
		worked = true
	body.process_mode = Node.PROCESS_MODE_INHERIT
	shape_node.disabled = false
	collision_enabled = true
	return worked


# ------------------------------------------------------------ decoracoes --

var deco_data: PackedFloat32Array
var deco_removed: Dictionary = {}
var deco_nodes: Array = []
var deco_body: StaticBody3D


func set_decorations(data: PackedFloat32Array, removed: Dictionary) -> void:
	deco_data = data
	deco_removed = removed
	_rebuild_deco_meshes()


func deco_count() -> int:
	return deco_data.size() / WorldGen.DECO_STRIDE


func deco_type(i: int) -> int:
	return int(deco_data[i * WorldGen.DECO_STRIDE])


## Posicao global da decoracao i.
func deco_position(i: int) -> Vector3:
	var o := i * WorldGen.DECO_STRIDE
	return position + Vector3(deco_data[o + 1], deco_data[o + 2], deco_data[o + 3])


func _deco_transform(i: int) -> Transform3D:
	var o := i * WorldGen.DECO_STRIDE
	var b := Basis(Vector3.UP, deco_data[o + 4]).scaled(Vector3.ONE * deco_data[o + 5])
	return Transform3D(b, Vector3(deco_data[o + 1], deco_data[o + 2], deco_data[o + 3]))


func _rebuild_deco_meshes() -> void:
	for n in deco_nodes:
		n.queue_free()
	deco_nodes.clear()
	var per_type := {}
	for i in deco_count():
		if deco_removed.has(i):
			continue
		var t := deco_type(i)
		if not per_type.has(t):
			per_type[t] = []
		per_type[t].append(i)
	var S := WorldGen.DECO_STRIDE
	for t in per_type:
		var list: Array = per_type[t]
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_custom_data = true
		mm.mesh = Deco.mesh(t)
		mm.instance_count = list.size()
		for j in list.size():
			var i: int = list[j]
			mm.set_instance_transform(j, _deco_transform(i))
			var o: int = i * S
			mm.set_instance_custom_data(j, Color(deco_data[o + 6], deco_data[o + 7], deco_data[o + 8], deco_data[o + 9]))
		var mmi := MultiMeshInstance3D.new()
		mmi.multimesh = mm
		if t == Deco.GRASS or t == Deco.FLOWER or t == Deco.MUSHROOM_GLOW or t == Deco.DEAD_BUSH:
			mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			mmi.visibility_range_end = 75.0
		add_child(mmi)
		deco_nodes.append(mmi)


## Colisao dos troncos/pedras (so perto do jogador).
func update_deco_collision(want: bool) -> void:
	if not want:
		if deco_body:
			deco_body.queue_free()
			deco_body = null
		return
	if deco_body:
		return
	deco_body = StaticBody3D.new()
	deco_body.collision_layer = 1
	deco_body.set_meta("chunk", self)
	for i in deco_count():
		if deco_removed.has(i):
			continue
		var t := deco_type(i)
		if not Deco.COLLIDERS.has(t):
			continue
		var c: Vector2 = Deco.COLLIDERS[t]
		var o := i * WorldGen.DECO_STRIDE
		var sc := deco_data[o + 5]
		var shape := CylinderShape3D.new()
		shape.radius = c.x * sc
		shape.height = c.y * sc
		var cs := CollisionShape3D.new()
		cs.shape = shape
		cs.position = Vector3(deco_data[o + 1], deco_data[o + 2] + c.y * sc * 0.5, deco_data[o + 3])
		cs.set_meta("deco_index", i)
		deco_body.add_child(cs)
	add_child(deco_body)


## Remove uma decoracao (arvore cortada, pedra quebrada...).
func remove_deco(i: int) -> void:
	deco_removed[i] = true
	_rebuild_deco_meshes()
	if deco_body:
		for cs in deco_body.get_children():
			if cs.get_meta("deco_index", -1) == i:
				cs.queue_free()
