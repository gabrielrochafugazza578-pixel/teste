#!/usr/bin/env python3
"""Folha de pichações (estilo "pixo": letras altas, retas e angulosas, de rolo
ou spray) e alguns grafites de assinatura arredondada, com borda de spray e
escorridos. Saída: assets/textures/decals/pixo.png (RGBA, 2048x1024, 4x2
células; cada célula é uma inscrição). Tudo gerado aqui (sem fontes externas).

Uso: python3 tools/make_graffiti.py
"""
import math
import os
import random

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "textures", "decals", "pixo.png")
CW, CH = 512, 512
COLS = [(16, 16, 18), (18, 18, 20), (20, 20, 22), (150, 22, 20), (28, 50, 120), (20, 20, 22), (230, 230, 225), (40, 110, 60)]


def glyph(rng, x, y, w, h):
    """Uma letra de pixo: hastes verticais e diagonais, com ganchos e serifas."""
    segs = []
    kind = rng.randrange(9)
    t, b = y, y + h
    l, r = x, x + w
    m = (l + r) / 2
    if kind == 0:   # A angular
        segs += [((l, b), (m, t)), ((m, t), (r, b)), ((l + w * 0.25, y + h * 0.6), (r - w * 0.25, y + h * 0.6))]
    elif kind == 1:  # E de hastes
        segs += [((l, t), (l, b)), ((l, t), (r, t - h * 0.08)), ((l, y + h * 0.5), (r * 0.9 + l * 0.1, y + h * 0.45)), ((l, b), (r, b + h * 0.06))]
    elif kind == 2:  # R / K
        segs += [((l, t), (l, b)), ((l, t), (r, y + h * 0.25)), ((r, y + h * 0.25), (l, y + h * 0.5)), ((l + w * 0.2, y + h * 0.5), (r, b))]
    elif kind == 3:  # S de zigue-zague
        segs += [((r, t), (l, y + h * 0.3)), ((l, y + h * 0.3), (r, y + h * 0.7)), ((r, y + h * 0.7), (l, b))]
    elif kind == 4:  # haste dupla (I com ganchos)
        segs += [((m, t - h * 0.1), (m, b)), ((l, t), (r, t)), ((l, b), (r, b))]
    elif kind == 5:  # M
        segs += [((l, b), (l, t)), ((l, t), (m, y + h * 0.55)), ((m, y + h * 0.55), (r, t)), ((r, t), (r, b))]
    elif kind == 6:  # O quadrado com corte
        segs += [((l, t), (r, t)), ((r, t), (r, b)), ((r, b), (l, b)), ((l, b), (l, t + h * 0.15))]
    elif kind == 7:  # X / estrela
        segs += [((l, t), (r, b)), ((r, t), (l, b)), ((m, t - h * 0.1), (m, t + h * 0.15))]
    else:            # T alto
        segs += [((l - w * 0.1, t), (r + w * 0.1, t)), ((m, t), (m, b + h * 0.1))]
    # serifa angulosa no pé (marca do pixo)
    if rng.random() < 0.5:
        segs.append(((l, b), (l - w * 0.25, b + h * 0.08)))
    return segs


def spray(draw, a, b, width, col):
    draw.line([a, b], fill=col, width=int(width))
    r = width / 2
    for p in (a, b):
        draw.ellipse([p[0] - r, p[1] - r, p[0] + r, p[1] + r], fill=col)


def cell(rng, ci):
    im = Image.new("L", (CW, CH), 0)
    d = ImageDraw.Draw(im)
    style = ci % 4
    if style in (0, 1, 2):
        # pixo: uma ou duas linhas de letras altas
        lines = 1 if rng.random() < 0.5 else 2
        n = rng.randint(4, 7)
        lh = (CH * 0.7) / lines
        for li in range(lines):
            gw = (CW * 0.82) / n
            x = CW * 0.09
            y = CH * 0.15 + li * lh * 1.05
            width = rng.uniform(8, 16)
            for gi in range(n):
                h = lh * rng.uniform(0.75, 0.95)
                for a, b in glyph(rng, x + gw * 0.12, y + (lh - h), gw * 0.7, h):
                    spray(d, a, b, width, 255)
                x += gw
    else:
        # assinatura arredondada (tag de spray)
        pts = []
        x = CW * 0.12
        y0 = CH * 0.5
        for k in range(rng.randint(5, 8)):
            amp = rng.uniform(40, 110)
            for s in range(14):
                a = s / 13.0 * math.pi * 2
                pts.append((x + s * 4.5, y0 + math.sin(a + k) * amp * 0.6 - math.cos(a * 0.5) * amp * 0.3))
            x += 55
        d.line(pts, fill=255, width=int(rng.uniform(7, 12)), joint="curve")
        # sublinhado com voltinha
        d.line([(CW * 0.1, y0 + 120), (CW * 0.85, y0 + 105)], fill=255, width=6)
    a = np.asarray(im).astype(np.float32) / 255.0
    # escorridos: de alguns pontos da parte de baixo dos traços, filetes para baixo
    ys, xs = np.nonzero(a > 0.5)
    if len(ys):
        for _ in range(rng.randint(4, 12)):
            i = rng.randrange(len(ys))
            x0, y0 = xs[i], ys[i]
            ln = rng.randint(20, 90)
            wd = rng.randint(1, 3)
            a[y0:min(CH, y0 + ln), max(0, x0 - wd):x0 + wd] = np.maximum(a[y0:min(CH, y0 + ln), max(0, x0 - wd):x0 + wd], np.linspace(1, 0.3, min(CH, y0 + ln) - y0)[:, None])
    # borda de spray: desfoque leve + respingos finos em volta
    soft = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(2.2))).astype(np.float32) / 255.0
    halo = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(9))).astype(np.float32) / 255.0
    noise = np.random.default_rng(ci).random((CH, CW)).astype(np.float32)
    speck = (noise < halo * 0.35).astype(np.float32) * 0.6
    alpha = np.clip(np.maximum(soft * 1.25, speck), 0, 1)
    # tinta gasta/desbotada em manchas
    fade = np.asarray(Image.fromarray((np.random.default_rng(ci + 7).random((CH // 32, CW // 32)) * 255).astype(np.uint8)).resize((CW, CH), Image.BICUBIC)).astype(np.float32) / 255.0
    alpha *= 0.65 + 0.35 * fade
    col = COLS[ci % len(COLS)]
    rgba = np.zeros((CH, CW, 4), np.uint8)
    rgba[:, :, 0], rgba[:, :, 1], rgba[:, :, 2] = col
    rgba[:, :, 3] = (alpha * 255).astype(np.uint8)
    return Image.fromarray(rgba, "RGBA")


def main():
    rng = random.Random(1904)
    sheet = Image.new("RGBA", (CW * 4, CH * 2), (0, 0, 0, 0))
    for ci in range(8):
        sheet.paste(cell(rng, ci), ((ci % 4) * CW, (ci // 4) * CH))
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    sheet.save(OUT)
    print("ok", OUT)


if __name__ == "__main__":
    main()
