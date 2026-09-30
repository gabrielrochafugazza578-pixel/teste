class_name Projectile
extends RigidBody3D
## Objetos arremessados (distrações e armas improvisadas).
## Ao impactar emitem RUÍDO (atraem infectados para longe do jogador).

var item_id: String = ""
var thrower: Node = null
var def: Dictionary = {}
var _done: bool = false
var _fuse: float = -1.0
var _life: float = 12.0


func launch(id: String, from: Vector3, vel: Vector3, by: Node) -> void:
	item_id = id
	thrower = by
	def = ItemDB.get_item(id).get("throw", {})
	global_position = from
	collision_layer = 1 << 6
	collision_mask = 1 | (1 << 3) | (1 << 4)
	mass = 0.4
	continuous_cd = true
	contact_monitor = true
	max_contacts_reported = 2
	var cs := CollisionShape3D.new()
	var sp := SphereShape3D.new()
	sp.radius = 0.07
	cs.shape = sp
	add_child(cs)
	var mi := MeshInstance3D.new()
	mi.mesh = ItemModels.mesh(id)
	mi.position = -mi.mesh.get_aabb().get_center()
	add_child(mi)
	linear_velocity = vel
	angular_velocity = Vector3(randf_range(-8, 8), randf_range(-8, 8), randf_range(-8, 8))
	body_entered.connect(_on_hit)
	if def.has("delay"):
		_fuse = float(def["delay"])


func _physics_process(delta: float) -> void:
	_life -= delta
	if _life <= 0.0:
		queue_free()
		return
	if _fuse > 0.0:
		_fuse -= delta
		if _fuse <= 0.0:
			_explode_noise()


func _on_hit(b: Node) -> void:
	if _done:
		return
	if b.has_method("receive_hit") and b != thrower:
		var info := DamageInfo.make(float(def.get("dmg", 3.0)), "blunt", thrower, linear_velocity)
		info.stagger = 0.3
		info.point = global_position
		b.receive_hit(info)
	if def.has("delay"):
		return
	_done = true
	var noise := float(def.get("noise", 12.0))
	EventBus.make_noise(global_position, noise, thrower, &"distraction")
	if def.get("break", false):
		AudioManager.play_3d("bottle_break", global_position, 0.0, -1.0, 70.0)
	elif item_id == "lata_vazia":
		AudioManager.play_3d("can_rattle", global_position, 0.0, -1.0, 60.0)
	else:
		AudioManager.play_3d("metal_clang", global_position, -4.0, -1.0, 60.0)
	if def.get("fire", false):
		var f := FireArea.new()
		get_parent().add_child(f)
		f.global_position = global_position
		f.ignite(thrower)
	if def.get("break", false):
		queue_free()
	else:
		# vira item recolhível
		var ip := ItemPickup.new()
		get_parent().add_child(ip)
		ip.setup(Inventory.make_stack(item_id, 1), global_position, true)
		queue_free()


func _explode_noise() -> void:
	_done = true
	AudioManager.play_3d("firecracker", global_position, 4.0, -1.0, 140.0)
	EventBus.make_noise(global_position, float(def.get("noise", 100.0)), thrower, &"firecracker")
	var l := OmniLight3D.new()
	l.light_color = Color(1.0, 0.7, 0.3)
	l.light_energy = 4.0
	l.omni_range = 10.0
	get_parent().add_child(l)
	l.global_position = global_position + Vector3(0, 0.4, 0)
	var tw := l.create_tween()
	tw.tween_property(l, "light_energy", 0.0, 2.4)
	tw.tween_callback(l.queue_free)
	queue_free()
