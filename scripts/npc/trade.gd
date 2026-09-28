class_name Trade
extends RefCounted
## Regras de troca (escambo): cada item tem um valor; a atitude da facção,
## a relação pessoal e a condição do item alteram o preço.


static func price_mult(npc: SurvivorNPC, manager: SurvivorManager, buying: bool) -> float:
	var att := npc.attitude()
	var m := 1.0
	match att:
		"friendly": m = 0.85
		"neutral": m = 1.0
		"wary": m = 1.3
		_: m = 2.0
	if manager:
		m -= clampf(manager.rel(npc.npc_id) / 400.0, -0.2, 0.15)
	return m if buying else 1.0 / (m * 1.25)


static func stack_value(s: Dictionary) -> float:
	var v := ItemDB.value(str(s["id"])) * int(s.get("qty", 1))
	if ItemDB.has_durability(str(s["id"])):
		v *= lerpf(0.3, 1.0, float(s.get("cond", 1.0)))
	return v


## Preço de uma unidade que o jogador compra do NPC.
static func buy_price(s: Dictionary, npc: SurvivorNPC, manager: SurvivorManager) -> float:
	var one := s.duplicate()
	one["qty"] = 1
	return maxf(1.0, stack_value(one) * price_mult(npc, manager, true))


## Quanto o NPC paga por uma unidade vendida pelo jogador.
static func sell_price(s: Dictionary, npc: SurvivorNPC, manager: SurvivorManager) -> float:
	var one := s.duplicate()
	one["qty"] = 1
	if ItemDB.get_item(str(s["id"])).get("story", false):
		return 0.0
	return stack_value(one) * price_mult(npc, manager, false)


## Executa uma troca: oferta do jogador (índice -> qtd) por pedido do NPC.
static func execute(player: Player, npc: SurvivorNPC, manager: SurvivorManager, give: Dictionary, take: Dictionary) -> bool:
	var give_v := 0.0
	var take_v := 0.0
	for i in give.keys():
		var s: Dictionary = player.inventory.stacks[int(i)]
		give_v += sell_price(s, npc, manager) * int(give[i])
	for i in take.keys():
		var s: Dictionary = npc.trade_inv.stacks[int(i)]
		take_v += buy_price(s, npc, manager) * int(take[i])
	if give_v + 0.01 < take_v:
		return false
	# remove de trás para frente para não invalidar índices
	var gk := give.keys()
	gk.sort()
	gk.reverse()
	var moved_to_npc: Array = []
	for i in gk:
		moved_to_npc.append(player.inventory.remove_stack_at(int(i), int(give[i])))
	var tk := take.keys()
	tk.sort()
	tk.reverse()
	for i in tk:
		var s := npc.trade_inv.remove_stack_at(int(i), int(take[i]))
		player.inventory.add_stack(s, true)
	for s in moved_to_npc:
		npc.trade_inv.add_stack(s, true)
	if manager:
		manager.change_rel(npc.npc_id, 3.0 + (give_v - take_v) * 0.3)
	if npc.faction != "" and give_v > take_v * 1.5 and give_v > 10.0:
		FactionManager.change_rep(npc.faction, 2.0)
	AudioManager.play_ui("pickup", -4.0)
	EventBus.toast("Troca realizada.", "good")
	return true
