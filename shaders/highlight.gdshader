// Realce do item na mira: brilho de borda (fresnel) somado por cima do objeto,
// pulsando devagar. Usado como material_overlay (não troca o material do item).
shader_type spatial;
render_mode blend_add, unshaded, cull_back, depth_draw_never;

uniform vec3 glow : source_color = vec3(1.0, 0.82, 0.45);
uniform float strength = 0.55;

void fragment() {
	float rim = pow(1.0 - clamp(abs(dot(NORMAL, VIEW)), 0.0, 1.0), 2.2);
	float pulse = 0.65 + 0.35 * sin(TIME * 4.0);
	ALBEDO = glow * (rim * 0.85 + 0.06) * strength * pulse;
}
