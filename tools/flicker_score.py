#!/usr/bin/env python3
"""Mede o "piscar" nas sequências gravadas por tests/flicker.tscn.

Para cada quadro do meio compara com a média dos vizinhos (câmera andando
devagar, a mudança real é suave; z-fighting e serrilhado pulam de um quadro
para outro). Salva <cena>_mapa.png (vermelho = pisca) e imprime a nota:
% de pixels com erro temporal alto.
Uso: python3 tools/flicker_score.py /tmp/pisca
"""
import glob
import os
import re
import sys

import numpy as np
from PIL import Image

d = sys.argv[1]
thr = float(sys.argv[2]) if len(sys.argv) > 2 else 0.12
scenes = {}
for f in sorted(glob.glob(os.path.join(d, "*_[0-9][0-9].png"))):
    m = re.match(r"(.*)_(\d\d)\.png$", os.path.basename(f))
    scenes.setdefault(m.group(1), []).append(f)
for name, files in sorted(scenes.items()):
    fr = [np.asarray(Image.open(f).convert("RGB"), dtype=np.float32) / 255.0 for f in files]
    if len(fr) < 3:
        continue
    acc = np.zeros(fr[0].shape[:2], np.float32)
    for i in range(1, len(fr) - 1):
        e = np.abs(fr[i] - 0.5 * (fr[i - 1] + fr[i + 1])).max(axis=2)
        acc = np.maximum(acc, e)
    bad = acc > thr
    # desconta o que se mexe com a câmera parada (vento, pessoas)
    sp = [os.path.join(d, "%s_s%d.png" % (name, k)) for k in range(2)]
    if all(os.path.exists(x) for x in sp):
        s0, s1 = [np.asarray(Image.open(x).convert("RGB"), dtype=np.float32) / 255.0 for x in sp]
        anim = np.abs(s0 - s1).max(axis=2) > thr * 0.5
        # dilata um pouco a máscara de animação
        from numpy.lib.stride_tricks import sliding_window_view as swv
        pad = np.pad(anim, 3)
        anim = swv(pad, (7, 7)).any(axis=(2, 3))
        bad &= ~anim
    # ignora a faixa do topo/rodapé (HUD escondido, mas bordas do quadro variam)
    score = bad[20:-20, 20:-20].mean() * 100.0
    base = fr[len(fr) // 2]
    over = base * 0.55
    over[bad] = [1.0, 0.1, 0.1]
    Image.fromarray((over * 255).astype(np.uint8)).save(os.path.join(d, name + "_mapa.png"))
    print("%-14s pisca: %5.2f%% dos pixels" % (name, score))
