extends "res://tests/gallery_driver.gd"
## Fotos das telas do jogo (todas as abas) + checagem dos botões do HUD.
## Uso: xvfb-run godot --path . res://tests/ui.tscn -- --no-audio --out=/tmp/ui


func _gallery() -> void:
	var av := g.layout.poi_pos("avenida_central")
	await _go(av + Vector3(4, 0, 30), av + Vector3(4, 0, 0), 10.0, WeatherManager.State.CLEAR)
	var p := g.player
	p._invuln = 9999.0
	# mochila variada para as fotos
	for e in [["faca_tatica", 1], ["lata_feijao", 3], ["agua_garrafa", 2], ["bandagem", 4], ["kit_primeiros_socorros", 1], ["tabua", 6],
			["pregos", 20], ["fita_adesiva", 2], ["pano", 3], ["pilha", 4], ["taco_beisebol", 1], ["cha_ervas", 1], ["pedra", 3]]:
		p.inventory.add(str(e[0]), int(e[1]))
	p.equipment["weapon"] = Inventory.make_stack("cano_ferro", 1, 0.7)
	p._update_weapon_visual()
	p.quick_slots = ["bandagem", "agua_garrafa", "lata_feijao", "faca_tatica"]
	p.survival.hunger = 38.0
	p.survival.thirst = 22.0
	p.survival.health = 64.0
	EventBus.toast("Você encontrou: Kit de primeiros socorros", "good")
	EventBus.toast("Barulho atraiu infectados!", "warn")
	await _wait(0.6)
	await _shot("hud")
	# botão Mochila do HUD (mesmo sinal do clique)
	EventBus.hud_menu_requested.emit("inventory")
	await _wait(0.6)
	_log("BOTAO_MOCHILA abriu=%s" % str(g.ui.current is InventoryScreen))
	var inv := g.ui.current as InventoryScreen
	if inv:
		await _shot("inv_equipamento")
		inv.right_tabs.current_tab = 2
		await _wait(0.4)
		await _shot("inv_fabricacao")
		inv.right_tabs.current_tab = 3
		await _wait(0.4)
		await _shot("inv_condicao")
		inv._filter = 2
		inv._refresh()
		await _wait(0.3)
		await _shot("inv_filtro_medico")
		inv.close()
	await _wait(0.4)
	# contêiner aberto
	var box := Inventory.new("teste_caixa", 20.0, 12, "Armário")
	for e in [["antibiotico", 1], ["lanterna", 1], ["corda", 1], ["lata_milho", 2], ["municao_38", 12]]:
		box.add(str(e[0]), int(e[1]))
	g.ui.open_inventory(box, "Armário", null, "")
	await _wait(0.6)
	await _shot("inv_conteiner")
	if g.ui.current:
		g.ui.current.queue_free()
	await _wait(0.4)
	# diário
	EventBus.hud_menu_requested.emit("journal")
	await _wait(0.6)
	_log("BOTAO_DIARIO abriu=%s" % str(g.ui.current is JournalScreen))
	var j := g.ui.current as JournalScreen
	if j:
		await _shot("diario_missoes")
		for t in [[1, "diario_progresso"], [5, "diario_faccoes"]]:
			j.tabs.current_tab = int(t[0])
			await _wait(0.4)
			await _shot(str(t[1]))
		j.close()
	await _wait(0.4)
	EventBus.hud_menu_requested.emit("map")
	await _wait(0.6)
	_log("BOTAO_MAPA abriu=%s" % str(g.ui.current is MapScreen))
	if g.ui.current:
		g.ui.current.queue_free()
	await _wait(0.4)
	# pausa
	var pm := PauseMenu.new()
	pm.game = g
	g.ui.open(pm, true)
	await _wait(0.6)
	await _shot("pausa")
	pm.queue_free()
	await _wait(0.4)
