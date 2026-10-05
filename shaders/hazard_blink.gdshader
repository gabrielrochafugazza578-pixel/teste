// Pisca-alerta de carro abandonado (a bateria ainda aguenta): âmbar piscando
// ~1,4 vez por segundo, cada carro no seu ritmo. Sem luz real (só emissivo).
shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 color : source_color = vec3(1.0, 0.42, 0.03);
uniform float energy = 2.0;

varying flat float v_seed;

void vertex() {
	vec3 o = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	v_seed = fract(sin(dot(o.xz, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float ph = fract(TIME * (1.25 + v_seed * 0.3) + v_seed);
	float on = smoothstep(0.0, 0.06, ph) * (1.0 - smoothstep(0.42, 0.5, ph));
	ALBEDO = mix(color * 0.12, color * energy, on);
}
