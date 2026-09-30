// Iluminacao cartoon compartilhada: sombra com corte seco, duas faixas de luz
// e um brilho de contorno (rim light) suave.

uniform float toon_rim = 0.22;

vec3 srgb_to_linear(vec3 c) {
	return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(0.04045, c));
}

void light() {
	// LIGHT_COLOR ja vem multiplicado por PI na Godot 4
	vec3 lc = LIGHT_COLOR / PI;
	float ndl = dot(NORMAL, LIGHT);
	float lit = smoothstep(0.0, 0.05, ndl);
	float shadow = smoothstep(0.3, 0.55, ATTENUATION);
	float band = mix(0.8, 1.0, smoothstep(0.42, 0.47, ndl));
	DIFFUSE_LIGHT += lc * lit * shadow * band;
	float rim = smoothstep(0.62, 0.7, 1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0));
	DIFFUSE_LIGHT += lc * rim * toon_rim * lit * shadow;
}
