#!/usr/bin/env python3
"""Baixa texturas CC0 do Poly Haven (https://polyhaven.com, licença CC0) e
empacota no formato das camadas do jogo:

  <NN>_a.png  RGB = cor (sRGB)      A = rugosidade
  <NN>_b.png  RG  = normal (OpenGL) B = oclusão (AO)   A = metal

Também grava assets/materials/escala.json com a escala real de cada foto
(repetições por metro), lida das dimensões informadas pelo Poly Haven.

Uso: python3 tools/fetch_textures.py [tamanho=2048]
     godot --headless --path . -s tools/pack_layers.gd
"""
import io
import json
import os
import sys
import urllib.request

from PIL import Image

# camada do jogo -> id no Poly Haven (ver LAYER_NAMES em asset_library.gd)
LAYERS = {
    0: "asphalt_02",              # asfalto rachado
    1: "concrete_pavement",       # concreto em placas (calçada, meio-fio, bases)
    2: "red_bricks_04",           # tijolo à vista vermelho, gasto
    3: "painted_plaster_wall",    # reboco pintado (neutro: recebe a cor do prédio)
    4: "clay_roof_tiles",         # telha de barro
    5: "rusty_metal_sheet",       # chapa metálica com ferrugem
    6: "brown_planks_03",         # tábuas
    7: "leafy_grass",             # grama (gramados e campos)
    8: "forest_ground_04",        # terra com pedriscos
    9: "rock_face_03",            # rocha (encostas, paredões)
    10: "grey_tiles",             # piso cerâmico
    11: "concrete_wall_008",      # painel de concreto (fachadas de escritório/hospital)
    12: "gravel_floor_02",        # cascalho
    13: "bark_willow_02",         # casca de árvore
    14: "cotton_jersey",          # tecido neutro (estofados, colchões, cortinas)
    15: "linoleum_brown",         # linóleo
}

# tecidos das roupas dos personagens (camadas 1..3 do atlas de detalhe; a 0 é a
# pele, procedural). Saem em tons de cinza: a cor vem da roupa (cor por vértice).
CHAR = {
    1: "jogging_melange",         # malha (camisetas, moletons)
    2: "denim_fabric_04",         # brim (calças)
    3: "brown_leather",           # couro (jaquetas, botas, cintos)
}

# ajuste de cor por camada: (brilho, saturação). As fotos vêm com a exposição
# do estúdio; o asfalto precisa ser escuro (faixas contrastam) e a calçada cinza.
ADJUST = {
    0: (0.6, 0.5),
    1: (1.02, 0.3),
}

API = "https://api.polyhaven.com"
# originais em PNG (a pasta tem .gdignore: o Godot não importa nem exporta);
# tools/pack_layers.gd converte para .res comprimido (BC7 + mipmaps) em assets/materials
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "materials", "src")
CACHE = os.environ.get("PH_CACHE", "/tmp/ph_cache")


def get(url: str) -> bytes:
    os.makedirs(CACHE, exist_ok=True)
    fn = os.path.join(CACHE, url.replace("/", "_").replace(":", ""))
    if os.path.exists(fn):
        return open(fn, "rb").read()
    req = urllib.request.Request(url, headers={"User-Agent": "o-inicio-do-fim-texture-fetch"})
    with urllib.request.urlopen(req, timeout=60) as r:
        data = r.read()
    open(fn, "wb").write(data)
    return data


def img(files: dict, key: str, res: str):
    if key not in files:
        return None
    entry = files[key].get(res) or files[key].get("1k")
    f = entry.get("jpg") or entry.get("png")
    return Image.open(io.BytesIO(get(f["url"])))


def main() -> None:
    size = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].isdigit() else 2048
    res = "2k" if size > 1024 else "1k"
    os.makedirs(OUT, exist_ok=True)
    scales = {}
    for layer, pid in LAYERS.items():
        info = json.loads(get(f"{API}/info/{pid}"))
        files = json.loads(get(f"{API}/files/{pid}"))
        dims = info.get("dimensions", [2000, 2000])  # mm
        scales[layer] = round(1000.0 / max(float(dims[0]), 1.0), 4)
        diff = img(files, "Diffuse", res).convert("RGB").resize((size, size), Image.LANCZOS)
        nor = img(files, "nor_gl", res).convert("RGB").resize((size, size), Image.LANCZOS)
        rough = img(files, "Rough", res)
        ao = img(files, "AO", res)
        arm = img(files, "arm", res)
        if arm is not None:
            arm = arm.convert("RGB").resize((size, size), Image.LANCZOS)
        if rough is None and arm is not None:
            rough = arm.getchannel("G")
        rough = rough.convert("L").resize((size, size), Image.LANCZOS)
        if ao is None:
            ao = arm.getchannel("R") if arm is not None else Image.new("L", (size, size), 255)
        ao = ao.convert("L").resize((size, size), Image.LANCZOS)
        metal = arm.getchannel("B") if arm is not None else Image.new("L", (size, size), 0)
        if layer in ADJUST:
            from PIL import ImageEnhance
            br, sat = ADJUST[layer]
            diff = ImageEnhance.Color(diff).enhance(sat)
            diff = ImageEnhance.Brightness(diff).enhance(br)
        a = Image.merge("RGBA", (*diff.split(), rough))
        nr, ng, _nb = nor.split()
        b = Image.merge("RGBA", (nr, ng, ao, metal))
        a.save(os.path.join(OUT, "%02d_a.png" % layer), optimize=True)
        b.save(os.path.join(OUT, "%02d_b.png" % layer), optimize=True)
        print("camada %2d  %-26s %s mm  escala %.3f/m" % (layer, pid, dims, scales[layer]))
    char_scales = {}
    for q, pid in CHAR.items():
        info = json.loads(get(f"{API}/info/{pid}"))
        files = json.loads(get(f"{API}/files/{pid}"))
        dims = info.get("dimensions", [500, 500])
        char_scales[q] = round(1000.0 / max(float(dims[0]), 1.0), 4)
        cs = 1024
        diff = img(files, "Diffuse", "1k").convert("RGB").resize((cs, cs), Image.LANCZOS)
        nor = img(files, "nor_gl", "1k").convert("RGB").resize((cs, cs), Image.LANCZOS)
        arm = img(files, "arm", "1k")
        rough = img(files, "Rough", "1k")
        if rough is None:
            rough = arm.convert("RGB").getchannel("G")
        rough = rough.convert("L").resize((cs, cs), Image.LANCZOS)
        ao = img(files, "AO", "1k")
        if ao is None:
            ao = arm.convert("RGB").getchannel("R") if arm is not None else Image.new("L", (cs, cs), 255)
        ao = ao.convert("L").resize((cs, cs), Image.LANCZOS)
        # detalhe neutro: luminância normalizada para média ~0,85 (o shader multiplica
        # pela cor da roupa)
        lum = diff.convert("L")
        mean = max(1.0, sum(i * c for i, c in enumerate(lum.histogram())) / (cs * cs))
        g = lum.point(lambda v: max(0, min(255, int(v / mean * 0.85 * 255))))
        a = Image.merge("RGBA", (g, g, g, rough))
        nr, ng, _nb = nor.split()
        b = Image.merge("RGBA", (nr, ng, ao, Image.new("L", (cs, cs), 0)))
        a.save(os.path.join(OUT, "char_%d_a.png" % q), optimize=True)
        b.save(os.path.join(OUT, "char_%d_b.png" % q), optimize=True)
        print("roupa %d  %-24s %s mm  escala %.3f/m" % (q, pid, dims, char_scales[q]))
    with open(os.path.join(OUT, "..", "escala.json"), "w") as f:
        json.dump({"fonte": "Poly Haven (CC0)", "ids": {str(k): v for k, v in LAYERS.items()},
            "escala": {str(k): v for k, v in scales.items()},
            "roupas": {str(k): v for k, v in CHAR.items()},
            "escala_roupas": {str(k): v for k, v in char_scales.items()}}, f, indent=1)


if __name__ == "__main__":
    main()
