class_name EventDirector
extends Node
## Eventos emergentes e encontros aleatórios no mundo pós-colapso:
## sobreviventes pedindo ajuda, saqueadores de emboscada, transmissões de
## rádio, quedas de suprimento, hordas migrando, alarmes de carro,
## cachorros assustados, patrulhas de facção. Tudo agendado por hora de
## jogo com probabilidades ajustadas por capítulo, clima e reputação.

var game: Node = null
var player: Player = null
var world: World = null
var director: Node = null
var survivors: SurvivorManager = null
var active_events: Array = []      # [{"id", "pos", "t", "nodes": []}]
var cooldowns: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _tick: float = 20.0
var _counter: int = 0

const EVENTS := {
	"pedido_ajuda": {"weight": 1.0, "min_chapter": 2, "cd": 10.0},
	"emboscada": {"weight": 0.8, "min_chapter": 2, "cd": 14.0},
	"radio": {"weight": 0.9, "min_chapter": 1, "cd": 6.0},
	"suprimentos": {"weight": 0.5, "min_chapter": 3, "cd": 24.0},
	"horda": {"weight": 0.6, "min_chapter": 3, "cd": 16.0},
	"alarme_carro": {"weight": 0.8, "min_chapter": 1, "cd": 5.0},
	"patrulha": {"weight": 0.7, "min_chapter": 2, "cd": 8.0},
	"viajante": {"weight": 0.7, "min_chapter": 1, "cd": 9.0},
}


func setup(g: Node, p: Player, w: World, d: Node, sm: SurvivorManager) -> void:
	game = g
	player = p
	world = w
	director = d
	survivors = sm
	_rng.randomize()
	EventBus.hour_changed.connect(_on_hour)
	EventBus.decision_made.connect(_on_decision)


func _process(delta: float) -> void:
	for e in active_events.duplicate():
		e["t"] = float(e["t"]) - delta
		if float(e["t"]) <= 0.0 or player.global_position.distance_to(e["pos"]) > 260.0:
			_end_event(e)


func _on_hour(_h: int) -> void:
	if not is_inside_tree() or player == null or not player.is_inside_tree() or player.cinematic or GameState.world_phase != GameState.Phase.POST:
		return
	if game and game.has_method("is_underground") and game.is_underground():
		return
	for k in cooldowns.keys():
		cooldowns[k] = float(cooldowns[k]) - 1.0
		if float(cooldowns[k]) <= 0.0:
			cooldowns.erase(k)
	if _rng.randf() > 0.35 or active_events.size() >= 2:
		return
	var cands: Array = []
	for id in EVENTS.keys():
		var e: Dictionary = EVENTS[id]
		if cooldowns.has(id) or StoryManager.chapter < int(e["min_chapter"]):
			continue
		var w := float(e["weight"])
		if id == "horda" and TimeManager.is_night():
			w *= 1.8
		if id == "emboscada" and FactionManager.rep("corvos") < -30.0:
			w *= 1.6
		cands.append([id, w])
	var pick = Util.weighted_pick(cands, _rng)
	if pick == null:
		return
	trigger(str(pick))


## Dispara um evento (também usado por testes/depuração).
func trigger(id: String) -> void:
	cooldowns[id] = float(EVENTS.get(id, {}).get("cd", 8.0))
	match id:
		"pedido_ajuda": _help_request()
		"emboscada": _ambush()
		"radio": _radio()
		"suprimentos": _supply_drop()
		"horda": _horde()
		"alarme_carro": _car_alarm()
		"patrulha": _patrol()
		"viajante": _traveler()


func _spot(min_d: float, max_d: float) -> Vector3:
	for i in 12:
		var a := _rng.randf() * TAU
		var d := _rng.randf_range(min_d, max_d)
		var p := player.global_position + Vector3(cos(a) * d, 0, sin(a) * d)
		if world.layout.is_water(p.x, p.z) or world.layout.building_at(p, 0.5) >= 0:
			continue
		p.y = world.ground_y(p.x, p.z)
		return p
	return Vector3.INF


func _survivor(pos: Vector3, faction: String, role: String, weapon: String, name_hint: String = "") -> SurvivorNPC:
	_counter += 1
	var r := Util.rng(_counter * 977 + TimeManager.day)
	var fighter := weapon != ""
	var ap := Appearance.survivor(FactionManager.color(faction) if faction != "" else Color(0.45, 0.42, 0.38), 3000 + _counter, fighter)
	ap["id"] = "npc_ev_%d" % _counter
	var d := {"id": "ev_%d_%d" % [TimeManager.day, _counter], "name": name_hint if name_hint != "" else NPCDB.random_name(r, bool(ap["female"])),
		"faction": faction, "role": role, "weapon": weapon, "pos": pos, "appearance": ap,
		"routine": [[0, "wander", "wander"]], "trader": role == "trader"}
	var n := SurvivorNPC.new()
	survivors.add_child(n)
	n.setup(d, survivors, world)
	survivors.spawned[d["id"]] = n
	return n


func _end_event(e: Dictionary) -> void:
	active_events.erase(e)
	for n in e.get("nodes", []):
		if is_instance_valid(n) and n is SurvivorNPC:
			var sn := n as SurvivorNPC
			if sn.follow_target == null:
				survivors.spawned.erase(sn.npc_id)
				sn.queue_free()


# --- eventos ---------------------------------------------------------------
func _help_request() -> void:
	var p := _spot(45.0, 80.0)
	if p == Vector3.INF:
		return
	var n := _survivor(p, "", "civilian", "")
	n.hp = n.max_hp * 0.35
	n.activity = "hide"
	n.routine = [[0, "hide", "home"]]
	var types := ["errante", "errante", "febril"]
	var nodes: Array = [n]
	for i in 3 + _rng.randi() % 3:
		var ip := p + Vector3(_rng.randf_range(-9.0, 9.0), 0, _rng.randf_range(-9.0, 9.0))
		ip.y = world.ground_y(ip.x, ip.z)
		director.spawn_scripted(types[_rng.randi() % types.size()], ip, _rng.randf() * TAU, Infected.S.WANDER)
	AudioManager.play_3d("distant_scream", p + Vector3(0, 1.6, 0), 0.0, 1.15, 110.0)
	EventBus.world_event.emit("pedido_ajuda", "Alguém está gritando por socorro por perto.")
	EventBus.toast("Gritos de socorro por perto.", "event")
	active_events.append({"id": "pedido_ajuda", "pos": p, "t": 420.0, "nodes": nodes})
	# quem for salvo fica grato: vira contato de troca
	n.trader = true
	n.trade_inv = Inventory.new("trade_" + n.npc_id, 60.0, 12, n.display_name)
	for s in LootTables.roll("house", "kitchen_cabinet", n.npc_id, "", 1.5):
		n.trade_inv.add_stack(s, true)


func _ambush() -> void:
	var p := _spot(30.0, 50.0)
	if p == Vector3.INF:
		return
	var nodes: Array = []
	for i in 2 + _rng.randi() % 2:
		var ap := p + Vector3(_rng.randf_range(-5.0, 5.0), 0, _rng.randf_range(-5.0, 5.0))
		ap.y = world.ground_y(ap.x, ap.z)
		var n := _survivor(ap, "corvos", "guard", ["facao", "taco_pregos", "revolver"][_rng.randi() % 3])
		n.activity = "hide"
		n.target = player
		nodes.append(n)
	survivors.set_aggro("corvos", 60.0 if FactionManager.rep("corvos") < 20.0 else 0.01)
	if FactionManager.rep("corvos") < 20.0:
		EventBus.subtitle.emit("Passa tudo o que tem na mochila e ninguém se machuca!", "Saqueador", 3.0)
	active_events.append({"id": "emboscada", "pos": p, "t": 300.0, "nodes": nodes})


func _radio() -> void:
	if not player.inventory.has("radio_portatil") and not GameState.has_flag("radio_fixed"):
		return
	var msgs := [
		"...aqui é a Guarda Aurora. Toque de recolher a partir das dezoito horas. Repito: toque de recolher...",
		"...se alguém estiver ouvindo, o estádio da Vila Operária aceita sobreviventes. Tragam remédios...",
		"...os Despertos oferecem abrigo e o Despertar. Venha à Capela São Judas. Não tenha medo...",
		"...estática... carga de combustível... Ponte Velha... pedágio dobrado essa semana...",
		"...alguém na escuta? Fazenda Santa Clara... eles não estão tratando ninguém... eles estão...",
	]
	var m: String = msgs[_rng.randi() % msgs.size()]
	AudioManager.play_2d("radio_static", -14.0, 1.0, "Voice")
	EventBus.subtitle.emit(m, "Rádio", 5.0)


func _supply_drop() -> void:
	var p := _spot(80.0, 140.0)
	if p == Vector3.INF:
		return
	var lc := LootContainer.new()
	world.add_child(lc)
	lc.setup({"uid": "drop_%d_%d" % [TimeManager.day, _counter], "kind": "crate", "context": "bunker", "pos": p + Vector3(0, 0.5, 0), "size": Vector3(1.2, 1.0, 1.2)})
	var mi := MeshInstance3D.new()
	mi.mesh = PropLib.mesh("crate")
	lc.add_child(mi)
	mi.position = Vector3(0, -0.5, 0)
	var smoke := GPUParticles3D.new()
	smoke.amount = 20
	smoke.lifetime = 6.0
	var pm := ParticleProcessMaterial.new()
	pm.direction = Vector3.UP
	pm.spread = 8.0
	pm.initial_velocity_min = 1.5
	pm.initial_velocity_max = 2.5
	pm.gravity = Vector3(0.3, 0.2, 0)
	pm.scale_min = 2.0
	pm.scale_max = 4.0
	smoke.process_material = pm
	var q := QuadMesh.new()
	q.material = Assets.particle_material(Assets.SPR_SMOKE, Color(0.9, 0.35, 0.3, 0.6))
	smoke.draw_pass_1 = q
	lc.add_child(smoke)
	AudioManager.play_2d("helicopter", -14.0)
	EventBus.toast("Um helicóptero soltou uma caixa de suprimentos. Fumaça vermelha ao longe.", "event")
	for i in 4:
		var ip := p + Vector3(_rng.randf_range(-15.0, 15.0), 0, _rng.randf_range(-15.0, 15.0))
		ip.y = world.ground_y(ip.x, ip.z)
		director.spawn_scripted("errante", ip, _rng.randf() * TAU, Infected.S.INVESTIGATE)
	active_events.append({"id": "suprimentos", "pos": p, "t": 900.0, "nodes": [lc]})


func _horde() -> void:
	if director and director.has_method("_spawn_horde"):
		director._spawn_horde()
		EventBus.toast("Uma horda está migrando pela região.", "warn")


func _car_alarm() -> void:
	var p := _spot(35.0, 70.0)
	if p == Vector3.INF:
		return
	AudioManager.play_3d("alarm", p + Vector3(0, 1.0, 0), -4.0, 1.3, 120.0)
	EventBus.make_noise(p, 70.0, null, &"alarm")


func _patrol() -> void:
	var f: String = ["guarda", "remanescentes", "corvos", "despertos"][_rng.randi() % 4]
	var p := _spot(60.0, 100.0)
	if p == Vector3.INF:
		return
	var weapons: Dictionary = {"guarda": "revolver", "remanescentes": "cano_ferro", "corvos": "facao", "despertos": "lanca"}
	var nodes: Array = []
	var dest := player.global_position + (player.global_position - p).normalized() * 60.0
	for i in 3:
		var ap := p + Vector3(i * 1.5, 0, i * 0.7)
		ap.y = world.ground_y(ap.x, ap.z)
		var n := _survivor(ap, f, "guard", str(weapons[f]))
		n.home = dest
		n.routine = [[0, "guard", "home"]]
		nodes.append(n)
	active_events.append({"id": "patrulha", "pos": p, "t": 420.0, "nodes": nodes})


func _traveler() -> void:
	var p := _spot(40.0, 70.0)
	if p == Vector3.INF:
		return
	var n := _survivor(p, "", "trader", "faca_cozinha")
	n.trader = true
	n.trade_inv = Inventory.new("trade_" + n.npc_id, 80.0, 16, n.display_name)
	for s in LootTables.roll("camp", "stash", n.npc_id, "", 1.6):
		n.trade_inv.add_stack(s, true)
	for s in LootTables.roll("pharmacy", "shelf", n.npc_id + "m", "", 1.0):
		n.trade_inv.add_stack(s, true)
	n.routine = [[0, "wander", "wander"]]
	active_events.append({"id": "viajante", "pos": p, "t": 600.0, "nodes": [n]})


func _on_decision(d: String, choice: String) -> void:
	if d == "travessia" and choice == "sozinho":
		# a travessia sozinho atrai infectados para a margem sul
		GameState.set_flag("travessia_perigosa", true)


## Chamado pelo Game quando o jogador chega à margem sul (m4_ponte).
func on_crossed_river() -> void:
	if GameState.has_flag("travessia_perigosa") and not GameState.has_flag("travessia_evento"):
		GameState.set_flag("travessia_evento", true)
		for i in 7:
			var ip := player.global_position + Vector3(_rng.randf_range(-25.0, 25.0), 0, _rng.randf_range(10.0, 35.0))
			ip.y = world.ground_y(ip.x, ip.z)
			director.spawn_scripted(["errante", "febril", "errante", "sentinela"][i % 4], ip, _rng.randf() * TAU, Infected.S.INVESTIGATE)


func to_dict() -> Dictionary:
	return {"cooldowns": cooldowns}


func from_dict(d: Dictionary) -> void:
	cooldowns = d.get("cooldowns", {})
