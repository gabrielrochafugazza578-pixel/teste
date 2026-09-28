class_name SurvivorManager
extends Node3D
## Popula sobreviventes perto do jogador (bases das facções, NPCs da
## história), guarda a memória de cada um (relação com o jogador, vivo ou
## morto, onde mora agora) e resolve hostilidade, agressões e companheiros.
## Longe do jogador os NPCs viram dados (sem nós na cena).

const SPAWN_R := 150.0
const DESPAWN_R := 210.0

var player: Player = null
var world: World = null
var director: Node = null
var spawned: Dictionary = {}       # id -> SurvivorNPC
var memory: Dictionary = {}        # id -> {"rel": float, "alive": bool, "home_poi": String, "met": bool, "hp": float}
var aggro: Dictionary = {}         # facção -> segundos restantes
var infected_timers: Dictionary = {}   # id -> segundos até virar
var camp_stations: Dictionary = {} # camp -> Station (fogueira)
var _tick: float = 0.0
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	EventBus.noise_emitted.connect(_on_noise)
	EventBus.hour_changed.connect(_on_hour)


func setup(p: Player, w: World, d: Node) -> void:
	player = p
	world = w
	director = d
	if d:
		d.survivor_manager = self
	MissionManager.npc_resolver = npc_position


# ---------------------------------------------------------------------------
# Presença e população
# ---------------------------------------------------------------------------
func _mem(id: String) -> Dictionary:
	if not memory.has(id):
		memory[id] = {"rel": 0.0, "alive": true, "home_poi": "", "met": false}
	return memory[id]


func _named_present(id: String) -> bool:
	var d := NPCDB.named(id)
	var m := _mem(id)
	if not bool(m["alive"]):
		return false
	var pr: Dictionary = d.get("present", {})
	if pr.get("setor7", false):
		return false   # instanciados pela localização do Setor 7
	if str(m["home_poi"]) != "":
		return true
	if pr.has("chapter_min") and StoryManager.chapter < int(pr["chapter_min"]):
		return false
	if pr.has("not_flag") and GameState.has_flag(str(pr["not_flag"])):
		return false
	if pr.has("mission"):
		var mid: String = pr["mission"]
		if not MissionManager.is_active(mid) and not MissionManager.is_done(mid):
			return false
	return true


func home_of(id: String) -> Vector3:
	var d := NPCDB.named(id)
	var m := _mem(id)
	var poi: String = m["home_poi"] if str(m["home_poi"]) != "" else str(d.get("poi", ""))
	var base := world.poi_pos(poi) if world else Vector3.ZERO
	var off: Array = d.get("offset", [0.0, 0.0, 0.0])
	if str(m["home_poi"]) != "":
		var h := Util.hash_str(id)
		off = [float(h % 7) - 3.0, 0.0, float((h / 7) % 7) - 3.0]
	var p := base + Vector3(off[0], 0.0, off[2])
	if world:
		p.y = world.ground_y(p.x, p.z) if not world.layout.in_tunnel(p) else base.y
	return p


## Posição de um NPC (missões/HUD).
func npc_position(id: String) -> Vector3:
	if spawned.has(id) and is_instance_valid(spawned[id]):
		return (spawned[id] as Node3D).global_position
	if NPCDB.NAMED.has(id):
		var pr: Dictionary = NPCDB.named(id).get("present", {})
		if pr.get("setor7", false):
			return world.poi_pos("setor7") if world else Vector3.INF
		return home_of(id)
	return Vector3.INF


func _process(delta: float) -> void:
	if player == null or world == null:
		return
	for f in aggro.keys():
		aggro[f] = float(aggro[f]) - delta
		if float(aggro[f]) <= 0.0:
			aggro.erase(f)
	for id in infected_timers.keys():
		infected_timers[id] = float(infected_timers[id]) - delta
		if float(infected_timers[id]) <= 0.0:
			infected_timers.erase(id)
			_turn(id)
	_tick -= delta
	if _tick > 0.0:
		return
	_tick = 1.0
	if GameState.world_phase != GameState.Phase.POST or player.cinematic:
		return
	var pp := player.global_position
	# NPCs nomeados
	for id in NPCDB.NAMED.keys():
		var want := _named_present(id)
		var h := home_of(id) if want else Vector3.ZERO
		var near := want and Vector2(h.x - pp.x, h.z - pp.z).length() < SPAWN_R
		if spawned.has(id):
			var n: SurvivorNPC = spawned[id]
			if not is_instance_valid(n):
				spawned.erase(id)
				continue
			if n.follow_target != null:
				continue
			if not want or n.global_position.distance_to(pp) > DESPAWN_R:
				_despawn(id)
		elif near:
			_spawn_named(id, h)
	# membros das bases
	for camp in NPCDB.CAMPS.keys():
		var c: Dictionary = NPCDB.CAMPS[camp]
		if c.has("chapter_min") and StoryManager.chapter < int(c["chapter_min"]):
			continue
		var cp := world.poi_pos(str(c["poi"]))
		var dist := Vector2(cp.x - pp.x, cp.z - pp.z).length()
		var n_alive := int(_mem("camp_" + camp).get("alive_count", int(c["count"])))
		if dist < SPAWN_R:
			for i in mini(n_alive, _cap_for(camp)):
				var id := "camp_%s_%d" % [camp, i]
				if not spawned.has(id) and bool(_mem(id)["alive"]):
					_spawn_member(camp, i)
			if not camp_stations.has(camp):
				_make_camp_fire(camp, cp)
		elif dist > DESPAWN_R:
			for i in int(c["count"]):
				var id := "camp_%s_%d" % [camp, i]
				if spawned.has(id) and (spawned[id] as SurvivorNPC).follow_target == null:
					_despawn(id)
			if camp_stations.has(camp):
				(camp_stations[camp] as Node).queue_free()
				camp_stations.erase(camp)
	_check_escorts()
	_emergent_events()


func _cap_for(camp: String) -> int:
	var c: Dictionary = NPCDB.CAMPS[camp]
	return maxi(2, int(round(int(c["count"]) * clampf(float(Settings.get_npc_cap()) / 24.0, 0.35, 1.0))))


func _faction_of_camp(camp: String) -> String:
	var c: Dictionary = NPCDB.CAMPS[camp]
	return str(c.get("faction", camp))


func _camp_anchor(camp: String, cp: Vector3) -> Dictionary:
	var c: Dictionary = NPCDB.CAMPS[camp]
	var r := float(c["radius"])
	var h := Util.hash_str(camp)
	var fire := cp + Vector3(cos(h * 0.1) * r * 0.35, 0, sin(h * 0.1) * r * 0.35)
	fire.y = world.ground_y(fire.x, fire.z)
	return {"fire_center": fire, "radius": r}


func _make_camp_fire(camp: String, cp: Vector3) -> void:
	var a := _camp_anchor(camp, cp)
	if camp in ["guarda", "corvalis"]:
		camp_stations[camp] = Node3D.new()
		add_child(camp_stations[camp])
		return
	var root := Node3D.new()
	add_child(root)
	root.global_position = a["fire_center"]
	var mi := MeshInstance3D.new()
	mi.mesh = PropLib.mesh("campfire")
	root.add_child(mi)
	var st := Station.new()
	root.add_child(st)
	st.setup("fire", Vector3.ZERO, 0.0, "campfire_" + camp)
	# barracas ao redor
	for k in 3:
		var ang := float(k) * 2.1 + 0.4
		var t := MeshInstance3D.new()
		t.mesh = PropLib.mesh("tent" if k != 1 else "tarp_shelter")
		root.add_child(t)
		var tp := Vector3(cos(ang), 0, sin(ang)) * (float(a["radius"]) * 0.55)
		t.position = tp + Vector3(0, world.ground_y(root.global_position.x + tp.x, root.global_position.z + tp.z) - root.global_position.y, 0)
		t.rotation.y = -ang + PI * 0.5
	camp_stations[camp] = root


func _spawn_named(id: String, pos: Vector3) -> void:
	var d := NPCDB.named(id).duplicate()
	d["id"] = id
	d["named"] = true
	d["pos"] = pos
	d["appearance"] = NPCDB.appearance_for(id)
	var m := _mem(id)
	if m.has("hp"):
		d["hp"] = m["hp"]
	var poi: String = m["home_poi"] if str(m["home_poi"]) != "" else str(d.get("poi", ""))
	for camp in NPCDB.CAMPS.keys():
		if str(NPCDB.CAMPS[camp]["poi"]) == poi:
			var a := _camp_anchor(camp, world.poi_pos(poi))
			var fc: Vector3 = a["fire_center"]
			var ang := float(Util.hash_str(id) % 628) / 100.0
			d["anchors"] = {"fire": fc + Vector3(cos(ang), 0, sin(ang)) * 1.7, "fire_center": fc,
				"sleep": fc + Vector3(cos(ang), 0, sin(ang)) * 4.5, "post": pos}
			break
	var n := SurvivorNPC.new()
	n.name = "NPC_" + id
	add_child(n)
	n.setup(d, self, world)
	spawned[id] = n
	if bool(m.get("follow", false)) and player:
		n.start_follow(player)


func _spawn_member(camp: String, i: int) -> void:
	var c: Dictionary = NPCDB.CAMPS[camp]
	var f := _faction_of_camp(camp)
	var cp := world.poi_pos(str(c["poi"]))
	var r := Util.rng(Util.hash_str(camp) * 17 + i * 131)
	var fighter_role := r.randf() < float(c["fighters"])
	var ap := Appearance.survivor(FactionManager.color(f), Util.hash_str(camp) % 1000 + i * 7, fighter_role)
	if f == "guarda" and fighter_role:
		ap = Appearance.police(Util.hash_str(camp) % 1000 + i * 7)
		ap["tear"] = 0.1
		ap["grime"] = 0.35
	elif f == "corvalis":
		ap = Appearance.police(Util.hash_str(camp) % 1000 + i * 7)
		ap["top_color"] = Color(0.08, 0.08, 0.09)
		ap["bottom_color"] = Color(0.07, 0.07, 0.08)
		ap["hat"] = "helmet"
		ap["hat_color"] = Color(0.06, 0.06, 0.07)
		ap["mask"] = true
	ap["id"] = "npc_camp_%s_%d" % [camp, i]
	var a := _camp_anchor(camp, cp)
	var rad := float(a["radius"])
	var ang := r.randf() * TAU
	var home := cp + Vector3(cos(ang), 0, sin(ang)) * r.randf_range(2.0, rad * 0.8)
	home.y = world.ground_y(home.x, home.z)
	var post := cp + Vector3(cos(ang), 0, sin(ang)) * rad
	post.y = world.ground_y(post.x, post.z)
	var fc: Vector3 = a["fire_center"]
	var weapons: Array = c["weapons"]
	var routine: Array
	if fighter_role:
		routine = [[6, "guard", "post"], [14, "wander", "wander"], [19, "warm", "fire"], [23, "guard", "post"]] if i % 2 == 0 \
			else [[0, "sleep", "sleep"], [7, "wander", "wander"], [12, "guard", "post"], [20, "warm", "fire"]]
	else:
		routine = [[6, "carry", "home"], [10, "wander", "wander"], [13, "sit", "home"], [17, "warm", "fire"], [22, "sleep", "sleep"]]
	var female := bool(ap["female"])
	var d := {"id": "camp_%s_%d" % [camp, i], "name": NPCDB.random_name(r, female), "faction": f, "camp": camp,
		"role": "guard" if fighter_role else "worker", "weapon": str(weapons[r.randi() % weapons.size()]) if fighter_role else "",
		"trader": i == 1 and f in ["remanescentes", "guarda", "corvos"], "pos": home, "appearance": ap, "routine": routine,
		"anchors": {"post": post, "fire": fc + Vector3(cos(ang), 0, sin(ang)) * r.randf_range(1.4, 2.2), "fire_center": fc,
			"sleep": fc + Vector3(cos(ang), 0, sin(ang)) * r.randf_range(3.5, 6.0)}}
	var n := SurvivorNPC.new()
	n.name = "NPC_" + str(d["id"])
	add_child(n)
	n.setup(d, self, world)
	spawned[d["id"]] = n


func _despawn(id: String) -> void:
	var n: SurvivorNPC = spawned[id]
	spawned.erase(id)
	if is_instance_valid(n):
		var m := _mem(id)
		m["hp"] = n.hp
		n.queue_free()


## Instancia um NPC nomeado numa posição exata (Setor 7, cinemáticas).
func spawn_named_at(id: String, pos: Vector3, yaw: float = 0.0) -> SurvivorNPC:
	if spawned.has(id) and is_instance_valid(spawned[id]):
		(spawned[id] as Node3D).global_position = pos
		return spawned[id]
	var d := NPCDB.named(id).duplicate()
	d["id"] = id
	d["named"] = true
	d["pos"] = pos
	d["yaw"] = yaw
	d["appearance"] = NPCDB.appearance_for(id)
	var n := SurvivorNPC.new()
	add_child(n)
	n.setup(d, self, world)
	spawned[id] = n
	return n


func npcs_near(pos: Vector3, radius: float) -> Array:
	var out: Array = []
	var r2 := radius * radius
	for id in spawned.keys():
		var n: SurvivorNPC = spawned[id]
		if is_instance_valid(n) and n.is_alive() and n.state != SurvivorNPC.S.DOWNED and n.global_position.distance_squared_to(pos) < r2:
			out.append(n)
	return out


func get_npc(id: String) -> SurvivorNPC:
	var n = spawned.get(id, null)
	return n if is_instance_valid(n) else null


# ---------------------------------------------------------------------------
# Atitude / hostilidade
# ---------------------------------------------------------------------------
func attitude_of(n: SurvivorNPC) -> String:
	if n.faction == "":
		return "friendly"
	if aggro.has(n.faction):
		return "hostile"
	var rel := float(_mem(n.npc_id)["rel"])
	if rel <= -50.0:
		return "hostile"
	var a := FactionManager.attitude(n.faction)
	if rel >= 40.0 and a == "wary":
		return "neutral"
	return a


func is_hostile_to_player(n: SurvivorNPC) -> bool:
	if n.named and n.essential and not aggro.has(n.faction):
		return false
	return attitude_of(n) == "hostile"


func set_aggro(f: String, seconds: float) -> void:
	if f == "":
		return
	var was := aggro.has(f)
	aggro[f] = maxf(float(aggro.get(f, 0.0)), seconds)
	if not was:
		EventBus.toast("%s estão hostis!" % FactionManager.faction_name(f), "warn")


func on_player_attacked(n: SurvivorNPC, count_rep: bool) -> void:
	var m := _mem(n.npc_id)
	m["rel"] = float(m["rel"]) - 25.0
	if n.faction != "":
		if count_rep:
			FactionManager.change_rep(n.faction, -6.0, "agressão")
		set_aggro(n.faction, 90.0)
		for o in npcs_near(n.global_position, 25.0):
			var on := o as SurvivorNPC
			if on.faction == n.faction and on.fighter and on != n:
				on.target = player
				on.set_state(SurvivorNPC.S.FIGHT)


func on_downed(n: SurvivorNPC) -> void:
	EventBus.toast("%s foi derrubado!" % n.display_name, "warn")


func on_npc_died(n: SurvivorNPC, killer: Node) -> void:
	var m := _mem(n.npc_id)
	m["alive"] = false
	if n.npc_id == "leme":
		GameState.set_flag("leme_dead", true)
		EventBus.subtitle.emit("Você... não faz ideia... do que está jogando fora...", n.display_name, 3.5)
	elif n.npc_id.begins_with("s7_guard_"):
		GameState.set_flag(n.npc_id + "_dead", true)
	if n.camp != "":
		var cm := _mem("camp_" + n.camp)
		cm["alive_count"] = maxi(0, int(cm.get("alive_count", int(NPCDB.CAMPS[n.camp]["count"]))) - 1)
	if killer is Player:
		GameState.add_stat("npc_killed")


func mark_infected(n: SurvivorNPC) -> void:
	if infected_timers.has(n.npc_id):
		return
	infected_timers[n.npc_id] = _rng.randf_range(40.0, 90.0)


func _turn(id: String) -> void:
	var n := get_npc(id)
	if n == null or not n.is_alive():
		_mem(id)["alive"] = false
		return
	var pos := n.global_position
	var yaw := n.global_rotation.y
	if player and pos.distance_to(player.global_position) < 20.0:
		EventBus.subtitle.emit("Eu... não tô me sentindo bem...", n.display_name, 3.0)
	n.die(null)
	if director and director.has_method("spawn_scripted"):
		director.spawn_scripted("errante", pos, yaw, Infected.S.IDLE)


# ---------------------------------------------------------------------------
# Relações pessoais (memória)
# ---------------------------------------------------------------------------
func change_rel(id: String, delta: float) -> void:
	var m := _mem(id)
	m["rel"] = clampf(float(m["rel"]) + delta, -100.0, 100.0)


func rel(id: String) -> float:
	return float(_mem(id)["rel"])


func mark_met(id: String) -> void:
	_mem(id)["met"] = true


func relocate(id: String, poi: String) -> void:
	var m := _mem(id)
	m["home_poi"] = poi
	m["follow"] = false
	var n := get_npc(id)
	if n == null:
		return
	var h := home_of(id)
	if n.global_position.distance_to(h) > 120.0:
		EventBus.toast("%s seguirá para %s." % [n.display_name, _poi_name(poi)], "info")
		_despawn(id)
	else:
		n.relocate(h)


func _poi_name(poi: String) -> String:
	if world and world.layout.pois.has(poi):
		return str(world.layout.pois[poi]["name"])
	return poi


func set_following(id: String, on: bool) -> void:
	var n := get_npc(id)
	_mem(id)["follow"] = on
	if n == null:
		return
	if on:
		n.start_follow(player)
	else:
		n.stop_follow()


func followers() -> Array:
	var out: Array = []
	for id in spawned.keys():
		var n: SurvivorNPC = spawned[id]
		if is_instance_valid(n) and n.follow_target != null:
			out.append(n)
	return out


func _check_escorts() -> void:
	# Sofia levada ao estádio em segurança
	var s := get_npc("sofia")
	if s != null and s.follow_target != null and not GameState.has_flag("sofia_safe"):
		if s.global_position.distance_to(world.poi_pos("estadio")) < 30.0:
			GameState.set_flag("sofia_safe", true)
			set_following("sofia", false)
			relocate("sofia", "estadio")
			EventBus.subtitle.emit("Tem outras crianças aqui? De verdade?", "Sofia", 3.0)
			change_rel("sofia", 40.0)
			EventBus.npc_helped.emit("sofia")


## Eventos emergentes ligados a NPCs (encontros e pedidos de ajuda).
func _emergent_events() -> void:
	var pp := player.global_position
	# a menina da escola: batidas na janela quando o jogador passa perto
	if StoryManager.chapter >= 2 and not MissionManager.is_active("s_sofia") and not MissionManager.is_done("s_sofia"):
		var ep := world.poi_pos("escola")
		if ep != Vector3.ZERO and pp.distance_to(ep) < 55.0:
			AudioManager.play_3d("door_bash", ep + Vector3(0, 3.0, 0), -6.0, 1.6)
			EventBus.subtitle.emit("(Batidas vindas de uma janela da escola.)", "", 3.0)
			MissionManager.start("s_sofia")
	if StoryManager.chapter >= 6 and not MissionManager.is_active("s_otavio") and not MissionManager.is_done("s_otavio") and GameState.has_flag("evolution"):
		MissionManager.start("s_otavio")


func _on_hour(_h: int) -> void:
	# reabastece comerciantes uma vez por dia (06h)
	if TimeManager.hour >= 6.0 and TimeManager.hour < 7.0:
		for id in spawned.keys():
			var n: SurvivorNPC = spawned[id]
			if is_instance_valid(n) and n.trader:
				n._restock()
	# necessidades básicas dos NPCs: consomem recursos da facção
	for id in spawned.keys():
		var n: SurvivorNPC = spawned[id]
		if is_instance_valid(n) and n.hunger > 0.7 and n.faction != "":
			var st: Dictionary = FactionManager.state.get(n.faction, {})
			var res: Dictionary = st.get("resources", {})
			if float(res.get("food", 0.0)) > 0.5:
				res["food"] = float(res["food"]) - 0.3
				n.hunger = 0.1


func _on_noise(pos: Vector3, radius: float, source: Node, kind: StringName) -> void:
	if source is SurvivorNPC:
		return
	if kind == &"gunshot" and source is Player:
		for o in npcs_near(pos, radius * 0.5):
			var n := o as SurvivorNPC
			if not n.fighter and n.state in [SurvivorNPC.S.IDLE, SurvivorNPC.S.MOVE]:
				n.fear = 1.0
				n._flee_from = pos
				n.set_state(SurvivorNPC.S.FLEE)
			elif n.fighter and n.faction != "" and attitude_of(n) == "wary":
				change_rel(n.npc_id, -5.0)


# ---------------------------------------------------------------------------
# Save
# ---------------------------------------------------------------------------
func to_dict() -> Dictionary:
	for id in spawned.keys():
		var n: SurvivorNPC = spawned[id]
		if is_instance_valid(n):
			var m := _mem(id)
			m["hp"] = n.hp
			m["follow"] = n.follow_target != null
	return {"memory": memory.duplicate(true), "aggro": aggro.duplicate()}


func from_dict(d: Dictionary) -> void:
	for id in spawned.keys().duplicate():
		_despawn(id)
	memory = d.get("memory", {})
	aggro = d.get("aggro", {})
