// Telas de computador/equipamentos (laboratório NEXUS, delegacia, hospital).
// style: 0 código/terminal, 1 gráfico + hélice, 2 alerta de contenção, 3 monitor cardíaco,
//        4 telejornal (plantão com tarja e letreiro)
shader_type spatial;
render_mode unshaded, cull_back;

uniform int style = 0;
uniform float power : hint_range(0.0, 1.0) = 1.0;
uniform float glitch : hint_range(0.0, 1.0) = 0.0;
uniform vec3 tint : source_color = vec3(0.45, 0.85, 0.75);
uniform float seed = 0.0;
uniform float heart_rate = 1.2;

float h11(float x) { return fract(sin(x * 91.345 + seed * 13.1) * 47453.5453); }

void fragment() {
	vec2 uv = UV;
	float t = TIME + seed * 10.0;
	if (glitch > 0.0) {
		float band = step(0.93 - glitch * 0.3, h11(floor(uv.y * 30.0) + floor(t * 12.0)));
		uv.x += band * (h11(floor(t * 20.0)) - 0.5) * 0.2 * glitch;
	}
	vec3 bg = vec3(0.01, 0.02, 0.025);
	vec3 col = bg;
	if (style == 0) {
		float line = floor(uv.y * 26.0 + t * 1.5);
		float len = 0.2 + h11(line) * 0.7;
		float indent = floor(h11(line + 3.0) * 4.0) * 0.05;
		float chars = step(0.35, h11(floor(uv.x * 60.0) + line * 7.0));
		float on = step(indent + 0.05, uv.x) * step(uv.x, len) * chars * step(0.25, fract(uv.y * 26.0 + t * 1.5));
		col += tint * on * 0.8;
		col += tint * 0.12 * step(0.9, uv.y);
	} else if (style == 1) {
		// hélice dupla estilizada + gráfico de barras
		float x = uv.x * 12.0 + t;
		float y1 = 0.62 + sin(x) * 0.12;
		float y2 = 0.62 - sin(x) * 0.12;
		float d = min(abs(uv.y - y1), abs(uv.y - y2));
		col += tint * smoothstep(0.012, 0.0, d);
		float rung = step(0.85, fract(x / 3.14159 * 2.0)) * step(min(y1, y2), uv.y) * step(uv.y, max(y1, y2));
		col += tint * 0.3 * rung * step(0.42, uv.y);
		float bar = step(uv.y, 0.08 + h11(floor(uv.x * 20.0) + floor(t * 0.5)) * 0.25) * step(0.02, fract(uv.x * 20.0));
		col += vec3(0.9, 0.5, 0.3) * bar * step(uv.y, 0.35) * 0.6;
	} else if (style == 2) {
		float blink = step(0.5, fract(t * 1.6));
		vec3 red = vec3(1.0, 0.12, 0.08);
		col = mix(vec3(0.08, 0.0, 0.0), red * 0.6, blink * 0.6);
		float stripes = step(0.5, fract((uv.x + uv.y) * 10.0 - t));
		float bandy = step(0.35, uv.y) * step(uv.y, 0.65);
		col = mix(col, red * (0.4 + stripes * 0.6), (1.0 - bandy) * 0.4);
		col += red * bandy * step(0.2, uv.x) * step(uv.x, 0.8) * step(0.4, fract(uv.x * 30.0)) * 0.7 * blink;
	} else if (style == 4) {
		// telejornal: fundo azul, apresentador em silhueta, tarja "URGENTE" e letreiro correndo
		uv.y = 1.0 - uv.y;   // UV.y cresce para baixo; aqui y = altura na tela
		col = mix(vec3(0.02, 0.06, 0.16), vec3(0.08, 0.2, 0.42), uv.y);
		col += vec3(0.1, 0.18, 0.3) * step(0.5, fract(uv.x * 8.0 + uv.y * 3.0)) * 0.12;
		vec2 hc = vec2(0.5, 0.62);
		float head = smoothstep(0.1, 0.095, length((uv - hc) * vec2(1.0, 0.8)));
		float body = smoothstep(0.0, 0.01, 0.35 - abs(uv.x - 0.5) - (uv.y - 0.1) * 0.9) * step(0.12, uv.y) * step(uv.y, 0.5);
		col = mix(col, vec3(0.05, 0.05, 0.07), max(head, body) * 0.9);
		float band = step(0.14, uv.y) * step(uv.y, 0.27);
		col = mix(col, vec3(0.78, 0.06, 0.05), band);
		float ticker = step(0.5, h11(floor((uv.x + t * 0.25) * 40.0))) * step(0.45, fract((uv.x + t * 0.25) * 40.0));
		col = mix(col, vec3(0.95), band * ticker * step(0.17, uv.y) * step(uv.y, 0.24) * 0.9);
		float top = step(0.84, uv.y) * step(uv.y, 0.92) * step(0.06, uv.x) * step(uv.x, 0.34);
		col = mix(col, vec3(0.95, 0.85, 0.2), top * (0.6 + 0.4 * step(0.5, fract(t))));
	} else {
		// monitor cardíaco
		float x = fract(uv.x - t * 0.25);
		float beat = fract(x * 3.0 * heart_rate);
		float ecg = 0.5 + (smoothstep(0.1, 0.13, beat) - smoothstep(0.13, 0.16, beat)) * 0.35
			- (smoothstep(0.16, 0.19, beat) - smoothstep(0.19, 0.22, beat)) * 0.2
			+ sin(beat * 6.28) * 0.02;
		float d = abs(uv.y - ecg);
		float trail = smoothstep(0.0, 0.6, fract(uv.x - t * 0.25));
		col += vec3(0.3, 1.0, 0.45) * smoothstep(0.015, 0.0, d) * trail;
		col += vec3(0.05, 0.2, 0.1) * step(0.98, fract(uv.x * 10.0));
	}
	float scan = 0.85 + 0.15 * sin(uv.y * 600.0);
	float vign = smoothstep(0.75, 0.3, length(uv - 0.5));
	col *= scan * (0.6 + vign * 0.5);
	ALBEDO = col * power * 1.8;
}
