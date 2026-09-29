class_name UIGlyph
extends Control
## Ícone vetorial (UIIcons) como controle: `glyph` do HUD ou `item_id` de item.

var glyph: String = "":
	set(v):
		glyph = v
		queue_redraw()
var item_id: String = "":
	set(v):
		item_id = v
		queue_redraw()
var color: Color = Color(0.9, 0.88, 0.82):
	set(v):
		color = v
		queue_redraw()
var dim: bool = false


static func make(g: String, sz: float, col: Color) -> UIGlyph:
	var c := UIGlyph.new()
	c.glyph = g
	c.color = col
	c.custom_minimum_size = Vector2(sz, sz)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


static func for_item(id: String, sz: float) -> UIGlyph:
	var c := UIGlyph.new()
	c.item_id = id
	c.custom_minimum_size = Vector2(sz, sz)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


func _draw() -> void:
	var s := minf(size.x, size.y)
	var r := Rect2((size - Vector2(s, s)) * 0.5, Vector2(s, s))
	if item_id != "":
		UIIcons.draw_item(self, item_id, r, dim)
	elif glyph != "":
		UIIcons.draw_glyph(self, glyph, r, color)
