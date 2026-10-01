extends Node
## Piloto automatico para testar o jogo de verdade (fisica, bichos, combate,
## cavar/construir, dia e noite). Uso:  godot -- --autotest=90
## Ao final imprime um resumo e fecha o jogo.

var main: Node
var player: Player
var world: World
var mobs: MobManager
var day_night: DayNight
var duration := 90.0
var t := 0.0
var _next_turn := 2.0
var _next_action := 1.0
var _spawned_test := false
var _hits := 0
var _digs := 0
var _places := 0
var _max_mobs := 0
var _species_seen := {}
var _frames := 0
var _fps_sum := 0.0
var _was_night := false
var _nights := 0
var _damage_taken := 0
var _last_hp := 20
var _mob_deaths := 0


func _ready() -> void:
	player.autopilot = true
	player.health_changed.connect(func(hp, _mx):
		if hp < _last_hp:
			_damage_taken += _last_hp - hp
		_last_hp = hp)
	mobs.child_exiting_tree.connect(func(n): if n is Mob and n.hp <= 0: _mob_deaths += 1)
	day_night.day_length = 50.0
	day_night.time_of_day = 0.68
	print("AUTOTESTE: iniciando por ", duration, "s")


func _process(delta: float) -> void:
	t += delta
	_frames += 1
	_fps_sum += Engine.get_frames_per_second()
	for m in mobs.mobs:
		if is_instance_valid(m):
			_species_seen[m.species] = true
	_max_mobs = maxi(_max_mobs, mobs.mobs.size())
	if day_night.is_night and not _was_night:
		_nights += 1
	_was_night = day_night.is_night

	if player.frozen:
		return
	# anda para frente sempre, pula de vez em quando
	Input.action_press("move_forward")
	if randf() < 0.01:
		Input.action_press("jump")
	else:
		Input.action_release("jump")

	# forca a aparicao de cada criatura da noite perto do jogador uma vez
	if not _spawned_test and t > 8.0:
		_spawned_test = true
		var i := 0
		for kind in ["lobo", "gosma", "espirito", "golem"]:
			var a := i * TAU / 4.0
			var p := player.global_position + Vector3(cos(a) * 6.0, 0, sin(a) * 6.0)
			p.y = world.height_at(p.x, p.z) + 1.0
			mobs.spawn(NightCreature.create(kind), p)
			i += 1
		for kind in Animal.SPECIES:
			var p := player.global_position + Vector3(randf_range(-8, 8), 0, randf_range(-8, 8))
			p.y = world.height_at(p.x, p.z) + 1.0
			mobs.spawn(Animal.create(kind), p)

	# mira no bicho mais proximo (se houver) ou gira de vez em quando
	var target: Mob = null
	var best := 7.0
	for m in mobs.mobs:
		if is_instance_valid(m) and not m.fading_out:
			var d: float = m.global_position.distance_to(player.global_position)
			if d < best:
				best = d
				target = m
	if target:
		var to := target.global_position + Vector3(0, 0.5, 0) - (player.global_position + Vector3(0, Player.EYE_HEIGHT, 0))
		player.set_look(rad_to_deg(atan2(-to.x, -to.z)), rad_to_deg(atan2(to.y, Vector2(to.x, to.z).length())))
	elif t > _next_turn:
		_next_turn = t + randf_range(2.0, 5.0)
		player.set_look(randf() * 360.0, -20.0)

	# acoes
	if t > _next_action:
		_next_action = t + 0.35
		var hit := player._raycast()
		if target and not hit.is_empty() and hit.collider == target:
			player._do_attack(hit)
			_hits += 1
		elif not hit.is_empty() and randf() < 0.5:
			player._do_attack(hit)
			_digs += 1
		elif not hit.is_empty():
			player._do_place(hit)
			_places += 1

	if t > duration:
		_finish()


func _finish() -> void:
	set_process(false)
	var species := _species_seen.keys()
	species.sort()
	print("AUTOTESTE RESULTADO:")
	print("  tempo=", snappedf(t, 0.1), "s  fps_medio=", snappedf(_fps_sum / maxf(_frames, 1), 0.1))
	print("  chunks=", world.chunks.size(), "  edicoes=", world.edits.size(), " chunks editados")
	print("  golpes_em_bichos=", _hits, "  cavadas=", _digs, "  construcoes=", _places)
	print("  max_bichos=", _max_mobs, "  especies_vistas=", species)
	print("  noites=", _nights, "  dia=", day_night.day_count, "  hora=", day_night.clock_string())
	print("  dano_recebido=", _damage_taken, "  bichos_derrotados=", _mob_deaths)
	print("  vida_jogador=", player.hp, "/", player.max_hp, "  pos=", player.global_position.round())
	var inv := []
	for m in Inventory.HOTBAR:
		inv.append("%s:%d" % [Mats.NAMES[m], player.inventory.counts.get(m, 0)])
	print("  inventario=", ", ".join(inv))
	get_tree().quit()
