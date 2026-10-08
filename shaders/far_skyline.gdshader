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
varying flat float b_seed;

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
	float spec = 0.5;
	if (abs(w_nrm.y) < 0.5) {
		float y_bot = MODEL_MATRIX[3].y - length(MODEL_MATRIX[1].xyz) * 0.5;
		float y_top = MODEL_MATRIX[3].y + length(MODEL_MATRIX[1].xyz) * 0.5;
		// estilo de cada prédio: residencial (janelas soltas), escritório (faixas
		// de vidro contínuas) ou comercial (janelas largas)
		float style = fract(b_seed * 7.31);
		vec2 csz = style < 0.45 ? vec2(3.0 + b_seed * 0.6, 2.9) : (style < 0.8 ? vec2(2.4, 3.4) : vec2(3.8, 3.3));
		vec2 wlo = style < 0.45 ? vec2(0.26, 0.3) : (style < 0.8 ? vec2(0.02, 0.28) : vec2(0.12, 0.25));
		vec2 whi = style < 0.45 ? vec2(0.74, 0.82) : (style < 0.8 ? vec2(0.98, 0.86) : vec2(0.88, 0.85));
		float u = abs(w_nrm.x) > 0.5 ? w_pos.z : w_pos.x;
		vec2 g = vec2(u, w_pos.y - y_bot - 0.4) / csz;
		vec2 f = fract(g);
		vec2 cell = floor(g);
		vec2 dg = max(fwidth(g), vec2(1e-4));
		float fw = clamp(1.0 - max(dg.x, dg.y) * 1.5, 0.0, 1.0);
		// bordas das janelas com 1 pixel de transição (sem serrilhado/cintilação)
		float win = clamp((f.x - wlo.x) / dg.x + 0.5, 0.0, 1.0) * clamp((whi.x - f.x) / dg.x + 0.5, 0.0, 1.0)
			* clamp((f.y - wlo.y) / dg.y + 0.5, 0.0, 1.0) * clamp((whi.y - f.y) / dg.y + 0.5, 0.0, 1.0);
		float cov = (whi.x - wlo.x) * (whi.y - wlo.y);
		// longe demais: a grade vira a média (sem cintilação)
		float wmix = mix(cov, win, fw);
		// faixa da laje entre os andares (mais clara) e platibanda no topo
		float slab = clamp((0.06 - abs(f.y - 0.04)) / dg.y + 0.5, 0.0, 1.0) * fw;
		base *= 1.0 + slab * 0.18;
		base *= mix(1.0, 0.82, smoothstep(y_top - 0.9, y_top - 0.7, w_pos.y));
		// escorridos de chuva verticais (cada prédio do seu jeito)
		float stk = hash21(vec2(floor(u * 0.9), b_seed * 31.0));
		base *= 1.0 - smoothstep(0.6, 1.0, stk) * 0.18 * (0.4 + world_decay * 0.6) * fw;
		// vidro: escuro e liso (reflete o céu; no pôr do sol as fachadas acendem)
		float rnd = hash21(cell + b_seed * 91.0);
		vec3 glass = vec3(0.03, 0.035, 0.04) + vec3(0.04, 0.05, 0.06) * daylight * (0.6 + rnd * 0.8);
		base = mix(base, glass, wmix * 0.85);
		rough = mix(rough, 0.08 + rnd * 0.1, wmix);
		spec = mix(0.5, 0.7, wmix);
		float powered = city_power * step(blackout_radius, distance(w_pos.xz, blackout_origin.xz) + rnd * 25.0);
		float occupancy = 0.25 + 0.45 * (1.0 - daylight);
		float lit = step(rnd, occupancy) * powered * (1.0 - step(1.0 - world_decay * 0.2, fract(rnd * 7.3)));
		float lit_avg = occupancy * powered;
		float l = mix(lit_avg * cov, lit * win, fw);
		emit = mix(vec3(1.0, 0.72, 0.42), vec3(0.75, 0.85, 1.0), step(0.75, fract(rnd * 13.1))) * l * mix(0.25, 1.0, 1.0 - daylight) * 1.4;
		// base mais escura (sujeira/sombra de rua)
		base *= mix(0.72, 1.0, smoothstep(0.0, 8.0, w_pos.y - y_bot));
	} else {
		base *= 0.78;   // laje/telhado
	}
	ALBEDO = base;
	ROUGHNESS = rough;
	SPECULAR = spec;
	EMISSION = emit;
}
