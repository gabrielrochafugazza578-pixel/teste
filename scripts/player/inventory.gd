class_name Inventory
extends RefCounted
## Inventario simples de materiais + barra de atalhos (hotbar).

signal changed

## Materiais da barra (teclas 1..9 e 0)
const HOTBAR: Array[int] = [Mats.GRASS, Mats.DIRT, Mats.STONE, Mats.SAND, Mats.WOOD,
	Mats.LEAVES, Mats.BRICK, Mats.CRYSTAL, Mats.CLAY, Mats.SNOW]

var counts: Dictionary = {}
var selected := 0
var creative := false


func _init() -> void:
	for m in HOTBAR:
		counts[m] = 0
	counts[Mats.DIRT] = 24
	counts[Mats.WOOD] = 16
	counts[Mats.BRICK] = 32
	counts[Mats.STONE] = 12
	counts[Mats.CRYSTAL] = 6


## Materiais parecidos viram o mesmo item (ex.: grama da floresta -> grama).
static func item_for(mat: int) -> int:
	match mat:
		Mats.FOREST_GRASS, Mats.MAGIC_GRASS:
			return Mats.GRASS
	return mat


func add(mat: int, amount := 1) -> void:
	var it := item_for(mat)
	if it <= Mats.AIR:
		return
	counts[it] = counts.get(it, 0) + amount
	changed.emit()


func selected_material() -> int:
	return HOTBAR[selected]


func can_place() -> bool:
	return creative or counts.get(selected_material(), 0) > 0


func consume_selected() -> void:
	if creative:
		return
	var m := selected_material()
	counts[m] = maxi(0, counts.get(m, 0) - 1)
	changed.emit()


func select(i: int) -> void:
	selected = posmod(i, HOTBAR.size())
	changed.emit()
