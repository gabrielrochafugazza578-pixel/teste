// Corpo comum de human_cloth.gdshader e human_cloth_torn.gdshader.
#include "res://shaders/human_common.gdshaderinc"

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic;
// cor base desta peça (jaleco = cardigã sem cor e clareado etc.)
uniform vec3 base_tint = vec3(1.0);
uniform float desat = 0.0;
uniform float bright = 1.0;
// 0 parte de cima, 1 de baixo, 2 calçado, 3 sem variação por pessoa
uniform int tint_slot = 3;
uniform float detail_k = 4.0;
uniform float porous = 1.0;
uniform float sheen = 0.25;
// peças "lisas" (jaleco, roupa de hospital, farda): a foto vira só sombreado
uniform float flatten = 0.0;
uniform vec3 flat_color : source_color = vec3(0.8);
// recorte por alfa (óculos: lentes vazadas)
uniform float alpha_cut = 0.0;
instance uniform vec3 tint_top : source_color, instance_index(5) = vec3(1.0);
instance uniform vec3 tint_bottom : source_color, instance_index(6) = vec3(1.0);
instance uniform vec3 tint_shoes : source_color, instance_index(7) = vec3(1.0);

void fragment() {
	vec4 a = texture(albedo_tex, UV);
	if (a.a < alpha_cut) {
		discard;
	}
	vec3 c = a.rgb;
	float l = dot(c, vec3(0.3, 0.59, 0.11));
	c = mix(c, vec3(l), desat) * base_tint * bright;
	float lm = dot(textureLod(albedo_tex, UV, 7.0).rgb, vec3(0.3, 0.59, 0.11));
	c = mix(c, flat_color * clamp(0.92 + (l - lm) * 0.14, 0.75, 1.08), flatten);
	if (tint_slot == 0) {
		c *= tint_top;
	} else if (tint_slot == 1) {
		c *= tint_bottom;
	} else if (tint_slot == 2) {
		c *= tint_shoes;
	}
	vec4 nt = texture(normal_tex, UV);
	float rough = nt.a;
	vec4 mask = COLOR;
	// rasgos: só nos infectados/sobreviventes gastos (wear), começando pelas barras
	if (wear > 0.001) {
		float th = texture(detail_tex, UV * detail_k * 0.8).b;
		float hole = mask.b * wear * 1.25 - th;
		if (hole > 0.0) {
			discard;
		}
		// borda desfiada e encardida
		float edge = smoothstep(-0.14, 0.0, hole);
		c *= 1.0 - edge * 0.55;
	}
#ifdef TORN
	// avesso do tecido visto pelos rasgos
	if (!FRONT_FACING) {
		c *= 0.32;
	}
#endif
	human_stains(c, rough, mask, UV, detail_k);
	human_wet(c, rough, porous);
	ALBEDO = c;
	ROUGHNESS = rough;
	SPECULAR = 0.3;
	NORMAL_MAP = vec3(nt.rg, 1.0);
	AO = mix(nt.b, 1.0, flatten * 0.8);
	AO_LIGHT_AFFECT = 0.25;
	// brilho rasante do tecido
	RIM = sheen;
	RIM_TINT = 0.6;
}
