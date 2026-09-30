shader_type spatial;
render_mode unshaded, depth_draw_never, depth_test_disabled, cull_disabled, blend_mix, fog_disabled, shadows_disabled;
// Contorno de desenho animado desenhado na tela inteira: detecta bordas pela
// profundidade (silhuetas) e pela mudanca brusca de normal (quinas).

uniform sampler2D depth_tex : hint_depth_texture, filter_nearest, repeat_disable;
uniform sampler2D normal_tex : hint_normal_roughness_texture, filter_nearest, repeat_disable;
uniform vec3 line_color : source_color = vec3(0.10, 0.07, 0.15);
uniform float thickness = 2.0;
uniform float depth_threshold = 0.03;
uniform float normal_threshold = 0.9;
uniform float max_distance = 120.0;
uniform float sea_level = 23.65;
uniform float strength = 0.95;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float lin_depth(vec2 uv, mat4 inv_proj) {
	float d = texture(depth_tex, uv).r;
	vec4 v = inv_proj * vec4(uv * 2.0 - 1.0, d, 1.0);
	return -v.z / v.w;
}

vec3 nrm(vec2 uv) {
	return normalize(texture(normal_tex, uv).xyz * 2.0 - 1.0);
}

void fragment() {
	vec2 px = thickness / VIEWPORT_SIZE;
	vec2 uv = SCREEN_UV;
	float d = lin_depth(uv, INV_PROJECTION_MATRIX);
	float dl = lin_depth(uv + vec2(-px.x, 0.0), INV_PROJECTION_MATRIX);
	float dr = lin_depth(uv + vec2(px.x, 0.0), INV_PROJECTION_MATRIX);
	float du = lin_depth(uv + vec2(0.0, -px.y), INV_PROJECTION_MATRIX);
	float dd = lin_depth(uv + vec2(0.0, px.y), INV_PROJECTION_MATRIX);
	float dmin = min(d, min(min(dl, dr), min(du, dd)));

	// segunda derivada da profundidade: ignora superficies inclinadas, pega silhuetas
	float lap = abs(dl + dr - 2.0 * d) + abs(du + dd - 2.0 * d);
	float depth_edge = smoothstep(depth_threshold, depth_threshold * 1.6, lap / max(dmin, 0.1));

	vec3 n = nrm(uv);
	float nd = (1.0 - dot(n, nrm(uv + vec2(-px.x, 0.0)))) + (1.0 - dot(n, nrm(uv + vec2(px.x, 0.0))))
		+ (1.0 - dot(n, nrm(uv + vec2(0.0, -px.y)))) + (1.0 - dot(n, nrm(uv + vec2(0.0, px.y))));
	float normal_edge = smoothstep(normal_threshold, normal_threshold * 1.3, nd) * step(dmin, 60.0);

	float edge = max(depth_edge, normal_edge);
	float fade = 1.0 - smoothstep(max_distance * 0.7, max_distance, dmin);

	// linhas de coisas embaixo d'agua ficam bem mais fracas
	vec4 vpos = INV_PROJECTION_MATRIX * vec4(uv * 2.0 - 1.0, texture(depth_tex, uv).r, 1.0);
	vpos.xyz /= vpos.w;
	vec3 wpos = (INV_VIEW_MATRIX * vec4(vpos.xyz, 1.0)).xyz;
	vec3 cam = INV_VIEW_MATRIX[3].xyz;
	float under = step(wpos.y, sea_level) * step(sea_level, cam.y);
	fade *= mix(1.0, 0.15, under);

	ALBEDO = line_color;
	ALPHA = edge * fade * strength;
}
