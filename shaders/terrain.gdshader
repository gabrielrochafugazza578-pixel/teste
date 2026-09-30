shader_type spatial;
render_mode cull_back;

#include "res://shaders/toon_light.gdshaderinc"

// Cores das encostas (sRGB)
uniform vec3 dirt_color : source_color = vec3(0.56, 0.37, 0.23);
uniform vec3 stone_color : source_color = vec3(0.50, 0.50, 0.57);

varying vec3 world_pos;
varying vec3 world_normal;

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
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	vec3 c = srgb_to_linear(COLOR.rgb);
	float grassy = step(0.83, COLOR.a);
	float snowy = step(0.5, COLOR.a) * (1.0 - grassy);
	float s = normalize(world_normal).y;
	// grama vira terra e neve vira pedra nas encostas (bordas bem definidas, estilo cartoon)
	float to_dirt = 1.0 - smoothstep(0.60, 0.63, s);
	float to_stone = 1.0 - smoothstep(0.50, 0.53, s);
	c = mix(c, dirt_color, to_dirt * grassy);
	c = mix(c, stone_color, to_stone * snowy);
	// faixas de rocha (estratos) nas paredes de pedra
	float rocky = max(to_stone * snowy, 1.0 - step(0.01, abs(COLOR.r - COLOR.b) + abs(COLOR.g - COLOR.b) - 0.12));
	float strata = step(0.5, fract(world_pos.y * 0.4 + vnoise(world_pos.xz * 0.08) * 1.2));
	c *= mix(1.0, 0.93 + 0.07 * strata, rocky * (1.0 - s * s));
	ALBEDO = c;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
}
