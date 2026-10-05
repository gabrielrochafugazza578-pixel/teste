// Bandeira no mastro: tecido ondulando com o vento global (ondas que correm do
// mastro para a ponta, mais fortes na ponta), desenho procedural da bandeira do
// município, desbotada e com a ponta esfiapada (mundo abandonado).
// Malha: PlaneMesh FACE_Z subdividida; UV.x = 0 no mastro, 1 na ponta.
shader_type spatial;
render_mode cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform float length_m = 1.95;
uniform vec3 col_a : source_color = vec3(0.12, 0.42, 0.24);
uniform vec3 col_b : source_color = vec3(0.92, 0.9, 0.84);
uniform vec3 col_c : source_color = vec3(0.86, 0.68, 0.16);

global uniform vec4 wind;
global uniform float wetness;

varying float v_shade;

float wave(float u, float t, float ph) {
	return sin(u * 7.0 - t * 5.5 + ph) * 0.6 + sin(u * 13.0 - t * 8.3 + ph * 1.7) * 0.25;
}

void vertex() {
	float u = UV.x;
	float v = UV.y;
	float str = clamp(wind.z, 0.15, 1.6);
	float t = TIME * (0.7 + str * 0.6);
	float ph = dot(MODEL_MATRIX[3].xz, vec2(0.31, 0.17));
	// amplitude cresce do mastro para a ponta; vento fraco = bandeira mais caída
	float amp = u * (0.1 + 0.16 * str);
	float w = wave(u, t, ph + v * 0.6);
	VERTEX.z += w * amp;
	// caimento: com pouco vento a ponta desce e encolhe na horizontal
	float droop = (1.0 - clamp(str, 0.0, 1.0)) * u * u;
	VERTEX.y -= droop * 0.45;
	VERTEX.x -= droop * 0.25 * length_m;
	// normal pela derivada da onda em u
	float e = 0.02;
	float dz = (wave(u + e, t, ph + v * 0.6) * (u + e) - w * u) * (0.1 + 0.16 * str) / (e * length_m);
	NORMAL = normalize(vec3(-dz, 0.0, 1.0));
	// dobras: as cristas pegam mais luz que os vales
	v_shade = 0.82 + 0.18 * w;
}

float h21(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
	// ponta esfiapada: a borda livre é rasgada em tiras irregulares
	float tear = 0.9 + 0.08 * h21(vec2(floor(uv.y * 14.0), 3.0));
	if (uv.x > tear) {
		discard;
	}
	// bandeira do município: faixas verde/branco/verde e disco amarelo perto do mastro
	vec3 c = col_a;
	if (abs(uv.y - 0.5) < 0.18) {
		c = col_b;
	}
	vec2 d = (uv - vec2(0.3, 0.5)) * vec2(length_m, 1.3);
	if (length(d) < 0.2) {
		c = col_c;
	}
	// desbotado pelo sol, sujo perto da ponta e da borda de baixo
	float n = h21(floor(uv * vec2(40.0, 26.0)));
	c = mix(c, vec3(dot(c, vec3(0.33))), 0.3);
	c *= 0.86 + n * 0.1 - uv.x * 0.12 - (1.0 - uv.y) * 0.06;
	c *= mix(1.0, 0.7, wetness);
	ALBEDO = c * v_shade;
	ROUGHNESS = 0.9;
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}
