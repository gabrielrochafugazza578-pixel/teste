extends Node3D
## Depuração: trilha de métodos do AnimationPlayer.
var calls := 0
func _ev(a: int, b: int, c: int) -> void:
	calls += 1
	print("chamado ", a, b, c)
func _ready() -> void:
	var sh := {"id": "t", "dur": 1.0, "cam": [[0.0, [0, 0, 0], [0, 0, 1], 60], [1.0, [1, 0, 0], [0, 0, 1], 60]], "events": [[0.2, "x"], [0.5, "y"]]}
	var an := CinematicDirector.build_shot(sh, 1, 2)
	var r := Node3D.new(); r.name = "Anchor"; add_child(r)
	var rig := Node3D.new(); rig.name = "Rig"; r.add_child(rig)
	var lk := Node3D.new(); lk.name = "Look"; r.add_child(lk)
	var ap := AnimationPlayer.new()
	add_child(ap)
	ap.root_node = NodePath("..")
	var lib := AnimationLibrary.new()
	lib.add_animation("t", an)
	ap.add_animation_library("x", lib)
	ap.play("x/t")
	await get_tree().create_timer(1.5).timeout
	print("calls=", calls, " rig=", rig.position)
	get_tree().quit()
