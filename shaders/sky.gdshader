// Céu procedural: gradiente atmosférico, sol, lua, estrelas e nuvens em
// camadas controladas pelo clima (cobertura/escurecimento) e pelo horário.
shader_type sky;

uniform vec3 zenith_color : source_color = vec3(0.2, 0.35, 0.6);
uniform vec3 horizon_color : source_color = vec3(0.65, 0.7, 0.75);
uniform vec3 ground_color : source_color = vec3(0.12, 0.12, 0.12);
uniform vec3 sun_color : source_color = vec3(1.0, 0.9, 0.75);
uniform vec3 cloud_light : source_color = vec3(0.95, 0.93, 0.9);
uniform vec3 cloud_shadow : source_color = vec3(0.35, 0.37, 0.42);
uniform vec3 moon_dir = vec3(0.3, 0.6, -0.7);
uniform float cloud_cover : hint_range(0.0, 1.0) = 0.35;
uniform float cloud_dark : hint_range(0.0, 1.0) = 0.0;
uniform float star_strength : hint_range(0.0, 1.0) = 0.0;
uniform float sun_size = 0.9994;
uniform float flash = 0.0;
uniform float haze = 0.3;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;

global uniform vec4 wind;

float h31(vec3 p) {
	p = fract(p * 0.3183099 + 0.1);
	p *= 17.0;
	return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

void sky() {
	vec3 d = normalize(EYEDIR);
	float up = d.y;
	float t = clamp(up, 0.0, 1.0);
	vec3 col = mix(horizon_color, zenith_color, pow(t, 0.55));
	if (up < 0.0) {
		col = mix(horizon_color, ground_color, clamp(-up * 4.0, 0.0, 1.0));
	}
	vec3 sd = LIGHT0_ENABLED ? normalize(LIGHT0_DIRECTION) : vec3(0.0, 1.0, 0.0);
	float sdot = dot(d, sd);
	// halo atmosférico ao redor do sol
	col += sun_color * pow(max(sdot, 0.0), 8.0) * 0.35 * (1.0 - cloud_cover * 0.6);
	col += sun_color * pow(max(sdot, 0.0), 64.0) * 0.4 * (1.0 - cloud_cover * 0.7);
	// disco solar
	if (!AT_CUBEMAP_PASS) {
		col += sun_color * smoothstep(sun_size, sun_size + 0.0003, sdot) * 12.0 * (1.0 - cloud_cover * 0.9);
	}
	// estrelas + lua
	if (star_strength > 0.01 && up > 0.0) {
		vec3 sp = floor(d * 280.0);
		float st = step(0.9975, h31(sp)) * h31(sp + 3.0);
		float twinkle = 0.7 + 0.3 * sin(TIME * 3.0 + h31(sp + 7.0) * 30.0);
		col += vec3(st * twinkle) * star_strength * (1.0 - cloud_cover) * smoothstep(0.0, 0.2, up);
		float md = dot(d, normalize(moon_dir));
		col += vec3(0.85, 0.88, 0.95) * smoothstep(0.9993, 0.99955, md) * star_strength * 1.5;
		col += vec3(0.25, 0.28, 0.35) * pow(max(md, 0.0), 24.0) * star_strength * 0.4;
	}
	// nuvens
	if (up > -0.02) {
		vec2 cuv = d.xz / (max(up, 0.0) + 0.12);
		vec2 drift = vec2(wind.x, wind.y) * TIME * (0.004 + wind.z * 0.01);
		float n1 = texture(noise_tex, cuv * 0.09 + drift).r;
		float n2 = texture(noise_tex, cuv * 0.27 + drift * 1.7).g;
		float n3 = texture(noise_tex, cuv * 0.8 + drift * 2.3).b;
		float dens = n1 * 0.65 + n2 * 0.28 + n3 * 0.07;
		// o ruído fica entre ~0,25 e ~0,55 (mediana 0,35): normaliza para 0..1, senão
		// só o céu totalmente encoberto tinha nuvem e o "parcialmente" era liso
		dens = clamp((dens - 0.25) / 0.32, 0.0, 1.0);
		float thr = mix(0.75, 0.0, cloud_cover);
		// borda mais definida: nuvem de tempo bom tem contorno (não é só uma mancha)
		float c = smoothstep(thr, thr + 0.13, dens);
		// encoberto/chuva: as nuvens se fundem num teto contínuo (só o relevo varia)
		c = max(c, smoothstep(0.7, 0.97, cloud_cover));
		float shade = 0.35 + 0.65 * smoothstep(thr + 0.55, thr - 0.05, dens + n2 * 0.1);
		vec3 cc = mix(cloud_shadow, cloud_light, shade * (1.0 - cloud_dark * 0.8));
		cc += sun_color * pow(max(sdot, 0.0), 6.0) * 0.4 * (1.0 - c * 0.5);
		cc = mix(cc, cloud_shadow * 0.45, cloud_dark * 0.6);
		float fade = smoothstep(-0.02, 0.18, up);
		col = mix(col, cc, c * fade * 0.95);
	}
	// neblina/haze no horizonte (casa com a fog do ambiente)
	col = mix(col, horizon_color, haze * (1.0 - smoothstep(0.0, 0.35, abs(up))));
	col += vec3(0.7, 0.75, 0.9) * flash;
	COLOR = col;
}
