class_name MobManager
extends Node3D
## Faz os bichos aparecerem perto do jogador: animais fofos de dia e criaturas
## brilhantes (e perigosas) a noite. Quando amanhece, as da noite viram poeira.

const MAX_ANIMALS := 10
const MAX_NIGHT := 9
const DESPAWN_DIST := 85.0

var world: World
var player: Player
var day_night: DayNight
var mobs: Array = []
var enabled := true
var _timer := 0.5


func _process(delta: float) -> void:
	if not enabled or player == null:
		return
	_timer -= delta
	if _timer > 0.0:
		return
	_timer = 1.0
	# limpeza
	var alive: Array = []
	for m in mobs:
		if is_instance_valid(m) and not m.is_queued_for_deletion():
			if m.global_position.distance_to(player.global_position) > DESPAWN_DIST:
				m.queue_free()
			else:
				alive.append(m)
	mobs = alive

	var animals := 0
	var night_mobs := 0
	for m in mobs:
		if m.nocturnal:
			night_mobs += 1
		else:
			animals += 1

	if day_night.is_night:
		if night_mobs < MAX_NIGHT:
			spawn_night_group()
	else:
		for m in mobs:
			if m.nocturnal:
				m.dissolve()
		if animals < MAX_ANIMALS:
			spawn_animal_group()


## Ponto aleatorio de chao firme entre min_d e max_d do jogador.
func random_ground(min_d: float, max_d: float, allow_water := false) -> Vector3:
	for i in 10:
		var a := randf() * TAU
		var d := randf_range(min_d, max_d)
		var x := player.global_position.x + cos(a) * d
		var z := player.global_position.z + sin(a) * d
		var h := world.height_at(x, z)
		if not allow_water and h < WorldGen.SEA + 0.4:
			continue
		var p := Vector3(x, maxf(h, WorldGen.SEA) + 0.6, z)
		if world.is_ready_at(p):
			return p
	return Vector3.INF


func spawn(m: Mob, pos: Vector3) -> Mob:
	m.world = world
	m.player = player
	add_child(m)
	m.global_position = pos
	mobs.append(m)
	return m


func spawn_animal_group() -> void:
	var base := random_ground(14.0, 30.0)
	if base == Vector3.INF:
		return
	var kinds: Array
	match world.biome_at(base.x, base.z):
		WorldGen.Biome.PLAINS:
			kinds = ["porco", "vaca", "ovelha", "galinha"]
		WorldGen.Biome.FOREST:
			kinds = ["coelho", "ovelha", "galinha", "porco"]
		WorldGen.Biome.SNOWY, WorldGen.Biome.MAGIC, WorldGen.Biome.DESERT:
			kinds = ["coelho"]
		WorldGen.Biome.BEACH:
			kinds = ["galinha", "coelho"]
		WorldGen.Biome.MOUNTAIN:
			kinds = ["ovelha"]
		_:
			return
	var kind: String = kinds[randi() % kinds.size()]
	for i in randi_range(2, 3):
		var p := base + Vector3(randf_range(-2.5, 2.5), 0, randf_range(-2.5, 2.5))
		p.y = maxf(world.height_at(p.x, p.z), WorldGen.SEA) + 0.6
		spawn(Animal.create(kind), p)


func spawn_night_group() -> void:
	var r := randf()
	if r < 0.35:
		# matilha de lobos sombrios
		var base := random_ground(20.0, 32.0)
		if base == Vector3.INF:
			return
		for i in randi_range(2, 3):
			var p := base + Vector3(randf_range(-2, 2), 0, randf_range(-2, 2))
			p.y = world.height_at(p.x, p.z) + 0.6
			_rise(spawn(NightCreature.create("lobo"), p))
	elif r < 0.62:
		var p := random_ground(14.0, 28.0)
		if p != Vector3.INF:
			_rise(spawn(NightCreature.create("gosma"), p))
	elif r < 0.9:
		var p := random_ground(16.0, 28.0, true)
		if p != Vector3.INF:
			_rise(spawn(NightCreature.create("espirito"), p + Vector3(0, 3, 0)))
	else:
		# golem de cristal (raro, so um por vez)
		for m in mobs:
			if m.species == "golem":
				return
		var p := random_ground(22.0, 32.0)
		if p != Vector3.INF:
			_rise(spawn(NightCreature.create("golem"), p))


## Efeito de surgir do chao.
func _rise(m: Mob) -> void:
	Effects.poof(self, m.global_position + Vector3(0, 0.3, 0), Color(0.55, 0.35, 1.0), 20, 3.0, 0.1, 3.0)


## Remove todos (ex.: ao renascer).
func clear_all() -> void:
	for m in mobs:
		if is_instance_valid(m):
			m.queue_free()
	mobs.clear()
