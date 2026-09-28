class_name StoryObject
extends Interactable
## Registros da narrativa: gravações da Dra. Helena, bilhetes, documentos e
## itens-chave. Ao interagir, o StoryManager registra e reproduz o conteúdo.

var story_id: String = ""
var kind: String = "audio"   # audio | note | item
var item_id: String = ""
var blink: MeshInstance3D
var _t: float = 0.0


func setup(id: String, k: String, pos: Vector3, yaw: float = 0.0, item: String = "") -> void:
	story_id = id
	kind = k
	item_id = item
	uid = "story_" + id
	position = pos
	rotation.y = yaw
	add_shape(Vector3(0.7, 0.6, 0.7), Vector3(0, 0.15, 0))
	var mi := MeshInstance3D.new()
	mi.mesh = _mesh(k)
	add_child(mi)
	match k:
		"audio":
			prompt = "Ouvir gravação"
			blink = MeshInstance3D.new()
			var s := SphereMesh.new()
			s.radius = 0.012
			s.height = 0.024
			s.radial_segments = 6
			s.rings = 3
			blink.mesh = s
			blink.material_override = Assets.emissive(Color(1.0, 0.15, 0.1), 3.0)
			blink.position = Vector3(0.05, 0.065, -0.05)
			add_child(blink)
			set_process(true)
		"note":
			prompt = "Ler"
			set_process(false)
		_:
			prompt = "Pegar " + ItemDB.item_name(item)
			set_process(false)


static func _mesh(k: String) -> Mesh:
	return Assets.cached_mesh("story_" + k, func() -> Mesh:
		var b := MeshBuf.new()
		match k:
			"audio":
				b.box(Vector3(0, 0.03, 0), Vector3(0.16, 0.06, 0.24), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.15, 0.15, 0.17))
				b.box(Vector3(0, 0.061, 0.03), Vector3(0.12, 0.002, 0.1), Assets.uv2_code(Assets.L_TILES), 0.0, Color(0.05, 0.05, 0.05))
			"note":
				b.box(Vector3(0, 0.003, 0), Vector3(0.21, 0.005, 0.29), Assets.uv2_code(Assets.L_PLASTER), 0.0, Color(0.95, 0.94, 0.88))
			_:
				b.box(Vector3(0, 0.02, 0), Vector3(0.12, 0.04, 0.08), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.7, 0.65, 0.4))
		return b.to_mesh(Assets.world_material("props_interior")))


func _process(delta: float) -> void:
	_t += delta
	if blink:
		blink.visible = fmod(_t, 1.2) < 0.25


func interact(player: Node) -> void:
	super.interact(player)
	StoryManager.collect(story_id, kind, item_id, player)
	queue_free()
