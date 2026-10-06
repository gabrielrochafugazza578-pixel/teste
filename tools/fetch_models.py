#!/usr/bin/env python3
"""Baixa modelos 3D escaneados do Poly Haven (https://polyhaven.com, CC0) em glTF
com texturas 1K para assets/models/props/<pasta>/<pasta>.gltf.

Uso: python3 tools/fetch_models.py [id ...]   (sem argumentos: a lista abaixo)
"""
import json
import os
import sys
import urllib.request

API = "https://api.polyhaven.com"
CACHE = os.environ.get("PH_CACHE", "/tmp/ph_cache")
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "models", "props")

# id no Poly Haven -> pasta no projeto
MODELS = {
    "Barrel_01": "barrel",
    "trashbag": "trash_bag",
    "Sofa_01": "sofa",
    "ArmChair_01": "armchair",
    "painted_wooden_chair_01": "chair",
    "wooden_table_02": "table",
    "side_table_01": "side_table",
    "wooden_bookshelf_worn": "bookshelf",
    "steel_frame_shelves_01": "steel_shelves",
    "potted_plant_02": "potted_plant",
    "metal_trash_can": "trash_can",
    "fire_hydrant": "hydrant",
    "concrete_road_barrier_02": "concrete_barrier",
    "modular_street_seating": "street_bench",
    "cardboard_box_01": "cardboard_box",
    "old_tyre": "tyre",
    "SchoolChair_01": "school_chair",
    "WetFloorSign_01": "wet_floor_sign",
    "rock_09": "rock",
    "rock_moss_set_01": "rock_moss",
    "tree_stump_01": "stump",
    "dead_tree_trunk": "fallen_log",
    "fern_02": "fern",
    "plastic_crate_02": "plastic_crate",
    "metal_jerrycan": "jerrycan",
}


def get(url: str) -> bytes:
    os.makedirs(CACHE, exist_ok=True)
    fn = os.path.join(CACHE, url.replace("/", "_").replace(":", ""))
    if os.path.exists(fn):
        return open(fn, "rb").read()
    req = urllib.request.Request(url, headers={"User-Agent": "o-inicio-do-fim-models"})
    with urllib.request.urlopen(req, timeout=180) as r:
        data = r.read()
    open(fn, "wb").write(data)
    return data


def fetch(pid: str, folder: str) -> None:
    files = json.loads(get(f"{API}/files/{pid}"))
    g = files["gltf"].get("1k") or files["gltf"].get("2k")
    entry = g["gltf"]
    dst = os.path.join(OUT, folder)
    os.makedirs(dst, exist_ok=True)
    # o .gltf aponta para o .bin e as texturas pelo nome original (caminho relativo)
    open(os.path.join(dst, folder + ".gltf"), "wb").write(get(entry["url"]))
    for rel, inc in entry.get("include", {}).items():
        p = os.path.join(dst, rel)
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, "wb").write(get(inc["url"]))
    gl = json.load(open(os.path.join(dst, folder + ".gltf")))
    names = [n.get("name", "?") for n in gl.get("nodes", []) if "mesh" in n]
    print("%-26s -> %-18s nós com malha: %s" % (pid, folder, names))


def main() -> None:
    ids = sys.argv[1:] or list(MODELS.keys())
    for pid in ids:
        fetch(pid, MODELS.get(pid, pid.lower()))
    with open(os.path.join(OUT, "LICENCA.txt"), "w") as f:
        f.write("Modelos 3D escaneados do Poly Haven (CC0 1.0) — https://polyhaven.com/license\n"
                "Baixados por tools/fetch_models.py:\n")
        for pid, folder in MODELS.items():
            f.write("  %-20s %s  (https://polyhaven.com/a/%s)\n" % (folder, pid, pid))


if __name__ == "__main__":
    main()
