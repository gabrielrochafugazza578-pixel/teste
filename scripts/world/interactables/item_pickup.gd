class_name ItemPickup
extends Interactable
## Item solto no mundo (chão, mesas, largado pelo jogador ou por NPCs).

var stack: Dictionary = {}
var dropped: bool = false
var mesh_node: MeshInstance3D


func setup(s: Dictionary, pos: Vector3, was_dropped: bool = false) -> void:
	stack = s.duplicate(true)
	dropped = was_dropped
	position = pos
	add_shape(Vector3(0.6, 0.5, 0.6), Vector3(0, 0.2, 0))
	mesh_node = MeshInstance3D.new()
	mesh_node.mesh = _mesh_for(ItemDB.category(str(stack["id"])))
	mesh_node.rotation.y = randf() * TAU
	mesh_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mesh_node)
	var q := int(stack.get("qty", 1))
	prompt = "Pegar %s%s" % [ItemDB.item_name(str(stack["id"])), (" x%d" % q) if q > 1 else ""]


static func _mesh_for(cat: String) -> Mesh:
	return Assets.cached_mesh("pickup_" + cat, func() -> Mesh:
		var b := MeshBuf.new()
		var col: Color = ItemDB.CAT_COLORS.get(cat, Color(0.6, 0.6, 0.6))
		match cat:
			"comida", "bebida":
				b.cylinder(Transform3D.IDENTITY, 0.045, 0.12, 8, Assets.uv2_code(Assets.L_METAL), 0.0, col)
				b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0.1, 0, 0.04)), 0.035, 0.2, 8, Assets.uv2_code(Assets.L_TILES), 0.0, col.lightened(0.3))
			"medicamento":
				b.box(Vector3(0, 0.05, 0), Vector3(0.18, 0.1, 0.12), Assets.uv2_code(Assets.L_PLASTER), 0.0, Color(0.9, 0.9, 0.9))
				b.box(Vector3(0, 0.101, 0), Vector3(0.08, 0.002, 0.03), Assets.uv2_code(Assets.L_PLASTER), 0.0, Color(0.8, 0.1, 0.1))
			"arma", "ferramenta":
				b.box(Vector3(0, 0.03, 0), Vector3(0.7, 0.05, 0.08), Assets.uv2_code(Assets.L_METAL), 0.0, col)
				b.box(Vector3(-0.25, 0.04, 0), Vector3(0.2, 0.06, 0.1), Assets.uv2_code(Assets.L_WOOD), 0.0, Color(0.4, 0.3, 0.2))
			"historia":
				b.box(Vector3(0, 0.01, 0), Vector3(0.21, 0.01, 0.29), Assets.uv2_code(Assets.L_PLASTER), 0.0, Color(0.95, 0.93, 0.85))
			_:
				b.box(Vector3(0, 0.08, 0), Vector3(0.25, 0.16, 0.2), Assets.uv2_code(Assets.L_FABRIC), 0.0, col)
		return b.to_mesh(Assets.world_material("props_interior")))


func interact(player: Node) -> void:
	super.interact(player)
	if player == null or not player.has_method("give_stack"):
		return
	var left: int = player.give_stack(stack)
	if left <= 0:
		if dropped:
			GameState.remove_dropped_near(global_position, str(stack["id"]))
		else:
			GameState.set_flag("picked_" + uid, true)
		queue_free()
	else:
		stack["qty"] = left
		EventBus.toast("Sem espaço no inventário.", "warn")
