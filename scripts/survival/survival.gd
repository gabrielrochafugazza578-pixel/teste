class_name Survival
extends RefCounted
## Sistemas de sobrevivência interligados do jogador.
##
## Fome, sede, energia, resistência (stamina), temperatura corporal,
## sangramento, fratura, dor, infecção bacteriana de ferimentos, intoxicação
## alimentar, resfriado, infecção NEXUS, umidade do corpo e peso carregado.
## Taxas por HORA DE JOGO; atualizado a cada frame com custo desprezível.

signal status_changed
signal died(cause: String)
signal symptom(kind: String)

var health: float = 100.0
var hunger: float = 85.0
var thirst: float = 80.0
var energy: float = 75.0
var stamina: float = 100.0
var body_temp: float = 36.6
var bleeding: float = 0.0          # 0 nenhum, 1 leve, 2 moderado, 3 grave
var fracture: float = 0.0          # 0 nenhum; >0 horas restantes de recuperação
var splinted: bool = false
var pain: float = 0.0
var wound_infection: float = 0.0
var food_poisoning: float = 0.0
var cold: float = 0.0
var infection: float = 0.0         # NEXUS 0..100
var infection_incubation: float = 0.0
var inhibitor_hours: float = 0.0
var immunity: float = 0.0
var wetness: float = 0.0
var morale: float = 60.0
var fever: float = 0.0
var dead: bool = false

# entradas do mundo (definidas pelo jogador a cada frame)
var activity: float = 0.0          # 0 parado, 1 andando, 2 correndo/sprint
var ambient_temp: float = 22.0
var warmth: float = 0.2            # isolamento das roupas
var rain_protection: float = 0.0
var near_heat: bool = false
var exposed_to_rain: float = 0.0
var sleeping: bool = false
var weight_ratio: float = 0.0

var _stamina_delay: float = 0.0
var _symptom_timer: float = 6.0
var _rng := RandomNumberGenerator.new()


func _init() -> void:
	_rng.randomize()


func max_stamina() -> float:
	var m := 100.0
	if thirst < 20.0:
		m -= 20.0
	if energy < 20.0:
		m -= 30.0 * (1.0 - energy / 20.0)
	if body_temp < 35.2:
		m -= 20.0
	if fracture > 0.0:
		m -= 15.0
	m -= clampf(infection - 50.0, 0.0, 50.0) * 0.5
	m -= cold * 0.15 + food_poisoning * 0.2
	return clampf(m, 25.0, 100.0)


func speed_multiplier() -> float:
	var m := 1.0
	if fracture > 0.0:
		m *= 0.62 if not splinted else 0.8
	if weight_ratio > 0.75:
		m *= clampf(1.0 - (weight_ratio - 0.75) * 0.9, 0.45, 1.0)
	if stamina < 5.0:
		m *= 0.85
	return m


func can_sprint() -> bool:
	return stamina > 8.0 and weight_ratio < 1.05 and (fracture <= 0.0 or splinted) and not dead


func use_stamina(amount: float) -> bool:
	if stamina < amount * 0.5:
		return false
	stamina = maxf(0.0, stamina - amount * (1.0 + clampf(weight_ratio - 0.8, 0.0, 0.6)))
	_stamina_delay = 0.9
	return true


func update(dt: float, hours: float) -> void:
	if dead:
		return
	var dm := Settings.needs_multiplier()
	# --- necessidades básicas ---------------------------------------------------
	var act := 1.0 + activity * 0.35
	var sleep_m := 0.5 if sleeping else 1.0
	hunger = maxf(0.0, hunger - 4.2 * hours * act * dm * sleep_m)
	var heat := clampf((ambient_temp - 26.0) / 10.0, 0.0, 1.0)
	thirst = maxf(0.0, thirst - 6.0 * hours * act * (1.0 + heat * 0.6 + fever * 0.01) * dm * sleep_m)
	if sleeping:
		energy = minf(100.0, energy + 12.5 * hours)
	else:
		energy = maxf(0.0, energy - 3.2 * hours * (1.0 + activity * 0.25) * dm)
	# --- resistência ---------------------------------------------------------
	_stamina_delay -= dt
	if _stamina_delay <= 0.0:
		var regen := 16.0
		if hunger < 20.0:
			regen *= 0.6
		if energy < 25.0:
			regen *= 0.7
		if activity >= 2.0:
			regen = 0.0
		stamina = minf(max_stamina(), stamina + regen * dt)
	stamina = minf(stamina, max_stamina())
	# --- temperatura corporal -----------------------------------------------
	var eff_ambient := ambient_temp + warmth * 9.0 - wetness * 7.0 + (9.0 if near_heat else 0.0) + activity * 1.5
	var target_body := 36.6 + clampf((eff_ambient - 21.0) * 0.08, -2.5, 1.2) + fever * 0.03
	body_temp = lerpf(body_temp, target_body, clampf(hours * 0.9, 0.0, 1.0))
	# --- umidade ---------------------------------------------------------------
	if exposed_to_rain > 0.0:
		wetness = minf(1.0, wetness + exposed_to_rain * (1.0 - rain_protection) * dt * 0.02)
	else:
		wetness = maxf(0.0, wetness - dt * (0.004 + (0.03 if near_heat else 0.0)))
	# --- ferimentos ---------------------------------------------------------------
	if bleeding > 0.0:
		health -= bleeding * 0.55 * dt
		if bleeding <= 1.0 and _rng.randf() < dt * 0.012:
			bleeding = 0.0
			EventBus.toast("O sangramento parou.", "info")
	if fracture > 0.0:
		fracture = maxf(0.0, fracture - hours * (1.0 if splinted else 0.25))
		pain = maxf(pain, 35.0 if not splinted else 15.0)
		if fracture <= 0.0:
			splinted = false
			EventBus.toast("Sua perna se recuperou da fratura.", "good")
	pain = maxf(0.0, pain - hours * 8.0)
	# --- doenças ---------------------------------------------------------------
	if wound_infection > 0.0:
		wound_infection = minf(100.0, wound_infection + hours * 3.5)
		if wound_infection > 60.0:
			health -= hours * 3.0
	if food_poisoning > 0.0:
		food_poisoning = maxf(0.0, food_poisoning - hours * 9.0)
		thirst = maxf(0.0, thirst - hours * 5.0)
	if body_temp < 35.8 and wetness > 0.4 and cold <= 0.0 and _rng.randf() < hours * 0.25 * (1.0 - immunity):
		cold = 20.0
		EventBus.toast("Você pegou um resfriado.", "warn")
	if cold > 0.0:
		cold = maxf(0.0, cold + hours * (2.0 if body_temp < 36.0 else -4.0 - (6.0 if sleeping else 0.0)))
		cold = minf(cold, 100.0)
	immunity = maxf(0.0, immunity - hours * 0.02)
	# --- NEXUS ----------------------------------------------------------------------
	if infection > 0.0:
		if infection_incubation > 0.0:
			infection_incubation -= hours
		else:
			var rate := 1.5 * dm
			if inhibitor_hours > 0.0:
				rate *= 0.15
			infection = minf(100.0, infection + rate * hours)
		inhibitor_hours = maxf(0.0, inhibitor_hours - hours)
		if infection >= 100.0:
			_die("infection")
			return
	fever = clampf(maxf(infection - 25.0, 0.0) * 0.9 + wound_infection * 0.5 + cold * 0.3, 0.0, 100.0)
	# --- efeitos de necessidades zeradas --------------------------------------
	if hunger <= 0.0:
		health -= 4.0 * hours
	elif hunger < 20.0:
		health -= 0.5 * hours
	if thirst <= 0.0:
		health -= 7.0 * hours
	if energy <= 0.0:
		health -= 1.5 * hours
	if body_temp < 34.8:
		health -= 3.0 * hours
	# regeneração natural lenta se bem cuidado
	if hunger > 50.0 and thirst > 50.0 and bleeding <= 0.0 and wound_infection < 20.0 and infection < 40.0:
		health = minf(100.0, health + hours * (2.5 + (4.0 if sleeping else 0.0)))
	morale = clampf(morale + hours * (1.0 if hunger > 50.0 and thirst > 50.0 else -1.5), 0.0, 100.0)
	# --- sintomas (tosse revela posição!) -------------------------------------------
	_symptom_timer -= dt
	if _symptom_timer <= 0.0:
		_symptom_timer = _rng.randf_range(12.0, 40.0)
		if cold > 25.0 and _rng.randf() < 0.6:
			symptom.emit("cough")
		elif food_poisoning > 40.0 and _rng.randf() < 0.3:
			symptom.emit("vomit")
		elif infection > 45.0 and _rng.randf() < 0.4:
			symptom.emit("hallucination")
	if health <= 0.0:
		_die(_death_cause())


func _death_cause() -> String:
	if thirst <= 0.0:
		return "thirst"
	if hunger <= 0.0:
		return "hunger"
	if bleeding > 0.0:
		return "bleeding"
	if body_temp < 34.8:
		return "cold"
	return "wounds"


func _die(cause: String) -> void:
	if dead:
		return
	dead = true
	health = 0.0
	died.emit(cause)


## Dano direto (já com armadura/dificuldade aplicados).
func damage(amount: float, kind: String = "blunt", infection_chance: float = 0.0) -> void:
	if dead:
		return
	health -= amount
	pain = minf(100.0, pain + amount * 1.2)
	match kind:
		"bite", "scratch", "sharp":
			if _rng.randf() < clampf(amount / 30.0, 0.15, 0.9):
				bleeding = minf(3.0, bleeding + (1.0 if amount < 18.0 else 2.0))
			if _rng.randf() < 0.18:
				wound_infection = maxf(wound_infection, 5.0)
		"heavy":
			if _rng.randf() < clampf(amount / 60.0, 0.05, 0.5) and fracture <= 0.0:
				fracture = 72.0
				splinted = false
				EventBus.toast("Você fraturou a perna!", "danger")
	if infection_chance > 0.0 and _rng.randf() < infection_chance:
		if infection <= 0.0:
			infection = 1.0
			infection_incubation = _rng.randf_range(2.0, 6.0)
			EventBus.toast("A ferida arde... você pode ter sido infectado.", "danger")
		else:
			infection = minf(100.0, infection + 8.0)
	if health <= 0.0:
		_die("wounds")
	status_changed.emit()


## Aplica efeitos de um item consumível. Retorna texto de feedback.
func consume(def: Dictionary, freshness: float = 1.0) -> String:
	var u: Dictionary = def.get("use", {})
	var spoiled := freshness < 0.35
	for k in u.keys():
		var v = u[k]
		match k:
			"hunger": hunger = clampf(hunger + float(v) * (0.6 if spoiled else 1.0), 0.0, 100.0)
			"thirst": thirst = clampf(thirst + float(v), 0.0, 100.0)
			"energy": energy = clampf(energy + float(v), 0.0, 100.0)
			"stamina": stamina = clampf(stamina + float(v), 0.0, max_stamina())
			"health": health = clampf(health + float(v), 0.0, 100.0)
			"warmth": body_temp = minf(37.2, body_temp + float(v) * 0.02)
			"morale": morale = clampf(morale + float(v), 0.0, 100.0)
			"pain": pain = clampf(pain + float(v), 0.0, 100.0)
			"fever": wound_infection = maxf(0.0, wound_infection + float(v) * 0.2)
			"stop_bleed": bleeding = 0.0
			"fix_fracture":
				if fracture > 0.0:
					splinted = true
			"fix_deep_wound": bleeding = 0.0
			"immunity": immunity = clampf(immunity + float(v), 0.0, 0.8)
			"infection":
				infection = maxf(0.0, infection + float(v))
				inhibitor_hours = 24.0
			"cure":
				for c in v:
					match str(c):
						"food_poisoning": food_poisoning = 0.0
						"wound_infection": wound_infection = 0.0
						"cold": cold = 0.0
			"sickness":
				var sick: Dictionary = v
				for sk in sick.keys():
					var ch := float(sick[sk]) * (1.6 if spoiled else 1.0)
					if _rng.randf() < ch:
						if sk == "food_poisoning":
							food_poisoning = maxf(food_poisoning, 60.0)
							EventBus.toast("Seu estômago revira...", "warn")
						elif sk == "wound_infection":
							wound_infection = maxf(wound_infection, 8.0)
	status_changed.emit()
	return ""


## Lista de condições para o HUD: [[id, texto, gravidade 0..2]]
func conditions() -> Array:
	var c: Array = []
	if bleeding > 0.0:
		c.append(["bleeding", ["", "Sangramento leve", "Sangramento", "Hemorragia"][clampi(int(ceil(bleeding)), 0, 3)], 2 if bleeding > 1.5 else 1])
	if fracture > 0.0:
		c.append(["fracture", "Fratura" + (" (imobilizada)" if splinted else ""), 1 if splinted else 2])
	if infection > 0.0 and infection_incubation <= 0.0:
		c.append(["infection", "Infecção NEXUS %d%%" % int(infection), 2 if infection > 50.0 else 1])
	if wound_infection > 15.0:
		c.append(["wound_infection", "Ferida infeccionada", 2 if wound_infection > 60.0 else 1])
	if food_poisoning > 5.0:
		c.append(["food_poisoning", "Intoxicação alimentar", 1])
	if cold > 5.0:
		c.append(["cold", "Resfriado", 1])
	if body_temp < 35.5:
		c.append(["hypothermia", "Frio intenso" if body_temp > 34.8 else "Hipotermia", 2 if body_temp < 35.0 else 1])
	if body_temp > 37.8:
		c.append(["fever", "Febre", 1])
	if hunger < 20.0:
		c.append(["hunger", "Faminto" if hunger > 0.0 else "Inanição", 2 if hunger <= 0.0 else 1])
	if thirst < 20.0:
		c.append(["thirst", "Com sede" if thirst > 0.0 else "Desidratado", 2 if thirst <= 0.0 else 1])
	if energy < 20.0:
		c.append(["energy", "Exausto", 2 if energy <= 5.0 else 1])
	if wetness > 0.5:
		c.append(["wet", "Encharcado", 0])
	if pain > 40.0:
		c.append(["pain", "Dor", 1])
	if weight_ratio > 1.0:
		c.append(["overweight", "Sobrecarregado", 1])
	return c


func to_dict() -> Dictionary:
	return {"health": health, "hunger": hunger, "thirst": thirst, "energy": energy, "stamina": stamina, "body_temp": body_temp,
		"bleeding": bleeding, "fracture": fracture, "splinted": splinted, "pain": pain, "wound_infection": wound_infection,
		"food_poisoning": food_poisoning, "cold": cold, "infection": infection, "infection_incubation": infection_incubation,
		"inhibitor_hours": inhibitor_hours, "immunity": immunity, "wetness": wetness, "morale": morale}


func from_dict(d: Dictionary) -> void:
	for k in d.keys():
		if k in self:
			set(k, d[k])
	dead = false
