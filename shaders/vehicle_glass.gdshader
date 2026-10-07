// Vidro de carro abandonado: película de poeira irregular (o grão vem da foto de
// terra das camadas do mundo) e marcas verticais de água de chuva que secou.
// Projeção dominante no espaço do objeto, como a pintura.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 glass_color : source_color = vec4(0.27, 0.28, 0.27, 1.0);
uniform float glass_roughness = 0.42;
uniform float glass_metal = 0.15;
uniform float dirt : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform sampler2DArray tex_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;

global uniform float wetness;

varying vec3 l_pos;
varying vec3 l_nrm;

void vertex() {
	l_pos = VERTEX;
	l_nrm = NORMAL;
}

void fragment() {
	vec3 an = abs(l_nrm);
	vec2 uv = an.y > 0.6 ? l_pos.xz : (an.x > an.z ? l_pos.zy : l_pos.xy);
	vec4 n = texture(noise_tex, uv * 0.6);
	vec4 d = texture(tex_a, vec3(uv * 3.1 + vec2(0.2, 0.7), 8.0));
	float lum = dot(d.rgb, vec3(0.3, 0.59, 0.11));
	// (o ruído fica em ~0,32 ± 0,09 no canal R)
	float film = clamp(dirt * (0.18 + (n.r - 0.32) * 3.0 + (lum - 0.2) * 0.8), 0.0, 1.0);
	// água que escorreu e secou: filetes verticais mais limpos e bordas sujas
	float streak = texture(noise_tex, vec2(uv.x * 2.3, uv.y * 0.08)).g;
	float clean_line = smoothstep(0.62, 0.78, streak);
	film = clamp(film * (1.0 - clean_line * 0.6) + smoothstep(0.5, 0.6, streak) * (1.0 - clean_line) * dirt * 0.25, 0.0, 1.0);
	// a chuva lava um pouco a película
	film *= 1.0 - wetness * 0.4;
	vec3 dust = mix(vec3(0.4, 0.37, 0.32), vec3(0.55, 0.51, 0.45), clamp(lum * 2.0, 0.0, 1.0));
	ALBEDO = mix(glass_color.rgb, dust * 0.8, film * 0.6);
	ROUGHNESS = mix(glass_roughness, 0.8, film * 0.8);
	METALLIC = mix(glass_metal, 0.0, film);
	SPECULAR = 0.5;
}
