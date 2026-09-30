class_name HumanoidDetails
extends RefCounted
## Detalhes de roupa e equipamento colados à malha base do HumanoidMeshBuilder:
## zíper, plaquetas, bolsos, abas, botões, costuras, barras, cinto, mochila com
## tiras e fivelas. Tudo é geometria fina (retalhos e fitas) levantada milímetros
## da superfície do tronco, com os mesmos pesos de osso do anel onde nasce — então
## acompanha a animação e não custa uma draw call a mais.
##
## Coordenadas: alturas `yy` na escala de referência (adulto de 1,78 m), como na
## tabela de anéis do tronco; larguras/alturas dos retalhos em metros de referência.

var b: HumanoidMeshBuilder


func _init(builder: HumanoidMeshBuilder) -> void:
	b = builder


# ---------------------------------------------------------------------------
# Superfície do tronco
# ---------------------------------------------------------------------------
func _ring_at(yy: float) -> Dictionary:
	var tr: Array = b.tr
	var n := tr.size()
	if yy <= float(tr[0]["yy"]):
		return tr[0]
	if yy >= float(tr[n - 1]["yy"]):
		return tr[n - 1]
	for i in n - 1:
		var r0: Dictionary = tr[i]
		var r1: Dictionary = tr[i + 1]
		if yy <= float(r1["yy"]):
			var f := (yy - float(r0["yy"])) / maxf(float(r1["yy"]) - float(r0["yy"]), 0.0001)
			return {"y": lerpf(float(r0["y"]), float(r1["y"]), f), "rx": lerpf(float(r0["rx"]), float(r1["rx"]), f),
				"rz": lerpf(float(r0["rz"]), float(r1["rz"]), f), "zoff": lerpf(float(r0["zoff"]), float(r1["zoff"]), f),
				"wk": lerpf(float(r0["wk"]), float(r1["wk"]), f), "dip": lerpf(float(r0["dip"]), float(r1["dip"]), f)}
	return tr[n - 1]


## Ponto do tronco na altura yy e ângulo th (frente = PI/2), levantado `lift` m. -> [pos, normal]
func torso_pt(yy: float, th: float, lift: float = 0.0) -> Array:
	var r := _ring_at(yy)
	var ct := cos(th)
	var st := sin(th)
	var rx: float = r["rx"]
	var rz: float = r["rz"]
	var p := Vector3(ct * rx, float(r["y"]), -st * rz + float(r["zoff"]))
	var fem: bool = b.a.get("female", false)
	p.y -= smoothstep(1.36, 1.515, yy) * pow(absf(ct), 1.5) * 0.052 * b.s * (0.85 if fem else 1.0) * float(r["wk"]) + float(r["dip"]) * smoothstep(0.0, 0.85, st)
	p.y += smoothstep(1.44, 1.51, yy) * maxf(0.0, -st) * 0.026 * b.s
	var n := Vector3(ct / maxf(rx, 0.001), 0.0, -st / maxf(rz, 0.001)).normalized()
	return [p + n * lift * b.s, n]


## Pesos de osso do tronco por altura (mesma regra dos anéis).
func torso_w(yy: float) -> Array:
	var w_h := 1.0 - smoothstep(0.98, 1.12, yy)
	var w_c := smoothstep(1.18, 1.3, yy)
	return [HumanoidMeshBuilder.HIPS, w_h, HumanoidMeshBuilder.SPINE, 1.0 - w_h - w_c, HumanoidMeshBuilder.CHEST, w_c]


func _emit(p: Vector3, n: Vector3, tg: Vector3, col: Color, mat: float, yy: float) -> int:
	var w := torso_w(yy)
	return b._v(p, n, tg, Vector3.UP, Vector2(p.x + p.z, p.y) * 3.0, col, mat, w[0], w[1], w[2], w[3], w[4], w[5])


## Fita sobre o tronco: `path` = pontos Vector2(yy, th); `width` em m de referência.
func strip(path: Array, width: float, lift: float, col: Color, mat: float) -> void:
	var cnt := path.size()
	if cnt < 2:
		return
	var pts: Array = []
	var nrm: Array = []
	for q in path:
		var r := torso_pt((q as Vector2).x, (q as Vector2).y, lift)
		pts.append(r[0])
		nrm.append(r[1])
	var left: Array = []
	var right: Array = []
	for i in cnt:
		var a: Vector3 = pts[maxi(i - 1, 0)]
		var c: Vector3 = pts[mini(i + 1, cnt - 1)]
		var tg := (c - a).normalized()
		var sd: Vector3 = tg.cross(nrm[i]).normalized() * width * 0.5 * b.s
		var yy: float = (path[i] as Vector2).x
		left.append(_emit(pts[i] - sd, nrm[i], tg, col, mat, yy))
		right.append(_emit(pts[i] + sd, nrm[i], tg, col, mat, yy))
	for i in cnt - 1:
		b._tri(left[i], right[i], left[i + 1])
		b._tri(right[i], right[i + 1], left[i + 1])


## Retalho retangular colado ao tronco (bolso, aba, etiqueta), centro (yy, th).
## `bulge`: abaulamento no meio (m) para dar volume ao bolso.
func patch(yy: float, th: float, w: float, h: float, lift: float, col: Color, mat: float, bulge: float = 0.0, cols_n: int = 4, rows_n: int = 3) -> void:
	var r := _ring_at(yy)
	var rad := maxf(0.5 * (float(r["rx"]) + float(r["rz"])) / b.s, 0.05)
	var dth := (w * 0.5) / rad
	var grid: Array = []
	for i in rows_n + 1:
		var row: Array = []
		var y_i := yy + h * (float(i) / rows_n - 0.5)
		for k in cols_n + 1:
			var fk := float(k) / cols_n * 2.0 - 1.0
			var fi := float(i) / rows_n * 2.0 - 1.0
			var lf := lift + bulge * (1.0 - fk * fk) * (1.0 - fi * fi)
			var q := torso_pt(y_i, th + dth * fk, lf)
			row.append(_emit(q[0], q[1], Vector3(-sin(th), 0, cos(th)), col, mat, y_i))
		grid.append(row)
	for i in rows_n:
		for k in cols_n:
			b._tri(grid[i][k], grid[i + 1][k], grid[i][k + 1])
			b._tri(grid[i][k + 1], grid[i + 1][k], grid[i + 1][k + 1])


## Região entre duas curvas (esquerda/direita, mesmo número de pontos): peito da camisa
## que aparece na abertura da jaqueta ou do jaleco.
func fill_between(left: Array, right: Array, lift: float, col: Color, mat: float) -> void:
	var cnt := left.size()
	var li: Array = []
	var ri: Array = []
	for i in cnt:
		var ql: Vector2 = left[i]
		var qr: Vector2 = right[i]
		var pl := torso_pt(ql.x, ql.y, lift)
		var pr := torso_pt(qr.x, qr.y, lift)
		li.append(_emit(pl[0], pl[1], Vector3.RIGHT, col, mat, ql.x))
		ri.append(_emit(pr[0], pr[1], Vector3.RIGHT, col, mat, qr.x))
	for i in cnt - 1:
		b._tri(li[i], ri[i], li[i + 1])
		b._tri(ri[i], ri[i + 1], li[i + 1])


## Abertura em V da jaqueta/jaleco mostrando a camisa; `w(yy)` = meia-largura (em cos).
func shirt_v(y0: float, y1: float, wmax: float, shirt: Color, edge: Color) -> void:
	var front := PI * 0.5
	var left: Array = []
	var right: Array = []
	var steps := 10
	for k in steps + 1:
		var f := float(k) / steps
		var yy := lerpf(y0, y1, f)
		var w := wmax * smoothstep(0.0, 1.0, f) * (1.0 - 0.4 * smoothstep(0.8, 1.0, f))
		var ang := asin(clampf(w, 0.0, 0.95))
		left.append(Vector2(yy, front - ang))
		right.append(Vector2(yy, front + ang))
	fill_between(left, right, 0.0016, shirt, HumanoidMeshBuilder.M_CLOTH)
	strip(left, 0.014, 0.0035, edge, HumanoidMeshBuilder.M_CLOTH)
	strip(right, 0.014, 0.0035, edge, HumanoidMeshBuilder.M_CLOTH)


## Anel fino em volta do tronco (barra, cinto).
func band(yy: float, height: float, lift: float, col: Color, mat: float, steps: int = 26) -> void:
	var path: Array = []
	for k in steps + 1:
		path.append(Vector2(yy, TAU * float(k) / steps))
	strip(path, height, lift, col, mat)


# ---------------------------------------------------------------------------
# Peças de roupa
# ---------------------------------------------------------------------------
func top_details() -> void:
	if b.lod != 0 or b.tr.is_empty():
		return
	var top: String = b.a.get("top", "tshirt")
	if top in ["tshirt", "longsleeve", "shirt", "labcoat", "gown"]:
		neckline(top)
	match top:
		"jacket":
			jacket()
		"labcoat":
			labcoat()
		"hoodie":
			hoodie()
		"shirt":
			shirt()
		"longsleeve", "tshirt":
			tee()
	var bottom: String = b.a.get("bottom", "jeans")
	if bottom in ["jeans", "pants"]:
		trousers(top)
	if bool(b.a.get("vest", false)):
		vest_straps()


## Acabamento do decote: fita que cobre a borda do tecido junto ao pescoço.
func neckline(top: String) -> void:
	var tc: Color = b.a.get("top_color", Color.GRAY)
	var col := tc.darkened(0.13)
	var wd := 0.02
	if top in ["shirt", "labcoat"]:
		col = tc.lightened(0.03)
		wd = 0.028
	if top == "gown":
		col = tc.darkened(0.06)
	var ring: Array = []
	for k in 29:
		ring.append(Vector2(1.522, TAU * float(k) / 28.0))
	strip(ring, wd, 0.0032, col, HumanoidMeshBuilder.M_CLOTH)


func jacket() -> void:
	var tc: Color = b.a.get("top_color", Color.GRAY)
	var dark := tc.darkened(0.22)
	var metal := Color(0.24, 0.24, 0.27)
	var front := PI * 0.5
	shirt_v(1.33, 1.525, 0.46, b.a.get("top2_color", Color(0.6, 0.6, 0.62)), tc.darkened(0.16))
	var zip: Array = []
	var yy := 1.02
	while yy <= 1.335:
		zip.append(Vector2(yy, front))
		yy += 0.035
	strip(zip, 0.05, 0.0012, tc.darkened(0.07), HumanoidMeshBuilder.M_CLOTH)
	strip(zip, 0.011, 0.0038, metal, HumanoidMeshBuilder.M_LEATHER)
	strip(zip, 0.0035, 0.0052, Color(0.62, 0.62, 0.64), HumanoidMeshBuilder.M_LEATHER)
	patch(1.335, front, 0.014, 0.03, 0.005, metal, HumanoidMeshBuilder.M_LEATHER)
	patch(1.21, front, 0.016, 0.034, 0.0065, Color(0.5, 0.5, 0.52), HumanoidMeshBuilder.M_LEATHER)
	# bolsos de mão com aba e botão
	for sgn: float in [-1.0, 1.0]:
		var th := front - sgn * 0.68
		patch(0.995, th, 0.125, 0.11, 0.0015, dark, HumanoidMeshBuilder.M_CLOTH, 0.002)
		patch(1.038, th, 0.13, 0.036, 0.0045, tc.darkened(0.1), HumanoidMeshBuilder.M_CLOTH, 0.003)
		patch(1.02, th, 0.012, 0.012, 0.0085, metal, HumanoidMeshBuilder.M_LEATHER, 0.0, 2, 2)
	# bolso do peito (lado esquerdo do personagem) com aba
	var thc := front + 0.5
	patch(1.3, thc, 0.095, 0.075, 0.0015, dark, HumanoidMeshBuilder.M_CLOTH, 0.002)
	patch(1.334, thc, 0.1, 0.03, 0.0045, tc.darkened(0.1), HumanoidMeshBuilder.M_CLOTH, 0.002)
	patch(1.32, thc, 0.011, 0.011, 0.0085, metal, HumanoidMeshBuilder.M_LEATHER, 0.0, 2, 2)
	# barra canelada e punho de gola
	band(0.918, 0.05, 0.0025, tc.darkened(0.18), HumanoidMeshBuilder.M_CLOTH)
	band(0.895, 0.008, 0.0035, tc.darkened(0.3), HumanoidMeshBuilder.M_CLOTH)
	# costuras nas costas: centro e canga (ombro a ombro)
	var back := PI * 1.5
	var seam: Array = []
	yy = 0.93
	while yy <= 1.43:
		seam.append(Vector2(yy, back))
		yy += 0.05
	strip(seam, 0.006, 0.0015, dark, HumanoidMeshBuilder.M_CLOTH)
	var yoke: Array = []
	for k in 13:
		var f := float(k) / 12.0
		yoke.append(Vector2(1.37 + 0.05 * (1.0 - pow(2.0 * f - 1.0, 2.0)) * 0.0, back - 1.25 + 2.5 * f))
	strip(yoke, 0.006, 0.0015, dark, HumanoidMeshBuilder.M_CLOTH)
	# dragonas nos ombros
	for sgn: float in [-1.0, 1.0]:
		patch(1.46, sgn * 0.0 + (0.42 if sgn > 0.0 else PI - 0.42), 0.055, 0.03, 0.003, dark, HumanoidMeshBuilder.M_CLOTH, 0.001, 3, 2)


func labcoat() -> void:
	var tc: Color = b.a.get("top_color", Color.WHITE)
	var edge := tc.darkened(0.12)
	var front := PI * 0.5
	# abertura em V com a camisa por baixo
	shirt_v(1.24, 1.525, 0.56, b.a.get("top2_color", Color(0.34, 0.44, 0.6)), edge)
	var mid: Array = []
	var yy := 0.62
	while yy <= 1.27:
		mid.append(Vector2(yy, front))
		yy += 0.06
	strip(mid, 0.006, 0.0015, edge, HumanoidMeshBuilder.M_CLOTH)
	for yb: float in [1.18, 1.05, 0.92, 0.79]:
		patch(yb, front + 0.05, 0.014, 0.014, 0.0035, Color(0.85, 0.86, 0.86), HumanoidMeshBuilder.M_LEATHER, 0.0, 2, 2)
	# bolso do peito e bolsos de baixo
	patch(1.28, front + 0.55, 0.08, 0.075, 0.0025, edge, HumanoidMeshBuilder.M_CLOTH, 0.002)
	for sgn: float in [-1.0, 1.0]:
		patch(0.98, front - sgn * 0.7, 0.13, 0.1, 0.0025, edge, HumanoidMeshBuilder.M_CLOTH, 0.002)


func hoodie() -> void:
	var tc: Color = b.a.get("top_color", Color.GRAY)
	var dark := tc.darkened(0.18)
	var front := PI * 0.5
	# bolso canguru e cordões
	patch(1.03, front, 0.27, 0.11, 0.003, dark, HumanoidMeshBuilder.M_CLOTH, 0.006)
	for sgn: float in [-1.0, 1.0]:
		var cord: Array = []
		for k in 6:
			cord.append(Vector2(1.44 - float(k) * 0.05, front - sgn * 0.13))
		strip(cord, 0.007, 0.004, Color(0.85, 0.85, 0.82), HumanoidMeshBuilder.M_CLOTH)
	band(0.918, 0.05, 0.0025, dark, HumanoidMeshBuilder.M_CLOTH)
	# capuz caído atrás da nuca
	var r := torso_pt(1.5, PI * 1.5, 0.0)
	var hood := (r[0] as Vector3) + Vector3(0, 0.0, 0.035 * b.s)
	b._ellipsoid(hood, Vector3(0.1, 0.05, 0.055) * b.s, tc, HumanoidMeshBuilder.M_CLOTH, HumanoidMeshBuilder.CHEST, 0.8, HumanoidMeshBuilder.NECK, 0.2, 12, 6)


func shirt() -> void:
	var tc: Color = b.a.get("top_color", Color.GRAY)
	var front := PI * 0.5
	var pl: Array = []
	var yy := 0.99
	while yy <= 1.46:
		pl.append(Vector2(yy, front))
		yy += 0.05
	strip(pl, 0.03, 0.0015, tc.darkened(0.06), HumanoidMeshBuilder.M_CLOTH)
	for yb: float in [1.42, 1.32, 1.22, 1.12, 1.02]:
		patch(yb, front, 0.011, 0.011, 0.0032, Color(0.9, 0.9, 0.88), HumanoidMeshBuilder.M_LEATHER, 0.0, 2, 2)
	# gola: duas abas
	for sgn: float in [-1.0, 1.0]:
		var fl: Array = []
		for k in 6:
			var f := float(k) / 5.0
			fl.append(Vector2(1.5 - f * 0.055, front - sgn * (0.12 + 0.36 * (1.0 - f))))
		strip(fl, 0.035, 0.005, tc.lightened(0.05), HumanoidMeshBuilder.M_CLOTH)
	patch(1.3, front + 0.5, 0.085, 0.085, 0.002, tc.darkened(0.08), HumanoidMeshBuilder.M_CLOTH, 0.002)
	patch(1.3, front - 0.5, 0.085, 0.085, 0.002, tc.darkened(0.08), HumanoidMeshBuilder.M_CLOTH, 0.002)


func tee() -> void:
	var tc: Color = b.a.get("top_color", Color.GRAY)
	# gola redonda canelada + barra
	var rim: Array = []
	for k in 25:
		var th := TAU * float(k) / 24.0
		rim.append(Vector2(1.5 + 0.0 * th, th))
	strip(rim, 0.016, 0.004, tc.darkened(0.16), HumanoidMeshBuilder.M_CLOTH)
	band(0.9, 0.03, 0.002, tc.darkened(0.1), HumanoidMeshBuilder.M_CLOTH)


func trousers(top: String) -> void:
	var bc: Color = b.a.get("bottom_color", Color.DARK_BLUE)
	var front := PI * 0.5
	var back := PI * 1.5
	var jeans: bool = b.a.get("bottom", "jeans") == "jeans"
	var covered: bool = top in ["jacket", "hoodie", "labcoat"]
	if not covered:
		# cinto com fivela e passadores
		var leather := Color(0.09, 0.065, 0.045)
		band(0.985, 0.036, 0.003, leather, HumanoidMeshBuilder.M_LEATHER)
		patch(0.985, front, 0.034, 0.03, 0.0065, Color(0.7, 0.68, 0.6), HumanoidMeshBuilder.M_LEATHER, 0.0, 2, 2)
		for k in 6:
			patch(0.985, front + (float(k) - 2.5) * 0.52, 0.012, 0.045, 0.0055, bc.darkened(0.15), HumanoidMeshBuilder.M_DENIM, 0.0, 1, 1)
	var seam := bc.darkened(0.25)
	# bolsos da frente (curva do quadril) e de trás com pesponto
	for sgn: float in [-1.0, 1.0]:
		var curve: Array = []
		for k in 7:
			var f := float(k) / 6.0
			curve.append(Vector2(0.965 - 0.075 * f, front - sgn * (0.85 - 0.22 * pow(f, 0.7))))
		strip(curve, 0.005, 0.002, seam, HumanoidMeshBuilder.M_DENIM)
		if jeans:
			patch(0.905, back + sgn * 0.42, 0.1, 0.11, 0.0022, bc.darkened(0.07), HumanoidMeshBuilder.M_DENIM, 0.001)
			var st: Array = []
			for k in 5:
				st.append(Vector2(0.96 - float(k) * 0.005, back + sgn * (0.42 - 0.2 + 0.4 * float(k) / 4.0)))
			strip(st, 0.004, 0.0035, Color(0.75, 0.6, 0.3), HumanoidMeshBuilder.M_CLOTH)


# ---------------------------------------------------------------------------
# Caixas (fivelas, tiras, presilhas) e mochila
# ---------------------------------------------------------------------------
## Caixa alinhada aos eixos (girada em Y por `yaw`), centro e meias-medidas em m de referência.
func box(center: Vector3, half: Vector3, col: Color, mat: float, bone: int, yaw: float = 0.0, bone2: int = -1, w2: float = 0.0) -> void:
	var bs := Basis(Vector3.UP, yaw)
	var sc: float = b.s
	for axis in 3:
		for sgn: float in [-1.0, 1.0]:
			var d := Vector3.ZERO
			d[axis] = sgn
			var ua := (axis + 1) % 3
			var va := (axis + 2) % 3
			var tu := Vector3.ZERO
			tu[ua] = 1.0
			var n: Vector3 = bs * d
			var idx: Array = []
			for sv: float in [-1.0, 1.0]:
				for su: float in [-1.0, 1.0]:
					var q := Vector3.ZERO
					q[axis] = sgn * half[axis]
					q[ua] = su * half[ua]
					q[va] = sv * half[va]
					idx.append(b._v((center + bs * q) * sc, n, bs * tu, Vector3.UP, Vector2(q.x + q.z, q.y) * 4.0, col, mat, bone, 1.0 - w2, maxi(bone2, 0), w2))
			b._tri(idx[0], idx[1], idx[2])
			b._tri(idx[1], idx[3], idx[2])


func backpack() -> void:
	var bc: Color = b.a.get("backpack_color", Color(0.3, 0.28, 0.2))
	var bw := float(b.a.get("build", 1.0))
	var s: float = b.s
	var zb := 0.115 * lerpf(1.0, float(b.a.get("girth", 1.0)), 0.6) + 0.07
	var webbing := Color(0.1, 0.1, 0.1)
	var metal := Color(0.4, 0.4, 0.42)
	var CH := HumanoidMeshBuilder.CHEST
	var SP := HumanoidMeshBuilder.SPINE
	var sides := 16
	# compartimento principal (retangular arredondado) e tampa
	var body_rings := [[0.0, 0.118 * bw, 0.062, bc, HumanoidMeshBuilder.M_CLOTH], [0.05, 0.146 * bw, 0.082, bc, HumanoidMeshBuilder.M_CLOTH],
		[0.3, 0.155 * bw, 0.092, bc, HumanoidMeshBuilder.M_CLOTH], [0.7, 0.155 * bw, 0.09, bc, HumanoidMeshBuilder.M_CLOTH],
		[0.95, 0.146 * bw, 0.078, bc, HumanoidMeshBuilder.M_CLOTH], [1.0, 0.115 * bw, 0.058, bc, HumanoidMeshBuilder.M_CLOTH]]
	b._tube(Vector3(0, 1.4 * s, zb * s), Vector3(0, 1.02 * s, (zb + 0.012) * s), body_rings, sides, CH, -1, SP, true, true, 0.0, 0.0, false)
	var lid_rings := [[0.0, 0.11 * bw, 0.06, bc.lightened(0.05), HumanoidMeshBuilder.M_CLOTH], [0.12, 0.152 * bw, 0.096, bc.lightened(0.05), HumanoidMeshBuilder.M_CLOTH],
		[0.75, 0.15 * bw, 0.1, bc.lightened(0.05), HumanoidMeshBuilder.M_CLOTH], [1.0, 0.12 * bw, 0.07, bc.lightened(0.04), HumanoidMeshBuilder.M_CLOTH]]
	b._tube(Vector3(0, 1.5 * s, (zb + 0.004) * s), Vector3(0, 1.31 * s, (zb + 0.048) * s), lid_rings, sides, CH, -1, -1, true, true, 0.0, 0.0, false)
	# bolsos laterais (garrafa) e frontal
	for sgn: float in [-1.0, 1.0]:
		var sp_rings := [[0.0, 0.03, 0.03, bc.darkened(0.12), HumanoidMeshBuilder.M_CLOTH], [0.1, 0.046, 0.046, bc.darkened(0.12), HumanoidMeshBuilder.M_CLOTH],
			[0.9, 0.048, 0.048, bc.darkened(0.12), HumanoidMeshBuilder.M_CLOTH], [1.0, 0.04, 0.04, bc.darkened(0.15), HumanoidMeshBuilder.M_CLOTH]]
		b._tube(Vector3(sgn * 0.165 * bw * s, 1.3 * s, (zb + 0.03) * s), Vector3(sgn * 0.168 * bw * s, 1.08 * s, (zb + 0.036) * s), sp_rings, 10, CH, -1, SP, true, true, 0.0, 0.0, false)
	var fp := [[0.0, 0.1 * bw, 0.03, bc.darkened(0.16), HumanoidMeshBuilder.M_CLOTH], [0.12, 0.112 * bw, 0.044, bc.darkened(0.16), HumanoidMeshBuilder.M_CLOTH],
		[0.9, 0.112 * bw, 0.044, bc.darkened(0.16), HumanoidMeshBuilder.M_CLOTH], [1.0, 0.1 * bw, 0.03, bc.darkened(0.16), HumanoidMeshBuilder.M_CLOTH]]
	b._tube(Vector3(0, 1.27 * s, (zb + 0.088) * s), Vector3(0, 1.08 * s, (zb + 0.092) * s), fp, 12, CH, -1, SP, true, true, 0.0, 0.0, false)
	# tiras de compressão com fivela (frente do bolso e tampa) e alça de mão
	for yy: float in [1.2, 1.12]:
		box(Vector3(0, yy, zb + 0.13), Vector3(0.118 * bw, 0.0085, 0.0035), webbing, HumanoidMeshBuilder.M_LEATHER, CH, 0.0, SP, 0.35)
		box(Vector3(0.0, yy, zb + 0.137), Vector3(0.014, 0.011, 0.004), metal, HumanoidMeshBuilder.M_LEATHER, CH, 0.0, SP, 0.35)
	box(Vector3(0, 1.4, zb + 0.108), Vector3(0.03, 0.05, 0.0035), webbing, HumanoidMeshBuilder.M_LEATHER, CH)
	box(Vector3(0, 1.4, zb + 0.114), Vector3(0.012, 0.012, 0.004), metal, HumanoidMeshBuilder.M_LEATHER, CH)
	box(Vector3(0, 1.505, zb + 0.008), Vector3(0.028, 0.006, 0.014), webbing, HumanoidMeshBuilder.M_LEATHER, CH)
	# alças acolchoadas: sobem do topo, passam sobre o ombro e descem pela frente do tronco
	for sgn: float in [-1.0, 1.0]:
		var p0 := Vector3(sgn * 0.075 * bw * s, 1.44 * s, (zb - 0.03) * s)
		var p1 := Vector3(sgn * 0.105 * bw * s, 1.505 * s, 0.02 * s)
		var p2 := Vector3(sgn * 0.128 * bw * s, 1.4 * s, -0.115 * s)
		var p3 := Vector3(sgn * 0.13 * bw * s, 1.2 * s, -0.112 * s)
		var p4 := Vector3(sgn * 0.12 * bw * s, 1.06 * s, -0.098 * s)
		var strap := [[0.0, 0.026, 0.008, webbing.lightened(0.04), HumanoidMeshBuilder.M_CLOTH], [1.0, 0.026, 0.008, webbing.lightened(0.04), HumanoidMeshBuilder.M_CLOTH]]
		b._tube(p0, p1, strap, 6, CH, -1, -1, false, false, 0.0, 0.0, false)
		b._tube(p1, p2, strap, 6, CH, -1, -1, false, false, 0.0, 0.0, false)
		b._tube(p2, p3, strap, 6, CH, -1, SP, false, false, 0.0, 0.0, false)
		b._tube(p3, p4, strap, 6, SP, -1, CH, false, true, 0.0, 0.0, false)
		box(Vector3(sgn * 0.12 * bw, 1.075, -0.099), Vector3(0.013, 0.012, 0.005), metal, HumanoidMeshBuilder.M_LEATHER, SP)
	# tira do peito
	box(Vector3(0, 1.3, -0.121), Vector3(0.115 * bw, 0.005, 0.003), webbing, HumanoidMeshBuilder.M_LEATHER, CH)
	box(Vector3(0, 1.3, -0.125), Vector3(0.014, 0.01, 0.004), metal, HumanoidMeshBuilder.M_LEATHER, CH)
	# cinto de quadril
	for sgn: float in [-1.0, 1.0]:
		var h0 := Vector3(sgn * 0.14 * bw * s, 1.04 * s, (zb + 0.05) * s)
		var h1 := Vector3(sgn * 0.17 * bw * s, 1.0 * s, 0.02 * s)
		var h2 := Vector3(sgn * 0.09 * bw * s, 0.99 * s, -0.11 * s)
		var belt := [[0.0, 0.03, 0.006, webbing, HumanoidMeshBuilder.M_CLOTH], [1.0, 0.03, 0.006, webbing, HumanoidMeshBuilder.M_CLOTH]]
		b._tube(h0, h1, belt, 6, SP, -1, -1, false, false, 0.0, 0.0, false)
		b._tube(h1, h2, belt, 6, SP, -1, -1, false, false, 0.0, 0.0, false)
	box(Vector3(0, 0.99, -0.113), Vector3(0.026, 0.017, 0.006), metal, HumanoidMeshBuilder.M_LEATHER, SP)
	if bool(b.a.get("bedroll", false)):
		var rc := Color(0.36, 0.3, 0.2)
		var rr := [[0.0, 0.052, 0.052, rc.darkened(0.1), HumanoidMeshBuilder.M_CLOTH], [0.05, 0.062, 0.062, rc, HumanoidMeshBuilder.M_CLOTH],
			[0.95, 0.062, 0.062, rc, HumanoidMeshBuilder.M_CLOTH], [1.0, 0.052, 0.052, rc.darkened(0.1), HumanoidMeshBuilder.M_CLOTH]]
		b._tube(Vector3(-0.185 * bw * s, 1.535 * s, (zb + 0.01) * s), Vector3(0.185 * bw * s, 1.535 * s, (zb + 0.01) * s), rr, 12, CH, -1, -1, true, true, 0.0, 0.0, false)
		for x: float in [-0.1, 0.1]:
			box(Vector3(x * bw, 1.535, zb + 0.01), Vector3(0.008, 0.066, 0.066), webbing, HumanoidMeshBuilder.M_LEATHER, CH)


func vest_straps() -> void:
	var vc: Color = b.a.get("vest_color", Color(0.1, 0.11, 0.1))
	var front := PI * 0.5
	for sgn: float in [-1.0, 1.0]:
		patch(1.18, front - sgn * 0.5, 0.075, 0.09, 0.003, vc.lightened(0.06), HumanoidMeshBuilder.M_CLOTH, 0.006)
		patch(1.07, front - sgn * 0.42, 0.075, 0.09, 0.003, vc.lightened(0.06), HumanoidMeshBuilder.M_CLOTH, 0.006)
	patch(1.3, front, 0.06, 0.03, 0.004, Color(0.7, 0.7, 0.72), HumanoidMeshBuilder.M_LEATHER)
