class_name ItemPickup
extends Interactable
## Item solto no mundo (chão, mesas, largado pelo jogador ou por NPCs).

var stack: Dictionary = {}
var dropped: bool = false
var mesh_node: MeshInstance3D


func setup(s: Dictionary, pos: Vector3, was_dropped: bool = false, yaw: float = INF) -> void:
	stack = s.duplicate(true)
	dropped = was_dropped
	position = pos
	add_to_group("item_pickup")
	var id := str(stack["id"])
	mesh_node = MeshInstance3D.new()
	mesh_node.mesh = ItemModels.mesh(id)
	mesh_node.rotation.y = randf() * TAU if yaw == INF else yaw
	mesh_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mesh_node)
	# área de interação do tamanho do objeto (mínimo para ser fácil de mirar)
	var aabb := mesh_node.mesh.get_aabb()
	var hs := maxf(aabb.size.x, aabb.size.z)
	var sz := Vector3(clampf(hs + 0.2, 0.45, 1.3), clampf(aabb.size.y + 0.25, 0.35, 0.8), clampf(hs + 0.2, 0.45, 1.3))
	add_shape(sz, Vector3(0, sz.y * 0.5 - 0.05, 0))
	var q := int(stack.get("qty", 1))
	prompt = "Pegar %s%s" % [ItemDB.item_name(id), (" x%d" % q) if q > 1 else ""]


## Nome curto + quantidade (painel "Itens por perto").
func label_text() -> String:
	var q := int(stack.get("qty", 1))
	return "%s%s" % [ItemDB.item_name(str(stack["id"])), (" x%d" % q) if q > 1 else ""]


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
