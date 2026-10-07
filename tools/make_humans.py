#!/usr/bin/env python3
"""Gera os personagens fotorrealistas do jogo a partir dos assets do MakeHuman
(malha base, alvos de forma, esqueleto, pesos, roupas, cabelos e peles em foto).

Licenças: a malha base, os alvos, o esqueleto, os pesos e os assets de sistema do
MakeHuman são CC0; os pacotes da comunidade usados aqui são CC0, exceto os marcados
"ccby" (atribuição em assets/characters/CREDITOS.txt).

Para cada personagem (RECIPES): aplica os alvos macro (gênero, idade, músculo, peso,
etnia), veste as roupas/cabelo/barba/olhos/sobrancelhas/cílios/dentes pelo .mhclo
(cada vértice preso a 3 vértices do corpo), apaga a pele escondida sob a roupa,
converte os 163 ossos do MakeHuman nos 18 do jogo, baixa os braços da pose em A para
a pose de descanso do animador (braços pendurados) e fecha as pernas, passa para
metros/Y-up/frente -Z e grava:

  assets/characters/src/<id>.json + <id>.bin   (malha por superfície, juntas, pé)
  assets/characters/src/tex/<material>_a.png    (cor, alfa = recorte)
  assets/characters/src/tex/<material>_n.png    (normal RG, AO em B, rugosidade em A)
  assets/characters/src/materials.json

Depois: godot --headless --path . -s tools/pack_humans.gd  (gera os .res do jogo).

Uso: python3 -I tools/make_humans.py --mh /caminho/assets_makehuman [id ...]
A pasta --mh contém data/ (3dobjs, rigs, targets), sys/ (assets de sistema) e
packs/<pacote>/ (pacotes da comunidade), como baixados do makehumancommunity.org.
"""
import json
import math
import os
import struct
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFile, ImageFilter

# alguns PNG dos pacotes da comunidade têm o perfil de cor (iCCP) com CRC errado
ImageFile.LOAD_TRUNCATED_IMAGES = True

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
OUT = os.path.join(ROOT, "assets", "characters", "src")

BONES = ["hips", "spine", "chest", "neck", "head", "jaw", "upperarm_l", "forearm_l", "hand_l",
         "upperarm_r", "forearm_r", "hand_r", "thigh_l", "shin_l", "foot_l", "thigh_r", "shin_r", "foot_r"]
BI = {n: i for i, n in enumerate(BONES)}

# osso do MakeHuman -> osso(s) do jogo; os não listados herdam do pai
MAP = {
    "root": "hips", "spine05": "hips", "spine04": "hips", "pelvis.L": "hips", "pelvis.R": "hips",
    "spine03": "spine", "spine02": "spine",
    "spine01": "chest", "clavicle.L": "chest", "clavicle.R": "chest", "breast.L": "chest", "breast.R": "chest",
    "shoulder01.L": [("chest", 0.3), ("upperarm_l", 0.7)], "shoulder01.R": [("chest", 0.3), ("upperarm_r", 0.7)],
    "upperarm01.L": "upperarm_l", "upperarm02.L": "upperarm_l", "upperarm01.R": "upperarm_r", "upperarm02.R": "upperarm_r",
    "lowerarm01.L": "forearm_l", "lowerarm02.L": "forearm_l", "lowerarm01.R": "forearm_r", "lowerarm02.R": "forearm_r",
    "wrist.L": "hand_l", "wrist.R": "hand_r",
    "neck01": "neck", "neck02": "neck", "neck03": "neck", "head": "head", "jaw": "jaw",
    "upperleg01.L": "thigh_l", "upperleg02.L": "thigh_l", "upperleg01.R": "thigh_r", "upperleg02.R": "thigh_r",
    "lowerleg01.L": "shin_l", "lowerleg02.L": "shin_l", "lowerleg01.R": "shin_r", "lowerleg02.R": "shin_r",
    "foot.L": "foot_l", "foot.R": "foot_r",
}

# ---------------------------------------------------------------------------
# Receitas
# ---------------------------------------------------------------------------
# macro: g (0 mulher .. 1 homem), age (anos), muscle/weight (0..1, 0,5 = médio),
# race: proporções african/asian/caucasian. height: altura do corpo sem calçado (m).
# clothes: assets .mhclo (roupas, calçados, barba, chapéus, óculos), na ordem de baixo
# para cima. tint: cor multiplicada por peça (o shader ainda varia por instância).
RECIPES = {}

# peles extras (1024 px) trocadas por pessoa em tempo de jogo (mesmo mapa UV)
SKINS_M = ["young_caucasian_male", "young_african_male", "young_asian_male", "middleage_caucasian_male",
           "mindfront_skin_male_african_middleage", "middleage_asian_male", "old_caucasian_male", "old_african_male"]
SKINS_F = ["young_caucasian_female", "young_african_female", "young_asian_female", "middleage_caucasian_female",
           "middleage_african_female", "middleage_asian_female", "old_caucasian_female"]

# peças claras/neutras que aceitam a cor da pessoa (slot 0 = cima, 1 = baixo, 2 = calçado)
TINT = {"elvs_crude_t-shirt_male": 0, "joepal_crude_t-shirt_female": 0, "toigo_basic_tucked_t-shirt": 0,
        "namuhekam_male_polo_shirt": 0, "mindfront_knitted_sweater_01": 0, "mindfront_knitted_sweater_02": 0,
        "toigo_wool_pants": 1, "cortu_cargo_pants": 1, "shoes05": 2, "shoes06": 2}
LABCOAT = {"desat": 1.0, "bright": 1.0, "base_tint": [0.96, 0.97, 0.98], "flatten": 0.92, "flat_color": [0.78, 0.79, 0.8]}
HOSPITAL = {"desat": 1.0, "bright": 1.0, "base_tint": [1.0, 1.0, 1.0], "flatten": 0.85, "flat_color": [0.42, 0.6, 0.64]}


def R(cid, g, age, height, skin, hair, clothes, **kw):
    r = {"g": g, "age": age, "muscle": 0.5, "weight": 0.5, "height": height, "skin": skin, "hair": hair,
         "clothes": clothes, "race": {"caucasian": 0.6, "african": 0.25, "asian": 0.15},
         "eyes": "brown", "eyebrows": "eyebrow001" if g > 0.5 else "eyebrow010",
         "eyelashes": "eyelashes01" if g > 0.5 else "eyelashes02"}
    r.update(kw)
    RECIPES[cid] = r
    return r


R("caio", 1.0, 31, 1.79, "toigo_light_skin_male_bronze", "culturalibre_hair_02",
  ["male_casualsuit05", "toigo_ankle_boots_male"], muscle=0.64, weight=0.47,
  race={"caucasian": 0.55, "african": 0.3, "asian": 0.15}, skin_tone=(0.98, 0.95, 0.93), stubble=0.7,
  tex_size={"skin": 2048, "male_casualsuit05": 2048}, params={"male_casualsuit05": {"desat": 0.3}},
  backpack=True, grime=0.3,
  # rosto marcado de sobrevivente: mandíbula e maçãs fortes, nariz com
  # calombo, sobrancelha baixa e cansaço nos olhos
  face={"chin/chin-width-incr": 0.35, "chin/chin-prominent-incr": 0.3, "head/head-square": 0.45,
        "cheek/l-cheek-bones-incr": 0.45, "cheek/r-cheek-bones-incr": 0.45, "cheek/l-cheek-volume-decr": 0.3,
        "cheek/r-cheek-volume-decr": 0.3, "nose/nose-hump-incr": 0.35, "nose/nose-scale-vert-incr": 0.15,
        "eyebrows/eyebrows-trans-down": 0.4, "eyebrows/eyebrows-trans-forward": 0.35, "eyes/l-eye-bag-incr": 0.35,
        "eyes/r-eye-bag-incr": 0.35, "eyes/l-eye-eyefold-down": 0.3, "eyes/r-eye-eyefold-down": 0.3,
        "mouth/mouth-upperlip-volume-decr": 0.25, "neck/neck-scale-horiz-incr": 0.2},
  expr={"eyebrows-left-down": 0.2, "eyebrows-right-down": 0.2, "mouth-compression": 0.12,
        "eye-left-slit": 0.1, "eye-right-slit": 0.1})
R("helena", 0.0, 38, 1.66, "young_caucasian_female", "rehmanpolanski_hair_bun_brown",
  ["toigo_basic_tucked_t-shirt", "toigo_wool_pants", "shoes06", "mindfront_cardigan_long_open_front",
   "frankyaye_glasses_library_male"], muscle=0.42, weight=0.42, eyes="green",
  race={"caucasian": 0.9, "asian": 0.1}, tex_size={"skin": 2048},
  params={"mindfront_cardigan_long_open_front": LABCOAT})
# civis
R("civ_m1", 1.0, 28, 1.78, "young_caucasian_male", "culturalibre_hair_05", ["male_casualsuit06", "shoes05"], muscle=0.55)
R("civ_m2", 1.0, 36, 1.75, "young_african_male", "short03", ["male_casualsuit03", "shoes02"], weight=0.55,
  race={"african": 0.7, "caucasian": 0.3})
R("civ_m3", 1.0, 57, 1.72, "old_caucasian_male", "short04", ["namuhekam_male_polo_shirt", "toigo_wool_pants", "shoes01"],
  weight=0.7, muscle=0.4, eyes="grey")
R("civ_m4", 1.0, 24, 1.82, "young_african_male", "afro01", ["mindfront_knitted_sweater_01", "cortu_cargo_pants", "shoes03"],
  race={"african": 0.85, "caucasian": 0.15}, muscle=0.6, weight=0.4)
R("civ_m5", 1.0, 44, 1.76, "middleage_caucasian_male", "cortu_short_messy_hair", ["male_worksuit01", "toigo_ankle_boots_male"],
  muscle=0.7, weight=0.62)
R("civ_m6", 1.0, 47, 1.8, "middleage_caucasian_male", "short01", ["male_elegantsuit01", "shoes04"], weight=0.58)
R("civ_m7", 1.0, 31, 1.74, "young_asian_male", "short03", ["elvs_crude_t-shirt_male", "cortu_cargo_pants", "shoes06"],
  race={"asian": 0.8, "caucasian": 0.2}, weight=0.45)
R("civ_f1", 0.0, 26, 1.65, "young_caucasian_female", "elvs_daisy_hair", ["joepal_crude_t-shirt_female", "toigo_wool_pants", "shoes06"],
  weight=0.45)
R("civ_f2", 0.0, 41, 1.68, "middleage_caucasian_female", "elvs_katherine_hair", ["female_elegantsuit01", "toigo_ankle_boots_female"],
  weight=0.5, eyes="blue")
R("civ_f3", 0.0, 33, 1.63, "young_african_female", "ponytail01", ["toigo_fisherman_sweater", "toigo_wool_pants", "toigo_ankle_boots_female"],
  race={"african": 0.75, "caucasian": 0.25}, weight=0.55)
R("civ_f4", 0.0, 22, 1.6, "young_asian_female", "braid01", ["mindfront_knitted_sweater_02", "toigo_wool_pants", "shoes05"],
  race={"asian": 0.85, "caucasian": 0.15}, weight=0.4)
R("civ_f5", 0.0, 68, 1.58, "old_caucasian_female", "ponytail01", ["janexx_old_female_sweater", "toigo_wool_pants", "shoes01"],
  weight=0.62, muscle=0.35, eyes="grey")
# pesquisadores, paciente, polícia, sobreviventes
R("researcher_m", 1.0, 45, 1.77, "middleage_caucasian_male", "culturalibre_hair_05",
  ["elvs_male_shirt_tie_tucked1", "toigo_wool_pants", "shoes04", "mindfront_cardigan_long_open_front",
   "frankyaye_glasses_library_male"], weight=0.55, params={"mindfront_cardigan_long_open_front": LABCOAT})
R("researcher_f", 0.0, 34, 1.64, "young_asian_female", "ponytail01",
  ["toigo_basic_tucked_t-shirt", "toigo_wool_pants", "shoes06", "mindfront_cardigan_long_open_front"],
  race={"asian": 0.6, "caucasian": 0.4}, weight=0.42, params={"mindfront_cardigan_long_open_front": LABCOAT})
R("patient", 1.0, 30, 1.76, "young_caucasian_male", "short04", ["toigo_basic_tucked_t-shirt", "toigo_wool_pants"],
  weight=0.4, muscle=0.45, mat_alias={"toigo_basic_tucked_t-shirt": "hospital_top", "toigo_wool_pants": "hospital_pants"},
  params={"hospital_top": HOSPITAL, "hospital_pants": HOSPITAL})
R("police", 1.0, 38, 1.81, "middleage_caucasian_male", "culturalibre_hair_02", ["elvs_male_shirt_untucked_bd1", "cortu_cargo_pants", "shoes03"],
  muscle=0.68, weight=0.55, mat_alias={"elvs_male_shirt_untucked_bd1": "police_shirt", "cortu_cargo_pants": "police_pants"},
  params={"police_shirt": {"desat": 1.0, "bright": 1.0, "flatten": 0.6, "flat_color": [0.12, 0.16, 0.27]},
          "police_pants": {"desat": 1.0, "bright": 1.0, "flatten": 0.6, "flat_color": [0.08, 0.09, 0.12]}})
R("survivor_m", 1.0, 34, 1.78, "middleage_caucasian_male", "cortu_short_messy_hair",
  ["mindfront_knitted_sweater_01", "cortu_cargo_pants", "toigo_ankle_boots_male"], muscle=0.62, weight=0.45,
  backpack=True)
R("survivor_f", 0.0, 29, 1.66, "young_caucasian_female", "elvs_unkempt_french_braid",
  ["toigo_fisherman_sweater", "cortu_cargo_pants", "toigo_ankle_boots_female"], muscle=0.55, weight=0.4,
  backpack=True)
R("child_f", 0.0, 9, 1.32, "young_caucasian_female", "ponytail01",
  ["mindfront_knitted_sweater_02", "toigo_wool_pants", "shoes06"], weight=0.45, backpack=True)
R("child_m", 1.0, 10, 1.38, "young_caucasian_male", "short03",
  ["elvs_crude_t-shirt_male", "cortu_cargo_pants", "shoes05"], weight=0.45)


def Z(cid, base, **kw):
    """Infectado a partir de um civil: mantém a pele sob a roupa (aparece pelos rasgos)."""
    r = dict(RECIPES[base])
    r.pop("backpack", None)
    r.pop("face", None)
    r["keep_body"] = True
    # rosto de infectado: encovado, tendões do pescoço tensos, narinas abertas,
    # lábio repuxado e o olhar parado
    r["gaunt"] = 0.9
    r["expr"] = {"neck-platysma": 0.75, "mouth-depression-retraction": 0.3, "mouth-upward-retraction": 0.22,
                 "nose-left-dilatation": 0.35, "nose-right-dilatation": 0.35, "eye-left-opened-up": 0.2,
                 "eye-right-opened-up": 0.2, "mouth-open": 0.1}
    r.update(kw)
    RECIPES[cid] = r


Z("z_m1", "civ_m1")
Z("z_m2", "civ_m2")
Z("z_m3", "civ_m3")
Z("z_m4", "civ_m5")
Z("z_m5", "patient")
Z("z_m6", "police")
Z("z_m7", "civ_m6")
Z("z_f1", "civ_f1")
Z("z_f2", "civ_f3")
Z("z_f3", "researcher_f")
Z("z_f4", "civ_f2")
Z("z_brute", "civ_m5", muscle=1.0, weight=1.0, height=2.02, age=40, plates=1.0, growths=0.6)
Z("z_host", "civ_m2", growths=1.0, hair=None)
Z("z_crawler", "civ_f1", muscle=0.15, weight=0.1, height=1.6)

# ---------------------------------------------------------------------------
# Leitura dos formatos do MakeHuman
# ---------------------------------------------------------------------------
_index = {}


def asset_dir(name):
    """Pasta de um asset (.mhclo/.mhmat/.png) pelo nome, procurando em sys/ e packs/."""
    if not _index:
        for base in ("sys", "packs"):
            for dp, dn, fn in os.walk(os.path.join(MH, base)):
                for f in fn:
                    if f.endswith((".mhclo", ".mhmat")):
                        _index.setdefault(os.path.splitext(f)[0], dp)
                        _index.setdefault(os.path.basename(dp), dp)
    if name not in _index:
        raise SystemExit("asset não encontrado: " + name)
    return _index[name]


def load_obj(path):
    vs, vts, faces, groups = [], [], [], []
    g = ""
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            if line.startswith("v "):
                vs.append([float(x) for x in line.split()[1:4]])
            elif line.startswith("vt "):
                p = line.split()
                vts.append([float(p[1]), float(p[2])])
            elif line.startswith("g "):
                g = line[2:].strip()
            elif line.startswith("f "):
                vi, ti = [], []
                for tok in line.split()[1:]:
                    a = tok.split("/")
                    vi.append(int(a[0]) - 1)
                    ti.append(int(a[1]) - 1 if len(a) > 1 and a[1] else -1)
                faces.append((vi, ti))
                groups.append(g)
    return np.array(vs, np.float64), np.array(vts, np.float64) if vts else np.zeros((0, 2)), faces, groups


def load_target(path):
    idx, d = [], []
    with open(path) as f:
        for line in f:
            if line[:1] in "#\n" or not line.strip():
                continue
            p = line.split()
            idx.append(int(p[0]))
            d.append([float(p[1]), float(p[2]), float(p[3])])
    return np.array(idx, np.int64), np.array(d, np.float64).reshape(-1, 3)


def parse_mhmat(path):
    m = {"dir": os.path.dirname(path)}
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            p = line.strip().split(None, 1)
            if len(p) == 2 and not p[0].startswith("#"):
                m[p[0]] = p[1].strip()
    return m


def parse_mhclo(name):
    d = asset_dir(name)
    path = os.path.join(d, name + ".mhclo")
    if not os.path.exists(path):
        cands = [f for f in os.listdir(d) if f.endswith(".mhclo")]
        path = os.path.join(d, cands[0])
    clo = {"name": name, "dir": d, "refs": [], "w": [], "off": [], "delete": set(), "scale": {}}
    mode = ""
    with open(path, encoding="utf-8", errors="replace") as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith("#"):
                continue
            p = s.split()
            key = p[0]
            if key in ("x_scale", "y_scale", "z_scale"):
                clo["scale"]["xyz".index(key[0])] = (int(p[1]), int(p[2]), float(p[3]))
                continue
            if key == "name":
                clo["title"] = s.split(None, 1)[1] if len(p) > 1 else ""
                continue
            if key in ("obj_file", "material", "z_depth", "uuid", "tag", "basemesh", "author",
                       "license", "homepage", "description", "max_pole", "special_pose", "offset_scale"):
                clo[key] = s.split(None, 1)[1] if len(p) > 1 else ""
                continue
            if key == "verts":
                mode = "verts"
                continue
            if key == "delete_verts":
                mode = "delete"
                continue
            if key in ("weights", "shapekeys", "texco", "faces", "vertexgroups"):
                mode = "skip"
                continue
            if mode == "verts":
                if len(p) >= 9:
                    clo["refs"].append([int(p[0]), int(p[1]), int(p[2])])
                    clo["w"].append([float(p[3]), float(p[4]), float(p[5])])
                    clo["off"].append([float(p[6]), float(p[7]), float(p[8])])
                elif len(p) == 1:
                    clo["refs"].append([int(p[0])] * 3)
                    clo["w"].append([1.0, 0.0, 0.0])
                    clo["off"].append([0.0, 0.0, 0.0])
            elif mode == "delete":
                i = 0
                while i < len(p):
                    if i + 2 < len(p) and p[i + 1] == "-":
                        clo["delete"].update(range(int(p[i]), int(p[i + 2]) + 1))
                        i += 3
                    else:
                        clo["delete"].add(int(p[i]))
                        i += 1
    clo["refs"] = np.array(clo["refs"], np.int64)
    clo["w"] = np.array(clo["w"], np.float64)
    clo["off"] = np.array(clo["off"], np.float64)
    vs, vts, faces, _ = load_obj(os.path.join(d, clo.get("obj_file", name + ".obj")))
    clo["vts"], clo["faces"], clo["nverts"] = vts, faces, len(vs)
    if len(vs) != len(clo["refs"]):
        raise SystemExit("%s: %d vértices no obj, %d no mhclo" % (name, len(vs), len(clo["refs"])))
    mat = clo.get("material", name + ".mhmat")
    mp = os.path.join(d, mat)
    clo["mat"] = parse_mhmat(mp) if os.path.exists(mp) else {"dir": d}
    return clo


def fit_proxy(clo, V):
    P = (V[clo["refs"]] * clo["w"][:, :, None]).sum(1)
    sc = np.ones(3)
    for ax, (a, b, den) in clo["scale"].items():
        sc[ax] = abs(V[a][ax] - V[b][ax]) / den
    return P + clo["off"] * sc


# ---------------------------------------------------------------------------
# Corpo: alvos macro
# ---------------------------------------------------------------------------
def _tri(v, names):
    """Peso dos alvos min/média/máx para um valor 0..1 (0,5 = média)."""
    lo, av, hi = names
    if v < 0.5:
        return {lo: 1.0 - v / 0.5, av: v / 0.5}
    return {av: 1.0 - (v - 0.5) / 0.5, hi: (v - 0.5) / 0.5}


def macro_targets(r):
    g = float(r["g"])
    gw = {"female": 1.0 - g, "male": g}
    years = float(r["age"])
    a = 0.5 + (years - 25.0) / 130.0 if years >= 25 else 0.1875 + (years - 11.0) / 14.0 * 0.3125
    a = min(max(a, 0.1875), 1.0)
    if a < 0.5:
        aw = {"child": 1.0 - (a - 0.1875) / 0.3125, "young": (a - 0.1875) / 0.3125}
    else:
        aw = {"young": 1.0 - (a - 0.5) / 0.5, "old": (a - 0.5) / 0.5}
    mw = _tri(float(r["muscle"]), ("minmuscle", "averagemuscle", "maxmuscle"))
    ww = _tri(float(r["weight"]), ("minweight", "averageweight", "maxweight"))
    out = []
    for gk, gv in gw.items():
        for ak, av in aw.items():
            for mk, mv in mw.items():
                for wk, wv in ww.items():
                    w = gv * av * mv * wv
                    if w > 1e-4:
                        out.append(("macrodetails/universal-%s-%s-%s-%s.target" % (gk, ak, mk, wk), w))
            for rk, rv in r["race"].items():
                w = gv * av * rv
                if w > 1e-4:
                    out.append(("macrodetails/%s-%s-%s.target" % (rk, gk, ak), w))
    return out


def _pair(name, w):
    """Alvo simétrico (l-/r-): o mesmo peso dos dois lados."""
    grp, rest = name.split("/", 1)
    return [("%s/l-%s" % (grp, rest), w), ("%s/r-%s" % (grp, rest), w)]


def _signed(base, v):
    """base-incr/-decr (ou -up/-down, -in/-out...) a partir de um valor com sinal."""
    if isinstance(base, tuple):
        pos, neg = base
    else:
        pos, neg = base + "-incr", base + "-decr"
    return [(pos if v >= 0 else neg, abs(v))] if abs(v) > 1e-3 else []


# Rosto: o MakeHuman sem detalhe dá rostos lisos e iguais. Cada pessoa ganha um
# rosto próprio (formato da cabeça, queixo, maçãs, nariz, lábios, olhos,
# sobrancelha, orelhas, um pouco de assimetria), estável pela semente do id,
# com a idade marcando olheiras e bochechas; "face" na receita sobrepõe e
# "expr" aplica unidades de expressão (misturadas pela origem étnica).
def face_targets(cid, r):
    rng = np.random.default_rng(abs(hash_str(cid)) % (2 ** 32))
    g = float(r["g"])
    age = float(r["age"])
    old = min(max((age - 30.0) / 40.0, 0.0), 1.0)
    out = []
    u = lambda a=0.35: float(rng.uniform(-a, a))
    shapes = ["head/head-oval", "head/head-round", "head/head-square", "head/head-rectangular", "head/head-diamond",
              "head/head-invertedtriangular"]
    sh = shapes[int(rng.integers(0, len(shapes)))]
    if g > 0.5 and rng.random() < 0.5:
        sh = "head/head-square"
    out.append((sh, float(rng.uniform(0.2, 0.5))))
    out += _signed("chin/chin-width", u() + 0.15 * g)
    out += _signed("chin/chin-prominent", u(0.3) + 0.1 * g)
    out += _signed("chin/chin-height", u(0.25))
    out += _signed("chin/chin-cleft", max(0.0, u(0.4)) * g)
    out += _pair("cheek/cheek-bones-incr", float(rng.uniform(0.1, 0.45)))
    for n, w in _signed("cheek/l-cheek-volume", u(0.3) - 0.35 * old - 0.3 * float(r.get("gaunt", 0.0))):
        out += [(n, w), (n.replace("/l-", "/r-"), w)]
    out += _signed("nose/nose-hump", u(0.4) + 0.1 * g)
    out += _signed("nose/nose-scale-horiz", u(0.3))
    out += _signed("nose/nose-scale-vert", u(0.3) + 0.08 * old)
    out += _signed("nose/nose-point-width", u(0.3))
    out += _signed(("nose/nose-base-up", "nose/nose-base-down"), u(0.3))
    out += _signed("nose/nose-nostrils-width", u(0.3))
    out += _signed("mouth/mouth-upperlip-volume", u(0.35) - 0.2 * g - 0.2 * old)
    out += _signed("mouth/mouth-lowerlip-volume", u(0.35) - 0.1 * g - 0.15 * old)
    out += _signed("mouth/mouth-scale-horiz", u(0.25))
    out += _signed(("mouth/mouth-angles-up", "mouth/mouth-angles-down"), u(0.2) - 0.15 * old)
    out += _signed(("mouth/mouth-laugh-lines-out", "mouth/mouth-laugh-lines-in"), 0.2 + 0.5 * old)
    out += _pair("eyes/eye-bag-incr", float(rng.uniform(0.05, 0.25)) + 0.5 * old)
    out += _pair("eyes/eye-eyefold-down", float(rng.uniform(0.0, 0.3)) + 0.3 * old)
    for n, w in _signed(("eyes/l-eye-height2-incr", "eyes/l-eye-height2-decr"), u(0.25)):
        out += [(n, w), (n.replace("/l-", "/r-"), w)]
    out += _signed(("eyebrows/eyebrows-trans-down", "eyebrows/eyebrows-trans-up"), 0.15 * g + u(0.2))
    out += _signed(("eyebrows/eyebrows-trans-forward", "eyebrows/eyebrows-trans-backward"), 0.2 * g + u(0.15))
    out += _signed(("forehead/forehead-temple-decr", "forehead/forehead-temple-incr"), 0.2 * old + u(0.2))
    out += _pair("ears/ear-flap-incr", max(0.0, u(0.4)))
    out += _pair("ears/ear-lobe-incr", max(0.0, u(0.3)) + 0.3 * old)
    out += _signed(("neck/neck-double-incr", "neck/neck-double-decr"), (float(r.get("weight", 0.5)) - 0.5) * 0.8 + 0.2 * old)
    # assimetria: ninguém tem as duas metades iguais
    asym = ["asym-brown-1", "asym-cheek-1", "asym-eye-2", "asym-jaw-1", "asym-mouth-1", "asym-nose-2", "asym-temple-1"]
    for k in rng.choice(len(asym), 4, replace=False):
        out.append(("asym/%s-%s.target" % (asym[int(k)], "l" if rng.random() < 0.5 else "r"), float(rng.uniform(0.2, 0.55))))
    over = dict((k, v) for k, v in r.get("face", {}).items())
    if over:
        opp = [("-incr", "-decr"), ("-up", "-down"), ("-in", "-out"), ("-forward", "-backward")]
        keep = {}
        for n, w in out:
            keep[n] = w
        for n, w in over.items():
            for a_, b_ in opp:
                for x, y in ((a_, b_), (b_, a_)):
                    if n.endswith(x):
                        keep.pop(n[: -len(x)] + y, None)
            keep[n] = w
        out = list(keep.items())
    # expressões (unidades por origem: caucasian/african/asian)
    for unit, w in r.get("expr", {}).items():
        for race, rw in r["race"].items():
            if rw > 1e-3:
                out.append(("expression/units/%s/%s" % (race, unit), w * rw))
    res = []
    for n, w in out:
        if not n.endswith(".target"):
            n += ".target"
        res.append((n, w))
    return res


def hash_str(s):
    h = 2166136261
    for ch in s.encode():
        h = ((h ^ ch) * 16777619) & 0xFFFFFFFF
    return h


def body_coords(r, cid=""):
    V, _, _, _ = BASE
    V = V.copy()
    face = face_targets(cid, r) if cid and not r.get("no_face") else []
    for rel, w in macro_targets(r) + face:
        p = os.path.join(MH, "data", "targets", rel)
        if not os.path.exists(p):
            print("  (sem alvo %s)" % rel)
            continue
        idx, d = load_target(p)
        if len(idx):
            V[idx] += d * w
    for rel, w in r.get("targets", []):
        idx, d = load_target(os.path.join(MH, "data", "targets", rel))
        V[idx] += d * w
    return V


# ---------------------------------------------------------------------------
# Esqueleto e pesos
# ---------------------------------------------------------------------------
def load_rig():
    sk = json.load(open(os.path.join(MH, "data", "rigs", "default.mhskel")))
    wt = json.load(open(os.path.join(MH, "data", "rigs", "default_weights.mhw")))["weights"]
    return sk, wt


def game_weights(nv):
    """Pesos (nv x 18) dos vértices da malha base nos ossos do jogo."""
    sk, wt = RIG
    bones = sk["bones"]

    def target(b):
        while b not in MAP:
            b = bones[b]["parent"]
        m = MAP[b]
        return [(m, 1.0)] if isinstance(m, str) else m

    W = np.zeros((nv, len(BONES)))
    for b, lst in wt.items():
        if b not in bones:
            continue
        arr = np.array(lst, np.float64).reshape(-1, 2)
        vi = arr[:, 0].astype(np.int64)
        for gname, frac in target(b):
            np.add.at(W[:, BI[gname]], vi, arr[:, 1] * frac)
    s = W.sum(1)
    bad = s < 1e-6
    W[bad, BI["hips"]] = 1.0
    return W / W.sum(1, keepdims=True)


def joint_pos(V, name):
    sk, _ = RIG
    return V[sk["joints"][name]].mean(0)


def bone_head(V, b):
    sk, _ = RIG
    return joint_pos(V, sk["bones"][b]["head"])


# ---------------------------------------------------------------------------
# Pose de descanso (braços pendurados, pernas fechadas)
# ---------------------------------------------------------------------------
def rot_between(a, b):
    a = a / np.linalg.norm(a)
    b = b / np.linalg.norm(b)
    v = np.cross(a, b)
    c = float(np.dot(a, b))
    if np.linalg.norm(v) < 1e-9:
        return np.eye(3)
    vx = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
    return np.eye(3) + vx + vx @ vx * (1.0 / (1.0 + c))


def affine(R, pivot):
    M = np.eye(4)
    M[:3, :3] = R
    M[:3, 3] = pivot - R @ pivot
    return M


def rest_pose(V):
    """Matrizes 4x4 (espaço MH) por osso do jogo que levam da pose em A à de descanso."""
    M = [np.eye(4) for _ in BONES]
    J = {}
    for side, sx in (("L", 1.0), ("R", -1.0)):
        sfx = "_l" if side == "L" else "_r"
        s = bone_head(V, "upperarm01." + side)
        e = bone_head(V, "lowerarm01." + side)
        w = bone_head(V, "wrist." + side)
        abd = math.radians(5.0)
        tgt_u = np.array([sx * math.sin(abd), -math.cos(abd), -0.02])
        Ru = rot_between(e - s, tgt_u)
        Mu = affine(Ru, s)
        e2 = s + Ru @ (e - s)
        w2 = e2 + Ru @ (w - e)
        tgt_f = np.array([sx * math.sin(abd + math.radians(1.5)), -math.cos(abd + math.radians(1.5)), 0.06])
        Rf = rot_between(w2 - e2, tgt_f)
        Mf = affine(Rf, e2) @ Mu
        M[BI["upperarm" + sfx]] = Mu
        M[BI["forearm" + sfx]] = Mf
        M[BI["hand" + sfx]] = Mf
        # pernas: tornozelo a ~11 cm do centro (pose em A tem as pernas abertas)
        h = bone_head(V, "upperleg01." + side)
        a = bone_head(V, "foot." + side)
        tgt_l = np.array([sx * 1.18, a[1], a[2]]) - h
        Rl = rot_between(a - h, tgt_l)
        Ml = affine(Rl, h)
        for b in ("thigh", "shin", "foot"):
            M[BI[b + sfx]] = Ml
    return M


def skin(P, W, M):
    out = np.zeros_like(P)
    Ph = np.c_[P, np.ones(len(P))]
    for b in range(len(BONES)):
        wb = W[:, b]
        if not np.any(wb > 0):
            continue
        out += wb[:, None] * (Ph @ M[b].T)[:, :3]
    return out


def apply_m(M, p):
    return (M @ np.r_[p, 1.0])[:3]


# ---------------------------------------------------------------------------
# Geometria de saída
# ---------------------------------------------------------------------------
def smooth_normals(P, tris):
    n = np.zeros_like(P)
    a, b, c = P[tris[:, 0]], P[tris[:, 1]], P[tris[:, 2]]
    fn = np.cross(b - a, c - a)
    for k in range(3):
        np.add.at(n, tris[:, k], fn)
    ln = np.linalg.norm(n, axis=1, keepdims=True)
    ln[ln < 1e-12] = 1.0
    return n / ln


def triangulate(faces, keep=None):
    """faces [(vi, ti)] -> listas de triângulos (vi x3, ti x3)."""
    tv, tt = [], []
    for k, (vi, ti) in enumerate(faces):
        if keep is not None and not keep[k]:
            continue
        for i in range(1, len(vi) - 1):
            tv.append([vi[0], vi[i], vi[i + 1]])
            tt.append([ti[0], ti[i], ti[i + 1]])
    return np.array(tv, np.int64).reshape(-1, 3), np.array(tt, np.int64).reshape(-1, 3)


def make_surface(name, mat, P, N, W, vts, tv, tt, color=None):
    """Separa vértices por (posição, uv) e devolve o dicionário da superfície."""
    if len(tv) == 0:
        return None
    key = tv.reshape(-1) * (len(vts) + 1) + (tt.reshape(-1) + 1)
    uniq, inv = np.unique(key, return_inverse=True)
    vi = uniq // (len(vts) + 1)
    ti = uniq % (len(vts) + 1) - 1
    uv = np.where(ti[:, None] >= 0, vts[np.maximum(ti, 0)], 0.0)
    uv = np.c_[uv[:, 0], 1.0 - uv[:, 1]]
    w = W[vi]
    order = np.argsort(-w, axis=1)[:, :4]
    wb = np.take_along_axis(w, order, 1)
    wb = wb / np.maximum(wb.sum(1, keepdims=True), 1e-9)
    col = np.ones((len(vi), 4)) if color is None else color[vi]
    return {"name": name, "mat": mat, "pos": P[vi], "nrm": N[vi], "uv": uv, "bones": order.astype(np.int32),
            "weights": wb, "color": col, "idx": inv.reshape(-1, 3)[:, ::-1].reshape(-1).astype(np.int32),
            "src": vi}


# ---------------------------------------------------------------------------
# Máscaras por vértice (cor): R sangue, G sujeira, B rasgo/ferida, A livre.
# O shader multiplica pela quantidade de cada instância (infectado, sobrevivente
# sujo…) e recorta com a textura de detalhe; aqui só se diz ONDE cada coisa pega.
# ---------------------------------------------------------------------------
def vnoise(P, freq, seed=0):
    p = P * freq + seed * 17.13
    i = np.floor(p)
    f = p - i
    f = f * f * (3 - 2 * f)

    def h(o):
        q = i + o
        return np.modf(np.sin(q @ np.array([12.9898, 78.233, 37.719]) + seed) * 43758.5453)[0] % 1.0

    c = [[[h(np.array([x, y, z], float)) for z in (0, 1)] for y in (0, 1)] for x in (0, 1)]
    fx, fy, fz = f[:, 0], f[:, 1], f[:, 2]

    def lerp(a, b, t):
        return a + (b - a) * t

    x00 = lerp(c[0][0][0], c[1][0][0], fx)
    x10 = lerp(c[0][1][0], c[1][1][0], fx)
    x01 = lerp(c[0][0][1], c[1][0][1], fx)
    x11 = lerp(c[0][1][1], c[1][1][1], fx)
    return lerp(lerp(x00, x10, fy), lerp(x01, x11, fy), fz)


def boundary_dist(P, tris):
    """Distância (m) de cada vértice até a borda aberta mais próxima da malha
    (barra da calça, punho, gola): rasgos e sujeira começam por ali."""
    from scipy.spatial import cKDTree
    e = np.sort(np.r_[tris[:, [0, 1]], tris[:, [1, 2]], tris[:, [2, 0]]], axis=1)
    # junta vértices na mesma posição (costuras de UV não são bordas)
    _, inv = np.unique(np.round(P, 5), axis=0, return_inverse=True)
    inv = inv.reshape(-1)
    e = np.sort(inv[e], axis=1)
    e = e[e[:, 0] != e[:, 1]]
    u, cnt = np.unique(e, axis=0, return_counts=True)
    bv = np.unique(u[cnt == 1].reshape(-1))
    if len(bv) == 0:
        return np.full(len(P), 9.0)
    rep = np.zeros(inv.max() + 1, np.int64)
    rep[inv] = np.arange(len(P))
    d, _ = cKDTree(P[rep[bv]]).query(P)
    return d


def bake_masks(sf, J, mouth, kind, seed, eyes=()):
    P, N = sf["pos"], sf["nrm"]
    n = len(P)
    col = np.zeros((n, 4))
    col[:, 3] = 1.0
    if kind in ("eyes", "brow", "teeth"):
        sf["color"] = col
        return
    y = P[:, 1]
    front = np.clip(-N[:, 2] * 1.5 + 0.2, 0, 1)
    # sangue: boca/queixo, escorrido pela frente do peito, mãos e respingos
    dm = np.linalg.norm(P - mouth, axis=1)
    chin = mouth + np.array([0.012, -0.04, 0.005])
    b = np.exp(-(np.linalg.norm((P - chin) * [1.3, 0.8, 1.0], axis=1) / 0.04) ** 2) * 1.05
    b = np.maximum(b, np.exp(-(np.linalg.norm((P - mouth) * [0.8, 2.2, 1.0], axis=1) / 0.03) ** 2) * 0.55)
    # escorrido: do queixo para baixo, em filetes estreitos pela frente
    below = np.clip((mouth[1] - y) / 0.6, 0, 1)
    streak = np.clip((vnoise(np.c_[P[:, 0] * 14.0, y * 0.5, P[:, 2] * 3.0], 3.0, seed) - 0.35) * 1.8, 0, 1) ** 1.5
    drip = (1.0 - below) ** 1.5 * front * (np.abs(P[:, 0] - mouth[0]) < 0.14) * streak * 1.3 * (y < mouth[1] - 0.01)
    b = np.maximum(b, drip)
    for h in (J[BI["hand_l"]], J[BI["hand_r"]]):
        b = np.maximum(b, np.exp(-(np.linalg.norm(P - h + [0, 0.05, 0], axis=1) / 0.07) ** 2) * 0.75)
    spl = np.clip((vnoise(P, 6.0, seed + 3) - 0.66) * 3.0, 0, 1)
    b = np.maximum(b, spl * 0.7)
    # sujeira: canela e pés, joelhos, mãos, barras; manchas espalhadas
    g = np.clip((0.62 - y) / 0.55, 0, 1) ** 1.3
    for k in (J[BI["shin_l"]], J[BI["shin_r"]]):
        g = np.maximum(g, np.exp(-(np.linalg.norm(P - k, axis=1) / 0.12) ** 2) * front)
    for h in (J[BI["hand_l"]], J[BI["hand_r"]]):
        g = np.maximum(g, np.exp(-(np.linalg.norm(P - h, axis=1) / 0.12) ** 2) * 0.8)
    g = np.maximum(g, np.clip((vnoise(P, 3.0, seed + 5) - 0.45) * 1.8, 0, 1) * 0.7)
    g *= np.where(y > J[BI["neck"]][1], 0.35, 1.0)
    # rasgos (roupa) e feridas (pele)
    if kind == "cloth":
        bd = boundary_dist(P, sf["idx"].reshape(-1, 3))
        t = np.exp(-bd / 0.05) * 0.9
        g = np.maximum(g, np.exp(-bd / 0.07) * 0.7)
        t = np.maximum(t, np.clip((vnoise(P, 4.0, seed + 7) - 0.5) * 2.6, 0, 1))
    elif kind == "body":
        t = np.clip((vnoise(P, 6.0, seed + 9) - 0.62) * 3.0, 0, 1)
        neck = J[BI["neck"]]
        t = np.maximum(t, np.exp(-(np.linalg.norm(P - neck - [0.03, 0, 0], axis=1) / 0.05) ** 2))
        for f in (J[BI["forearm_l"]], J[BI["forearm_r"]]):
            t = np.maximum(t, np.exp(-(np.linalg.norm(P - f, axis=1) / 0.07) ** 2) * 0.8)
    else:
        t = np.zeros(n)
    col[:, 0] = np.clip(b, 0, 1)
    col[:, 1] = np.clip(g, 0, 1)
    col[:, 2] = np.clip(t, 0, 1)
    # alfa da pele: 0,5 neutro; abaixo, olheira (o shader afunda nos infectados);
    # acima, couro cabeludo sob o cabelo (scalp_mask). As duas regiões nunca se
    # tocam, então a interpolação entre vértices não mistura uma com a outra.
    if kind == "body":
        col[:, 3] = 0.5
        if len(eyes):
            o = np.zeros(n)
            for e in eyes:
                o = np.maximum(o, np.exp(-(np.linalg.norm((P - e) * [1.0, 1.25, 1.6], axis=1) / 0.03) ** 2))
            col[:, 3] = 0.5 - 0.5 * np.clip(o * 1.2, 0, 1)
    sf["color"] = col


def scalp_mask(body, hair, J):
    """Quanto cada vértice da pele fica sob o cabelo (0..1): a pele ali é pintada
    da cor do cabelo pelo shader, sem o corte duro na testa e nas têmporas onde
    os cartões de cabelo acabam ou deixam frestas."""
    from scipy.spatial import cKDTree
    P, N = body["pos"], body["nrm"]
    H = hair["pos"]
    T = hair["idx"].reshape(-1, 3)
    # pontos nos triângulos (cartões grandes têm poucos vértices)
    a, b, c = H[T[:, 0]], H[T[:, 1]], H[T[:, 2]]
    pts = [H, (a + b + c) / 3, (a + b) / 2, (b + c) / 2, (c + a) / 2,
           (4 * a + b + c) / 6, (a + 4 * b + c) / 6, (a + b + 4 * c) / 6]
    S = np.concatenate(pts)
    d, k = cKDTree(S).query(P)
    to = S[k] - P
    to /= np.maximum(np.linalg.norm(to, axis=1, keepdims=True), 1e-6)
    above = np.sum(to * N, axis=1)
    s = _sstep(0.03, 0.008, d) * _sstep(-0.15, 0.3, above)
    # só a cabeça (não o pescoço/ombros sob o cabelo comprido)
    s *= _sstep(J[BI["head"]][1] - 0.035, J[BI["head"]][1] + 0.005, P[:, 1])
    # orelhas ficam limpas (coordenadas da malha base do MakeHuman, dm)
    B = BASE[0][body["src"]]
    e = ((np.abs(B[:, 0]) - 0.8) / 0.13) ** 2 + ((B[:, 1] - 7.0) / 0.4) ** 2 + ((B[:, 2] - 0.45) / 0.24) ** 2
    s *= _sstep(0.75, 1.15, e)
    # costeleta termina no meio da orelha (na nuca o cabelo desce mais)
    s *= 1.0 - _sstep(0.1, 0.35, B[:, 2]) * (1.0 - _sstep(6.92, 7.12, B[:, 1]))
    return np.clip(s, 0, 1)


def hair_color(key):
    """Cor média (sRGB 0..1) dos fios na textura do cabelo."""
    path = os.path.join(OUT, "tex", key + "_a.png")
    if not os.path.exists(path):
        return None
    a = np.asarray(Image.open(path).convert("RGBA").resize((256, 256))).astype(np.float32) / 255.0
    w = a[:, :, 3] > 0.5
    if w.sum() < 10:
        return None
    return [round(float(x), 4) for x in a[w, :3].mean(0)]


# ---------------------------------------------------------------------------
# Textura de detalhe (repetível): R respingos, G sujeira, B trama do rasgo, A veias
# ---------------------------------------------------------------------------
def fft_noise(n, beta, rng):
    fx = np.fft.fftfreq(n)[:, None]
    fy = np.fft.fftfreq(n)[None, :]
    f = np.sqrt(fx * fx + fy * fy)
    f[0, 0] = 1.0
    amp = f ** (-beta)
    amp[0, 0] = 0.0
    ph = rng.uniform(0, 2 * np.pi, (n, n))
    img = np.real(np.fft.ifft2(amp * np.exp(1j * ph)))
    img = (img - img.mean()) / (img.std() + 1e-9)
    return np.clip(img * 0.18 + 0.5, 0, 1)


def detail_texture(size=1024):
    from scipy.spatial import cKDTree
    rng = np.random.default_rng(4242)
    r = fft_noise(size, 1.2, rng)
    # gotas: discos de tamanhos variados (repetíveis por envolver as bordas)
    yy, xx = np.mgrid[0:size, 0:size]
    for _ in range(140):
        cx, cy = rng.uniform(0, size, 2)
        rad = rng.uniform(2, 14) * size / 1024
        dx = (xx - cx + size / 2) % size - size / 2
        dy = (yy - cy + size / 2) % size - size / 2
        r = np.maximum(r, np.clip(1.2 - np.sqrt(dx * dx + dy * dy) / rad, 0, 1) * 0.95)
    g = fft_noise(size, 1.5, rng) * 0.6 + fft_noise(size, 0.8, rng) * 0.4
    b = fft_noise(size, 1.9, rng) * 0.75 + fft_noise(size, 0.6, rng) * 0.25
    # veias: bordas de células de Voronoi (domínio periódico), afinadas e falhadas
    pts = rng.uniform(0, size, (90, 2))
    tree = cKDTree(pts, boxsize=size)
    q = np.c_[xx.reshape(-1) + 0.5, yy.reshape(-1) + 0.5] % size
    d, _ = tree.query(q, k=2)
    edge = (d[:, 1] - d[:, 0]).reshape(size, size)
    pts2 = rng.uniform(0, size, (380, 2))
    d2, _ = cKDTree(pts2, boxsize=size).query(q, k=2)
    edge2 = (d2[:, 1] - d2[:, 0]).reshape(size, size)
    v = np.maximum(np.clip(1.0 - edge / (3.2 * size / 1024), 0, 1),
                   np.clip(1.0 - edge2 / (1.6 * size / 1024), 0, 1) * 0.7)
    v *= np.clip((fft_noise(size, 1.4, rng) - 0.38) * 3.0, 0, 1)
    img = np.dstack([r, g, b, v])
    os.makedirs(os.path.join(OUT, "tex"), exist_ok=True)
    Image.fromarray((img * 255).astype(np.uint8), "RGBA").save(os.path.join(OUT, "tex", "human_detail_a.png"))
    MATS["human_detail"] = {"kind": "detail", "size": size, "alpha": True, "params": {}, "albedo": "human_detail_a"}


# ---------------------------------------------------------------------------
# Texturas
# ---------------------------------------------------------------------------
MATS = {}
FRESH = set()   # materiais já gerados nesta execução (os do materials.json antigo são refeitos)


def _img(path):
    im = Image.open(path)
    im.load()
    return im


def save_tex(mat, kind, diffuse, normal=None, ao=None, rough=None, size=1024, alpha=False, tint=None,
             params=None, nsize=None):
    """Grava <mat>_a.png e (se houver) <mat>_n.png em src/tex."""
    os.makedirs(os.path.join(OUT, "tex"), exist_ok=True)
    rec = {"kind": kind, "size": size, "alpha": alpha, "params": params or {}}
    if tint is not None:
        rec["params"]["tint"] = list(tint)
    if diffuse is not None:
        im = _img(diffuse)
        has_a = im.mode in ("RGBA", "LA") or (im.mode == "P" and "transparency" in im.info)
        im = im.convert("RGBA")
        if not (alpha and has_a):
            im.putalpha(255)
        im = im.resize((size, size), Image.LANCZOS)
        if alpha and has_a:
            # sangra a cor para dentro das áreas transparentes (sem franja escura no mip)
            im = bleed(im)
        im.save(os.path.join(OUT, "tex", mat + "_a.png"))
        rec["albedo"] = mat + "_a"
    if normal is not None or ao is not None or rough is not None:
        size = nsize or size
        try:
            n = _img(normal).convert("RGB").resize((size, size), Image.LANCZOS) if normal else None
        except Exception:
            # (alguns pacotes da comunidade têm o mapa normal corrompido)
            n = None
        if n is None:
            n = Image.new("RGB", (size, size), (128, 128, 255))
        r, g, _ = n.split()
        b = _img(ao).convert("L").resize((size, size), Image.LANCZOS) if ao else Image.new("L", (size, size), 255)
        if isinstance(rough, (int, float)):
            a = Image.new("L", (size, size), int(rough * 255))
        elif rough is not None:
            a = rough.resize((size, size), Image.LANCZOS)
        else:
            a = Image.new("L", (size, size), 200)
        Image.merge("RGBA", (r, g, b, a)).save(os.path.join(OUT, "tex", mat + "_n.png"))
        rec["normal"] = mat + "_n"
    MATS[mat] = rec
    FRESH.add(mat)
    return rec


def bleed(im):
    a = np.asarray(im).astype(np.float32)
    rgb, al = a[:, :, :3], a[:, :, 3:] / 255.0
    acc = rgb * al
    wa = al.copy()
    # média borrada ponderada pelo alfa preenche os buracos
    blur_rgb = Image.fromarray(np.clip(acc, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(6))
    blur_a = Image.fromarray(np.clip(wa[:, :, 0] * 255, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(6))
    br = np.asarray(blur_rgb).astype(np.float32)
    ba = np.asarray(blur_a).astype(np.float32)[:, :, None] / 255.0
    fill = br / np.maximum(ba, 1e-3)
    out_rgb = np.where(al > 0.5, rgb, np.clip(fill, 0, 255))
    return Image.fromarray(np.dstack([out_rgb, a[:, :, 3:]]).astype(np.uint8), "RGBA")


def mat_textures(clo_mat, key):
    d = clo_mat.get("dir", "")

    def p(k):
        f = clo_mat.get(k)
        if not f:
            return None
        f = os.path.basename(f.replace("\\", "/"))
        fp = os.path.join(d, f)
        return fp if os.path.exists(fp) else None

    return p("diffuseTexture"), p("normalmapTexture"), p("aomapTexture"), \
        clo_mat.get("transparent", "False") == "True" or clo_mat.get("alphaToCoverage", "False") == "True"


SKIN_ROUGH = None


def skin_rough_map():
    """Rugosidade da pele (lábios, nariz e testa mais oleosos) a partir do mapa
    especular do pacote skins02 (mindfront, CC0)."""
    global SKIN_ROUGH
    if SKIN_ROUGH is None:
        sp = os.path.join(asset_dir("mindfront_skin_male_african_middleage"), "skin_male_african_middleage_SPEC.png")
        s = np.asarray(_img(sp).convert("L")).astype(np.float32) / 255.0
        rough = np.clip(0.72 - (s - s.mean()) * 0.9, 0.38, 0.85)
        SKIN_ROUGH = Image.fromarray((rough * 255).astype(np.uint8), "L")
    return SKIN_ROUGH


def _sstep(a, b, x):
    t = np.clip((x - a) / (b - a), 0, 1)
    return t * t * (3 - 2 * t)


def beard_weight(V):
    """Região da barba (0..1) por vértice da malha base, no espaço do MakeHuman
    (dm; nariz em y 6,91, boca 6,56, queixo 6,19): queixo, bochechas abaixo da
    linha do nariz, costeletas subindo até a orelha, bigode, sem os lábios."""
    x, y, z = V[:, 0], V[:, 1], V[:, 2]
    ax = np.abs(x)
    nose_y, mouth_y, chin_y = 6.909, 6.56, 6.19
    top = mouth_y + 0.17 + _sstep(0.2, 0.55, ax) * 0.1 + _sstep(0.85, 0.35, z) * _sstep(0.45, 0.65, ax) * 0.62
    w = _sstep(top + 0.06, top - 0.08, y)
    w *= _sstep(0.0, 0.35, z + (ax > 0.6) * 0.3)
    # pescoço: a barba some logo abaixo do queixo (descendo até a gola parecia sujeira)
    w *= _sstep(chin_y - 0.1, chin_y + 0.04, y)
    # o limite de baixo segue a mandíbula: sob o queixo vai até o começo da
    # garganta, nos lados para na linha do maxilar (e não desce pelo pescoço)
    w *= _sstep(-0.1, 0.12, z - (0.75 - (y - chin_y) * 1.2))
    must = _sstep(0.5, 0.3, ax) * _sstep(nose_y - 0.05, nose_y - 0.15, y) * _sstep(mouth_y + 0.02, mouth_y + 0.1, y) \
        * _sstep(1.1, 1.3, z)
    w = np.maximum(w, must)
    lip = ((x / 0.3) ** 2 + ((y - mouth_y) / 0.075) ** 2) < 1.0
    w[lip & (z > 1.1)] = 0
    w[y > nose_y + 0.1] = 0
    return w


def stubble(skin_img, density, color, seed=3):
    """Pinta barba por fazer na textura da pele (sombra azulada + fios curtos)."""
    V, VT, F, G = BASE
    size = skin_img.size[0]
    w = beard_weight(V)
    mask = Image.new("L", (size, size), 0)
    dr = ImageDraw.Draw(mask)
    for (vi, ti), g in zip(F, G):
        if g != "body":
            continue
        val = w[vi].mean()
        if val > 0.01:
            dr.polygon([(VT[t][0] * size, (1 - VT[t][1]) * size) for t in ti], fill=int(val * 255))
    m = np.asarray(mask.filter(ImageFilter.GaussianBlur(size / 700))).astype(np.float32) / 255.0
    a = np.asarray(skin_img.convert("RGB")).astype(np.float32)
    # sombra da barba raspada (azulada, contínua: é ela que dá o "rosto barbado")
    a *= (1.0 - m * 0.26 * density)[:, :, None]
    a = a * (1 - m[:, :, None] * 0.18 * density) + np.array([62, 64, 70]) * m[:, :, None] * 0.18 * density
    # fios: traços de 1 px puxados para "baixo" no rosto (+u no layout do MakeHuman)
    rng = np.random.default_rng(seed)
    hair = np.zeros((size, size), np.float32)
    ys, xs = np.nonzero(m > 0.05)
    n = int(len(ys) * 0.24 * density)
    pick = rng.integers(0, len(ys), n)
    py, px = ys[pick], xs[pick]
    # borda rala (sem pontinhos soltos que pareciam sujeira)
    keep = rng.random(n) < m[py, px] ** 1.8
    py, px = py[keep], px[keep]
    ln = max(2, int(size / 900))
    for k in range(ln + 1):
        xx = np.clip(px + k, 0, size - 1)
        yy = np.clip(py + (rng.random(len(py)) < 0.3).astype(int) * k // 2, 0, size - 1)
        hair[yy, xx] = np.maximum(hair[yy, xx], 1.0 - k / (ln + 1.5))
    hair = np.asarray(Image.fromarray((hair * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.6))).astype(np.float32) / 255.0
    al = np.clip(hair * 1.3, 0, 1) * 0.55
    a = a * (1 - al[:, :, None]) + np.array(color, np.float32)[None, None, :] * al[:, :, None]
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGB")


def skin_material(name, size, beard=0.0, beard_color=(28, 21, 16), tone=None):
    key = "skin_" + name + ("_barba%d" % int(beard * 10) if beard > 0 else "")
    if key in FRESH:
        return key
    d = asset_dir(name)
    m = parse_mhmat(os.path.join(d, [f for f in os.listdir(d) if f.endswith(".mhmat")][0]))
    diff, nrm, _, _ = mat_textures(m, key)
    if beard > 0:
        tmp = os.path.join(OUT, "tex", "_tmp_" + key + ".png")
        os.makedirs(os.path.dirname(tmp), exist_ok=True)
        im = _img(diff).convert("RGB")
        if im.size[0] != size:
            im = im.resize((size, size), Image.LANCZOS)
        stubble(im, beard, beard_color).save(tmp)
        diff = tmp
    if "skin_shared" not in FRESH:
        nd = asset_dir("mindfront_skin_male_african_middleage")
        save_tex("skin_shared", "skin", None, normal=os.path.join(nd, "skin_male_african_middleage_NRM.png"),
                 rough=skin_rough_map(), size=2048)
    save_tex(key, "skin", diff, size=size, params={"tone": list(tone)} if tone else None)
    MATS[key]["normal"] = "skin_shared_n"
    if beard > 0:
        os.remove(diff)
    return key


# ---------------------------------------------------------------------------
# Mochila (gerada aqui: lona, alças e saco de dormir)
# ---------------------------------------------------------------------------
def backpack(J, outer):
    """Mochila no espaço do jogo (já em metros), presa ao peito."""
    chest = J[BI["chest"]]
    spine = J[BI["spine"]]
    neck = J[BI["neck"]]
    # costas de verdade: a roupa mais para trás na altura da mochila
    band = outer[(np.abs(outer[:, 0]) < 0.14) & (outer[:, 1] > spine[1] - 0.05) & (outer[:, 1] < chest[1] + 0.12)]
    back_z = (band[:, 2].max() - 0.075) if len(band) else chest[2] + 0.115
    parts = []

    def box(c, half, rnd, segs=6):
        # caixa arredondada (superelipsoide)
        P, T, UV = [], [], []
        nu, nv = segs * 4, segs * 2
        for i in range(nv + 1):
            v = i / nv
            th = math.pi * (v - 0.5)
            for k in range(nu + 1):
                u = k / nu
                ph = 2 * math.pi * u
                cx, sx_ = math.cos(th), math.sin(th)
                cp, sp = math.cos(ph), math.sin(ph)
                e = rnd

                def sg(x, ex):
                    return math.copysign(abs(x) ** ex, x)

                x = sg(cx, e) * sg(cp, e) * half[0]
                y = sg(sx_, e) * half[1]
                z = sg(cx, e) * sg(sp, e) * half[2]
                P.append([c[0] + x, c[1] + y, c[2] + z])
                UV.append([u * 2.0, v])
        for i in range(nv):
            for k in range(nu):
                a = i * (nu + 1) + k
                b = a + nu + 1
                T += [[a, b, a + 1], [a + 1, b, b + 1]]
        return np.array(P), np.array(T), np.array(UV)

    main = box(np.array([0.0, (chest[1] + spine[1]) * 0.5 + 0.02, back_z + 0.08]), (0.17, 0.24, 0.1), 0.35)
    pocket = box(np.array([0.0, spine[1] - 0.01, back_z + 0.19]), (0.12, 0.09, 0.04), 0.4)
    roll_c = np.array([0.0, (chest[1] + spine[1]) * 0.5 + 0.02 - 0.24 - 0.055, back_z + 0.1])
    # saco de dormir: cilindro deitado sobre a mochila
    P, T, UV = [], [], []
    nu, nl = 18, 8
    for i in range(nl + 1):
        x = -0.2 + 0.4 * i / nl
        for k in range(nu + 1):
            ph = 2 * math.pi * k / nu
            P.append([roll_c[0] + x, roll_c[1] + math.sin(ph) * 0.075, roll_c[2] + math.cos(ph) * 0.075])
            UV.append([k / nu * 2.0, i / nl])
    for i in range(nl):
        for k in range(nu):
            a = i * (nu + 1) + k
            b = a + nu + 1
            T += [[a, b, a + 1], [a + 1, b, b + 1]]
    # tampas nas pontas do rolo
    for i, sgn in ((0, -1.0), (nl, 1.0)):
        c = len(P)
        P.append([roll_c[0] + (-0.2 if i == 0 else 0.2), roll_c[1], roll_c[2]])
        UV.append([0.5, 0.5])
        for k in range(nu):
            a = i * (nu + 1) + k
            T.append([c, a + 1, a] if sgn > 0 else [c, a, a + 1])
    roll = (np.array(P), np.array(T), np.array(UV))
    # alças: acompanham a superfície da roupa por cima do ombro (raio máximo das
    # peças por ângulo num plano vertical), do topo da mochila até o peito
    straps = []
    for sx in (-1.0, 1.0):
        xs = sx * 0.105
        C = np.array([xs, chest[1] + 0.02, chest[2]])
        near = outer[(np.abs(outer[:, 0] - xs) < 0.03) & (outer[:, 1] < neck[1] + 0.02)] - C
        ang = np.degrees(np.arctan2(near[:, 2], near[:, 1]))
        rad = np.hypot(near[:, 1], near[:, 2])
        pts = []
        for th in np.linspace(80.0, -150.0, 24):
            sel = np.abs(ang - th) < 5.0
            rr = rad[sel].max() if sel.any() else 0.12
            t = math.radians(th)
            pts.append(C + np.array([0.0, math.cos(t), math.sin(t)]) * (rr + 0.009))
        P, T, UV = [], [], []
        for i, p_ in enumerate(pts):
            P.append(p_ + [-0.023, 0, 0])
            P.append(p_ + [0.023, 0, 0])
            UV += [[0, i / 6], [0.15, i / 6]]
        for i in range(len(pts) - 1):
            a = 2 * i
            T += [[a, a + 2, a + 1], [a + 1, a + 2, a + 3]]
        P, T = np.array(P), np.array(T)
        # face para fora
        n0 = np.cross(P[T[0, 1]] - P[T[0, 0]], P[T[0, 2]] - P[T[0, 0]])
        if np.dot(n0, P[T[0, 0]] - C) < 0:
            T = T[:, ::-1]
        straps.append((P, T, np.array(UV)))
    return [("backpack", main), ("backpack", pocket), ("bedroll", roll)] + [("strap", s) for s in straps]


# ---------------------------------------------------------------------------
# Crescimentos de fungo (hospedeiro: cabeça tomada; colosso: placas no corpo)
# ---------------------------------------------------------------------------
def _ellipsoid(c, axes, R, nu=14, nv=8, rng=None, lump=0.25):
    P, T, UV = [], [], []
    for i in range(nv + 1):
        th = math.pi * i / nv
        for k in range(nu + 1):
            ph = 2 * math.pi * k / nu
            d = np.array([math.sin(th) * math.cos(ph), math.cos(th), math.sin(th) * math.sin(ph)])
            bump = 1.0 + lump * (math.sin(ph * 3 + th * 2 + (rng.random() if rng else 0)) * 0.5 +
                                 (rng.random() - 0.5 if rng else 0) * 0.6)
            P.append(c + R @ (d * axes * bump))
            UV.append([k / nu, i / nv])
    for i in range(nv):
        for k in range(nu):
            a = i * (nu + 1) + k
            b = a + nu + 1
            T += [[a, a + 1, b], [a + 1, b + 1, b]]
    return np.array(P), np.array(T), np.array(UV)


def _frame(n, rng):
    n = n / np.linalg.norm(n)
    t = np.cross(n, rng.normal(size=3))
    t /= np.linalg.norm(t)
    b = np.cross(n, t)
    return np.stack([t, n, b], axis=1)   # colunas: x=t, y=n, z=b


def fungus(body, J, region, amount, seed):
    """Placas (orelhas-de-pau) e caroços brotando da superfície do corpo."""
    rng = np.random.default_rng(seed)
    P, N, Bn = body["pos"], body["nrm"], body["bones"]
    if region == "head":
        sel = np.nonzero((Bn[:, 0] == BI["head"]) & (P[:, 1] > J[BI["head"]][1] + 0.02))[0]
        n_plates, n_lumps, sc = int(22 * amount), int(36 * amount), 0.72
    else:
        sel = np.nonzero(np.isin(Bn[:, 0], [BI["chest"], BI["upperarm_l"], BI["upperarm_r"], BI["spine"], BI["neck"]]) &
                         (P[:, 1] > J[BI["spine"]][1]) & (P[:, 1] < J[BI["neck"]][1] + 0.03))[0]
        n_plates, n_lumps, sc = int(40 * amount), int(50 * amount), 1.15
    parts = []
    for i in range(n_plates):
        v = sel[rng.integers(len(sel))]
        n = N[v]
        r = rng.uniform(0.03, 0.065) * sc
        if region == "head":
            # placas em leque saindo do crânio (orelha-de-pau), grossas, metade enterrada
            axes = np.array([r * rng.uniform(1.0, 1.5), r * rng.uniform(0.7, 1.0), r * rng.uniform(0.32, 0.5)])
            R = rot_between(np.array([0, 1.0, 0]), n) @ rot_between(np.array([0, 0, 1.0]), rng.normal(size=3) * [1, 0.3, 1] + [0, 0, 1.0])
            c = P[v] + n * r * 0.05
        else:
            # placas deitadas sobre o corpo (couraça), sobrepostas
            axes = np.array([r * rng.uniform(1.0, 1.6), r * rng.uniform(0.22, 0.34), r * rng.uniform(0.9, 1.3)])
            R = rot_between(np.array([0, 1.0, 0]), n) @ rot_between(np.array([1.0, 0, 0]), rng.normal(size=3) * [1, 0, 1] + [1.0, 0, 0])
            c = P[v] + n * r * 0.04
        parts.append((v,) + _ellipsoid(c, axes, R, rng=rng, lump=0.32))
    for i in range(n_lumps):
        v = sel[rng.integers(len(sel))]
        r = rng.uniform(0.012, 0.034) * sc
        c = P[v] - N[v] * r * 0.15
        parts.append((v,) + _ellipsoid(c, np.array([r, r * 0.8, r]), rot_between(np.array([0, 1.0, 0]), N[v]),
                                       nu=8, nv=5, rng=rng, lump=0.3))
    out = []
    for v, Pp, Tt, UVp in parts:
        Wg = np.zeros((len(Pp), len(BONES)))
        Wg[np.arange(len(Pp))[:, None], Bn[v][None, :]] = body["weights"][v][None, :]
        out.append((Pp, Tt, UVp, Wg))
    return out


# ---------------------------------------------------------------------------
# Montagem
# ---------------------------------------------------------------------------
def to_game(P, scale, ground):
    G = np.c_[-P[:, 0], P[:, 1], -P[:, 2]] * 0.1 * scale
    G[:, 1] -= ground
    return G


def build(cid, r):
    print("==", cid)
    V = body_coords(r, cid)
    Vb, VTb, Fb, Gb = BASE
    nv = len(V)
    W = game_weights(nv)
    M = rest_pose(V)

    # proxies (roupas etc.)
    items = []
    for nm in [r["eyes_mesh"] if "eyes_mesh" in r else "high-poly", r.get("eyebrows"), r.get("eyelashes"),
               r.get("teeth"), r.get("hair")] + list(r.get("clothes", [])):
        if not nm:
            continue
        clo = parse_mhclo(nm)
        clo["P"] = fit_proxy(clo, V)
        Wp = (W[clo["refs"]] * clo["w"][:, :, None]).sum(1)
        clo["W"] = Wp / np.maximum(Wp.sum(1, keepdims=True), 1e-9)
        items.append(clo)

    deleted = set()
    for clo in items:
        deleted |= clo["delete"]
    keep_body = r.get("keep_body", False)

    # pose de descanso
    Vp = skin(V, W, M)
    for clo in items:
        clo["Pp"] = skin(clo["P"], clo["W"], M)

    # escala e chão (sola mais baixa entre corpo e calçado)
    body_mask = np.array([g == "body" for g in Gb])
    tv_b, tt_b = triangulate(Fb, body_mask)
    used = np.unique(tv_b)
    top = Vp[used, 1].max()
    sole = Vp[used, 1].min()
    scale = r["height"] / ((top - sole) * 0.1)
    low = sole
    for clo in items:
        low = min(low, clo["Pp"][:, 1].min())
    ground = low * 0.1 * scale

    Gp = to_game(Vp, scale, ground)
    # juntas do jogo
    J = np.zeros((len(BONES), 3))

    def gj(b, bone):
        J[BI[b]] = to_game(apply_m(M[BI[b]], bone_head(V, bone))[None], scale, ground)[0]

    for b, bone in (("hips", "spine05"), ("spine", "spine03"), ("chest", "spine01"), ("neck", "neck01"),
                    ("head", "head"), ("jaw", "jaw")):
        gj(b, bone)
    for side, sfx in (("L", "_l"), ("R", "_r")):
        gj("upperarm" + sfx, "upperarm01." + side)
        gj("forearm" + sfx, "lowerarm01." + side)
        gj("hand" + sfx, "wrist." + side)
        gj("thigh" + sfx, "upperleg01." + side)
        gj("shin" + sfx, "lowerleg01." + side)
        gj("foot" + sfx, "foot." + side)

    surfaces = []
    tex_size = r.get("tex_size", {})

    # corpo (pele)
    skin_key = skin_material(r["skin"], tex_size.get("skin", 1024), r.get("stubble", 0.0),
                             r.get("stubble_color", (28, 21, 16)), r.get("skin_tone"))
    face_keep = np.array([g == "body" and (keep_body or not any(v in deleted for v in vi))
                          for (vi, ti), g in zip(Fb, Gb)])
    tv, tt = triangulate(Fb, face_keep)
    Nb = smooth_normals(Gp, tv)
    if keep_body and deleted:
        hid = np.array(sorted(v for v in deleted if v < len(Gp)))
        Gp = Gp.copy()
        Gp[hid] -= Nb[hid] * 0.007
    s = make_surface("body", skin_key, Gp, Nb, W, VTb, tv, tt)
    surfaces.append(s)

    # proxies (roupas de baixo empurradas para dentro das de cima onde se cobrem)
    for clo in items:
        clo["G"] = to_game(clo["Pp"], scale, ground)
    resolve_layers([c for c in items if is_garment(c["name"], r)])
    for clo in items:
        nm = clo["name"]
        P = clo["G"]
        tv, tt = triangulate(clo["faces"])
        N = smooth_normals(P, tv)
        if nm == r.get("hair") or "beard" in nm.lower():
            # cartões de cabelo: normal puxada para fora do centro da cabeça (sombreado de volume)
            hc = J[BI["head"]] + np.array([0.0, 0.07, 0.0]) * (r["height"] / 1.79)
            out = P - hc
            out /= np.maximum(np.linalg.norm(out, axis=1, keepdims=True), 1e-6)
            N = N * np.sign(np.sum(N * out, axis=1, keepdims=True) + 1e-6)
            N = N * 0.35 + out * 0.65
            N /= np.maximum(np.linalg.norm(N, axis=1, keepdims=True), 1e-6)
        if nm in ("high-poly", "low-poly"):
            key = "eyes_" + r.get("eyes", "brown")
            if key not in FRESH:
                em = parse_mhmat(os.path.join(asset_dir("high-poly"), "..", "materials", r.get("eyes", "brown") + ".mhmat"))
                diff, _, _, _ = mat_textures(em, key)
                save_tex(key, "eyes", diff, size=512, alpha=True)
            kind = "eyes"
        else:
            key = nm
            diff, nrm, ao, alpha = mat_textures(clo["mat"], key)
            alias = r.get("mat_alias", {}).get(nm)
            if "glasses" in nm.lower():
                alpha = True
            low_name = nm.lower()
            if "eyebrow" in low_name or "eyelash" in low_name:
                kind = "brow"
            elif nm == r.get("hair"):
                kind = "hair"
            elif "beard" in low_name or "moustache" in low_name:
                kind = "beard"
            elif "teeth" in low_name:
                kind = "teeth"
            else:
                kind = "cloth"
            if key not in FRESH:
                sz = tex_size.get(nm, 1024 if kind in ("cloth", "hair", "beard") else 512)
                rough = 0.82 if kind == "cloth" else (0.45 if kind in ("hair", "beard") else 0.6)
                prm = dict(r.get("params", {}).get(nm, {}))
                if kind == "cloth":
                    prm.setdefault("tint_slot", TINT.get(nm, 3))
                    if "glasses" in nm.lower():
                        prm.setdefault("alpha_cut", 0.5)
                save_tex(key, kind, diff, normal=nrm, ao=ao, rough=rough, size=sz,
                         alpha=alpha or kind in ("hair", "brow", "beard"), params=prm,
                         nsize=sz // 2 if kind == "cloth" else None)
            if alias:
                rec = dict(MATS[key])
                rec["params"] = dict(r.get("params", {}).get(alias, {}))
                rec["params"].setdefault("tint_slot", 3)
                MATS[alias] = rec
                key = alias
        sf = make_surface(kind if kind != "cloth" else "cloth:" + nm, key, P, N, clo["W"], clo["vts"], tv, tt)
        if sf is not None:
            surfaces.append(sf)

    # fungo
    if r.get("growths", 0) > 0 or r.get("plates", 0) > 0:
        if "fungus" not in FRESH:
            save_tex("fungus", "fungus", None, size=0)
        grow = []
        if r.get("growths", 0) > 0:
            grow += fungus(surfaces[0], J, "head", r["growths"], 11 + len(cid))
        if r.get("plates", 0) > 0:
            grow += fungus(surfaces[0], J, "body", r["plates"], 23 + len(cid))
        for k, (P, T, UV, Wg) in enumerate(grow):
            N = smooth_normals(P, T)
            sf = make_surface("fungus", "fungus", P, N, Wg, np.c_[UV[:, 0], 1.0 - UV[:, 1]], T, T)
            surfaces.append(sf)

    # mochila
    if r.get("backpack"):
        if "backpack" not in FRESH:
            save_tex("backpack", "gear", None, size=0, params={"color": [0.36, 0.32, 0.23]})
            save_tex("bedroll", "gear", None, size=0, params={"color": [0.22, 0.3, 0.24]})
            save_tex("strap", "gear", None, size=0, params={"color": [0.12, 0.12, 0.11]})
        outer = np.concatenate([sf["pos"] for sf in surfaces if sf["name"].startswith("cloth")])
        for mname, (P, T, UV) in backpack(J, outer):
            T = np.array(T, np.int64)
            N = smooth_normals(P, T)
            Wg = np.zeros((len(P), len(BONES)))
            Wg[:, BI["chest"]] = 1.0
            sf = make_surface("gear:" + mname, mname, P, N, Wg, np.c_[UV[:, 0], 1.0 - UV[:, 1]], T, T)
            surfaces.append(sf)

    # máscaras de sangue/sujeira/rasgo
    mouth = J[BI["jaw"]] + np.array([0.0, -0.045, -0.085]) * (r["height"] / 1.79)
    eyes = []
    for sf in surfaces:
        if sf["name"] == "eyes":
            ep = sf["pos"]
            eyes = [ep[ep[:, 0] < 0].mean(0), ep[ep[:, 0] >= 0].mean(0)]
    for k, sf in enumerate(surfaces):
        kind = sf["name"].split(":")[0]
        bake_masks(sf, J, mouth, "cloth" if kind in ("cloth", "gear") else kind, k * 31 + len(cid), eyes)
    scalp = None
    hair_sf = [sf for sf in surfaces if sf["name"] == "hair"]
    if hair_sf:
        sm = scalp_mask(surfaces[0], hair_sf[0], J)
        col = surfaces[0]["color"]
        col[:, 3] = np.where(sm > 0.002, 0.5 + 0.5 * sm, col[:, 3])
        scalp = hair_color(hair_sf[0]["mat"])

    # pé (para o IK do animador): ponta, calcanhar e altura do tornozelo
    fp = np.concatenate([s["pos"][s["bones"][:, 0] == BI["foot_l"]] for s in surfaces])
    ank = J[BI["foot_l"]]
    toe = float(-(fp[:, 2].min() - ank[2]))
    heel = float(fp[:, 2].max() - ank[2])
    foot = [toe, heel, float(ank[1])]

    write(cid, r, J, foot, merge_surfaces(surfaces), scalp)


def is_garment(nm, r):
    low = nm.lower()
    return not (nm in ("high-poly", "low-poly") or nm == r.get("hair") or any(
        k in low for k in ("eyebrow", "eyelash", "teeth", "glasses", "beard", "moustache")))


def resolve_layers(garments, gap=0.007, reach=0.04):
    """Na ordem da receita, cada peça cobre as anteriores: os vértices das de baixo
    que ficam fora (ou rente) da de cima vão para `gap` m por dentro dela — sem a
    camiseta ou a calça atravessando o jaleco e a jaqueta."""
    from scipy.spatial import cKDTree
    for j in range(1, len(garments)):
        outer = garments[j]
        Po = outer["G"]
        tv, _ = triangulate(outer["faces"])
        No = smooth_normals(Po, tv)
        tree = cKDTree(Po)
        for i in range(j):
            inner = garments[i]
            P = inner["G"]
            d, k = tree.query(P, distance_upper_bound=reach)
            ok = np.isfinite(d)
            if not ok.any():
                continue
            q = Po[k[ok]]
            n = No[k[ok]]
            sd = np.sum((P[ok] - q) * n, axis=1)
            push = np.clip(sd + gap, 0.0, None) * np.clip(1.0 - d[ok] / reach, 0.0, 1.0) ** 0.5
            P[ok] -= n * push[:, None]
            inner["G"] = P


def merge_surfaces(surfaces):
    out, by = [], {}
    for sf in surfaces:
        k = (sf["name"].split(":")[0] if sf["name"].startswith(("gear", "fungus")) else sf["name"], sf["mat"])
        if k not in by:
            by[k] = dict(sf)
            by[k]["name"] = sf["name"]
            out.append(by[k])
            continue
        d = by[k]
        base = len(d["pos"])
        for a in ("pos", "nrm", "uv", "bones", "weights", "color"):
            d[a] = np.concatenate([d[a], sf[a]])
        d["idx"] = np.concatenate([d["idx"], sf["idx"] + base]).astype(np.int32)
    return out


def write(cid, r, J, foot, surfaces, scalp=None):
    os.makedirs(OUT, exist_ok=True)
    meta = {"id": cid, "height": r["height"], "joints": J.round(5).tolist(), "foot": [round(x, 4) for x in foot],
            "grime": r.get("grime", 0.2), "surfaces": []}
    if scalp:
        meta["scalp"] = scalp
    with open(os.path.join(OUT, cid + ".bin"), "wb") as f:
        for s in surfaces:
            nv = len(s["pos"])
            ni = len(s["idx"])
            meta["surfaces"].append({"name": s["name"], "mat": s["mat"], "nv": nv, "ni": ni})
            f.write(s["pos"].astype("<f4").tobytes())
            f.write(s["nrm"].astype("<f4").tobytes())
            f.write(s["uv"].astype("<f4").tobytes())
            f.write(s["bones"].astype("<i4").tobytes())
            f.write(s["weights"].astype("<f4").tobytes())
            f.write(s["color"].astype("<f4").tobytes())
            f.write(s["idx"].astype("<i4").tobytes())
    tris = sum(s["ni"] for s in meta["surfaces"]) // 3
    meta["tris"] = tris
    json.dump(meta, open(os.path.join(OUT, cid + ".json"), "w"), indent=1)
    print("   %d superfícies, %d triângulos, altura %.2f m, pé %s" % (len(surfaces), tris, r["height"], meta["foot"]))


def main():
    global MH, BASE, RIG
    args = sys.argv[1:]
    MH = "/tmp/mh"
    if "--mh" in args:
        i = args.index("--mh")
        MH = args[i + 1]
        del args[i:i + 2]
    BASE = load_obj(os.path.join(MH, "data", "3dobjs", "base.obj"))
    RIG = load_rig()
    mp = os.path.join(OUT, "materials.json")
    if os.path.exists(mp) and args:
        MATS.update(json.load(open(mp)))
    if "human_detail" not in MATS or not os.path.exists(os.path.join(OUT, "tex", "human_detail_a.png")):
        detail_texture()
    args = [a for a in args if not a.startswith("--")]
    ids = args or list(RECIPES.keys())
    for cid in ids:
        build(cid, RECIPES[cid])
    if not args or "--peles" in sys.argv:
        for sk in SKINS_M + SKINS_F:
            skin_material(sk, 1024)
    MATS["_skins"] = {"male": ["skin_" + k for k in SKINS_M], "female": ["skin_" + k for k in SKINS_F]}
    json.dump(MATS, open(mp, "w"), indent=1)
    credits()


def credits():
    """assets/characters/CREDITOS.txt: autor e licença de cada asset usado."""
    used = set()
    for r in RECIPES.values():
        used.update([r["skin"], r.get("hair"), r.get("eyebrows"), r.get("eyelashes")] + list(r["clothes"]))
    used.update(SKINS_M + SKINS_F)
    used.discard(None)
    info = {}
    for base in ("sys", "packs"):
        for dp, dn, fn in os.walk(os.path.join(MH, base)):
            for f in fn:
                if f.endswith(".json") and os.path.basename(dp) == "packs":
                    try:
                        info.update(json.load(open(os.path.join(dp, f))))
                    except Exception:
                        pass
    lines = ["Personagens fotorrealistas: malha base, alvos, esqueleto, pesos e assets de sistema do",
             "MakeHuman (CC0 1.0, https://www.makehumancommunity.org). Assets da comunidade usados:", ""]
    for n in sorted(used):
        i = info.get(n, {})
        lic = i.get("license", "CC0")
        lines.append("  %-42s %-8s %s %s" % (n, lic, i.get("author", "MakeHuman team"), i.get("source", "")))
    lines += ["", "Os marcados CC-BY exigem atribuição: autores acima (CC BY 4.0).",
              "Gerados por tools/make_humans.py; mochila, máscaras de sangue/sujeira e textura de detalhe: próprios."]
    open(os.path.join(ROOT, "assets", "characters", "CREDITOS.txt"), "w").write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
