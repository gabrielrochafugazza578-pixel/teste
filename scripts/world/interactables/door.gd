class_name Door
extends Interactable
## Porta física: dobradiça, correr (laboratório/lojas) ou enrolar (galpões).
## Estados persistentes: aberta, trancada, barricada (pontos), quebrada.
## Infectados podem golpear portas (bash) — barricadas compram tempo.

var kind: String = "hinged"
var width: float = 0.95
var height: float = 2.15
var is_open: bool = false
var locked: bool = false
var lock_key: String = ""
var barricade: float = 0.0
var hp: float = 100.0
var broken: bool = false
var pivot: Node3D
var panel: MeshInstance3D
var body: AnimatableBody3D
var _tween: Tween
var _open_amount: float = 0.0
## lado para onde a folha gira (+1/-1): sempre para longe de quem abre, senão a
## porta varre a pessoa e a empurra contra a parede ao lado do batente
var _swing: float = -1.0


func setup(d: Dictionary) -> void:
	uid = str(d.get("uid", ""))
	kind = str(d.get("kind", "hinged"))
	width = float(d.get("width", 0.95))
	height = float(d.get("height", 2.15))
	locked = bool(d.get("locked", false))
	lock_key = str(d.get("key", ""))
	if d.has("name"):
		target_id = "door_" + str(d["name"])
	position = d["pos"]
	rotation.y = float(d["yaw"])
	pivot = Node3D.new()
	add_child(pivot)
	panel = MeshInstance3D.new()
	panel.mesh = _panel_mesh()
	pivot.add_child(panel)
	body = AnimatableBody3D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	# sync_to_physics=true não acompanha o movimento do nó pai (pivot): a folha
	# abria na tela e a colisão ficava fechada no batente — parede invisível
	# na porta. Sem sincronizar, o corpo segue a transformação na hora.
	body.sync_to_physics = false
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(width, height, 0.08)
	cs.shape = box
	body.add_child(cs)
	pivot.add_child(body)
	if kind == "hinged":
		pivot.position = Vector3(-width * 0.5, 0, 0)
		panel.position = Vector3(width * 0.5, height * 0.5, 0)
		body.position = panel.position
	else:
		panel.position = Vector3(0, height * 0.5, 0)
		body.position = panel.position
	add_shape(Vector3(width + 0.6, height, 1.6), Vector3(0, height * 0.5, 0))
	var st := GameState.door_state(uid)
	if not st.is_empty():
		locked = bool(st.get("locked", locked))
		barricade = float(st.get("barricade", 0.0))
		broken = bool(st.get("broken", false))
		hp = float(st.get("hp", 100.0))
		_swing = float(st.get("swing", -1.0))
		if bool(st.get("open", false)) or broken:
			_set_open_amount(1.0)
			is_open = true
	_update_prompt()


func _panel_mesh() -> Mesh:
	var key := "door_%s_%.2f_%.2f" % [kind, width, height]
	return Assets.cached_mesh(key, func() -> Mesh:
		var b := MeshBuf.new()
		var code := Assets.uv2_code(Assets.L_WOOD)
		var col := Color(0.55, 0.42, 0.3)
		if kind == "sliding":
			code = Assets.uv2_code(Assets.L_METAL)
			col = Color(0.75, 0.78, 0.8)
		elif kind == "roller":
			code = Assets.uv2_code(Assets.L_METAL)
			col = Color(0.6, 0.62, 0.6)
		b.box(Vector3.ZERO, Vector3(width, height, 0.05), code, 0.2, col)
		if kind == "hinged":
			b.box(Vector3(width * 0.38, -0.05, -0.04), Vector3(0.12, 0.03, 0.03), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.7, 0.7, 0.65))
		return b.to_mesh(Assets.world_material("interior")))


func get_prompt(player: Node) -> String:
	_update_prompt()
	return prompt


func _update_prompt() -> void:
	if broken:
		prompt = "Porta quebrada"
	elif barricade > 0.0:
		prompt = "Remover barricada (%d%%)" % int(barricade)
	elif locked and not is_open:
		prompt = "Trancada" + (" — usar chave" if lock_key != "" else " — forçar com pé de cabra")
	else:
		prompt = "Fechar porta" if is_open else "Abrir porta"


func hold_time(player: Node) -> float:
	if barricade > 0.0:
		return 2.2
	if locked and not is_open and lock_key == "" and player != null and player.has_method("has_tool") and player.has_tool("pry"):
		return 2.8
	return 0.0


func interact(player: Node) -> void:
	super.interact(player)
	if broken:
		return
	if barricade > 0.0:
		barricade = 0.0
		if player and player.has_method("give_item"):
			player.give_item("tabua", 2)
		EventBus.make_noise(global_position, 8.0, player, &"barricade")
		_save()
		return
	if locked and not is_open:
		if lock_key != "" and player and player.has_method("has_key") and player.has_key(lock_key):
			locked = false
			EventBus.toast("Destrancado.", "info")
		elif lock_key == "" and player and player.has_method("has_tool") and player.has_tool("pry"):
			locked = false
			player.use_tool("pry", 0.03)
			EventBus.make_noise(global_position, 18.0, player, &"pry")
			AudioManager.play_3d("door_force", global_position)
		else:
			AudioManager.play_3d("door_locked", global_position)
			EventBus.toast("A porta está trancada.", "warn")
			return
	set_open(not is_open, player)


func set_open(open: bool, by: Node = null) -> void:
	if open == is_open:
		return
	is_open = open
	if open and kind == "hinged" and by is Node3D and _open_amount < 0.05:
		var lp := to_local((by as Node3D).global_position)
		_swing = 1.0 if lp.z > 0.0 else -1.0
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_method(_set_open_amount, _open_amount, 1.0 if open else 0.0, 0.55 if kind == "hinged" else 0.8).set_trans(Tween.TRANS_SINE)
	AudioManager.play_3d("door_open" if open else "door_close", global_position)
	EventBus.make_noise(global_position, 6.0, by, &"door")
	_save()


func _set_open_amount(v: float) -> void:
	_open_amount = v
	match kind:
		"hinged":
			pivot.rotation.y = _swing * v * deg_to_rad(100.0)
		"sliding":
			pivot.position.x = v * width * 0.95
		"roller":
			pivot.position.y = v * height * 0.92


## Golpe de infectado/jogador. Retorna true se a porta cedeu.
func bash(amount: float, attacker: Node = null) -> bool:
	if broken or is_open:
		return true
	if barricade > 0.0:
		barricade = maxf(0.0, barricade - amount)
		AudioManager.play_3d("barricade_hit", global_position)
	else:
		hp -= amount * (0.5 if locked else 1.0)
		AudioManager.play_3d("door_bash", global_position)
	EventBus.make_noise(global_position, 14.0, attacker, &"bash")
	if hp <= 0.0:
		broken = true
		locked = false
		set_open(true, attacker)
		_save()
		return true
	_save()
	return false


func add_barricade(points: float = 100.0) -> void:
	if is_open:
		set_open(false)
	barricade = minf(200.0, barricade + points)
	_save()


func blocks_path() -> bool:
	return not is_open and not broken


func _save() -> void:
	if uid == "":
		return
	GameState.store_door(uid, {"open": is_open, "locked": locked, "barricade": barricade, "broken": broken, "hp": hp, "swing": _swing})
