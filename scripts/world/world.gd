class_name World
extends Node3D
## Mundo infinito: carrega chunks ao redor do jogador em threads, descarrega os
## distantes, guarda as modificacoes (cavar/construir) e desenha a agua.

signal chunk_ready(key: Vector2i)

const N := WorldGen.N
const P := WorldGen.P
const H := WorldGen.H

@export var view_radius := 8
@export var collision_radius := 2

var world_seed: int
var gen: WorldGen
var terrain_material: ShaderMaterial
var water: MeshInstance3D

var chunks: Dictionary = {}      # Vector2i -> Chunk
var tasks: Dictionary = {}       # Vector2i -> id da tarefa de geracao
var remesh_tasks: Dictionary = {} # id da tarefa -> Vector2i
var results: Array = []
var mutex := Mutex.new()
var edits: Dictionary = {}       # Vector2i -> { indice_local: Vector2(densidade, material) }
var removed_decos: Dictionary = {} # Vector2i -> { indice_da_decoracao: true }

var focus: Node3D
var center := Vector2i(1 << 30, 1 << 30)
var queue: Array[Vector2i] = []
var max_tasks := 3
var finalize_budget := 3
var collision_budget := 2
var fast_mode := false           # usado pela ferramenta de fotos


func _ready() -> void:
	world_seed = Game.world_seed
	gen = WorldGen.new(world_seed)
	terrain_material = ShaderMaterial.new()
	terrain_material.shader = load("res://shaders/terrain.gdshader")
	max_tasks = maxi(1, OS.get_processor_count() - 1)
	_make_water()


func _exit_tree() -> void:
	for id in tasks.values():
		WorkerThreadPool.wait_for_task_completion(id)
	for id in remesh_tasks.keys():
		WorkerThreadPool.wait_for_task_completion(id)
	tasks.clear()
	remesh_tasks.clear()


func _make_water() -> void:
	water = MeshInstance3D.new()
	var pm := PlaneMesh.new()
	var size := float((view_radius * 2 + 3) * N)
	pm.size = Vector2(size, size)
	pm.subdivide_width = 48
	pm.subdivide_depth = 48
	water.mesh = pm
	var mat := ShaderMaterial.new()
	mat.shader = load("res://shaders/water.gdshader")
	water.material_override = mat
	water.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	water.position.y = WorldGen.SEA - 0.35
	add_child(water)


func _process(_delta: float) -> void:
	if focus == null:
		return
	var p := focus.global_position
	water.position.x = snappedf(p.x, 8.0)
	water.position.z = snappedf(p.z, 8.0)
	var c := Vector2i(floori(p.x / N), floori(p.z / N))
	if c != center:
		center = c
		_refresh_needed()
	_launch_tasks()
	_collect_results()
	_update_collisions()


func _dist2(k: Vector2i) -> int:
	var d := k - center
	return d.x * d.x + d.y * d.y


func _refresh_needed() -> void:
	var unload_r2 := (view_radius + 2) * (view_radius + 2)
	for k in chunks.keys():
		if _dist2(k) > unload_r2:
			chunks[k].queue_free()
			chunks.erase(k)
	queue.clear()
	var r2 := view_radius * view_radius
	for dz in range(-view_radius, view_radius + 1):
		for dx in range(-view_radius, view_radius + 1):
			if dx * dx + dz * dz > r2:
				continue
			var k := center + Vector2i(dx, dz)
			if not chunks.has(k) and not tasks.has(k):
				queue.append(k)
	# mais proximos no fim (pop_back)
	queue.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: return _dist2(a) > _dist2(b))


func _launch_tasks() -> void:
	while queue.size() > 0 and tasks.size() + remesh_tasks.size() < max_tasks:
		var k: Vector2i = queue.pop_back()
		if chunks.has(k) or tasks.has(k):
			continue
		var ed: Dictionary = edits.get(k, {}).duplicate()
		var id := WorkerThreadPool.add_task(_task_generate.bind(k, ed, world_seed), false, "chunk")
		tasks[k] = id


## Roda numa thread: gera densidade, aplica edicoes e cria a malha.
func _task_generate(k: Vector2i, ed: Dictionary, s: int) -> void:
	var g := WorldGen.new(s)
	var data := g.generate_chunk(k.x, k.y)
	var dens: PackedFloat32Array = data["dens"]
	var mats: PackedByteArray = data["mats"]
	var ymin: int = data["ymin"]
	var ymax: int = data["ymax"]
	for li in ed:
		var e: Vector2 = ed[li]
		dens[li] = e.x
		mats[li] = int(e.y)
		var y: int = li % H
		ymin = mini(ymin, y - 2)
		ymax = maxi(ymax, y + 1)
	ymin = clampi(ymin, 0, H - 3)
	ymax = clampi(ymax, ymin, H - 3)
	var md := ChunkMesher.build(dens, mats, ymin, ymax, k.x, k.y)
	var mesh := ChunkMesher.make_mesh(md, terrain_material)
	var decos := g.decorations(k.x, k.y)
	mutex.lock()
	results.append({"kind": "gen", "key": k, "dens": dens, "mats": mats, "ymin": ymin, "ymax": ymax, "md": md, "mesh": mesh, "edit_count": ed.size(), "decos": decos})
	mutex.unlock()


func _task_remesh(k: Vector2i, dens: PackedFloat32Array, mats: PackedByteArray, ymin: int, ymax: int, ver: int) -> void:
	var md := ChunkMesher.build(dens, mats, ymin, ymax, k.x, k.y)
	var mesh := ChunkMesher.make_mesh(md, terrain_material)
	mutex.lock()
	results.append({"kind": "remesh", "key": k, "md": md, "mesh": mesh, "version": ver})
	mutex.unlock()


func _collect_results() -> void:
	# libera tarefas concluidas
	for k in tasks.keys():
		if WorkerThreadPool.is_task_completed(tasks[k]):
			WorkerThreadPool.wait_for_task_completion(tasks[k])
			tasks.erase(k)
	for id in remesh_tasks.keys():
		if WorkerThreadPool.is_task_completed(id):
			WorkerThreadPool.wait_for_task_completion(id)
			remesh_tasks.erase(id)

	mutex.lock()
	var batch := results
	var budget := 1000 if fast_mode else finalize_budget
	if batch.size() > budget:
		results = batch.slice(budget)
		batch = batch.slice(0, budget)
	else:
		results = []
	mutex.unlock()

	for r in batch:
		var k: Vector2i = r["key"]
		if r["kind"] == "gen":
			if chunks.has(k) or _dist2(k) > (view_radius + 2) * (view_radius + 2):
				continue
			var ch := Chunk.new()
			ch.setup(k)
			ch.dens = r["dens"]
			ch.mats = r["mats"]
			ch.ymin = r["ymin"]
			ch.ymax = r["ymax"]
			add_child(ch)
			chunks[k] = ch
			ch.apply_mesh(r["mesh"], r["md"])
			if not removed_decos.has(k):
				removed_decos[k] = {}
			ch.set_decorations(r["decos"], removed_decos[k])
			# edicoes feitas enquanto a tarefa rodava
			if edits.has(k) and edits[k].size() != r["edit_count"]:
				for li in edits[k]:
					var e: Vector2 = edits[k][li]
					ch.dens[li] = e.x
					ch.mats[li] = int(e.y)
					var y: int = li % H
					ch.ymin = clampi(mini(ch.ymin, y - 2), 0, H - 3)
					ch.ymax = clampi(maxi(ch.ymax, y + 1), ch.ymin, H - 3)
				ch.version += 1
				ch.remesh_pending = true
			chunk_ready.emit(k)
		else:
			var ch: Chunk = chunks.get(k)
			if ch == null:
				continue
			if r["version"] == ch.version:
				ch.remesh_pending = false
				ch.apply_mesh(r["mesh"], r["md"])

	# remesh de chunks modificados
	for k in chunks:
		var ch: Chunk = chunks[k]
		if ch.remesh_pending and not remesh_tasks.values().has(k):
			var id := WorkerThreadPool.add_task(_task_remesh.bind(k, ch.dens.duplicate(), ch.mats.duplicate(), ch.ymin, ch.ymax, ch.version), true, "remesh")
			remesh_tasks[id] = k


func _update_collisions() -> void:
	var r2 := collision_radius * collision_radius
	var budget := 1000 if fast_mode else collision_budget
	# prioriza os chunks mais proximos
	var keys := chunks.keys()
	keys.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: return _dist2(a) < _dist2(b))
	for k in keys:
		var ch: Chunk = chunks[k]
		var want := _dist2(k) <= r2
		if want and (not ch.collision_enabled or ch.collision_dirty):
			if budget <= 0:
				continue
			if ch.update_collision(true):
				budget -= 1
			ch.update_deco_collision(true)
		elif not want and ch.collision_enabled:
			ch.update_collision(false)
			ch.update_deco_collision(false)


## Numero de chunks ainda sendo gerados dentro do raio de visao.
func pending_count() -> int:
	var n := queue.size() + tasks.size() + results.size() + remesh_tasks.size()
	for k in chunks:
		if chunks[k].remesh_pending:
			n += 1
	return n


## Existe chao com colisao pronto nesta posicao?
func is_ready_at(pos: Vector3) -> bool:
	var k := Vector2i(floori(pos.x / N), floori(pos.z / N))
	var ch: Chunk = chunks.get(k)
	return ch != null and ch.collision_enabled and not ch.collision_dirty


func height_at(x: float, z: float) -> float:
	return gen.height_at(x, z)


func biome_at(x: float, z: float) -> int:
	return gen.biome_at(x, z, gen.height_at(x, z))


## Densidade atual (com edicoes) no ponto de grade global. NAN se nao carregado.
func density_at_grid(gx: int, gy: int, gz: int) -> float:
	if gy < 0 or gy >= H:
		return -WorldGen.DMAX
	var k := Vector2i(floori(float(gx) / N), floori(float(gz) / N))
	var ch: Chunk = chunks.get(k)
	if ch == null:
		return NAN
	var lx := gx - k.x * N
	var lz := gz - k.y * N
	return ch.dens[(lz * P + lx) * H + gy]


const SMALL_DECOS := [Deco.FLOWER, Deco.GRASS, Deco.MUSHROOM_GLOW, Deco.DEAD_BUSH, Deco.BUSH]


## Quebra uma decoracao (arvore, pedra...) e da os materiais ao jogador.
func break_deco(ch: Chunk, i: int, who: Player) -> void:
	var t := ch.deco_type(i)
	var pos := ch.deco_position(i)
	ch.remove_deco(i)
	match t:
		Deco.TREE_ROUND, Deco.TREE_PINE, Deco.TREE_PALM:
			Effects.poof(self, pos + Vector3(0, 3.2, 0), Color(0.35, 0.7, 0.28), 26, 4.5, 0.16)
		Deco.TREE_AUTUMN:
			Effects.poof(self, pos + Vector3(0, 3.2, 0), Color(0.95, 0.55, 0.2), 26, 4.5, 0.16)
		Deco.TREE_PINE_SNOW:
			Effects.poof(self, pos + Vector3(0, 3.2, 0), Color(0.95, 0.97, 1.0), 26, 4.5, 0.16)
		Deco.MUSHROOM_GIANT:
			Effects.poof(self, pos + Vector3(0, 3.0, 0), Color(0.9, 0.3, 0.45), 26, 4.5, 0.16)
		Deco.CRYSTAL:
			Effects.poof(self, pos + Vector3(0, 0.6, 0), Color(0.7, 0.5, 1.0), 20, 3.5, 0.1, 3.0)
		_:
			Effects.poof(self, pos + Vector3(0, 0.6, 0), Color(0.6, 0.6, 0.65), 16, 3.0)
	if who and Deco.DROPS.has(t):
		var drop: Array = Deco.DROPS[t]
		who.inventory.add(drop[0], drop[1])
		if who.hud:
			who.hud.show_message("+%d %s" % [drop[1], Mats.NAMES[drop[0]]], 1.5)


## Tira plantinhas (flores, grama...) de perto de onde o terreno mudou.
## Com `all = true` remove tambem arvores e pedras.
func remove_small_decos(pos: Vector3, r: float, all := false) -> void:
	var k := Vector2i(floori(pos.x / N), floori(pos.z / N))
	for dz in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			var ch: Chunk = chunks.get(k + Vector2i(dx, dz))
			if ch == null:
				continue
			var changed := false
			for i in ch.deco_count():
				if ch.deco_removed.has(i) or (not all and not SMALL_DECOS.has(ch.deco_type(i))):
					continue
				var dp := ch.deco_position(i)
				if Vector2(dp.x - pos.x, dp.z - pos.z).length() < r:
					ch.deco_removed[i] = true
					changed = true
			if changed:
				ch._rebuild_deco_meshes()
				if ch.deco_body:
					ch.update_deco_collision(false)
					ch.update_deco_collision(true)


## Cava (add=false) ou constroi (add=true) uma esfera suave.
## Retorna o material mais comum removido (ou -1).
func edit_sphere(center_pos: Vector3, radius: float, add: bool, mat: int) -> int:
	var gmin := Vector3i((center_pos - Vector3.ONE * (radius + 1.0)).floor())
	var gmax := Vector3i((center_pos + Vector3.ONE * (radius + 1.0)).ceil())
	gmin.y = maxi(gmin.y, 1)
	gmax.y = mini(gmax.y, H - 4)
	var removed := {}
	var touched := {}
	for gz in range(gmin.z, gmax.z + 1):
		for gx in range(gmin.x, gmax.x + 1):
			# chunks que contem este ponto (bordas compartilhadas)
			var owners: Array = []
			var kx0 := floori(float(gx) / N)
			var kz0 := floori(float(gz) / N)
			for kz in [kz0 - 1, kz0]:
				for kx in [kx0 - 1, kx0]:
					var lx: int = gx - kx * N
					var lz: int = gz - kz * N
					if lx >= 0 and lx < P and lz >= 0 and lz < P:
						owners.append([Vector2i(kx, kz), (lz * P + lx) * H])
			var primary: Chunk = null
			var primary_base := 0
			for o in owners:
				if chunks.has(o[0]):
					primary = chunks[o[0]]
					primary_base = o[1]
					break
			if primary == null:
				continue
			for gy in range(gmin.y, gmax.y + 1):
				var dist := Vector3(gx, gy, gz).distance_to(center_pos)
				var sdf := dist - radius
				var old := primary.dens[primary_base + gy]
				var old_mat := int(primary.mats[primary_base + gy])
				var nd := old
				var nm := old_mat
				if add:
					nd = maxf(old, -sdf)
					if nd > old and (old <= 0.0 or sdf < -0.5):
						nm = mat
				else:
					nd = minf(old, sdf)
					if old > 0.0 and nd <= 0.0:
						removed[old_mat] = removed.get(old_mat, 0) + 1
				nd = clampf(nd, -WorldGen.DMAX, WorldGen.DMAX)
				if nd == old and nm == old_mat:
					continue
				for o in owners:
					var k: Vector2i = o[0]
					var li: int = o[1] + gy
					if not edits.has(k):
						edits[k] = {}
					edits[k][li] = Vector2(nd, nm)
					var ch: Chunk = chunks.get(k)
					if ch:
						ch.dens[li] = nd
						ch.mats[li] = nm
						ch.ymin = clampi(mini(ch.ymin, gy - 2), 0, H - 3)
						ch.ymax = clampi(maxi(ch.ymax, gy + 1), ch.ymin, H - 3)
						touched[k] = true
	for k in touched:
		var ch: Chunk = chunks[k]
		ch.version += 1
		ch.remesh_pending = true
	var best := -1
	var best_n := 0
	for m in removed:
		if removed[m] > best_n:
			best_n = removed[m]
			best = m
	return best
