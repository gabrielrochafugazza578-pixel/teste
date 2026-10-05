// Fita de isolamento (zebrada amarelo/preto) entre dois cavaletes, tremulando
// com o vento global. UV.x = 0..1 ao longo da fita (0 e 1 presos nos postes),
// UV.y = 0..1 na largura.
shader_type spatial;
render_mode cull_disabled, diffuse_lambert_wrap;

global uniform vec4 wind;
global uniform float wetness;

varying float v_lit;

void vertex() {
	float t = UV.x;
	float w = sin(t * PI);
	float str = clamp(wind.z, 0.2, 1.6);
	float seed = dot(MODEL_MATRIX[3].xz, vec2(0.37, 0.23));
	float tm = TIME * (2.5 + str * 2.0);
	float flap = sin(tm + t * 14.0 + seed) * 0.6 + sin(tm * 1.7 - t * 23.0 + seed * 2.0) * 0.4;
	// balança para fora do plano e torce um pouco em volta do próprio eixo
	VERTEX.z += w * (flap * 0.07 * str + 0.04 * str);
	VERTEX.y += w * (cos(tm * 0.8 + t * 9.0 + seed) * 0.025 * str) + (UV.y - 0.5) * flap * 0.02 * w;
	v_lit = 0.85 + 0.15 * flap;
}

void fragment() {
	// faixas diagonais a cada 35 cm (fita de 2,8 m)
	float s = fract((UV.x * 2.8 + UV.y * 0.07) / 0.35);
	vec3 c = s < 0.5 ? vec3(0.9, 0.76, 0.1) : vec3(0.06, 0.06, 0.05);
	c *= mix(1.0, 0.75, wetness) * v_lit;
	ALBEDO = c;
	ROUGHNESS = mix(0.45, 0.2, wetness);
	SPECULAR = 0.4;
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}
