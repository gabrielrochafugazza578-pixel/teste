// Pele dos personagens fotorrealistas: textura em foto (MakeHuman CC0), mapa normal
// e rugosidade da pele (poros, lábios e nariz mais oleosos), espalhamento
// subsuperficial no Forward+. Infectados: palidez cinza-amarelada, veias escuras,
// hematomas e feridas abertas (estilo dos infectados de The Last of Us / DayZ).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

#include "res://shaders/human_common.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic;
uniform vec3 tone = vec3(1.0);
uniform float sss = 0.4;
uniform float normal_strength = 0.8;
// poros e microrrugas (mapa repetível): só de perto, some com a distância
uniform sampler2D pore_tex : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform float pore_scale = 12.0;
uniform float pore_strength = 0.55;

void fragment() {
	vec3 alb = texture(albedo_tex, UV).rgb * tone;
	vec4 nt = texture(normal_tex, UV);
	float rough = nt.a;
	vec4 mask = COLOR;
	float inf = infection;
	if (inf > 0.001) {
		vec4 dt = texture(detail_tex, UV * 6.0);
		vec4 dt2 = texture(detail_tex, UV * 1.7 + vec2(0.13, 0.41));
		float l = dot(alb, vec3(0.3, 0.59, 0.11));
		// sem circulação: cor some, fica cinza-amarelado (peles escuras ficam acinzentadas)
		vec3 pale = vec3(l) * vec3(1.0, 1.0, 0.86) * (1.0 + inf * 0.1);
		alb = mix(alb, pale, inf * 0.85);
		alb = mix(alb, vec3(0.36, 0.36, 0.31), inf * 0.22);
		// olheiras fundas e pálpebras arroxeadas (alfa da máscara)
		float sock = 1.0 - mask.a;
		alb = mix(alb, alb * vec3(0.32, 0.22, 0.24), sock * inf * 0.9);
		// sujeira/encardido geral da pele
		alb *= 1.0 - inf * 0.12 * dt2.g;
		// veias escuras aparecendo (mais nas áreas finas: pescoço, rosto, braços)
		float vein = dt.a * smoothstep(0.3, 0.7, dt2.g + inf * 0.35);
		alb = mix(alb, vec3(0.13, 0.12, 0.16) * (0.5 + l), clamp(vein * inf * 1.1, 0.0, 0.8));
		// hematomas arroxeados e olheiras
		float bruise = smoothstep(0.5, 0.78, dt2.r) * inf;
		alb = mix(alb, alb * vec3(0.52, 0.4, 0.48), bruise * 0.65);
		// feridas abertas (máscara B): carne viva no centro, borda escura
		float wm = mask.b * inf * 1.6 + (dt.b - 0.5) * 0.9;
		float wound = smoothstep(0.55, 0.7, wm);
		float rim = smoothstep(0.42, 0.55, wm) - wound;
		alb = mix(alb, vec3(0.2, 0.03, 0.025), wound);
		alb = mix(alb, alb * vec3(0.45, 0.32, 0.3), rim * 0.8);
		rough = mix(rough, 0.25, wound);
		rough = mix(rough, 0.48, inf * 0.35);
	}
	human_stains(alb, rough, mask, UV, 5.0);
	human_wet(alb, rough, 0.4);
	ALBEDO = alb;
	ROUGHNESS = rough;
	SPECULAR = 0.42;
	vec2 nxy = nt.rg * 2.0 - 1.0;
	float pf = 1.0 - smoothstep(1.2, 4.5, length(VERTEX));
	if (pf > 0.0) {
		vec2 pn = texture(pore_tex, UV * pore_scale).rg * 2.0 - 1.0;
		nxy += pn * pore_strength * pf;
		// fundo dos poros um pouco mais fosco
		ROUGHNESS = clamp(rough + length(pn) * 0.08 * pf, 0.0, 1.0);
	}
	NORMAL_MAP = vec3(nxy * 0.5 + 0.5, 1.0);
	NORMAL_MAP_DEPTH = normal_strength;
	AO = nt.b;
	AO_LIGHT_AFFECT = 0.3;
#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
	SSS_STRENGTH = sss * (1.0 - inf * 0.7);
#endif
}
