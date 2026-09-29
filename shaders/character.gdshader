// Personagens (Caio, sobreviventes, infectados, pesquisadores).
// UMA draw call por personagem: cor por vértice (rgb) + id de material (alpha)
// que seleciona a camada da textura de detalhe (pele, malha, brim, couro).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2DArray detail_a : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2DArray detail_b : filter_linear_mipmap, repeat_enable;
uniform float infection : hint_range(0.0, 1.0) = 0.0;
uniform float grime_amount : hint_range(0.0, 1.0) = 0.25;
uniform float wet_self : hint_range(0.0, 1.0) = 0.0;
uniform float fresnel_rim = 0.0;
uniform vec3 rim_color = vec3(0.6, 0.7, 0.8);
uniform float pale_eyes = 0.0;
uniform float emissive_eyes = 0.0;

global uniform float wetness;
global uniform float daylight;

varying float mat_id;
varying vec3 l_pos;

float h3(vec3 p) { return fract(sin(dot(p, vec3(12.9, 78.2, 37.7))) * 43758.5); }
// ruído de valor suave (sujeira sem blocos visíveis)
float vn3(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = mix(mix(h3(i), h3(i + vec3(1, 0, 0)), f.x), mix(h3(i + vec3(0, 1, 0)), h3(i + vec3(1, 1, 0)), f.x), f.y);
	float b = mix(mix(h3(i + vec3(0, 0, 1)), h3(i + vec3(1, 0, 1)), f.x), mix(h3(i + vec3(0, 1, 1)), h3(i + vec3(1, 1, 1)), f.x), f.y);
	return mix(a, b, f.z);
}

void vertex() {
	mat_id = COLOR.a;
	l_pos = VERTEX;
}

void fragment() {
	float q = floor(mat_id * 3.0 + 0.5); // 0 pele, 1 malha, 2 brim, 3 couro
	vec3 luv = vec3(UV * 2.2, q);
	vec4 da = texture(detail_a, luv);
	vec4 db = texture(detail_b, luv);

	vec3 base = COLOR.rgb;
	float rough = da.a;
	vec3 alb = base * da.rgb;
	vec2 nxy = db.rg * 2.0 - 1.0;
	bool eye = UV.y > 19.0;
	bool hair = UV.y > 9.0 && !eye;
	// roupa/couro: levanta os tons escuros (jaqueta preta ilegível sob o ACES) sem estourar os claros
	if (q > 0.5 && !eye && !hair) {
		base = pow(base, vec3(0.74));
		alb = base * da.rgb;
	}
	// pele: idem, mais leve (tons escuros de pele fechavam em preto)
	if (q < 0.5 && !eye && !hair) {
		base = pow(base, vec3(0.82));
		alb = base * da.rgb;
	}
	if (eye) {
		nxy = vec2(0.0);
		alb = base;
	}
	if (hair) {
		// fios: listras finas no sentido do penteado, contraste some à distância
		float u = UV.x * 1400.0;
		float fw = clamp(1.0 - fwidth(u) * 0.6, 0.0, 1.0);
		float h1 = fract(sin(floor(u) * 12.9898) * 43758.5453);
		float h2 = fract(sin(floor(u * 0.23) * 78.233) * 43758.5453);
		float st = mix(0.5, 0.35 + 0.45 * h1 + 0.2 * h2, fw);
		alb = base * (0.6 + 0.6 * st);
		rough = 0.5 + 0.15 * h1;
		nxy = vec2((h1 - 0.5) * 0.7 * fw, 0.0);
	}

	if (q < 0.5) {
		// Infecção NEXUS: palidez acinzentada, veias escuras, olheiras.
		float veins = db.a * smoothstep(0.1, 0.6, infection);
		// pele doentia: cinza-esverdeada e fosca, qualquer que fosse o tom original
		vec3 sick = vec3(0.34, 0.37, 0.31) * da.rgb;
		vec3 pale = mix(alb, mix(sick, alb * 1.4, 0.22), infection * 0.85);
		alb = mix(pale, vec3(0.13, 0.08, 0.12), veins * 0.6);
		rough = mix(rough, 0.72, infection * 0.7);
	}
	// sujeira geral
	float g = grime_amount * (0.3 + 0.7 * vn3(l_pos * 7.0) * (0.6 + 0.4 * vn3(l_pos * 23.0)));
	alb *= 1.0 - g * 0.35;

	float wet = max(wetness * 0.8, wet_self);
	if (wet > 0.01 && (q > 0.5 || hair)) {
		alb *= mix(1.0, 0.62, wet);
		rough = mix(rough, 0.35, wet * 0.7);
	}

	ALBEDO = alb;
	ROUGHNESS = rough;
	METALLIC = 0.0;
	NORMAL_MAP = vec3(nxy * 0.8, sqrt(max(0.0, 1.0 - dot(nxy, nxy)))) * 0.5 + 0.5;
	float rim = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
	EMISSION = rim_color * rim * fresnel_rim;
	// preenchimento de dia: personagem nunca fecha em preto no lado da sombra
	float sky_up = 0.6 + 0.4 * clamp(NORMAL.y, -1.0, 1.0);
	EMISSION += alb * (0.055 * daylight) * sky_up;
	// translucidez da pele (orelhas, narinas, lábios): amolece o terminador da luz
	if (q < 0.5 && !eye) {
		BACKLIGHT = alb * vec3(0.32, 0.16, 0.11);
	}
	// olhos (UV.y > 19 marca o globo ocular): esclera/íris brilham nos infectados
	if (eye) {
		ROUGHNESS = 0.12;
		SPECULAR = 0.7;
	}
	if (emissive_eyes > 0.0 && eye && base.r > 0.3) {
		EMISSION += vec3(0.8, 0.85, 0.7) * emissive_eyes;
	}
}
