extends Node
## Captura o menu principal, configurações e a tela de carregar.
## Uso: xvfb-run godot --path . --rendering-driver opengl3 res://tests/menu_test.tscn -- --out=/tmp/x

var out_dir := "user://shots"

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--out="):
			out_dir = a.substr(6)
	DirAccess.make_dir_recursive_absolute(out_dir)
	await Assets.bake_all()
	var menu: Control = (load("res://scenes/menu/main_menu.tscn") as PackedScene).instantiate()
	add_child(menu)
	await _wait(1.5)
	await _snap("menu_principal")
	menu._open_settings()
	await _wait(0.6)
	await _snap("menu_config_graficos")
	var sm := menu._sub as SettingsMenu
	sm.tabs.current_tab = 3
	await _wait(0.3)
	await _snap("menu_config_acessibilidade")
	sm.close()
	await _wait(0.3)
	menu._open_load()
	await _wait(0.5)
	await _snap("menu_carregar")
	get_tree().quit()


func _wait(t: float) -> void:
	await get_tree().create_timer(t).timeout


func _snap(n: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(out_dir + "/" + n + ".png")
	print("snap ", n)
