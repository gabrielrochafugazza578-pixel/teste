// Folhagem de árvores/arbustos: cartões com recorte alfa (alpha scissor),
// balanço pelo vento global (peso em COLOR.r) e variação de tom por instância.
// Recorte (não blend) => sem ordenação de transparência, barato na GTX 750 Ti.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform sampler2D leaf_tex : source_color, filter_linear_mipmap, repeat_disable;
uniform float alpha_cut = 0.45;
uniform vec3 tint = vec3(1.0);
uniform float sway = 1.0;
uniform float fade_start = 400.0;
uniform float fade_end = 460.0;

global uniform vec4 wind;
global uniform float veg_growth;
global uniform float wetness;

varying float v_shade;
varying flat float v_hue;

void vertex() {
	vec3 wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float w = COLOR.r * sway;
	float t = TIME * (1.0 + wind.w * 2.0);
	float ph = dot(MODEL_MATRIX[3].xz, vec2(0.13, 0.17));
	vec3 offs = vec3(wind.x, 0.0, wind.y) * (sin(t * 1.3 + ph) * 0.5 + 0.6) * wind.z * 0.35 * w;
	offs += vec3(sin(t * 3.1 + wp.x * 0.8), cos(t * 2.7 + wp.z * 0.9) * 0.3, cos(t * 3.4 + wp.z)) * 0.03 * w * (0.4 + wind.z);
	// deslocamento em espaço de mundo -> local (matriz só com rotação + escala uniforme)
	mat3 m = mat3(MODEL_MATRIX);
	VERTEX += transpose(m) * offs / max(dot(m[0], m[0]), 0.0001);
	v_shade = COLOR.g;
	// tom por árvore (posição da instância): umas mais amareladas, outras mais escuras
	v_hue = fract(sin(dot(MODEL_MATRIX[3].xz, vec2(12.9898, 78.233))) * 43758.5453);
	// distância: encolhe cartões para evitar "pop"
	float d = distance(wp, CAMERA_POSITION_WORLD);
	float f = 1.0 - smoothstep(fade_start, fade_end, d);
	if (f < 0.999) {
		VERTEX *= f;
	}
}

// Alfa "que não some": nos mipmaps a média do alfa cai abaixo do corte e a copa
// fica rala e cintilando de longe; compensa pelo nível de mip e deixa a borda com
// 1 pixel de transição (recorte antisserrilhado, técnica de Ben Golus).
float coverage_alpha(float a, vec2 uv, vec2 tsize, float cut) {
	vec2 dx = dFdx(uv * tsize);
	vec2 dy = dFdy(uv * tsize);
	float mip = max(0.0, 0.5 * log2(max(dot(dx, dx), dot(dy, dy))));
	a *= 1.0 + mip * 0.25;
	return clamp((a - cut) / max(fwidth(a), 0.0001) + 0.5, 0.0, 1.0);
}

void fragment() {
	vec4 c = texture(leaf_tex, UV);
	// cartão "redondo" e irregular: as folhas dos cantos somem, então a copa não
	// mostra as arestas retas dos polígonos (aspecto de papel amassado)
	float rr = length(UV - 0.5) * 2.0;
	float edge = 1.0 - smoothstep(0.55, 0.95, rr + (c.g - 0.12) * 0.6);
	// cartão visto de lado vira um risco fino ("palito" saindo da copa): some
	// aos poucos quando o plano do cartão fica alinhado com a visão
	vec3 fn = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	float facing = abs(dot(fn, normalize(-VERTEX)));
	float side = smoothstep(0.1, 0.3, facing);
	float a = coverage_alpha(c.a * mix(0.35, 1.0, edge) * step(rr, 0.97) * side, UV, vec2(textureSize(leaf_tex, 0)), alpha_cut);
	if (a < 0.5) {
		discard;
	}
	vec3 leaf = c.rgb * mix(vec3(0.9, 1.0, 0.85), vec3(1.15, 1.08, 0.8), v_hue);
	vec3 alb = leaf * tint * (0.68 + v_shade * 0.62);
	alb *= mix(1.0, 0.7, wetness);
	ALBEDO = alb;
	ROUGHNESS = mix(0.8, 0.4, wetness);
	// face de trás levemente mais escura (sem BACKLIGHT, compatível com GL3)
	if (!FRONT_FACING) {
		ALBEDO *= 0.8;
		NORMAL = -NORMAL;
	}
}
