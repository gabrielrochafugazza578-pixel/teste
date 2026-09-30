class_name StructureManager
extends Node3D
## Posicionamento e persistência de estruturas construídas pelo jogador
## (fogueira, coletor, caixa, esconderijo, cama, bancada, alarme de latas,
## barricadas em portas). As estruturas ficam em GameState.structures.

const KINDS := {
	"campfire": {"station": "fire", "prop": "campfire", "col": Vector3.ZERO},
	"rain_collector": {"station": "rain_collector", "prop": "", "col": Vector3(0.8, 1.0, 0.8)},
	"storage_box": {"station": "storage", "prop": "crate", "col": Vector3(0.82, 0.82, 0.82)},
	"hidden_stash": {"station": "hidden_stash", "prop": "tarp_shelter", "col": Vector3.ZERO},
	"bedroll": {"station": "bed", "prop": "", "col": Vector3.ZERO},
	"workbench": {"station": "workbench", "prop": "workbench", "col": Vector3(2.0, 0.95, 0.82)},
	"can_alarm": {"station": "", "prop": "", "col": Vector3.ZERO},
}

var player: Player = null
var world: World = null
var placing: String = ""          # item id em posicionamento
var _kind: String = ""
var _ghost: Node3D
var _ghost_mat: StandardMaterial3D
var _yaw: float = 0.0
var _valid: bool = false
var _spawned: Dictionary = {}     # índice -> nó


func setup(p: Player, w: World) -> void:
	player = p
	world = w
	for i in GameState.structures.size():
		_spawn(i)


static func place_kind(item_id: String) -> String:
	return str(ItemDB.get_item(item_id).get("place", ""))


# ---------------------------------------------------------------------------
# Modo de posicionamento
# ---------------------------------------------------------------------------
func begin(item_id: String) -> void:
	var k := place_kind(item_id)
	if k == "" or not player.inventory.has(item_id):
		return
	if k == "barricade":
		_barricade(item_id)
		return
	cancel()
	placing = item_id
	_kind = k
	_yaw = player.cam_rig.yaw
	_ghost = _visual(k)
	_ghost_mat = StandardMaterial3D.new()
	_ghost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_ghost_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_ghost_mat.albedo_color = Color(0.4, 1.0, 0.5, 0.35)
	_apply_ghost_mat(_ghost)
	add_child(_ghost)
	EventBus.toast("[Clique] posicionar · [Roda/Q/F] girar · [Botão direito] cancelar", "info")


func cancel() -> void:
	placing = ""
	_kind = ""
	if is_instance_valid(_ghost):
		_ghost.queue_free()
	_ghost = null


func _apply_ghost_mat(n: Node) -> void:
	if n is GeometryInstance3D:
		(n as GeometryInstance3D).material_override = _ghost_mat
		(n as GeometryInstance3D).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for c in n.get_children():
		_apply_ghost_mat(c)


func _input(event: InputEvent) -> void:
	if placing == "":
		return
	var used := false
	if event is InputEventMouseButton and event.pressed:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			_yaw += 0.2
			used = true
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_yaw -= 0.2
			used = true
	if event.is_action_pressed("dodge"):
		_yaw += PI * 0.25
		used = true
	elif event.is_action_pressed("shove"):
		_yaw -= PI * 0.25
		used = true
	elif event.is_action_pressed("attack"):
		_confirm()
		used = true
	elif event.is_action_pressed("block") or event.is_action_pressed("pause"):
		cancel()
		used = true
	elif event.is_action_released("attack") or event.is_action_released("block"):
		used = true
	if used:
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if placing == "" or not is_instance_valid(_ghost) or player == null:
		return
	if not player.inventory.has(placing) or player.in_vehicle != null or player.survival.dead:
		cancel()
		return
	var fwd := player.cam_rig.flat_forward()
	var p := player.global_position + fwd * 2.2 + Vector3(0, 1.2, 0)
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(p, p + Vector3(0, -4.0, 0), 1)
	q.exclude = [player.get_rid()]
	var hit := space.intersect_ray(q)
	_valid = false
	if not hit.is_empty():
		var n: Vector3 = hit["normal"]
		p = hit["position"]
		_valid = n.y > 0.8 and absf(p.y - player.global_position.y) < 1.2
		# espaço livre
		var sz: Vector3 = KINDS[_kind]["col"]
		if _valid and sz != Vector3.ZERO:
			var sq := PhysicsShapeQueryParameters3D.new()
			var box := BoxShape3D.new()
			box.size = sz * Vector3(0.95, 0.9, 0.95)
			sq.shape = box
			sq.transform = Transform3D(Basis(Vector3.UP, _yaw), p + Vector3(0, sz.y * 0.5 + 0.05, 0))
			sq.collision_mask = 1 | (1 << 1)
			_valid = space.intersect_shape(sq, 1).is_empty()
	_ghost.global_position = p
	_ghost.rotation.y = _yaw
	_ghost_mat.albedo_color = Color(0.4, 1.0, 0.5, 0.35) if _valid else Color(1.0, 0.3, 0.25, 0.35)


func _confirm() -> void:
	if not _valid:
		EventBus.toast("Não dá para construir aqui.", "warn")
		return
	var pos := _ghost.global_position
	player.inventory.remove(placing, 1)
	var idx := GameState.add_structure(_kind, pos, _yaw, {})
	_spawn(idx)
	AudioManager.play_3d("craft", pos, -2.0)
	EventBus.make_noise(pos, 8.0, player, &"build")
	EventBus.structure_built.emit(_kind, pos)
	GameState.add_stat("built")
	var id := placing
	cancel()
	if player.inventory.has(id):
		begin(id)


func _barricade(item_id: String) -> void:
	var d := player.current_interactable as Door
	if d == null:
		for n in get_tree().get_nodes_in_group("interactable"):
			var dd := n as Door
			if dd != null and dd.global_position.distance_to(player.global_position) < 2.4:
				d = dd
				break
	if d == null or d.broken:
		EventBus.toast("Fique perto de uma porta para barricá-la.", "info")
		return
	player.inventory.remove(item_id, 1)
	player.use_tool("hammer", 0.02)
	d.add_barricade(100.0)
	player.body.play("inspect_low", 1.0)
	AudioManager.play_3d("barricade_hit", d.global_position, 0.0)
	EventBus.make_noise(d.global_position, 22.0, player, &"hammer")
	EventBus.toast("Porta barricada.", "good")


# ---------------------------------------------------------------------------
# Instanciação
# ---------------------------------------------------------------------------
func _spawn(idx: int) -> void:
	var s: Dictionary = GameState.structures[idx]
	var k: String = s["type"]
	if not KINDS.has(k) or bool(s.get("data", {}).get("removed", false)):
		return
	var pos := Util.v3(s["pos"])
	var yaw := float(s["rot"])
	var root := Node3D.new()
	root.name = "Struct_%d" % idx
	add_child(root)
	root.global_position = pos
	root.rotation.y = yaw
	root.add_child(_visual(k))
	var def: Dictionary = KINDS[k]
	var col: Vector3 = def["col"]
	if col != Vector3.ZERO:
		var sb := StaticBody3D.new()
		sb.collision_layer = 1
		var cs := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = col
		cs.shape = box
		cs.position = Vector3(0, col.y * 0.5, 0)
		sb.add_child(cs)
		root.add_child(sb)
	var st: String = def["station"]
	if st != "":
		var station := Station.new()
		root.add_child(station)
		station.setup(st, Vector3.ZERO, 0.0, "struct_%d" % idx)
		if k == "bedroll":
			station.prompt = "Dormir na cama improvisada / Salvar"
	elif k == "can_alarm":
		var a := CanAlarm.new()
		root.add_child(a)
	_spawned[idx] = root


func _visual(k: String) -> Node3D:
	var n := Node3D.new()
	var def: Dictionary = KINDS.get(k, {})
	var prop: String = def.get("prop", "")
	var mi := MeshInstance3D.new()
	if prop != "":
		mi.mesh = PropLib.mesh(prop)
	else:
		mi.mesh = Assets.cached_mesh("struct_" + k, func() -> Mesh: return _custom_mesh(k))
	n.add_child(mi)
	return n


static func _custom_mesh(k: String) -> Mesh:
	var b := MeshBuf.new()
	var wood := Assets.uv2_code(Assets.L_WOOD)
	var fab := Assets.uv2_code(Assets.L_FABRIC)
	var met := Assets.uv2_code(Assets.L_METAL)
	match k:
		"rain_collector":
			# barril com lona em funil sobre estrutura de tábuas
			b.cylinder(Transform3D(Basis(), Vector3(0, 0.0, 0)), 0.3, 0.9, 12, met, 0.2, Color(0.25, 0.4, 0.55))
			for i in 4:
				var a := i * PI * 0.5 + PI * 0.25
				b.box(Vector3(cos(a) * 0.45, 0.6, sin(a) * 0.45), Vector3(0.06, 1.2, 0.06), wood, 0.1, Color(0.6, 0.5, 0.4))
			b.cylinder(Transform3D(Basis(), Vector3(0, 1.05, 0)), 0.18, 0.12, 10, fab, 0.3, Color(0.2, 0.35, 0.55), true, 0.62)
		"bedroll":
			b.box(Vector3(0, 0.05, 0), Vector3(0.8, 0.1, 1.9), fab, 0.1, Color(0.3, 0.38, 0.3))
			b.box(Vector3(0, 0.1, -0.78), Vector3(0.55, 0.12, 0.3), fab, 0.4, Color(0.75, 0.72, 0.65))
			b.box(Vector3(0.05, 0.12, 0.25), Vector3(0.78, 0.05, 1.1), fab, 0.7, Color(0.45, 0.3, 0.22))
		"can_alarm":
			for i in 2:
				b.box(Vector3(-0.9 + i * 1.8, 0.45, 0), Vector3(0.05, 0.9, 0.05), wood, 0.2, Color(0.55, 0.45, 0.35))
			b.box(Vector3(0, 0.55, 0), Vector3(1.8, 0.01, 0.01), fab, 0.1, Color(0.7, 0.65, 0.5))
			for i in 4:
				b.cylinder(Transform3D(Basis(), Vector3(-0.5 + i * 0.33, 0.38, 0)), 0.04, 0.11, 8, met, float(i) * 0.2, Color(0.75, 0.72, 0.68))
		_:
			b.box(Vector3(0, 0.25, 0), Vector3(0.5, 0.5, 0.5), wood)
	return b.to_mesh(Assets.world_material("props"))


func to_dict() -> Dictionary:
	return {}
