shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, specular_disabled;
// Gelatina translucida e brilhante (gosma lunar, aura dos espiritos).

#include "res://shaders/toon_light.gdshaderinc"

uniform vec3 albedo : source_color = vec3(0.3, 0.95, 0.85);
uniform vec3 glow_color : source_color = vec3(0.3, 1.0, 0.85);
uniform float glow = 1.2;
uniform float opacity = 0.55;
instance uniform float flash = 0.0;
instance uniform float fade = 1.0;

void fragment() {
	float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 2.0);
	ALBEDO = mix(albedo, vec3(1.0, 0.3, 0.3), flash);
	// brilho que pulsa devagar
	float pulse = 0.85 + 0.15 * sin(TIME * 3.0);
	EMISSION = glow_color * glow * (0.35 + fres * 1.6) * pulse + vec3(1.0, 0.3, 0.3) * flash;
	ALPHA = clamp(opacity + fres * 0.45, 0.0, 1.0) * fade;
	ROUGHNESS = 0.3;
}
