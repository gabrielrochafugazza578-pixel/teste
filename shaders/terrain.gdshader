// Terreno: mistura grama / terra / rocha / cascalho por splat (COLOR) + inclinação.
// Variação macro por ruído quebra a repetição de tiles vista de longe.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2DArray tex_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2DArray tex_b : filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D noise_tex : filter_linear_mipmap, repeat_enable;
uniform float grass_scale = 0.45;
uniform float dirt_scale = 0.5;
uniform float rock_scale = 0.22;
uniform float gravel_scale = 0.8;
// a foto de grama (Poly Haven) é o chão entre as folhas, amarronzado: mantém o
// detalhe (luminância, relevo, rugosidade) e leva a cor para verde de gramado
uniform vec3 grass_green : source_color = vec3(0.24, 0.31, 0.11);
uniform float grass_tint = 0.85;
// canal A de tex_b = relevo (fotos do Poly Haven): transições por altura
uniform bool has_height = false;
// foto aérea de campo (Poly Haven, aerial_grass_rock), normalizada em torno de
// 0,5: manchas de dezenas de metros (capim seco, verde, terra) em vez de ruído
uniform sampler2D macro_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform bool has_macro = false;

global uniform float wetness;
global uniform float world_decay;
global uniform float rain_intensity;
global uniform vec3 sun_dir;
global uniform float sun_strength;
uniform float parallax_distance = 22.0;

varying vec3 w_pos;
varying vec3 w_nrm;
varying vec4 splat;

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	w_nrm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	splat = COLOR;
}

// relevo 0..1 misturado pelos pesos (grama, terra, rocha, cascalho)
float t_height(vec2 p, vec4 w, vec2 gx, vec2 gy) {
	float h = 0.0;
	float tw = 0.0;
	if (w.x > 0.01) {
		h += textureGrad(tex_b, vec3(p * grass_scale, 7.0), gx * grass_scale, gy * grass_scale).a * 0.6 * w.x;
		tw += w.x;
	}
	if (w.y > 0.01) {
		h += textureGrad(tex_b, vec3(p * dirt_scale, 8.0), gx * dirt_scale, gy * dirt_scale).a * w.y;
		tw += w.y;
	}
	if (w.z > 0.01) {
		h += textureGrad(tex_b, vec3(p * rock_scale, 9.0), gx * rock_scale, gy * rock_scale).a * w.z;
		tw += w.z;
	}
	if (w.w > 0.01) {
		h += textureGrad(tex_b, vec3(p * gravel_scale, 12.0), gx * gravel_scale, gy * gravel_scale).a * w.w;
		tw += w.w;
	}
	return h / max(tw, 1e-3);
}

void fragment() {
	vec2 uv = w_pos.xz;
	vec4 macro = texture(noise_tex, uv * 0.0035);
	vec4 meso = texture(noise_tex, uv * 0.021);
	float slope = 1.0 - clamp(w_nrm.y, 0.0, 1.0);
	float w_rock = clamp(splat.g + smoothstep(0.28, 0.5, slope), 0.0, 1.0);
	float w_dirt = clamp(splat.r + smoothstep(0.55, 0.75, meso.r) * 0.5 * (1.0 - world_decay * 0.4), 0.0, 1.0) * (1.0 - w_rock);
	float w_grav = clamp(splat.b, 0.0, 1.0) * (1.0 - w_rock);
	float w_grass = clamp(1.0 - w_rock - w_dirt - w_grav, 0.0, 1.0);

	// derivadas antes de qualquer desvio (o parallax mexe na UV dentro de um if)
	vec2 gx = dFdx(uv);
	vec2 gy = dFdy(uv);
	vec4 wv = vec4(w_grass, w_dirt, w_rock, w_grav);
	float pshadow = 0.0;
#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
	// --- Relevo de verdade perto da câmera: torrões, pedras e cascalho com
	// profundidade (parallax pelo relevo misturado das fotos) e sombra própria
	// do sol entre as pedras. A projeção é de cima: a profundidade é o eixo Y.
	float cam_d = length(CAMERA_POSITION_WORLD - w_pos);
	float pfade = has_height ? 1.0 - smoothstep(parallax_distance * 0.55, parallax_distance, cam_d) : 0.0;
	// profundidade (m) de cada foto: grama, terra, rocha, cascalho
	float pdepth = dot(wv, vec4(0.015, 0.035, 0.09, 0.035)) / max(dot(wv, vec4(1.0)), 1e-3);
	if (pfade > 0.0) {
		vec3 V = (CAMERA_POSITION_WORLD - w_pos) / max(cam_d, 1e-4);
		float vz = max(V.y, 0.0);
		float steps = floor(mix(24.0, 6.0, vz) * mix(0.5, 1.0, pfade));
		vec2 delta = -V.xz / max(vz, 0.3) * pdepth * pfade / steps;
		float st = 1.0 / steps;
		vec2 ofs = uv;
		float cur = 0.0;
		float hd = 1.0 - t_height(ofs, wv, gx, gy);
		vec2 prev = ofs;
		float prev_hd = hd;
		float prev_cur = 0.0;
		for (int i = 0; i < 24; i++) {
			if (float(i) >= steps || cur >= hd) {
				break;
			}
			prev = ofs;
			prev_hd = hd;
			prev_cur = cur;
			ofs += delta;
			cur += st;
			hd = 1.0 - t_height(ofs, wv, gx, gy);
		}
		float after = hd - cur;
		float before = prev_hd - prev_cur;
		uv = mix(ofs, prev, clamp(after / min(after - before, -1e-5), 0.0, 1.0));
		if (sun_strength > 0.01 && sun_dir.y > 0.03) {
			float hh = 1.0 - t_height(uv, wv, gx, gy);
			vec2 ldir = sun_dir.xz / max(sun_dir.y, 0.12) * pdepth;
			float sh = 0.0;
			for (int i = 1; i <= 8; i++) {
				float f = float(i) / 8.0;
				float sd = 1.0 - t_height(uv + ldir * hh * f, wv, gx, gy);
				sh = max(sh, (hh * (1.0 - f) - sd) * (1.0 - f * 0.6) * 7.0);
			}
			pshadow = clamp(sh, 0.0, 1.0) * pfade * smoothstep(0.03, 0.2, sun_dir.y);
		}
	}
#endif
	vec4 ga = textureGrad(tex_a, vec3(uv * grass_scale, 7.0), gx * grass_scale, gy * grass_scale);
	float glum = dot(ga.rgb, vec3(0.299, 0.587, 0.114));
	// média da própria foto (último mipmap): o detalhe fica em torno de 1 em
	// qualquer renderizador/formato
	float gavg = dot(textureLod(tex_a, vec3(0.5, 0.5, 7.0), 11.0).rgb, vec3(0.299, 0.587, 0.114));
	ga.rgb = mix(ga.rgb, grass_green * (glum / max(gavg, 0.01)), grass_tint);
	vec4 gb = textureGrad(tex_b, vec3(uv * grass_scale, 7.0), gx * grass_scale, gy * grass_scale);
	vec4 da = textureGrad(tex_a, vec3(uv * dirt_scale, 8.0), gx * dirt_scale, gy * dirt_scale);
	vec4 db = textureGrad(tex_b, vec3(uv * dirt_scale, 8.0), gx * dirt_scale, gy * dirt_scale);
	vec4 ra = textureGrad(tex_a, vec3(uv * rock_scale, 9.0), gx * rock_scale, gy * rock_scale);
	vec4 rb = textureGrad(tex_b, vec3(uv * rock_scale, 9.0), gx * rock_scale, gy * rock_scale);
	vec4 ca = ga;
	vec4 cb = gb;
	if (w_grav > 0.01) {
		ca = textureGrad(tex_a, vec3(uv * gravel_scale, 12.0), gx * gravel_scale, gy * gravel_scale);
		cb = textureGrad(tex_b, vec3(uv * gravel_scale, 12.0), gx * gravel_scale, gy * gravel_scale);
	}
	// mistura por altura: na transição as pedras e torrões mais altos aparecem por
	// cima e a terra/grama preenche os vãos (em vez de uma foto "transparente"
	// sobre a outra); a altura de cada foto entra em pé de igualdade com o peso
	float crev = 0.0;
	if (has_height) {
		float hg = gb.a * 0.6;
		float hd = db.a;
		float hr = rb.a;
		float hc = cb.a;
		float bw = 0.2;
		// só camadas presentes disputam o topo (uma de peso ~0 com relevo alto
		// zeraria todas as outras: pixel preto)
		float eg = step(0.002, w_grass) * (w_grass + hg + 1.0);
		float ed = step(0.002, w_dirt) * (w_dirt + hd + 1.0);
		float er = step(0.002, w_rock) * (w_rock + hr + 1.0);
		float ec = step(0.002, w_grav) * (w_grav + hc + 1.0);
		float top = max(max(eg, ed), max(er, ec)) - bw;
		w_grass = max(eg - top, 0.0);
		w_dirt = max(ed - top, 0.0);
		w_rock = max(er - top, 0.0);
		w_grav = max(ec - top, 0.0);
	}
	float tot = w_grass + w_dirt + w_rock + w_grav + 0.0001;
	vec4 A = (ga * w_grass + da * w_dirt + ra * w_rock + ca * w_grav) / tot;
	vec4 B = (gb * w_grass + db * w_dirt + rb * w_rock + cb * w_grav) / tot;
	if (has_height) {
		float hmix = (gb.a * w_grass + db.a * w_dirt + rb.a * w_rock + cb.a * w_grav) / tot;
		crev = smoothstep(0.4, 0.05, hmix);
	}
	w_grass /= tot;
	w_dirt /= tot;
	w_rock /= tot;
	w_grav /= tot;
	tot = 1.0;

	vec3 alb = A.rgb;
	// variação macro de cor (manchas secas / úmidas)
	alb *= 0.76 + macro.r * 0.48;
	if (has_macro) {
		// duas amostras em escalas e ângulos diferentes: a foto não se repete
		vec3 m1 = texture(macro_tex, uv / 34.0).rgb * 2.0;
		vec3 m2 = texture(macro_tex, mat2(vec2(0.6, 0.8), vec2(-0.8, 0.6)) * uv / 97.0 + 0.37).rgb * 2.0;
		vec3 mac = sqrt(m1 * m2);
		alb *= mix(vec3(1.0), mac, (w_grass * 0.85 + w_dirt * 0.5 + w_grav * 0.3));
	}
	alb = mix(alb, alb * vec3(1.12, 1.02, 0.78), smoothstep(0.55, 0.8, macro.g) * w_grass * 0.6);
	// pasto de verdade não é um tapete: manchas de ~50 m mais secas (palha) e
	// outras mais verdes/úmidas, que quebram o verde uniforme dos campos abertos
	float dryp = smoothstep(0.42, 0.72, meso.g * 0.6 + macro.b * 0.4);
	alb = mix(alb, alb * vec3(1.2, 1.06, 0.68), dryp * w_grass * 0.55);
	float lush = smoothstep(0.55, 0.8, meso.b) * (1.0 - dryp);
	alb = mix(alb, alb * vec3(0.82, 1.0, 0.8), lush * w_grass * 0.45);
	// pós-colapso: vegetação mais alta/escura e descuidada
	alb = mix(alb, alb * vec3(0.85, 1.05, 0.8), world_decay * w_grass * 0.35);
	// chão seco natural é fosco: as fotos de cascalho/terra têm trechos de
	// rugosidade baixa (pedrinhas lisas) que no contraluz viravam um espelho
	float rough = max(A.a, 0.62);
	vec2 nxy = B.rg * 2.0 - 1.0;
	vec3 nmap = vec3(nxy, sqrt(max(0.0, 1.0 - dot(nxy, nxy))));

	if (wetness > 0.01) {
		float wet = wetness * (0.5 + 0.5 * (1.0 - slope));
		alb *= mix(1.0, 0.6, wet);
		rough = mix(rough, 0.35, wet * 0.8);
		float wsum = (w_dirt + w_grav) / tot;
		// a água junta primeiro nas partes baixas do relevo (entre pedras e torrões)
		float puddle = smoothstep(0.66 - wetness * 0.12, 0.7 - wetness * 0.12, meso.b * 0.6 + macro.r * 0.4 + crev * 0.06) * wsum * smoothstep(0.35, 0.7, wetness) * (1.0 - slope);
		puddle = max(puddle, smoothstep(0.72, 1.0, crev) * wsum * smoothstep(0.5, 0.95, wetness) * (1.0 - slope) * 0.4);
		alb = mix(alb, vec3(0.05, 0.045, 0.04), puddle * 0.8);
		rough = mix(rough, 0.03, puddle);
		nmap = normalize(mix(nmap, vec3(0.0, 0.0, 1.0), puddle));
	}

	// sombra própria do relevo tira só a parte do sol
	alb *= 1.0 - pshadow * 0.7 * sun_strength;
	ALBEDO = alb;
	ROUGHNESS = rough;
	METALLIC = 0.0;
	// terra/cascalho seco reflete pouco (sol baixo de frente virava um espelho);
	// molhado volta ao especular normal
	SPECULAR = mix(0.25, 0.5, wetness);
	NORMAL_MAP = nmap * 0.5 + 0.5;
	AO = B.b;
	AO_LIGHT_AFFECT = 0.3;
}
