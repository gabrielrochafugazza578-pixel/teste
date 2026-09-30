class_name ShaderGlobals
extends RefCounted
## Espelho em GDScript dos uniforms globais de shader.
## (RenderingServer.global_shader_parameter_get é proibido fora do editor.)

static var values: Dictionary = {
	"wetness": 0.0, "world_decay": 1.0, "veg_growth": 1.0, "city_power": 0.0,
	"blackout_origin": Vector3.ZERO, "blackout_radius": 0.0, "rain_intensity": 0.0, "daylight": 1.0,
}


static func set_value(name: String, value: Variant) -> void:
	values[name] = value
	RenderingServer.global_shader_parameter_set(name, value)


static func get_value(name: String, default: Variant = 0.0) -> Variant:
	return values.get(name, default)
