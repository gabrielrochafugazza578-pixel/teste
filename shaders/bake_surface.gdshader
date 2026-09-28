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
shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform int mode = 0;
uniform int layer = 0;
uniform int channel = 0;
uniform float px = 0.001953125;

const float PI = 3.14159265;

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
// Superfícies do mundo. Saída: albedo, altura (0..1), roughness, metallic, ao
// ---------------------------------------------------------------------------
void surface(int id, vec2 uv, out vec3 alb, out float h, out float rough, out float metal, out float ao) {
	metal = 0.0;
	ao = 1.0;
	if (id == 0) { // asfalto
		float agg = vnoise(uv, vec2(160.0));
		vec3 st = voronoi(uv, 48.0);
		float stones = smoothstep(0.35, 0.1, st.x);
		float patch = smoothstep(0.58, 0.62, fbm(uv, 3.0, 4));
		vec3 cr = voronoi(uv + fbm(uv, 4.0, 3) * 0.05, 5.0);
		float crack = 1.0 - smoothstep(0.0, 0.025, cr.y);
		float base = 0.13 + agg * 0.05 + stones * st.z * 0.09;
		alb = vec3(base * 0.98, base, base * 1.04);
		alb = mix(alb, vec3(0.075, 0.075, 0.08), patch * 0.8);
		alb *= 1.0 - crack * 0.5;
		h = 0.45 + stones * 0.35 + agg * 0.2 - crack * 0.5;
		rough = 0.86 - patch * 0.12 - stones * 0.05;
		ao = 1.0 - crack * 0.5;
	} else if (id == 1) { // concreto (calçada)
		float n = fbm(uv, 4.0, 5);
		float pores = smoothstep(0.75, 0.9, vnoise(uv, vec2(220.0)));
		vec2 slab = fract(uv * 2.0);
		float seam = 1.0 - smoothstep(0.0, 0.012, min(min(slab.x, 1.0 - slab.x), min(slab.y, 1.0 - slab.y)));
		float stain = smoothstep(0.55, 0.8, fbm(uv + 0.3, 2.0, 4));
		float g = 0.5 + n * 0.12 - stain * 0.12;
		alb = vec3(g * 1.02, g, g * 0.95);
		alb *= 1.0 - seam * 0.45;
		h = 0.6 + n * 0.25 - pores * 0.2 - seam * 0.6;
		rough = 0.9 - stain * 0.1;
		ao = 1.0 - seam * 0.6;
	} else if (id == 2) { // tijolo
		float rows = 14.0;
		float row = floor(uv.y * rows);
		float off = mod(row, 2.0) * 0.5;
		float bx = uv.x * 4.0 + off;
		vec2 bid = vec2(mod(floor(bx), 4.0), mod(row, rows));
		float fx = fract(bx);
		float fy = fract(uv.y * rows);
		float mw = 0.05;
		float mx = smoothstep(0.0, mw, fx) * smoothstep(0.0, mw, 1.0 - fx);
		float my = smoothstep(0.0, mw * 3.0, fy) * smoothstep(0.0, mw * 3.0, 1.0 - fy);
		float brick = mx * my;
		float r = hash21(bid);
		float n = fbm(uv, 16.0, 4);
		vec3 bc = mix(vec3(0.42, 0.17, 0.11), vec3(0.62, 0.33, 0.22), r);
		bc = mix(bc, vec3(0.3, 0.26, 0.24), step(0.92, r) * 0.6);
		bc *= 0.85 + n * 0.3;
		vec3 mc = vec3(0.52, 0.5, 0.46) * (0.85 + n * 0.2);
		alb = mix(mc, bc, brick);
		h = mix(0.25, 0.75 + n * 0.2, brick);
		rough = mix(0.95, 0.82, brick);
		ao = mix(0.6, 1.0, brick);
	} else if (id == 3) { // reboco pintado
		float n = fbm(uv, 3.0, 6);
		float fine = vnoise(uv, vec2(180.0));
		vec3 cr = voronoi(uv + n * 0.1, 3.0);
		float crack = (1.0 - smoothstep(0.0, 0.012, cr.y)) * smoothstep(0.6, 0.7, fbm(uv + 7.0, 2.0, 3));
		float peel = smoothstep(0.7, 0.72, fbm(uv + 2.0, 4.0, 5));
		float g = 0.8 + n * 0.1 + fine * 0.05;
		alb = vec3(g);
		alb = mix(alb, vec3(0.55, 0.52, 0.48), peel);
		alb *= 1.0 - crack * 0.5;
		h = 0.5 + n * 0.3 + fine * 0.1 - peel * 0.3 - crack * 0.4;
		rough = 0.85;
		ao = 1.0 - crack * 0.4;
	} else if (id == 4) { // telha cerâmica
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
		vec3 tc = mix(vec3(0.5, 0.2, 0.12), vec3(0.66, 0.32, 0.18), r);
		float moss = smoothstep(0.6, 0.75, fbm(uv, 3.0, 5)) * (1.0 - lap * 0.5);
		tc = mix(tc, vec3(0.22, 0.24, 0.12), moss * 0.7);
		alb = tc * (0.75 + curve * 0.3) * (0.7 + lap * 0.3);
		h = curve * 0.6 + lap * 0.4;
		rough = 0.72 + moss * 0.2;
		ao = 0.55 + lap * 0.45;
	} else if (id == 5) { // metal ondulado pintado
		float c = 0.5 + 0.5 * sin(uv.x * 12.0 * 2.0 * PI);
		float rust = smoothstep(0.55, 0.7, fbm(uv, 4.0, 6) + (1.0 - uv.y) * 0.0);
		float streak = fbm2(uv, vec2(24.0, 2.0), 4);
		vec3 paint = vec3(0.34, 0.4, 0.43) * (0.9 + streak * 0.2);
		vec3 rc = mix(vec3(0.28, 0.13, 0.06), vec3(0.45, 0.24, 0.1), fbm(uv, 16.0, 3));
		alb = mix(paint, rc, rust);
		h = c * 0.8 + rust * 0.1;
		rough = mix(0.45, 0.9, rust);
		metal = mix(0.55, 0.15, rust);
		ao = 0.75 + c * 0.25;
	} else if (id == 6) { // tábuas de madeira
		float planks = 5.0;
		float px_ = uv.x * planks;
		float pid = mod(floor(px_), planks);
		float fx = fract(px_);
		float gap = smoothstep(0.0, 0.03, fx) * smoothstep(0.0, 0.03, 1.0 - fx);
		float r = hash21(vec2(pid, 1.0));
		float grain = fbm2(uv + vec2(r, 0.0), vec2(40.0, 3.0), 5);
		float rings = 0.5 + 0.5 * sin((uv.x * 60.0 + grain * 6.0) * PI);
		vec3 wc = mix(vec3(0.3, 0.19, 0.11), vec3(0.5, 0.34, 0.2), r);
		wc *= 0.8 + grain * 0.3 + rings * 0.08;
		alb = wc * (0.4 + gap * 0.6);
		h = 0.4 + grain * 0.4 + gap * 0.2 - (1.0 - gap) * 0.4;
		rough = 0.74;
		ao = 0.5 + gap * 0.5;
	} else if (id == 7) { // grama (solo)
		float n = fbm(uv, 3.0, 5);
		float blades = vnoise(uv * vec2(1.0, 0.35), vec2(240.0, 84.0));
		float dry = smoothstep(0.5, 0.75, fbm(uv + 5.0, 2.0, 4));
		vec3 g = mix(vec3(0.12, 0.2, 0.06), vec3(0.2, 0.28, 0.09), n);
		g = mix(g, vec3(0.32, 0.29, 0.14), dry * 0.7);
		g *= 0.75 + blades * 0.45;
		alb = g;
		h = blades * 0.7 + n * 0.3;
		rough = 0.96;
		ao = 0.7 + blades * 0.3;
	} else if (id == 8) { // terra
		float n = fbm(uv, 4.0, 6);
		vec3 v = voronoi(uv, 22.0);
		float peb = smoothstep(0.32, 0.18, v.x) * step(0.55, v.z);
		vec3 d = mix(vec3(0.22, 0.16, 0.11), vec3(0.36, 0.27, 0.18), n);
		d = mix(d, vec3(0.42, 0.38, 0.33) * (0.8 + v.z * 0.3), peb);
		alb = d;
		h = n * 0.5 + peb * 0.5;
		rough = 0.95 - peb * 0.1;
		ao = 0.8 + peb * 0.2;
	} else if (id == 9) { // rocha
		float n = fbm(uv, 3.0, 7);
		float ridge = 1.0 - abs(fbm(uv + 3.0, 4.0, 5) * 2.0 - 1.0);
		vec3 v = voronoi(uv + n * 0.2, 5.0);
		float crack = 1.0 - smoothstep(0.0, 0.04, v.y);
		float lichen = smoothstep(0.66, 0.72, fbm(uv + 9.0, 8.0, 4));
		vec3 rc = mix(vec3(0.3, 0.29, 0.27), vec3(0.47, 0.45, 0.41), n);
		rc = mix(rc, vec3(0.45, 0.46, 0.3), lichen * 0.6);
		alb = rc * (1.0 - crack * 0.5);
		h = n * 0.5 + ridge * 0.4 - crack * 0.4;
		rough = 0.86;
		ao = 1.0 - crack * 0.6;
	} else if (id == 10) { // piso cerâmico
		float t = 3.0;
		vec2 f = fract(uv * t);
		vec2 tid = mod(floor(uv * t), vec2(t));
		float grout = smoothstep(0.0, 0.025, min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y)));
		float r = hash21(tid);
		float n = fbm(uv, 6.0, 4);
		vec3 tc = mix(vec3(0.62, 0.58, 0.52), vec3(0.72, 0.68, 0.6), r) * (0.92 + n * 0.12);
		alb = mix(vec3(0.3, 0.29, 0.27), tc, grout);
		h = grout * 0.8 + n * 0.1;
		rough = mix(0.85, 0.28 + n * 0.1, grout);
		ao = 0.6 + grout * 0.4;
	} else if (id == 11) { // painéis de fachada (concreto pré-moldado)
		vec2 f = fract(uv * 2.0);
		float seam = smoothstep(0.0, 0.01, min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y)));
		float n = fbm(uv, 4.0, 5);
		float streak = fbm2(uv, vec2(12.0, 1.0), 4);
		float g = 0.58 + n * 0.1 - streak * 0.06;
		alb = vec3(g, g * 0.99, g * 0.96) * (0.55 + seam * 0.45);
		h = 0.5 + n * 0.2 + seam * 0.3 - (1.0 - seam) * 0.3;
		rough = 0.78;
		ao = 0.6 + seam * 0.4;
	} else if (id == 12) { // cascalho
		vec3 v = voronoi(uv, 18.0);
		vec3 v2 = voronoi(uv + 0.37, 31.0);
		float s1 = smoothstep(0.45, 0.2, v.x);
		float s2 = smoothstep(0.4, 0.15, v2.x);
		vec3 c = mix(vec3(0.3, 0.28, 0.25), vec3(0.52, 0.49, 0.44), v.z);
		c = mix(c, vec3(0.4, 0.36, 0.3) * (0.8 + v2.z * 0.4), s2 * (1.0 - s1));
		alb = c * (0.6 + max(s1, s2) * 0.4);
		h = max(s1, s2 * 0.8);
		rough = 0.93;
		ao = 0.6 + max(s1, s2) * 0.4;
	} else if (id == 13) { // casca de árvore
		float fib = fbm2(uv, vec2(14.0, 2.0), 5);
		float ridges = smoothstep(0.35, 0.65, fib);
		vec3 bc = mix(vec3(0.14, 0.1, 0.07), vec3(0.3, 0.24, 0.18), ridges);
		float moss = smoothstep(0.6, 0.72, fbm(uv, 4.0, 4));
		bc = mix(bc, vec3(0.2, 0.25, 0.1), moss * 0.5);
		alb = bc;
		h = ridges;
		rough = 0.92;
		ao = 0.5 + ridges * 0.5;
	} else if (id == 14) { // tecido (estofado)
		float wx = 0.5 + 0.5 * sin(uv.x * 160.0 * PI);
		float wy = 0.5 + 0.5 * sin(uv.y * 160.0 * PI);
		float weave = mix(wx, wy, step(0.5, fract((floor(uv.x * 160.0) + floor(uv.y * 160.0)) * 0.5)));
		float n = fbm(uv, 4.0, 4);
		alb = vec3(0.78 + weave * 0.1) * (0.9 + n * 0.15);
		h = weave * 0.6 + n * 0.2;
		rough = 0.95;
		ao = 0.8 + weave * 0.2;
	} else { // 15: linóleo hospitalar
		float n = fbm(uv, 3.0, 5);
		float spk = smoothstep(0.8, 0.95, vnoise(uv, vec2(200.0)));
		float scuff = smoothstep(0.6, 0.8, fbm2(uv, vec2(3.0, 18.0), 4));
		vec3 c = vec3(0.56, 0.6, 0.57) * (0.93 + n * 0.1);
		c = mix(c, vec3(0.3, 0.32, 0.3), spk * 0.5);
		c *= 1.0 - scuff * 0.12;
		alb = c;
		h = 0.5 + n * 0.1;
		rough = 0.32 + scuff * 0.3;
		ao = 1.0;
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
