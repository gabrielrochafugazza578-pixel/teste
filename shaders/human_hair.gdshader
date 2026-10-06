// Cabelo, barba, sobrancelhas e cílios (cartões com alfa do MakeHuman CC0):
// recorte por alfa (sombra correta), brilho anisotrópico ao longo dos fios e luz
// atravessando as pontas. A cor varia por pessoa (hair_tint).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap_anisotropic;
uniform float cutoff = 0.42;
uniform float aniso = 0.55;
uniform float rough_base = 0.5;
uniform float spec = 0.3;
// rgb = cor desejada, a = quanto tingir (0 = cor da foto)
instance uniform vec4 hair_tint : source_color, instance_index(8) = vec4(1.0, 1.0, 1.0, 0.0);
instance uniform float grime : instance_index(1) = 0.2;
global uniform float wetness;

void fragment() {
	vec4 a = texture(albedo_tex, UV);
	vec3 c = a.rgb;
	// tinge pela luminância (o cabelo da textura vira castanho, preto, grisalho…)
	float l = dot(c, vec3(0.3, 0.59, 0.11));
	c = mix(c, vec3(l) * 2.4 * hair_tint.rgb, hair_tint.a);
	c = mix(c, c * vec3(0.7, 0.66, 0.6), clamp(grime, 0.0, 1.0) * 0.4);
	ALBEDO = c * (1.0 - clamp(wetness, 0.0, 1.0) * 0.3);
	ALPHA = a.a;
	ALPHA_SCISSOR_THRESHOLD = cutoff;
	ROUGHNESS = mix(rough_base, rough_base * 0.6, clamp(wetness, 0.0, 1.0));
	SPECULAR = spec;
	ANISOTROPY = aniso;
	ANISOTROPY_FLOW = vec2(0.0, 1.0);
	BACKLIGHT = c * 0.35;
}
