extends Node3D
## Depuração: dirigir um veículo num piso plano.
func _ready() -> void:
	InputSetup.register_all({})
	var floor_b := StaticBody3D.new()
	var cs := CollisionShape3D.new()
	var bx := BoxShape3D.new()
	bx.size = Vector3(400, 1, 400)
	cs.shape = bx
	floor_b.add_child(cs)
	floor_b.position = Vector3(0, -0.5, 0)
	add_child(floor_b)
	var v := Vehicle.new()
	add_child(v)
	v.setup({"id": "t", "type": "police", "pos": Vector3(0, 0.3, 0), "yaw": 0.0, "fuel": 20.0, "engine": 0.8, "battery": true})
	for i in 60:
		await get_tree().physics_frame
	v.driver = Player.new()
	v.engine_on = true
	Input.action_press("move_forward")
	for i in 240:
		await get_tree().physics_frame
		if i % 40 == 0:
			var hits := 0
			for w in v._wheels:
				if float(w["comp"]) > 0.0:
					hits += 1
			print("t=%d vel=%.1f km/h y=%.3f pos=%s thr=%.2f rodas_c=%d" % [i, v.speed_kmh, v.global_position.y, str(v.global_position.snapped(Vector3.ONE * 0.1)), v.throttle, hits])
	Input.action_release("move_forward")
	get_tree().quit()
