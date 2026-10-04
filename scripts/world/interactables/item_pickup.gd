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


## Item largado agora (não o restaurado do save): cai da mão até o chão com um quique.
func animate_drop(from_height: float = 0.85) -> void:
	if mesh_node == null:
		return
	mesh_node.position.y = from_height
	var spin := mesh_node.rotation.y
	mesh_node.rotation = Vector3(randf_range(-0.6, 0.6), spin - 0.8, randf_range(-0.6, 0.6))
	var tw := create_tween()
	tw.tween_property(mesh_node, "position:y", 0.0, 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.parallel().tween_property(mesh_node, "rotation", Vector3(0.0, spin, 0.0), 0.32)
	tw.tween_property(mesh_node, "position:y", 0.06, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(mesh_node, "position:y", 0.0, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


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
		_fly_to(player)
	else:
		stack["qty"] = left
		EventBus.toast("Sem espaço no inventário.", "warn")


## Pegar: o objeto voa até a mão do Caio e some (em vez de sumir na hora).
func _fly_to(player: Node) -> void:
	enabled = false
	remove_from_group("item_pickup")
	for c in get_children():
		if c is CollisionShape3D:
			(c as CollisionShape3D).set_deferred("disabled", true)
	if mesh_node == null or not (player is Node3D):
		queue_free()
		return
	var pl := player as Node3D
	var hand := pl.global_position + Vector3(0, 1.05, 0) + (-pl.global_transform.basis.z) * 0.35
	var start := mesh_node.global_position
	var tw := create_tween()
	tw.tween_method(func(k: float) -> void:
		if not is_instance_valid(mesh_node):
			return
		# arco: sobe um pouco no meio do caminho
		var p := start.lerp(hand, k) + Vector3(0, sin(k * PI) * 0.25, 0)
		mesh_node.global_position = p
		mesh_node.scale = Vector3.ONE * lerpf(1.0, 0.25, k * k), 0.0, 1.0, 0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_callback(queue_free)
