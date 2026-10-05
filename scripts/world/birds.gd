class_name Birds
extends Node3D
## Urubus planando em círculos lá no alto. Os bandos seguem o jogador bem devagar
## (mau agouro), inclinam nas curvas e batem as asas de vez em quando (shader).
## Somem à noite e com chuva forte.

var target: Node3D
var _flocks: Array = []
var _t := 0.0
static var _mesh: ArrayMesh
static var _shader: Shader


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242
	for f in 2:
		var fl := {"center": Vector3.ZERO, "ready": false, "dir": 1.0 if f == 0 else -1.0,
			"off": Vector3(rng.randf_range(-140.0, 140.0), 0.0, rng.randf_range(-140.0, 140.0)), "birds": []}
		for i in rng.randi_range(3, 5):
			var mi := MeshInstance3D.new()
			mi.mesh = bird_mesh()
			var m := ShaderMaterial.new()
			m.shader = _shader
			m.set_shader_parameter("seed", rng.randf())
			mi.material_override = m
			mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			add_child(mi)
			# envergadura de urubu (~1,7 m)
			(fl["birds"] as Array).append({"node": mi, "s": rng.randf_range(0.95, 1.1), "r": rng.randf_range(16.0, 42.0), "ang": rng.randf() * TAU,
				"h": rng.randf_range(36.0, 72.0), "ph": rng.randf() * TAU, "v": rng.randf_range(8.0, 11.0)})
		_flocks.append(fl)


static func bird_mesh() -> ArrayMesh:
	if _mesh != null:
		return _mesh
	_shader = load("res://shaders/bird.gdshader")
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var tri := func(a: Vector3, b: Vector3, c: Vector3) -> void:
		for p: Vector3 in [a, b, c]:
			st.set_color(Color(clampf(absf(p.x) / 0.86, 0.0, 1.0), 0, 0, 1))
			st.set_normal(Vector3.UP)
			st.add_vertex(p)
	# corpo (frente em -Z), cabeça e cauda em leque
	var nose := Vector3(0, 0.02, -0.42)
	var tail := Vector3(0, 0, 0.36)
	tri.call(nose, Vector3(0.09, 0, -0.08), Vector3(-0.09, 0, -0.08))
	tri.call(Vector3(-0.09, 0, -0.08), Vector3(0.09, 0, -0.08), tail)
	tri.call(Vector3(-0.05, 0, 0.26), Vector3(0.05, 0, 0.26), Vector3(0, 0, 0.5))
	tri.call(Vector3(-0.05, 0, 0.26), Vector3(0, 0, 0.5), Vector3(-0.12, 0, 0.47))
	tri.call(Vector3(0.05, 0, 0.26), Vector3(0.12, 0, 0.47), Vector3(0, 0, 0.5))
	# asas: bordo de ataque reto, ponta "de dedos" (primárias separadas)
	for sg: float in [-1.0, 1.0]:
		var rf := Vector3(0.08 * sg, 0, -0.12)
		var rb := Vector3(0.08 * sg, 0, 0.16)
		var mf := Vector3(0.5 * sg, 0, -0.16)
		var mb := Vector3(0.5 * sg, 0, 0.16)
		tri.call(rf, mf, mb)
		tri.call(rf, mb, rb)
		for k in 4:
			var z0 := -0.15 + k * 0.075
			tri.call(Vector3(0.5 * sg, 0, z0), Vector3(0.5 * sg, 0, z0 + 0.075), Vector3((0.86 - absf(k - 1.5) * 0.04) * sg, 0, z0 + 0.05))
	_mesh = st.commit()
	return _mesh


func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return
	var vis := TimeManager.daylight() > 0.25 and WeatherManager.rain < 0.6
	visible = vis
	if not vis:
		return
	_t += delta
	for fl in _flocks:
		var want: Vector3 = target.global_position + (fl["off"] as Vector3)
		if not bool(fl["ready"]):
			fl["center"] = want
			fl["ready"] = true
		# segue bem devagar; se o jogador sumiu longe (carro, viagem), reaparece
		var cen: Vector3 = fl["center"]
		if cen.distance_to(want) > 600.0:
			cen = want
		cen = cen.lerp(want, clampf(delta * 0.015, 0.0, 1.0))
		fl["center"] = cen
		var dir: float = fl["dir"]
		for b in fl["birds"]:
			var r: float = float(b["r"]) * (1.0 + 0.18 * sin(_t * 0.05 + float(b["ph"])))
			b["ang"] = float(b["ang"]) + float(b["v"]) / r * delta * dir
			var a: float = b["ang"]
			var p := cen + Vector3(cos(a) * r, float(b["h"]) + sin(_t * 0.17 + float(b["ph"])) * 4.0, sin(a) * r)
			var fwd := Vector3(-sin(a), 0.0, cos(a)) * dir
			# inclina para dentro da curva
			var bas := Basis.looking_at(fwd, Vector3.UP) * Basis(Vector3.BACK, -0.38 * dir)
			(b["node"] as MeshInstance3D).global_transform = Transform3D(bas.scaled(Vector3.ONE * float(b["s"])), p)
