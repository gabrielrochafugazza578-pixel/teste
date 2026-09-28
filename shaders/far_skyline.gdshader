// Silhueta distante dos prédios (MultiMesh de caixas, 1 draw call).
// Some onde o chunk verdadeiro está carregado (máscara 48×48 de chunks) e
// desenha janelas procedurais que se apagam com a energia da cidade e com a
// onda do apagão — o mesmo critério do world_surface.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D chunk_mask : filter_nearest, repeat_disable;
uniform vec2 mask_origin = vec2(-1536.0);
uniform float mask_scale = 0.00032552;   // 1 / (64 * 48)

global uniform float daylight;
global uniform float city_power;
global uniform float world_decay;
global uniform vec3 blackout_origin;
global uniform float blackout_radius;

varying vec3 w_pos;
varying vec3 w_nrm;
varying float b_seed;

float hash21(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

void vertex() {
	vec3 center = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float loaded = textureLod(chunk_mask, (center.xz - mask_origin) * mask_scale, 0.0).r;
	if (loaded > 0.5) {
		VERTEX = vec3(0.0);
	}
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	w_nrm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	b_seed = hash21(center.xz * 0.013);
}

void fragment() {
	vec3 base = COLOR.rgb;
	float rough = 0.85;
	vec3 emit = vec3(0.0);
	if (abs(w_nrm.y) < 0.5) {
		// fachada: grade de janelas de 3 m × 3 m
		float u = abs(w_nrm.x) > 0.5 ? w_pos.z : w_pos.x;
		vec2 g = vec2(u, w_pos.y - 0.4) / vec2(3.0, 3.0);
		vec2 f = fract(g);
		vec2 cell = floor(g);
		float fw = clamp(1.0 - max(fwidth(g.x), fwidth(g.y)) * 1.5, 0.0, 1.0);
		float win = step(0.22, f.x) * step(f.x, 0.78) * step(0.3, f.y) * step(f.y, 0.82);
		// longe demais: a grade vira a média (sem cintilação)
		float wmix = mix(0.3, win, fw);
		base = mix(base, vec3(0.05, 0.06, 0.07) + vec3(0.1, 0.12, 0.14) * daylight, wmix * 0.75);
		rough = mix(rough, 0.35, wmix);
		float rnd = hash21(cell + b_seed * 91.0);
		float powered = city_power * step(blackout_radius, distance(w_pos.xz, blackout_origin.xz) + rnd * 25.0);
		float occupancy = 0.25 + 0.45 * (1.0 - daylight);
		float lit = step(rnd, occupancy) * powered * (1.0 - step(1.0 - world_decay * 0.2, fract(rnd * 7.3)));
		float lit_avg = occupancy * powered;
		float l = mix(lit_avg * 0.3, lit * win, fw);
		emit = mix(vec3(1.0, 0.72, 0.42), vec3(0.75, 0.85, 1.0), step(0.75, fract(rnd * 13.1))) * l * mix(0.25, 1.0, 1.0 - daylight) * 1.4;
		// base mais escura (sujeira/sombra de rua)
		base *= mix(0.72, 1.0, smoothstep(0.0, 8.0, w_pos.y - (MODEL_MATRIX[3].y - length(MODEL_MATRIX[1].xyz) * 0.5)));
	} else {
		base *= 0.78;   // laje/telhado
	}
	ALBEDO = base;
	ROUGHNESS = rough;
	EMISSION = emit;
}
