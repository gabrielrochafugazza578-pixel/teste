class_name CanAlarm
extends Area3D
## Alarme de latas: quando um infectado ou NPC hostil cruza o fio, faz
## barulho (atrai outros infectados, mas avisa o jogador).

var _cd: float = 0.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = (1 << 2) | (1 << 3)
	monitoring = true
	monitorable = false
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(2.0, 1.2, 0.6)
	cs.shape = box
	cs.position = Vector3(0, 0.6, 0)
	add_child(cs)
	body_entered.connect(_on_body)


func _process(delta: float) -> void:
	_cd = maxf(0.0, _cd - delta)


func _on_body(b: Node) -> void:
	if _cd > 0.0 or b.is_in_group("player"):
		return
	_cd = 4.0
	AudioManager.play_3d("can_rattle", global_position, 2.0)
	EventBus.make_noise(global_position, 30.0, self, &"alarm")
	EventBus.toast("Alarme de latas disparou!", "warn")
