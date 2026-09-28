// Personagens (Caio, sobreviventes, infectados, pesquisadores).
// UMA draw call por personagem: cor por vértice (rgb) + id de material (alpha)
// que seleciona o quadrante do atlas de detalhe (pele, malha, brim, couro).
// textureGrad mantém mipmaps corretos dentro do atlas sem costuras.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D detail_a : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D detail_b : filter_linear_mipmap, repeat_enable;
uniform float infection : hint_range(0.0, 1.0) = 0.0;
uniform float grime_amount : hint_range(0.0, 1.0) = 0.25;
uniform float wet_self : hint_range(0.0, 1.0) = 0.0;
uniform float fresnel_rim = 0.0;
uniform vec3 rim_color = vec3(0.6, 0.7, 0.8);
uniform float pale_eyes = 0.0;
uniform float emissive_eyes = 0.0;

global uniform float wetness;

varying float mat_id;
varying vec3 l_pos;

void vertex() {
	mat_id = COLOR.a;
	l_pos = VERTEX;
}

void fragment() {
	float q = floor(mat_id * 3.0 + 0.5); // 0 pele, 1 malha, 2 brim, 3 couro
	vec2 qoff = vec2(mod(q, 2.0), floor(q / 2.0)) * 0.5;
	vec2 luv = UV * 2.2;
	vec2 auv = qoff + fract(luv) * 0.5;
	vec2 dx = dFdx(luv) * 0.5;
	vec2 dy = dFdy(luv) * 0.5;
	vec4 da = textureGrad(detail_a, auv, dx, dy);
	vec4 db = textureGrad(detail_b, auv, dx, dy);

	vec3 base = COLOR.rgb;
	float rough = da.a;
	vec3 alb = base * da.rgb;

	if (q < 0.5) {
		// Infecção NEXUS: palidez acinzentada, veias escuras, olheiras.
		float veins = db.a * smoothstep(0.1, 0.6, infection);
		vec3 pale = mix(alb, vec3(dot(alb, vec3(0.33))) * vec3(0.86, 0.9, 0.84), infection * 0.75);
		alb = mix(pale, vec3(0.18, 0.2, 0.22), veins * 0.55);
		rough = mix(rough, 0.35, infection * 0.4);
	}
	// sujeira geral
	float g = grime_amount * (0.4 + 0.6 * fract(sin(dot(floor(l_pos * 9.0), vec3(12.9, 78.2, 37.7))) * 43758.5));
	alb *= 1.0 - g * 0.35;

	float wet = max(wetness * 0.8, wet_self);
	if (wet > 0.01 && q > 0.5) {
		alb *= mix(1.0, 0.62, wet);
		rough = mix(rough, 0.35, wet * 0.7);
	}

	vec2 nxy = db.rg * 2.0 - 1.0;
	ALBEDO = alb;
	ROUGHNESS = rough;
	METALLIC = 0.0;
	NORMAL_MAP = vec3(nxy * 0.8, sqrt(max(0.0, 1.0 - dot(nxy, nxy)))) * 0.5 + 0.5;
	float rim = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
	EMISSION = rim_color * rim * fresnel_rim;
	// olhos: cor quase branca com mat_id 0 e rgb > 0.95 => realce
	if (emissive_eyes > 0.0 && q < 0.5 && base.r > 0.8 && base.g > 0.78 && base.b > 0.74) {
		EMISSION += vec3(0.8, 0.85, 0.7) * emissive_eyes;
	}
}
