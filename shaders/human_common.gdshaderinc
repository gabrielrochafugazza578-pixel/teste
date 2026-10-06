// Comum aos materiais dos personagens fotorrealistas (MakeHuman).
// Os materiais são compartilhados por todos os personagens que usam a mesma peça;
// o que muda por pessoa vem dos parâmetros de instância (infectado, sujo, ferido,
// cor da roupa) e das máscaras gravadas na cor do vértice por tools/make_humans.py:
// R = onde o sangue pega, G = sujeira, B = rasgo (roupa) / ferida (pele).

instance uniform float infection : instance_index(0) = 0.0;
instance uniform float grime : instance_index(1) = 0.2;
instance uniform float blood : instance_index(2) = 0.0;
instance uniform float wear : instance_index(3) = 0.0;

// R respingos, G sujeira, B trama dos rasgos, A veias (repetível)
uniform sampler2D detail_tex : filter_linear_mipmap, repeat_enable;

global uniform float wetness;
global uniform float daylight;

// Sujeira e sangue por cima da cor (sangue fresco = vermelho escuro molhado,
// seco = marrom fosco). `k` é a escala da textura de detalhe nesta peça.
void human_stains(inout vec3 alb, inout float rough, vec4 mask, vec2 uv, float k) {
	vec4 dt = texture(detail_tex, uv * k);
	vec4 dt2 = texture(detail_tex, uv * k * 0.37 + vec2(0.31, 0.67));
	float dm = mask.g * grime * 1.7;
	float d = smoothstep(0.38, 0.8, dm + (dt.g - 0.5) * 0.9 + (dt2.g - 0.5) * 0.4);
	alb = mix(alb, alb * vec3(0.46, 0.4, 0.33) + vec3(0.035, 0.028, 0.018), d * 0.85);
	rough = mix(rough, 0.96, d * 0.7);
	float bm = mask.r * blood * 1.5;
	float bn = bm + (dt.r - 0.5) * 0.9 + (dt2.b - 0.5) * 0.45;
	float b = smoothstep(0.45, 0.62, bn);
	// bordas mais finas e escurecidas (sangue que secou nas bordas)
	float rim = smoothstep(0.38, 0.47, bn) - b;
	float dry = smoothstep(0.3, 0.7, dt2.g);
	vec3 bc = mix(vec3(0.115, 0.006, 0.005), vec3(0.055, 0.02, 0.013), dry);
	alb = mix(alb, alb * vec3(0.55, 0.38, 0.34), rim * 0.7);
	alb = mix(alb, bc, b * 0.95);
	rough = mix(rough, mix(0.22, 0.65, dry), b);
}

// Chuva: tecido e pele escurecem e brilham
void human_wet(inout vec3 alb, inout float rough, float porous) {
	float w = clamp(wetness, 0.0, 1.0);
	alb *= 1.0 - w * 0.32 * porous;
	rough = mix(rough, rough * 0.45, w);
}
