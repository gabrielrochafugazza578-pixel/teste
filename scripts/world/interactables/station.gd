class_name Station
extends Interactable
## Estações: cama (dormir/salvar), bancada (fabricação), fogueira (cozinhar,
## aquecer), fogão, coletor de chuva, armazenamento e esconderijo.

var station: String = "bed"
var storage: Inventory
var fire_node: Node3D
var light: OmniLight3D
var water: float = 0.0
var lit: bool = true


func setup(kind: String, pos: Vector3, yaw: float = 0.0, id: String = "") -> void:
	station = kind
	uid = id
	position = pos
	rotation.y = yaw
	add_shape(Vector3(1.4, 1.2, 1.4), Vector3(0, 0.5, 0))
	set_process(station == "fire" or station == "rain_collector")
	match station:
		"bed":
			prompt = "Dormir / Salvar"
		"workbench":
			prompt = "Usar bancada"
		"fire":
			prompt = "Fogueira (cozinhar)"
			add_to_group("heat_source")
			_make_fire()
		"stove":
			prompt = "Fogão (cozinhar)"
		"rain_collector":
			prompt = "Coletor de chuva"
			add_to_group("rain_collector")
		"storage", "hidden_stash":
			prompt = "Abrir esconderijo" if station == "hidden_stash" else "Abrir caixa"
			storage = Inventory.new(uid, 80.0 if station == "storage" else 40.0, 30 if station == "storage" else 16, "Armazenamento")
			var st := GameState.container_state(uid)
			if not st.is_empty():
				storage.from_data({"id": uid, "w": storage.max_weight, "slots": storage.max_slots, "stacks": st.get("items", [])})
			storage.changed.connect(func() -> void: GameState.store_container(uid, storage.stacks))


func _make_fire() -> void:
	fire_node = Node3D.new()
	add_child(fire_node)
	var p := GPUParticles3D.new()
	p.amount = int(24 * Settings.get_particle_multiplier()) + 6
	p.lifetime = 0.9
	var pm := ParticleProcessMaterial.new()
	pm.direction = Vector3.UP
	pm.spread = 12.0
	pm.initial_velocity_min = 0.6
	pm.initial_velocity_max = 1.3
	pm.gravity = Vector3(0, 0.5, 0)
	pm.scale_min = 0.25
	pm.scale_max = 0.5
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	pm.emission_sphere_radius = 0.18
	var grad := Gradient.new()
	grad.set_color(0, Color(1.0, 0.75, 0.3, 0.9))
	grad.set_color(1, Color(0.8, 0.2, 0.05, 0.0))
	var gt := GradientTexture1D.new()
	gt.gradient = grad
	pm.color_ramp = gt
	p.process_material = pm
	var q := QuadMesh.new()
	q.size = Vector2(0.5, 0.5)
	q.material = Assets.particle_material(Assets.SPR_SPARK, Color(1.0, 0.7, 0.35), true)
	p.draw_pass_1 = q
	p.position = Vector3(0, 0.15, 0)
	fire_node.add_child(p)
	light = OmniLight3D.new()
	light.light_color = Color(1.0, 0.6, 0.3)
	light.light_energy = 1.6
	light.omni_range = 7.0
	light.position = Vector3(0, 0.6, 0)
	light.shadow_enabled = bool(Settings.get_shadow_params()["local_shadows"])
	fire_node.add_child(light)


func _process(delta: float) -> void:
	if light:
		light.light_energy = 1.4 + sin(Time.get_ticks_msec() * 0.013) * 0.15 + randf() * 0.15
	if station == "rain_collector" and WeatherManager.rain > 0.1:
		water = minf(water + delta * WeatherManager.rain * 0.02, 5.0)


func get_prompt(_player: Node) -> String:
	if station == "rain_collector":
		return "Coletor de chuva (%d garrafas)" % int(water)
	return prompt


func is_heat_source() -> bool:
	return station == "fire" and lit


func interact(player: Node) -> void:
	super.interact(player)
	match station:
		"bed":
			EventBus.sleep_requested.emit(self)
		"workbench":
			EventBus.crafting_ui_requested.emit("workbench", self)
		"fire", "stove":
			EventBus.crafting_ui_requested.emit("fire", self)
		"rain_collector":
			var n := int(water)
			if n <= 0:
				EventBus.toast("O coletor está vazio. Espere chover.", "info")
				return
			if player and player.has_method("fill_bottles"):
				var filled: int = player.fill_bottles("agua_suja", n)
				water -= filled
		"storage", "hidden_stash":
			EventBus.container_ui_requested.emit(storage, "Esconderijo" if station == "hidden_stash" else "Caixa de armazenamento", self)
