// Grama geométrica (tufos de lâminas, SEM transparência => early-Z preservado).
// COLOR.r = altura relativa na lâmina (0 raiz, 1 ponta), COLOR.g = variação.
// INSTANCE_CUSTOM: r = escala de altura, g = tom, b = secura.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform vec3 color_root = vec3(0.05, 0.08, 0.02);
uniform vec3 color_tip = vec3(0.22, 0.3, 0.09);
uniform vec3 color_dry = vec3(0.38, 0.33, 0.16);
uniform float fade_distance = 30.0;
uniform bool use_custom = true;

global uniform vec4 wind;
global uniform float veg_growth;
global uniform vec3 player_world_pos;
global uniform float wetness;

varying float v_h;
varying float v_tone;
varying float v_dry;

void vertex() {
	float h = COLOR.r;
	vec4 ic = use_custom ? INSTANCE_CUSTOM : vec4(1.0, 0.5, 0.2, 0.0);
	vec3 wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float d = distance(wp, CAMERA_POSITION_WORLD);
	float fade = 1.0 - smoothstep(fade_distance * 0.7, fade_distance, d);
	float growth = mix(0.55, 1.35, veg_growth);
	float scale_y = ic.r * growth * fade;
	vec3 local = VERTEX;
	local.y *= scale_y;
	local.xz *= mix(0.2, 1.0, fade);
	// vento
	float t = TIME * (1.2 + wind.w * 2.5);
	float wave = sin(t + wp.x * 0.35 + wp.z * 0.28) * 0.5 + 0.5;
	vec3 bend = vec3(wind.x, 0.0, wind.y) * (0.15 + wave * 0.35) * wind.z * h * h;
	bend.xz += vec2(sin(t * 2.3 + wp.z * 3.0), cos(t * 2.1 + wp.x * 3.0)) * 0.03 * h;
	// jogador empurra a grama
	vec3 away = wp - player_world_pos;
	float pd = length(away.xz);
	float push = smoothstep(1.1, 0.2, pd) * step(abs(away.y), 1.5);
	bend.xz += normalize(away.xz + 0.001) * push * 0.45 * h;
	bend.y -= push * 0.25 * h;
	mat3 m = mat3(MODEL_MATRIX);
	float s2 = max(dot(m[0], m[0]), 0.0001);
	VERTEX = local + transpose(m) * bend / s2;
	v_h = h;
	v_tone = ic.g + COLOR.g * 0.3;
	v_dry = ic.b;
	NORMAL = normalize(mix(NORMAL, vec3(0.0, 1.0, 0.0), 0.6));
}

void fragment() {
	vec3 tip = mix(color_tip * (0.8 + v_tone * 0.4), color_dry, v_dry);
	vec3 c = mix(color_root, tip, smoothstep(0.0, 1.0, v_h));
	c *= mix(1.0, 0.7, wetness);
	ALBEDO = c;
	ROUGHNESS = mix(0.85, 0.45, wetness);
	AO = mix(0.35, 1.0, v_h);
	AO_LIGHT_AFFECT = 0.6;
}
