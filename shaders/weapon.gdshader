// Armas e ferramentas: atlas de materiais "de verdade" (nogueira, aço escovado,
// polímero, borracha/couro). UV em metros; UV2.x = camada 0..3; COLOR = tinta
// (a tinta sobre o aço vira latão, alumínio, aço oxidado, pintura…).
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform sampler2DArray weapon_a : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2DArray weapon_b : filter_linear_mipmap_anisotropic, repeat_enable;
uniform float blood = 0.0;
uniform float fill = 0.0;   // itens soltos: mesma luz indireta dos interiores
global uniform float daylight;

varying flat float v_layer;
varying vec4 v_tint;
varying vec3 l_pos;

void vertex() {
	v_layer = clamp(floor(UV2.x + 0.01), 0.0, 3.0);
	v_tint = COLOR;
	l_pos = VERTEX;
}

void fragment() {
	int li = int(v_layer);
	float sc = li == 0 ? 3.0 : (li == 1 ? 2.2 : (li == 2 ? 4.0 : 5.0));
	vec3 uvw = vec3(UV * sc, v_layer);
	vec4 a = texture(weapon_a, uvw);
	vec4 b = texture(weapon_b, uvw);
	vec3 alb = a.rgb * v_tint.rgb;
	float metal = b.a * step(0.5, v_tint.a);   // alfa da tinta < 0,5 = pintado (sem metal)
	float rough = a.a;
	vec2 nxy = b.rg * 2.0 - 1.0;
	ALBEDO = alb;
	METALLIC = metal;
	ROUGHNESS = rough;
	NORMAL_MAP = vec3(nxy, sqrt(max(0.0, 1.0 - dot(nxy, nxy)))) * 0.5 + 0.5;
	AO = b.b;
	SPECULAR = 0.5;
	EMISSION = alb * vec3(1.0, 0.9, 0.76) * fill * (0.2 + daylight * 0.8);
}
