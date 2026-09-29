class_name UIIcons
extends RefCounted
## Ícones vetoriais desenhados em código (sem arquivos): itens por categoria /
## palavra-chave do id e símbolos do HUD. Tudo é desenhado numa caixa 0..1
## escalada para o retângulo pedido, então serve de 16 px a 96 px.


## Símbolo do item: primeiro por palavra-chave do id, depois pela categoria.
static func glyph_for_item(id: String) -> String:
	var keys := [
		["chave_roda", "tireiron"], ["canivete", "knife"], ["cutelo", "cleaver"], ["soco_ingles", "knuckles"], ["bastao", "bat"],
		["golfe", "golf"], ["machadinha", "axe"], ["picareta", "pickaxe"], ["foice", "sickle"], ["enxada", "hoe"], ["katana", "katana"],
		["submetralhadora", "smg"], ["carabina", "rifle"], ["fuzil", "rifle"], ["virote", "arrow"], ["besta", "crossbow"],
		["kit_ferramentas", "wrench"], ["kit_barricada", "crate"], ["kit_fogueira", "flame"], ["fragmento", "key"],
		["luvas", "glove"], ["botas", "boot"], ["chocolate", "bar"], ["macarrao", "bowl"], ["pao", "bar"], ["mel", "flask"],
		["racao", "can"], ["energetico", "can"], ["cachaca", "bottle"], ["ervas", "fruit"], ["lenha", "plank"], ["lona", "cloth"],
		["pneu", "tape"], ["fios", "rope"], ["oleo", "flask"], ["binoculo", "target"], ["dossie", "book"],
		["coquetel", "molotov"], ["rojao", "firework"], ["pedra", "rock"], ["garrafa_vazia", "bottle"], ["lata_vazia", "can"],
		["faca", "knife"], ["facao", "machete"], ["machado", "axe"], ["marreta", "sledge"], ["martelo", "hammer"],
		["taco", "bat"], ["cano", "pipe"], ["cassetete", "bat"], ["pe_de_cabra", "crowbar"], ["lanca", "spear"], ["pa", "shovel"],
		["pistola", "gun"], ["revolver", "gun"], ["espingarda", "rifle"], ["rifle", "rifle"], ["arco", "bow"], ["besta", "bow"],
		["flecha", "arrow"], ["bala", "ammo"], ["cartucho", "ammo"], ["municao", "ammo"],
		["chave_fenda", "screwdriver"], ["chave_inglesa", "wrench"], ["chave", "key"], ["isqueiro", "flame"], ["fosforo", "flame"],
		["lanterna", "flashlight"], ["pilha", "battery"], ["bateria", "battery"], ["radio", "radio"],
		["mochila", "backpack"], ["bolsa", "backpack"], ["jaqueta", "jacket"], ["casaco", "jacket"], ["capa", "jacket"], ["colete", "vest"],
		["capacete", "helmet"], ["bone", "helmet"], ["gorro", "helmet"], ["bota", "boot"], ["tenis", "boot"], ["luva", "glove"],
		["mascara", "mask"], ["filtro", "mask"],
		["bandagem", "bandage"], ["tira", "bandage"], ["pano", "cloth"], ["tala", "splint"], ["kit", "medkit"], ["sutura", "medkit"],
		["inibidor", "syringe"], ["seringa", "syringe"], ["vacina", "syringe"], ["alcool", "flask"], ["antissep", "flask"],
		["agua", "bottle"], ["refrigerante", "can"], ["cha", "mug"], ["cafe", "mug"], ["leite", "bottle"], ["suco", "bottle"],
		["enlatado", "can"], ["lata", "can"], ["feijao", "can"], ["sopa", "bowl"], ["arroz", "bowl"], ["cozid", "bowl"],
		["barra", "bar"], ["biscoito", "bar"], ["carne", "meat"], ["peixe", "fish"], ["fruta", "fruit"], ["milho", "fruit"],
		["madeira", "plank"], ["tabua", "plank"], ["prego", "nail"], ["parafuso", "nail"], ["sucata", "gear"], ["metal", "gear"],
		["fita", "tape"], ["corda", "rope"], ["arame", "rope"], ["tecido", "cloth"], ["cola", "flask"],
		["gasolina", "jerrycan"], ["combust", "jerrycan"], ["querosene", "jerrycan"], ["carvao", "rock"],
		["foto", "photo"], ["gravador", "cassette"], ["fita_k7", "cassette"], ["fragmento", "document"], ["cracha", "card"],
		["cartao", "card"], ["nota", "document"], ["carta", "document"], ["diario", "book"], ["mapa", "map"],
		["fogueira", "flame"], ["bancada", "crate"], ["armadilha", "trap"], ["barricada", "crate"], ["cama", "bed"], ["coletor", "bottle"],
	]
	# chaves curtas (≤ 4 letras) só valem como palavra inteira do id ("pa" ≠ "pano", "sopa")
	var tokens := id.split("_")
	for k in keys:
		var key: String = k[0]
		if key.contains("_") or key.length() > 4:
			if id.contains(key):
				return k[1]
		elif key in tokens:
			return k[1]
	match ItemDB.category(id):
		"comida": return "can"
		"bebida": return "bottle"
		"medicamento": return "pill"
		"ferramenta": return "wrench"
		"arma": return "bat"
		"arremesso": return "rock"
		"material": return "gear"
		"equipamento": return "backpack"
		"combustivel": return "jerrycan"
		"historia": return "document"
		"estrutura": return "crate"
		"municao": return "ammo"
	return "box"


static func item_color(id: String) -> Color:
	return ItemDB.CAT_COLORS.get(ItemDB.category(id), Color(0.6, 0.6, 0.6))


## Fundo circular com a cor da categoria + símbolo claro por cima.
static func draw_item(ci: CanvasItem, id: String, r: Rect2, dim: bool = false) -> void:
	var base := item_color(id)
	var c := r.get_center()
	var rad := minf(r.size.x, r.size.y) * 0.5
	ci.draw_circle(c, rad, base.darkened(0.62) * Color(1, 1, 1, 0.95))
	ci.draw_arc(c, rad - 1.0, 0.0, TAU, 32, base.darkened(0.15) * Color(1, 1, 1, 0.9), maxf(1.0, rad * 0.06), true)
	var inner := Rect2(c - Vector2(rad, rad) * 0.72, Vector2(rad, rad) * 1.44)
	var col := base.lightened(0.45)
	if dim:
		col = col.darkened(0.45)
	draw_glyph(ci, glyph_for_item(id), inner, col)


static func _p(r: Rect2, x: float, y: float) -> Vector2:
	return r.position + Vector2(x, y) * r.size


static func _pts(r: Rect2, a: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for i in range(0, a.size(), 2):
		out.append(_p(r, a[i], a[i + 1]))
	return out


static func _poly(ci: CanvasItem, r: Rect2, a: Array, col: Color) -> void:
	ci.draw_colored_polygon(_pts(r, a), col)


static func _rect(ci: CanvasItem, r: Rect2, x0: float, y0: float, x1: float, y1: float, col: Color) -> void:
	ci.draw_rect(Rect2(_p(r, x0, y0), _p(r, x1, y1) - _p(r, x0, y0)), col)


static func _line(ci: CanvasItem, r: Rect2, x0: float, y0: float, x1: float, y1: float, col: Color, w: float) -> void:
	ci.draw_line(_p(r, x0, y0), _p(r, x1, y1), col, maxf(1.0, w * r.size.x), true)


static func _circ(ci: CanvasItem, r: Rect2, x: float, y: float, rad: float, col: Color) -> void:
	ci.draw_circle(_p(r, x, y), rad * r.size.x, col)


static func _ring(ci: CanvasItem, r: Rect2, x: float, y: float, rad: float, col: Color, w: float, a0: float = 0.0, a1: float = TAU) -> void:
	ci.draw_arc(_p(r, x, y), rad * r.size.x, a0, a1, 28, col, maxf(1.0, w * r.size.x), true)


## Desenha o símbolo `g` dentro de `r` com a cor `col`.
static func draw_glyph(ci: CanvasItem, g: String, r: Rect2, col: Color) -> void:
	var dk := col.darkened(0.55)
	match g:
		# ---- comida / bebida
		"can":
			_rect(ci, r, 0.27, 0.2, 0.73, 0.84, col)
			_rect(ci, r, 0.27, 0.42, 0.73, 0.62, dk)
			_line(ci, r, 0.25, 0.2, 0.75, 0.2, col.lightened(0.3), 0.07)
			_line(ci, r, 0.25, 0.84, 0.75, 0.84, col.lightened(0.3), 0.07)
		"bar":
			_poly(ci, r, [0.12, 0.44, 0.2, 0.36, 0.8, 0.36, 0.88, 0.44, 0.88, 0.58, 0.8, 0.66, 0.2, 0.66, 0.12, 0.58], col)
			_rect(ci, r, 0.36, 0.36, 0.64, 0.66, dk)
		"bowl":
			_poly(ci, r, [0.12, 0.5, 0.88, 0.5, 0.78, 0.72, 0.62, 0.84, 0.38, 0.84, 0.22, 0.72], col)
			for x in [0.35, 0.5, 0.65]:
				_line(ci, r, x, 0.2, x + 0.04, 0.4, col, 0.05)
		"meat":
			_circ(ci, r, 0.58, 0.44, 0.24, col)
			_line(ci, r, 0.42, 0.6, 0.2, 0.84, col.lightened(0.4), 0.1)
			_circ(ci, r, 0.18, 0.86, 0.07, col.lightened(0.4))
		"fish":
			_poly(ci, r, [0.12, 0.5, 0.35, 0.32, 0.62, 0.3, 0.76, 0.46, 0.92, 0.3, 0.9, 0.7, 0.76, 0.54, 0.62, 0.7, 0.35, 0.68], col)
			_circ(ci, r, 0.3, 0.46, 0.035, dk)
		"fruit":
			_circ(ci, r, 0.5, 0.58, 0.28, col)
			_line(ci, r, 0.5, 0.32, 0.56, 0.16, dk.lightened(0.2), 0.06)
			_poly(ci, r, [0.56, 0.22, 0.76, 0.14, 0.7, 0.3], col.lightened(0.2))
		"bottle":
			_rect(ci, r, 0.43, 0.08, 0.57, 0.18, dk.lightened(0.3))
			_rect(ci, r, 0.44, 0.18, 0.56, 0.32, col)
			_poly(ci, r, [0.44, 0.3, 0.56, 0.3, 0.7, 0.42, 0.3, 0.42], col)
			_rect(ci, r, 0.3, 0.42, 0.7, 0.9, col)
			_rect(ci, r, 0.3, 0.55, 0.7, 0.72, dk)
		"mug":
			_rect(ci, r, 0.2, 0.34, 0.66, 0.84, col)
			_ring(ci, r, 0.68, 0.58, 0.13, col, 0.07, -PI * 0.5, PI * 0.5)
			for x in [0.32, 0.46]:
				_line(ci, r, x, 0.14, x + 0.03, 0.28, col, 0.05)
		# ---- médico
		"medkit":
			_rect(ci, r, 0.36, 0.2, 0.64, 0.3, col)
			_rect(ci, r, 0.14, 0.3, 0.86, 0.84, col)
			_rect(ci, r, 0.44, 0.4, 0.56, 0.74, dk)
			_rect(ci, r, 0.33, 0.51, 0.67, 0.63, dk)
		"cross":
			_rect(ci, r, 0.38, 0.14, 0.62, 0.86, col)
			_rect(ci, r, 0.14, 0.38, 0.86, 0.62, col)
		"pill":
			ci.draw_set_transform(_p(r, 0.5, 0.5), -PI / 4.0, Vector2.ONE)
			var w := r.size.x
			ci.draw_rect(Rect2(Vector2(-0.22, -0.13) * w, Vector2(0.44, 0.26) * w), col)
			ci.draw_circle(Vector2(-0.22, 0) * w, 0.13 * w, col)
			ci.draw_circle(Vector2(0.22, 0) * w, 0.13 * w, dk.lightened(0.35))
			ci.draw_rect(Rect2(Vector2(0.0, -0.13) * w, Vector2(0.22, 0.26) * w), dk.lightened(0.35))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"bandage":
			_circ(ci, r, 0.42, 0.5, 0.3, col)
			_circ(ci, r, 0.42, 0.5, 0.1, dk)
			_rect(ci, r, 0.42, 0.62, 0.9, 0.8, col)
		"splint":
			_rect(ci, r, 0.2, 0.14, 0.34, 0.86, col)
			_rect(ci, r, 0.66, 0.14, 0.8, 0.86, col)
			for y in [0.3, 0.7]:
				_rect(ci, r, 0.14, y, 0.86, y + 0.08, col.lightened(0.3))
		"syringe":
			_line(ci, r, 0.2, 0.8, 0.72, 0.28, col, 0.14)
			_line(ci, r, 0.72, 0.28, 0.88, 0.12, col.lightened(0.3), 0.04)
			_line(ci, r, 0.12, 0.72, 0.28, 0.88, col, 0.06)
			_line(ci, r, 0.3, 0.7, 0.5, 0.5, dk, 0.08)
		"flask":
			_rect(ci, r, 0.42, 0.12, 0.58, 0.34, col)
			_poly(ci, r, [0.42, 0.34, 0.58, 0.34, 0.82, 0.84, 0.18, 0.84], col)
			_poly(ci, r, [0.3, 0.6, 0.7, 0.6, 0.82, 0.84, 0.18, 0.84], dk)
		# ---- ferramentas / armas
		"wrench":
			_line(ci, r, 0.24, 0.8, 0.62, 0.42, col, 0.13)
			_circ(ci, r, 0.68, 0.34, 0.18, col)
			_circ(ci, r, 0.74, 0.28, 0.08, dk)
		"screwdriver":
			_line(ci, r, 0.46, 0.54, 0.86, 0.14, col.lightened(0.3), 0.06)
			_line(ci, r, 0.16, 0.84, 0.46, 0.54, col, 0.16)
		"hammer":
			_line(ci, r, 0.26, 0.86, 0.56, 0.34, dk.lightened(0.5), 0.1)
			_poly(ci, r, [0.34, 0.26, 0.62, 0.1, 0.8, 0.38, 0.52, 0.54], col)
		"flame":
			_poly(ci, r, [0.5, 0.1, 0.72, 0.42, 0.76, 0.64, 0.64, 0.84, 0.36, 0.84, 0.24, 0.64, 0.3, 0.44, 0.42, 0.5], col)
			_poly(ci, r, [0.5, 0.44, 0.62, 0.64, 0.56, 0.8, 0.44, 0.8, 0.38, 0.66], col.lightened(0.5))
		"knife":
			_poly(ci, r, [0.44, 0.56, 0.82, 0.12, 0.86, 0.2, 0.52, 0.62], col.lightened(0.25))
			_line(ci, r, 0.18, 0.84, 0.44, 0.58, dk.lightened(0.4), 0.12)
		"machete":
			_poly(ci, r, [0.4, 0.58, 0.78, 0.1, 0.9, 0.2, 0.88, 0.3, 0.5, 0.66], col.lightened(0.25))
			_line(ci, r, 0.16, 0.86, 0.42, 0.6, dk.lightened(0.4), 0.12)
		"bat":
			_poly(ci, r, [0.16, 0.9, 0.1, 0.84, 0.66, 0.16, 0.8, 0.1, 0.9, 0.2, 0.84, 0.34], col)
		"pipe":
			_line(ci, r, 0.16, 0.84, 0.84, 0.16, col, 0.13)
			_line(ci, r, 0.16, 0.84, 0.84, 0.16, dk, 0.04)
		"crowbar":
			_line(ci, r, 0.3, 0.86, 0.66, 0.2, col, 0.09)
			_ring(ci, r, 0.76, 0.24, 0.1, col, 0.09, PI, TAU)
			_line(ci, r, 0.3, 0.86, 0.18, 0.8, col, 0.09)
		"axe":
			_line(ci, r, 0.24, 0.9, 0.64, 0.14, dk.lightened(0.5), 0.1)
			_poly(ci, r, [0.54, 0.18, 0.86, 0.12, 0.9, 0.42, 0.66, 0.42], col)
		"sledge":
			_line(ci, r, 0.26, 0.9, 0.56, 0.3, dk.lightened(0.5), 0.1)
			_poly(ci, r, [0.3, 0.26, 0.6, 0.08, 0.84, 0.46, 0.56, 0.64], col)
		"spear":
			_line(ci, r, 0.14, 0.86, 0.7, 0.3, dk.lightened(0.5), 0.07)
			_poly(ci, r, [0.64, 0.26, 0.9, 0.1, 0.74, 0.36], col)
		"shovel":
			_line(ci, r, 0.64, 0.12, 0.42, 0.56, dk.lightened(0.5), 0.08)
			_poly(ci, r, [0.3, 0.52, 0.54, 0.62, 0.44, 0.86, 0.2, 0.78], col)
		"gun":
			_poly(ci, r, [0.12, 0.3, 0.86, 0.3, 0.86, 0.46, 0.5, 0.46, 0.46, 0.82, 0.3, 0.82, 0.32, 0.46, 0.12, 0.46], col)
		"rifle":
			_poly(ci, r, [0.06, 0.4, 0.94, 0.36, 0.94, 0.44, 0.5, 0.48, 0.34, 0.64, 0.12, 0.66, 0.06, 0.52], col)
		"bow":
			_ring(ci, r, 0.28, 0.5, 0.42, col, 0.07, -PI * 0.42, PI * 0.42)
			_line(ci, r, 0.58, 0.12, 0.58, 0.88, col.lightened(0.4), 0.025)
		"arrow":
			_line(ci, r, 0.14, 0.86, 0.8, 0.2, col, 0.05)
			_poly(ci, r, [0.72, 0.18, 0.9, 0.1, 0.82, 0.28], col)
		"ammo":
			for x in [0.26, 0.5, 0.74]:
				_rect(ci, r, x - 0.08, 0.4, x + 0.08, 0.86, col)
				_circ(ci, r, x, 0.4, 0.08, col.lightened(0.3))
		"cleaver":
			_poly(ci, r, [0.3, 0.18, 0.86, 0.18, 0.86, 0.5, 0.3, 0.56], col.lightened(0.25))
			_circ(ci, r, 0.76, 0.28, 0.04, dk)
			_line(ci, r, 0.14, 0.86, 0.34, 0.5, dk.lightened(0.4), 0.12)
		"knuckles":
			for x in [0.26, 0.42, 0.58, 0.74]:
				_ring(ci, r, x, 0.42, 0.08, col, 0.05)
			_poly(ci, r, [0.18, 0.54, 0.82, 0.54, 0.72, 0.8, 0.28, 0.8], col)
		"pickaxe":
			_line(ci, r, 0.5, 0.2, 0.5, 0.9, dk.lightened(0.5), 0.08)
			_poly(ci, r, [0.08, 0.34, 0.5, 0.14, 0.92, 0.34, 0.5, 0.24], col)
		"sickle":
			_ring(ci, r, 0.46, 0.44, 0.3, col, 0.08, PI * 1.05, PI * 2.2)
			_line(ci, r, 0.76, 0.52, 0.66, 0.9, dk.lightened(0.5), 0.1)
		"hoe":
			_line(ci, r, 0.2, 0.9, 0.7, 0.2, dk.lightened(0.5), 0.07)
			_poly(ci, r, [0.62, 0.14, 0.9, 0.2, 0.84, 0.44, 0.66, 0.28], col)
		"katana":
			_line(ci, r, 0.3, 0.72, 0.9, 0.1, col.lightened(0.3), 0.05)
			_line(ci, r, 0.12, 0.9, 0.3, 0.72, dk.lightened(0.3), 0.08)
			_line(ci, r, 0.22, 0.66, 0.36, 0.8, col, 0.06)
		"smg":
			_poly(ci, r, [0.1, 0.34, 0.9, 0.34, 0.9, 0.48, 0.56, 0.48, 0.52, 0.86, 0.4, 0.86, 0.44, 0.48, 0.1, 0.48], col)
			_rect(ci, r, 0.62, 0.48, 0.72, 0.78, col)
		"golf":
			_line(ci, r, 0.3, 0.1, 0.62, 0.8, col.lightened(0.3), 0.04)
			_poly(ci, r, [0.56, 0.78, 0.86, 0.78, 0.86, 0.9, 0.56, 0.9], col)
		"tireiron":
			_line(ci, r, 0.5, 0.12, 0.5, 0.88, col, 0.08)
			_line(ci, r, 0.12, 0.5, 0.88, 0.5, col, 0.08)
		"crossbow":
			_line(ci, r, 0.5, 0.16, 0.5, 0.9, dk.lightened(0.5), 0.08)
			_ring(ci, r, 0.5, 0.52, 0.34, col, 0.06, PI * 1.15, PI * 1.85)
			_line(ci, r, 0.2, 0.36, 0.8, 0.36, col.lightened(0.4), 0.02)
		"rock":
			_poly(ci, r, [0.2, 0.62, 0.3, 0.34, 0.54, 0.22, 0.78, 0.36, 0.84, 0.64, 0.62, 0.8, 0.34, 0.8], col)
		"molotov":
			_rect(ci, r, 0.44, 0.3, 0.56, 0.42, col)
			_rect(ci, r, 0.32, 0.42, 0.68, 0.9, col)
			_poly(ci, r, [0.5, 0.06, 0.6, 0.2, 0.56, 0.32, 0.44, 0.32, 0.4, 0.2], Color(1.0, 0.62, 0.2))
		"firework":
			_rect(ci, r, 0.4, 0.3, 0.6, 0.86, col)
			_poly(ci, r, [0.4, 0.3, 0.5, 0.12, 0.6, 0.3], col.lightened(0.3))
		# ---- materiais
		"plank":
			_poly(ci, r, [0.1, 0.3, 0.86, 0.2, 0.9, 0.36, 0.14, 0.46], col)
			_poly(ci, r, [0.1, 0.56, 0.86, 0.46, 0.9, 0.62, 0.14, 0.72], col.darkened(0.2))
		"nail":
			_line(ci, r, 0.5, 0.26, 0.5, 0.88, col, 0.07)
			_rect(ci, r, 0.32, 0.16, 0.68, 0.26, col)
		"gear":
			for i in 8:
				var a := TAU * i / 8.0
				var d := Vector2(cos(a), sin(a))
				ci.draw_line(_p(r, 0.5, 0.5) + d * r.size.x * 0.26, _p(r, 0.5, 0.5) + d * r.size.x * 0.42, col, r.size.x * 0.12)
			_circ(ci, r, 0.5, 0.5, 0.3, col)
			_circ(ci, r, 0.5, 0.5, 0.11, dk)
		"cloth":
			_poly(ci, r, [0.16, 0.24, 0.5, 0.3, 0.84, 0.22, 0.84, 0.78, 0.5, 0.72, 0.16, 0.8], col)
			_line(ci, r, 0.5, 0.3, 0.5, 0.72, dk, 0.03)
		"tape":
			_ring(ci, r, 0.5, 0.5, 0.26, col, 0.16)
		"rope":
			for rr in [0.34, 0.24, 0.14]:
				_ring(ci, r, 0.5, 0.5, rr, col, 0.06)
		# ---- equipamento
		"backpack":
			_rect(ci, r, 0.38, 0.1, 0.62, 0.2, dk.lightened(0.3))
			_poly(ci, r, [0.24, 0.3, 0.34, 0.18, 0.66, 0.18, 0.76, 0.3, 0.8, 0.88, 0.2, 0.88], col)
			_rect(ci, r, 0.32, 0.56, 0.68, 0.8, dk)
			_line(ci, r, 0.32, 0.56, 0.68, 0.56, col.lightened(0.3), 0.03)
		"jacket":
			_poly(ci, r, [0.36, 0.14, 0.5, 0.24, 0.64, 0.14, 0.9, 0.3, 0.84, 0.6, 0.74, 0.54, 0.74, 0.88, 0.26, 0.88, 0.26, 0.54, 0.16, 0.6, 0.1, 0.3], col)
			_line(ci, r, 0.5, 0.24, 0.5, 0.88, dk, 0.03)
		"vest":
			_poly(ci, r, [0.3, 0.14, 0.44, 0.14, 0.5, 0.3, 0.56, 0.14, 0.7, 0.14, 0.78, 0.36, 0.76, 0.88, 0.24, 0.88, 0.22, 0.36], col)
		"flashlight":
			_rect(ci, r, 0.12, 0.42, 0.56, 0.6, col)
			_poly(ci, r, [0.56, 0.36, 0.72, 0.28, 0.72, 0.74, 0.56, 0.66], col.lightened(0.2))
			for a in [-0.18, 0.0, 0.18]:
				_line(ci, r, 0.78, 0.51 + a * 0.5, 0.92, 0.51 + a, Color(1, 0.95, 0.7, col.a), 0.035)
		"battery":
			_rect(ci, r, 0.24, 0.22, 0.76, 0.86, col)
			_rect(ci, r, 0.4, 0.12, 0.6, 0.22, col.lightened(0.3))
			_poly(ci, r, [0.54, 0.32, 0.38, 0.58, 0.5, 0.58, 0.44, 0.78, 0.62, 0.5, 0.5, 0.5], dk)
		"radio":
			_rect(ci, r, 0.16, 0.34, 0.84, 0.84, col)
			_line(ci, r, 0.3, 0.34, 0.62, 0.1, col, 0.04)
			_circ(ci, r, 0.36, 0.6, 0.12, dk)
			_rect(ci, r, 0.56, 0.46, 0.76, 0.56, dk)
		"helmet":
			ci.draw_colored_polygon(_arc_poly(r, 0.5, 0.62, 0.34, PI, TAU), col)
			_rect(ci, r, 0.1, 0.6, 0.9, 0.7, col.lightened(0.2))
		"boot":
			_poly(ci, r, [0.3, 0.12, 0.56, 0.12, 0.56, 0.58, 0.86, 0.66, 0.88, 0.86, 0.28, 0.86], col)
			_rect(ci, r, 0.28, 0.8, 0.88, 0.88, dk.lightened(0.2))
		"glove":
			_rect(ci, r, 0.28, 0.44, 0.72, 0.88, col)
			for x in [0.3, 0.42, 0.54]:
				_rect(ci, r, x, 0.16, x + 0.1, 0.46, col)
			_poly(ci, r, [0.66, 0.5, 0.86, 0.38, 0.9, 0.46, 0.72, 0.66], col)
		"mask":
			_poly(ci, r, [0.18, 0.3, 0.82, 0.3, 0.78, 0.62, 0.5, 0.76, 0.22, 0.62], col)
			_circ(ci, r, 0.5, 0.74, 0.14, dk.lightened(0.3))
		# ---- combustível / história / estrutura
		"jerrycan":
			_poly(ci, r, [0.2, 0.26, 0.64, 0.26, 0.8, 0.4, 0.8, 0.9, 0.2, 0.9], col)
			_rect(ci, r, 0.28, 0.16, 0.56, 0.26, col)
			_rect(ci, r, 0.36, 0.2, 0.48, 0.26, dk)
			_line(ci, r, 0.3, 0.5, 0.7, 0.8, dk, 0.05)
			_line(ci, r, 0.7, 0.5, 0.3, 0.8, dk, 0.05)
		"document":
			_poly(ci, r, [0.22, 0.1, 0.64, 0.1, 0.8, 0.26, 0.8, 0.9, 0.22, 0.9], col)
			_poly(ci, r, [0.64, 0.1, 0.8, 0.26, 0.64, 0.26], dk.lightened(0.3))
			for y in [0.4, 0.52, 0.64, 0.76]:
				_line(ci, r, 0.32, y, 0.7, y, dk, 0.03)
		"book":
			_rect(ci, r, 0.2, 0.14, 0.8, 0.86, col)
			_rect(ci, r, 0.2, 0.14, 0.3, 0.86, dk)
			_line(ci, r, 0.4, 0.34, 0.7, 0.34, dk, 0.04)
		"photo":
			_rect(ci, r, 0.12, 0.2, 0.88, 0.8, col)
			_rect(ci, r, 0.18, 0.26, 0.82, 0.7, dk)
			_poly(ci, r, [0.2, 0.68, 0.42, 0.42, 0.56, 0.58, 0.66, 0.48, 0.8, 0.68], col.lightened(0.2))
		"cassette":
			_rect(ci, r, 0.1, 0.26, 0.9, 0.76, col)
			_circ(ci, r, 0.34, 0.48, 0.09, dk)
			_circ(ci, r, 0.66, 0.48, 0.09, dk)
			_rect(ci, r, 0.3, 0.62, 0.7, 0.76, dk.lightened(0.2))
		"card":
			_rect(ci, r, 0.12, 0.26, 0.88, 0.76, col)
			_rect(ci, r, 0.2, 0.36, 0.42, 0.62, dk)
			_line(ci, r, 0.5, 0.42, 0.8, 0.42, dk, 0.04)
			_line(ci, r, 0.5, 0.56, 0.74, 0.56, dk, 0.04)
		"key":
			_ring(ci, r, 0.3, 0.5, 0.16, col, 0.08)
			_line(ci, r, 0.44, 0.5, 0.88, 0.5, col, 0.08)
			_line(ci, r, 0.74, 0.5, 0.74, 0.66, col, 0.07)
			_line(ci, r, 0.86, 0.5, 0.86, 0.62, col, 0.07)
		"map":
			_poly(ci, r, [0.1, 0.24, 0.36, 0.14, 0.64, 0.24, 0.9, 0.14, 0.9, 0.76, 0.64, 0.86, 0.36, 0.76, 0.1, 0.86], col)
			_line(ci, r, 0.36, 0.14, 0.36, 0.76, dk, 0.03)
			_line(ci, r, 0.64, 0.24, 0.64, 0.86, dk, 0.03)
		"crate":
			_rect(ci, r, 0.14, 0.2, 0.86, 0.84, col)
			_line(ci, r, 0.14, 0.2, 0.86, 0.84, dk, 0.05)
			_line(ci, r, 0.86, 0.2, 0.14, 0.84, dk, 0.05)
		"trap":
			_ring(ci, r, 0.5, 0.56, 0.3, col, 0.07, PI, TAU)
			for x in [0.3, 0.44, 0.56, 0.7]:
				_line(ci, r, x, 0.56, x, 0.4, col, 0.04)
			_rect(ci, r, 0.14, 0.56, 0.86, 0.64, col)
		"bed":
			_rect(ci, r, 0.1, 0.5, 0.9, 0.7, col)
			_rect(ci, r, 0.14, 0.4, 0.34, 0.5, col.lightened(0.3))
			_line(ci, r, 0.12, 0.7, 0.12, 0.84, col, 0.05)
			_line(ci, r, 0.88, 0.7, 0.88, 0.84, col, 0.05)
		# ---- HUD
		"heart":
			_circ(ci, r, 0.34, 0.38, 0.2, col)
			_circ(ci, r, 0.66, 0.38, 0.2, col)
			_poly(ci, r, [0.15, 0.46, 0.85, 0.46, 0.5, 0.88], col)
		"wind":
			_line(ci, r, 0.1, 0.34, 0.66, 0.34, col, 0.08)
			_ring(ci, r, 0.66, 0.24, 0.1, col, 0.08, -PI * 0.5, PI * 0.5)
			_line(ci, r, 0.1, 0.56, 0.8, 0.56, col, 0.08)
			_line(ci, r, 0.2, 0.76, 0.6, 0.76, col, 0.08)
		"food":
			_line(ci, r, 0.34, 0.14, 0.34, 0.88, col, 0.08)
			for x in [0.24, 0.44]:
				_line(ci, r, x, 0.14, x, 0.36, col, 0.06)
			_line(ci, r, 0.24, 0.38, 0.44, 0.38, col, 0.06)
			_poly(ci, r, [0.64, 0.12, 0.74, 0.12, 0.76, 0.54, 0.72, 0.88, 0.66, 0.88, 0.66, 0.54], col)
		"drop":
			_poly(ci, r, [0.5, 0.1, 0.72, 0.46, 0.76, 0.62, 0.7, 0.78, 0.5, 0.88, 0.3, 0.78, 0.24, 0.62, 0.28, 0.46], col)
		"bolt":
			_poly(ci, r, [0.58, 0.08, 0.24, 0.56, 0.48, 0.56, 0.4, 0.92, 0.76, 0.42, 0.52, 0.42], col)
		"thermo":
			_line(ci, r, 0.5, 0.16, 0.5, 0.64, col, 0.14)
			_circ(ci, r, 0.5, 0.74, 0.16, col)
		"mind":
			_circ(ci, r, 0.5, 0.46, 0.3, col)
			_circ(ci, r, 0.4, 0.42, 0.05, dk)
			_circ(ci, r, 0.6, 0.42, 0.05, dk)
			_ring(ci, r, 0.5, 0.52, 0.14, dk, 0.05, 0.3, PI - 0.3)
		"sun":
			_circ(ci, r, 0.5, 0.5, 0.2, col)
			for i in 8:
				var a := TAU * i / 8.0
				ci.draw_line(_p(r, 0.5 + cos(a) * 0.3, 0.5 + sin(a) * 0.3), _p(r, 0.5 + cos(a) * 0.42, 0.5 + sin(a) * 0.42), col, maxf(1.0, r.size.x * 0.06), true)
		"moon":
			_circ(ci, r, 0.5, 0.5, 0.32, col)
			_circ(ci, r, 0.64, 0.4, 0.28, Color(0.06, 0.07, 0.08, 1.0))
		"cloud":
			_circ(ci, r, 0.36, 0.58, 0.18, col)
			_circ(ci, r, 0.56, 0.46, 0.22, col)
			_circ(ci, r, 0.72, 0.6, 0.16, col)
			_rect(ci, r, 0.36, 0.58, 0.72, 0.76, col)
		"rain":
			draw_glyph(ci, "cloud", Rect2(r.position, r.size * Vector2(1, 0.75)), col)
			for x in [0.34, 0.52, 0.7]:
				_line(ci, r, x, 0.66, x - 0.06, 0.9, Color(0.55, 0.75, 1.0, col.a), 0.05)
		"fog":
			for y in [0.34, 0.5, 0.66]:
				_line(ci, r, 0.14, y, 0.86, y, col, 0.07)
		"eye":
			var top := _arc_poly(r, 0.5, 0.86, 0.5, PI * 1.22, PI * 1.78)
			var bot := _arc_poly(r, 0.5, 0.14, 0.5, PI * 0.22, PI * 0.78)
			top.remove_at(top.size() - 1)   # cantos compartilhados: sem ponto repetido
			bot.remove_at(bot.size() - 1)
			ci.draw_colored_polygon(top + bot, col)
			_circ(ci, r, 0.5, 0.5, 0.12, dk)
		"target":
			_ring(ci, r, 0.5, 0.5, 0.32, col, 0.06)
			_circ(ci, r, 0.5, 0.5, 0.08, col)
		"star":
			var pts := PackedVector2Array()
			for i in 10:
				var a := -PI * 0.5 + TAU * i / 10.0
				var rr := 0.42 if i % 2 == 0 else 0.18
				pts.append(_p(r, 0.5 + cos(a) * rr, 0.52 + sin(a) * rr))
			ci.draw_colored_polygon(pts, col)
		"check":
			_line(ci, r, 0.18, 0.52, 0.42, 0.76, col, 0.1)
			_line(ci, r, 0.42, 0.76, 0.84, 0.26, col, 0.1)
		"people":
			_circ(ci, r, 0.36, 0.34, 0.12, col)
			_circ(ci, r, 0.66, 0.36, 0.1, col.darkened(0.2))
			ci.draw_colored_polygon(_arc_poly(r, 0.36, 0.84, 0.24, PI, TAU), col)
			ci.draw_colored_polygon(_arc_poly(r, 0.66, 0.84, 0.2, PI, TAU), col.darkened(0.2))
		"flag":
			_line(ci, r, 0.26, 0.1, 0.26, 0.9, col, 0.06)
			_poly(ci, r, [0.26, 0.14, 0.84, 0.26, 0.26, 0.5], col)
		_:
			_rect(ci, r, 0.2, 0.26, 0.8, 0.84, col)
			_poly(ci, r, [0.2, 0.26, 0.5, 0.12, 0.8, 0.26], col.lightened(0.25))


static func _arc_poly(r: Rect2, cx: float, cy: float, rad: float, a0: float, a1: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := 14
	for i in n + 1:
		var a := lerpf(a0, a1, float(i) / n)
		out.append(_p(r, cx + cos(a) * rad, cy + sin(a) * rad))
	return out
