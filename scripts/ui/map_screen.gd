class_name MapScreen
extends Control
## Mapa da região de Santa Aurora (rasterizado do layout uma vez e salvo em
## cache): ruas, rodovias, rio, lago, quarteirões, prédios, distritos.
## Mostra jogador, locais descobertos, objetivo, veículos e companheiros.
## Roda do mouse: zoom · arrastar: mover · botão direito: marcar destino.

signal closed

const SIZE := 1024
const HALF := WorldLayout.HALF

static var _tex: ImageTexture = null

var game: Node
var player: Player
var view: MapView


func _ready() -> void:
	theme = UITheme.game_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(UIKit.dim_bg(0.75))
	var h := UIKit.hbox(14)
	var p := UIKit.window(10)
	p.custom_minimum_size = Vector2(900, 760)
	view = MapView.new()
	view.screen = self
	view.custom_minimum_size = Vector2(880, 740)
	view.clip_contents = true
	p.add_child(view)
	h.add_child(p)
	var side := UIKit.window(16)
	side.custom_minimum_size = Vector2(380, 760)
	var sv := UIKit.vbox(8)
	side.add_child(sv)
	sv.add_child(UIKit.header("map", "MAPA", WorldLayout.district_name(game.world.district_at(player.global_position)), "M", "Fechar"))
	sv.add_child(UIKit.separator())
	# legenda
	var leg := GridContainer.new()
	leg.columns = 2
	leg.add_theme_constant_override("h_separation", 14)
	leg.add_theme_constant_override("v_separation", 4)
	for e in [["target", "Você", Color(1.0, 0.95, 0.85)], ["star", "Objetivo", UITheme.ACCENT], ["flag", "Local conhecido", Color(0.85, 0.8, 0.7)], ["people", "Companheiros", UITheme.GOOD]]:
		var lh := UIKit.hbox(6)
		lh.add_child(UIGlyph.make(str(e[0]), 16, e[2]))
		lh.add_child(UIKit.label(str(e[1]), 14, UITheme.TEXT_DIM))
		leg.add_child(lh)
	sv.add_child(leg)
	sv.add_child(UIKit.section("Locais conhecidos (%d)" % GameState.discovered.size()))
	var sc := ScrollContainer.new()
	sc.custom_minimum_size = Vector2(340, 440)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var lv := UIKit.vbox(2)
	lv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(lv)
	var ids := GameState.discovered.keys()
	ids.sort()
	for id in ids:
		var poi: Dictionary = game.world.layout.pois.get(id, {})
		if poi.is_empty():
			continue
		var b := Button.new()
		b.text = "      " + str(poi["name"])
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.flat = true
		b.add_theme_font_size_override("font_size", 15)
		var fg := UIGlyph.make("flag", 16, UITheme.ACCENT.darkened(0.2))
		fg.position = Vector2(6, 8)
		b.add_child(fg)
		var pp: Vector3 = poi["pos"]
		b.pressed.connect(func() -> void: view.center_on(Vector2(pp.x, pp.z)))
		lv.add_child(b)
	sv.add_child(sc)
	var hints := GridContainer.new()
	hints.columns = 2
	hints.add_theme_constant_override("h_separation", 8)
	hints.add_theme_constant_override("v_separation", 4)
	for e in [["Roda", "zoom"], ["Arrastar", "mover o mapa"], ["Botão direito", "marcar destino"]]:
		hints.add_child(UIKit.keycap(str(e[0])))
		hints.add_child(UIKit.label(str(e[1]), 13, UITheme.TEXT_DIM))
	sv.add_child(hints)
	sv.add_child(UIKit.button("Fechar", close, 200))
	h.add_child(side)
	add_child(UIKit.center(h))
	if _tex == null:
		_tex = ImageTexture.create_from_image(_load_or_build(game.world.layout))
	view.tex = _tex
	view.center_on(Vector2(player.global_position.x, player.global_position.z))
	EventBus.ui_screen_opened.emit("map")


static func world_to_px(p: Vector2) -> Vector2:
	return (p + Vector2(HALF, HALF)) / (HALF * 2.0) * SIZE


static func _load_or_build(layout: WorldLayout) -> Image:
	var path := "user://cache/map_%d_v2.png" % layout.seed_value
	if FileAccess.file_exists(path):
		var img := Image.load_from_file(path)
		if img != null and img.get_width() == SIZE:
			return img
	var img := build_image(layout)
	DirAccess.make_dir_recursive_absolute("user://cache")
	img.save_png(path)
	return img


static func build_image(layout: WorldLayout) -> Image:
	var img := Image.create(SIZE, SIZE, false, Image.FORMAT_RGB8)
	img.fill(Color(0.2, 0.24, 0.17))
	# relevo aproximado por distrito (barato)
	var step := 16
	for py in range(0, SIZE, step):
		for px in range(0, SIZE, step):
			var wx := (float(px) + step * 0.5) / SIZE * HALF * 2.0 - HALF
			var wz := (float(py) + step * 0.5) / SIZE * HALF * 2.0 - HALF
			var d := layout.district_at(wx, wz)
			var c := Color(0.2, 0.24, 0.17)
			match d:
				"serra": c = Color(0.25, 0.25, 0.2)
				"floresta": c = Color(0.13, 0.2, 0.12)
				"rural": c = Color(0.27, 0.28, 0.18)
				"parque_norte": c = Color(0.17, 0.25, 0.15)
			var n := layout.noise.get_noise_2d(wx, wz) * 0.04
			img.fill_rect(Rect2i(px, py, step, step), Color(c.r + n, c.g + n, c.b + n))
	# área urbana
	var u0 := world_to_px(WorldLayout.URBAN.position)
	var u1 := world_to_px(WorldLayout.URBAN.end)
	img.fill_rect(Rect2i(Vector2i(u0), Vector2i(u1 - u0)), Color(0.3, 0.3, 0.29))
	# quarteirões
	for b in layout.blocks:
		var r: Rect2 = b["rect"]
		var a := world_to_px(r.position)
		var e := world_to_px(r.end)
		var col := Color(0.38, 0.37, 0.35)
		match str(b.get("kind", "")):
			"park", "plaza": col = Color(0.24, 0.34, 0.2)
			"stadium": col = Color(0.3, 0.4, 0.28)
			"corvalis": col = Color(0.33, 0.33, 0.37)
		img.fill_rect(Rect2i(Vector2i(a), Vector2i((e - a).ceil())), col)
	# prédios
	for b in layout.buildings:
		if not b.has("rect"):
			continue
		var r: Rect2 = b["rect"]
		var a := world_to_px(r.position)
		var e := world_to_px(r.end)
		var col := Color(0.22, 0.21, 0.2) if str(b.get("poi", "")) == "" else Color(0.5, 0.42, 0.28)
		img.fill_rect(Rect2i(Vector2i(a), Vector2i((e - a).ceil()).max(Vector2i(1, 1))), col)
	# lago
	var lc := world_to_px(WorldLayout.LAKE_CENTER)
	var lr := WorldLayout.LAKE_R / (HALF * 2.0) * SIZE
	for y in range(int(lc.y - lr.y), int(lc.y + lr.y) + 1):
		for x in range(int(lc.x - lr.x), int(lc.x + lr.x) + 1):
			if x < 0 or y < 0 or x >= SIZE or y >= SIZE:
				continue
			if ((Vector2(x, y) - lc) / lr).length() < 0.92:
				img.set_pixel(x, y, Color(0.16, 0.3, 0.42))
	# rio
	for i in layout.river_pts.size() - 1:
		_thick_line(img, world_to_px(layout.river_pts[i]), world_to_px(layout.river_pts[i + 1]), WorldLayout.RIVER_HALF * 2.0 / (HALF * 2.0) * SIZE, Color(0.16, 0.3, 0.42))
	# ruas
	for r in layout.roads:
		var w := maxf(float(r["hw"]) * 2.0 / (HALF * 2.0) * SIZE, 1.2)
		var col := Color(0.12, 0.12, 0.13) if str(r["kind"]) != "highway" else Color(0.55, 0.45, 0.28)
		if str(r["kind"]) == "bridge":
			col = Color(0.5, 0.5, 0.5)
		_thick_line(img, world_to_px(r["a"]), world_to_px(r["b"]), w, col)
	for pl in layout.hwy_polylines:
		var pts: Array = pl["pts"]
		for i in pts.size() - 1:
			_thick_line(img, world_to_px(pts[i]), world_to_px(pts[i + 1]), 2.2, Color(0.55, 0.45, 0.28))
	return img


static func _thick_line(img: Image, a: Vector2, b: Vector2, w: float, c: Color) -> void:
	var len := a.distance_to(b)
	var n := maxi(1, int(len / maxf(w * 0.5, 0.7)))
	var r := maxi(1, int(ceil(w * 0.5)))
	for i in n + 1:
		var p := a.lerp(b, float(i) / float(n))
		var rect := Rect2i(int(p.x) - r, int(p.y) - r, r * 2, r * 2).intersection(Rect2i(0, 0, SIZE, SIZE))
		if rect.size.x > 0 and rect.size.y > 0:
			img.fill_rect(rect, c)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map") or event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	if not is_inside_tree():
		return
	EventBus.ui_screen_closed.emit("map")
	closed.emit()
	queue_free()
