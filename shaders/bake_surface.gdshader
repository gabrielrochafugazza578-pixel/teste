// Gerador de texturas PBR procedurais (executado UMA vez na GPU durante o
// carregamento). Todas as texturas são "tileáveis" (ruído periódico).
//
// mode 0: superfícies do mundo (layer 0..15)
//     channel 0 -> RGB albedo + A roughness
//     channel 1 -> RG normal + B ambient occlusion + A metallic
// mode 1: atlas de personagens (4 quadrantes: pele, malha, brim, couro)
//     channel 0 -> RGB detalhe + A roughness | channel 1 -> RG normal + B AO + A máscara de veias
// mode 2: folhas (RGBA com alfa recortado)
// mode 3: sprites de partículas (layer: 0 fumaça, 1 papel, 2 faísca, 3 gota, 4 folha seca)
// mode 4: ruído genérico (R grande, G médio, B fino, A voronoi)
// mode 5: atlas das armas (4 quadrantes: nogueira, aço, polímero, borracha)
shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform int mode = 0;
uniform int layer = 0;
uniform int channel = 0;
uniform float px = 0.001953125;


float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
	float n = hash21(p);
	return vec2(n, hash21(p + n + 17.17));
}

float vnoise(vec2 p, vec2 period) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	float a = hash21(mod(i, period));
	float b = hash21(mod(i + vec2(1.0, 0.0), period));
	float c = hash21(mod(i + vec2(0.0, 1.0), period));
	float d = hash21(mod(i + vec2(1.0, 1.0), period));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 uv, float freq, int oct) {
	float s = 0.0;
	float amp = 0.5;
	float norm = 0.0;
	for (int i = 0; i < 7; i++) {
		if (i >= oct) {
			break;
		}
		s += amp * vnoise(uv * freq, vec2(freq));
		norm += amp;
		freq *= 2.0;
		amp *= 0.5;
	}
	return s / norm;
}

// fbm anisotrópico (fibras / grão de madeira)
float fbm2(vec2 uv, vec2 freq, int oct) {
	float s = 0.0;
	float amp = 0.5;
	float norm = 0.0;
	for (int i = 0; i < 6; i++) {
		if (i >= oct) {
			break;
		}
		s += amp * vnoise(uv * freq, freq);
		norm += amp;
		freq *= 2.0;
		amp *= 0.5;
	}
	return s / norm;
}

// Voronoi periódico: x = F1, y = F2 - F1 (borda), z = id da célula
vec3 voronoi(vec2 uv, float freq) {
	vec2 p = uv * freq;
	vec2 i = floor(p);
	vec2 f = fract(p);
	float f1 = 8.0;
	float f2 = 8.0;
	float cid = 0.0;
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 g = vec2(float(x), float(y));
			vec2 cell = mod(i + g, vec2(freq));
			vec2 o = hash22(cell);
			vec2 r = g + o - f;
			float d = dot(r, r);
			if (d < f1) {
				f2 = f1;
				f1 = d;
				cid = hash21(cell + 3.1);
			} else if (d < f2) {
				f2 = d;
			}
		}
	}
	return vec3(sqrt(f1), sqrt(f2) - sqrt(f1), cid);
}

// ---------------------------------------------------------------------------
// Utilitários de detalhe
// ---------------------------------------------------------------------------
// Riscos finos: em cada célula um segmento com direção aleatória (tileável)
float scratches(vec2 uv, float freq, float density, float width) {
	vec2 p = uv * freq;
	float m = 0.0;
	for (int k = 0; k < 2; k++) {
		vec2 q = p + float(k) * vec2(0.37, 0.71);
		vec2 ci = floor(q);
		vec2 f = fract(q) - 0.5;
		vec2 cell = mod(ci, vec2(freq));
		float r = hash21(cell + float(k) * 9.1);
		if (r < density) {
			float a = hash21(cell + 2.3) * PI;
			vec2 d = vec2(cos(a), sin(a));
			float along = dot(f, d);
			float across = abs(dot(f, vec2(-d.y, d.x)));
			float len = 0.2 + hash21(cell + 5.7) * 0.3;
			m = max(m, (1.0 - smoothstep(0.0, width, across)) * (1.0 - smoothstep(len * 0.8, len, abs(along))));
		}
	}
	return m;
}

// Fissura ramificada: borda de voronoi distorcida
float cracks(vec2 uv, float freq, float warp, float width) {
	vec2 w = vec2(fbm(uv, 4.0, 3), fbm(uv + 3.3, 4.0, 3)) - 0.5;
	vec3 v = voronoi(uv + w * warp, freq);
	return 1.0 - smoothstep(0.0, width, v.y);
}

// ---------------------------------------------------------------------------
// Superfícies do mundo. Saída: albedo, altura (0..1), roughness, metallic, ao
// ---------------------------------------------------------------------------
void surface(int id, vec2 uv, out vec3 alb, out float h, out float rough, out float metal, out float ao) {
	metal = 0.0;
	ao = 1.0;
	if (id == 0) { // asfalto: agregado, betume, desgaste, manchas de óleo, fissuras e remendos
		vec3 s1 = voronoi(uv, 90.0);
		vec3 s2 = voronoi(uv + 0.31, 46.0);
		float st1 = smoothstep(0.42, 0.18, s1.x);
		float st2 = smoothstep(0.38, 0.12, s2.x) * step(0.45, s2.z);
		float grit = vnoise(uv, vec2(320.0));
		float wear = fbm(uv, 2.0, 4);
		vec3 bitumen = vec3(0.075, 0.076, 0.08);
		vec3 stone1 = mix(vec3(0.2, 0.2, 0.2), vec3(0.3, 0.28, 0.26), s1.z);
		vec3 stone2 = mix(vec3(0.24, 0.24, 0.25), vec3(0.36, 0.33, 0.3), s2.z);
		vec3 c = bitumen;
		c = mix(c, stone1, st1 * 0.4);
		c = mix(c, stone2, st2 * 0.55);
		c *= 0.88 + grit * 0.22;
		c *= 0.85 + fbm(uv + 2.2, 6.0, 4) * 0.3;
		c = mix(c, c * 1.5 + 0.03, smoothstep(0.4, 0.8, wear) * 0.7);   // desbotado pelo sol
		float oil = smoothstep(0.62, 0.7, fbm(uv + 7.7, 3.0, 5));
		c = mix(c, vec3(0.045, 0.045, 0.05), oil * 0.75);
		float patch = smoothstep(0.66, 0.68, fbm(uv + 1.9, 2.0, 3));
		c = mix(c, vec3(0.06, 0.062, 0.066) * (0.9 + grit * 0.2), patch);
		float cr = max(cracks(uv, 5.0, 0.25, 0.035), cracks(uv + 0.21, 11.0, 0.3, 0.03) * smoothstep(0.5, 0.65, fbm(uv + 9.0, 2.0, 3))) * (1.0 - patch);
		float seal = cracks(uv + 0.5, 3.0, 0.15, 0.045) * smoothstep(0.55, 0.7, fbm(uv + 4.0, 2.0, 3));
		c = mix(c, vec3(0.035), seal * 0.9);
		c *= 1.0 - cr * 0.8;
		alb = c;
		h = 0.4 + st1 * 0.25 + st2 * 0.3 + grit * 0.1 - cr * 0.55 + seal * 0.08;
		rough = 0.88 - st2 * 0.05 - oil * 0.3 - seal * 0.35 - patch * 0.06;
		ao = 1.0 - cr * 0.6 - (1.0 - max(st1, st2)) * 0.1;
	} else if (id == 1) { // concreto (calçada): placas, agregado, poros, manchas, chiclete, trincas
		vec2 sg = uv * 2.0;
		vec2 sf = fract(sg);
		vec2 sid = mod(floor(sg), vec2(2.0));
		float ed = min(min(sf.x, 1.0 - sf.x), min(sf.y, 1.0 - sf.y));
		float seam = 1.0 - smoothstep(0.004, 0.014, ed);
		float chip = (1.0 - smoothstep(0.012, 0.04, ed)) * smoothstep(0.6, 0.75, vnoise(uv, vec2(60.0)));
		float r = hash21(sid + 4.4);
		float n = fbm(uv, 4.0, 5);
		vec3 ag = voronoi(uv, 140.0);
		float spec = smoothstep(0.3, 0.1, ag.x) * step(0.6, ag.z);
		float pores = smoothstep(0.8, 0.92, vnoise(uv, vec2(260.0)));
		float stain = smoothstep(0.55, 0.85, fbm(uv + 0.3, 2.0, 5));
		vec3 gv = voronoi(uv + 0.77, 12.0);
		float gum = smoothstep(0.05, 0.03, gv.x) * step(0.94, gv.z);
		float hair = cracks(uv + r, 3.0, 0.3, 0.012) * step(0.6, r) * (1.0 - seam);
		float mott = fbm(uv + 1.1, 8.0, 4);
		float g = 0.52 + (r - 0.5) * 0.08 + n * 0.14 + (mott - 0.5) * 0.1 - stain * 0.16;
		vec3 c = vec3(g * 1.02, g, g * 0.95);
		c = mix(c, c * (0.75 + ag.z * 0.5), spec * 0.6);
		c *= 1.0 - pores * 0.35;
		c = mix(c, vec3(0.2, 0.19, 0.18), seam * 0.8);
		c = mix(c, c * 0.8, chip);
		c = mix(c, vec3(0.12, 0.12, 0.13), gum * 0.8);
		c *= 1.0 - hair * 0.45;
		alb = c;
		h = 0.6 + n * 0.2 + spec * 0.08 - pores * 0.2 - seam * 0.6 - chip * 0.2 - hair * 0.3;
		rough = 0.9 - stain * 0.12 - gum * 0.2;
		ao = 1.0 - seam * 0.6 - pores * 0.2;
	} else if (id == 2) { // tijolo: tamanho irregular, cantos lascados, fuligem, eflorescência
		float rows = 14.0;
		float row = floor(uv.y * rows);
		float off = mod(row, 2.0) * 0.5 + (hash21(vec2(row, 1.3)) - 0.5) * 0.08;
		float bx = uv.x * 4.0 + off;
		vec2 bid = vec2(mod(floor(bx), 4.0), mod(row, rows));
		float r = hash21(bid);
		float fx = fract(bx);
		float fy = fract(uv.y * rows);
		float nb = vnoise(uv, vec2(96.0));
		float mw = 0.045 + nb * 0.02;
		float mx = smoothstep(0.0, mw, fx) * smoothstep(0.0, mw, 1.0 - fx);
		float my = smoothstep(0.0, mw * 3.0, fy) * smoothstep(0.0, mw * 3.0, 1.0 - fy);
		float brick = mx * my;
		float corner = (1.0 - smoothstep(0.0, 0.18, min(fx, 1.0 - fx) + min(fy, 1.0 - fy) * 0.25)) * step(0.55, hash21(bid + 7.0));
		brick *= 1.0 - corner * smoothstep(0.4, 0.6, nb);
		float n = fbm(uv, 16.0, 4);
		float pits = smoothstep(0.78, 0.9, vnoise(uv, vec2(200.0)));
		vec3 bc = mix(vec3(0.4, 0.16, 0.1), vec3(0.64, 0.34, 0.21), r);
		bc = mix(bc, vec3(0.26, 0.14, 0.1), step(0.9, r) * 0.7);      // tijolos queimados
		bc = mix(bc, vec3(0.62, 0.45, 0.32), step(0.82, fract(r * 7.3)) * 0.4);
		bc *= 0.82 + n * 0.3 - pits * 0.2;
		float soot = smoothstep(0.5, 0.85, fbm(uv + 2.0, 2.0, 4));
		float eff = smoothstep(0.7, 0.85, fbm(uv + 5.0, 5.0, 4));
		vec3 mc = vec3(0.5, 0.48, 0.44) * (0.8 + vnoise(uv, vec2(300.0)) * 0.3);
		vec3 c = mix(mc * 0.85, bc, brick);
		c = mix(c, c * 0.55, soot * 0.6);
		c = mix(c, vec3(0.78, 0.76, 0.72), eff * 0.35);
		alb = c;
		h = mix(0.15, 0.75 + n * 0.2 - pits * 0.2, brick);
		rough = mix(0.96, 0.84, brick);
		ao = mix(0.5, 1.0, brick);
	} else if (id == 3) { // reboco pintado: chapisco, ondulação, escorridos, descascado, fissuras
		float n = fbm(uv, 3.0, 6);
		float grain = vnoise(uv, vec2(220.0));
		float bumps = smoothstep(0.55, 0.85, vnoise(uv, vec2(110.0)));
		float drip = fbm2(uv + 0.2, vec2(28.0, 1.5), 4);
		float drip_mask = smoothstep(0.48, 0.75, drip) * smoothstep(0.35, 0.7, fbm(uv + 1.7, 3.0, 3));
		vec3 cr = voronoi(uv + n * 0.1, 3.0);
		float crack = (1.0 - smoothstep(0.0, 0.01, cr.y)) * smoothstep(0.62, 0.7, fbm(uv + 7.0, 2.0, 3));
		float peel_n = fbm(uv + 2.0, 5.0, 5);
		float peel = smoothstep(0.78, 0.8, peel_n);
		float peel_edge = smoothstep(0.75, 0.78, peel_n) - peel;
		float g = 0.82 + n * 0.08 + grain * 0.04 + bumps * 0.03;
		vec3 c = vec3(g);
		c = mix(c, c * vec3(0.76, 0.73, 0.66), drip_mask * 0.6);
		c *= 0.94 + fbm(uv + 5.5, 7.0, 4) * 0.1;
		c = mix(c, vec3(0.64, 0.62, 0.58) * (0.85 + grain * 0.3), peel);   // reboco cru por baixo da tinta
		c *= 1.0 - peel_edge * 0.25;
		c *= 1.0 - crack * 0.55;
		alb = c;
		h = 0.5 + n * 0.2 + grain * 0.08 + bumps * 0.12 - peel * 0.25 + peel_edge * 0.1 - crack * 0.4;
		rough = 0.86 + peel * 0.08 - drip_mask * 0.05;
		ao = 1.0 - crack * 0.4 - peel * 0.15;
	} else if (id == 4) { // telha cerâmica: variação, lascas, sujeira nas sobreposições, líquen
		float rows = 6.0;
		float row = floor(uv.y * rows);
		float off = mod(row, 2.0) * 0.5;
		float tx = uv.x * 4.0 + off;
		float fx = fract(tx);
		float fy = fract(uv.y * rows);
		vec2 tid = vec2(mod(floor(tx), 4.0), row);
		float r = hash21(tid);
		float curve = sin(fx * PI);
		float lap = smoothstep(0.0, 0.25, fy);
		float n = fbm(uv, 12.0, 4);
		vec3 tc = mix(vec3(0.48, 0.19, 0.11), vec3(0.68, 0.34, 0.19), r);
		tc = mix(tc, vec3(0.36, 0.2, 0.14), step(0.88, r) * 0.6);
		tc *= 0.88 + n * 0.25;
		float lichen = smoothstep(0.7, 0.76, fbm(uv, 6.0, 5)) * (0.4 + lap * 0.6);
		float moss = smoothstep(0.6, 0.75, fbm(uv + 3.0, 3.0, 5)) * (1.0 - lap);
		float chip = smoothstep(0.82, 0.9, vnoise(uv, vec2(40.0))) * (1.0 - smoothstep(0.0, 0.1, 1.0 - fy));
		tc = mix(tc, vec3(0.6, 0.58, 0.48), lichen * 0.35);
		tc = mix(tc, vec3(0.2, 0.23, 0.1), moss * 0.7);
		tc = mix(tc, vec3(0.55, 0.36, 0.28), chip);
		alb = tc * (0.72 + curve * 0.32) * (0.6 + lap * 0.4);
		h = curve * 0.6 + lap * 0.4 + n * 0.05 - chip * 0.2;
		rough = 0.72 + moss * 0.2 + lichen * 0.1;
		ao = 0.5 + lap * 0.5;
	} else if (id == 5) { // metal ondulado pintado: riscos, tinta lascada nas cristas, ferrugem escorrida
		float c = 0.5 + 0.5 * sin(uv.x * 12.0 * 2.0 * PI);
		float spots = smoothstep(0.62, 0.72, fbm(uv, 4.0, 6));
		float bleed = smoothstep(0.5, 0.75, fbm2(uv + vec2(0.0, 0.1), vec2(40.0, 2.0), 4)) * smoothstep(0.45, 0.65, fbm(uv + vec2(0.0, 0.15), 4.0, 4));
		float chip = smoothstep(0.7, 0.8, vnoise(uv, vec2(80.0))) * smoothstep(0.7, 0.95, c);
		float scr = scratches(uv, 24.0, 0.5, 0.02);
		float streak = fbm2(uv, vec2(24.0, 2.0), 4);
		vec3 paint = vec3(0.34, 0.4, 0.43) * (0.88 + streak * 0.22);
		vec3 rc = mix(vec3(0.24, 0.11, 0.05), vec3(0.5, 0.27, 0.11), fbm(uv, 16.0, 3));
		vec3 bare = vec3(0.55, 0.56, 0.57);
		vec3 col = paint;
		col = mix(col, bare, max(chip, scr * 0.7));
		col = mix(col, rc, max(spots, bleed * 0.6));
		alb = col;
		float rust = max(spots, bleed * 0.6);
		h = c * 0.8 + spots * 0.1 - scr * 0.05;
		rough = mix(mix(0.45, 0.3, chip), 0.9, rust);
		metal = mix(mix(0.45, 0.95, max(chip, scr * 0.7)), 0.1, rust);
		ao = 0.72 + c * 0.28;
	} else if (id == 6) { // tábuas: veio com anéis, nós, emendas, pregos, desgaste e sujeira nas frestas
		float planks = 5.0;
		float px_ = uv.x * planks;
		float pid = mod(floor(px_), planks);
		float fx = fract(px_);
		float r = hash21(vec2(pid, 1.0));
		// emenda de topo (tábuas de comprimentos diferentes)
		float jy = fract(uv.y + r);
		float joint = 1.0 - smoothstep(0.0, 0.008, min(jy, 1.0 - jy)) * 1.0;
		float gap = smoothstep(0.0, 0.03, fx) * smoothstep(0.0, 0.03, 1.0 - fx) * (1.0 - joint * 0.8);
		float warp = fbm2(uv + vec2(r * 3.0, 0.0), vec2(6.0, 1.0), 4);
		// nó: centro por tábua, anéis contornam o nó
		vec2 kc = vec2((pid + 0.3 + hash21(vec2(pid, 5.0)) * 0.4) / planks, fract(hash21(vec2(pid, 8.0)) + 0.2));
		vec2 kd = vec2((uv.x - kc.x) * planks, (fract(uv.y - kc.y + 0.5) - 0.5) * 1.6);
		float kr = length(kd);
		float has_knot = step(0.45, hash21(vec2(pid, 9.0)));
		float knot = (1.0 - smoothstep(0.03, 0.09, kr)) * has_knot;
		float around = exp(-kr * 8.0) * has_knot;
		float ring_x = fx * 3.0 + warp * 2.5 + around * 1.2 / max(kr, 0.05) * 0.05;
		float rings = 0.5 + 0.5 * sin(ring_x * 2.0 * PI * (3.0 + r * 3.0));
		float fibers = fbm2(uv + vec2(r, 0.0), vec2(160.0, 4.0), 3);
		vec3 lightw = mix(vec3(0.52, 0.36, 0.22), vec3(0.62, 0.46, 0.3), r);
		vec3 darkw = lightw * vec3(0.62, 0.55, 0.5);
		vec3 wc = mix(darkw, lightw, smoothstep(0.25, 0.85, rings));
		wc *= 0.85 + fibers * 0.3;
		wc = mix(wc, vec3(0.18, 0.11, 0.07), knot * 0.85);
		float worn = smoothstep(0.55, 0.8, fbm(uv + 3.3, 3.0, 4));
		wc = mix(wc, wc * 1.2 + 0.04, worn * 0.35);
		float dirt = (1.0 - smoothstep(0.03, 0.12, min(fx, 1.0 - fx))) * 0.5;
		wc *= 1.0 - dirt * 0.4;
		// pregos nas pontas das tábuas
		vec2 nd = vec2((fx - 0.5) / 0.25, (jy < 0.5 ? jy : jy - 1.0) * planks * 1.6 - 0.25);
		float nail = (1.0 - smoothstep(0.08, 0.14, length(vec2(abs(nd.x) - 1.0, nd.y)))) * step(0.3, r);
		wc = mix(wc, vec3(0.12, 0.11, 0.1), nail);
		alb = wc * (0.35 + gap * 0.65);
		h = 0.45 + rings * 0.1 + fibers * 0.15 + gap * 0.2 - (1.0 - gap) * 0.45 - knot * 0.1 - nail * 0.2;
		rough = 0.72 - worn * 0.12 + knot * 0.1;
		metal = nail * 0.6;
		ao = 0.45 + gap * 0.55;
	} else if (id == 7) { // grama (solo): folhas finas, trevos, palha, falhas de terra
		float n = fbm(uv, 3.0, 5);
		float blades = vnoise(uv * vec2(1.0, 0.35), vec2(240.0, 84.0));
		float blades2 = vnoise((uv + 0.5) * vec2(0.4, 1.0), vec2(96.0, 240.0));
		float dry = smoothstep(0.5, 0.75, fbm(uv + 5.0, 2.0, 4));
		float bald = smoothstep(0.68, 0.74, fbm(uv + 8.0, 3.0, 5));
		vec3 cl = voronoi(uv, 60.0);
		float clover = smoothstep(0.3, 0.12, cl.x) * step(0.7, cl.z);
		vec3 g = mix(vec3(0.11, 0.19, 0.05), vec3(0.22, 0.3, 0.09), n);
		g = mix(g, vec3(0.34, 0.31, 0.15), dry * 0.7);
		g *= 0.55 + max(blades, blades2) * 0.8;
		g *= 0.9 + vnoise(uv, vec2(400.0)) * 0.2;
		g = mix(g, vec3(0.14, 0.26, 0.07), clover * 0.6);
		vec3 soil = mix(vec3(0.2, 0.15, 0.1), vec3(0.3, 0.23, 0.15), vnoise(uv, vec2(120.0)));
		g = mix(g, soil, bald * 0.85);
		alb = g;
		h = max(blades, blades2) * 0.7 * (1.0 - bald) + n * 0.3;
		rough = 0.96;
		ao = 0.65 + max(blades, blades2) * 0.35;
	} else if (id == 8) { // terra: torrões, pedrinhas sombreadas, gravetos, gretas de seca
		float n = fbm(uv, 4.0, 6);
		vec3 v = voronoi(uv, 22.0);
		vec3 v2 = voronoi(uv + 0.4, 55.0);
		float peb = smoothstep(0.34, 0.16 + v.z * 0.1, v.x) * step(0.8, v.z);
		float peb2 = smoothstep(0.3, 0.12, v2.x) * step(0.86, v2.z);
		float clod = smoothstep(0.4, 0.0, voronoi(uv + 0.8, 30.0).x);
		float dryc = cracks(uv, 7.0, 0.2, 0.025) * smoothstep(0.55, 0.7, fbm(uv + 6.0, 2.0, 3));
		float twig = scratches(uv, 14.0, 0.25, 0.035);
		vec3 d = mix(vec3(0.2, 0.15, 0.1), vec3(0.37, 0.28, 0.19), n);
		d *= 0.85 + clod * 0.25;
		d = mix(d, vec3(0.44, 0.4, 0.35) * (0.75 + v.z * 0.35), peb);
		d = mix(d, vec3(0.38, 0.34, 0.3) * (0.8 + v2.z * 0.3), peb2);
		d = mix(d, vec3(0.28, 0.2, 0.12), twig * 0.8);
		d *= 1.0 - dryc * 0.5;
		alb = d;
		h = n * 0.35 + clod * 0.2 + peb * 0.5 + peb2 * 0.3 + twig * 0.15 - dryc * 0.4;
		rough = 0.95 - peb * 0.1;
		ao = 0.75 + max(peb, peb2) * 0.25 - dryc * 0.3;
	} else if (id == 9) { // rocha
		float n = fbm(uv, 3.0, 7);
		float ridge = 1.0 - abs(fbm(uv + 3.0, 4.0, 5) * 2.0 - 1.0);
		vec3 v = voronoi(uv + n * 0.2, 5.0);
		float crack = 1.0 - smoothstep(0.0, 0.04, v.y);
		float lichen = smoothstep(0.66, 0.72, fbm(uv + 9.0, 8.0, 4));
		float grain = vnoise(uv, vec2(180.0));
		float strata = 0.5 + 0.5 * sin((uv.y * 18.0 + n * 3.0) * PI);
		vec3 rc = mix(vec3(0.3, 0.29, 0.27), vec3(0.48, 0.46, 0.42), n);
		rc *= 0.88 + grain * 0.2 + strata * 0.06;
		rc = mix(rc, vec3(0.45, 0.46, 0.3), lichen * 0.6);
		alb = rc * (1.0 - crack * 0.5);
		h = n * 0.5 + ridge * 0.35 + grain * 0.05 - crack * 0.4;
		rough = 0.86;
		ao = 1.0 - crack * 0.6;
	} else if (id == 10) { // piso cerâmico: esmalte mesclado, trincas, cantos lascados, rejunte sujo
		float t = 3.0;
		vec2 f = fract(uv * t);
		vec2 tid = mod(floor(uv * t), vec2(t));
		float ed = min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y));
		float grout = smoothstep(0.0, 0.025, ed);
		float r = hash21(tid);
		float n = fbm(uv, 6.0, 4);
		float speck = smoothstep(0.75, 0.9, vnoise(uv, vec2(240.0)));
		float marble = smoothstep(0.4, 0.6, fbm2(uv + r, vec2(8.0, 3.0), 5));
		vec3 tc = mix(vec3(0.6, 0.56, 0.5), vec3(0.73, 0.69, 0.61), r) * (0.92 + n * 0.1);
		tc = mix(tc, tc * 0.85, marble * 0.3);
		tc *= 1.0 - speck * 0.12;
		float cracked = step(0.78, r) * cracks(uv + r, 6.0, 0.2, 0.012);
		float chip = (1.0 - smoothstep(0.0, 0.06, ed)) * step(0.7, hash21(tid + 2.0)) * smoothstep(0.55, 0.7, vnoise(uv, vec2(48.0)));
		float scuff = smoothstep(0.6, 0.8, fbm2(uv, vec2(3.0, 16.0), 4));
		vec3 gc = vec3(0.27, 0.26, 0.24) * (0.8 + vnoise(uv, vec2(300.0)) * 0.3);
		vec3 c = mix(gc, tc, grout);
		c = mix(c, vec3(0.4, 0.38, 0.34), chip);
		c *= 1.0 - cracked * 0.5 - scuff * 0.08;
		alb = c;
		h = grout * 0.8 + n * 0.05 - chip * 0.3 - cracked * 0.3;
		rough = mix(0.88, 0.22 + n * 0.1 + scuff * 0.25, grout * (1.0 - chip));
		ao = 0.55 + grout * 0.45;
	} else if (id == 11) { // painéis pré-moldados: juntas, chumbadores, escorridos de sujeira, pátina
		vec2 f = fract(uv * 2.0);
		float ed = min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y));
		float seam = smoothstep(0.0, 0.01, ed);
		float n = fbm(uv, 4.0, 5);
		float streak = fbm2(uv, vec2(12.0, 1.0), 4);
		float drip = smoothstep(0.5, 0.8, fbm2(uv + 0.3, vec2(36.0, 1.2), 4)) * smoothstep(1.0, 0.3, f.y);
		vec2 bf = abs(f - vec2(0.1));
		float bolt = 1.0 - smoothstep(0.012, 0.02, length(f - vec2(0.08, 0.08))) ;
		bolt = max(bolt, 1.0 - smoothstep(0.012, 0.02, length(f - vec2(0.92, 0.08))));
		float pores = smoothstep(0.82, 0.93, vnoise(uv, vec2(240.0)));
		float g = 0.58 + n * 0.1 - streak * 0.06;
		vec3 c = vec3(g, g * 0.99, g * 0.96);
		c = mix(c, c * vec3(0.7, 0.68, 0.64), drip * 0.5);
		c *= 1.0 - pores * 0.2;
		c = mix(c, vec3(0.25, 0.24, 0.23), bolt * 0.8);
		alb = c * (0.55 + seam * 0.45);
		h = 0.5 + n * 0.2 + seam * 0.3 - (1.0 - seam) * 0.3 - bolt * 0.2 - pores * 0.1;
		rough = 0.78 - drip * 0.08;
		metal = bolt * 0.5;
		ao = 0.6 + seam * 0.4;
	} else if (id == 12) { // cascalho
		vec3 v = voronoi(uv, 18.0);
		vec3 v2 = voronoi(uv + 0.37, 31.0);
		vec3 v3 = voronoi(uv + 0.71, 60.0);
		float s1 = smoothstep(0.45, 0.2, v.x);
		float s2 = smoothstep(0.4, 0.15, v2.x);
		float s3 = smoothstep(0.35, 0.1, v3.x);
		vec3 c = mix(vec3(0.3, 0.28, 0.25), vec3(0.54, 0.5, 0.45), v.z);
		c = mix(c, vec3(0.42, 0.37, 0.31) * (0.8 + v2.z * 0.4), s2 * (1.0 - s1));
		c = mix(c, vec3(0.36, 0.34, 0.32) * (0.8 + v3.z * 0.4), s3 * (1.0 - max(s1, s2)));
		float top = smoothstep(0.0, 0.6, s1);
		alb = c * (0.5 + max(max(s1, s2), s3) * 0.5) * (0.9 + top * 0.15);
		h = max(max(s1, s2 * 0.8), s3 * 0.6);
		rough = 0.93;
		ao = 0.5 + max(max(s1, s2), s3) * 0.5;
	} else if (id == 13) { // casca de árvore
		float fib = fbm2(uv, vec2(14.0, 2.0), 5);
		float ridges = smoothstep(0.35, 0.65, fib);
		float plates = voronoi(uv * vec2(1.0, 0.4), 10.0).y;
		float deep = 1.0 - smoothstep(0.0, 0.08, plates);
		vec3 bc = mix(vec3(0.13, 0.09, 0.06), vec3(0.32, 0.26, 0.2), ridges);
		bc *= 1.0 - deep * 0.5;
		float moss = smoothstep(0.6, 0.72, fbm(uv, 4.0, 4));
		bc = mix(bc, vec3(0.2, 0.25, 0.1), moss * 0.5);
		alb = bc * (0.9 + vnoise(uv, vec2(160.0)) * 0.2);
		h = ridges - deep * 0.4;
		rough = 0.92;
		ao = 0.45 + ridges * 0.55 - deep * 0.2;
	} else if (id == 14) { // tecido (estofado): trama, fiapos, manchas, desbotado
		float wx = 0.5 + 0.5 * sin(uv.x * 160.0 * PI);
		float wy = 0.5 + 0.5 * sin(uv.y * 160.0 * PI);
		float weave = mix(wx, wy, step(0.5, fract((floor(uv.x * 160.0) + floor(uv.y * 160.0)) * 0.5)));
		float n = fbm(uv, 4.0, 4);
		float fuzz = vnoise(uv, vec2(320.0));
		float stain = smoothstep(0.62, 0.7, fbm(uv + 4.0, 3.0, 5));
		float ring = smoothstep(0.62, 0.64, fbm(uv + 4.0, 3.0, 5)) - smoothstep(0.64, 0.68, fbm(uv + 4.0, 3.0, 5));
		float fade = smoothstep(0.5, 0.8, fbm(uv + 9.0, 2.0, 3));
		vec3 c = vec3(0.76 + weave * 0.1) * (0.88 + n * 0.15 + fuzz * 0.06);
		c = mix(c, c * vec3(0.72, 0.64, 0.5), stain * 0.55);
		c *= 1.0 - ring * 0.2;
		c = mix(c, c * 1.12 + 0.03, fade * 0.3);
		alb = c;
		h = weave * 0.6 + n * 0.2 + fuzz * 0.1;
		rough = 0.95;
		ao = 0.8 + weave * 0.2;
	} else { // 15: linóleo / vinílico: pontilhado, emendas, marcas de arrasto, riscos
		float n = fbm(uv, 3.0, 5);
		float spk = smoothstep(0.8, 0.95, vnoise(uv, vec2(200.0)));
		float spk2 = smoothstep(0.85, 0.97, vnoise(uv + 0.3, vec2(90.0)));
		float scuff = smoothstep(0.6, 0.8, fbm2(uv, vec2(3.0, 18.0), 4));
		float scr = scratches(uv, 16.0, 0.45, 0.015);
		vec2 f = fract(uv * 1.0);
		float seam = 1.0 - smoothstep(0.0, 0.004, min(f.x, 1.0 - f.x));
		vec3 c = vec3(0.56, 0.6, 0.57) * (0.93 + n * 0.1);
		c = mix(c, vec3(0.3, 0.32, 0.3), spk * 0.5);
		c = mix(c, vec3(0.75, 0.77, 0.74), spk2 * 0.4);
		c *= 1.0 - scuff * 0.14 - scr * 0.12;
		c *= 1.0 - seam * 0.4;
		alb = c;
		h = 0.5 + n * 0.1 - scr * 0.1 - seam * 0.3;
		rough = 0.32 + scuff * 0.3 + scr * 0.2;
		ao = 1.0 - seam * 0.3;
	}
}

// ---------------------------------------------------------------------------
// Atlas de personagens (uv local do quadrante 0..1)
// ---------------------------------------------------------------------------
void char_surface(int q, vec2 uv, out vec3 alb, out float h, out float rough, out float extra) {
	extra = 0.0;
	if (q == 0) { // pele: poros + manchas suaves + veias (máscara)
		float pores = vnoise(uv, vec2(96.0));
		float blot = fbm(uv, 3.0, 4);
		alb = vec3(0.94 + blot * 0.06, 0.92 + blot * 0.04, 0.9 + blot * 0.03) * (0.96 + pores * 0.04);
		h = 0.5 + pores * 0.15 - smoothstep(0.7, 0.9, pores) * 0.3;
		rough = 0.52 + blot * 0.1;
		vec3 v = voronoi(uv + fbm(uv, 6.0, 3) * 0.15, 6.0);
		extra = 1.0 - smoothstep(0.0, 0.04, v.y);
	} else if (q == 1) { // malha de algodão
		float knitx = 0.5 + 0.5 * sin(uv.x * 64.0 * 2.0 * PI);
		float knity = 0.5 + 0.5 * sin((uv.y * 128.0 + knitx * 0.5) * PI);
		float n = fbm(uv, 4.0, 4);
		alb = vec3(0.86 + knity * 0.08) * (0.94 + n * 0.1);
		h = knity * 0.5 + knitx * 0.2;
		rough = 0.93;
	} else if (q == 2) { // brim (sarja diagonal)
		float d = fract((uv.x + uv.y) * 90.0);
		float tw = smoothstep(0.2, 0.5, d) * smoothstep(0.9, 0.6, d);
		float n = fbm(uv, 5.0, 5);
		float fade = smoothstep(0.5, 0.8, fbm(uv + 2.0, 2.0, 3));
		alb = vec3(0.8 + tw * 0.15 + fade * 0.12) * (0.9 + n * 0.15);
		h = tw * 0.6 + n * 0.2;
		rough = 0.86;
	} else { // couro / borracha
		vec3 v = voronoi(uv, 40.0);
		float n = fbm(uv, 4.0, 4);
		float grain = smoothstep(0.0, 0.08, v.y);
		alb = vec3(0.84 + n * 0.1) * (0.9 + grain * 0.1);
		h = grain * 0.6 + n * 0.2;
		rough = 0.42 + (1.0 - grain) * 0.2;
	}
}

// ---------------------------------------------------------------------------
// Atlas das armas (quadrantes): 0 nogueira envernizada, 1 aço (escovado,
// riscos, desgaste), 2 polímero pontilhado, 3 borracha/couro quadriculado.
// extra = metalicidade
// ---------------------------------------------------------------------------
void weapon_surface(int q, vec2 uv, out vec3 alb, out float h, out float rough, out float extra) {
	extra = 0.0;
	if (q == 0) { // nogueira: veio longo contínuo, figura, poros, verniz gasto
		float warp = fbm2(uv, vec2(3.0, 1.0), 5);
		float ring = 0.5 + 0.5 * sin((uv.x * 40.0 + warp * 9.0 + fbm(uv, 6.0, 4) * 3.0) * 2.0 * PI);
		ring = pow(ring, 3.0);   // anéis finos e escuros sobre fundo claro
		float fig = fbm2(uv + 0.3, vec2(48.0, 5.0), 4);
		float pores = smoothstep(0.75, 0.92, vnoise(uv * vec2(1.0, 0.25), vec2(300.0, 75.0)));
		vec3 lw = vec3(0.42, 0.26, 0.15);
		vec3 dw = vec3(0.26, 0.15, 0.08);
		vec3 c = mix(lw, dw, ring * 0.55 + fig * 0.3);
		c *= 0.9 + fbm(uv + 7.0, 3.0, 3) * 0.2;
		c *= 1.0 - pores * 0.25;
		float worn = smoothstep(0.6, 0.8, fbm(uv + 2.0, 3.0, 4));
		c = mix(c, c * 1.25 + vec3(0.04, 0.03, 0.02), worn * 0.4);
		alb = c;
		h = 0.5 + ring * 0.08 + fig * 0.08 - pores * 0.15;
		rough = 0.38 + worn * 0.25 + pores * 0.15;
	} else if (q == 1) { // aço: escovado, riscos, oxidação leve, desgaste claro
		float brush = fbm2(uv, vec2(2.0, 180.0), 3);
		float scr = scratches(uv, 18.0, 0.7, 0.012);
		float scr2 = scratches(uv + 0.5, 40.0, 0.5, 0.02);
		float ox = smoothstep(0.66, 0.78, fbm(uv + 4.0, 5.0, 5));
		float n = fbm(uv, 8.0, 4);
		vec3 c = vec3(0.62, 0.63, 0.65) * (0.85 + brush * 0.25 + n * 0.08);
		c = mix(c, vec3(0.85), max(scr, scr2 * 0.6) * 0.6);
		c = mix(c, vec3(0.3, 0.2, 0.14), ox * 0.45);
		alb = c;
		h = 0.5 + brush * 0.05 - scr * 0.12 - scr2 * 0.06 + ox * 0.05;
		rough = 0.3 + brush * 0.12 + ox * 0.35 - scr * 0.1;
		extra = 1.0 - ox * 0.6;
	} else if (q == 2) { // polímero: pontilhado fino, desgaste brilhante nas bordas
		float st = vnoise(uv, vec2(300.0));
		float st2 = smoothstep(0.55, 0.8, vnoise(uv + 0.2, vec2(140.0)));
		float n = fbm(uv, 6.0, 4);
		float scuff = smoothstep(0.65, 0.8, fbm2(uv, vec2(4.0, 20.0), 4));
		vec3 c = vec3(0.17 + st * 0.04 + n * 0.03);
		c = mix(c, c * 1.35, scuff * 0.5);
		alb = c;
		h = 0.5 + st * 0.2 + st2 * 0.15;
		rough = 0.72 - scuff * 0.25;
	} else { // borracha / couro: quadriculado (checkering) com sujeira nos sulcos
		vec2 d = uv * 90.0;
		float a = abs(fract(d.x + d.y) - 0.5);
		float b = abs(fract(d.x - d.y) - 0.5);
		float diamond = smoothstep(0.06, 0.18, min(a, b));
		float n = fbm(uv, 5.0, 4);
		float grime = vnoise(uv, vec2(120.0));
		vec3 c = vec3(0.16 + n * 0.04) * (0.8 + diamond * 0.25);
		c *= 1.0 - (1.0 - diamond) * grime * 0.25;
		alb = c;
		h = diamond * 0.22 + n * 0.08;
		rough = 0.82 - diamond * 0.1;
	}
}

// Folhas: 4x4 células com uma folha elíptica rotacionada cada
vec4 leaves(vec2 uv) {
	vec4 outc = vec4(0.0);
	for (int j = 0; j < 2; j++) {
		vec2 cuv = uv * 4.0 + vec2(float(j) * 0.5, float(j) * 0.37);
		vec2 cid = floor(cuv);
		vec2 f = fract(cuv) - 0.5;
		float r = hash21(mod(cid, vec2(4.0)) + float(j) * 13.0);
		float ang = r * PI * 2.0;
		mat2 rot = mat2(vec2(cos(ang), -sin(ang)), vec2(sin(ang), cos(ang)));
		vec2 p = rot * f;
		p.y += 0.05;
		float len = 0.42 + r * 0.06;
		float wid = 0.16 + fract(r * 7.0) * 0.06;
		float e = (p.x * p.x) / (wid * wid * (1.0 - clamp(p.y / len, -1.0, 1.0) * 0.4)) + (p.y * p.y) / (len * len);
		if (e < 1.0) {
			float rib = 1.0 - smoothstep(0.0, 0.015, abs(p.x));
			float veins = 0.5 + 0.5 * sin((p.y * 40.0 + abs(p.x) * 30.0));
			vec3 c = mix(vec3(0.1, 0.2, 0.05), vec3(0.24, 0.34, 0.1), fract(r * 3.3));
			c = mix(c, vec3(0.38, 0.33, 0.12), step(0.85, fract(r * 5.1)) * 0.7);
			c *= 0.85 + veins * 0.1 + rib * 0.2;
			c *= 0.75 + (1.0 - e) * 0.35;
			outc = vec4(c, 1.0);
		}
	}
	return outc;
}

vec4 sprite(int id, vec2 uv) {
	vec2 c = uv - 0.5;
	float r = length(c) * 2.0;
	if (id == 0) { // fumaça
		float n = fbm(uv, 4.0, 5);
		float a = smoothstep(1.0, 0.2, r + (n - 0.5) * 0.6);
		return vec4(vec3(0.75 + n * 0.25), a * a);
	} else if (id == 1) { // papel
		float edge = step(0.08, uv.x) * step(uv.x, 0.92) * step(0.04, uv.y) * step(uv.y, 0.96);
		float lines = step(0.6, fract(uv.y * 16.0)) * step(0.15, uv.x) * step(uv.x, 0.85) * step(0.12, uv.y);
		float n = fbm(uv, 4.0, 3);
		vec3 col = vec3(0.86, 0.84, 0.78) * (0.92 + n * 0.1) - lines * 0.35;
		return vec4(col, edge);
	} else if (id == 2) { // faísca / brilho
		float a = pow(max(0.0, 1.0 - r), 3.0);
		return vec4(vec3(1.0, 0.85, 0.55), a);
	} else if (id == 3) { // gota de chuva (risco vertical)
		float a = smoothstep(0.12, 0.0, abs(c.x)) * smoothstep(0.5, 0.2, abs(c.y));
		return vec4(vec3(0.8, 0.85, 0.9), a * 0.8);
	} else { // folha seca
		vec4 l = leaves(uv * 0.25);
		return vec4(mix(l.rgb, vec3(0.4, 0.3, 0.15), 0.6), l.a);
	}
}

void fragment() {
	vec2 uv = UV;
	if (mode == 0) {
		vec3 alb; float h; float rough; float metal; float ao;
		surface(layer, uv, alb, h, rough, metal, ao);
		if (channel == 0) {
			COLOR = vec4(clamp(alb, 0.0, 1.0), clamp(rough, 0.0, 1.0));
		} else {
			vec3 a2; float hx; float hy; float r2; float m2; float o2;
			surface(layer, fract(uv + vec2(px, 0.0)), a2, hx, r2, m2, o2);
			surface(layer, fract(uv + vec2(0.0, px)), a2, hy, r2, m2, o2);
			float strength = 2.2;
			vec3 n = normalize(vec3(-(hx - h) * strength / (px * 256.0), (hy - h) * strength / (px * 256.0), 1.0));
			COLOR = vec4(n.xy * 0.5 + 0.5, clamp(ao, 0.0, 1.0), clamp(metal, 0.0, 1.0));
		}
	} else if (mode == 1) {
		int q = int(step(0.5, uv.x)) + int(step(0.5, uv.y)) * 2;
		vec2 luv = fract(uv * 2.0);
		vec3 alb; float h; float rough; float extra;
		char_surface(q, luv, alb, h, rough, extra);
		if (channel == 0) {
			COLOR = vec4(alb, rough);
		} else {
			vec3 a2; float hx; float hy; float r2; float e2;
			char_surface(q, fract(luv + vec2(px * 2.0, 0.0)), a2, hx, r2, e2);
			char_surface(q, fract(luv + vec2(0.0, px * 2.0)), a2, hy, r2, e2);
			float strength = 1.2;
			vec3 n = normalize(vec3(-(hx - h) * strength / (px * 512.0), (hy - h) * strength / (px * 512.0), 1.0));
			COLOR = vec4(n.xy * 0.5 + 0.5, 1.0, extra);
		}
	} else if (mode == 5) {
		int q = int(step(0.5, uv.x)) + int(step(0.5, uv.y)) * 2;
		vec2 luv = fract(uv * 2.0);
		vec3 alb; float h; float rough; float extra;
		weapon_surface(q, luv, alb, h, rough, extra);
		if (channel == 0) {
			COLOR = vec4(clamp(alb, 0.0, 1.0), clamp(rough, 0.0, 1.0));
		} else {
			vec3 a2; float hx; float hy; float r2; float e2;
			weapon_surface(q, fract(luv + vec2(px * 2.0, 0.0)), a2, hx, r2, e2);
			weapon_surface(q, fract(luv + vec2(0.0, px * 2.0)), a2, hy, r2, e2);
			float strength = 1.6;
			vec3 n = normalize(vec3(-(hx - h) * strength / (px * 512.0), (hy - h) * strength / (px * 512.0), 1.0));
			COLOR = vec4(n.xy * 0.5 + 0.5, 1.0, extra);
		}
	} else if (mode == 2) {
		COLOR = leaves(uv);
	} else if (mode == 3) {
		COLOR = sprite(layer, uv);
	} else {
		float a = fbm(uv, 2.0, 5);
		float b = fbm(uv + 0.5, 8.0, 4);
		float c = vnoise(uv, vec2(64.0));
		vec3 v = voronoi(uv, 8.0);
		COLOR = vec4(a, b, c, v.x);
	}
}
