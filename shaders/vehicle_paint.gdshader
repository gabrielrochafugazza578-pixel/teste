// Pintura de carro: cor da instância (MultiMesh) ou do veículo dirigível, com
// sujeira que se acumula embaixo e poeira nas faces de cima, ferrugem em manchas
// e carcaça queimada. Ruído em projeção dominante no espaço do objeto.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 paint_color : source_color = vec4(1.0);
uniform float dirt : hint_range(0.0, 1.0) = 0.0;
uniform float rust : hint_range(0.0, 1.0) = 0.0;
uniform float burn : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;

varying vec3 l_pos;
varying vec3 l_nrm;

void vertex() {
	l_pos = VERTEX;
	l_nrm = NORMAL;
}

void fragment() {
	vec3 base = COLOR.rgb * paint_color.rgb;
	vec3 an = abs(l_nrm);
	vec2 uv = an.y > 0.6 ? l_pos.xz : (an.x > an.z ? l_pos.zy : l_pos.xy);
	vec4 n = texture(noise_tex, uv * 0.35);
	vec4 n2 = texture(noise_tex, uv * 1.9 + vec2(0.37, 0.11));
	float low = smoothstep(0.95, 0.25, l_pos.y);
	float top = smoothstep(0.55, 0.92, l_nrm.y);
	float d = clamp(dirt * (low * 0.95 + top * 0.75 + n.r * 0.35) * (0.55 + n2.g * 0.9), 0.0, 1.0);
	vec3 dirt_col = mix(vec3(0.3, 0.27, 0.22), vec3(0.52, 0.48, 0.41), n2.b);
	vec3 alb = mix(base, dirt_col, d * 0.85);
	float r = smoothstep(0.6, 0.8, n.g * 0.7 + n2.r * 0.5) * rust;
	alb = mix(alb, vec3(0.3, 0.13, 0.05) * (0.7 + n2.b * 0.6), r);
	vec3 charred = mix(vec3(0.028, 0.026, 0.025), vec3(0.24, 0.11, 0.05), smoothstep(0.45, 0.8, n.b * 0.8 + n2.r * 0.4));
	alb = mix(alb, charred, burn);
	float wear = max(max(d, r), burn);
	ALBEDO = alb;
	METALLIC = mix(0.4, 0.0, wear);
	ROUGHNESS = mix(0.28, 0.95, wear);
	SPECULAR = 0.5;
}
