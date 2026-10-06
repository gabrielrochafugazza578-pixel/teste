#!/usr/bin/env python3
"""Árvores escaneadas do Poly Haven (https://polyhaven.com, CC0) prontas para o jogo.

Os escaneamentos têm milhões de triângulos (o jacarandá: 1,4 mi de tronco e galhos
e 2,4 mi de folhas soltas). Aqui:
  * tronco e galhos: os galhinhos finos (componentes pequenos) saem; o resto vai
    inteiro para tools/pack_trees.gd, que simplifica com o meshoptimizer do Godot
    até a meta de triângulos de cada nível (perto/longe);
  * folhas: as folhas reais são agrupadas (k-means) em tufos e cada tufo vira um
    par de cartões cruzados com textura em foto montada com as folhas DESTA
    espécie (recortes do atlas de folhas do próprio modelo) — a copa mantém a
    silhueta real da árvore;
  * cor do vértice: R = quanto balança no vento, G = sombreamento da copa.

Saída: assets/models/trees/src/<id>_<lod>.json/.bin (gitignored), as texturas do
tronco/galhos em assets/models/trees/<id>/ e a folhagem em
assets/textures/foliage/leaves_<id>.png.
Uso: python3 -I tools/make_trees.py --src /pasta/com/<modelo>/tree.gltf ...
"""
import json
import os
import random
import shutil
import sys

import numpy as np
from PIL import Image
from scipy import ndimage
from scipy.cluster.vq import kmeans2
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
OUT = os.path.join(ROOT, "assets", "models", "trees")
FOLIAGE = os.path.join(ROOT, "assets", "textures", "foliage")

# id do jogo -> modelo do Poly Haven, altura final (m), tufos de folha, metas de tri
TREES = {
    "jacaranda": {"model": "jacaranda_tree", "height": 9.6, "tufts": 1050, "bark": [14000, 2200],
                  "min_branch": 0.9, "card": 1.7},
    "acacia": {"model": "tree_small_02", "height": 5.8, "tufts": 520, "bark": [7000, 1200],
               "min_branch": 0.35, "card": 1.55},
}


def load_gltf(path):
    g = json.load(open(path))
    d = os.path.dirname(path)
    bins = [open(os.path.join(d, b["uri"]), "rb").read() for b in g["buffers"]]

    def acc(i):
        a = g["accessors"][i]
        v = g["bufferViews"][a["bufferView"]]
        dt = {5126: np.float32, 5125: np.uint32, 5123: np.uint16, 5121: np.uint8}[a["componentType"]]
        n = {"SCALAR": 1, "VEC2": 2, "VEC3": 3, "VEC4": 4}[a["type"]]
        off = v.get("byteOffset", 0) + a.get("byteOffset", 0)
        stride = v.get("byteStride", 0)
        buf = bins[v["buffer"]]
        if stride and stride != n * np.dtype(dt).itemsize:
            raw = np.frombuffer(buf, np.uint8, count=stride * a["count"], offset=off).reshape(a["count"], stride)
            return raw[:, :n * np.dtype(dt).itemsize].copy().view(dt).reshape(a["count"], n)
        return np.frombuffer(buf, dt, count=a["count"] * n, offset=off).reshape(a["count"], n) if n > 1 else \
            np.frombuffer(buf, dt, count=a["count"], offset=off).copy()

    parts = {}
    for m in g["meshes"]:
        for p in m["primitives"]:
            name = g["materials"][p["material"]]["name"]
            parts[name] = {
                "pos": acc(p["attributes"]["POSITION"]).astype(np.float64),
                "nrm": acc(p["attributes"]["NORMAL"]).astype(np.float64),
                "uv": acc(p["attributes"]["TEXCOORD_0"]).astype(np.float64),
                "idx": acc(p["indices"]).astype(np.int64).reshape(-1, 3),
            }
    return g, parts


def drop_small(part, min_size):
    """Remove componentes conexos cujo tamanho (diagonal da caixa) < min_size."""
    P, T = part["pos"], part["idx"]
    n = len(P)
    rows = np.r_[T[:, 0], T[:, 1], T[:, 2]]
    cols = np.r_[T[:, 1], T[:, 2], T[:, 0]]
    adj = coo_matrix((np.ones(len(rows), np.int8), (rows, cols)), shape=(n, n))
    nc, lab = connected_components(adj, directed=False)
    mn = np.full((nc, 3), np.inf)
    mx = np.full((nc, 3), -np.inf)
    np.minimum.at(mn, lab, P)
    np.maximum.at(mx, lab, P)
    size = np.linalg.norm(mx - mn, axis=1)
    keep_c = size >= min_size
    keep_t = keep_c[lab[T[:, 0]]]
    T = T[keep_t]
    used = np.unique(T)
    remap = np.full(n, -1, np.int64)
    remap[used] = np.arange(len(used))
    out = {k: part[k][used] for k in ("pos", "nrm", "uv")}
    out["idx"] = remap[T]
    print("    galhos: %d componentes, %d mantidos, %d -> %d tri" % (nc, keep_c.sum(), len(part["idx"]), len(T)))
    return out


def cluster_decimate(part, cell):
    """Simplificação grosseira por grade (só para o nível de longe)."""
    P, T = part["pos"], part["idx"]
    key = np.floor(P / cell).astype(np.int64)
    _, inv = np.unique(key, axis=0, return_inverse=True)
    inv = inv.reshape(-1)
    n = inv.max() + 1
    cnt = np.bincount(inv, minlength=n)[:, None]
    out = {}
    for a in ("pos", "nrm", "uv", "color"):
        if a in part:
            acc = np.zeros((n, part[a].shape[1]))
            np.add.at(acc, inv, part[a])
            out[a] = acc / np.maximum(cnt, 1)
    out["nrm"] /= np.maximum(np.linalg.norm(out["nrm"], axis=1, keepdims=True), 1e-9)
    T2 = inv[T]
    ok = (T2[:, 0] != T2[:, 1]) & (T2[:, 1] != T2[:, 2]) & (T2[:, 0] != T2[:, 2])
    T2 = np.unique(np.sort(T2[ok], axis=1), axis=0, return_index=True)[1]
    T2 = inv[T][ok][np.sort(T2)]
    out["idx"] = T2
    return out


def leaf_cards(leaves, n_tufts, card_k, rng, center_xz, top_y, height):
    """Tufos de folhas reais -> pares de cartões cruzados."""
    P, T = leaves["pos"], leaves["idx"]
    cen = P[T].mean(1)
    sel = rng.choice(len(cen), min(len(cen), 160000), replace=False)
    pts = cen[sel]
    np.random.seed(7)
    cents, lab = kmeans2(pts, n_tufts, minit="++", seed=7, iter=12)
    verts, uvs, cols, nrms, idx = [], [], [], [], []
    crown_c = np.array([center_xz[0], top_y * 0.62, center_xz[1]])
    for k in range(len(cents)):
        mem = pts[lab == k]
        if len(mem) < 8:
            continue
        c = mem.mean(0)
        spread = np.sqrt(((mem - c) ** 2).sum(1).mean())
        s = max(spread * 2.0 * card_k, 0.35 * height / 9.6)
        out = c - crown_c
        out[1] *= 0.6
        out /= max(np.linalg.norm(out), 1e-6)
        # dois cartões: um de frente para fora, outro girado 90° em volta da saída
        up = np.array([0.0, 1.0, 0.0])
        a1 = np.cross(out, up)
        if np.linalg.norm(a1) < 1e-3:
            a1 = np.array([1.0, 0.0, 0.0])
        a1 /= np.linalg.norm(a1)
        a2 = np.cross(out, a1)
        ang = rng.uniform(0, np.pi)
        r1 = a1 * np.cos(ang) + a2 * np.sin(ang)
        r2 = np.cross(out, r1)
        dist = np.linalg.norm((c - np.array([center_xz[0], 0, center_xz[1]]))[[0, 2]])
        sway = np.clip(0.25 + c[1] / top_y * 0.45 + dist / (height * 0.6) * 0.4, 0.2, 1.0)
        shade = np.clip(0.35 + (c[1] - top_y * 0.4) / (top_y * 0.6) * 0.4 + (np.dot(c - crown_c, out) > 0) * 0.25, 0.25, 1.0)
        for (ax, ay) in ((r1, r2), (r1 * 0.95 + out * 0.3, np.cross(out, r1))):
            ax = ax / np.linalg.norm(ax) * s * 0.5
            ay = ay / np.linalg.norm(ay) * s * 0.5
            base = len(verts)
            q = [c - ax - ay, c + ax - ay, c + ax + ay, c - ax + ay]
            n = np.cross(ax, ay)
            n /= max(np.linalg.norm(n), 1e-9)
            if np.dot(n, out) < 0:
                n = -n
            for i, p in enumerate(q):
                verts.append(p)
                nrms.append(n)
                uvs.append([[0, 1], [1, 1], [1, 0], [0, 0]][i])
                cols.append([sway, shade, 0, 1])
            idx += [[base, base + 1, base + 2], [base, base + 2, base + 3]]
    return {"pos": np.array(verts), "nrm": np.array(nrms), "uv": np.array(uvs, float), "color": np.array(cols),
            "idx": np.array(idx, np.int64)}


def foliage_texture(model_dir, tid):
    """Cartão redondo de folhas desta espécie (recortes do atlas do modelo)."""
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import make_foliage as mf
    tex = os.path.join(model_dir, "textures")
    hi = [f for f in os.listdir(tex) if f.startswith("leaves_diff_2k")]
    diff = hi[0] if hi else [f for f in os.listdir(tex) if "leaves_diff" in f][0]
    alpha = [f for f in os.listdir(tex) if f.startswith("leaves_alpha_2k")] or ["leaves_alpha_1k.png"]
    d = Image.open(os.path.join(tex, diff)).convert("RGB")
    a = Image.open(os.path.join(tex, alpha[0])).convert("L").resize(d.size, Image.LANCZOS)
    img = d.copy()
    img.putalpha(a)
    if tid == "jacaranda":
        # folhas bipinadas inteiras (3 no atlas): leque de folhas compridas
        pcs = mf.pieces(img, 4000, keep=3)
        card = mf.cluster(pcs, 1024, 26, (0.34, 0.5), 11, radius=0.34, twigs=5)
    else:
        # folhas soltas presas a talos: separa só o limbo verde
        arr = np.asarray(img).astype(np.int32)
        m = (arr[:, :, 3] > 110) & (arr[:, :, 1] > arr[:, :, 0] + 18) & (arr[:, :, 1] > 50) & (arr[:, :, 0] < arr[:, :, 1] * 0.8)
        m = ndimage.binary_opening(m, iterations=5)
        lab, n = ndimage.label(m)
        pcs = []
        for i, sl in enumerate(ndimage.find_objects(lab)):
            if sl is None:
                continue
            mm = lab[sl] == i + 1
            h, w = mm.shape
            if not (6000 <= mm.sum() <= 160000) or max(h, w) / max(1, min(h, w)) > 2.6 or not (0.42 < mm.mean() < 0.8):
                continue
            sub = np.asarray(img)[sl].copy()
            sub[:, :, 3] = (sub[:, :, 3] * ndimage.binary_dilation(mm, iterations=1)).astype(np.uint8)
            pcs.append(Image.fromarray(sub, "RGBA"))
        print("    folhas recortadas:", len(pcs))
        card = mf.cluster(pcs, 1024, 52, (0.13, 0.24), 13, twigs=6)
    card = mf.bleed(card)
    os.makedirs(FOLIAGE, exist_ok=True)
    card.save(os.path.join(FOLIAGE, "leaves_%s.png" % tid))


def write(tid, lod, surfaces, tex=None):
    d = os.path.join(OUT, "src")
    os.makedirs(d, exist_ok=True)
    meta = {"id": tid, "lod": lod, "surfaces": [], "tex": tex or {}}
    with open(os.path.join(d, "%s_%d.bin" % (tid, lod)), "wb") as f:
        for name, s, target in surfaces:
            n = len(s["pos"])
            col = s.get("color", np.ones((n, 4)))
            meta["surfaces"].append({"name": name, "nv": n, "ni": len(s["idx"]) * 3, "target": target})
            f.write(s["pos"].astype("<f4").tobytes())
            f.write(s["nrm"].astype("<f4").tobytes())
            f.write(s["uv"].astype("<f4").tobytes())
            f.write(col.astype("<f4").tobytes())
            # Godot: frente em sentido horário
            f.write(s["idx"][:, ::-1].astype("<i4").tobytes())
    json.dump(meta, open(os.path.join(d, "%s_%d.json" % (tid, lod)), "w"), indent=1)


def bark_colors(s, center_xz, top_y):
    P = s["pos"]
    dist = np.linalg.norm(P[:, [0, 2]] - np.array(center_xz), axis=1)
    sway = np.clip(P[:, 1] / top_y * 0.25 + dist / max(top_y, 1) * 0.25, 0.0, 0.5)
    s["color"] = np.c_[sway, np.ones(len(P)), np.zeros(len(P)), np.ones(len(P))]


def build(tid, spec, gltf_path):
    print("==", tid)
    rng = np.random.default_rng(42)
    g, parts = load_gltf(gltf_path)
    names = list(parts.keys())
    trunk = parts[[n for n in names if n.endswith("trunk")][0]]
    branches = parts[[n for n in names if "branch" in n][0]]
    leaves = parts[[n for n in names if n.endswith("leaves")][0]]
    # escala/centro: base do tronco na origem, altura pedida
    allp = np.r_[trunk["pos"], branches["pos"], leaves["pos"]]
    y0 = trunk["pos"][:, 1].min()
    top = allp[:, 1].max() - y0
    k = spec["height"] / top
    base = trunk["pos"][trunk["pos"][:, 1] < y0 + 0.4 * (top / 10)]
    cx, cz = base[:, 0].mean(), base[:, 2].mean()
    for p in (trunk, branches, leaves):
        p["pos"] = (p["pos"] - [cx, y0, cz]) * k
    branches = drop_small(branches, spec["min_branch"] / k * k)
    top_y = spec["height"]
    for s in (trunk, branches):
        bark_colors(s, (0.0, 0.0), top_y)
    near = leaf_cards(leaves, spec["tufts"], spec["card"], rng, (0.0, 0.0), top_y, spec["height"])
    far = leaf_cards(leaves, max(60, spec["tufts"] // 4), spec["card"] * 1.75, rng, (0.0, 0.0), top_y, spec["height"])
    # texturas de cada material (nomes curtos copiados para assets/models/trees/<id>/)
    texmap = {}
    for m in g["materials"]:
        key = "trunk" if m["name"].endswith("trunk") else ("branches" if "branch" in m["name"] else "leaves")
        ent = {}
        for slot, ref in (("albedo", m["pbrMetallicRoughness"].get("baseColorTexture")), ("normal", m.get("normalTexture")),
                          ("arm", m["pbrMetallicRoughness"].get("metallicRoughnessTexture"))):
            if ref is not None:
                uri = g["images"][g["textures"][ref["index"]]["source"]]["uri"]
                ent[slot] = os.path.basename(uri).replace(spec["model"] + "_", "")
        texmap[key] = ent
    tb, tf = spec["bark"]
    write(tid, 0, [("trunk", trunk, int(tb * 0.45)), ("branches", branches, int(tb * 0.55)), ("leaves", near, 0)], texmap)
    far_trunk = cluster_decimate(trunk, spec["height"] / 70.0)
    far_br = cluster_decimate(drop_small(branches, spec["min_branch"] * 2.5), spec["height"] / 50.0)
    write(tid, 1, [("trunk", far_trunk, int(tf * 0.5)), ("branches", far_br, int(tf * 0.5)), ("leaves", far, 0)], texmap)
    # texturas do tronco e dos galhos (1K do Poly Haven)
    dst = os.path.join(OUT, tid)
    os.makedirs(dst, exist_ok=True)
    tex = os.path.join(os.path.dirname(gltf_path), "textures")
    for f in os.listdir(tex):
        if ("trunk" in f or "branch" in f or "_diff_" in f or "_nor_gl_" in f or "_arm_" in f) and "leaves" not in f:
            short = f.replace(spec["model"] + "_", "")
            shutil.copy(os.path.join(tex, f), os.path.join(dst, short))
    foliage_texture(os.path.dirname(gltf_path), tid)
    print("   perto: casca %d tri (meta %d), %d cartões; longe: %d cartões" % (
        len(trunk["idx"]) + len(branches["idx"]), tb, len(near["idx"]) // 2, len(far["idx"]) // 2))


def main():
    args = sys.argv[1:]
    src = "/tmp/trees"
    if "--src" in args:
        i = args.index("--src")
        src = args[i + 1]
        del args[i:i + 2]
    only_tex = "--so-folhas" in args
    args = [a for a in args if not a.startswith("--")]
    for tid in (args or list(TREES.keys())):
        spec = TREES[tid]
        if only_tex:
            foliage_texture(os.path.join(src, spec["model"]), tid)
            continue
        build(tid, spec, os.path.join(src, spec["model"], "tree.gltf"))
    with open(os.path.join(OUT, "LICENCA.txt"), "w") as f:
        f.write("Árvores escaneadas do Poly Haven (CC0 1.0) — https://polyhaven.com/license\n"
                "Processadas por tools/make_trees.py:\n")
        for tid, spec in TREES.items():
            f.write("  %-10s %s  (https://polyhaven.com/a/%s)\n" % (tid, spec["model"], spec["model"]))


if __name__ == "__main__":
    main()
