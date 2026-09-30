class_name Crafting
extends RefCounted
## Regras de fabricação: verificação de ingredientes/ferramentas/estação,
## consumo, desgaste de ferramentas e reparos de equipamento.


static func station_ok(r: Dictionary, station: String) -> bool:
	var need: String = r.get("station", "")
	if need == "":
		return true
	if need == "workbench":
		return station == "workbench"
	if need == "fire":
		return station == "fire"
	return false


## Retorna {"ok": bool, "missing": [texto], "tools_missing": [tag]}
static func check(r: Dictionary, player: Player, station: String) -> Dictionary:
	var missing: Array = []
	for e in r.get("in", []):
		var id: String = e[0]
		var n := int(e[1])
		var have := player.inventory.count(id)
		if have < n:
			missing.append("%s (%d/%d)" % [ItemDB.item_name(id), have, n])
	var tools_missing: Array = []
	for t in r.get("tools", []):
		if not player.has_tool(str(t)):
			tools_missing.append(str(t))
	var ok := missing.is_empty() and tools_missing.is_empty() and station_ok(r, station)
	if r.has("repair") and ok:
		ok = _repair_target(r, player).size() > 0
	return {"ok": ok, "missing": missing, "tools_missing": tools_missing, "station_ok": station_ok(r, station)}


static func tool_name(tag: String) -> String:
	match tag:
		"hammer": return "Martelo"
		"saw": return "Serrote"
		"cut": return "Lâmina (faca/facão)"
		"wrench": return "Chave inglesa"
		"screw": return "Chave de fenda"
		"pliers": return "Alicate"
		"pry": return "Pé de cabra"
		"siphon": return "Mangueira"
		"mechanic": return "Kit de ferramentas"
	return tag


static func _repair_target(r: Dictionary, player: Player) -> Dictionary:
	match str(r["repair"]):
		"weapon":
			var w: Dictionary = player.equipment["weapon"]
			if not w.is_empty() and float(w.get("cond", 1.0)) < 0.98:
				return w
		"torso":
			var t: Dictionary = player.equipment["torso"]
			if not t.is_empty() and float(t.get("cond", 1.0)) < 0.98:
				return t
		"tool":
			for s in player.inventory.stacks:
				var d := ItemDB.get_item(str(s["id"]))
				if d.has("tool") and float(s.get("cond", 1.0)) < 0.9:
					return s
	return {}


static func craft(id: String, player: Player, station: String) -> bool:
	var r := CraftingDB.get_recipe(id)
	if r.is_empty():
		return false
	var c := check(r, player, station)
	if not c["ok"]:
		return false
	for e in r.get("in", []):
		player.inventory.remove(str(e[0]), int(e[1]))
	for t in r.get("tools", []):
		player.use_tool(str(t), 0.03)
	if r.has("repair"):
		var target := _repair_target(r, player)
		target["cond"] = minf(1.0, float(target.get("cond", 1.0)) + float(r.get("amount", 0.4)))
		EventBus.toast("%s reparado (%d%%)." % [ItemDB.item_name(str(target["id"])), int(float(target["cond"]) * 100.0)], "good")
	else:
		var res: Array = r["result"]
		player.inventory.add(str(res[0]), int(res[1]), 1.0, {}, true)
		EventBus.item_crafted.emit(str(res[0]), int(res[1]))
		EventBus.toast("Fabricado: %s x%d" % [ItemDB.item_name(str(res[0])), int(res[1])], "good")
	GameState.add_stat("crafted")
	AudioManager.play_3d("craft", player.global_position, -2.0)
	EventBus.make_noise(player.global_position, 6.0, player, &"craft")
	return true
