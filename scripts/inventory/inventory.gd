class_name Inventory
extends RefCounted
## Inventário com capacidade limitada por PESO e por ESPAÇOS.
## Pilha = {"id", "qty", "cond" (0..1: durabilidade/frescor), "data" {}}.
## Usado pelo jogador (bolsos + mochila), contêineres, veículos e esconderijos.

signal changed

var owner_id: String = ""
var title: String = ""
var max_weight: float = 8.0
var max_slots: int = 8
var stacks: Array = []


func _init(id: String = "", weight_cap: float = 8.0, slots: int = 8, title_: String = "") -> void:
	owner_id = id
	max_weight = weight_cap
	max_slots = slots
	title = title_


static func make_stack(id: String, qty: int = 1, cond: float = 1.0, data: Dictionary = {}) -> Dictionary:
	return {"id": id, "qty": qty, "cond": cond, "data": data.duplicate(true)}


func total_weight() -> float:
	var w := 0.0
	for s in stacks:
		w += ItemDB.weight(s["id"]) * int(s["qty"]) + _extra_weight(s)
	return w


func _extra_weight(s: Dictionary) -> float:
	var d: Dictionary = s.get("data", {})
	if d.has("fuel"):
		return float(d["fuel"]) * 0.75
	return 0.0


func free_weight() -> float:
	return max_weight - total_weight()


func count(id: String) -> int:
	var n := 0
	for s in stacks:
		if s["id"] == id:
			n += int(s["qty"])
	return n


func has(id: String, qty: int = 1) -> bool:
	return count(id) >= qty


func find(id: String) -> Dictionary:
	for s in stacks:
		if s["id"] == id:
			return s
	return {}


func index_of(stack: Dictionary) -> int:
	return stacks.find(stack)


## Quantos cabem (por peso e espaços).
func can_fit(id: String, qty: int) -> int:
	var w := ItemDB.weight(id)
	var by_weight := qty if w <= 0.0001 else int(floor(free_weight() / w + 0.0001))
	var ms := ItemDB.max_stack(id)
	var space := 0
	for s in stacks:
		if s["id"] == id and not ItemDB.has_durability(id):
			space += ms - int(s["qty"])
	space += (max_slots - stacks.size()) * ms
	return clampi(mini(by_weight, space), 0, qty)


## Adiciona; retorna a quantidade que NÃO coube.
func add(id: String, qty: int = 1, cond: float = 1.0, data: Dictionary = {}, force: bool = false) -> int:
	if not ItemDB.exists(id) or qty <= 0:
		return qty
	var fit := qty if force else can_fit(id, qty)
	var left := fit
	var ms := ItemDB.max_stack(id)
	if not ItemDB.has_durability(id) and data.is_empty():
		for s in stacks:
			if left <= 0:
				break
			if s["id"] == id and int(s["qty"]) < ms and (s.get("data", {}) as Dictionary).is_empty():
				var room := ms - int(s["qty"])
				var put := mini(room, left)
				# frescor médio ponderado
				s["cond"] = (float(s["cond"]) * int(s["qty"]) + cond * put) / float(int(s["qty"]) + put)
				s["qty"] = int(s["qty"]) + put
				left -= put
	while left > 0 and (stacks.size() < max_slots or force):
		var put := mini(ms, left)
		stacks.append(make_stack(id, put, cond, data))
		left -= put
	if fit > 0:
		changed.emit()
		EventBus.inventory_changed.emit(owner_id)
	return qty - fit + left


func add_stack(s: Dictionary, force: bool = false) -> int:
	return add(s["id"], int(s["qty"]), float(s.get("cond", 1.0)), s.get("data", {}), force)


## Remove; retorna quanto foi removido. Consome primeiro as pilhas mais velhas.
func remove(id: String, qty: int = 1) -> int:
	var removed := 0
	for i in range(stacks.size() - 1, -1, -1):
		if removed >= qty:
			break
		var s: Dictionary = stacks[i]
		if s["id"] != id:
			continue
		var take := mini(int(s["qty"]), qty - removed)
		s["qty"] = int(s["qty"]) - take
		removed += take
		if int(s["qty"]) <= 0:
			stacks.remove_at(i)
	if removed > 0:
		changed.emit()
		EventBus.inventory_changed.emit(owner_id)
	return removed


func remove_stack_at(index: int, qty: int = -1) -> Dictionary:
	if index < 0 or index >= stacks.size():
		return {}
	var s: Dictionary = stacks[index]
	var n := int(s["qty"]) if qty < 0 else mini(qty, int(s["qty"]))
	var out := make_stack(s["id"], n, float(s["cond"]), s.get("data", {}))
	s["qty"] = int(s["qty"]) - n
	if int(s["qty"]) <= 0:
		stacks.remove_at(index)
	changed.emit()
	EventBus.inventory_changed.emit(owner_id)
	return out


## Transfere a pilha `index` para outro inventário; retorna qtd movida.
func transfer_to(other: Inventory, index: int, qty: int = -1) -> int:
	if index < 0 or index >= stacks.size():
		return 0
	var s: Dictionary = stacks[index]
	var n := int(s["qty"]) if qty < 0 else mini(qty, int(s["qty"]))
	var fit := other.can_fit(s["id"], n)
	if fit <= 0:
		return 0
	var moved := remove_stack_at(index, fit)
	other.add_stack(moved)
	return fit


## Desgasta um item com durabilidade (armas/ferramentas). Retorna true se quebrou.
func wear(stack: Dictionary, amount: float) -> bool:
	if stack.is_empty():
		return false
	stack["cond"] = maxf(0.0, float(stack["cond"]) - amount)
	changed.emit()
	if float(stack["cond"]) <= 0.0:
		var idx := stacks.find(stack)
		if idx >= 0:
			stacks.remove_at(idx)
			EventBus.toast("%s quebrou!" % ItemDB.item_name(stack["id"]), "warn")
			changed.emit()
			EventBus.inventory_changed.emit(owner_id)
		return true
	return false


func find_tool(tool_tag: String) -> Dictionary:
	for s in stacks:
		var def := ItemDB.get_item(s["id"])
		if def.has("tool") and tool_tag in (def["tool"] as Array):
			return s
	return {}


func clear() -> void:
	stacks.clear()
	changed.emit()


func to_data() -> Dictionary:
	return {"id": owner_id, "w": max_weight, "slots": max_slots, "stacks": stacks.duplicate(true)}


func from_data(d: Dictionary) -> void:
	owner_id = str(d.get("id", owner_id))
	max_weight = float(d.get("w", max_weight))
	max_slots = int(d.get("slots", max_slots))
	stacks = []
	for s in d.get("stacks", []):
		var st: Dictionary = s
		st["qty"] = int(st.get("qty", 1))
		stacks.append(st)
	changed.emit()


## Ordena por categoria e nome (botão "organizar").
func sort_items() -> void:
	stacks.sort_custom(func(a, b):
		var ca := ItemDB.category(a["id"])
		var cb := ItemDB.category(b["id"])
		if ca == cb:
			return ItemDB.item_name(a["id"]) < ItemDB.item_name(b["id"])
		return ca < cb)
	changed.emit()
