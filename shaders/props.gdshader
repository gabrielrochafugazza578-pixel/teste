shader_type spatial;
render_mode cull_back;
// Objetos do mundo (arvores, plantas...). Cor por vertice, variacao por
// instancia (INSTANCE_CUSTOM.rgb), balanco com o vento (INSTANCE_CUSTOM.a)
// e partes que brilham a noite (alfa do vertice = 0.5).

#include "res://shaders/toon_light.gdshaderinc"

global uniform float night_factor;
uniform float sway_strength = 0.05;

varying vec3 tint;
varying float glow;

void vertex() {
	tint = INSTANCE_CUSTOM.rgb;
	vec3 wp = MODEL_MATRIX[3].xyz;
	float h = max(VERTEX.y - 0.8, 0.0);
	float ph = wp.x * 0.37 + wp.z * 0.23;
	float amt = sway_strength * INSTANCE_CUSTOM.a * h;
	VERTEX.x += sin(TIME * 1.4 + ph) * amt;
	VERTEX.z += cos(TIME * 1.1 + ph * 1.3) * amt * 0.7;
}

void fragment() {
	vec3 base = srgb_to_linear(COLOR.rgb);
	float a = COLOR.a;
	float tintable = 1.0 - step(0.25, a);
	float glowing = step(0.25, a) * (1.0 - step(0.75, a));
	vec3 c = mix(base, base * tint, tintable);
	ALBEDO = c;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	EMISSION = c * glowing * (0.25 + night_factor * 3.5);
}
