// Água de rio/lago para o Forward+ (Vulkan): opaca, para receber os reflexos de
// tela (SSR) de prédios, árvores e céu (ler a profundidade da cena jogaria o
// material na passada transparente, que não tem SSR). No Compatibility usa-se
// water.gdshader (transparente).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform vec3 deep_color : source_color = vec3(0.025, 0.045, 0.045);
uniform vec3 shallow_color : source_color = vec3(0.13, 0.15, 0.11);
uniform vec3 sky_tint : source_color = vec3(0.45, 0.52, 0.58);
uniform float flow_speed = 0.03;
uniform vec2 flow_dir = vec2(1.0, 0.3);
uniform float murk = 0.6;

global uniform vec4 wind;
global uniform float rain_intensity;
global uniform float daylight;

varying vec3 w_pos;

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float t = TIME;
	VERTEX.y += (sin(w_pos.x * 0.35 + t * 1.1) + cos(w_pos.z * 0.3 + t * 0.9)) * 0.03 * (0.5 + wind.z);
}

void fragment() {
	vec2 fd = normalize(flow_dir);
	vec2 uv1 = w_pos.xz * 0.06 + fd * TIME * flow_speed;
	vec2 uv2 = w_pos.xz * 0.11 - vec2(fd.y, -fd.x) * TIME * flow_speed * 1.4;
	vec3 n1 = texture(noise_tex, uv1).rgb;
	vec3 n2 = texture(noise_tex, uv2).gbr;
	vec2 nxy = ((n1.rg + n2.rg) - 1.0) * (0.3 + wind.z * 0.35);
	if (rain_intensity > 0.05) {
		vec2 rp = w_pos.xz * 2.2;
		vec2 ci = floor(rp);
		vec2 cf = fract(rp) - 0.5;
		float h = fract(sin(dot(ci, vec2(12.9898, 78.233))) * 43758.5453);
		float t = fract(TIME * 1.4 + h * 5.0);
		float ring = sin((length(cf) - t * 0.5) * 40.0) * smoothstep(0.5, 0.0, length(cf)) * (1.0 - t);
		nxy += normalize(cf + 0.0001) * ring * 0.4 * rain_intensity;
	}
	// espuma rala em manchas que correm com a água
	float foam_n = texture(noise_tex, w_pos.xz * 0.05 + fd * TIME * flow_speed * 0.8).b;
	float foam = smoothstep(0.78, 0.92, foam_n) * 0.35 * (0.4 + wind.z);
	float shore = 0.0;
	vec3 body = mix(shallow_color, deep_color, murk);
	// um pouco do céu na cor (a água turva espalha a luz); o reflexo de verdade vem
	// do especular (céu + SSR)
	body = mix(body, sky_tint * (0.2 + daylight * 0.6), 0.08);
	vec3 alb = mix(body, vec3(0.7, 0.72, 0.7) * (0.25 + daylight * 0.75), foam * 0.7);
	ALBEDO = alb;
	ROUGHNESS = mix(0.03, 0.5, foam);
	METALLIC = 0.0;
	SPECULAR = 0.6;
	NORMAL_MAP = normalize(vec3(nxy * (1.0 - shore * 0.5), 1.0)) * 0.5 + 0.5;
}
