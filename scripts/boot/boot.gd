extends Node
## Boot: aplica configurações, gera texturas PBR na GPU (uma vez por
## qualidade) e sintetiza/carrega o áudio do cache; depois abre o menu.
## Argumentos: --skip-menu (vai direto para um novo jogo), --load=<slot>.

var loading: LoadingScreen


func _ready() -> void:
	var cl := CanvasLayer.new()
	add_child(cl)
	loading = LoadingScreen.new()
	cl.add_child(loading)
	UITheme.apply_scale(get_tree())
	await get_tree().process_frame
	loading.set_progress(0.05, "Gerando texturas (%d px)…" % Settings.get_texture_size())
	await Assets.bake_all()
	loading.set_progress(0.4, "Sintetizando sons…")
	AudioManager.generate_async()
	while AudioManager.generating:
		loading.set_progress(0.4 + AudioManager.progress * 0.5, "Sintetizando sons… %d%%" % int(AudioManager.progress * 100.0))
		await get_tree().process_frame
	if not AudioManager.is_ready:
		await AudioManager.audio_ready
	loading.set_progress(0.95, "Preparando malhas…")
	await get_tree().process_frame
	PropLib.warm()
	loading.set_progress(1.0, "Pronto.")
	await get_tree().process_frame
	var args := OS.get_cmdline_user_args()
	for a in args:
		if a.begins_with("--load="):
			SaveManager.load_game(a.substr(7))
			return
	if args.has("--skip-menu"):
		GameState.start_mode = "new"
		GameState.skip_opening = args.has("--skip-opening")
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")
		return
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
