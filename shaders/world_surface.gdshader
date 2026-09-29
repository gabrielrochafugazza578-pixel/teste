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

global uniform float wetness;
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
varying float v_seed;
varying vec4 v_tint;

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
	// Em MultiMesh com use_colors, COLOR já vem multiplicado pela cor da instância.
	v_tint = COLOR;
	if (use_instance_tint) {
		v_seed = fract(v_seed + dot(MODEL_MATRIX[3].xz, vec2(0.137, 0.291)));
	}
}

void fragment() {
	int li = int(v_layer);
	float sc = layer_scales[li];
	vec3 uvw = vec3(UV * sc, v_layer);
	vec4 a = texture(tex_a, uvw);
	vec4 b = texture(tex_b, uvw);

	// Projeção dominante para ruídos em espaço de mundo (1 amostra, barato)
	vec3 an = abs(w_nrm);
	vec2 np = an.y > 0.7 ? w_pos.xz : (an.x > an.z ? w_pos.zy : w_pos.xy);
	vec4 nz = texture(noise_tex, np * 0.045);

	vec3 base_rgb = a.rgb;
	// anti-repetição nas camadas orgânicas (asfalto, reboco, grama, terra, rocha,
	// cascalho, casca): 2ª amostra girada em outra escala, misturada por ruído de mundo
	if (li == 0 || li == 3 || li == 7 || li == 8 || li == 9 || li == 12 || li == 13) {
		vec2 ruv = mat2(vec2(0.8, -0.6), vec2(0.6, 0.8)) * (UV * sc * 0.41) + vec2(0.37, 0.71);
		vec3 a2 = texture(tex_a, vec3(ruv, v_layer)).rgb;
		base_rgb = mix(base_rgb, a2, smoothstep(0.3, 0.7, nz.g) * 0.5);
	}
	// variação de tom em grande escala (manchas, sol, sujeira acumulada)
	base_rgb *= 0.9 + nz.r * 0.2;
	vec3 alb = base_rgb * v_tint.rgb;
	float rough = a.a;
	float metal = b.a;
	float ao = b.b * v_tint.a;
	vec2 nxy = (b.rg * 2.0 - 1.0) * normal_strength;
	vec3 nmap = vec3(nxy, sqrt(max(0.0, 1.0 - dot(nxy, nxy))));
	vec3 emit = vec3(0.0);

	// --- Deterioração: fuligem, escorridos, musgo -------------------------------
	float decay = world_decay * grime;
	if (decay > 0.01) {
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

	// --- Sinalização horizontal (ruas: modo 4 rua, 5 avenida, 6 rodovia) --------
	// UV.x = distância do eixo da via (m), UV.y = distância ao longo da via.
	if (v_wmode > 3.5) {
		float ax = abs(UV.x);
		float dash = step(fract(UV.y / 6.0), 0.5);
		float m = 0.0;
		vec3 mc = vec3(0.78, 0.62, 0.16);
		if (v_wmode < 4.5) {
			m = step(ax, 0.07) * dash;
		} else if (v_wmode < 5.5) {
			m = step(abs(ax - 0.12), 0.05);
			float lane = step(abs(ax - 3.4), 0.06) * step(fract(UV.y / 9.0), 0.4);
			if (lane > 0.5) { m = 1.0; mc = vec3(0.8); }
		} else {
			m = step(ax, 0.07) * dash;
			float edge = step(abs(ax - 4.55), 0.07);
			if (edge > 0.5) { m = 1.0; mc = vec3(0.8); }
		}
		float wear = smoothstep(0.2, 0.55, nz.g + 0.35 - world_decay * 0.3);
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
		float inx = step(wmin.x, f.x) * step(f.x, wmax.x);
		float iny = step(wmin.y, f.y) * step(f.y, wmax.y);
		float frame_x = step(wmin.x - 0.04, f.x) * step(f.x, wmax.x + 0.04);
		float frame_y = step(wmin.y - 0.05, f.y) * step(f.y, wmax.y + 0.03);
		float rnd = h21(cell + v_seed * 131.0);
		float rnd2 = h21(cell.yx + v_seed * 71.0 + 3.0);
		if (inx * iny > 0.5) {
			is_window = 1.0;
			// vidro escuro com reflexo falso do céu (fresnel) + cortinas variadas
			vec3 interior = mix(vec3(0.012, 0.014, 0.018), vec3(0.05, 0.045, 0.04), rnd2) * (0.6 + 0.4 * f.y);
			float curtain = step(0.62, rnd) * step(0.45 + rnd2 * 0.3, f.y) * step(0.5, fract(rnd * 7.0 + (f.x > 0.5 ? 0.5 : 0.0)));
			interior = mix(interior, vec3(0.28, 0.25, 0.21) * (0.6 + rnd2 * 0.6), curtain * 0.8);
			float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
			vec3 refl = mix(vec3(0.16, 0.18, 0.2), vec3(0.42, 0.47, 0.53), f.y) * (0.2 + daylight * 0.8);
			vec3 glass_col = mix(interior, refl, 0.25 + fres * 0.55);
			float broken = step(1.0 - world_decay * 0.2, rnd2) * (exterior ? 1.0 : 0.0);
			alb = mix(glass_col, vec3(0.008), broken);
			// rugosidade moderada: reflexo do céu desfocado evita cintilação (aliasing) nas janelas
			rough = mix(0.24, 0.95, broken);
			metal = 0.0;
			ao = 1.0;
			nmap = vec3(0.0, 0.0, 1.0);
			// caixilho central nas janelas largas
			if (v_wmode > 1.5 && abs(f.x - (wmin.x + wmax.x) * 0.5) < 0.012) {
				alb = vec3(0.12);
				rough = 0.5;
			}
			// luz acesa (energia + apagão progressivo em onda)
			float powered = city_power * step(blackout_radius, distance(w_pos.xz, blackout_origin.xz) + rnd * 25.0);
			float occupancy = shop ? 0.85 : (0.25 + 0.45 * (1.0 - daylight));
			float lit = step(rnd, occupancy) * powered * (1.0 - broken);
			vec3 warm = mix(vec3(1.0, 0.72, 0.42), vec3(0.75, 0.85, 1.0), step(0.7, rnd2));
			emit = warm * lit * (0.55 + rnd * 0.9) * (shop ? 1.6 : 1.0) * mix(0.35, 1.0, 1.0 - daylight) * emission_boost;
		} else if (frame_x * frame_y > 0.5) {
			// moldura / peitoril
			alb *= 0.62;
			rough = 0.6;
			nmap = vec3(0.0, 0.0, 1.0);
		}
	}

	// --- Umidade, poças e ondulações de chuva -------------------------------------
	if (exterior && wetness > 0.01) {
		float porous = clamp(rough, 0.0, 1.0);
		float exposure = mix(0.45, 1.0, clamp(w_nrm.y, 0.0, 1.0));
		float wet = wetness * exposure * (1.0 - is_window);
		alb *= mix(1.0, 0.55, wet * porous);
		rough = mix(rough, 0.18, wet * 0.85);
		if (enable_puddles && w_nrm.y > 0.92) {
			float pn = texture(noise_tex, w_pos.xz * 0.028).r * 0.7 + nz.b * 0.3;
			float th = 0.8 - wetness * 0.12;
			float puddle = smoothstep(th, th + 0.04, pn) * smoothstep(0.2, 0.6, wetness);
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
	ALBEDO = alb;
	ROUGHNESS = clamp(rough, 0.02, 1.0);
	METALLIC = metal;
	SPECULAR = 0.5 + is_window * 0.15;
	NORMAL_MAP = nmap * 0.5 + 0.5;
	AO = ao;
	AO_LIGHT_AFFECT = 0.35;
	EMISSION = emit;
}
