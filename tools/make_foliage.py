#!/usr/bin/env python3
"""Monta as texturas de folhagem fotográfica do jogo a partir dos atlas de folhas
dos modelos de plantas do Poly Haven (https://polyhaven.com, licença CC0).

Os modelos escaneados trazem cada folha/tufo como um recorte (cor + alfa). Aqui
cada recorte é separado pelos componentes do alfa e recomposto no formato que o
jogo usa:

  leaves_tree.png   copa de árvore (cartão redondo cheio de folhas)
  leaves_bush.png   arbusto (folhas largas serrilhadas)
  leaves_vine.png   trepadeira (folhas pequenas)
  leaves_pine.png   pinheiro (raminhos tipo agulha, de samambaia)
  frond_palm.png    folha de palmeira (uma fronde comprida, base em v=0)
  grass_tuft.png    moita de grama vista de lado (plano de 0,92 x 0,62 m)

Uso: python3 tools/fetch_textures.py && python3 tools/make_foliage.py
"""
import io
import json
import math
import os
import random
import urllib.request

import numpy as np
from PIL import Image, ImageDraw, ImageEnhance, ImageFilter
from scipy import ndimage

API = "https://api.polyhaven.com"
CACHE = os.environ.get("PH_CACHE", "/tmp/ph_cache")
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "textures", "foliage")


def get(url: str) -> bytes:
    os.makedirs(CACHE, exist_ok=True)
    fn = os.path.join(CACHE, url.replace("/", "_").replace(":", ""))
    if os.path.exists(fn):
        return open(fn, "rb").read()
    req = urllib.request.Request(url, headers={"User-Agent": "o-inicio-do-fim-foliage"})
    with urllib.request.urlopen(req, timeout=120) as r:
        data = r.read()
    open(fn, "wb").write(data)
    return data


def atlas(model: str, dkey: str, akey: str, res: str = "2k") -> Image.Image:
    files = json.loads(get(f"{API}/files/{model}"))

    def url(k):
        e = files[k].get(res) or files[k].get("1k")
        return (e.get("jpg") or e.get("png"))["url"]

    d = Image.open(io.BytesIO(get(url(dkey)))).convert("RGB")
    a = Image.open(io.BytesIO(get(url(akey)))).convert("L").resize(d.size, Image.LANCZOS)
    d.putalpha(a)
    return d


def pieces(img: Image.Image, min_area: int, box=None, keep: int = 0, aspect=(0.0, 99.0),
           fill=(0.0, 1.0), green: float = -1.0) -> list:
    """Recortes (RGBA) de cada componente conexo do alfa (as folhas/tufos).
    Filtros: proporção altura/largura, quanto do retângulo a folha preenche e um
    mínimo de "verde" (g - r) para separar folha de fruto, flor e casca."""
    if box:
        img = img.crop(box)
    arr = np.asarray(img)
    mask = arr[:, :, 3] > 110
    mask = ndimage.binary_opening(mask, iterations=1)
    lab, n = ndimage.label(mask)
    out = []
    for i, sl in enumerate(ndimage.find_objects(lab)):
        if sl is None:
            continue
        m = lab[sl] == (i + 1)
        if m.sum() < min_area:
            continue
        h, w = m.shape
        asp = max(h, w) / max(1, min(h, w))
        if not (aspect[0] <= asp <= aspect[1]) or not (fill[0] <= m.mean() <= fill[1]):
            continue
        if green > -1.0:
            px = arr[sl][m].astype(np.float32)
            if (px[:, 1] - px[:, 0]).mean() / 255.0 < green:
                continue
        sub = arr[sl].copy()
        # alfa só do próprio componente (sem pedaço da folha vizinha nem o lixo do preenchimento)
        a = sub[:, :, 3].astype(np.float32) * ndimage.binary_dilation(m, iterations=2)
        sub[:, :, 3] = a.astype(np.uint8)
        out.append((int(m.sum()), Image.fromarray(sub, "RGBA")))
    out.sort(key=lambda t: -t[0])
    if keep:
        out = out[:keep]
    return [p for _, p in out]


def bleed(img: Image.Image) -> Image.Image:
    """Espalha a cor das folhas para a área transparente (sem halo escuro nos mipmaps)."""
    arr = np.asarray(img).astype(np.float32)
    a = arr[:, :, 3:4] / 255.0
    rgb = arr[:, :, :3]
    acc = rgb * a
    w = a.copy()
    for r in (4, 16, 64):
        k = Image.fromarray(np.clip(acc, 0, 255).astype(np.uint8)).filter(ImageFilter.BoxBlur(r))
        kw = Image.fromarray((np.clip(w[:, :, 0], 0, 1) * 255).astype(np.uint8)).filter(ImageFilter.BoxBlur(r))
        kb = np.asarray(k).astype(np.float32)
        kwb = np.asarray(kw).astype(np.float32)[:, :, None] / 255.0
        fill = kb / np.maximum(kwb, 1e-3)
        rgb = np.where(w > 0.01, rgb, fill)
        acc = rgb * np.maximum(w, kwb)
        w = np.maximum(w, kwb)
    out = np.concatenate([np.clip(rgb, 0, 255), arr[:, :, 3:4]], axis=2).astype(np.uint8)
    return Image.fromarray(out, "RGBA")


def tint(leaf: Image.Image, bright: float, sat: float, warm: float) -> Image.Image:
    rgb = leaf.convert("RGB")
    rgb = ImageEnhance.Color(rgb).enhance(sat)
    rgb = ImageEnhance.Brightness(rgb).enhance(bright)
    if warm:
        r, g, b = rgb.split()
        r = r.point(lambda v: min(255, int(v * (1.0 + warm))))
        b = b.point(lambda v: int(v * (1.0 - warm * 0.6)))
        rgb = Image.merge("RGB", (r, g, b))
    rgb.putalpha(leaf.getchannel("A"))
    return rgb


def cluster(leaves: list, size: int, n: int, scale: tuple, seed: int, radius: float = 0.44,
            twigs: int = 7, warm_chance: float = 0.12, outward: bool = True) -> Image.Image:
    """Cartão de copa: folhas giradas apontando para fora, as do miolo mais escuras."""
    rnd = random.Random(seed)
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    c = size / 2
    d = ImageDraw.Draw(canvas)
    for _ in range(twigs):
        a = rnd.random() * math.tau
        r1 = radius * size * rnd.uniform(0.6, 0.95)
        pts = [(c, c)]
        for k in range(1, 5):
            t = k / 4
            pts.append((c + math.cos(a + math.sin(t * 3) * 0.2) * r1 * t, c + math.sin(a + math.sin(t * 3) * 0.2) * r1 * t))
        d.line(pts, fill=(58, 44, 32, 255), width=max(2, size // 300))
    items = []
    for _ in range(n):
        rr = math.sqrt(rnd.random())
        a = rnd.random() * math.tau
        items.append((rr, a))
    items.sort()
    for rr, a in items:
        leaf = rnd.choice(leaves)
        target = rnd.uniform(*scale) * size
        k = target / max(leaf.size)
        lw, lh = max(2, int(leaf.width * k)), max(2, int(leaf.height * k))
        lf = leaf.resize((lw, lh), Image.LANCZOS)
        # as folhas do atlas estão de pé (cabinho embaixo): aponta a ponta para fora
        deg = (-(math.degrees(a) + 90.0) if outward else rnd.uniform(0, 360)) + rnd.uniform(-38, 38)
        lf = lf.rotate(deg, resample=Image.BICUBIC, expand=True)
        warm = rnd.uniform(0.05, 0.25) if rnd.random() < warm_chance else 0.0
        lf = tint(lf, (0.55 + 0.45 * rr) * rnd.uniform(0.85, 1.12), rnd.uniform(0.85, 1.1), warm)
        x = c + math.cos(a) * rr * radius * size - lf.width / 2
        y = c + math.sin(a) * rr * radius * size - lf.height / 2
        canvas.alpha_composite(lf, (int(x), int(y)))
    return canvas


def grass_tuft(clumps: list, seed: int) -> Image.Image:
    """Moita para o plano de 0,92 x 0,62 m: tela 1480x1000 (texel quadrado em metros),
    reduzida para 1024x1024 (o plano desfaz o achatamento)."""
    rnd = random.Random(seed)
    W, H = 1480, 1000
    canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    xs = [0.18, 0.5, 0.82, 0.34, 0.66]
    order = list(range(len(xs)))
    for i in order:
        cl = clumps[i % len(clumps)]
        h = H * rnd.uniform(0.78, 0.98)
        k = h / cl.height
        w = cl.width * k
        if w > W * 0.62:
            k *= W * 0.62 / w
        im = cl.resize((max(2, int(cl.width * k)), max(2, int(cl.height * k))), Image.LANCZOS)
        if rnd.random() < 0.5:
            im = im.transpose(Image.FLIP_LEFT_RIGHT)
        im = tint(im, rnd.uniform(0.9, 1.08), rnd.uniform(0.95, 1.1), 0.0)
        x = int(xs[i] * W - im.width / 2)
        canvas.alpha_composite(im, (max(0, min(W - im.width, x)), H - im.height))
    return canvas.resize((1024, 1024), Image.LANCZOS)


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    tree_a = atlas("island_tree_02", "leaves_diff", "leaves_alpha")
    tree_b = atlas("island_tree_01", "leaves_diff", "leaves_alpha")
    tree_leaves = pieces(tree_a, 4000) + pieces(tree_b, 4000)
    # arbusto: só as folhas verdes serrilhadas (sem fruto, flor, casca nem as amareladas)
    shrub = pieces(atlas("shrub_01", "Diffuse", "Alpha"), 6000, box=(0, 0, 2048, 1640), aspect=(1.05, 2.2),
                   fill=(0.3, 0.75), green=0.04)
    # trepadeira: as 7 folhas de cima (os galhos ficam de fora)
    searsia = pieces(atlas("searsia_lucida", "Diffuse", "Alpha"), 2500, box=(0, 0, 1250, 800), aspect=(1.05, 3.0),
                     fill=(0.45, 0.9))
    fern = pieces(atlas("fern_02", "Diffuse", "Alpha"), 20000)
    # moitas da faixa de baixo; o último 1,5% da altura (base esticada do atlas) é cortado
    grass = pieces(atlas("grass_medium_01", "Diffuse", "Alpha"), 8000, box=(0, 1500, 2048, 2048), keep=5,
                   aspect=(1.0, 3.5))
    grass = [g.crop((0, 0, g.width, int(g.height * 0.93))) for g in grass]
    print("recortes: árvore %d, arbusto %d, trepadeira %d, samambaia %d, grama %d" % (
        len(tree_leaves), len(shrub), len(searsia), len(fern), len(grass)))
    jobs = {
        "leaves_tree.png": lambda: cluster(tree_leaves, 2048, 420, (0.07, 0.12), 11),
        "leaves_bush.png": lambda: cluster(shrub, 2048, 170, (0.1, 0.16), 23, warm_chance=0.05),
        "leaves_vine.png": lambda: cluster(searsia, 1024, 220, (0.07, 0.11), 37, radius=0.46, twigs=4),
        "leaves_pine.png": lambda: cluster(fern, 2048, 42, (0.3, 0.5), 53, radius=0.3, twigs=0, warm_chance=0.0),
        "grass_tuft.png": lambda: grass_tuft(grass, 71),
    }
    for name, fn in jobs.items():
        img = bleed(fn())
        img.save(os.path.join(OUT, name), optimize=True)
        print("ok", name, img.size)
    # palmeira: a maior fronde da samambaia, de pé, base em v=0 (lado do tronco)
    fr = fern[0]
    fr = fr.transpose(Image.FLIP_TOP_BOTTOM)
    pad = Image.new("RGBA", (fr.width + 40, fr.height + 40), (0, 0, 0, 0))
    pad.alpha_composite(fr, (20, 20))
    pad = bleed(pad.resize((512, 2048), Image.LANCZOS))
    pad.save(os.path.join(OUT, "frond_palm.png"), optimize=True)
    print("ok frond_palm.png", pad.size)
    with open(os.path.join(OUT, "LICENCA.txt"), "w") as f:
        f.write("Folhagem fotográfica montada por tools/make_foliage.py a partir dos atlas de folhas\n"
                "dos modelos do Poly Haven (CC0 1.0): island_tree_01, island_tree_02, shrub_01,\n"
                "searsia_lucida, fern_02 e grass_medium_01 — https://polyhaven.com/license\n")


if __name__ == "__main__":
    main()
