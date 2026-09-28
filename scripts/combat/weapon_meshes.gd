class_name WeaponMeshes
extends RefCounted
## Malhas procedurais das armas empunhadas (cabo na origem, arma ao longo de +Y).

static func mesh(id: String) -> Mesh:
	return Assets.cached_mesh("weapon_" + id, func() -> Mesh: return _build(id))


static func _build(id: String) -> Mesh:
	var b := MeshBuf.new()
	var MET := Assets.uv2_code(Assets.L_METAL)
	var WOOD := Assets.uv2_code(Assets.L_WOOD)
	var FAB := Assets.uv2_code(Assets.L_FABRIC)
	var steel := Color(0.72, 0.73, 0.75)
	var dark := Color(0.15, 0.15, 0.16)
	var wood := Color(0.6, 0.45, 0.3)
	match id:
		"cano_ferro":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.1, 0)), 0.022, 0.85, 8, MET, 0.0, Color(0.45, 0.42, 0.4))
		"taco_beisebol", "taco_pregos":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.12, 0)), 0.018, 0.4, 8, WOOD, 0.0, wood, true, 0.026)
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0.28, 0)), 0.026, 0.5, 8, WOOD, 0.0, wood, true, 0.036)
			if id == "taco_pregos":
				for i in 10:
					var a := i * 2.4
					var y := 0.4 + (i % 5) * 0.07
					b.box_xf(Transform3D(Basis(Vector3.UP, a), Vector3(cos(a) * 0.035, y, sin(a) * 0.035)), Vector3(0.06, 0.006, 0.006), MET, 0.0, steel)
		"facao":
			b.box(Vector3(0, 0.0, 0), Vector3(0.03, 0.14, 0.035), WOOD, 0.0, dark)
			b.box(Vector3(0, 0.33, 0.012), Vector3(0.006, 0.52, 0.06), MET, 0.0, steel)
		"machado":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.12, 0)), 0.018, 0.78, 8, WOOD, 0.0, wood)
			b.box(Vector3(0, 0.58, 0.06), Vector3(0.025, 0.12, 0.17), MET, 0.0, Color(0.5, 0.5, 0.52))
		"marreta":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.12, 0)), 0.02, 0.85, 8, WOOD, 0.0, wood)
			b.box(Vector3(0, 0.72, 0), Vector3(0.09, 0.09, 0.2), MET, 0.0, Color(0.35, 0.35, 0.37))
		"pe_de_cabra":
			b.box(Vector3(0, 0.25, 0), Vector3(0.022, 0.62, 0.022), MET, 0.0, Color(0.55, 0.1, 0.08))
			b.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.9), Vector3(0, 0.58, 0.04)), Vector3(0.022, 0.12, 0.022), MET, 0.0, Color(0.55, 0.1, 0.08))
		"martelo":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.08, 0)), 0.016, 0.34, 8, WOOD, 0.0, wood)
			b.box(Vector3(0, 0.27, 0.02), Vector3(0.03, 0.03, 0.13), MET, 0.0, steel)
		"pa":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.12, 0)), 0.017, 0.95, 8, WOOD, 0.0, wood)
			b.box(Vector3(0, 0.95, 0), Vector3(0.2, 0.26, 0.012), MET, 0.0, Color(0.4, 0.42, 0.42))
		"cassetete":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.1, 0)), 0.018, 0.62, 8, MET, 0.0, dark)
		"lanca":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.4, 0)), 0.016, 1.6, 6, WOOD, 0.0, wood)
			b.box(Vector3(0, 1.28, 0), Vector3(0.012, 0.18, 0.04), MET, 0.0, steel)
		"faca_cozinha", "faca_tatica":
			b.box(Vector3(0, 0.0, 0), Vector3(0.025, 0.11, 0.03), FAB, 0.0, dark)
			b.box(Vector3(0, 0.15, 0.008), Vector3(0.004, 0.2, 0.03), MET, 0.0, steel)
		"chave_fenda":
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, -0.05, 0)), 0.015, 0.1, 6, FAB, 0.0, Color(0.8, 0.6, 0.1))
			b.cylinder(Transform3D(Basis.IDENTITY, Vector3(0, 0.05, 0)), 0.004, 0.14, 4, MET, 0.0, steel)
		"chave_inglesa":
			b.box(Vector3(0, 0.1, 0), Vector3(0.012, 0.28, 0.03), MET, 0.0, steel)
			b.box(Vector3(0, 0.26, 0.015), Vector3(0.014, 0.05, 0.07), MET, 0.0, steel)
		"revolver":
			b.box(Vector3(0, 0.0, 0), Vector3(0.03, 0.1, 0.035), FAB, 0.0, Color(0.3, 0.2, 0.15))
			b.box(Vector3(0, 0.08, -0.06), Vector3(0.03, 0.04, 0.2), MET, 0.0, dark)
			b.cylinder(Transform3D(Basis(Vector3.RIGHT, PI * 0.5), Vector3(0, 0.08, 0.0)), 0.022, 0.05, 8, MET, 0.0, dark)
		"arco":
			for i in 6:
				var t0 := float(i) / 6.0
				var t1 := float(i + 1) / 6.0
				var p0 := Vector3(0, lerpf(-0.6, 0.6, t0), -sin(t0 * PI) * 0.15)
				var p1 := Vector3(0, lerpf(-0.6, 0.6, t1), -sin(t1 * PI) * 0.15)
				var mid := (p0 + p1) * 0.5
				var dir := (p1 - p0).normalized()
				b.box_xf(Transform3D(Basis.looking_at(dir, Vector3.RIGHT), mid), Vector3(0.02, 0.025, p0.distance_to(p1)), WOOD, 0.0, wood)
			b.box(Vector3(0, 0, 0.002), Vector3(0.002, 1.2, 0.002), FAB, 0.0, Color(0.9, 0.9, 0.85))
		_:
			b.box(Vector3(0, 0.2, 0), Vector3(0.03, 0.45, 0.03), MET, 0.0, steel)
	return b.to_mesh(Assets.world_material("props_interior"))
