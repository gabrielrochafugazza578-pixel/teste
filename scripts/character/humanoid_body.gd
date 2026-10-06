class_name HumanoidBody
extends Node3D
## Corpo visual de qualquer humanoide: Skeleton3D + malha skinned (1 draw call)
## + ProceduralAnimator. O MESMO nó é usado pelo Caio jogável, NPCs,
## infectados e atores da cinemática (a diferença é só quem controla).
##
## LOD de animação: `anim_interval` define a frequência de atualização do
## esqueleto (0 = todo frame). O dono ajusta pelo tier do SimScheduler.

signal anim_event(event_name: String)

## Custo acumulado de gerar malhas de personagem (diagnóstico dos testes).
static var build_usec: int = 0
static var build_count: int = 0

var appearance: Dictionary = {}
var skeleton: Skeleton3D
var mesh_instance: MeshInstance3D
var material: ShaderMaterial
var animator: ProceduralAnimator
var lod: int = -1
var anim_interval: float = 0.0
var _accum: float = 0.0
var _attachments: Dictionary = {}
var frozen: bool = false
## 1ª pessoa: encolhe a cabeça (e o que está preso nela) para a câmera ficar
## nos olhos sem ver o próprio rosto por dentro.
var hide_head: bool = false:
	set(v):
		if hide_head == v:
			return
		hide_head = v
		_apply_head()


func setup(ap: Dictionary, lod_level: int = 0) -> void:
	ap = HumanModels.photo(ap)
	appearance = ap
	var joints := HumanoidMeshBuilder.compute_joints(ap)
	skeleton = Skeleton3D.new()
	skeleton.name = "Skeleton"
	for i in HumanoidMeshBuilder.BONE_NAMES.size():
		skeleton.add_bone(HumanoidMeshBuilder.BONE_NAMES[i])
	for i in HumanoidMeshBuilder.BONE_NAMES.size():
		var parent: int = HumanoidMeshBuilder.PARENTS[i]
		var origin: Vector3 = joints[i]
		if parent >= 0:
			skeleton.set_bone_parent(i, parent)
			origin = joints[i] - joints[parent]
		skeleton.set_bone_rest(i, Transform3D(Basis.IDENTITY, origin))
	skeleton.reset_bone_poses()
	add_child(skeleton)
	mesh_instance = MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	skeleton.add_child(mesh_instance)
	mesh_instance.skeleton = NodePath("..")
	if HumanModels.is_model(ap):
		HumanModels.apply(mesh_instance, ap)
	else:
		material = Assets.character_material(float(ap.get("infected", 0.0)))
		material.set_shader_parameter("grime_amount", float(ap.get("grime", 0.2)))
		mesh_instance.material_override = material
	mesh_instance.custom_aabb = AABB(Vector3(-1.4, -0.3, -1.4), Vector3(2.8, 2.8, 2.8))
	set_lod(lod_level)
	animator = ProceduralAnimator.new(skeleton, ap)
	animator.event.connect(func(e: String) -> void: anim_event.emit(e))
	_apply_shadow_setting()
	EventBus.settings_changed.connect(_apply_shadow_setting)
	animator.update(0.0)


func _apply_shadow_setting() -> void:
	if mesh_instance == null:
		return
	var sp := Settings.get_shadow_params()
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if bool(sp["character_shadows"]) and lod == 0 else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func set_lod(level: int) -> void:
	if level == lod:
		return
	lod = level
	var ap := appearance
	if HumanModels.is_model(ap):
		# malha única com LODs automáticos (o Godot troca pela distância)
		_apply_shadow_setting()
		return
	var key := Appearance.mesh_key(ap, level)
	mesh_instance.mesh = Assets.cached_mesh(key, func() -> Mesh:
		var t0 := Time.get_ticks_usec()
		var m := HumanoidMeshBuilder.build(ap, level)
		build_usec += Time.get_ticks_usec() - t0
		build_count += 1
		return m)
	_apply_shadow_setting()


func set_infection(v: float) -> void:
	if HumanModels.is_model(appearance) and mesh_instance:
		mesh_instance.set_instance_shader_parameter("infection", v)
	elif material:
		material.set_shader_parameter("infection", v)


## Chamado pelo dono todo frame (ou a cada tick); aplica o LOD temporal.
func tick(delta: float) -> void:
	if frozen or animator == null:
		return
	_accum += delta
	if _accum < anim_interval:
		return
	animator.update(_accum)
	_accum = 0.0
	if hide_head:
		_apply_head()


func force_update() -> void:
	if animator:
		animator.update(maxf(_accum, 0.016))
		_accum = 0.0
		if hide_head:
			_apply_head()


func _apply_head() -> void:
	if skeleton == null:
		return
	var i := skeleton.find_bone("head")
	if i >= 0:
		skeleton.set_bone_pose_scale(i, Vector3.ONE * (0.001 if hide_head else 1.0))
	if _attachments.has("head"):
		(_attachments["head"] as Node3D).visible = not hide_head


func play(action_name: String, speed_mult: float = 1.0, restart: bool = true) -> bool:
	return animator.play(action_name, speed_mult, restart) if animator else false


func stop_action() -> void:
	if animator:
		animator.stop_action()


## Anexa um nó a um osso (arma na mão, lanterna no peito…).
func attach(bone_name: String, node: Node3D, offset: Transform3D = Transform3D.IDENTITY) -> void:
	var ba: BoneAttachment3D
	if _attachments.has(bone_name):
		ba = _attachments[bone_name]
	else:
		ba = BoneAttachment3D.new()
		ba.bone_name = bone_name
		skeleton.add_child(ba)
		_attachments[bone_name] = ba
	ba.add_child(node)
	node.transform = offset


func clear_attachment(bone_name: String) -> void:
	if _attachments.has(bone_name):
		var ba: BoneAttachment3D = _attachments[bone_name]
		for c in ba.get_children():
			c.queue_free()


func bone_global_position(bone_name: String) -> Vector3:
	var idx := skeleton.find_bone(bone_name)
	if idx < 0:
		return global_position
	return skeleton.global_transform * skeleton.get_bone_global_pose(idx).origin


func set_visible_body(v: bool) -> void:
	visible = v
