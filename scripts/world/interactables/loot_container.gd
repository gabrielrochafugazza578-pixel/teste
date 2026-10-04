class_name LootContainer
extends Interactable
## Móvel/contêiner com loot contextual. O conteúdo é gerado na primeira
## abertura (determinístico pelo uid) e salvo no GameState a cada mudança.

const LABELS := {
	"fridge": "Geladeira", "kitchen_cabinet": "Armário da cozinha", "drawer": "Gaveteiro", "nightstand": "Criado-mudo",
	"wardrobe": "Guarda-roupa", "medicine_cabinet": "Armário de remédios", "bookshelf": "Estante", "shelf": "Prateleira",
	"counter": "Balcão", "locker": "Armário", "filing": "Arquivo", "med_cart": "Carrinho de medicação", "toolbox": "Caixa de ferramentas",
	"workbench": "Gavetas da bancada", "desk": "Mesa", "freezer": "Freezer", "crate": "Caixote", "rack": "Estante industrial",
	"barrel": "Tambor", "box": "Caixas de papelão", "lab_cabinet": "Armário do laboratório", "server": "Rack de servidor",
	"stove": "Fogão", "trunk": "Porta-malas", "glovebox": "Porta-luvas", "stash": "Esconderijo", "body": "Corpo",
	"storage": "Caixa de armazenamento",
}

var kind: String = "drawer"
var context: String = "house"
var district: String = ""
var inv: Inventory
var generated: bool = false
var persistent_player_storage: bool = false
var size: Vector3 = Vector3(0.8, 0.8, 0.6)
var _lift: float = 0.5
var _anim: Node3D

# como o móvel "abre" quando revistado (peça animada por cima da malha do cômodo)
const DRAWER_KINDS := ["drawer", "nightstand", "desk", "filing", "workbench", "counter", "kitchen_cabinet", "med_cart", "toolbox", "lab_cabinet"]
const DOOR_KINDS := ["wardrobe", "locker", "fridge", "freezer", "medicine_cabinet", "server", "stove"]
const LID_KINDS := ["crate", "box", "storage", "barrel"]


func setup(d: Dictionary) -> void:
	uid = str(d.get("uid", ""))
	kind = str(d.get("kind", "drawer"))
	context = str(d.get("context", "house"))
	district = str(d.get("district", ""))
	position = d["pos"]
	rotation.y = float(d.get("yaw", 0.0))
	var sz: Vector3 = d.get("size", Vector3(0.8, 0.8, 0.6))
	size = sz
	_lift = maxf(sz.y * 0.6, 0.5) if d.has("prop") else sz.y * 0.5
	add_shape(Vector3(maxf(sz.x, 0.6), maxf(sz.y, 0.6), maxf(sz.z, 0.6) + 0.4))
	prompt = "Revistar " + LABELS.get(kind, "contêiner").to_lower()
	var cap := 30.0
	var slots := 12
	match kind:
		"nightstand", "glovebox", "medicine_cabinet", "desk", "stove":
			cap = 6.0
			slots = 6
		"crate", "rack", "trunk", "storage", "stash":
			cap = 60.0
			slots = 20
	inv = Inventory.new(uid, cap, slots, LABELS.get(kind, "Contêiner"))
	var st := GameState.container_state(uid)
	if not st.is_empty():
		inv.from_data({"id": uid, "w": cap, "slots": slots, "stacks": st.get("items", [])})
		generated = true
	inv.changed.connect(_on_changed)
	# já revistado (save): fica aberto
	if generated and d.has("prop"):
		_open_anim.call_deferred(true)


func _on_changed() -> void:
	if generated:
		GameState.store_container(uid, inv.stacks)


func get_prompt(_player: Node) -> String:
	if generated and inv.stacks.is_empty():
		return LABELS.get(kind, "Contêiner") + " (vazio)"
	return prompt if not generated else "Abrir " + LABELS.get(kind, "contêiner").to_lower()


func hold_time(_player: Node) -> float:
	return 0.0 if generated else 0.75


func interact(player: Node) -> void:
	super.interact(player)
	if _anim == null and size != Vector3.ZERO:
		_open_anim(false)
	if not generated:
		generated = true
		if not persistent_player_storage:
			var stacks := LootTables.roll(context, kind, uid, district, Settings.loot_multiplier())
			for s in stacks:
				inv.add_stack(s, true)
		GameState.store_container(uid, inv.stacks)
		GameState.add_stat("looted")
		EventBus.container_opened.emit(uid, context)
	AudioManager.play_3d("search", global_position)
	EventBus.make_noise(global_position, 4.0, player, &"search")
	EventBus.container_ui_requested.emit(inv, LABELS.get(kind, "Contêiner"), self)


## Gaveta que desliza, porta que gira ou tampa que levanta. O móvel faz parte da
## malha do cômodo (não se mexe), então a peça aberta é desenhada por cima: a
## frente do móvel é o -Z local, o chão fica em y = -_lift.
func _open_anim(instant: bool) -> void:
	if _anim != null or not is_inside_tree():
		return
	var fam := "drawer" if kind in DRAWER_KINDS else ("door" if kind in DOOR_KINDS else ("lid" if kind in LID_KINDS else ""))
	if fam == "":
		return
	var sz := size
	var wood := Color(0.55, 0.42, 0.3)
	var col := wood
	var code := Assets.uv2_code(Assets.L_WOOD)
	if kind in ["fridge", "freezer", "stove"]:
		col = Color(0.92, 0.92, 0.9)
		code = Assets.uv2_code(Assets.L_METAL)
	elif kind in ["locker", "server", "toolbox", "med_cart", "filing", "lab_cabinet", "medicine_cabinet", "barrel"]:
		col = Color(0.6, 0.63, 0.66)
		code = Assets.uv2_code(Assets.L_METAL)
	elif kind == "box":
		col = Color(0.62, 0.5, 0.34)
	var dark := Color(0.06, 0.055, 0.05)
	var front := -sz.z * 0.5
	var floor_y := -_lift
	var pivot := Node3D.new()
	add_child(pivot)
	_anim = pivot
	var b := MeshBuf.new()
	var target := Transform3D.IDENTITY
	match fam:
		"drawer":
			var dw := sz.x * (0.42 if sz.x > 1.4 else 0.82)
			var dh := clampf(sz.y * 0.22, 0.1, 0.18)
			var dd := minf(sz.z * 0.8, 0.5)
			var dx := (sz.x * 0.25) if sz.x > 1.4 else 0.0
			var top_y := floor_y + sz.y * (0.78 if sz.y < 1.2 else 0.62)
			# caixa da gaveta: frente, laterais, fundo e o "vazio" escuro dentro
			b.box(Vector3(0, 0, -dd * 0.5), Vector3(dw, dh, 0.02), code, 0.3, col)
			b.box(Vector3(-dw * 0.5 + 0.01, -0.005, 0), Vector3(0.015, dh * 0.85, dd), code, 0.3, col * 0.85)
			b.box(Vector3(dw * 0.5 - 0.01, -0.005, 0), Vector3(0.015, dh * 0.85, dd), code, 0.3, col * 0.85)
			b.box(Vector3(0, -dh * 0.45, 0), Vector3(dw - 0.03, 0.012, dd), code, 0.3, dark * 3.0)
			b.box(Vector3(0, -0.005, dd * 0.5 - 0.008), Vector3(dw - 0.03, dh * 0.85, 0.015), code, 0.3, col * 0.7)
			# puxador
			b.box(Vector3(0, 0.0, -dd * 0.5 - 0.02), Vector3(0.12, 0.02, 0.02), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.7, 0.7, 0.68))
			pivot.position = Vector3(dx, top_y, front + dd * 0.5 - 0.005)
			target = Transform3D(Basis.IDENTITY, pivot.position + Vector3(0, 0, -dd * 0.62))
		"door":
			var wide := sz.x > 0.9
			var dw2 := sz.x * (0.5 if wide else 0.96)
			var dh2 := sz.y * 0.92
			var cy := floor_y + sz.y * 0.5
			# vão escuro (interior do armário) onde a porta estava
			var hole := MeshBuf.new()
			hole.box(Vector3((sz.x * 0.25 if wide else 0.0), cy, front - 0.004), Vector3(dw2 - 0.03, dh2 - 0.03, 0.006), code, 0.0, dark)
			var hm := MeshInstance3D.new()
			hm.mesh = hole.to_mesh(Assets.world_material("interior"))
			hm.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			add_child(hm)
			# folha com dobradiça na lateral direita
			b.box(Vector3(-dw2 * 0.5, 0, -0.0125), Vector3(dw2, dh2, 0.025), code, 0.3, col)
			b.box(Vector3(-dw2 + 0.06, 0, -0.04), Vector3(0.025, 0.14, 0.025), Assets.uv2_code(Assets.L_METAL), 0.0, Color(0.7, 0.7, 0.68))
			var hinge_x := sz.x * 0.5 if wide else sz.x * 0.48
			pivot.position = Vector3(hinge_x, cy, front - 0.006)
			target = Transform3D(Basis(Vector3.UP, deg_to_rad(-105.0)), pivot.position)
		"lid":
			var lw := sz.x * 1.02
			var ld := sz.z * 1.02
			var lt := 0.04 if kind != "box" else 0.012
			var top := floor_y + sz.y
			if kind == "barrel":
				b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0, -ld * 0.5)), sz.x * 0.5, lt, 14, code, 0.0, col)
			else:
				b.box(Vector3(0, lt * 0.5, -ld * 0.5), Vector3(lw, lt, ld), code, 0.3, col)
			# boca escura da caixa
			var hole2 := MeshBuf.new()
			hole2.box(Vector3(0, top + 0.002, 0), Vector3(sz.x * 0.9, 0.004, sz.z * 0.9), code, 0.0, dark)
			var hm2 := MeshInstance3D.new()
			hm2.mesh = hole2.to_mesh(Assets.world_material("interior"))
			hm2.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			add_child(hm2)
			# dobradiça no fundo (z = +sz.z/2): a frente da tampa sobe
			pivot.position = Vector3(0, top, ld * 0.5)
			target = Transform3D(Basis(Vector3.RIGHT, deg_to_rad(75.0 if kind != "barrel" else 12.0)), pivot.position + (Vector3(0.3, 0, -0.1) if kind == "barrel" else Vector3.ZERO))
	var mi := MeshInstance3D.new()
	mi.mesh = b.to_mesh(Assets.world_material("interior"))
	pivot.add_child(mi)
	if instant:
		pivot.transform = target
		return
	var tw := create_tween()
	tw.tween_property(pivot, "transform", target, 0.45 if fam == "door" else 0.32).set_trans(Tween.TRANS_BACK if fam == "drawer" else Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
