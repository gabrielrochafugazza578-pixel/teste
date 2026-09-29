class_name WeaponMeshes
extends RefCounted
## Malhas procedurais das armas e ferramentas empunháveis, com o atlas de
## materiais das armas (weapon.gdshader): nogueira, aço, polímero, borracha.
##
## Convenções (iguais às de antes, usadas pelo encaixe na mão):
##   armas brancas/ferramentas: cabo na origem, arma ao longo de +Y
##   armas de fogo: empunhadura na origem (vertical), cano apontando para -Z
## Espessura sempre no eixo X. `pickup_mesh()` deita a mesma malha no chão.

const W := 0.0   # nogueira / madeira
const S := 1.0   # aço (a tinta vira latão, alumínio, oxidado…)
const P := 2.0   # polímero
const R := 3.0   # borracha / couro quadriculado

# tintas (alfa >= 0,5 permite metal; < 0,5 = pintado/fosco)
const STEEL := Color(1.0, 1.0, 1.02, 1.0)
const BLUED := Color(0.34, 0.36, 0.41, 1.0)
const BLACK_STEEL := Color(0.2, 0.2, 0.22, 1.0)
const ALU := Color(1.2, 1.22, 1.28, 1.0)
const BRASS := Color(1.3, 1.0, 0.45, 1.0)
const RUSTY := Color(0.78, 0.55, 0.42, 1.0)
const WALNUT := Color(1.0, 1.0, 1.0, 0.3)
const LIGHT_WOOD := Color(1.6, 1.42, 1.15, 0.3)
const HANDLE_WOOD := Color(1.25, 1.1, 0.95, 0.3)
const POLY := Color(0.85, 0.85, 0.85, 0.3)
const RUBBER := Color(1.0, 1.0, 1.0, 0.3)

const FIREARMS := ["revolver", "pistola_9mm", "pistola_compacta", "submetralhadora", "espingarda_12", "espingarda_dupla",
	"carabina_22", "rifle_caca", "fuzil_policia", "besta"]


static func mesh(id: String) -> Mesh:
	return Assets.cached_mesh("weapon_" + id, func() -> Mesh:
		var b := MeshBuf.new()
		_build(id, b)
		return b.to_mesh(Assets.weapon_material()))


## Armas longas seguradas com as duas mãos (coronha no ombro).
const LONG_GUNS := ["submetralhadora", "espingarda_12", "espingarda_dupla", "carabina_22", "rifle_caca", "fuzil_policia", "besta"]


static func is_long_gun(id: String) -> bool:
	return id in LONG_GUNS


static func has_model(id: String) -> bool:
	return ItemDB.is_weapon(id) or ItemDB.get_item(id).has("ranged") or id in ["chave_fenda", "chave_inglesa", "martelo", "pa", "lanterna"]


## A mesma arma deitada no chão (origem no chão, centrada), para itens soltos.
static func pickup_mesh(id: String) -> Mesh:
	return Assets.cached_mesh("weapon_floor_" + id, func() -> Mesh:
		var src := MeshBuf.new()
		_build(id, src)
		var rot := Basis(Vector3.BACK, PI * 0.5)
		var lo := Vector3(INF, INF, INF)
		var hi := -lo
		for v in src.verts:
			var w := rot * v
			lo = lo.min(w)
			hi = hi.max(w)
		var c := (lo + hi) * 0.5
		var out := MeshBuf.new()
		out.append(src, Transform3D(rot, Vector3(-c.x, -lo.y + 0.003, -c.z)))
		return out.to_mesh(Assets.item_material()))


# ---------------------------------------------------------------------------
# Auxiliares
# ---------------------------------------------------------------------------
## Perfil no plano ZY ([z, y, z, y, ...]) extrudado na espessura (eixo X).
static func _prof(b: MeshBuf, pts: Array, thick: float, code: float, col: Color, off: Vector3 = Vector3.ZERO) -> void:
	var poly := PackedVector2Array()
	for i in range(0, pts.size(), 2):
		poly.append(Vector2(pts[i], pts[i + 1]))
	var xf := Transform3D(Basis(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0)), off)
	b.extrude(poly, -thick * 0.5, thick * 0.5, xf, code, 0.0, col)


## Perfil no plano XY extrudado em Z (peças vistas de frente, ex.: guarda).
static func _prof_z(b: MeshBuf, pts: Array, z0: float, z1: float, code: float, col: Color, off: Vector3 = Vector3.ZERO) -> void:
	var poly := PackedVector2Array()
	for i in range(0, pts.size(), 2):
		poly.append(Vector2(pts[i], pts[i + 1]))
	b.extrude(poly, z0, z1, Transform3D(Basis.IDENTITY, off), code, 0.0, col)


static func _tube(b: MeshBuf, a: Vector3, e: Vector3, r0: float, r1: float, code: float, col: Color, sides: int = 12) -> void:
	b.tube(a, e, r0, r1, sides, code, 0.0, col)


## Anel (toro grosseiro) no plano perpendicular a `axis`.
static func _ring(b: MeshBuf, c: Vector3, axis: Vector3, radius: float, t: float, code: float, col: Color, segs: int = 12) -> void:
	var u := axis.cross(Vector3.UP if absf(axis.y) < 0.9 else Vector3.RIGHT).normalized()
	var v := axis.cross(u).normalized()
	for i in segs:
		var a0 := TAU * float(i) / segs
		var a1 := TAU * float(i + 1) / segs
		b.tube(c + (u * cos(a0) + v * sin(a0)) * radius, c + (u * cos(a1) + v * sin(a1)) * radius, t, t, 6, code, 0.0, col)


## Cabo reto (tubo levemente afunilado) de y0 a y1.
static func _handle(b: MeshBuf, y0: float, y1: float, r0: float, r1: float, code: float, col: Color) -> void:
	_tube(b, Vector3(0, y0, 0), Vector3(0, y1, 0), r0, r1, code, col, 12)


## Lâmina: perfil [z, y...] fino com gume (duas faces levemente inclinadas).
static func _blade(b: MeshBuf, pts: Array, thick: float, col: Color = STEEL) -> void:
	_prof(b, pts, thick, S, col)


## Rebites/parafusos na lateral do cabo.
static func _rivets(b: MeshBuf, ys: Array, z: float, half_w: float, col: Color = STEEL) -> void:
	for y in ys:
		for sx: float in [-1.0, 1.0]:
			_tube(b, Vector3(sx * half_w, y, z), Vector3(sx * (half_w + 0.002), y, z), 0.0045, 0.0045, S, col, 8)


# ---------------------------------------------------------------------------
static func _build(id: String, b: MeshBuf) -> void:
	match id:
		# ================= armas brancas =================
		"faca_cozinha":
			_prof(b, [-0.012, -0.05, 0.012, -0.05, 0.013, 0.06, -0.011, 0.06], 0.02, W, HANDLE_WOOD)
			_rivets(b, [-0.02, 0.03], 0.0, 0.01)
			_prof(b, [-0.013, 0.058, 0.014, 0.058, 0.014, 0.066, -0.013, 0.066], 0.022, S, STEEL)
			_blade(b, [-0.012, 0.066, 0.012, 0.066, 0.014, 0.14, 0.008, 0.24, -0.002, 0.28, -0.013, 0.2], 0.0025)
		"faca_tatica":
			_prof(b, [-0.013, -0.055, 0.013, -0.055, 0.016, 0.0, 0.013, 0.055, -0.013, 0.055, -0.016, 0.0], 0.024, R, RUBBER)
			_prof(b, [-0.03, 0.055, 0.03, 0.055, 0.032, 0.065, -0.032, 0.065], 0.026, S, BLACK_STEEL)
			_blade(b, [-0.014, 0.065, 0.013, 0.065, 0.014, 0.17, 0.004, 0.25, -0.004, 0.22, -0.014, 0.19], 0.004, BLUED)
			_tube(b, Vector3(0, -0.06, 0), Vector3(0, -0.055, 0), 0.012, 0.012, S, BLACK_STEEL)
		"canivete":
			_prof(b, [-0.009, -0.04, 0.009, -0.04, 0.011, 0.045, -0.009, 0.05], 0.016, W, HANDLE_WOOD)
			_prof(b, [-0.009, -0.042, 0.009, -0.042, 0.011, 0.047, -0.009, 0.052], 0.017, S, STEEL, Vector3(0, 0, 0))
			_blade(b, [-0.008, 0.048, 0.008, 0.05, 0.009, 0.1, 0.0, 0.13, -0.008, 0.095], 0.0022)
		"cutelo":
			_handle(b, -0.06, 0.05, 0.012, 0.013, W, HANDLE_WOOD)
			_rivets(b, [-0.03, 0.0, 0.03], 0.0, 0.012)
			_blade(b, [-0.012, 0.05, 0.075, 0.05, 0.085, 0.07, 0.085, 0.22, -0.012, 0.23], 0.004)
			_tube(b, Vector3(-0.004, 0.2, 0.06), Vector3(0.004, 0.2, 0.06), 0.009, 0.009, S, Color(0.1, 0.1, 0.1, 0.3), 10)
		"facao":
			_prof(b, [-0.013, -0.06, 0.014, -0.06, 0.016, 0.07, -0.012, 0.07], 0.024, W, HANDLE_WOOD)
			_rivets(b, [-0.03, 0.0, 0.04], 0.0, 0.012)
			_blade(b, [-0.012, 0.07, 0.016, 0.07, 0.03, 0.35, 0.028, 0.5, 0.012, 0.56, -0.004, 0.5, -0.012, 0.3], 0.003)
		"katana":
			_prof(b, [-0.015, -0.14, 0.015, -0.14, 0.016, 0.12, -0.016, 0.12], 0.027, R, Color(0.25, 0.22, 0.3, 0.3))
			for i in 7:
				var y := -0.12 + i * 0.037
				_prof(b, [-0.017, y, 0.017, y + 0.012, 0.017, y + 0.016, -0.017, y + 0.004], 0.029, R, Color(0.75, 0.7, 0.6, 0.3))
			_tube(b, Vector3(0, 0.12, 0), Vector3(0, 0.128, 0), 0.042, 0.042, S, BLACK_STEEL, 16)
			_tube(b, Vector3(0, 0.128, 0), Vector3(0, 0.155, 0), 0.017, 0.015, S, BRASS, 10)
			var pts := []
			var back := []
			for i in 11:
				var t := float(i) / 10.0
				var y := 0.155 + t * 0.68
				var curve := t * t * 0.025
				pts.append_array([0.014 + curve - t * 0.004, y])
				back.push_front([-0.012 + curve, y])
			pts.append_array([0.028, 0.86])
			for p in back:
				pts.append_array(p)
			_blade(b, pts, 0.005)
		"machado", "machadinha":
			var small := id == "machadinha"
			var L := 0.4 if small else 0.78
			_handle(b, -0.1, L, 0.016 if small else 0.019, 0.014 if small else 0.017, W, LIGHT_WOOD)
			var sc := 0.75 if small else 1.0
			_prof(b, [-0.03 * sc, L - 0.07 * sc, 0.02 * sc, L - 0.06 * sc, 0.14 * sc, L - 0.11 * sc, 0.155 * sc, L + 0.02 * sc,
				0.14 * sc, L + 0.09 * sc, 0.02 * sc, L + 0.05 * sc, -0.03 * sc, L + 0.05 * sc], 0.028 * sc, S, BLUED)
			_prof(b, [0.13 * sc, L - 0.1 * sc, 0.156 * sc, L - 0.1 * sc, 0.16 * sc, L + 0.08 * sc, 0.135 * sc, L + 0.085 * sc], 0.012 * sc, S, STEEL)
		"marreta":
			_handle(b, -0.12, 0.72, 0.02, 0.019, W, LIGHT_WOOD)
			_tube(b, Vector3(0, 0.76, -0.1), Vector3(0, 0.76, 0.1), 0.045, 0.045, S, BLACK_STEEL, 12)
			_tube(b, Vector3(0, 0.76, -0.105), Vector3(0, 0.76, -0.1), 0.04, 0.045, S, STEEL, 12)
			_tube(b, Vector3(0, 0.76, 0.1), Vector3(0, 0.76, 0.105), 0.045, 0.04, S, STEEL, 12)
		"picareta":
			_handle(b, -0.12, 0.8, 0.02, 0.019, W, LIGHT_WOOD)
			_prof(b, [-0.3, 0.81, -0.15, 0.845, 0.0, 0.86, 0.15, 0.845, 0.28, 0.8, 0.27, 0.79, 0.15, 0.815, 0.0, 0.825, -0.15, 0.815, -0.29, 0.8], 0.03, S, RUSTY)
			_tube(b, Vector3(0, 0.79, 0), Vector3(0, 0.88, 0), 0.028, 0.028, S, BLACK_STEEL, 10)
		"pe_de_cabra":
			var red := Color(1.2, 0.2, 0.14, 0.3)
			_tube(b, Vector3(0, -0.12, 0.0), Vector3(0, 0.5, 0.0), 0.012, 0.012, S, red, 8)
			_tube(b, Vector3(0, 0.5, 0.0), Vector3(0, 0.56, 0.025), 0.012, 0.012, S, red, 8)
			_tube(b, Vector3(0, 0.56, 0.025), Vector3(0, 0.575, 0.06), 0.012, 0.009, S, red, 8)
			_prof(b, [-0.006, -0.12, 0.006, -0.12, 0.03, -0.16, 0.025, -0.17, 0.0, -0.14], 0.02, S, STEEL)
		"martelo":
			_handle(b, -0.08, 0.26, 0.015, 0.013, W, HANDLE_WOOD)
			_tube(b, Vector3(0, 0.285, -0.02), Vector3(0, 0.285, 0.055), 0.016, 0.016, S, BLUED, 10)
			_prof(b, [-0.02, 0.27, -0.02, 0.3, -0.07, 0.31, -0.095, 0.29, -0.06, 0.285], 0.022, S, BLUED)
		"pa":
			_handle(b, -0.12, 0.88, 0.018, 0.017, W, LIGHT_WOOD)
			_tube(b, Vector3(-0.05, -0.15, 0), Vector3(0.05, -0.15, 0), 0.012, 0.012, P, POLY, 8)
			_prof(b, [-0.02, 0.88, 0.02, 0.88, 0.03, 0.95, 0.11, 0.97, 0.12, 1.2, 0.0, 1.27, -0.12, 1.2, -0.11, 0.97, -0.03, 0.95], 0.01, S, Color(0.55, 0.57, 0.6, 1.0))
		"enxada":
			_handle(b, -0.12, 1.25, 0.018, 0.017, W, LIGHT_WOOD)
			b.box_xf(Transform3D(Basis(Vector3.RIGHT, 0.35), Vector3(0, 1.2, 0.1)), Vector3(0.23, 0.006, 0.17), S, 0.0, RUSTY)
			_tube(b, Vector3(0, 1.24, -0.01), Vector3(0, 1.24, 0.03), 0.022, 0.022, S, BLACK_STEEL, 8)
		"foice":
			_handle(b, -0.1, 0.25, 0.015, 0.014, W, HANDLE_WOOD)
			var cres := []
			var inner := []
			for i in 13:
				var a := lerpf(-0.2, PI * 0.95, float(i) / 12.0)
				cres.append_array([cos(a) * 0.16 - 0.16, 0.25 + sin(a) * 0.2 + 0.02])
				inner.push_front([cos(a) * 0.13 - 0.14, 0.25 + sin(a) * 0.15 + 0.02])
			for p in inner:
				cres.append_array(p)
			_blade(b, cres, 0.0025, RUSTY)
		"lanca":
			_handle(b, -0.42, 1.25, 0.017, 0.015, W, LIGHT_WOOD)
			_tube(b, Vector3(0, 1.12, 0), Vector3(0, 1.24, 0), 0.02, 0.02, R, Color(0.6, 0.6, 0.62, 0.3), 10)
			_blade(b, [-0.014, 1.22, 0.014, 1.22, 0.012, 1.34, 0.0, 1.42, -0.012, 1.34], 0.003)
		"cassetete":
			_handle(b, -0.1, 0.52, 0.018, 0.018, P, POLY)
			_tube(b, Vector3(0, 0.02, 0), Vector3(0, 0.02, 0.12), 0.013, 0.013, P, POLY, 10)
			_tube(b, Vector3(0, 0.02, 0.12), Vector3(0, -0.02, 0.12), 0.016, 0.016, P, POLY, 10)
		"bastao_retratil":
			_tube(b, Vector3(0, -0.1, 0), Vector3(0, 0.08, 0), 0.016, 0.016, R, RUBBER, 12)
			_tube(b, Vector3(0, 0.08, 0), Vector3(0, 0.26, 0), 0.012, 0.012, S, BLACK_STEEL, 10)
			_tube(b, Vector3(0, 0.26, 0), Vector3(0, 0.43, 0), 0.009, 0.009, S, BLACK_STEEL, 10)
			_tube(b, Vector3(0, 0.43, 0), Vector3(0, 0.46, 0), 0.013, 0.012, S, STEEL, 10)
		"taco_beisebol", "taco_pregos":
			_tube(b, Vector3(0, -0.14, 0), Vector3(0, -0.12, 0), 0.028, 0.02, W, LIGHT_WOOD, 12)
			_tube(b, Vector3(0, -0.12, 0), Vector3(0, 0.25, 0), 0.016, 0.022, W, LIGHT_WOOD, 12)
			_tube(b, Vector3(0, 0.25, 0), Vector3(0, 0.72, 0), 0.022, 0.034, W, LIGHT_WOOD, 12)
			_tube(b, Vector3(0, 0.72, 0), Vector3(0, 0.76, 0), 0.034, 0.026, W, LIGHT_WOOD, 12)
			_tube(b, Vector3(0, -0.1, 0), Vector3(0, 0.08, 0), 0.0175, 0.0185, R, RUBBER, 12)
			if id == "taco_pregos":
				for i in 12:
					var a := i * 2.4
					var y := 0.45 + (i % 6) * 0.045
					var d := Vector3(cos(a), 0, sin(a))
					_tube(b, Vector3(0, y, 0) + d * 0.02, Vector3(0, y, 0) + d * 0.07, 0.0025, 0.0015, S, RUSTY, 5)
		"bastao_aluminio":
			_tube(b, Vector3(0, -0.13, 0), Vector3(0, -0.11, 0), 0.027, 0.019, S, ALU, 14)
			_tube(b, Vector3(0, -0.11, 0), Vector3(0, 0.25, 0), 0.015, 0.02, S, ALU, 14)
			_tube(b, Vector3(0, 0.25, 0), Vector3(0, 0.74, 0), 0.02, 0.031, S, ALU, 14)
			_tube(b, Vector3(0, -0.1, 0), Vector3(0, 0.12, 0), 0.0175, 0.019, R, Color(0.9, 0.25, 0.2, 0.3), 12)
		"taco_golfe":
			_tube(b, Vector3(0, -0.12, 0), Vector3(0, 0.14, 0), 0.015, 0.012, R, RUBBER, 10)
			_tube(b, Vector3(0, 0.14, 0), Vector3(0, 0.9, 0), 0.0065, 0.005, S, STEEL, 8)
			_prof(b, [-0.02, 0.88, 0.02, 0.88, 0.09, 0.9, 0.1, 0.94, 0.02, 0.94, -0.02, 0.92], 0.028, S, BLUED)
		"chave_roda":
			_tube(b, Vector3(0, -0.2, 0), Vector3(0, 0.2, 0), 0.011, 0.011, S, BLACK_STEEL, 8)
			_tube(b, Vector3(0, 0.0, -0.2), Vector3(0, 0.0, 0.2), 0.011, 0.011, S, BLACK_STEEL, 8)
			for e in [Vector3(0, 0.2, 0), Vector3(0, -0.2, 0), Vector3(0, 0, 0.2), Vector3(0, 0, -0.2)]:
				var dd := (e as Vector3).normalized()
				_tube(b, e, e + dd * 0.035, 0.016, 0.016, S, STEEL, 8)
		"soco_ingles":
			for i in 4:
				_ring(b, Vector3(0, -0.035 + i * 0.024, -0.012), Vector3.RIGHT, 0.012, 0.0045, S, BRASS, 10)
			_prof(b, [0.0, -0.05, 0.012, -0.05, 0.03, -0.03, 0.03, 0.04, 0.012, 0.06, 0.0, 0.06, 0.012, 0.03, 0.012, -0.02], 0.012, S, BRASS)
		"cano_ferro":
			_tube(b, Vector3(0, -0.12, 0), Vector3(0, 0.74, 0), 0.021, 0.021, S, RUSTY, 12)
			_tube(b, Vector3(0, 0.7, 0), Vector3(0, 0.76, 0), 0.026, 0.026, S, Color(0.5, 0.45, 0.4, 1.0), 12)
		"chave_fenda":
			_tube(b, Vector3(0, -0.06, 0), Vector3(0, 0.05, 0), 0.016, 0.013, P, Color(2.2, 1.6, 0.3, 0.3), 10)
			_tube(b, Vector3(0, 0.05, 0), Vector3(0, 0.19, 0), 0.0035, 0.0035, S, STEEL, 6)
			_prof(b, [-0.004, 0.19, 0.004, 0.19, 0.002, 0.2, -0.002, 0.2], 0.002, S, STEEL)
		"chave_inglesa":
			_prof(b, [-0.012, -0.06, 0.012, -0.06, 0.012, 0.2, -0.012, 0.2], 0.012, S, STEEL)
			_prof(b, [-0.03, 0.2, 0.035, 0.2, 0.035, 0.24, 0.012, 0.24, 0.012, 0.225, -0.012, 0.225, -0.012, 0.26, -0.03, 0.26], 0.016, S, STEEL)
		"lanterna":
			_tube(b, Vector3(0, -0.08, 0), Vector3(0, 0.08, 0), 0.016, 0.016, S, BLACK_STEEL, 12)
			_tube(b, Vector3(0, 0.08, 0), Vector3(0, 0.12, 0), 0.016, 0.024, S, BLACK_STEEL, 12)
		# ================= armas de fogo =================
		"revolver":
			_prof(b, [-0.012, -0.05, 0.018, -0.05, 0.022, 0.0, 0.016, 0.05, -0.012, 0.05, -0.02, 0.0], 0.03, W, WALNUT)
			_prof(b, [-0.018, 0.045, 0.02, 0.045, 0.02, 0.095, -0.03, 0.1, -0.06, 0.085, -0.06, 0.055, -0.03, 0.045], 0.026, S, BLUED)
			_tube(b, Vector3(0, 0.07, -0.005), Vector3(0, 0.07, -0.05), 0.02, 0.02, S, BLUED, 12)
			_tube(b, Vector3(0, 0.084, -0.05), Vector3(0, 0.084, -0.16), 0.008, 0.008, S, BLUED, 10)
			_prof(b, [-0.05, 0.075, -0.16, 0.075, -0.16, 0.095, -0.05, 0.095], 0.01, S, BLUED)
			_prof(b, [-0.15, 0.094, -0.14, 0.094, -0.145, 0.104], 0.004, S, BLUED)
			_prof(b, [0.0, 0.095, 0.012, 0.095, 0.03, 0.115, 0.02, 0.118], 0.006, S, BLUED)
			_ring(b, Vector3(0, 0.04, -0.018), Vector3.RIGHT, 0.017, 0.003, S, BLUED, 10)
			_prof(b, [-0.02, 0.035, -0.014, 0.04, -0.014, 0.05, -0.02, 0.05], 0.004, S, STEEL)
		"pistola_9mm", "pistola_compacta":
			var c := 0.8 if id == "pistola_compacta" else 1.0
			var frame := P if id == "pistola_9mm" else S
			var fcol := POLY if id == "pistola_9mm" else BLACK_STEEL
			_prof(b, [-0.016 * c, -0.055 * c, 0.02 * c, -0.055 * c, 0.028 * c, 0.05 * c, -0.012 * c, 0.05 * c], 0.029 * c, R if id == "pistola_9mm" else W, RUBBER if id == "pistola_9mm" else WALNUT)
			_prof(b, [-0.02 * c, 0.045 * c, 0.028 * c, 0.045 * c, 0.03 * c, 0.075 * c, -0.16 * c, 0.075 * c, -0.16 * c, 0.058 * c, -0.05 * c, 0.058 * c, -0.03 * c, 0.045 * c], 0.027 * c, frame, fcol)
			_ring(b, Vector3(0, 0.042 * c, -0.022 * c), Vector3.RIGHT, 0.016 * c, 0.0035, frame, fcol, 10)
			_prof(b, [0.035 * c, 0.073 * c, -0.165 * c, 0.073 * c, -0.165 * c, 0.105 * c, 0.035 * c, 0.105 * c], 0.026 * c, S, BLUED)
			for i in 6:
				var z := (0.028 - i * 0.006) * c
				_prof(b, [z, 0.078 * c, z - 0.002, 0.078 * c, z - 0.002, 0.102 * c, z, 0.102 * c], 0.0265 * c, S, BLACK_STEEL)
			_tube(b, Vector3(0, 0.09 * c, -0.165 * c), Vector3(0, 0.09 * c, -0.168 * c), 0.006 * c, 0.006 * c, S, BLACK_STEEL, 8)
			_prof(b, [-0.155 * c, 0.105 * c, -0.145 * c, 0.105 * c, -0.148 * c, 0.113 * c], 0.004, S, BLACK_STEEL)
			_prof(b, [0.02 * c, 0.105 * c, 0.03 * c, 0.105 * c, 0.03 * c, 0.113 * c, 0.02 * c, 0.113 * c], 0.016 * c, S, BLACK_STEEL)
			_prof(b, [-0.018 * c, 0.035 * c, -0.012 * c, 0.04 * c, -0.012 * c, 0.055 * c, -0.018 * c, 0.05 * c], 0.004, S, BLACK_STEEL)
			_prof(b, [-0.018 * c, -0.056 * c, 0.022 * c, -0.056 * c, 0.022 * c, -0.064 * c, -0.018 * c, -0.064 * c], 0.024 * c, S, BLACK_STEEL)
		"submetralhadora":
			_prof(b, [-0.018, -0.07, 0.02, -0.07, 0.026, 0.05, -0.012, 0.05], 0.03, R, RUBBER)
			_prof(b, [0.12, 0.05, -0.2, 0.05, -0.2, 0.12, 0.12, 0.12], 0.036, S, BLACK_STEEL)
			_tube(b, Vector3(0, 0.09, -0.2), Vector3(0, 0.09, -0.3), 0.011, 0.011, S, BLACK_STEEL, 10)
			_prof(b, [-0.08, 0.05, -0.105, 0.05, -0.115, -0.13, -0.09, -0.13], 0.024, S, BLACK_STEEL)
			_prof(b, [-0.15, 0.05, -0.13, 0.05, -0.13, -0.03, -0.15, -0.03], 0.024, P, POLY)
			_tube(b, Vector3(-0.012, 0.1, 0.12), Vector3(-0.012, 0.1, 0.36), 0.006, 0.006, S, BLACK_STEEL, 8)
			_tube(b, Vector3(0.012, 0.1, 0.12), Vector3(0.012, 0.1, 0.36), 0.006, 0.006, S, BLACK_STEEL, 8)
			_prof(b, [0.34, 0.02, 0.37, 0.02, 0.37, 0.12, 0.34, 0.12], 0.036, P, POLY)
			_ring(b, Vector3(0, 0.04, -0.03), Vector3.RIGHT, 0.017, 0.003, S, BLACK_STEEL, 10)
			_prof(b, [-0.18, 0.12, -0.17, 0.12, -0.17, 0.14, -0.18, 0.14], 0.012, S, BLACK_STEEL)
		"espingarda_12", "espingarda_dupla":
			var dbl := id == "espingarda_dupla"
			_prof(b, [0.35, -0.1, 0.1, -0.02, 0.03, -0.045, -0.015, -0.03, 0.0, 0.05, 0.06, 0.07, 0.35, 0.055, 0.36, -0.1], 0.04, W, WALNUT)
			_tube(b, Vector3(0, -0.02, 0.36), Vector3(0, -0.02, 0.37), 0.02, 0.02, R, RUBBER, 8)
			_prof(b, [0.0, 0.03, 0.06, 0.07, -0.15 if not dbl else -0.08, 0.07, -0.15 if not dbl else -0.08, 0.03], 0.038, S, BLUED)
			if dbl:
				for sx: float in [-0.011, 0.011]:
					_tube(b, Vector3(sx, 0.058, -0.08), Vector3(sx, 0.058, -0.66), 0.012, 0.011, S, BLUED, 10)
				_prof(b, [-0.08, 0.035, -0.35, 0.04, -0.35, 0.05, -0.08, 0.05], 0.03, W, WALNUT)
			else:
				_tube(b, Vector3(0, 0.062, -0.15), Vector3(0, 0.062, -0.72), 0.011, 0.011, S, BLUED, 10)
				_tube(b, Vector3(0, 0.038, -0.15), Vector3(0, 0.038, -0.62), 0.01, 0.01, S, BLUED, 10)
				_tube(b, Vector3(0, 0.04, -0.3), Vector3(0, 0.04, -0.47), 0.02, 0.02, W, WALNUT, 12)
			_ring(b, Vector3(0, 0.02, 0.02), Vector3.RIGHT, 0.018, 0.0035, S, BLUED, 10)
			_prof(b, [-0.7 if not dbl else -0.65, 0.074, -0.69 if not dbl else -0.64, 0.074, -0.695 if not dbl else -0.645, 0.082], 0.004, S, BRASS)
		"carabina_22", "rifle_caca":
			var big := id == "rifle_caca"
			var L := 0.72 if big else 0.6
			_prof(b, [0.43, 0.05, 0.43, -0.11, 0.14, -0.035, 0.07, -0.075, 0.03, -0.05, 0.0, 0.02, -0.34, 0.025, -0.36, 0.045, -0.34, 0.06, 0.05, 0.058, 0.14, 0.05], 0.04, W, WALNUT)
			if big:
				_prof(b, [0.14, 0.05, 0.36, 0.06, 0.36, 0.075, 0.18, 0.07], 0.02, W, WALNUT)
			_tube(b, Vector3(0, 0.068, 0.08), Vector3(0, 0.068, -0.14), 0.014, 0.014, S, BLUED, 12)
			_tube(b, Vector3(0, 0.068, -0.14), Vector3(0, 0.068, -L), 0.009, 0.007, S, BLUED, 10)
			_tube(b, Vector3(0, 0.07, 0.03), Vector3(0.045, 0.06, 0.035), 0.004, 0.004, S, STEEL, 6)
			_tube(b, Vector3(0.047, 0.06, 0.035), Vector3(0.05, 0.06, 0.035), 0.008, 0.008, S, STEEL, 8)
			_ring(b, Vector3(0, 0.015, -0.005), Vector3.RIGHT, 0.017, 0.003, S, BLUED, 10)
			if big:
				_tube(b, Vector3(0, 0.12, 0.09), Vector3(0, 0.12, 0.05), 0.02, 0.013, S, BLACK_STEEL, 14)
				_tube(b, Vector3(0, 0.12, 0.05), Vector3(0, 0.12, -0.12), 0.013, 0.013, S, BLACK_STEEL, 14)
				_tube(b, Vector3(0, 0.12, -0.12), Vector3(0, 0.12, -0.2), 0.013, 0.024, S, BLACK_STEEL, 14)
				_tube(b, Vector3(0, 0.12, -0.2), Vector3(0, 0.12, -0.205), 0.024, 0.024, S, Color(0.2, 0.3, 0.5, 1.0), 14)
				for z in [0.02, -0.09]:
					_prof(b, [z - 0.01, 0.078, z + 0.01, 0.078, z + 0.01, 0.108, z - 0.01, 0.108], 0.012, S, BLACK_STEEL)
				_tube(b, Vector3(-0.016, 0.12, -0.03), Vector3(0.016, 0.12, -0.03), 0.006, 0.006, S, BLACK_STEEL, 8)
			else:
				_prof(b, [-L + 0.01, 0.075, -L + 0.02, 0.075, -L + 0.015, 0.086], 0.004, S, BLUED)
		"fuzil_policia":
			_prof(b, [-0.018, -0.065, 0.022, -0.065, 0.03, 0.04, -0.01, 0.04], 0.03, R, RUBBER)
			_prof(b, [0.05, 0.03, -0.16, 0.03, -0.16, 0.075, 0.05, 0.075], 0.034, S, BLACK_STEEL)
			_prof(b, [0.05, 0.075, -0.16, 0.075, -0.16, 0.1, 0.05, 0.1], 0.03, S, BLACK_STEEL)
			_tube(b, Vector3(0, 0.08, -0.16), Vector3(0, 0.08, -0.42), 0.022, 0.022, P, POLY, 12)
			_tube(b, Vector3(0, 0.08, -0.42), Vector3(0, 0.08, -0.52), 0.007, 0.007, S, BLACK_STEEL, 10)
			_tube(b, Vector3(0, 0.08, -0.52), Vector3(0, 0.08, -0.57), 0.01, 0.01, S, BLACK_STEEL, 8)
			_prof(b, [-0.045, 0.03, -0.085, 0.03, -0.11, -0.1, -0.1, -0.16, -0.065, -0.16, -0.06, -0.1], 0.024, S, BLACK_STEEL)
			_prof(b, [0.05, 0.035, 0.3, 0.02, 0.32, 0.03, 0.32, 0.1, 0.3, 0.1, 0.05, 0.085], 0.034, P, POLY)
			_prof(b, [-0.41, 0.1, -0.39, 0.1, -0.395, 0.135, -0.405, 0.135], 0.012, S, BLACK_STEEL)
			_prof(b, [0.02, 0.1, 0.04, 0.1, 0.035, 0.125, 0.025, 0.125], 0.018, S, BLACK_STEEL)
			_ring(b, Vector3(0, 0.02, -0.022), Vector3.RIGHT, 0.016, 0.0035, S, BLACK_STEEL, 10)
		"besta":
			_prof(b, [0.3, -0.07, 0.08, -0.02, 0.02, -0.06, -0.01, -0.03, 0.0, 0.04, -0.45, 0.05, -0.45, 0.075, 0.3, 0.06], 0.036, P, POLY)
			for sx: float in [-1.0, 1.0]:
				_tube(b, Vector3(0, 0.068, -0.44), Vector3(sx * 0.3, 0.07, -0.38), 0.012, 0.007, P, Color(0.5, 0.52, 0.5, 0.3), 8)
				_tube(b, Vector3(sx * 0.3, 0.07, -0.38), Vector3(0, 0.072, -0.04), 0.0012, 0.0012, R, Color(0.9, 0.9, 0.85, 0.3), 4)
			_ring(b, Vector3(0, 0.06, -0.48), Vector3.UP, 0.035, 0.005, S, BLACK_STEEL, 10)
			_ring(b, Vector3(0, 0.015, -0.005), Vector3.RIGHT, 0.017, 0.003, S, BLACK_STEEL, 10)
		"arco":
			for i in 8:
				var t0 := float(i) / 8.0
				var t1 := float(i + 1) / 8.0
				var p0 := Vector3(0, lerpf(-0.6, 0.6, t0), -sin(t0 * PI) * 0.14)
				var p1 := Vector3(0, lerpf(-0.6, 0.6, t1), -sin(t1 * PI) * 0.14)
				var r0 := lerpf(0.009, 0.016, sin(t0 * PI))
				var r1 := lerpf(0.009, 0.016, sin(t1 * PI))
				_tube(b, p0, p1, r0, r1, W, LIGHT_WOOD, 8)
			_tube(b, Vector3(0, -0.07, -0.14), Vector3(0, 0.07, -0.14), 0.019, 0.019, R, RUBBER, 10)
			_tube(b, Vector3(0, -0.6, 0), Vector3(0, 0.6, 0), 0.0012, 0.0012, R, Color(0.9, 0.9, 0.85, 0.3), 4)
		_:
			_tube(b, Vector3(0, -0.05, 0), Vector3(0, 0.4, 0), 0.015, 0.015, S, STEEL, 8)

