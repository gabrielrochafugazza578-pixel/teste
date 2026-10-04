// Folha solta caindo (partícula): recorte alfa, cor da partícula (COLOR) e
// normal "para cima" — iluminada como as folhas do chão, sem ficar preta quando
// o verso gira para a câmera contra o céu.
shader_type spatial;
render_mode cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform sampler2D tex : source_color, filter_linear_mipmap, repeat_disable;

void fragment() {
	vec4 c = texture(tex, UV);
	if (c.a < 0.5) {
		discard;
	}
	ALBEDO = c.rgb * COLOR.rgb;
	NORMAL = normalize((VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz);
	ROUGHNESS = 0.85;
}
