// Vidro (janelas do laboratório, sala de isolamento, vitrines).
// Transparência leve com fresnel e sujeira; "condensation" embaça (cena do paciente).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, specular_schlick_ggx;

uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform vec3 tint : source_color = vec3(0.7, 0.8, 0.82);
uniform float dirt : hint_range(0.0, 1.0) = 0.2;
uniform float condensation : hint_range(0.0, 1.0) = 0.0;
uniform float crack : hint_range(0.0, 1.0) = 0.0;
uniform float base_alpha = 0.12;

varying vec3 w_pos;

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec4 n = texture(noise_tex, UV * 1.7 + w_pos.xz * 0.01);
	float fres = pow(1.0 - clamp(abs(dot(NORMAL, VIEW)), 0.0, 1.0), 3.0);
	float smudge = smoothstep(0.45, 0.8, n.g) * dirt;
	float fog = condensation * smoothstep(0.2, 0.7, n.r + 0.3);
	float cr = crack * (1.0 - smoothstep(0.0, 0.03, n.a));
	ALBEDO = mix(tint * 0.2, vec3(0.75), smudge * 0.5 + fog * 0.7 + cr);
	// reflexo levemente desfocado: vidro 100% liso faz o brilho "estalar" ao andar
	ROUGHNESS = mix(0.08, 0.6, smudge + fog);
	METALLIC = 0.0;
	SPECULAR = 0.9;
	ALPHA = clamp(base_alpha + fres * 0.45 + smudge * 0.25 + fog * 0.55 + cr * 0.8, 0.0, 0.95);
}
