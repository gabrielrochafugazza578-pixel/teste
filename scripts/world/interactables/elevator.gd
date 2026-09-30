class_name Elevator
extends Interactable
## Elevador de serviço do laboratório para o Setor 7 (subsolo isolado).
## Requer a Chave Aurora. A transição usa fade curto (viagem de elevador).

var target: String = "setor7"
var required_key: String = "setor7"


func setup(pos: Vector3, yaw: float, tgt: String, key: String) -> void:
	position = pos
	rotation.y = yaw
	target = tgt
	required_key = key
	uid = "elevator_" + tgt
	target_id = "elevator_" + tgt
	add_shape(Vector3(2.0, 2.4, 1.2), Vector3(0, 1.2, 0))
	prompt = "Elevador de serviço"


func get_prompt(player: Node) -> String:
	if required_key != "" and player and player.has_method("has_key") and not player.has_key(required_key):
		return "Elevador de serviço — requer autorização"
	return "Descer ao Setor 7" if target == "setor7" else "Subir"


func interact(player: Node) -> void:
	super.interact(player)
	if required_key != "" and player and player.has_method("has_key") and not player.has_key(required_key):
		AudioManager.play_3d("door_locked", global_position)
		EventBus.toast("Leitor pisca em vermelho: ACESSO NEGADO.", "warn")
		return
	EventBus.elevator_requested.emit(target, self)
