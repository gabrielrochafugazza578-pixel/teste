shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_disabled, specular_disabled;
// Agua cartoon: cor pela profundidade, espuma branca na beira e linhas de onda.

#include "res://shaders/toon_light.gdshaderinc"

uniform sampler2D depth_tex : hint_depth_texture, filter_linear;
uniform vec3 shallow_color : source_color = vec3(0.22, 0.74, 0.80);
uniform vec3 deep_color : source_color = vec3(0.07, 0.30, 0.66);
uniform vec3 foam_color : source_color = vec3(0.97, 1.0, 1.0);
uniform float depth_range = 7.0;

varying vec3 wpos;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash21(i), hash21(i + vec2(1, 0)), u.x), mix(hash21(i + vec2(0, 1)), hash21(i + vec2(1, 1)), u.x), u.y);
}

void vertex() {
	wpos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.y += sin(wpos.x * 0.35 + TIME * 1.3) * 0.06 + cos(wpos.z * 0.3 + TIME * 1.1) * 0.06;
}

void fragment() {
	float raw = texture(depth_tex, SCREEN_UV).r;
	vec4 v = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, raw, 1.0);
	float scene_z = -v.z / v.w;
	float water_z = -VERTEX.z;
	float thick = max(scene_z - water_z, 0.0);
	float df = clamp(thick / depth_range, 0.0, 1.0);
	vec3 col = mix(shallow_color, deep_color, smoothstep(0.0, 1.0, df));

	// linhas de onda desenhadas
	float n = vnoise(wpos.xz * 0.18 + vec2(TIME * 0.05, TIME * 0.03));
	float n2 = vnoise(wpos.xz * 0.5 - vec2(TIME * 0.08, 0.0));
	float f = fract(n * 5.0 + n2 * 0.6 + TIME * 0.05);
	float wave = 1.0 - smoothstep(0.0, 0.035, min(f, 1.0 - f));
	col = mix(col, foam_color, wave * 0.45 * (1.0 - df * 0.4));

	// espuma na beira
	float edge = 0.55 + 0.25 * sin(TIME * 2.0 + wpos.x * 0.6 + wpos.z * 0.4);
	float foam = 1.0 - smoothstep(edge, edge + 0.05, thick);

	col = mix(col, foam_color, foam);
	ALBEDO = col;
	ALPHA = clamp(mix(0.7, 0.95, df) + foam, 0.0, 1.0);
	ROUGHNESS = 1.0;
}
