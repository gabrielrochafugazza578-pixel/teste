class_name ItemModels
extends RefCounted
## Modelos 3D dos itens soltos no mundo (latas, garrafas, remédios, roupas,
## munição, ferramentas…). Cada item tem um modelo próprio em escala real,
## deitado/apoiado de forma natural, com origem no chão e centrado.
##
## Duas superfícies por malha: o atlas de materiais das armas (aço, polímero,
## nogueira, borracha — plástico, vidro, metal, couro) e o material do mundo
## (tecido, papel, papelão, pedra). Armas e ferramentas com modelo próprio usam
## WeaponMeshes.pickup_mesh(). Malhas ficam em cache por id.

const W := 0.0   # nogueira / madeira
const S := 1.0   # aço
const P := 2.0   # polímero (plástico, vidro fosco, embalagens)
const R := 3.0   # borracha / couro

const ALU := Color(0.86, 0.87, 0.9, 1.0)
const TIN := Color(0.78, 0.78, 0.8, 1.0)
const BRASS := Color(0.95, 0.72, 0.36, 1.0)
const RUST := Color(0.62, 0.38, 0.22, 0.3)


static func mesh(id: String) -> Mesh:
	if WeaponMeshes.has_model(id):
		return WeaponMeshes.pickup_mesh(id)
	return Assets.cached_mesh("item_" + id, func() -> Mesh:
		var a := MeshBuf.new()
		var f := MeshBuf.new()
		_build(id, a, f)
		if a.is_empty() and f.is_empty():
			f.box(Vector3(0, 0.08, 0), Vector3(0.25, 0.16, 0.2), Assets.uv2_code(Assets.L_FABRIC), 0.0, Color(0.6, 0.5, 0.4))
		var m := ArrayMesh.new()
		if not a.is_empty():
			m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, a.to_arrays())
			m.surface_set_material(m.get_surface_count() - 1, Assets.item_material())
		if not f.is_empty():
			m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, f.to_arrays())
			m.surface_set_material(m.get_surface_count() - 1, Assets.world_material("props_interior"))
		return m)


## Cor "de embalagem" estável por id (rótulos variam entre produtos).
static func _hc(id: String, k: int = 0, s: float = 0.7, v: float = 0.75) -> Color:
	var h := fposmod(float(hash(id + str(k)) % 1000) / 1000.0, 1.0)
	return Color.from_hsv(h, s, v)


static func _paint(c: Color) -> Color:
	return Color(c.r, c.g, c.b, 0.3)


static func _fab(layer: int) -> float:
	return Assets.uv2_code(layer)


# ---------------------------------------------------------------------------
# Primitivas
# ---------------------------------------------------------------------------
static func _vcyl(b: MeshBuf, base: Vector3, r: float, h: float, code: float, c: Color, sides: int = 14, r_top: float = -1.0) -> void:
	b.tube(base, base + Vector3(0, h, 0), r, r if r_top < 0.0 else r_top, sides, code, 0.0, c)


## Cilindro deitado no chão, eixo no plano XZ com ângulo `yaw`.
static func _hcyl(b: MeshBuf, center: Vector3, r: float, length: float, yaw: float, code: float, c: Color, sides: int = 12) -> void:
	var d := Vector3(cos(yaw), 0, sin(yaw)) * length * 0.5
	var cc := Vector3(center.x, maxf(center.y, r), center.z)
	b.tube(cc - d, cc + d, r, r, sides, code, 0.0, c)


static func _ball(b: MeshBuf, c: Vector3, r: float, code: float, col: Color) -> void:
	var up := Vector3.UP * r
	b.tube(c - up, c - up * 0.45, r * 0.08, r * 0.88, 10, code, 0.0, col, false)
	b.tube(c - up * 0.45, c + up * 0.45, r * 0.88, r * 0.88, 10, code, 0.0, col, false)
	b.tube(c + up * 0.45, c + up, r * 0.88, r * 0.08, 10, code, 0.0, col, false)


## Anel (toro) deitado: bobinas de corda, fita, pneus.
static func _torus(b: MeshBuf, c: Vector3, big_r: float, r: float, code: float, col: Color, seg: int = 16) -> void:
	for i in seg:
		var a0 := TAU * float(i) / float(seg)
		var a1 := TAU * float(i + 1) / float(seg)
		var p0 := c + Vector3(cos(a0), 0, sin(a0)) * big_r
		var p1 := c + Vector3(cos(a1), 0, sin(a1)) * big_r
		b.tube(p0, p1, r, r, 8, code, 0.0, col, false)


static func _yaw_box(b: MeshBuf, pos: Vector3, size: Vector3, yaw: float, code: float, c: Color) -> void:
	b.box_xf(Transform3D(Basis(Vector3.UP, yaw), pos), size, code, 0.0, c)


# ---------------------------------------------------------------------------
# Modelos
# ---------------------------------------------------------------------------
static func _build(id: String, a: MeshBuf, f: MeshBuf) -> void:
	var FAB := _fab(Assets.L_FABRIC)
	var PAPER := _fab(Assets.L_PLASTER)
	match id:
		# ---- comida
		"lata_feijao", "lata_milho":
			_can(a, 0.037, 0.11, TIN, _paint(Color(0.55, 0.18, 0.12) if id == "lata_feijao" else Color(0.9, 0.75, 0.15)))
		"lata_sardinha":
			a.box(Vector3(0, 0.013, 0), Vector3(0.105, 0.025, 0.065), S, 0.0, TIN)
			a.box(Vector3(0, 0.0135, 0), Vector3(0.107, 0.018, 0.067), S, 0.0, _paint(Color(0.15, 0.3, 0.6)))
			a.tube(Vector3(0.035, 0.027, -0.02), Vector3(0.035, 0.027, 0.02), 0.006, 0.006, 6, S, 0.0, TIN)
		"refrigerante", "energetico":
			var col := Color(0.75, 0.08, 0.08) if id == "refrigerante" else Color(0.1, 0.12, 0.14)
			_can(a, 0.033, 0.122, ALU, _paint(col))
			if id == "energetico":
				a.tube(Vector3(0, 0.05, 0), Vector3(0, 0.08, 0), 0.0335, 0.0335, 14, P, 0.0, Color(0.45, 0.85, 0.2))
		"lata_vazia":
			var tb := MeshBuf.new()
			_can(tb, 0.034, 0.11, ALU, _paint(_hc(id).darkened(0.3)))
			a.append(tb, Transform3D(Basis(Vector3.UP, 0.6) * Basis(Vector3.FORWARD, PI * 0.5), Vector3(0, 0.034, 0)) * Transform3D(Basis.IDENTITY, Vector3(0, -0.055, 0)))
		"racao_militar":
			a.box(Vector3(0, 0.018, 0), Vector3(0.12, 0.035, 0.24), P, 0.0, Color(0.36, 0.34, 0.2))
			a.box(Vector3(0, 0.0355, 0.06), Vector3(0.08, 0.002, 0.06), P, 0.0, Color(0.1, 0.1, 0.08))
		"chocolate", "barra_cereal":
			var sz := Vector3(0.155, 0.012, 0.065) if id == "chocolate" else Vector3(0.11, 0.016, 0.035)
			a.box(Vector3(0, sz.y * 0.5, 0), sz, P, 0.0, Color(0.35, 0.12, 0.08) if id == "chocolate" else Color(0.9, 0.55, 0.12))
			a.box(Vector3(sz.x * 0.46, sz.y * 0.5, 0), Vector3(sz.x * 0.1, sz.y * 1.05, sz.z * 1.02), S, 0.0, ALU)
		"biscoito":
			_hcyl(a, Vector3(0, 0.028, 0), 0.028, 0.2, 0.0, P, Color(0.2, 0.35, 0.75))
			a.tube(Vector3(-0.1, 0.028, 0), Vector3(-0.108, 0.028, 0), 0.02, 0.004, 10, P, 0.0, Color(0.2, 0.35, 0.75))
			a.tube(Vector3(0.1, 0.028, 0), Vector3(0.108, 0.028, 0), 0.02, 0.004, 10, P, 0.0, Color(0.2, 0.35, 0.75))
			a.tube(Vector3(-0.03, 0.028, 0), Vector3(0.03, 0.028, 0), 0.0285, 0.0285, 12, P, 0.0, Color(0.95, 0.8, 0.2))
		"pao_velho":
			_hcyl(a, Vector3(0, 0.04, 0), 0.042, 0.22, 0.2, W, Color(0.95, 0.68, 0.4))
			for i in 3:
				_yaw_box(a, Vector3(-0.06 + i * 0.06, 0.078, 0), Vector3(0.01, 0.008, 0.05), 0.2 + 0.9, W, Color(0.7, 0.45, 0.25))
		"arroz":
			a.box(Vector3(0, 0.03, 0), Vector3(0.16, 0.06, 0.24), P, 0.0, Color(0.95, 0.95, 0.93))
			a.box(Vector3(0, 0.061, 0.02), Vector3(0.12, 0.002, 0.1), P, 0.0, Color(0.8, 0.15, 0.1))
		"macarrao":
			a.box(Vector3(0, 0.025, 0), Vector3(0.09, 0.05, 0.22), P, 0.0, Color(0.15, 0.3, 0.7))
			a.box(Vector3(0, 0.051, 0.03), Vector3(0.06, 0.002, 0.08), P, 0.0, Color(0.95, 0.8, 0.3))
		"arroz_cozido", "macarrao_cozido", "sopa_caseira", "carne_assada", "peixe_assado":
			_vcyl(a, Vector3.ZERO, 0.085, 0.075, S, TIN, 16)
			var fill := {"arroz_cozido": Color(0.95, 0.93, 0.86), "macarrao_cozido": Color(0.95, 0.8, 0.45), "sopa_caseira": Color(0.7, 0.45, 0.2),
				"carne_assada": Color(0.4, 0.2, 0.1), "peixe_assado": Color(0.75, 0.55, 0.3)}
			a.tube(Vector3(0, 0.06, 0), Vector3(0, 0.068, 0), 0.08, 0.08, 16, P, 0.0, fill.get(id, Color.WHITE))
			for sx: float in [-1.0, 1.0]:
				a.box(Vector3(sx * 0.1, 0.06, 0), Vector3(0.03, 0.008, 0.02), S, 0.0, Color(0.2, 0.2, 0.2))
		"mel":
			_vcyl(a, Vector3.ZERO, 0.036, 0.09, P, Color(0.85, 0.55, 0.1))
			_vcyl(a, Vector3(0, 0.09, 0), 0.037, 0.018, S, _paint(Color(0.85, 0.75, 0.2)))
		"carne_crua", "peixe_cru":
			a.box(Vector3(0, 0.008, 0), Vector3(0.2, 0.016, 0.14), P, 0.0, Color(0.92, 0.92, 0.9))
			if id == "carne_crua":
				_yaw_box(a, Vector3(0, 0.03, 0), Vector3(0.15, 0.03, 0.1), 0.15, R, Color(0.7, 0.2, 0.18))
				_yaw_box(a, Vector3(0.02, 0.046, 0.01), Vector3(0.06, 0.004, 0.08), 0.15, R, Color(0.95, 0.9, 0.8))
			else:
				var fish := PackedVector2Array([Vector2(-0.12, 0), Vector2(-0.07, 0.035), Vector2(0.05, 0.03), Vector2(0.09, 0.005),
					Vector2(0.13, 0.03), Vector2(0.13, -0.03), Vector2(0.09, -0.005), Vector2(0.05, -0.03), Vector2(-0.07, -0.035)])
				a.extrude(fish, -0.012, 0.012, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3(0, 0.03, 0)), S, 0.0, Color(0.6, 0.65, 0.7, 1.0))
		"fruta":
			_ball(a, Vector3(0, 0.038, 0), 0.038, P, Color(0.85, 0.35, 0.1))
			_ball(a, Vector3(0.07, 0.035, 0.03), 0.035, P, Color(0.9, 0.7, 0.15))
			_ball(a, Vector3(0.02, 0.034, 0.07), 0.034, P, Color(0.3, 0.6, 0.15))
		"cafe_pronto", "cha_ervas":
			_vcyl(a, Vector3.ZERO, 0.042, 0.23, S, _paint(Color(0.15, 0.3, 0.25) if id == "cafe_pronto" else Color(0.55, 0.12, 0.1)), 16)
			_vcyl(a, Vector3(0, 0.23, 0), 0.036, 0.05, P, Color(0.12, 0.12, 0.12), 14)
		"agua_garrafa", "agua_fervida", "agua_suja", "suco_caixa":
			if id == "suco_caixa":
				a.box(Vector3(0, 0.06, 0), Vector3(0.063, 0.12, 0.04), P, 0.0, Color(0.95, 0.6, 0.1))
				a.box(Vector3(0, 0.065, -0.0205), Vector3(0.05, 0.05, 0.002), P, 0.0, Color(0.3, 0.7, 0.2))
				a.tube(Vector3(0.015, 0.12, 0), Vector3(0.02, 0.16, 0), 0.003, 0.003, 6, P, 0.0, Color(0.95, 0.95, 0.95))
			else:
				var tint := Color(0.72, 0.85, 0.92)
				if id == "agua_suja":
					tint = Color(0.62, 0.55, 0.35)
				_pet(a, tint, Color(0.15, 0.35, 0.8) if id != "agua_fervida" else Color(0.9, 0.9, 0.9), _hc(id, 1, 0.5, 0.85))
		"cachaca", "garrafa_vazia", "coquetel":
			var gb := MeshBuf.new()
			var glass := Color(0.35, 0.55, 0.25) if id != "cachaca" else Color(0.75, 0.55, 0.25)
			_glass_bottle(gb, glass)
			if id == "coquetel":
				f.box_xf(Transform3D(Basis(Vector3.BACK, 0.3), Vector3(0.005, 0.33, 0)), Vector3(0.028, 0.09, 0.024), FAB, 0.0, Color(0.85, 0.8, 0.7))
				a.append(gb)
			elif id == "garrafa_vazia":
				a.append(gb, Transform3D(Basis(Vector3.UP, -0.4) * Basis(Vector3.FORWARD, PI * 0.5), Vector3(0, 0.036, 0)) * Transform3D(Basis.IDENTITY, Vector3(0, -0.154, 0)))
			else:
				a.append(gb)
				a.box(Vector3(0, 0.1, -0.0365), Vector3(0.05, 0.07, 0.002), P, 0.0, Color(0.95, 0.9, 0.75))
		"cigarros":
			a.box(Vector3(0, 0.011, 0), Vector3(0.056, 0.022, 0.088), P, 0.0, Color(0.95, 0.95, 0.95))
			a.box(Vector3(0, 0.0112, -0.03), Vector3(0.057, 0.0226, 0.03), P, 0.0, Color(0.8, 0.1, 0.1))
		"fosforos":
			a.box(Vector3(0, 0.008, 0), Vector3(0.055, 0.016, 0.037), P, 0.0, Color(0.9, 0.85, 0.3))
			a.box(Vector3(0.0276, 0.008, 0), Vector3(0.002, 0.012, 0.035), R, 0.0, Color(0.35, 0.2, 0.15))
		"isqueiro":
			_yaw_box(a, Vector3(0, 0.006, 0), Vector3(0.025, 0.012, 0.08), 0.4, P, _hc(id, 0, 0.8, 0.8))
			_yaw_box(a, Vector3(0.012, 0.007, -0.035), Vector3(0.022, 0.013, 0.014), 0.4, S, ALU)
		# ---- medicamentos
		"analgesico", "antitermico", "antibiotico", "carvao_ativado", "comprimido_purificador":
			var stripe := {"analgesico": Color(0.2, 0.4, 0.8), "antitermico": Color(0.85, 0.2, 0.2), "antibiotico": Color(0.2, 0.65, 0.3),
				"carvao_ativado": Color(0.15, 0.15, 0.15), "comprimido_purificador": Color(0.2, 0.7, 0.85)}
			a.box(Vector3(0, 0.016, 0), Vector3(0.1, 0.032, 0.055), P, 0.0, Color(0.96, 0.96, 0.95))
			a.box(Vector3(0, 0.0325, 0), Vector3(0.1, 0.002, 0.018), P, 0.0, stripe.get(id, Color.RED))
			a.box(Vector3(0.07, 0.003, 0.02), Vector3(0.05, 0.005, 0.1), S, 0.0, ALU)
		"vitaminas", "remedios_remanescentes":
			for i in (1 if id == "vitaminas" else 3):
				var o := Vector3(i * 0.05 - 0.05 * (1 if id != "vitaminas" else 0), 0, (i % 2) * 0.03)
				_vcyl(a, o, 0.022, 0.07, P, Color(0.85, 0.45, 0.1))
				_vcyl(a, o + Vector3(0, 0.07, 0), 0.024, 0.02, P, Color(0.96, 0.96, 0.96))
		"bandagem", "pano_limpo":
			if id == "bandagem":
				_hcyl(f, Vector3(0, 0.026, 0), 0.026, 0.075, 0.3, FAB, Color(1.1, 1.08, 1.02))
				_yaw_box(f, Vector3(0.06, 0.001, 0.03), Vector3(0.05, 0.002, 0.12), 1.0, FAB, Color(1.1, 1.08, 1.02))
			else:
				_folded(f, Vector3(0.28, 0.018, 0.22), Color(1.05, 1.05, 1.05), 2)
		"antisseptico", "alcool", "cola":
			var body := {"antisseptico": Color(0.45, 0.25, 0.12), "alcool": Color(0.92, 0.94, 0.96), "cola": Color(0.96, 0.96, 0.9)}
			var hh := 0.19 if id == "alcool" else (0.12 if id == "antisseptico" else 0.09)
			var rr := 0.038 if id == "alcool" else (0.026 if id == "antisseptico" else 0.02)
			_vcyl(a, Vector3.ZERO, rr, hh, P, body.get(id, Color.WHITE))
			a.tube(Vector3(0, hh, 0), Vector3(0, hh + 0.02, 0), rr, rr * 0.45, 12, P, 0.0, body.get(id, Color.WHITE))
			_vcyl(a, Vector3(0, hh + 0.02, 0), rr * 0.45, 0.022, P, Color(0.85, 0.12, 0.1) if id != "cola" else Color(0.95, 0.6, 0.1))
			a.tube(Vector3(0, hh * 0.3, 0), Vector3(0, hh * 0.7, 0), rr + 0.0008, rr + 0.0008, 14, P, 0.0, _hc(id, 2, 0.6, 0.8))
		"kit_primeiros_socorros":
			a.box(Vector3(0, 0.045, 0), Vector3(0.28, 0.09, 0.19), P, 0.0, Color(0.8, 0.12, 0.1))
			a.box(Vector3(0, 0.0905, 0), Vector3(0.1, 0.002, 0.03), P, 0.0, Color(0.97, 0.97, 0.97))
			a.box(Vector3(0, 0.0905, 0), Vector3(0.03, 0.002, 0.1), P, 0.0, Color(0.97, 0.97, 0.97))
			a.tube(Vector3(-0.05, 0.09, -0.1), Vector3(0.05, 0.09, -0.1), 0.008, 0.008, 6, P, 0.0, Color(0.2, 0.2, 0.2))
		"kit_sutura":
			a.box(Vector3(0, 0.016, 0), Vector3(0.16, 0.032, 0.1), P, 0.0, Color(0.9, 0.92, 0.94))
			a.box(Vector3(0, 0.0325, 0), Vector3(0.14, 0.002, 0.03), P, 0.0, Color(0.2, 0.5, 0.75))
		"tala":
			for sx: float in [-0.04, 0.04]:
				a.box(Vector3(sx, 0.004, 0), Vector3(0.06, 0.008, 0.36), S, 0.0, ALU)
			a.box(Vector3(0, 0.009, 0.05), Vector3(0.15, 0.004, 0.04), R, 0.0, Color(0.1, 0.1, 0.12))
		"inibidor_nx":
			_hcyl(a, Vector3(0, 0.009, 0), 0.009, 0.1, 0.0, P, Color(0.85, 0.92, 0.95))
			_hcyl(a, Vector3(-0.005, 0.009, 0), 0.0075, 0.06, 0.0, P, Color(0.2, 0.75, 0.95))
			a.tube(Vector3(0.05, 0.009, 0), Vector3(0.08, 0.009, 0), 0.0012, 0.0006, 5, S, 0.0, ALU)
			a.tube(Vector3(-0.05, 0.009, 0), Vector3(-0.075, 0.009, 0), 0.003, 0.003, 6, P, 0.0, Color(0.9, 0.9, 0.9))
			a.box(Vector3(-0.078, 0.009, 0), Vector3(0.004, 0.018, 0.022), P, 0.0, Color(0.9, 0.9, 0.9))
		# ---- materiais
		"tabua":
			for i in 2:
				_yaw_box(a, Vector3(i * 0.02, 0.011 + i * 0.022, i * 0.03), Vector3(0.9, 0.022, 0.1), 0.1 * i, W, Color(1.25, 1.05, 0.8))
		"lenha":
			for i in 3:
				var cc := Vector3(-0.047 if i == 0 else (0.047 if i == 1 else 0.0), 0.045 if i < 2 else 0.122, 0.0)
				_hcyl(a, cc, 0.045, 0.42, PI * 0.5 + (i - 1) * 0.1, W, Color(0.55, 0.4, 0.28))
		"pregos", "parafusos":
			f.box(Vector3(0, 0.022, 0), Vector3(0.1, 0.044, 0.07), FAB, 0.0, Color(0.62, 0.48, 0.32))
			for i in 5:
				var yaw := float(i) * 1.3
				var o := Vector3(0.08 + (i % 3) * 0.02, 0.003, -0.03 + i * 0.015)
				var d := Vector3(cos(yaw), 0, sin(yaw)) * 0.03
				a.tube(o - d, o + d, 0.0022, 0.0015 if id == "pregos" else 0.0022, 5, S, 0.0, TIN)
		"sucata", "pecas_motor", "plastico":
			if id == "plastico":
				_yaw_box(a, Vector3(0, 0.004, 0), Vector3(0.3, 0.008, 0.22), 0.3, P, Color(0.3, 0.45, 0.7))
				_yaw_box(a, Vector3(0.05, 0.012, 0.02), Vector3(0.2, 0.006, 0.18), -0.5, P, Color(0.85, 0.85, 0.8))
			else:
				_gear(a, Vector3(0, 0.012, 0), 0.07, TIN if id == "pecas_motor" else RUST)
				a.box_xf(Transform3D(Basis(Vector3.UP, 0.8) * Basis(Vector3.RIGHT, 0.15), Vector3(0.1, 0.012, 0.08)), Vector3(0.22, 0.006, 0.12), S, 0.0, RUST)
				_hcyl(a, Vector3(-0.09, 0.016, 0.07), 0.016, 0.26, 2.2, S, Color(0.5, 0.5, 0.5, 1.0))
		"fita_adesiva":
			_torus(a, Vector3(0, 0.024, 0), 0.042, 0.02, P, Color(0.7, 0.7, 0.72))
		"pneu":
			_torus(a, Vector3(0, 0.1, 0), 0.24, 0.1, R, Color(0.18, 0.18, 0.19), 20)
			_vcyl(a, Vector3(0, 0.05, 0), 0.15, 0.1, S, Color(0.6, 0.6, 0.62, 1.0), 16)
		"corda", "fios", "mangueira":
			var col := {"corda": Color(0.8, 0.7, 0.5), "fios": Color(0.15, 0.15, 0.15), "mangueira": Color(0.2, 0.5, 0.25)}
			var th := {"corda": 0.009, "fios": 0.004, "mangueira": 0.011}
			var code := R if id != "corda" else W
			for i in (4 if id != "fios" else 6):
				_torus(a, Vector3(0.004 * i, float(th[id]) * (1.0 + i * 1.6), 0.003 * i), 0.12 - i * 0.004, th[id], code, col[id], 18)
		"lona", "pano", "tecido_grosso":
			var col := {"lona": Color(0.25, 0.4, 0.7), "pano": _hc(id, 3, 0.4, 0.75), "tecido_grosso": Color(0.45, 0.4, 0.32)}
			_folded(f, Vector3(0.4 if id == "lona" else 0.3, 0.02 if id != "lona" else 0.03, 0.3 if id == "lona" else 0.22), col[id], 3 if id == "lona" else 2)
		"ervas":
			for i in 7:
				var yaw := -0.3 + i * 0.1
				var d := Vector3(cos(yaw), 0, sin(yaw)) * 0.12
				f.tube(Vector3(0, 0.01, 0), Vector3(0, 0.01, 0) + d, 0.004, 0.012, 5, _fab(Assets.L_GRASS), 0.0, Color(0.9, 1.1, 0.6))
			f.tube(Vector3(0.01, 0.01, -0.01), Vector3(0.01, 0.01, 0.012), 0.008, 0.008, 6, FAB, 0.0, Color(0.8, 0.7, 0.5))
		"oleo_motor":
			a.box(Vector3(0, 0.1, 0), Vector3(0.13, 0.2, 0.065), P, 0.0, Color(0.95, 0.75, 0.1))
			_vcyl(a, Vector3(0.035, 0.2, 0), 0.016, 0.03, P, Color(0.1, 0.1, 0.1))
			a.box(Vector3(-0.035, 0.175, 0), Vector3(0.04, 0.05, 0.02), P, 0.0, Color(0.95, 0.75, 0.1))
			a.box(Vector3(0, 0.1, -0.0335), Vector3(0.1, 0.08, 0.002), P, 0.0, Color(0.1, 0.1, 0.12))
		"bateria_carro":
			a.box(Vector3(0, 0.085, 0), Vector3(0.24, 0.17, 0.17), P, 0.0, Color(0.12, 0.12, 0.13))
			a.box(Vector3(0, 0.171, 0), Vector3(0.22, 0.004, 0.15), P, 0.0, Color(0.2, 0.2, 0.22))
			for sx: float in [-1.0, 1.0]:
				_vcyl(a, Vector3(sx * 0.08, 0.17, 0.05), 0.01, 0.022, S, BRASS if sx > 0 else Color(0.4, 0.4, 0.4, 1.0))
		# ---- combustível
		"galao_gasolina", "galao_vazio":
			var col := _paint(Color(0.75, 0.12, 0.08) if id == "galao_gasolina" else Color(0.25, 0.4, 0.25))
			a.box(Vector3(0, 0.2, 0), Vector3(0.16, 0.4, 0.33), S, 0.0, col)
			for s2: float in [-1.0, 1.0]:
				a.box_xf(Transform3D(Basis(Vector3.RIGHT, s2 * 0.7), Vector3(0.081, 0.2, 0)), Vector3(0.004, 0.03, 0.36), S, 0.0, col.darkened(0.15))
				a.box_xf(Transform3D(Basis(Vector3.RIGHT, s2 * 0.7), Vector3(-0.081, 0.2, 0)), Vector3(0.004, 0.03, 0.36), S, 0.0, col.darkened(0.15))
			for zz: float in [-0.09, 0.0, 0.09]:
				a.box(Vector3(0, 0.43, zz), Vector3(0.025, 0.06, 0.018), S, 0.0, col)
			a.box(Vector3(0, 0.455, 0), Vector3(0.025, 0.012, 0.2), S, 0.0, col)
			a.tube(Vector3(0, 0.4, 0.13), Vector3(0, 0.44, 0.15), 0.02, 0.02, 10, S, 0.0, col.darkened(0.2))
		# ---- ferramentas sem modelo de arma
		"alicate":
			var arm := PackedVector2Array([Vector2(0, -0.006), Vector2(0.06, -0.01), Vector2(0.19, -0.006), Vector2(0.19, 0.006), Vector2(0.06, 0.004), Vector2(0, 0.006)])
			for s2: float in [-1.0, 1.0]:
				a.extrude(arm, -0.005, 0.005, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5) * Basis(Vector3.BACK, s2 * 0.12), Vector3(0, 0.006 + (s2 + 1.0) * 0.005, 0)), S, 0.0, TIN)
				_hcyl(a, Vector3(0.14 * cos(s2 * 0.12), 0.008, -0.14 * sin(s2 * 0.12)), 0.009, 0.1, -s2 * 0.12, R, Color(0.75, 0.15, 0.1))
		"serrote":
			var blade := PackedVector2Array([Vector2(0, 0.05), Vector2(0.45, 0.02), Vector2(0.45, -0.02), Vector2(0, -0.06)])
			a.extrude(blade, -0.001, 0.001, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3(0.05, 0.003, 0)), S, 0.0, TIN)
			a.box(Vector3(-0.05, 0.012, -0.005), Vector3(0.14, 0.024, 0.11), P, 0.0, Color(0.8, 0.2, 0.1))
		"kit_ferramentas":
			a.box(Vector3(0, 0.09, 0), Vector3(0.42, 0.18, 0.2), S, 0.0, _paint(Color(0.75, 0.12, 0.08)))
			a.box(Vector3(0, 0.181, 0), Vector3(0.43, 0.004, 0.21), S, 0.0, _paint(Color(0.6, 0.1, 0.06)))
			a.tube(Vector3(-0.1, 0.21, 0), Vector3(0.1, 0.21, 0), 0.01, 0.01, 8, P, 0.0, Color(0.1, 0.1, 0.1))
			for sx: float in [-0.1, 0.1]:
				a.box(Vector3(sx, 0.195, 0), Vector3(0.012, 0.03, 0.012), S, 0.0, TIN)
			a.box(Vector3(0, 0.15, -0.101), Vector3(0.05, 0.03, 0.004), S, 0.0, TIN)
		"pilha":
			for i in 2:
				_hcyl(a, Vector3(0, 0.007, i * 0.016), 0.007, 0.05, 0.0, S, _paint(Color(0.1, 0.1, 0.1) if i == 0 else Color(0.8, 0.5, 0.1)))
				a.tube(Vector3(0.025, 0.007, i * 0.016), Vector3(0.028, 0.007, i * 0.016), 0.003, 0.003, 6, S, 0.0, TIN)
		"radio_portatil":
			a.box(Vector3(0, 0.07, 0), Vector3(0.06, 0.14, 0.035), P, 0.0, Color(0.12, 0.12, 0.13))
			a.box(Vector3(0, 0.1, -0.0178), Vector3(0.04, 0.025, 0.002), P, 0.0, Color(0.3, 0.45, 0.35))
			_vcyl(a, Vector3(0.018, 0.14, 0), 0.005, 0.1, R, Color(0.08, 0.08, 0.08), 6)
			a.box(Vector3(-0.012, 0.15, 0), Vector3(0.012, 0.02, 0.012), P, 0.0, Color(0.1, 0.1, 0.1))
		"binoculo":
			for sx: float in [-0.035, 0.035]:
				_hcyl(a, Vector3(sx, 0.03, 0), 0.03, 0.12, PI * 0.5, R, Color(0.12, 0.12, 0.12))
				a.tube(Vector3(sx, 0.03, -0.061), Vector3(sx, 0.03, -0.063), 0.026, 0.026, 12, P, 0.0, Color(0.2, 0.3, 0.4))
			a.box(Vector3(0, 0.035, 0.02), Vector3(0.04, 0.02, 0.05), P, 0.0, Color(0.15, 0.15, 0.15))
		# ---- equipamento
		"mochila_escolar", "mochila_trilha", "mochila_militar":
			var col := {"mochila_escolar": Color(0.2, 0.3, 0.6), "mochila_trilha": Color(0.7, 0.3, 0.1), "mochila_militar": Color(0.35, 0.37, 0.25)}
			var big := 1.0 if id == "mochila_escolar" else 1.25
			f.box(Vector3(0, 0.07 * big, 0), Vector3(0.3, 0.14, 0.42) * big, FAB, 0.0, col[id])
			f.box(Vector3(0, 0.15 * big, 0.06), Vector3(0.22 * big, 0.04, 0.2 * big), FAB, 0.0, (col[id] as Color).darkened(0.15))
			for sx: float in [-0.08, 0.08]:
				f.box(Vector3(sx * big, 0.005, 0), Vector3(0.05, 0.01, 0.4 * big), FAB, 0.0, Color(0.1, 0.1, 0.1))
			a.box(Vector3(0, 0.171 * big, 0.06), Vector3(0.18 * big, 0.004, 0.006), S, 0.0, TIN)
		"jaqueta", "casaco_inverno", "capa_chuva":
			var col := {"jaqueta": Color(0.25, 0.28, 0.35), "casaco_inverno": Color(0.4, 0.3, 0.22), "capa_chuva": Color(0.9, 0.75, 0.15)}
			_folded(f, Vector3(0.42, 0.035, 0.32), col[id], 2)
			f.box_xf(Transform3D(Basis(Vector3.UP, 0.5), Vector3(0.2, 0.012, 0.18)), Vector3(0.1, 0.024, 0.34), FAB, 0.0, (col[id] as Color).darkened(0.1))
			a.box(Vector3(0, 0.073, 0), Vector3(0.006, 0.002, 0.28), S, 0.0, TIN)
		"colete":
			a.box(Vector3(0, 0.025, 0), Vector3(0.4, 0.05, 0.46), R, 0.0, Color(0.14, 0.15, 0.16))
			for i in 3:
				a.box(Vector3(-0.12 + i * 0.12, 0.06, 0.08), Vector3(0.09, 0.025, 0.12), R, 0.0, Color(0.18, 0.19, 0.2))
			a.box(Vector3(0, 0.051, -0.12), Vector3(0.2, 0.002, 0.06), P, 0.0, Color(0.9, 0.9, 0.9))
		"botas":
			for sx: float in [-0.07, 0.07]:
				var bb := MeshBuf.new()
				bb.box(Vector3(0, 0.015, 0.02), Vector3(0.1, 0.03, 0.29), R, 0.0, Color(0.08, 0.08, 0.08))
				bb.box(Vector3(0, 0.06, 0.04), Vector3(0.095, 0.07, 0.24), R, 0.0, Color(0.3, 0.2, 0.12))
				bb.box(Vector3(0, 0.16, 0.1), Vector3(0.09, 0.2, 0.12), R, 0.0, Color(0.3, 0.2, 0.12))
				a.append(bb, Transform3D(Basis(Vector3.UP, sx * 1.5), Vector3(sx * 1.4, 0, 0)))
		"luvas":
			for sx: float in [-1.0, 1.0]:
				var gb := MeshBuf.new()
				gb.box(Vector3(0, 0.012, 0), Vector3(0.09, 0.024, 0.11), R, 0.0, Color(0.35, 0.25, 0.15))
				for k in 4:
					gb.tube(Vector3(-0.033 + k * 0.022, 0.011, -0.055), Vector3(-0.033 + k * 0.022, 0.011, -0.12), 0.01, 0.009, 6, R, 0.0, Color(0.35, 0.25, 0.15))
				gb.tube(Vector3(sx * 0.045, 0.011, 0.0), Vector3(sx * 0.08, 0.011, -0.04), 0.011, 0.01, 6, R, 0.0, Color(0.35, 0.25, 0.15))
				a.append(gb, Transform3D(Basis(Vector3.UP, sx * 0.4), Vector3(sx * 0.07, 0, 0)))
		"mascara_filtro":
			var mb := MeshBuf.new()
			mb.tube(Vector3(0, 0.0, 0), Vector3(0, 0.06, 0), 0.09, 0.07, 16, R, 0.0, Color(0.1, 0.1, 0.11))
			for sx: float in [-0.035, 0.035]:
				mb.tube(Vector3(sx, 0.058, -0.02), Vector3(sx, 0.064, -0.02), 0.025, 0.025, 12, P, 0.0, Color(0.3, 0.4, 0.45))
			mb.tube(Vector3(0, 0.03, 0.07), Vector3(0, 0.05, 0.13), 0.035, 0.04, 12, S, 0.0, _paint(Color(0.35, 0.37, 0.3)))
			a.append(mb, Transform3D(Basis.IDENTITY, Vector3(0, 0.002, 0)))
		# ---- munição
		"municao_38", "municao_9mm", "municao_380", "municao_22", "municao_308", "municao_556":
			var col := {"municao_38": Color(0.2, 0.3, 0.55), "municao_9mm": Color(0.2, 0.45, 0.25), "municao_380": Color(0.5, 0.2, 0.5),
				"municao_22": Color(0.85, 0.7, 0.15), "municao_308": Color(0.35, 0.3, 0.22), "municao_556": Color(0.3, 0.33, 0.2)}
			var long_ := id in ["municao_308", "municao_556"]
			var bs := Vector3(0.1, 0.035, 0.07) if not long_ else Vector3(0.14, 0.04, 0.085)
			a.box(Vector3(0, bs.y * 0.5, 0), bs, P, 0.0, col[id])
			a.box(Vector3(0, bs.y + 0.001, 0), Vector3(bs.x * 0.8, 0.002, bs.z * 0.5), P, 0.0, Color(0.95, 0.93, 0.85))
			var cl := 0.07 if long_ else (0.025 if id == "municao_22" else 0.03)
			var cr := 0.0055 if long_ else (0.0028 if id == "municao_22" else 0.0048)
			for i in 3:
				var o := Vector3(0.08 + i * 0.018, cr, -0.02 + i * 0.02)
				var d := Vector3(cos(0.4 + i), 0, sin(0.4 + i)) * cl * 0.5
				a.tube(o - d, o + d * 0.55, cr, cr, 8, S, 0.0, BRASS)
				a.tube(o + d * 0.55, o + d, cr * 0.95, cr * 0.35, 8, S, 0.0, Color(0.75, 0.5, 0.35, 1.0))
		"cartucho_12":
			a.box(Vector3(0, 0.035, 0), Vector3(0.12, 0.07, 0.065), P, 0.0, Color(0.75, 0.12, 0.08))
			a.box(Vector3(0, 0.0705, 0), Vector3(0.09, 0.002, 0.04), P, 0.0, Color(0.95, 0.9, 0.8))
			for i in 2:
				var o := Vector3(0.1 + i * 0.03, 0.0105, 0.01 - i * 0.03)
				var d := Vector3(cos(0.7 + i * 1.1), 0, sin(0.7 + i * 1.1)) * 0.035
				a.tube(o - d, o - d * 0.55, 0.0115, 0.0115, 10, S, 0.0, BRASS)
				a.tube(o - d * 0.55, o + d, 0.0105, 0.0105, 10, P, 0.0, Color(0.75, 0.1, 0.08))
		"flecha", "virote":
			var ln := 0.7 if id == "flecha" else 0.38
			for i in 3:
				var yaw := -0.08 + i * 0.08
				var o := Vector3(0, 0.005 + i * 0.001, -0.02 + i * 0.02)
				var d := Vector3(cos(yaw), 0, sin(yaw)) * ln * 0.5
				a.tube(o - d, o + d, 0.004, 0.004, 6, W if id == "flecha" else P, 0.0, Color(0.9, 0.75, 0.5) if id == "flecha" else Color(0.15, 0.15, 0.15))
				a.tube(o + d, o + d * 1.09, 0.006, 0.0005, 6, S, 0.0, TIN)
				for k in 2:
					var fb := o - d * 0.85
					a.box_xf(Transform3D(Basis(Vector3.UP, -yaw) * Basis(Vector3.RIGHT, k * PI * 0.5), fb), Vector3(0.06, 0.018, 0.001), P,
						0.0, Color(0.85, 0.2, 0.15) if id == "flecha" else Color(0.9, 0.9, 0.9))
		# ---- arremessáveis
		"pedra":
			var rk := _fab(Assets.L_ROCK)
			f.box_xf(Transform3D(Basis.from_euler(Vector3(0.3, 0.5, 0.2)), Vector3(0, 0.035, 0)), Vector3(0.09, 0.06, 0.08), rk, 0.3, Color(0.75, 0.72, 0.68))
			f.box_xf(Transform3D(Basis.from_euler(Vector3(-0.4, 1.2, 0.5)), Vector3(0.01, 0.04, 0.005)), Vector3(0.08, 0.05, 0.07), rk, 0.6, Color(0.75, 0.72, 0.68))
		"rojao":
			for i in 2:
				_hcyl(f, Vector3(0, 0.02, i * 0.045), 0.02, 0.2, 0.0, PAPER, Color(0.85, 0.15, 0.12) if i == 0 else Color(0.2, 0.3, 0.8))
			a.tube(Vector3(0.1, 0.02, 0), Vector3(0.14, 0.02, 0), 0.0015, 0.0015, 4, P, 0.0, Color(0.3, 0.8, 0.2))
		# ---- história / documentos
		"bilhete_mae", "fragmento_1", "fragmento_2", "fragmento_3":
			_yaw_box(f, Vector3(0, 0.002, 0), Vector3(0.15, 0.003, 0.21), 0.2, PAPER, Color(1.05, 1.02, 0.9))
			_yaw_box(f, Vector3(0.02, 0.0045, 0.01), Vector3(0.14, 0.002, 0.1), -0.1, PAPER, Color(1.0, 0.97, 0.85))
		"dossie_nexus", "prontuario_lia":
			if id == "prontuario_lia":
				a.box(Vector3(0, 0.004, 0), Vector3(0.23, 0.006, 0.32), W, 0.0, Color(0.9, 0.7, 0.45))
				f.box(Vector3(0, 0.009, 0.01), Vector3(0.21, 0.004, 0.28), PAPER, 0.0, Color(1.05, 1.05, 1.02))
				a.box(Vector3(0, 0.014, -0.14), Vector3(0.09, 0.012, 0.03), S, 0.0, TIN)
			else:
				f.box(Vector3(0, 0.01, 0), Vector3(0.24, 0.02, 0.32), PAPER, 0.0, Color(0.95, 0.85, 0.6))
				f.box_xf(Transform3D(Basis(Vector3.UP, 0.15), Vector3(0.03, 0.022, 0.01)), Vector3(0.21, 0.004, 0.29), PAPER, 0.0, Color(1.05, 1.05, 1.0))
				f.box(Vector3(0, 0.0205, -0.1), Vector3(0.1, 0.002, 0.03), PAPER, 0.0, Color(0.7, 0.12, 0.1))
		"foto_familia":
			a.box(Vector3(0, 0.001, 0), Vector3(0.1, 0.002, 0.15), P, 0.0, Color(0.95, 0.95, 0.93))
			a.box(Vector3(0, 0.0021, 0.005), Vector3(0.088, 0.001, 0.12), P, 0.0, Color(0.55, 0.45, 0.35))
		"cartao_corvalis", "cartao_nivel4":
			a.box(Vector3(0, 0.0012, 0), Vector3(0.086, 0.0024, 0.054), P, 0.0, Color(0.92, 0.94, 0.96))
			a.box(Vector3(0, 0.0025, -0.016), Vector3(0.086, 0.0004, 0.014), P, 0.0, Color(0.15, 0.3, 0.55) if id == "cartao_corvalis" else Color(0.75, 0.15, 0.12))
			a.box(Vector3(-0.025, 0.0025, 0.008), Vector3(0.022, 0.0004, 0.028), P, 0.0, Color(0.6, 0.6, 0.6))
		"chave_oficina", "chave_setor7":
			_torus(a, Vector3(-0.03, 0.003, 0), 0.014, 0.003, S, BRASS if id == "chave_oficina" else TIN, 12)
			var kp := PackedVector2Array([Vector2(-0.015, 0.004), Vector2(0.045, 0.004), Vector2(0.045, -0.002), Vector2(0.04, -0.006),
				Vector2(0.035, -0.002), Vector2(0.028, -0.007), Vector2(0.02, -0.002), Vector2(-0.015, -0.004)])
			a.extrude(kp, -0.0015, 0.0015, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3(0, 0.002, 0)), S, 0.0, BRASS if id == "chave_oficina" else TIN)
		# ---- estruturas (kits)
		"kit_barricada", "kit_fogueira", "bancada", "armadilha_latas", "cama_improvisada", "coletor_chuva", "caixa_armazenamento", "esconderijo":
			for i in 3:
				_yaw_box(a, Vector3(0, 0.012 + i * 0.024, (i - 1) * 0.01), Vector3(0.6, 0.022, 0.1), (i - 1) * 0.08, W, Color(1.15, 0.95, 0.72))
			for sx: float in [-0.18, 0.18]:
				a.tube(Vector3(sx, 0.04, -0.07), Vector3(sx, 0.04, 0.07), 0.042, 0.042, 10, W, 0.0, Color(0.8, 0.7, 0.5))
			if id == "armadilha_latas":
				for i in 3:
					var tb := MeshBuf.new()
					_can(tb, 0.034, 0.11, ALU, _paint(_hc(id, i)))
					a.append(tb, Transform3D(Basis(Vector3.UP, i), Vector3(-0.15 + i * 0.15, 0.075, 0.12)))
		_:
			_generic(id, a, f)


static func _generic(id: String, a: MeshBuf, f: MeshBuf) -> void:
	var FAB := _fab(Assets.L_FABRIC)
	match UIIcons.glyph_for_item(id):
		"can":
			_can(a, 0.037, 0.11, TIN, _paint(_hc(id)))
		"bottle":
			_pet(a, Color(0.75, 0.85, 0.9), Color(0.2, 0.4, 0.8), _hc(id))
		"ammo":
			a.box(Vector3(0, 0.018, 0), Vector3(0.1, 0.035, 0.07), P, 0.0, _hc(id, 0, 0.5, 0.5))
		"document", "book", "map":
			f.box(Vector3(0, 0.01, 0), Vector3(0.17, 0.02, 0.24), _fab(Assets.L_PLASTER), 0.0, _hc(id, 0, 0.4, 0.6))
		"pill", "medkit":
			a.box(Vector3(0, 0.016, 0), Vector3(0.1, 0.032, 0.055), P, 0.0, Color(0.95, 0.95, 0.95))
		"jacket", "cloth", "vest":
			_folded(f, Vector3(0.35, 0.03, 0.28), _hc(id, 0, 0.4, 0.6), 2)
		_:
			match ItemDB.category(id):
				"comida":
					a.box(Vector3(0, 0.03, 0), Vector3(0.14, 0.06, 0.1), P, 0.0, _hc(id))
				"arma", "ferramenta":
					a.box(Vector3(0, 0.02, 0), Vector3(0.4, 0.04, 0.05), S, 0.0, TIN)
					a.box(Vector3(-0.15, 0.022, 0), Vector3(0.14, 0.044, 0.06), R, 0.0, Color(0.2, 0.2, 0.2))
				_:
					f.box(Vector3(0, 0.06, 0), Vector3(0.22, 0.12, 0.18), FAB, 0.0, Color(0.62, 0.48, 0.32))


# ---------------------------------------------------------------------------
# Peças reaproveitadas
# ---------------------------------------------------------------------------
static func _can(b: MeshBuf, r: float, h: float, metal: Color, label: Color) -> void:
	b.tube(Vector3(0, 0, 0), Vector3(0, 0.006, 0), r * 0.94, r, 16, S, 0.0, metal, false)
	b.tube(Vector3(0, 0.006, 0), Vector3(0, h - 0.008, 0), r, r, 16, S, 0.0, metal, false)
	b.tube(Vector3(0, h * 0.12, 0), Vector3(0, h * 0.88, 0), r + 0.0006, r + 0.0006, 16, S, 0.0, label, false)
	b.tube(Vector3(0, h - 0.008, 0), Vector3(0, h, 0), r, r * 0.9, 16, S, 0.0, metal)
	b.tube(Vector3(0, h - 0.0015, 0), Vector3(0, h + 0.001, 0), r * 0.92, r * 0.92, 16, S, 0.0, metal.lightened(0.1))


static func _pet(b: MeshBuf, body: Color, cap: Color, label: Color) -> void:
	b.tube(Vector3(0, 0, 0), Vector3(0, 0.012, 0), 0.028, 0.035, 14, P, 0.0, body, false)
	b.tube(Vector3(0, 0.012, 0), Vector3(0, 0.17, 0), 0.035, 0.035, 14, P, 0.0, body, false)
	b.tube(Vector3(0, 0.17, 0), Vector3(0, 0.215, 0), 0.035, 0.013, 14, P, 0.0, body, false)
	b.tube(Vector3(0, 0.215, 0), Vector3(0, 0.226, 0), 0.013, 0.013, 12, P, 0.0, body, false)
	b.tube(Vector3(0, 0.226, 0), Vector3(0, 0.244, 0), 0.0155, 0.0155, 12, P, 0.0, cap)
	b.tube(Vector3(0, 0.07, 0), Vector3(0, 0.125, 0), 0.0358, 0.0358, 14, P, 0.0, label, false)


static func _glass_bottle(b: MeshBuf, glass: Color) -> void:
	b.tube(Vector3(0, 0, 0), Vector3(0, 0.2, 0), 0.036, 0.036, 14, P, 0.0, glass)
	b.tube(Vector3(0, 0.2, 0), Vector3(0, 0.245, 0), 0.036, 0.013, 14, P, 0.0, glass, false)
	b.tube(Vector3(0, 0.245, 0), Vector3(0, 0.3, 0), 0.013, 0.012, 12, P, 0.0, glass, false)
	b.tube(Vector3(0, 0.3, 0), Vector3(0, 0.308, 0), 0.0145, 0.0145, 12, S, 0.0, Color(0.8, 0.7, 0.3, 1.0))


## Pilha de pano dobrado (roupas, lona, toalhas).
static func _folded(f: MeshBuf, size: Vector3, col: Color, layers: int) -> void:
	var FAB := _fab(Assets.L_FABRIC)
	for i in layers:
		var s := Vector3(size.x * (1.0 - i * 0.08), size.y, size.z * (1.0 - i * 0.1))
		f.box_xf(Transform3D(Basis(Vector3.UP, (i % 2) * 0.12 - 0.05), Vector3(i * 0.008, size.y * (i + 0.5), i * 0.006)), s, FAB, float(i) * 0.3,
			col.darkened(0.05 * i))
	# dobra arredondada na frente
	f.tube(Vector3(-size.x * 0.48, size.y * layers * 0.5, -size.z * 0.5), Vector3(size.x * 0.48, size.y * layers * 0.5, -size.z * 0.5),
		size.y * layers * 0.5, size.y * layers * 0.5, 8, FAB, 0.0, col.darkened(0.08))


static func _gear(b: MeshBuf, c: Vector3, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	var teeth := 10
	for i in teeth * 2:
		var a0 := TAU * float(i) / float(teeth * 2)
		var rr := r if i % 2 == 0 else r * 0.8
		pts.append(Vector2(cos(a0 - 0.08), sin(a0 - 0.08)) * rr)
		pts.append(Vector2(cos(a0 + 0.08), sin(a0 + 0.08)) * rr)
	b.extrude(pts, -0.008, 0.008, Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), c), S, 0.0, col)
	b.tube(c + Vector3(0, 0.008, 0), c + Vector3(0, 0.02, 0), r * 0.3, r * 0.3, 10, S, 0.0, col)
