extends SceneTree
## Gera cinematics/opening_library.tres a partir de cinematics/opening.json.
## A biblioteca pode ser aberta/editada no editor (AnimationPlayer da cena
## scenes/cinematics/opening_cinematic.tscn). Se existir, o jogo usa ela.
## Uso: godot --headless --path . -s tools/bake_cinematic.gd

func _init() -> void:
	var txt := FileAccess.get_file_as_string("res://cinematics/opening.json")
	var d = JSON.parse_string(txt)
	if typeof(d) != TYPE_DICTIONARY:
		push_error("JSON inválido")
		quit(1)
		return
	var lib: AnimationLibrary = load("res://scripts/cinematics/cinematic_director.gd").build_library(d)
	var err := ResourceSaver.save(lib, "res://cinematics/opening_library.tres")
	print("Biblioteca gerada: %d tomadas (erro=%d)" % [lib.get_animation_list().size(), err])
	quit(0 if err == OK else 1)
