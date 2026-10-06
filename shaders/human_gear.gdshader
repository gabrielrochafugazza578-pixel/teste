// Equipamento gerado (mochila, saco de dormir, alças): lona de nylon/algodão com
// trama procedural, costuras escurecidas e o mesmo desgaste das roupas.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

#include "res://shaders/human_common.gdshaderinc"

uniform vec3 color : source_color = vec3(0.36, 0.32, 0.23);
uniform float weave = 160.0;

void fragment() {
	vec2 w = UV * weave;
	float wx = sin(w.x * 6.2832) * 0.5 + 0.5;
	float wy = sin(w.y * 6.2832) * 0.5 + 0.5;
	float fw = clamp(1.0 - fwidth(w.x) * 0.8, 0.0, 1.0);
	vec4 dt = texture(detail_tex, UV * 3.0);
	vec3 c = color * (0.86 + (wx * wy - 0.25) * 0.25 * fw) * (0.85 + dt.g * 0.3);
	float rough = 0.78;
	human_stains(c, rough, COLOR, UV, 2.0);
	human_wet(c, rough, 0.8);
	ALBEDO = c;
	ROUGHNESS = rough;
	NORMAL_MAP = vec3(0.5 + (wx - 0.5) * 0.18 * fw, 0.5 + (wy - 0.5) * 0.18 * fw, 1.0);
	RIM = 0.15;
}
