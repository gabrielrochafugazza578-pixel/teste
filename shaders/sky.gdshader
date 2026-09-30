shader_type sky;
// Ceu cartoon: degrade, sol e lua com bordas definidas, estrelas e nuvens em
// duas cores (estilo desenho animado).

uniform vec3 top_color : source_color = vec3(0.30, 0.60, 1.0);
uniform vec3 horizon_color : source_color = vec3(0.75, 0.90, 1.0);
uniform vec3 ground_color : source_color = vec3(0.55, 0.70, 0.85);
uniform vec3 sun_dir = vec3(0.0, 1.0, 0.0);
uniform vec3 sun_color : source_color = vec3(1.0, 0.95, 0.75);
uniform vec3 cloud_light : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 cloud_shade : source_color = vec3(0.72, 0.78, 0.92);
uniform float night = 0.0;
uniform float sunset = 0.0;
uniform float cloud_cover = 0.46;
uniform float cloud_time = 0.0;

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	float a = hash21(i);
	float b = hash21(i + vec2(1.0, 0.0));
	float c = hash21(i + vec2(0.0, 1.0));
	float d = hash21(i + vec2(1.0, 1.0));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += a * vnoise(p);
		p = p * 2.03 + vec2(17.1, 9.2);
		a *= 0.5;
	}
	return v;
}

void sky() {
	vec3 d = normalize(EYEDIR);
	float h = d.y;
	vec3 col = mix(horizon_color, top_color, smoothstep(0.0, 0.55, h));
	col = mix(col, ground_color, smoothstep(0.0, -0.25, h));

	vec3 sd = normalize(sun_dir);
	float sdot = dot(d, sd);
	// brilho do sol perto do horizonte (por do sol)
	col += sun_color * pow(max(sdot, 0.0), 12.0) * (0.25 + 0.5 * sunset) * (1.0 - night);

	if (!AT_CUBEMAP_PASS) {
		// estrelas
		if (night > 0.01 && h > 0.0) {
			vec2 suv = vec2(atan(d.x, d.z) * 60.0, d.y * 90.0);
			vec2 cell = floor(suv);
			float r = hash21(cell);
			if (r > 0.985) {
				vec2 center = vec2(hash21(cell + 3.1), hash21(cell + 7.7));
				float dist = length(fract(suv) - center);
				float tw = 0.6 + 0.4 * sin(TIME * (2.0 + r * 6.0) + r * 40.0);
				col += vec3(1.0, 0.95, 0.85) * smoothstep(0.12, 0.0, dist) * night * tw * smoothstep(0.0, 0.2, h);
			}
		}
		// sol: disco com borda definida
		float sun_disc = smoothstep(0.9982, 0.9986, sdot);
		col = mix(col, vec3(1.0, 0.97, 0.8) * 3.0, sun_disc * (1.0 - night * 0.9));
		// lua (lado oposto ao sol), em forma de crescente
		vec3 md = -sd;
		float mdot = dot(d, md);
		float moon = smoothstep(0.9990, 0.9993, mdot);
		vec3 offset_dir = normalize(md + vec3(0.02, 0.012, 0.0));
		float bite = smoothstep(0.9991, 0.9994, dot(d, offset_dir));
		col = mix(col, vec3(0.95, 0.95, 1.0) * 2.0, moon * (1.0 - bite) * night);
		col += vec3(0.4, 0.5, 0.9) * pow(max(mdot, 0.0), 60.0) * 0.4 * night;

		// nuvens cartoon
		if (h > 0.0) {
			vec2 uv = d.xz / (h + 0.12) * 1.3 + vec2(cloud_time * 0.02, cloud_time * 0.008);
			float n = fbm(uv);
			float mask = smoothstep(cloud_cover, cloud_cover + 0.015, n);
			float inner = smoothstep(cloud_cover + 0.05, cloud_cover + 0.06, fbm(uv - sd.xz * 0.06));
			vec3 cc = mix(cloud_shade, cloud_light, inner);
			float fade = smoothstep(0.02, 0.18, h);
			col = mix(col, cc, mask * fade * 0.95);
		}
	}
	COLOR = col;
}
