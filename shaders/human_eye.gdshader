// Olhos (MakeHuman CC0): íris em foto, córnea molhada. Infectados: olho leitoso
// (catarata) ou injetado de sangue.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
instance uniform float infection : instance_index(0) = 0.0;
instance uniform float eye_cloud : instance_index(4) = 0.0;

void fragment() {
	vec4 ta = texture(albedo_tex, UV);
	// a "córnea" do MakeHuman aponta para a área transparente da textura
	if (ta.a < 0.5) {
		discard;
	}
	vec3 c = ta.rgb;
	float l = dot(c, vec3(0.3, 0.59, 0.11));
	// íris/pupila são as partes escuras da textura; esclera é a clara
	float iris = 1.0 - smoothstep(0.35, 0.6, l);
	vec3 milky = vec3(0.62, 0.62, 0.56);
	c = mix(c, mix(c, milky, 0.85), eye_cloud * iris);
	// esclera amarelada e com vasos nos infectados
	c = mix(c, c * vec3(1.0, 0.8, 0.62), infection * (1.0 - iris) * 0.7);
	// sombra da pálpebra de cima e dos cílios sobre o globo (sem ela o olho
	// "acende" e parece de boneco): a parte que aponta para cima escurece
	float up = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).y;
	float lid = smoothstep(-0.05, 0.45, up);
	c *= mix(1.0, 0.45, lid);
	// esclera nunca é branco puro
	c = mix(c, c * vec3(0.93, 0.88, 0.85), 1.0 - iris);
	ALBEDO = c * 0.88;
	ROUGHNESS = 0.06;
	SPECULAR = 0.6;
	CLEARCOAT = 1.0;
	CLEARCOAT_ROUGHNESS = 0.02;
}
