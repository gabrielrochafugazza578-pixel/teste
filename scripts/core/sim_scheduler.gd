extends Node
## SimScheduler — níveis de simulação (LOD de IA/física) e fatiamento de tempo.
##
## Cada agente (infectado, sobrevivente, animal, veículo) registra uma função
## `think(dt, tier)`. O agendador:
##   * calcula o nível (tier) pela distância ao foco (jogador ou câmera);
##   * chama `think` em intervalos que crescem com a distância;
##   * limita o tempo total gasto por frame (orçamento em microssegundos),
##     espalhando o trabalho entre frames — nada de dezenas de cálculos por
##     NPC por frame;
##   * em cinemáticas, rebaixa agentes fora do campo de visão da câmera.
##
## Tiers:
##   FULL     (perto)   — física completa, percepção a ~8 Hz, animação por frame
##   SIMPLE   (médio)   — movimento cinemático sem colisão, ~3 Hz
##   MINIMAL  (longe)   — posição atualizada ~1 Hz, sem animação
##   ABSTRACT (fora)    — o nó é devolvido ao pool; a população vira dado

enum Tier { FULL, SIMPLE, MINIMAL, ABSTRACT }

class Agent:
	extends RefCounted
	var node: Node3D
	var think: Callable
	var on_tier: Callable
	var tier: int = 0
	var next_time: float = 0.0
	var last_time: float = 0.0
	var alive: bool = true
	var always_full: bool = false


var agents: Array = []
var focus_position: Vector3 = Vector3.ZERO
var focus_node: Node3D = null
var camera: Camera3D = null
var cinematic_mode: bool = false
var paused_sim: bool = false

## Distâncias de corte dos tiers (m). Ajustadas pela densidade nas configurações.
var tier_distances := PackedFloat32Array([42.0, 90.0, 150.0])
## Intervalo entre "pensamentos" por tier (s).
var tier_intervals := PackedFloat32Array([0.12, 0.33, 1.1, 3.5])

var _retier_cursor: int = 0
var _think_cursor: int = 0
var _dirty: bool = false
var _now: float = 0.0

# Estatísticas para o painel de desempenho (F3).
var stat_think_calls: int = 0
var stat_think_usec: int = 0
var stat_tier_counts := PackedInt32Array([0, 0, 0, 0])


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	process_priority = -10


func register(node: Node3D, think: Callable, on_tier: Callable = Callable(), always_full: bool = false) -> Agent:
	var a := Agent.new()
	a.node = node
	a.think = think
	a.on_tier = on_tier
	a.always_full = always_full
	a.tier = _compute_tier(node.global_position if node.is_inside_tree() else Vector3.ZERO, true) if not always_full else Tier.FULL
	a.last_time = _now
	a.next_time = _now + randf() * tier_intervals[a.tier]
	agents.append(a)
	if a.on_tier.is_valid():
		a.on_tier.call(a.tier)
	return a


func unregister(a: Agent) -> void:
	if a == null:
		return
	a.alive = false
	_dirty = true


func set_focus(node: Node3D) -> void:
	focus_node = node


func tier_for_position(pos: Vector3) -> int:
	return _compute_tier(pos, true)


func distance_to_focus(pos: Vector3) -> float:
	return pos.distance_to(focus_position)


func _compute_tier(pos: Vector3, check_view: bool) -> int:
	var d2 := pos.distance_squared_to(focus_position)
	var tier := Tier.ABSTRACT
	if d2 < tier_distances[0] * tier_distances[0]:
		tier = Tier.FULL
	elif d2 < tier_distances[1] * tier_distances[1]:
		tier = Tier.SIMPLE
	elif d2 < tier_distances[2] * tier_distances[2]:
		tier = Tier.MINIMAL
	# Em cinemáticas, o que está fora do quadro recebe simulação reduzida.
	if check_view and cinematic_mode and camera != null and is_instance_valid(camera) and tier < Tier.MINIMAL:
		if not camera.is_position_in_frustum(pos):
			tier = mini(tier + 1, Tier.MINIMAL)
	return tier


func _process(delta: float) -> void:
	_now += delta
	if focus_node != null and is_instance_valid(focus_node) and focus_node.is_inside_tree():
		focus_position = focus_node.global_position
	elif camera != null and is_instance_valid(camera) and camera.is_inside_tree():
		focus_position = camera.global_position
	if _dirty:
		_compact()
	if paused_sim:
		return
	var n := agents.size()
	if n == 0:
		return
	# 1) Recalcula tiers de uma fatia dos agentes por frame.
	var slice := mini(n, 20)
	for i in slice:
		_retier_cursor = (_retier_cursor + 1) % n
		var a: Agent = agents[_retier_cursor]
		if not a.alive or not is_instance_valid(a.node):
			a.alive = false
			_dirty = true
			continue
		if a.always_full:
			continue
		var t := _compute_tier(a.node.global_position, true)
		if t != a.tier:
			a.tier = t
			a.next_time = minf(a.next_time, _now + tier_intervals[t])
			if a.on_tier.is_valid():
				a.on_tier.call(t)
	# 2) Distribui os "pensamentos" dentro do orçamento de CPU.
	var budget := Settings.get_ai_budget_usec()
	var start := Time.get_ticks_usec()
	stat_think_calls = 0
	var counts := PackedInt32Array([0, 0, 0, 0])
	for k in n:
		var idx := (_think_cursor + k) % n
		var a: Agent = agents[idx]
		if not a.alive:
			continue
		counts[a.tier] += 1
		if _now < a.next_time:
			continue
		if not is_instance_valid(a.node):
			a.alive = false
			_dirty = true
			continue
		var dt := _now - a.last_time
		a.last_time = _now
		a.next_time = _now + tier_intervals[a.tier] * randf_range(0.85, 1.15)
		a.think.call(dt, a.tier)
		stat_think_calls += 1
		if Time.get_ticks_usec() - start > budget:
			_think_cursor = (idx + 1) % n
			break
	stat_tier_counts = counts
	stat_think_usec = Time.get_ticks_usec() - start


func _compact() -> void:
	var keep: Array = []
	for a in agents:
		if a.alive and is_instance_valid(a.node):
			keep.append(a)
	agents = keep
	_dirty = false
	_retier_cursor = 0
	_think_cursor = 0


func clear_all() -> void:
	agents.clear()
	_dirty = false


func now() -> float:
	return _now
