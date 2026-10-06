// Roupas rasgadas (infectados): igual a human_cloth.gdshader, mas sem descartar
// as faces de trás, para o avesso aparecer pelos rasgos.
// Roupas e calçados dos personagens fotorrealistas: textura em foto da peça
// (MakeHuman CC0/CC-BY) com mapa normal e AO. A cor varia por pessoa (tint_*),
// e o uso aparece por máscara: sujeira nas barras e joelhos, sangue, rasgos.
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

#define TORN
#include "res://shaders/human_cloth.gdshaderinc"
