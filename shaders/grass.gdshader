// Grama: moitas de 3 planos cruzados com a textura grass_bush.png
// (SimpleGrassTextured, IcterusGames, MIT) recortada por alpha scissor.
// Altura relativa no plano = VERTEX.y / 0.62 (0 raiz, 1 topo).
// Cor da instância (COLOR, MultiMesh use_colors): r = escala de altura, g = tom, b = secura.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform sampler2D grass_tex : source_color, filter_linear_mipmap, repeat_disable;
uniform vec3 tint = vec3(0.78, 0.86, 0.62);
uniform vec3 color_dry = vec3(0.62, 0.55, 0.3);
uniform float fade_distance = 30.0;
uniform float alpha_cut = 0.42;
uniform bool use_custom = true;

global uniform vec4 wind;
global uniform float veg_growth;
global uniform vec3 player_world_pos;
global uniform float wetness;

varying float v_h;
varying float v_tone;
varying float v_dry;
varying vec3 v_up;

void vertex() {
	float h = clamp(VERTEX.y / 0.62, 0.0, 1.0);
	vec4 ic = use_custom ? COLOR : vec4(1.0, 0.5, 0.2, 1.0);
	vec3 wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 origin = MODEL_MATRIX[3].xyz;
	float d = distance(origin, CAMERA_POSITION_WORLD);
	float fade = 1.0 - smoothstep(fade_distance * 0.7, fade_distance, d);
	float growth = mix(0.55, 1.35, veg_growth);
	vec3 local = VERTEX;
	local.y *= ic.r * growth * fade;
	local.xz *= mix(0.3, 1.0, fade);
	// vento (cada moita balança como um todo, a ponta mais que a base)
	float t = TIME * (1.2 + wind.w * 2.5);
	float wave = sin(t + origin.x * 0.35 + origin.z * 0.28) * 0.5 + 0.5;
	vec3 bend = vec3(wind.x, 0.0, wind.y) * (0.12 + wave * 0.3) * wind.z * h * h;
	bend.xz += vec2(sin(t * 2.3 + origin.z * 3.0 + wp.x), cos(t * 2.1 + origin.x * 3.0 + wp.z)) * 0.025 * h;
	// o jogador empurra a grama
	vec3 away = origin - player_world_pos;
	float pd = length(away.xz);
	float push = smoothstep(1.0, 0.15, pd) * step(abs(away.y), 1.5);
	bend.xz += normalize(away.xz + 0.001) * push * 0.4 * h;
	bend.y -= push * 0.22 * h;
	mat3 m = mat3(MODEL_MATRIX);
	float s2 = max(dot(m[0], m[0]), 0.0001);
	VERTEX = local + transpose(m) * bend / s2;
	v_h = h;
	v_tone = ic.g;
	v_dry = ic.b;
	// normal "de gramado" (para cima, levemente inclinada pelo plano): iluminação
	// uniforme nos dois lados do plano, sem face escura
	v_up = normalize((MODELVIEW_MATRIX * vec4(NORMAL * 0.25 + vec3(0.0, 1.0, 0.0), 0.0)).xyz);
}

void fragment() {
	vec4 tex = texture(grass_tex, UV);
	vec3 c = tex.rgb * tint * (0.82 + v_tone * 0.36);
	float lum = dot(c, vec3(0.3, 0.59, 0.11));
	c = mix(c, color_dry * lum * 2.2, v_dry * 0.8);
	c *= mix(0.5, 1.0, smoothstep(0.0, 0.55, v_h));   // raiz sombreada pela própria moita
	c *= mix(1.0, 0.72, wetness);
	ALBEDO = c;
	ALPHA = tex.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_cut;
	NORMAL = v_up;
	ROUGHNESS = mix(0.85, 0.45, wetness);
	BACKLIGHT = c * 0.35;
}
