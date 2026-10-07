// Shader "uber" das superfícies do mundo (prédios, ruas, calçadas, props, interiores).
//
// Um único material para quase toda a geometria estática => malhas de um chunk
// inteiro podem ser mescladas em poucas draw calls (crítico para CPU i3 + GL).
//
// Codificação por vértice:
//   UV   : coordenadas em METROS (o shader aplica a escala por camada)
//   UV2.x: camada (0..15) + 16 * modo_janela (0 nenhum, 1 residencial, 2 escritório, 3 loja)
//   UV2.y: semente aleatória 0..1 (variação por prédio/objeto)
//   COLOR: rgb = tinta, a = oclusão/sujeira pré-calculada (1 = limpo)
//
// Efeitos globais: umidade/poças (chuva), deterioração (mundo pós-colapso),
// energia da cidade (janelas acesas + apagão progressivo).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2DArray tex_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2DArray tex_b : filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform float layer_scales[16];
uniform bool exterior = true;
uniform bool enable_windows = true;
uniform bool enable_puddles = true;
uniform bool use_instance_tint = false;
uniform float normal_strength = 1.0;
uniform float grime = 1.0;
uniform float emission_boost = 1.0;
// Interiores: luz indireta falsa (claridade que entra pelas janelas e rebate), quente.
uniform float interior_fill = 0.0;
// canal A de tex_b = relevo (fotos com mapa de altura; a camada 5, metal, guarda metal)
uniform bool has_height = false;
uniform float parallax_scale = 1.0;
uniform float parallax_distance = 14.0;
// profundidade do relevo de cada camada, em metros
const float LAYER_DEPTH[16] = float[16](
	0.007, 0.01, 0.014, 0.003, 0.03, 0.0, 0.005, 0.012,
	0.014, 0.06, 0.003, 0.004, 0.018, 0.015, 0.0, 0.0);

global uniform float wetness;
// 1 quando o SSAO de verdade está ligado (Forward+): alivia a oclusão "pintada"
global uniform float ssao_active;
global uniform float world_decay;
global uniform float city_power;
global uniform vec3 blackout_origin;
global uniform float blackout_radius;
global uniform float daylight;
global uniform float rain_intensity;
global uniform float detail_distance;

varying vec3 w_pos;
varying vec3 w_nrm;
varying flat float v_layer;
varying flat float v_wmode;
// flat: a semente é constante no objeto; interpolada, sai com erro de ~1e-7 que o
// hash das janelas amplifica até virar "chuvisco" pixel a pixel
varying flat float v_seed;
varying vec4 v_tint;

// Degrau/faixa com antisserrilhado analítico (largura de 1 pixel via fwidth):
// padrões finos (janelas, faixas, caixilhos) não "cintilam" ao andar.
float aa_step(float edge, float x) {
	float w = max(fwidth(x), 1e-4);
	return clamp((x - edge) / w + 0.5, 0.0, 1.0);
}
float aa_band(float x, float half_w) {
	float w = max(fwidth(x), 1e-4);
	return clamp((half_w - abs(x)) / w + 0.5, 0.0, 1.0);
}
// idem com a largura do pixel dada (para coordenadas com fract, que saltam)
float aa_band_w(float x, float half_w, float w) {
	return clamp((half_w - abs(x)) / max(w, 1e-4) + 0.5, 0.0, 1.0);
}

float h21(vec2 p) {
	p = fract(p * vec2(233.34, 851.73));
	p += dot(p, p + 23.45);
	return fract(p.x * p.y);
}

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	w_nrm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	float code = UV2.x + 0.01;
	v_layer = mod(floor(code), 16.0);
	v_wmode = floor(code / 16.0);
	v_seed = UV2.y;
	// Decalques (manchas, papéis, marcas, remendos): UV2.y = 2 + nível + semente.
	// Ficam a milímetros da superfície e brigariam pelo depth (piscando); aqui
	// o vértice vai um pouco na direção da câmera ao longo do raio de visão —
	// a posição na tela não muda, só a profundidade (e cada nível vence o anterior).
	if (UV2.y > 1.5) {
		float level = floor(UV2.y) - 2.0;
		v_seed = fract(UV2.y);
		vec3 wv = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
		vec3 tc = CAMERA_POSITION_WORLD - wv;
		float dc = length(tc);
		// a precisão do depth cai com o quadrado da distância: o empurrão também
		// (0,5 mm perto, ~4 mm a 30 m); cada nível de sobreposição soma metade
		vec3 dw = tc / max(dc, 0.001) * (0.0005 + 4e-6 * dc * dc) * (1.0 + level * 0.5);
		mat3 m = mat3(MODEL_MATRIX);
		VERTEX += transpose(m) * dw / max(dot(m[0], m[0]), 1e-6);
	}
	// Em MultiMesh com use_colors, COLOR já vem multiplicado pela cor da instância.
	v_tint = COLOR;
	if (use_instance_tint) {
		v_seed = fract(v_seed + dot(MODEL_MATRIX[3].xz, vec2(0.137, 0.291)));
	}
}

void fragment() {
	int li = int(v_layer);
	float sc = layer_scales[li];
	// derivadas fora dos "if" (dentro de desvio não uniforme o GLSL não garante)
	vec2 dUV = fwidth(UV);
	// sentido em que UV.x cresce ao longo da parede (para o interior das janelas)
	vec3 u_dir = dFdx(UV.x) * dFdx(w_pos) + dFdy(UV.x) * dFdy(w_pos);
	vec2 tuv = UV * sc;
	vec2 gx = dFdx(tuv);
	vec2 gy = dFdy(tuv);
	vec3 Nn = normalize(w_nrm);
	bool hgt = has_height && li != 5;
#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
	// --- Relevo de verdade (parallax occlusion) perto da câmera ----------------
	// rejunte dos tijolos, telhas, frestas da calçada, pedras: o raio de visão
	// desce no mapa de altura (canal A de tex_b) até bater no relevo. Base
	// tangente pelas derivadas de tela (independe do sinal da tangente da malha).
	vec3 dpx = dFdx(w_pos);
	vec3 dpy = dFdy(w_pos);
	vec2 dux = dFdx(UV);
	vec2 duy = dFdy(UV);
	float pdepth = hgt ? LAYER_DEPTH[li] * parallax_scale : 0.0;
	float cam_d = length(CAMERA_POSITION_WORLD - w_pos);
	float pfade = 1.0 - smoothstep(parallax_distance * 0.55, parallax_distance, cam_d);
	if (pdepth > 0.0 && pfade > 0.0) {
		vec3 p2 = cross(dpy, Nn);
		vec3 p1 = cross(Nn, dpx);
		vec3 T = p2 * dux.x + p1 * duy.x;
		vec3 B = p2 * dux.y + p1 * duy.y;
		float inv = inversesqrt(max(max(dot(T, T), dot(B, B)), 1e-12));
		vec3 Vw = (CAMERA_POSITION_WORLD - w_pos) / max(cam_d, 1e-4);
		vec3 vts = vec3(dot(Vw, T * inv), dot(Vw, B * inv), dot(Vw, Nn));
		float steps = floor(mix(20.0, 6.0, clamp(vts.z, 0.0, 1.0)) * mix(0.5, 1.0, pfade));
		vec2 delta = -vts.xy / max(vts.z, 0.3) * pdepth * sc * pfade / steps;
		float st = 1.0 / steps;
		vec2 ofs = tuv;
		float cur = 0.0;
		float hd = 1.0 - textureGrad(tex_b, vec3(ofs, v_layer), gx, gy).a;
		vec2 prev = ofs;
		float prev_hd = hd;
		float prev_cur = 0.0;
		for (int i = 0; i < 20; i++) {
			if (float(i) >= steps || cur >= hd) {
				break;
			}
			prev = ofs;
			prev_hd = hd;
			prev_cur = cur;
			ofs += delta;
			cur += st;
			hd = 1.0 - textureGrad(tex_b, vec3(ofs, v_layer), gx, gy).a;
		}
		float after = hd - cur;
		float before = prev_hd - prev_cur;
		tuv = mix(ofs, prev, clamp(after / min(after - before, -1e-5), 0.0, 1.0));
	}
#endif
	vec3 uvw = vec3(tuv, v_layer);
	vec4 a = textureGrad(tex_a, uvw, gx, gy);
	vec4 b = textureGrad(tex_b, uvw, gx, gy);
	// altura 0..1 do relevo (0 = rejunte/fresta); a camada de metal guarda metal
	float h = hgt ? b.a : 0.5;
	float crev = smoothstep(0.42, 0.05, h);

	// Projeção dominante para ruídos em espaço de mundo (1 amostra, barato)
	vec3 an = abs(w_nrm);
	vec2 np = an.y > 0.7 ? w_pos.xz : (an.x > an.z ? w_pos.zy : w_pos.xy);
	vec4 nz = texture(noise_tex, np * 0.045);

	vec3 base_rgb = a.rgb;
	// anti-repetição nas camadas orgânicas (asfalto, reboco, grama, terra, rocha,
	// cascalho, casca): 2ª amostra girada em outra escala, misturada por ruído de mundo
	if (li == 0 || li == 3 || li == 7 || li == 8 || li == 9 || li == 12 || li == 13) {
		mat2 rot = mat2(vec2(0.8, -0.6), vec2(0.6, 0.8));
		vec2 ruv = rot * (tuv * 0.41) + vec2(0.37, 0.71);
		vec3 a2 = textureGrad(tex_a, vec3(ruv, v_layer), rot * gx * 0.41, rot * gy * 0.41).rgb;
		base_rgb = mix(base_rgb, a2, smoothstep(0.3, 0.7, nz.g) * 0.5);
	}
	// grama: foto amarronzada (chão entre as folhas) puxada para verde de gramado
	if (li == 7) {
		float glum = dot(base_rgb, vec3(0.299, 0.587, 0.114));
		float gavg = dot(textureLod(tex_a, vec3(0.5, 0.5, v_layer), 11.0).rgb, vec3(0.299, 0.587, 0.114));
		base_rgb = mix(base_rgb, vec3(0.1, 0.15, 0.033) * (glum / max(gavg, 0.01)), 0.78);
	}
	// variação de tom em grande escala (manchas, sol, sujeira acumulada)
	base_rgb *= 0.9 + nz.r * 0.2;
	vec3 alb = base_rgb * v_tint.rgb;
	float rough = a.a;
	float metal = hgt ? 0.0 : b.a;
	float ao = b.b * v_tint.a;
	vec2 nxy = (b.rg * 2.0 - 1.0) * normal_strength;
	vec3 nmap = vec3(nxy, sqrt(max(0.0, 1.0 - dot(nxy, nxy))));
	vec3 emit = vec3(0.0);

	// --- Abandono: reboco caído (aparece o tijolo) e buracos no asfalto ----------
	float wdec = world_decay * grime;
	float pothole = 0.0;
	if (exterior && hgt && wdec > 0.01) {
		if (li == 3 && an.y < 0.5) {
			// manchas onde o reboco soltou: mais perto do chão (umidade que sobe)
			// e onde o próprio reboco é mais fino (relevo baixo)
			float base_h = v_wmode > 0.5 ? UV.y : 10.0;
			float pm = texture(noise_tex, np * 0.11 + v_seed * 3.7).r * 0.65 + texture(noise_tex, np * 0.47 + 0.19).g * 0.35;
			pm += smoothstep(1.8, 0.0, base_h) * 0.12 - h * 0.04;
			// (o ruído fica em ~0,37 ± 0,06: ~10% da parede no abandono total)
			float th = 0.51 - wdec * 0.06;
			float hole = smoothstep(th, th + 0.006, pm);
			// borda: a espessura do reboco faz sombra e o tijolo fica mais escuro ali
			float rim = smoothstep(th - 0.014, th, pm) * (1.0 - hole);
			float s2 = layer_scales[2];
			vec2 buv = UV * s2 + vec2(v_seed * 5.0, 0.0);
			vec4 ba = textureGrad(tex_a, vec3(buv, 2.0), gx / sc * s2, gy / sc * s2);
			vec4 bb = textureGrad(tex_b, vec3(buv, 2.0), gx / sc * s2, gy / sc * s2);
			vec2 bxy = (bb.rg * 2.0 - 1.0) * normal_strength;
			vec3 bn = vec3(bxy, sqrt(max(0.0, 1.0 - dot(bxy, bxy))));
			alb = mix(alb, ba.rgb * (0.75 + 0.25 * smoothstep(0.0, 0.012, pm - th)), hole);
			alb *= 1.0 - rim * 0.3;
			rough = mix(rough, ba.a, hole);
			ao = mix(ao, bb.b, hole);
			nmap = normalize(mix(nmap, bn, hole));
			h = mix(h, bb.a * 0.6, hole);
			crev = max(crev * (1.0 - hole), smoothstep(0.42, 0.05, h) * hole);
		} else if (li == 0 && an.y > 0.9) {
			// buracos: o asfalto some e fica a base de cascalho, mais funda (junta água)
			float pn2 = texture(noise_tex, w_pos.xz * 0.17 + vec2(0.31, 0.67)).b * 0.7 + texture(noise_tex, w_pos.xz * 0.6).g * 0.3;
			// (~3% da rua no abandono total)
			float th = 0.47 - wdec * 0.04;
			pothole = smoothstep(th, th + 0.008, pn2 + (0.5 - h) * 0.02);
			float rim = smoothstep(th - 0.012, th, pn2) * (1.0 - pothole);
			float s12 = layer_scales[12];
			vec2 cuv = w_pos.xz * s12;
			vec4 ca = textureGrad(tex_a, vec3(cuv, 12.0), gx / sc * s12, gy / sc * s12);
			vec4 cb = textureGrad(tex_b, vec3(cuv, 12.0), gx / sc * s12, gy / sc * s12);
			vec2 cxy = cb.rg * 2.0 - 1.0;
			vec3 cn = vec3(cxy, sqrt(max(0.0, 1.0 - dot(cxy, cxy))));
			alb = mix(alb, ca.rgb * vec3(0.42, 0.41, 0.39), pothole);
			alb *= 1.0 - rim * 0.25;
			rough = mix(rough, ca.a, pothole);
			ao = mix(ao, cb.b * 0.8, pothole);
			nmap = normalize(mix(nmap, cn, pothole));
			// fundo do buraco = parte mais baixa: a chuva enche primeiro
			crev = max(crev, pothole * mix(0.75, 1.0, smoothstep(0.6, 0.1, cb.a)));
			h = min(h, 1.0 - pothole);
		}
	}

	// --- Deterioração: fuligem, escorridos, musgo -------------------------------
	float decay = world_decay * grime;
	// fuligem/escorridos são de prédio: tronco de árvore (casca) fica de fora
	if (decay > 0.01 && li != 13) {
		float streak = texture(noise_tex, vec2(np.x * 0.35, np.y * 0.02)).g;
		float vertical = 1.0 - an.y;
		float dirt = smoothstep(0.35, 0.8, streak * 0.7 + nz.r * 0.5) * vertical;
		alb = mix(alb, alb * vec3(0.5, 0.47, 0.42), dirt * decay * 0.75);
		// Em fachadas UV.y = altura acima da base do prédio: musgo sobe do chão.
		float base_h = v_wmode > 0.5 ? UV.y : 10.0;
		float moss_mask = smoothstep(0.55, 0.75, nz.r + nz.b * 0.2) * (an.y > 0.6 ? 1.0 : smoothstep(1.6, 0.0, base_h) * 0.7);
		alb = mix(alb, vec3(0.13, 0.16, 0.07) * (0.7 + nz.g * 0.6), moss_mask * decay * (exterior ? 0.55 : 0.12));
		rough = mix(rough, 0.95, moss_mask * decay * 0.5);
		ao *= 1.0 - dirt * decay * 0.25;
	}
	// sujeira assentada nas partes baixas do relevo (rejunte, frestas, entre as pedras)
	if (hgt) {
		alb *= 1.0 - crev * (0.1 + decay * 0.2);
	}

	// --- Sinalização horizontal (ruas: modo 4 rua, 5 avenida, 6 rodovia) --------
	// UV.x = distância do eixo da via (m), UV.y = distância ao longo da via.
	if (v_wmode > 3.5) {
		float ax = abs(UV.x);
		// tracejado: distância até o centro do traço (contínua, sem o salto do fract)
		float d6 = (fract(UV.y / 6.0 + 0.25) - 0.5) * 6.0;
		float wy = dUV.y;
		float wx = dUV.x;
		float dash = aa_band_w(d6, 1.5, wy);
		float m = 0.0;
		vec3 mc = vec3(0.78, 0.62, 0.16);
		if (v_wmode < 4.5) {
			m = aa_band_w(UV.x, 0.07, wx) * dash;
		} else if (v_wmode < 5.5) {
			m = aa_band_w(ax - 0.12, 0.05, wx);
			float d9 = (fract(UV.y / 9.0 + 0.3) - 0.5) * 9.0;
			float lane = aa_band_w(ax - 3.4, 0.06, wx) * aa_band_w(d9, 1.8, wy);
			mc = mix(mc, vec3(0.8), lane);
			m = max(m, lane);
		} else {
			m = aa_band_w(UV.x, 0.07, wx) * dash;
			float edge = aa_band_w(ax - 4.55, 0.07, wx);
			mc = mix(mc, vec3(0.8), edge);
			m = max(m, edge);
		}
		float wear = smoothstep(0.2, 0.55, nz.g + 0.35 - world_decay * 0.3);
		m *= 1.0 - pothole;
		alb = mix(alb, mc, m * 0.85 * wear);
		rough = mix(rough, 0.6, m * wear);
	}

	// --- Janelas procedurais ---------------------------------------------------
	float is_window = 0.0;
	if (enable_windows && v_wmode > 0.5 && v_wmode < 3.5 && an.y < 0.3) {
		vec2 cell_size = v_wmode < 1.5 ? vec2(3.1, 2.9) : (v_wmode < 2.5 ? vec2(2.4, 3.4) : vec2(3.6, 3.6));
		vec2 g = UV / cell_size;
		vec2 cell = floor(g);
		vec2 f = fract(g);
		vec2 wmin = v_wmode < 1.5 ? vec2(0.28, 0.3) : vec2(0.1, 0.24);
		vec2 wmax = v_wmode < 1.5 ? vec2(0.72, 0.84) : vec2(0.9, 0.86);
		bool shop = v_wmode > 2.5 && cell.y < 0.5;
		if (shop) {
			wmin = vec2(0.06, 0.08);
			wmax = vec2(0.94, 0.78);
		}
		// tamanho do pixel medido em células: de longe as janelas viram a média
		// (senão a grade de janelas faz moiré e cintila ao andar)
		vec2 fw = max(dUV / cell_size, vec2(1e-4));
		float far_fade = smoothstep(0.1, 0.35, max(fw.x, fw.y));
		float inx = clamp((f.x - wmin.x) / fw.x + 0.5, 0.0, 1.0) * clamp((wmax.x - f.x) / fw.x + 0.5, 0.0, 1.0);
		float iny = clamp((f.y - wmin.y) / fw.y + 0.5, 0.0, 1.0) * clamp((wmax.y - f.y) / fw.y + 0.5, 0.0, 1.0);
		float frx = clamp((f.x - wmin.x + 0.04) / fw.x + 0.5, 0.0, 1.0) * clamp((wmax.x + 0.04 - f.x) / fw.x + 0.5, 0.0, 1.0);
		float fry = clamp((f.y - wmin.y + 0.05) / fw.y + 0.5, 0.0, 1.0) * clamp((wmax.y + 0.03 - f.y) / fw.y + 0.5, 0.0, 1.0);
		float cov = (wmax.x - wmin.x) * (wmax.y - wmin.y);
		float fcov = (wmax.x - wmin.x + 0.08) * (wmax.y - wmin.y + 0.08) - cov;
		float win = mix(inx * iny, cov, far_fade);
		float frame = mix(max(frx * fry - inx * iny, 0.0), fcov, far_fade);
		float rnd = h21(cell + v_seed * 131.0);
		float rnd2 = h21(cell.yx + v_seed * 71.0 + 3.0);
		// escorrido sob o peitoril: a água que desce da janela suja a parede abaixo
		// em filetes (mais forte junto ao peitoril, some antes da laje)
		if (exterior && !shop && an.y < 0.3) {
			float xin = smoothstep(wmin.x - 0.03, wmin.x + 0.06, f.x) * smoothstep(wmax.x + 0.03, wmax.x - 0.06, f.x);
			float under = step(f.y, wmin.y - 0.01) * smoothstep(0.0, wmin.y, f.y);
			float colm = texture(noise_tex, vec2(UV.x * 1.7 + v_seed * 7.0, UV.y * 0.05)).g;
			float st = xin * under * smoothstep(0.32, 0.72, colm) * (1.0 - far_fade);
			alb = mix(alb, alb * vec3(0.52, 0.5, 0.46), st * clamp(world_decay * grime, 0.0, 1.0) * 0.75);
		}
		if (win + frame > 0.001) {
			// cômodo atrás do vidro ("interior mapping"): o raio de visão entra numa caixa
			// (piso, teto, paredes, fundo) e o cômodo ganha profundidade conforme o ângulo
			vec3 Nw = normalize(w_nrm);
			vec3 Tw = normalize(cross(vec3(0.0, 1.0, 0.0), Nw));
			Tw *= dot(u_dir, Tw) < 0.0 ? -1.0 : 1.0;
			vec3 rd = normalize(w_pos - CAMERA_POSITION_WORLD);
			vec3 r = vec3(dot(rd, Tw), rd.y, max(-dot(rd, Nw), 0.02));
			float ww = (wmax.x - wmin.x) * cell_size.x;
			vec2 wc = vec2((f.x - (wmin.x + wmax.x) * 0.5) * cell_size.x, (f.y - wmin.y) * cell_size.y);
			float room_w = cell_size.x * 0.96;
			float floor_y = -wmin.y * cell_size.y * 0.95;
			float ceil_y = cell_size.y * (1.0 - wmin.y) * 0.95;
			float depth = 3.2 + rnd * 2.0;
			float tx = ((r.x > 0.0 ? room_w * 0.5 : -room_w * 0.5) - wc.x) / (abs(r.x) < 1e-4 ? 1e-4 : r.x);
			float ty = ((r.y > 0.0 ? ceil_y : floor_y) - wc.y) / (abs(r.y) < 1e-4 ? 1e-4 : r.y);
			float tz = depth / r.z;
			float th = min(min(tx, ty), tz);
			vec3 hp = vec3(wc, 0.0) + r * th;
			float zf = clamp(hp.z / depth, 0.0, 1.0);
			vec3 wall_c = mix(vec3(0.42, 0.4, 0.36), vec3(0.34, 0.37, 0.36), rnd2);
			vec3 room;
			if (th == ty && r.y < 0.0) {
				room = mix(vec3(0.24, 0.18, 0.13), vec3(0.3, 0.29, 0.27), step(0.5, rnd)) * 0.9;   // piso
			} else if (th == ty) {
				room = vec3(0.5, 0.49, 0.46);                                                     // teto
			} else if (th == tz) {
				room = wall_c * 0.85;                                                             // fundo
				// porta / vão escuro na parede do fundo de alguns cômodos
				room *= 1.0 - step(0.55, rnd2) * step(abs(hp.x - (rnd - 0.5) * room_w * 0.5), 0.45) * step(hp.y, 2.0 + floor_y) * 0.75;
			} else {
				room = wall_c;                                                                    // laterais
			}
			// luz do dia que entra pela janela: forte perto do vidro, cai no fundo;
			// o piso perto da janela pega mais, o teto quase nada
			float sky_in = (0.2 + daylight * 0.8) * (1.0 - world_decay * 0.25);
			float falloff = mix(1.0, 0.12, pow(zf, 0.7));
			room *= sky_in * falloff * (th == ty && r.y > 0.0 ? 0.45 : 1.0) * 0.32;
			room *= mix(1.0, 0.5, rnd2 * rnd);
			vec3 interior = mix(room, vec3(0.03, 0.03, 0.028) * (0.2 + daylight * 0.8), far_fade);
			float curtain = step(0.62, rnd) * step(0.45 + rnd2 * 0.3, f.y) * step(0.5, fract(rnd * 7.0 + (f.x > 0.5 ? 0.5 : 0.0)));
			curtain = mix(curtain, 0.08, far_fade);
			interior = mix(interior, vec3(0.28, 0.25, 0.21) * (0.6 + rnd2 * 0.6), curtain * 0.8);
			float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
			vec3 refl = mix(vec3(0.16, 0.18, 0.2), vec3(0.42, 0.47, 0.53), mix(f.y, 0.55, far_fade)) * (0.2 + daylight * 0.8);
			vec3 glass_col = mix(interior, refl, 0.12 + fres * 0.6);
			float broken = step(1.0 - world_decay * 0.2, rnd2) * (exterior ? 1.0 : 0.0);
			broken = mix(broken, world_decay * 0.2 * (exterior ? 1.0 : 0.0), far_fade);
			vec3 g_alb = mix(glass_col, vec3(0.008), broken);
			// rugosidade moderada: reflexo do céu desfocado evita cintilação nas janelas
			float g_rough = mix(0.24, 0.95, broken);
			// caixilho central nas janelas largas
			if (v_wmode > 1.5) {
				float mull = clamp((0.012 - abs(f.x - (wmin.x + wmax.x) * 0.5)) / fw.x + 0.5, 0.0, 1.0) * (1.0 - far_fade);
				g_alb = mix(g_alb, vec3(0.12), mull);
				g_rough = mix(g_rough, 0.5, mull);
			}
			// moldura / peitoril
			alb = mix(alb, alb * 0.62, frame);
			rough = mix(rough, 0.6, frame);
			nmap = normalize(mix(nmap, vec3(0.0, 0.0, 1.0), clamp(frame + win, 0.0, 1.0)));
			// vidro
			alb = mix(alb, g_alb, win);
			rough = mix(rough, g_rough, win);
			metal = mix(metal, 0.0, win);
			ao = mix(ao, 1.0, win);
			is_window = win;
			// luz acesa (energia + apagão progressivo em onda)
			float powered = city_power * step(blackout_radius, distance(w_pos.xz, blackout_origin.xz) + rnd * 25.0);
			float occupancy = shop ? 0.85 : (0.25 + 0.45 * (1.0 - daylight));
			float lit = mix(step(rnd, occupancy), occupancy, far_fade) * powered * (1.0 - broken);
			vec3 warm = mix(vec3(1.0, 0.72, 0.42), vec3(0.75, 0.85, 1.0), step(0.7, rnd2));
			// à noite a exposição do "olho" sobe ~3x: janela acesa mais fraca que isso
			// estourava em branco puro (vitrines viravam placas brancas)
			emit = warm * lit * (0.4 + rnd * 0.55) * (shop ? 1.2 : 1.0) * mix(0.35, 0.6, 1.0 - daylight) * emission_boost * win;
		}
	}

	// --- Contato com o chão: a base das fachadas é mais escura (sujeira, respingo
	// de chuva e a "oclusão" que o renderer Compatibility não calcula) ---------
	if (exterior && v_wmode > 0.5 && v_wmode < 3.5 && an.y < 0.3) {
		float hb = UV.y;
		float fake_ao = 1.0 - ssao_active * 0.6;
		alb *= mix(mix(1.0, 0.62, fake_ao), 1.0, smoothstep(0.0, 1.1, hb)) * mix(0.9, 1.0, smoothstep(0.0, 3.5, hb));
		ao *= mix(mix(1.0, 0.75, fake_ao), 1.0, smoothstep(0.0, 0.6, hb));
	}

	// --- Umidade, poças e ondulações de chuva -------------------------------------
	if (exterior && wetness > 0.01) {
		float porous = clamp(rough, 0.0, 1.0);
		float exposure = mix(0.45, 1.0, clamp(w_nrm.y, 0.0, 1.0));
		float wet = wetness * exposure * (1.0 - is_window);
		// frestas e rejuntes molham primeiro e secam por último
		wet = clamp(wet * mix(0.85, 1.7, crev), 0.0, 1.0);
		alb *= mix(1.0, 0.55, wet * porous);
		rough = mix(rough, 0.18, wet * 0.85);
		if (enable_puddles && w_nrm.y > 0.92) {
			float pn = texture(noise_tex, w_pos.xz * 0.028).r * 0.7 + nz.b * 0.3;
			float th = 0.8 - wetness * 0.12;
			pn += (0.5 - h) * 0.08;
			float puddle = smoothstep(th, th + 0.04, pn) * smoothstep(0.2, 0.6, wetness);
			// água parada nas frestas, no rejunte e entre as pedras do chão
			puddle = max(puddle, smoothstep(0.55, 0.98, crev) * smoothstep(0.3, 0.8, wetness) * 0.7);
			alb = mix(alb, alb * 0.35 + vec3(0.01), puddle);
			rough = mix(rough, 0.02, puddle);
			vec3 flatn = vec3(0.0, 0.0, 1.0);
			if (rain_intensity > 0.05) {
				vec2 rp = w_pos.xz * 1.7;
				vec2 ci = floor(rp);
				vec2 cf = fract(rp) - 0.5;
				float t = fract(TIME * 1.3 + h21(ci) * 7.0);
				float ring = sin((length(cf) - t * 0.5) * 38.0) * smoothstep(0.5, 0.0, length(cf)) * (1.0 - t);
				flatn.xy += normalize(cf + 0.0001) * ring * 0.25 * rain_intensity;
			}
			nmap = normalize(mix(nmap, flatn, puddle));
		}
	}

	if (interior_fill > 0.0) {
		// forros e faces voltadas para baixo recebem a luz que rebate do piso
		float down = clamp(-w_nrm.y, 0.0, 1.0);
		alb *= vec3(1.04, 1.0, 0.93);
		emit += alb * vec3(1.0, 0.9, 0.76) * interior_fill * (1.0 + down * 1.4) * (0.2 + daylight * 0.8) * (0.55 + 0.45 * ao);
	}
	// antisserrilhado especular: onde a normal varia muito dentro do pixel (detalhe
	// fino do relevo ou geometria vista de longe) o brilho fica mais fosco em vez
	// de acender e apagar a cada passo
	vec2 dn = fwidth(nmap.xy);
	vec3 dg = fwidth(w_nrm);
	float nvar = dot(dn, dn) + dot(dg, dg);
	rough = sqrt(clamp(rough * rough + min(nvar * 1.5, 0.35), 0.0, 1.0));
	ALBEDO = alb;
	ROUGHNESS = clamp(rough, 0.02, 1.0);
	METALLIC = metal;
	SPECULAR = 0.5 + is_window * 0.15;
	NORMAL_MAP = nmap * 0.5 + 0.5;
	AO = ao;
	AO_LIGHT_AFFECT = 0.35;
	EMISSION = emit;
}
