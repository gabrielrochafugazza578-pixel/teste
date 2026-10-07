// Terreno distante de baixa resolução (mapa inteiro, 32 m por célula).
// Descartado dentro dos chunks carregados; cor por vértice (bioma) com
// variação de ruído para não parecer um tapete liso visto da serra.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D chunk_mask : filter_nearest, repeat_disable;
uniform vec2 mask_origin = vec2(-1536.0);
uniform float mask_scale = 0.00032552;
global uniform float veg_growth;
// a mesma foto aérea do terreno de perto (manchas de campo de verdade)
uniform sampler2D macro_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform bool has_macro = false;

varying vec3 w_pos;

float hash21(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash21(i), hash21(i + vec2(1.0, 0.0)), f.x), mix(hash21(i + vec2(0.0, 1.0)), hash21(i + vec2(1.0, 1.0)), f.x), f.y);
}

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	if (texture(chunk_mask, (w_pos.xz - mask_origin) * mask_scale).r > 0.5) {
		discard;
	}
	vec3 base = COLOR.rgb;
	float forest = COLOR.a;   // 1 = mata fechada
	float n = vnoise(w_pos.xz * 0.06) * 0.6 + vnoise(w_pos.xz * 0.23) * 0.4;
	// copas: manchas escuras e claras
	base *= mix(0.9 + n * 0.2, 0.62 + n * 0.55, forest);
	base = mix(base, base * vec3(0.9, 1.08, 0.85), forest * (veg_growth - 1.0) * 0.3);
	if (has_macro) {
		vec2 uv = w_pos.xz;
		vec3 m1 = texture(macro_tex, uv / 34.0).rgb * 2.0;
		vec3 m2 = texture(macro_tex, mat2(vec2(0.6, 0.8), vec2(-0.8, 0.6)) * uv / 97.0 + 0.37).rgb * 2.0;
		base *= mix(vec3(1.0), sqrt(m1 * m2), 0.7 * (1.0 - forest));
	}
	ALBEDO = base;
	ROUGHNESS = 0.92;
	SPECULAR = 0.3;
}
