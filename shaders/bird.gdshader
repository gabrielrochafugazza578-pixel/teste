// Urubu planando: silhueta escura, asas em "V" (diedro) e de vez em quando uma
// rajada de batidas. COLOR.r = distância da raiz até a ponta da asa (0..1).
shader_type spatial;
render_mode cull_disabled, diffuse_lambert_wrap, specular_disabled;

uniform float seed = 0.0;

void vertex() {
	float w = COLOR.r;
	// rajadas curtas de batidas, separadas por planeios longos
	float burst = smoothstep(0.75, 0.95, sin(TIME * 0.31 + seed * 6.2831));
	float flap = sin(TIME * 7.5 + seed * 19.0) * burst;
	VERTEX.y += w * (0.13 + flap * 0.42);
	// as penas da ponta (primárias) se abrem quando a asa sobe
	VERTEX.x *= 1.0 - w * max(flap, 0.0) * 0.08;
}

void fragment() {
	// dorso preto; ponta das asas um pouco mais clara (rêmiges prateadas)
	vec3 c = mix(vec3(0.045, 0.04, 0.04), vec3(0.16, 0.15, 0.14), smoothstep(0.55, 1.0, COLOR.r));
	ALBEDO = c;
	ROUGHNESS = 0.85;
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}
