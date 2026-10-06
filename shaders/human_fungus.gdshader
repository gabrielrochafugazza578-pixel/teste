// Fungo dos infectados avançados (placas e caroços que brotam da pele): bege
// pálido com lamelas e bordas escuras, úmido. Como os "estaladores" de The Last of Us.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

#include "res://shaders/human_common.gdshaderinc"

void fragment() {
	vec4 dt = texture(detail_tex, UV * vec2(3.0, 1.5));
	vec4 dt2 = texture(detail_tex, UV * 0.7 + vec2(0.2, 0.6));
	// lamelas: listras finas no sentido do crescimento
	float gills = sin(UV.x * 140.0 + dt.g * 6.0) * 0.5 + 0.5;
	float fw = clamp(1.0 - fwidth(UV.x * 140.0) * 0.5, 0.0, 1.0);
	vec3 base = mix(vec3(0.27, 0.22, 0.14), vec3(0.15, 0.11, 0.07), dt2.g);
	// base avermelhada onde o fungo rompe a pele
	base = mix(base, vec3(0.2, 0.07, 0.05), smoothstep(0.55, 0.85, dt2.r) * 0.6);
	vec3 dark = vec3(0.05, 0.03, 0.02);
	float edge = smoothstep(0.75, 0.98, abs(UV.y - 0.5) * 2.0);
	vec3 c = mix(base, base * 0.72, gills * fw * 0.6);
	c = mix(c, dark, clamp(edge * 0.7 + dt.a * 0.5, 0.0, 1.0));
	c = mix(c, vec3(0.28, 0.06, 0.04), smoothstep(0.6, 0.8, dt.r) * 0.35);
	float rough = mix(0.32, 0.6, dt.g);
	human_wet(c, rough, 0.3);
	ALBEDO = c;
	ROUGHNESS = rough;
	SPECULAR = 0.5;
	NORMAL_MAP = vec3(0.5 + (gills - 0.5) * 0.35 * fw, 0.5 + (dt.b - 0.5) * 0.3, 1.0);
	BACKLIGHT = c * 0.15;
}
