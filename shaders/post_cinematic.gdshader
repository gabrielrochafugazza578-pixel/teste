// Tratamento de imagem "de câmera" sobre o 3D (antes da interface): nitidez
// (devolve o detalhe que o TAA e a escala de resolução borram), gradação de cor
// com sombras levemente frias e altas luzes quentes, curva em S suave,
// saturação maior nos meios-tons, vinheta, aberração cromática nas bordas e
// granulação de filme fina. Uma passada de tela cheia, barata.
shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float sharpen = 0.5;
uniform float grade = 1.0;
uniform float vignette = 0.22;
uniform float aberration = 0.0018;
uniform float grain = 0.028;
uniform vec3 shadow_tint = vec3(0.93, 0.99, 1.06);
uniform vec3 high_tint = vec3(1.05, 1.0, 0.94);

float luma(vec3 c) {
	return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 px = SCREEN_PIXEL_SIZE;
	vec2 c = uv - 0.5;
	float r2 = dot(c, c);
	// aberração cromática: cresce com o quadrado da distância ao centro
	vec2 ca = c * aberration * r2 * 4.0;
	vec3 col = vec3(texture(screen_tex, uv - ca).r, texture(screen_tex, uv).g, texture(screen_tex, uv + ca).b);
	// nitidez adaptativa (máscara de nitidez em cruz, limitada: sem halo)
	vec3 n = texture(screen_tex, uv + vec2(px.x, 0.0)).rgb + texture(screen_tex, uv - vec2(px.x, 0.0)).rgb
		+ texture(screen_tex, uv + vec2(0.0, px.y)).rgb + texture(screen_tex, uv - vec2(0.0, px.y)).rgb;
	vec3 detail = col - n * 0.25;
	col += clamp(detail * sharpen * 2.0, vec3(-0.06), vec3(0.06));
	// gradação
	float l = luma(col);
	vec3 g = col * mix(shadow_tint, high_tint, smoothstep(0.08, 0.7, l));
	// curva em S só nos meios-tons e altas luzes; as sombras ganham um "pé"
	// levantado (sem esmagar o preto: a sombra das ruas continua legível)
	g = mix(g, g * g * (3.0 - 2.0 * g), 0.14 * smoothstep(0.15, 0.5, l));
	g += vec3(0.012, 0.014, 0.018) * (1.0 - smoothstep(0.0, 0.25, l));
	float lg = luma(g);
	g = mix(vec3(lg), g, mix(0.9, 1.12, smoothstep(0.04, 0.45, lg)) * mix(1.0, 0.92, smoothstep(0.75, 1.0, lg)));
	col = mix(col, g, grade);
	// vinheta (escurece os cantos como uma lente de verdade)
	col *= 1.0 - vignette * smoothstep(0.12, 0.6, r2 * 1.6);
	// granulação: ruído por pixel que muda a cada quadro, mais nos meios-tons
	vec2 gp = floor(uv / px);
	float nz = fract(sin(dot(gp + fract(TIME * 13.17) * vec2(193.1, 71.7), vec2(12.9898, 78.233))) * 43758.5453);
	col += (nz - 0.5) * grain * (0.5 + 0.5 * (1.0 - abs(l * 2.0 - 1.0)));
	COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
}
