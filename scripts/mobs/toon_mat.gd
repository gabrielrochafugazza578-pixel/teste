class_name ToonMat
## Materiais cartoon (com cache) para bichos, mao do jogador e efeitos.

static var _cache: Dictionary = {}
static var _shader: Shader


static func get_mat(color: Color, emission := Color(0, 0, 0), strength := 0.0) -> ShaderMaterial:
	var key := "%s|%s|%.2f" % [color.to_html(), emission.to_html(), strength]
	if _cache.has(key):
		return _cache[key]
	if _shader == null:
		_shader = load("res://shaders/creature.gdshader")
	var m := ShaderMaterial.new()
	m.shader = _shader
	m.set_shader_parameter("albedo", color)
	m.set_shader_parameter("emission_color", emission)
	m.set_shader_parameter("emission_strength", strength)
	_cache[key] = m
	return m
