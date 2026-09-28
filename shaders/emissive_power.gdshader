// Emissor ligado à rede elétrica da cidade (postes, semáforos, letreiros).
// Apaga com city_power e com a onda de apagão (blackout_origin/radius).
// mode 0: poste (só à noite), 1: semáforo (ciclo de cores), 2: sempre aceso
shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec3 color : source_color = vec3(1.0, 0.82, 0.55);
uniform float energy = 2.5;
uniform int mode = 0;

global uniform float city_power;
global uniform float daylight;
global uniform vec3 blackout_origin;
global uniform float blackout_radius;

varying vec3 w_pos;
varying float v_seed;

void vertex() {
	w_pos = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	v_seed = fract(sin(dot(w_pos.xz, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float powered = city_power * step(blackout_radius, distance(w_pos.xz, blackout_origin.xz) + v_seed * 20.0);
	vec3 c = color;
	float on = powered;
	if (mode == 0) {
		on *= smoothstep(0.55, 0.2, daylight);
	} else if (mode == 1) {
		float t = fract(TIME / 12.0 + v_seed);
		c = t < 0.45 ? vec3(0.1, 1.0, 0.3) : (t < 0.55 ? vec3(1.0, 0.8, 0.1) : vec3(1.0, 0.1, 0.05));
	}
	ALBEDO = mix(vec3(0.08), c * energy, on);
}
