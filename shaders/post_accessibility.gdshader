// Filtros de acessibilidade para daltonismo (simulação/compensação Daltonize)
// e efeitos de estado do jogador (visão de febre/infecção, dano, exaustão).
// Aplicado num ColorRect de tela cheia SOMENTE quando necessário.
shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform int mode = 0; // 0 nenhum, 1 protanopia, 2 deuteranopia, 3 tritanopia
uniform float fever = 0.0;
uniform float damage = 0.0;
uniform float exhaustion = 0.0;
uniform float blur_vignette = 0.0;

vec3 daltonize(vec3 c, int m) {
	// RGB -> LMS
	float L = 17.8824 * c.r + 43.5161 * c.g + 4.11935 * c.b;
	float M = 3.45565 * c.r + 27.1554 * c.g + 3.86714 * c.b;
	float S = 0.0299566 * c.r + 0.184309 * c.g + 1.46709 * c.b;
	float l = L; float mm = M; float s = S;
	if (m == 1) { l = 2.02344 * M - 2.52581 * S; }
	else if (m == 2) { mm = 0.494207 * L + 1.24827 * S; }
	else { s = -0.395913 * L + 0.801109 * M; }
	vec3 sim;
	sim.r = 0.0809444479 * l - 0.130504409 * mm + 0.116721066 * s;
	sim.g = -0.0102485335 * l + 0.0540193266 * mm - 0.113614708 * s;
	sim.b = -0.000365296938 * l - 0.00412161469 * mm + 0.693511405 * s;
	vec3 err = c - sim;
	vec3 corr;
	corr.r = 0.0;
	corr.g = err.r * 0.7 + err.g;
	corr.b = err.r * 0.7 + err.b;
	return clamp(c + corr, 0.0, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 c = uv - 0.5;
	float r = length(c);
	if (fever > 0.0) {
		uv += vec2(sin(uv.y * 20.0 + TIME * 2.0), cos(uv.x * 18.0 + TIME * 1.7)) * 0.002 * fever;
	}
	vec3 col = textureLod(screen_tex, uv, blur_vignette * smoothstep(0.25, 0.7, r) * 3.0).rgb;
	if (mode > 0) {
		col = daltonize(col, mode);
	}
	col = mix(col, col * vec3(1.1, 0.95, 0.85), fever * 0.4);
	col = mix(col, col * vec3(1.0, 0.2, 0.15), damage * smoothstep(0.2, 0.75, r));
	col *= 1.0 - exhaustion * smoothstep(0.3, 0.8, r) * 0.8;
	COLOR = vec4(col, 1.0);
}
