class_name Interactable
extends Area3D
## Base de tudo que o jogador pode usar com [E]. A detecção é feita pela
## área do jogador (camada física 6 "interact"), sem varreduras por frame.

var uid: String = ""
var prompt: String = "Interagir"
var enabled: bool = true
var target_id: String = ""   # usado por missões (objetivo "interagir com X")


func _init() -> void:
	collision_layer = 1 << 5
	collision_mask = 0
	monitoring = false
	monitorable = true
	add_to_group("interactable")


func add_shape(size: Vector3, offset: Vector3 = Vector3.ZERO) -> void:
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	cs.shape = box
	cs.position = offset
	add_child(cs)


func get_prompt(_player: Node) -> String:
	return prompt


func can_interact(_player: Node) -> bool:
	return enabled


## Tempo (s) segurando [E]. 0 = instantâneo.
func hold_time(_player: Node) -> float:
	return 0.0


func interact(_player: Node) -> void:
	if target_id != "":
		EventBus.interacted.emit(target_id)
