shader_type spatial;
render_mode cull_back;
// Bichos e objetos com cor unica. `flash` (por instancia) pisca quando leva dano.

#include "res://shaders/toon_light.gdshaderinc"

uniform vec3 albedo : source_color = vec3(1.0);
uniform vec3 emission_color : source_color = vec3(0.0);
uniform float emission_strength = 0.0;
instance uniform float flash = 0.0;
instance uniform float fade = 1.0;

void fragment() {
	ALBEDO = mix(albedo, vec3(1.0, 0.25, 0.25), flash);
	EMISSION = emission_color * emission_strength + vec3(1.0, 0.3, 0.3) * flash * 0.6;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	// dissolve ao aparecer/sumir (padrao de pontinhos)
	float n = fract(sin(dot(floor(FRAGCOORD.xy / 3.0), vec2(12.9898, 78.233))) * 43758.5453);
	if (n > fade) {
		discard;
	}
}
