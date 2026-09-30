// Terreno: mistura grama / terra / rocha / cascalho por splat (COLOR) + inclinação.
// Variação macro por ruído quebra a repetição de tiles vista de longe.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2DArray tex_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2DArray tex_b : filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform float grass_scale = 0.45;
uniform float dirt_scale = 0.5;
uniform float rock_scale = 0.22;
uniform float gravel_scale = 0.8;

global uniform float wetness;
global uniform float world_decay;
global uniform float rain_intensity;

varying vec3 w_pos;
varying vec3 w_nrm;
varying vec4 splat;

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	w_nrm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	splat = COLOR;
}

void fragment() {
	vec2 uv = w_pos.xz;
	vec4 macro = texture(noise_tex, uv * 0.0035);
	vec4 meso = texture(noise_tex, uv * 0.021);
	float slope = 1.0 - clamp(w_nrm.y, 0.0, 1.0);
	float w_rock = clamp(splat.g + smoothstep(0.28, 0.5, slope), 0.0, 1.0);
	float w_dirt = clamp(splat.r + smoothstep(0.55, 0.75, meso.r) * 0.5 * (1.0 - world_decay * 0.4), 0.0, 1.0) * (1.0 - w_rock);
	float w_grav = clamp(splat.b, 0.0, 1.0) * (1.0 - w_rock);
	float w_grass = clamp(1.0 - w_rock - w_dirt - w_grav, 0.0, 1.0);

	vec4 ga = texture(tex_a, vec3(uv * grass_scale, 7.0));
	vec4 gb = texture(tex_b, vec3(uv * grass_scale, 7.0));
	vec4 da = texture(tex_a, vec3(uv * dirt_scale, 8.0));
	vec4 db = texture(tex_b, vec3(uv * dirt_scale, 8.0));
	vec4 ra = texture(tex_a, vec3(uv * rock_scale, 9.0));
	vec4 rb = texture(tex_b, vec3(uv * rock_scale, 9.0));
	vec4 ca = ga;
	vec4 cb = gb;
	if (w_grav > 0.01) {
		ca = texture(tex_a, vec3(uv * gravel_scale, 12.0));
		cb = texture(tex_b, vec3(uv * gravel_scale, 12.0));
	}
	float tot = w_grass + w_dirt + w_rock + w_grav + 0.0001;
	vec4 A = (ga * w_grass + da * w_dirt + ra * w_rock + ca * w_grav) / tot;
	vec4 B = (gb * w_grass + db * w_dirt + rb * w_rock + cb * w_grav) / tot;

	vec3 alb = A.rgb;
	// variação macro de cor (manchas secas / úmidas)
	alb *= 0.82 + macro.r * 0.36;
	alb = mix(alb, alb * vec3(1.12, 1.02, 0.78), smoothstep(0.55, 0.8, macro.g) * w_grass * 0.6);
	// pós-colapso: vegetação mais alta/escura e descuidada
	alb = mix(alb, alb * vec3(0.85, 1.05, 0.8), world_decay * w_grass * 0.35);
	float rough = A.a;
	vec2 nxy = B.rg * 2.0 - 1.0;
	vec3 nmap = vec3(nxy, sqrt(max(0.0, 1.0 - dot(nxy, nxy))));

	if (wetness > 0.01) {
		float wet = wetness * (0.5 + 0.5 * (1.0 - slope));
		alb *= mix(1.0, 0.6, wet);
		rough = mix(rough, 0.35, wet * 0.8);
		float puddle = smoothstep(0.66 - wetness * 0.12, 0.7 - wetness * 0.12, meso.b * 0.6 + macro.r * 0.4) * (w_dirt + w_grav) * smoothstep(0.35, 0.7, wetness) * (1.0 - slope);
		alb = mix(alb, vec3(0.05, 0.045, 0.04), puddle * 0.8);
		rough = mix(rough, 0.03, puddle);
		nmap = normalize(mix(nmap, vec3(0.0, 0.0, 1.0), puddle));
	}

	ALBEDO = alb;
	ROUGHNESS = rough;
	METALLIC = 0.0;
	NORMAL_MAP = nmap * 0.5 + 0.5;
	AO = B.b;
	AO_LIGHT_AFFECT = 0.3;
}
