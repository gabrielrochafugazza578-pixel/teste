extends Node
## FactionManager — grupos sobreviventes, reputação do jogador, relações
## entre facções e simulação abstrata (recursos, patrulhas, conflitos)
## executada por hora de jogo (não por frame).

const DEFS := {
	"remanescentes": {
		"name": "Os Remanescentes", "leader": "Marta Albuquerque", "hq": "estadio", "color": Color(0.35, 0.55, 0.35),
		"desc": "Famílias, vizinhos e ex-funcionários do São Lucas abrigados no Estádio Municipal. Precisam de remédios, comida e esperança.",
		"territory": ["estadio", "vila_operaria"], "goal": "Proteger as crianças e sobreviver ao próximo inverno.",
		"resources": {"food": 45.0, "water": 60.0, "meds": 6.0, "materials": 30.0, "arms": 8.0}, "members": 34, "fighters": 10,
	},
	"guarda": {
		"name": "Guarda Aurora", "leader": "Comandante Rui Tavares", "hq": "delegacia", "color": Color(0.22, 0.32, 0.58),
		"desc": "O que restou da guarda municipal e da polícia. Mantêm a ordem à força e controlam as pontes e a Delegacia Central.",
		"territory": ["delegacia", "checkpoint_ponte", "centro"], "goal": "Restaurar a ordem — a qualquer custo.",
		"resources": {"food": 55.0, "water": 50.0, "meds": 12.0, "materials": 40.0, "arms": 45.0}, "members": 26, "fighters": 20,
	},
	"despertos": {
		"name": "Os Despertos", "leader": "Irmão Tadeu", "hq": "igreja_despertos", "color": Color(0.42, 0.26, 0.48),
		"desc": "Uma seita que acredita que o NEXUS é o próximo passo da humanidade. Protegem os Hospedeiros e sequestram imunes.",
		"territory": ["igreja_despertos", "parque_norte"], "goal": "Guiar todos ao Despertar.",
		"resources": {"food": 25.0, "water": 30.0, "meds": 4.0, "materials": 15.0, "arms": 12.0}, "members": 18, "fighters": 9,
	},
	"corvos": {
		"name": "Corvos do Rio", "leader": "Bento \"Corvo\" Siqueira", "hq": "acampamento_rio", "color": Color(0.5, 0.16, 0.12),
		"desc": "Saqueadores que cobram pedágio na Ponte Velha e vivem do que os outros perdem.",
		"territory": ["acampamento_rio", "ponte_velha"], "goal": "Tomar o que puderem, enquanto puderem.",
		"resources": {"food": 35.0, "water": 30.0, "meds": 5.0, "materials": 35.0, "arms": 25.0}, "members": 16, "fighters": 14,
	},
	"corvalis": {
		"name": "Segurança Corvalis", "leader": "Diretor Augusto Leme", "hq": "corvalis", "color": Color(0.15, 0.15, 0.17),
		"desc": "Seguranças privados leais à empresa responsável pelo Projeto NEXUS. Guardam o Complexo e o Centro de Triagem.",
		"territory": ["corvalis", "fazenda_santa_clara"], "goal": "Proteger os segredos do NEXUS e concluir o NEXUS-3.",
		"resources": {"food": 60.0, "water": 60.0, "meds": 30.0, "materials": 50.0, "arms": 60.0}, "members": 20, "fighters": 18,
	},
}

var reputation: Dictionary = {}
var relations: Dictionary = {}
var state: Dictionary = {}
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	reset()
	EventBus.hour_changed.connect(_on_hour)
	EventBus.npc_killed.connect(_on_npc_killed)
	EventBus.npc_helped.connect(_on_npc_helped)


func reset() -> void:
	reputation = {"remanescentes": 0.0, "guarda": 0.0, "despertos": -10.0, "corvos": -20.0, "corvalis": -100.0}
	relations = {}
	_set_rel("remanescentes", "guarda", 10)
	_set_rel("remanescentes", "despertos", -40)
	_set_rel("remanescentes", "corvos", -50)
	_set_rel("remanescentes", "corvalis", -60)
	_set_rel("guarda", "despertos", -30)
	_set_rel("guarda", "corvos", -70)
	_set_rel("guarda", "corvalis", -20)
	_set_rel("despertos", "corvos", -30)
	_set_rel("despertos", "corvalis", -50)
	_set_rel("corvos", "corvalis", -60)
	state = {}
	for id in DEFS.keys():
		var d: Dictionary = DEFS[id]
		state[id] = {"resources": (d["resources"] as Dictionary).duplicate(), "members": int(d["members"]), "fighters": int(d["fighters"]), "morale": 0.6}


func _key(a: String, b: String) -> String:
	return a + "|" + b if a < b else b + "|" + a


func _set_rel(a: String, b: String, v: float) -> void:
	relations[_key(a, b)] = clampf(v, -100.0, 100.0)


func relation(a: String, b: String) -> float:
	if a == b:
		return 100.0
	if a == "player":
		return rep(b)
	if b == "player":
		return rep(a)
	return float(relations.get(_key(a, b), 0.0))


func rep(f: String) -> float:
	return float(reputation.get(f, 0.0))


func change_rep(f: String, delta: float, reason: String = "") -> void:
	if not reputation.has(f):
		return
	reputation[f] = clampf(rep(f) + delta, -100.0, 100.0)
	EventBus.faction_reputation_changed.emit(f, reputation[f])
	if absf(delta) >= 5.0:
		var sg := "+" if delta > 0.0 else ""
		EventBus.toast("%s: %s%d reputação%s" % [DEFS[f]["name"], sg, int(delta), (" (" + reason + ")") if reason != "" else ""], "faction")
	# aliados/inimigos reagem parcialmente
	for other in DEFS.keys():
		if other == f:
			continue
		var rel := relation(f, other)
		if rel <= -40.0:
			reputation[other] = clampf(rep(other) - delta * 0.25, -100.0, 100.0)
		elif rel >= 30.0:
			reputation[other] = clampf(rep(other) + delta * 0.2, -100.0, 100.0)


func change_relation(a: String, b: String, delta: float) -> void:
	_set_rel(a, b, relation(a, b) + delta)
	EventBus.faction_relation_changed.emit(a, b, relation(a, b))


## Atitude de um membro da facção em relação ao jogador.
func attitude(f: String) -> String:
	var r := rep(f)
	if f == "corvalis":
		return "hostile"
	if r <= -40.0:
		return "hostile"
	if r < -10.0:
		return "wary"
	if r < 30.0:
		return "neutral"
	return "friendly"


func is_hostile(a: String, b: String) -> bool:
	return relation(a, b) <= -45.0


func faction_name(f: String) -> String:
	return str(DEFS.get(f, {}).get("name", f))


func color(f: String) -> Color:
	return DEFS.get(f, {}).get("color", Color.GRAY)


func add_resource(f: String, res: String, amount: float) -> void:
	if not state.has(f):
		return
	var r: Dictionary = state[f]["resources"]
	r[res] = maxf(0.0, float(r.get(res, 0.0)) + amount)


# ---------------------------------------------------------------------------
# Simulação abstrata (1x por hora de jogo)
# ---------------------------------------------------------------------------
func _on_hour(_h: int) -> void:
	if not GameState.in_game or GameState.world_phase != GameState.Phase.POST:
		return
	for f in state.keys():
		var s: Dictionary = state[f]
		var res: Dictionary = s["resources"]
		var members: int = s["members"]
		res["food"] = maxf(0.0, float(res["food"]) - members * 0.035)
		res["water"] = maxf(0.0, float(res["water"]) - members * 0.04)
		# expedições de coleta
		if _rng.randf() < 0.35:
			var gain := _rng.randf_range(1.0, 5.0)
			res["food"] = float(res["food"]) + gain
			res["water"] = float(res["water"]) + gain * 0.8
			res["materials"] = float(res["materials"]) + gain * 0.5
			if _rng.randf() < 0.05 and members > 3:
				s["members"] = members - 1
				EventBus.world_event.emit("loss_" + f, "%s perderam um batedor em uma expedição." % faction_name(f))
		var hungry := float(res["food"]) < members * 0.3
		s["morale"] = clampf(float(s["morale"]) + (-0.03 if hungry else 0.01), 0.0, 1.0)
	# conflitos entre facções hostis
	if _rng.randf() < 0.08:
		var ids := state.keys()
		var a: String = ids[_rng.randi() % ids.size()]
		var b: String = ids[_rng.randi() % ids.size()]
		if a != b and is_hostile(a, b) and a != "corvalis" and b != "corvalis":
			var sa: Dictionary = state[a]
			var sb: Dictionary = state[b]
			var pa := float(sa["fighters"]) * (0.5 + _rng.randf())
			var pb := float(sb["fighters"]) * (0.5 + _rng.randf())
			var winner := a if pa > pb else b
			var loser := b if winner == a else a
			var sl: Dictionary = state[loser]
			sl["fighters"] = maxi(1, int(sl["fighters"]) - 1)
			change_relation(a, b, -3.0)
			EventBus.world_event.emit("clash", "Rádio: confronto entre %s e %s. %s levaram a melhor." % [faction_name(a), faction_name(b), faction_name(winner)])


func _on_npc_killed(npc_id: String, faction_id: String, killer: Node) -> void:
	if faction_id == "" or not state.has(faction_id):
		return
	var s: Dictionary = state[faction_id]
	s["members"] = maxi(0, int(s["members"]) - 1)
	if killer != null and killer.is_in_group("player"):
		change_rep(faction_id, -25.0, "membro morto")


func _on_npc_helped(npc_id: String) -> void:
	pass


func to_dict() -> Dictionary:
	return {"reputation": reputation, "relations": relations, "state": state}


func from_dict(d: Dictionary) -> void:
	reset()
	var r: Dictionary = d.get("reputation", {})
	for k in r.keys():
		reputation[k] = float(r[k])
	var rel: Dictionary = d.get("relations", {})
	for k in rel.keys():
		relations[k] = float(rel[k])
	var st: Dictionary = d.get("state", {})
	for k in st.keys():
		state[k] = st[k]
