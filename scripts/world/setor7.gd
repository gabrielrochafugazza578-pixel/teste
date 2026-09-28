class_name Setor7
extends Node3D
## Setor 7 — instalação subterrânea sob o laboratório de P&D da Corvalis.
## Local isolado (60 m abaixo da superfície) gerado proceduralmente:
## saguão do elevador, corredor, segurança, laboratório, isolamento (Lia),
## contenção e núcleo de dados (Helena, Leme). Geometria mesclada numa
## malha só + colisão direta no PhysicsServer (mesmo padrão dos chunks).

const DEPTH := 60.0
const H := 3.6

var game: Node = null
var markers: Dictionary = {}
var _body: RID = RID()
var _shapes: Array = []
var _mesh := MeshBuf.new()
var _props := MeshBuf.new()
var _alarm_lights: Array = []
var _t: float = 0.0
var leme: SurvivorNPC = null
var built: bool = false

# Salas (retângulos XZ locais; frente = -Z)
const ROOMS := {
	"lobby": Rect2(-4.0, -8.0, 8.0, 8.0),
	"corridor": Rect2(-2.0, -42.0, 4.0, 34.0),
	"security": Rect2(-13.0, -21.0, 11.0, 9.0),
	"lab": Rect2(2.0, -31.0, 15.0, 17.0),
	"isolation": Rect2(-17.0, -39.0, 15.0, 13.0),
	"core": Rect2(-9.0, -60.0, 18.0, 18.0),
}
## Portas: [sala, lado, posição ao longo da parede, largura]
## lados: "n" (-Z), "s" (+Z), "w" (-X), "e" (+X)
const DOORS := [
	["lobby", "n", 4.0, 2.2], ["corridor", "s", 2.0, 2.2],
	["security", "e", 4.5, 1.2], ["corridor", "w", 25.0, 1.2],
	["lab", "w", 9.0, 1.4], ["corridor", "e", 20.0, 1.4],
	["isolation", "e", 6.5, 1.2], ["corridor", "w", 9.5, 1.2],
	["core", "s", 9.0, 2.2], ["corridor", "n", 2.0, 2.2],
]


static func origin_for(lab_pos: Vector3) -> Vector3:
	return Vector3(lab_pos.x, -DEPTH, lab_pos.z)


func build(g: Node) -> void:
	game = g
	var tiles := Assets.uv2_code(Assets.L_TILES)
	var panels := Assets.uv2_code(Assets.L_PANELS)
	var conc := Assets.uv2_code(Assets.L_CONCRETE)
	var lino := Assets.uv2_code(Assets.L_LINOLEUM)
	var metal := Assets.uv2_code(Assets.L_METAL)
	for rn in ROOMS.keys():
		var r: Rect2 = ROOMS[rn]
		var wall_code := panels if rn in ["lab", "core", "isolation"] else conc
		var floor_code := lino if rn in ["lab", "isolation"] else tiles
		var tint := Color(0.78, 0.82, 0.84) if rn != "core" else Color(0.5, 0.54, 0.58)
		# piso e teto
		_mesh.quad(Vector3(r.position.x, 0, r.position.y), Vector3(r.end.x, 0, r.position.y), Vector3(r.end.x, 0, r.end.y), Vector3(r.position.x, 0, r.end.y),
			Vector3.UP, Vector2(r.position.x, r.position.y), Vector2(r.end.x, r.position.y), Vector2(r.end.x, r.end.y), Vector2(r.position.x, r.end.y), floor_code, 0.3, Color(0.85, 0.85, 0.85))
		_mesh.quad(Vector3(r.position.x, H, r.end.y), Vector3(r.end.x, H, r.end.y), Vector3(r.end.x, H, r.position.y), Vector3(r.position.x, H, r.position.y),
			Vector3.DOWN, Vector2(0, 0), Vector2(r.size.x, 0), Vector2(r.size.x, r.size.y), Vector2(0, r.size.y), panels, 0.6, Color(0.6, 0.62, 0.64))
		_collider(Vector3(r.get_center().x, -0.25, r.get_center().y), Vector3(r.size.x, 0.5, r.size.y))
		_collider(Vector3(r.get_center().x, H + 0.25, r.get_center().y), Vector3(r.size.x, 0.5, r.size.y))
		for side: String in ["n", "s", "w", "e"]:
			_room_wall(rn, r, side, wall_code, tint)
	_furnish(metal, panels)
	var m := _mesh.to_mesh(Assets.world_material("interior"))
	var mi := MeshInstance3D.new()
	mi.mesh = m
	add_child(mi)
	var pm := _props.to_mesh(Assets.world_material("props_interior"))
	var pmi := MeshInstance3D.new()
	pmi.mesh = pm
	add_child(pmi)
	_lights()
	_interactables()
	built = true


func _room_wall(rn: String, r: Rect2, side: String, code: float, tint: Color) -> void:
	var a: Vector2
	var b: Vector2
	var inward: Vector3
	match side:
		"n":
			a = Vector2(r.end.x, r.position.y)
			b = Vector2(r.position.x, r.position.y)
			inward = Vector3.BACK
		"s":
			a = Vector2(r.position.x, r.end.y)
			b = Vector2(r.end.x, r.end.y)
			inward = Vector3.FORWARD
		"w":
			a = Vector2(r.position.x, r.position.y)
			b = Vector2(r.position.x, r.end.y)
			inward = Vector3.RIGHT
		_:
			a = Vector2(r.end.x, r.end.y)
			b = Vector2(r.end.x, r.position.y)
			inward = Vector3.LEFT
	var holes: Array = []
	for d in DOORS:
		if d[0] == rn and d[1] == side:
			var u := float(d[2])
			var w := float(d[3])
			holes.append([u - w * 0.5, u + w * 0.5, 0.0, 2.3])
	# o corredor se abre inteiro para o saguão e o núcleo (portas largas)
	_mesh.wall_with_holes(a, b, 0.0, H, inward, holes, code, 0.2, tint)
	# colisão por trechos sólidos
	var len := a.distance_to(b)
	var dir := (b - a) / maxf(len, 0.001)
	var solid: Array = []
	var u := 0.0
	var hs := holes.duplicate()
	hs.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	for hole in hs:
		if float(hole[0]) > u:
			solid.append([u, float(hole[0])])
		# lintel acima da porta
		var c0 := a + dir * float(hole[0])
		var c1 := a + dir * float(hole[1])
		var cm := (c0 + c1) * 0.5
		_collider(Vector3(cm.x, (2.3 + H) * 0.5, cm.y), Vector3(maxf(absf(c1.x - c0.x), 0.2), H - 2.3, maxf(absf(c1.y - c0.y), 0.2)))
		u = float(hole[1])
	if u < len:
		solid.append([u, len])
	for s in solid:
		var p0 := a + dir * float(s[0])
		var p1 := a + dir * float(s[1])
		var c := (p0 + p1) * 0.5
		var sz := Vector3(maxf(absf(p1.x - p0.x), 0.25), H, maxf(absf(p1.y - p0.y), 0.25))
		_collider(Vector3(c.x, H * 0.5, c.y), sz)


func _collider(center: Vector3, size: Vector3) -> void:
	if not _body.is_valid():
		_body = PhysicsServer3D.body_create()
		PhysicsServer3D.body_set_mode(_body, PhysicsServer3D.BODY_MODE_STATIC)
		PhysicsServer3D.body_set_collision_layer(_body, 1)
		PhysicsServer3D.body_set_collision_mask(_body, 0)
	var sh := PhysicsServer3D.box_shape_create()
	PhysicsServer3D.shape_set_data(sh, size * 0.5)
	PhysicsServer3D.body_add_shape(_body, sh, Transform3D(Basis.IDENTITY, center))
	_shapes.append(sh)


func _enter_tree() -> void:
	if _body.is_valid():
		PhysicsServer3D.body_set_space(_body, get_world_3d().space)


func _ready() -> void:
	if _body.is_valid():
		PhysicsServer3D.body_set_space(_body, get_world_3d().space)
		PhysicsServer3D.body_set_state(_body, PhysicsServer3D.BODY_STATE_TRANSFORM, global_transform)


func _exit_tree() -> void:
	release()


func release() -> void:
	for s in _shapes:
		PhysicsServer3D.free_rid(s)
	_shapes.clear()
	if _body.is_valid():
		PhysicsServer3D.free_rid(_body)
		_body = RID()


func _prop(pn: String, pos: Vector3, yaw: float, collide: bool = true) -> void:
	var xf := Transform3D(Basis(Vector3.UP, yaw), pos)
	_props.append(PropLib.buf(pn), xf)
	var cs := PropLib.collision_size(pn)
	if collide and cs != Vector3.ZERO:
		var sh := PhysicsServer3D.box_shape_create()
		PhysicsServer3D.shape_set_data(sh, cs * 0.5)
		if not _body.is_valid():
			_collider(Vector3(0, -10, 0), Vector3.ONE)
		PhysicsServer3D.body_add_shape(_body, sh, Transform3D(xf.basis, pos + Vector3(0, cs.y * 0.5, 0)))
		_shapes.append(sh)


func _furnish(metal: float, panels: float) -> void:
	# saguão: elevador (porta metálica no fundo, +Z)
	_mesh.box(Vector3(0, 1.3, -0.1), Vector3(2.4, 2.6, 0.2), metal, 0.1, Color(0.55, 0.58, 0.6))
	markers["arrival"] = Transform3D(Basis(), Vector3(0, 0, -1.8))
	markers["elevator"] = Transform3D(Basis(Vector3.UP, PI), Vector3(0, 0, -0.6))
	markers["entrance"] = Transform3D(Basis(), Vector3(2.8, 0, -6.5))
	_prop("desk", Vector3(2.8, 0, -6.8), 0.0)
	_prop("filing_cabinet", Vector3(-3.4, 0, -6.5), PI * 0.5)
	# segurança: armários, mesa com monitores
	var sr: Rect2 = ROOMS["security"]
	_prop("locker", Vector3(sr.position.x + 1.0, 0, sr.position.y + 0.4), 0.0)
	_prop("locker", Vector3(sr.position.x + 2.6, 0, sr.position.y + 0.4), 0.0)
	_prop("desk", Vector3(sr.get_center().x, 0, sr.end.y - 1.2), PI)
	_prop("computer", Vector3(sr.get_center().x - 0.3, 0.76, sr.end.y - 1.2), PI, false)
	_prop("computer", Vector3(sr.get_center().x + 0.4, 0.76, sr.end.y - 1.2), PI, false)
	markers["security"] = Transform3D(Basis(), Vector3(sr.get_center().x, 0, sr.get_center().y))
	# laboratório: bancadas, capelas, equipamento
	var lr: Rect2 = ROOMS["lab"]
	for i in 3:
		var z := lr.position.y + 3.5 + i * 4.5
		_prop("lab_bench", Vector3(lr.get_center().x + 1.0, 0, z), 0.0)
		_prop("lab_equipment", Vector3(lr.get_center().x + 0.4, 0.93, z), 0.0, false)
		_prop("computer", Vector3(lr.get_center().x + 1.8, 0.93, z), 0.0, false)
	_prop("fume_hood", Vector3(lr.end.x - 0.6, 0, lr.position.y + 3.0), -PI * 0.5)
	_prop("fume_hood", Vector3(lr.end.x - 0.6, 0, lr.position.y + 6.0), -PI * 0.5)
	_prop("server_rack", Vector3(lr.end.x - 0.6, 0, lr.end.y - 1.5), -PI * 0.5)
	markers["lab"] = Transform3D(Basis(), Vector3(lr.get_center().x - 3.0, 0.0, lr.get_center().y))
	# isolamento: 3 celas com vidro
	var ir: Rect2 = ROOMS["isolation"]
	for k in 3:
		var x0 := ir.position.x + 0.5 + k * 4.6
		_mesh.box(Vector3(x0 + 4.2, H * 0.5, ir.position.y + 3.0), Vector3(0.15, H, 6.0), panels, 0.1, Color(0.8, 0.82, 0.84))
		_collider(Vector3(x0 + 4.2, H * 0.5, ir.position.y + 3.0), Vector3(0.15, H, 6.0))
		_prop("hospital_bed", Vector3(x0 + 2.0, 0, ir.position.y + 1.4), 0.0)
		# vidro frontal da cela
		var g := MeshInstance3D.new()
		var q := QuadMesh.new()
		q.size = Vector2(3.4, 2.4)
		g.mesh = q
		g.material_override = Assets.glass_material(0.1, 0.35)
		g.position = Vector3(x0 + 2.2, 1.3, ir.position.y + 6.0)
		add_child(g)
		_collider(Vector3(x0 + 2.2, 1.3, ir.position.y + 6.0), Vector3(3.6, 2.6, 0.08))
		markers["cell_%d" % k] = Transform3D(Basis(), Vector3(x0 + 2.0, 0, ir.position.y + 3.2))
	# a cela 1 tem a porta aberta (Lia está lá dentro)
	markers["lia"] = markers["cell_1"]
	# núcleo: fileiras de servidores e console central
	var cr: Rect2 = ROOMS["core"]
	for row in 2:
		for i in 5:
			var x := cr.position.x + 2.0 + i * 3.4
			_prop("server_rack", Vector3(x, 0, cr.position.y + 2.0 + row * 3.0), 0.0)
	_prop("desk", Vector3(0, 0, cr.end.y - 6.0), PI)
	_prop("computer", Vector3(-0.35, 0.76, cr.end.y - 6.0), PI, false)
	_prop("computer", Vector3(0.35, 0.76, cr.end.y - 6.0), PI, false)
	_prop("generator", Vector3(cr.end.x - 1.5, 0, cr.end.y - 2.0), PI * 0.5)
	markers["core"] = Transform3D(Basis(), Vector3(0, 0, cr.end.y - 7.0))
	markers["helena"] = Transform3D(Basis(Vector3.UP, PI), Vector3(0.0, 0, cr.end.y - 5.2))
	markers["leme"] = Transform3D(Basis(), Vector3(3.0, 0, cr.end.y - 9.0))
	markers["guard_0"] = Transform3D(Basis(), Vector3(-5.0, 0, cr.end.y - 4.0))
	markers["guard_1"] = Transform3D(Basis(), Vector3(5.5, 0, cr.end.y - 3.0))
	markers["guard_2"] = Transform3D(Basis(), Vector3(sr.get_center().x, 0, sr.get_center().y + 1.0))
	markers["guard_3"] = Transform3D(Basis(), Vector3(lr.get_center().x, 0, lr.position.y + 2.0))
	markers["containment"] = Transform3D(Basis(), Vector3(lr.get_center().x + 3.0, 0, lr.end.y - 3.0))


func _lights() -> void:
	# poucas luzes: brancas fracas + vermelhas de emergência piscando
	var spots := [["lobby", Color(0.9, 0.95, 1.0), 0.8], ["corridor", Color(1.0, 0.15, 0.1), 1.2], ["lab", Color(0.85, 0.92, 1.0), 1.0],
		["isolation", Color(0.7, 0.85, 1.0), 0.7], ["core", Color(0.4, 0.6, 1.0), 1.1], ["security", Color(1.0, 0.2, 0.12), 0.9]]
	for s in spots:
		var r: Rect2 = ROOMS[s[0]]
		var l := OmniLight3D.new()
		l.position = Vector3(r.get_center().x, H - 0.4, r.get_center().y)
		l.omni_range = maxf(r.size.x, r.size.y) * 0.75
		l.light_color = s[1]
		l.light_energy = float(s[2])
		l.shadow_enabled = false
		add_child(l)
		if (s[1] as Color).g < 0.3:
			_alarm_lights.append(l)
	var r2: Rect2 = ROOMS["corridor"]
	var l2 := OmniLight3D.new()
	l2.position = Vector3(0, H - 0.4, r2.position.y + 6.0)
	l2.omni_range = 12.0
	l2.light_color = Color(1.0, 0.15, 0.1)
	l2.light_energy = 1.0
	add_child(l2)
	_alarm_lights.append(l2)


func _interactables() -> void:
	var ev := Elevator.new()
	add_child(ev)
	var exf: Transform3D = markers["elevator"]
	ev.setup(exf.origin, exf.basis.get_euler().y, "surface", "")
	# portas internas
	var i := 0
	for d in [["security", "e", 4.5, 1.2, false], ["lab", "w", 9.0, 1.4, false], ["isolation", "e", 6.5, 1.2, true]]:
		var r: Rect2 = ROOMS[d[0]]
		var pos := Vector3.ZERO
		var yaw := 0.0
		match str(d[1]):
			"e":
				pos = Vector3(r.end.x, 0, r.end.y - float(d[2]))
				yaw = PI * 0.5
			"w":
				pos = Vector3(r.position.x, 0, r.position.y + float(d[2]))
				yaw = PI * 0.5
		var door := Door.new()
		add_child(door)
		door.setup({"uid": "s7_d%d" % i, "pos": pos, "yaw": yaw, "width": float(d[3]), "height": 2.2, "kind": "hinged",
			"locked": bool(d[4]), "key": "cartao_nivel4" if bool(d[4]) else ""})
		i += 1
	# gravações da Helena
	for o in StoryManager.pending_objects("setor7"):
		var od: Dictionary = o
		var mk: String = od.get("marker", "entrance")
		var p: Vector3 = (markers.get(mk, markers["entrance"]) as Transform3D).origin
		var so := StoryObject.new()
		add_child(so)
		so.setup(str(od["id"]), str(od["kind"]), p + Vector3(0.3, 0.8, 0.0), 0.0, str(od.get("item", "")))
	# loot
	var k := 0
	for spot: String in ["security", "lab", "entrance"]:
		var lc := LootContainer.new()
		add_child(lc)
		var p: Vector3 = (markers[spot] as Transform3D).origin
		lc.setup({"uid": "s7_c%d" % k, "kind": "locker" if spot == "security" else "lab_cabinet", "context": "lab" if spot != "security" else "police",
			"pos": p + Vector3(1.2, 0.6, 1.0), "size": Vector3(0.8, 1.2, 0.5)})
		k += 1
	# bancada para fabricar/reparar antes do confronto
	var wb := Station.new()
	add_child(wb)
	wb.setup("workbench", (markers["security"] as Transform3D).origin + Vector3(-2.5, 0, -2.5), 0.0, "s7_wb")


## Popula NPCs (Lia, Helena, Leme, seguranças).
func populate(sm: SurvivorManager) -> void:
	var lia := sm.spawn_named_at("lia", to_global((markers["lia"] as Transform3D).origin), 0.0)
	if GameState.has_flag("lia_found"):
		sm.set_following("lia", true)
	else:
		lia.set_state(SurvivorNPC.S.SCRIPTED)
		lia.body.play("sit", 1.0)
	var hx: Transform3D = markers["helena"]
	var hel := sm.spawn_named_at("helena", to_global(hx.origin), PI)
	hel.set_state(SurvivorNPC.S.SCRIPTED)
	hel.body.play("typing", 1.0)
	if not GameState.has_flag("leme_dead"):
		var d := {"id": "leme", "name": "Diretor Augusto Leme", "faction": "corvalis", "role": "leader", "weapon": "revolver",
			"pos": to_global((markers["leme"] as Transform3D).origin), "named": false, "hp": 260.0,
			"appearance": _leme_appearance(), "routine": [[0, "guard", "home"]]}
		leme = SurvivorNPC.new()
		leme.name = "NPC_leme"
		sm.add_child(leme)
		leme.setup(d, sm, sm.world)
		leme.max_hp = 260.0
		leme.hp = 260.0
		sm.spawned["leme"] = leme
		for gi in 4:
			var gd := {"id": "s7_guard_%d" % gi, "name": "Segurança Corvalis", "faction": "corvalis", "role": "guard",
				"weapon": "revolver" if gi % 2 == 0 else "cassetete", "pos": to_global((markers["guard_%d" % gi] as Transform3D).origin),
				"appearance": _guard_appearance(gi), "routine": [[0, "guard", "home"]]}
			if GameState.has_flag("s7_guard_%d_dead" % gi):
				continue
			var gn := SurvivorNPC.new()
			sm.add_child(gn)
			gn.setup(gd, sm, sm.world)
			sm.spawned[gd["id"]] = gn


## Espécime de contenção (Colosso adormecido no laboratório).
func populate_specimen(director: Node) -> void:
	if director and not GameState.has_flag("s7_specimen_dead"):
		var inf: Infected = director.spawn_scripted("colosso", to_global((markers["containment"] as Transform3D).origin), 0.0, Infected.S.DORMANT, 77)
		inf.home = inf.global_position


func _leme_appearance() -> Dictionary:
	var a := Appearance.civilian(900)
	a["id"] = "npc_leme"
	a["female"] = false
	a["height"] = 1.82
	a["top"] = "jacket"
	a["top_color"] = Color(0.12, 0.13, 0.16)
	a["top2_color"] = Color(0.85, 0.85, 0.88)
	a["bottom"] = "pants"
	a["bottom_color"] = Color(0.1, 0.1, 0.12)
	a["shoes"] = "boots"
	a["shoes_color"] = Color(0.05, 0.05, 0.05)
	a["hair_style"] = "short"
	a["hair_color"] = Color(0.55, 0.55, 0.55)
	a["glasses"] = false
	a["grime"] = 0.1
	return a


func _guard_appearance(i: int) -> Dictionary:
	var a := Appearance.police(700 + i)
	a["id"] = "npc_s7g_%d" % i
	a["top_color"] = Color(0.08, 0.08, 0.09)
	a["bottom_color"] = Color(0.07, 0.07, 0.08)
	a["hat"] = "helmet"
	a["hat_color"] = Color(0.06, 0.06, 0.07)
	a["mask"] = true
	return a


func _process(delta: float) -> void:
	_t += delta
	var blink := 0.5 + 0.5 * sin(_t * 4.0)
	for l in _alarm_lights:
		(l as OmniLight3D).light_energy = 0.35 + blink * 1.1
