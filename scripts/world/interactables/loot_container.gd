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


func setup(d: Dictionary) -> void:
	uid = str(d.get("uid", ""))
	kind = str(d.get("kind", "drawer"))
	context = str(d.get("context", "house"))
	district = str(d.get("district", ""))
	position = d["pos"]
	rotation.y = float(d.get("yaw", 0.0))
	var sz: Vector3 = d.get("size", Vector3(0.8, 0.8, 0.6))
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
