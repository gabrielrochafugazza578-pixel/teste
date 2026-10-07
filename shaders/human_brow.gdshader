// Sobrancelhas e cílios (cartões do MakeHuman CC0): fios finos com transparência
// de verdade (mistura, não recorte), na cor do cabelo da pessoa — o recorte por
// alfa engrossava os fios e virava um traço preto "pintado".
shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform float opacity = 0.9;
uniform float density = 1.6;
instance uniform vec4 hair_tint : source_color, instance_index(8) = vec4(1.0, 1.0, 1.0, 0.0);

void fragment() {
	vec4 a = texture(albedo_tex, UV);
	// fios: a cor da textura (quase preta) puxada para a do cabelo, um pouco mais escura
	vec3 hc = hair_tint.a > 0.01 ? hair_tint.rgb * 0.75 : vec3(0.06, 0.045, 0.035);
	vec3 c = mix(a.rgb, hc, 0.65);
	ALBEDO = c;
	ALPHA = clamp(a.a * density, 0.0, 1.0) * opacity;
	ROUGHNESS = 0.6;
	SPECULAR = 0.25;
}
