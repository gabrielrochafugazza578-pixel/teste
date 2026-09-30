extends Node
## Relógio: 24 h de jogo = 48 min reais (1 h de jogo = 2 min reais), mesmo com FPS baixo.
## Uso: godot --headless --path . res://tests/clock_test.tscn

func _ready() -> void:
	GameState.in_game = true
	Settings.gameplay["day_length_minutes"] = 48.0
	TimeManager.set_time(10.0, 1)
	TimeManager.running = true
	# simula FPS muito baixo: 4 quadros por segundo
	Engine.max_fps = 4
	var t0 := Time.get_ticks_msec()
	var h0 := TimeManager.hour
	await get_tree().create_timer(12.0, true, false, true).timeout
	var real_s := (Time.get_ticks_msec() - t0) / 1000.0
	var game_min := (TimeManager.hour - h0) * 60.0
	var esperado := real_s * 24.0 * 60.0 / (48.0 * 60.0)
	print("RELOGIO: %.1f s reais -> %.2f min de jogo (esperado %.2f)" % [real_s, game_min, esperado])
	print("RELOGIO_OK" if absf(game_min - esperado) < 0.05 * esperado + 0.05 else "RELOGIO_FALHOU")
	get_tree().quit()
