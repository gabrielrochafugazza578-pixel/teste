#!/usr/bin/env python3
"""Baixa texturas CC0 do Poly Haven (https://polyhaven.com, licença CC0) e
empacota no formato das camadas do jogo:

  <NN>_a.png  RGB = cor (sRGB)      A = rugosidade
  <NN>_b.png  RG  = normal (OpenGL) B = oclusão (AO)   A = metal

Também grava assets/materials/escala.json com a escala real de cada foto
(repetições por metro), lida das dimensões informadas pelo Poly Haven.

Uso: python3 tools/fetch_textures.py [tamanho=1024]
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
    2: "brick_wall_02",           # tijolo à vista
    3: "painted_plaster_wall",    # reboco pintado
    4: "clay_roof_tiles",         # telha de barro
    5: "rusty_metal_sheet",       # chapa metálica com ferrugem
    6: "brown_planks_03",         # tábuas
    8: "dirt",                    # terra
    9: "rock_ground",             # rocha
    10: "grey_tiles",             # piso cinza
    11: "floor_tiles_02",         # revestimento de pedra clara (fachadas)
    12: "gravel_floor",           # cascalho
    13: "bark_brown_02",          # casca de árvore
    15: "linoleum_brown",         # linóleo
}

# ajuste de cor por camada: (brilho, saturação). As fotos vêm com a exposição
# do estúdio; o asfalto precisa ser escuro (faixas contrastam) e a calçada cinza.
ADJUST = {
    0: (0.6, 0.5),
    1: (1.02, 0.3),
    12: (0.8, 0.2),
}

API = "https://api.polyhaven.com"
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "materials")
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
    size = int(sys.argv[1]) if len(sys.argv) > 1 else 1024
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
    with open(os.path.join(OUT, "escala.json"), "w") as f:
        json.dump({"fonte": "Poly Haven (CC0)", "ids": {str(k): v for k, v in LAYERS.items()},
            "escala": {str(k): v for k, v in scales.items()}}, f, indent=1)


if __name__ == "__main__":
    main()
