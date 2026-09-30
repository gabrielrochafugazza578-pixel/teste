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
