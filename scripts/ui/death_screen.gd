class_name DeathScreen
extends Control
## Tela de morte: causa, dias sobrevividos e opções.

var cause: String = ""


func _ready() -> void:
	theme = UITheme.get_theme()
	UIKit.full_rect(self)
	process_mode = Node.PROCESS_MODE_ALWAYS
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.0, 0.0, 0.0)
	UIKit.full_rect(bg)
	add_child(bg)
	create_tween().tween_property(bg, "color:a", 0.88, 2.5)
	var v := UIKit.vbox(12)
	v.modulate.a = 0.0
	v.add_child(UIKit.label("VOCÊ MORREU", 54, UITheme.DANGER, HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(UIKit.label(_cause_text(), 20, UITheme.TEXT, HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(UIKit.label("Sobreviveu %d dias em Santa Aurora." % TimeManager.day, 16, UITheme.TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(UIKit.spacer(24))
	var latest := SaveManager.latest_slot()
	var b1 := UIKit.button("Carregar último salvamento", func() -> void: SaveManager.load_game(latest), 360)
	b1.disabled = latest == ""
	v.add_child(b1)
	v.add_child(UIKit.button("Menu principal", func() -> void:
		get_tree().paused = false
		GameState.in_game = false
		AudioManager.stop_all_loops()
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn"), 360))
	add_child(UIKit.center(v))
	var tw := create_tween()
	tw.tween_interval(1.8)
	tw.tween_property(v, "modulate:a", 1.0, 1.2)
	tw.tween_callback(func() -> void: b1.grab_focus())
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _cause_text() -> String:
	match cause:
		"hunger": return "Você morreu de fome."
		"thirst": return "Você morreu de desidratação."
		"cold": return "O frio levou você."
		"bleeding": return "Você sangrou até a morte."
		"infection": return "O NEXUS venceu. Você virou um deles."
		"bite", "scratch": return "Os infectados foram mais rápidos."
		"bullet": return "Você foi baleado."
		"drown": return "Você se afogou."
		"fall", "heavy": return "Um impacto fatal."
	return "Santa Aurora cobrou o seu preço."
