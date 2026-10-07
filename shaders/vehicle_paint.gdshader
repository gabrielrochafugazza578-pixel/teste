// Pintura de carro: cor da instância (MultiMesh) ou do veículo dirigível, com
// sujeira que se acumula embaixo e poeira nas faces de cima, ferrugem em manchas
// e carcaça queimada. A ferrugem, a lama e a lataria queimada vêm das fotos das
// camadas do mundo (chapa enferrujada e terra do Poly Haven), com relevo, em
// projeção dominante no espaço do objeto; o ruído só decide onde cada uma aparece.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 paint_color : source_color = vec4(1.0);
uniform float dirt : hint_range(0.0, 1.0) = 0.0;
uniform float rust : hint_range(0.0, 1.0) = 0.0;
uniform float burn : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform sampler2DArray tex_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2DArray tex_b : filter_linear_mipmap_anisotropic, repeat_enable;
uniform bool has_height = false;

global uniform float wetness;

varying vec3 l_pos;
varying vec3 l_nrm;

void vertex() {
	l_pos = VERTEX;
	l_nrm = NORMAL;
}

// normal de foto (OpenGL, RG) aplicada na normal de tela pela base tangente
// das derivadas (a projeção é por eixo: a malha não tem tangente para ela)
vec3 bump(vec3 n_view, vec3 pos_view, vec2 uv, vec2 nxy, float k) {
	vec3 dpx = dFdx(pos_view);
	vec3 dpy = dFdy(pos_view);
	vec2 dux = dFdx(uv);
	vec2 duy = dFdy(uv);
	vec3 p2 = cross(dpy, n_view);
	vec3 p1 = cross(n_view, dpx);
	vec3 T = p2 * dux.x + p1 * duy.x;
	vec3 B = p2 * dux.y + p1 * duy.y;
	float inv = inversesqrt(max(max(dot(T, T), dot(B, B)), 1e-12));
	return normalize(n_view + (T * nxy.x - B * nxy.y) * inv * k);
}

void fragment() {
	vec3 base = COLOR.rgb * paint_color.rgb;
	vec3 an = abs(l_nrm);
	vec2 uv = an.y > 0.6 ? l_pos.xz : (an.x > an.z ? l_pos.zy : l_pos.xy);
	vec4 n = texture(noise_tex, uv * 0.35);
	vec4 n2 = texture(noise_tex, uv * 1.9 + vec2(0.37, 0.11));
	// fotos: chapa enferrujada (camada 5) e terra (camada 8)
	vec2 ruv = uv * 0.9 + vec2(0.13, 0.41);
	vec4 ra = texture(tex_a, vec3(ruv, 5.0));
	vec4 rb = texture(tex_b, vec3(ruv, 5.0));
	vec2 duv = uv * 2.4 + vec2(0.61, 0.27);
	vec4 da = texture(tex_a, vec3(duv, 8.0));
	vec4 db = texture(tex_b, vec3(duv, 8.0));
	float dlum = dot(da.rgb, vec3(0.3, 0.59, 0.11));
	float dh = has_height ? db.a : dlum * 2.0;

	float low = smoothstep(0.95, 0.25, l_pos.y);
	float top = smoothstep(0.55, 0.92, l_nrm.y);
	// lama/poeira: o grão da foto de terra recorta a borda da mancha
	float d = clamp(dirt * (low * 0.95 + top * 0.75 + n.r * 0.35) * (0.55 + n2.g * 0.9) + (dh - 0.5) * 0.35 * dirt, 0.0, 1.0);
	d = smoothstep(0.08, 0.7, d);
	// poeira fina por cima, lama da foto de terra embaixo (respingo das rodas)
	vec3 dust = mix(vec3(0.38, 0.34, 0.28), vec3(0.52, 0.48, 0.41), dlum);
	vec3 dirt_col = mix(dust, da.rgb * vec3(1.15, 1.08, 0.98), low * 0.8);
	vec3 alb = mix(base, dirt_col, d * 0.88);
	// ferrugem: manchas que começam embaixo e nas bordas; o metal nu da foto
	// (canal de metal da chapa) vira as partes onde a tinta descascou
	float rmask = n.g * 0.7 + n2.r * 0.5 + low * 0.25 + (1.0 - ra.a) * 0.15;
	// o parâmetro decide a ÁREA enferrujada (a mancha em si é opaca)
	float r = smoothstep(0.86 - rust * 0.45, 0.94 - rust * 0.45, rmask) * step(0.01, rust);
	float bare = rb.a * r;
	vec3 rust_col = ra.rgb * vec3(1.05, 0.95, 0.85);
	alb = mix(alb, rust_col, r);
	// carcaça queimada: chapa escura com a ferrugem da foto aparecendo por baixo
	// carcaça queimada de verdade: chapa enferrujada (a tinta some no fogo),
	// fuligem preta embaixo e nas bordas, cinza clara no teto e no capô
	float scorch = smoothstep(0.22, 0.5, n.b * 0.8 + n2.r * 0.4 + top * 0.2 - low * 0.12);
	vec3 charred = mix(vec3(0.03, 0.028, 0.026), ra.rgb * 0.8, scorch);
	charred = mix(charred, vec3(0.3, 0.29, 0.27) * (0.7 + n2.g * 0.5), smoothstep(0.55, 0.8, n2.b) * top * 0.65);
	alb = mix(alb, charred, burn);
	float wear = max(max(d, r), burn);
	// relevo da ferrugem/terra só onde elas aparecem (a tinta é lisa)
	float rel = max(r, burn * 0.8);
	vec2 nrm_xy = (rb.rg * 2.0 - 1.0) * rel + (db.rg * 2.0 - 1.0) * d * 0.6;
	NORMAL = bump(NORMAL, VERTEX, uv, nrm_xy, 1.0);
	// molhado (chuva): poeira escurece e a tinta fica ainda mais lisa
	float wet = wetness * (0.4 + 0.6 * top);
	alb *= mix(1.0, 0.7, wet * d);
	ALBEDO = alb;
	METALLIC = mix(0.4, 0.0, wear) + bare * 0.55 * (1.0 - burn);
	// tinta: base metalizada mais fosca + camada de verniz lisa por cima (o
	// reflexo nítido do céu e o brilho duplo de carro de verdade); poeira e
	// ferrugem matam o verniz
	ROUGHNESS = mix(mix(0.36, 0.95, wear), mix(0.95, ra.a, r), r * 0.6);
	ROUGHNESS = mix(ROUGHNESS, 0.3, wet * d * 0.6);
	SPECULAR = 0.5;
	CLEARCOAT = (1.0 - wear) * 0.85;
	CLEARCOAT_ROUGHNESS = mix(0.06, 0.6, d);
}
