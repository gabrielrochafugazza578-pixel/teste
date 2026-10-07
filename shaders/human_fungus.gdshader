// Fungo dos infectados avançados (placas e caroços que brotam da pele): placas
// secas marrom-acinzentadas com lamelas, borda clara de crescimento e borda
// escura. Como os "estaladores" de The Last of Us.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

#include "res://shaders/human_common.gdshaderinc"

void fragment() {
	vec4 dt = texture(detail_tex, UV * vec2(3.0, 1.5));
	vec4 dt2 = texture(detail_tex, UV * 0.7 + vec2(0.2, 0.6));
	// lamelas: listras finas no sentido do crescimento
	float gills = sin(UV.x * 140.0 + dt.g * 6.0) * 0.5 + 0.5;
	float fw = clamp(1.0 - fwidth(UV.x * 140.0) * 0.5, 0.0, 1.0);
	// placa seca de fungo (orelha-de-pau): marrom-acinzentado fosco, manchado,
	// borda de crescimento mais clara e ocre nas lamelas (antes parecia folha dourada
	// lisa e brilhante)
	vec3 base = mix(vec3(0.16, 0.135, 0.1), vec3(0.085, 0.068, 0.05), dt2.g);
	base = mix(base, vec3(0.22, 0.2, 0.16), smoothstep(0.55, 0.9, dt.g) * 0.6);
	// base avermelhada onde o fungo rompe a pele
	base = mix(base, vec3(0.16, 0.05, 0.035), smoothstep(0.6, 0.9, dt2.r) * 0.5);
	vec3 dark = vec3(0.035, 0.026, 0.02);
	float edge = smoothstep(0.75, 0.98, abs(UV.y - 0.5) * 2.0);
	vec3 c = mix(base, mix(base * 0.6, vec3(0.2, 0.14, 0.05), 0.35), gills * fw * 0.5);
	// borda nova do crescimento: faixa clara e fina antes da borda escura
	c = mix(c, vec3(0.45, 0.41, 0.32), smoothstep(0.55, 0.72, abs(UV.y - 0.5) * 2.0) * (1.0 - edge) * 0.55);
	c = mix(c, dark, clamp(edge * 0.8 + dt.a * 0.4, 0.0, 1.0));
	float rough = mix(0.72, 0.9, dt.g);
	human_wet(c, rough, 0.3);
	ALBEDO = c;
	ROUGHNESS = rough;
	SPECULAR = 0.3;
	NORMAL_MAP = vec3(0.5 + (gills - 0.5) * 0.35 * fw, 0.5 + (dt.b - 0.5) * 0.3, 1.0);
	BACKLIGHT = c * 0.06;
}
