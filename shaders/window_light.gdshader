// "Luz de janela" vista de dentro dos interiores: painel emissivo cuja cor
// segue a luz do dia (e relâmpagos). Barato: 1 quad por janela, sem luzes reais.
shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

uniform vec3 day_color : source_color = vec3(0.85, 0.9, 1.0);
uniform vec3 night_color : source_color = vec3(0.05, 0.07, 0.12);
uniform float flash = 0.0;

global uniform float daylight;
global uniform float world_decay;

void fragment() {
	vec2 uv = UV;
	float frame = step(0.06, uv.x) * step(uv.x, 0.94) * step(0.05, uv.y) * step(uv.y, 0.95);
	float mullion = 1.0 - step(abs(uv.x - 0.5), 0.02) * frame;
	float dirt = 0.75 + 0.25 * fract(sin(dot(floor(uv * 6.0), vec2(12.9, 78.2))) * 43758.5);
	vec3 c = mix(night_color, day_color, daylight) * dirt * (1.0 - world_decay * 0.25);
	c += vec3(0.8, 0.85, 1.0) * flash;
	ALBEDO = mix(vec3(0.05), c, frame * mullion) * 1.2;
}
