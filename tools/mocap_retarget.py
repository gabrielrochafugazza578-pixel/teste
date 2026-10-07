#!/usr/bin/env python3
"""Converte captura de movimento (BVH da base CMU, conversão livre de
https://github.com/Shriinivas/cmubvh — "CMU places no restrictions on the use of
the original dataset") para o esqueleto de 18 ossos do jogo.

Retarget por DIREÇÕES (não por ângulos): a cada quadro calcula a posição das
juntas no BVH e monta, para cada osso do jogo, a base global que leva o osso da
pose de descanso do jogo (braços para baixo, pernas retas, olhando para -Z) até a
direção capturada; a torção dos membros vem do plano do cotovelo/joelho. Assim a
pose de descanso torta do CMU não importa. Saída: ângulos Euler (YXZ, graus) por
osso no formato do ProceduralAnimator + deslocamento do quadril, um ciclo de
passada em loop (andar/correr) ou o trecho todo (parado), a 30 quadros/s.

Uso: python3 tools/mocap_retarget.py <pasta com .bvh>  (grava assets/anim/mocap/*.json)
"""
import json
import math
import os
import sys

import numpy as np

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.join(ROOT, "assets", "anim", "mocap")

# juntas de descanso do jogo (Caio, metros), na ordem dos ossos do jogo
GAME_BONES = ["hips", "spine", "chest", "neck", "head", "jaw", "ua_l", "fa_l", "hand_l", "ua_r", "fa_r", "hand_r",
              "th_l", "sh_l", "ft_l", "th_r", "sh_r", "ft_r"]
PARENTS = [-1, 0, 1, 2, 3, 4, 2, 6, 7, 2, 9, 10, 0, 12, 13, 0, 15, 16]
LEG_GAME = 0.4275 + 0.4547   # coxa + canela do Caio

# clipes: nome no jogo -> (arquivo, tipo, quadro inicial opcional)
CLIPS = {
    "walk": ("07_01.bvh", "cycle"),
    "walk_slow": ("07_04.bvh", "cycle"),
    "walk_brisk": ("07_12.bvh", "cycle"),
    "jog": ("16_35.bvh", "cycle"),
    "run": ("09_01.bvh", "cycle"),
    "idle": ("82_08.bvh", "idle_start"),
    "idle_b": ("77_02.bvh", "idle"),
    "look_flash": ("77_05.bvh", "idle"),
    "creep": ("77_14.bvh", "cycle"),
    "limp": ("77_19.bvh", "cycle"),
    "zombie": ("20_08.bvh", "cycle"),
    "zombie_b": ("21_08.bvh", "cycle"),
}


# ---------------------------------------------------------------------------
# BVH
# ---------------------------------------------------------------------------
def parse_bvh(path):
    toks = open(path).read().split()
    i = 0
    joints = []   # dict(name, parent, offset, channels)
    stack = []
    while toks[i] != "MOTION":
        t = toks[i]
        if t in ("ROOT", "JOINT"):
            joints.append({"name": toks[i + 1], "parent": stack[-1] if stack else -1, "offset": None, "channels": []})
            i += 2
        elif t == "End":
            joints.append({"name": joints[stack[-1]]["name"] + "_end", "parent": stack[-1], "offset": None, "channels": []})
            i += 2
        elif t == "{":
            stack.append(len(joints) - 1)
            i += 1
        elif t == "}":
            stack.pop()
            i += 1
        elif t == "OFFSET":
            joints[stack[-1]]["offset"] = np.array([float(x) for x in toks[i + 1:i + 4]])
            i += 4
        elif t == "CHANNELS":
            n = int(toks[i + 1])
            joints[stack[-1]]["channels"] = toks[i + 2:i + 2 + n]
            i += 2 + n
        else:
            i += 1
    nf = int(toks[i + 2])
    ft = float(toks[i + 5])
    vals = np.array([float(x) for x in toks[i + 6:]])
    nch = sum(len(j["channels"]) for j in joints)
    motion = vals[: nf * nch].reshape(nf, nch)
    return joints, motion, ft


def _rot(axis, deg):
    a = math.radians(deg)
    c, s = math.cos(a), math.sin(a)
    if axis == "X":
        return np.array([[1, 0, 0], [0, c, -s], [0, s, c]])
    if axis == "Y":
        return np.array([[c, 0, s], [0, 1, 0], [-s, 0, c]])
    return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]])


def fk_positions(joints, motion):
    """Posições globais (F, J, 3) de todas as juntas."""
    nf = len(motion)
    P = np.zeros((nf, len(joints), 3))
    for f in range(nf):
        col = 0
        G = [None] * len(joints)
        for j, jt in enumerate(joints):
            R = np.eye(3)
            pos = jt["offset"].copy()
            for ch in jt["channels"]:
                v = motion[f, col]
                col += 1
                if ch.endswith("position"):
                    pos[{"X": 0, "Y": 1, "Z": 2}[ch[0]]] = v
                else:
                    R = R @ _rot(ch[0], v)
            if jt["parent"] < 0:
                G[j] = R
                P[f, j] = pos
            else:
                pr = G[jt["parent"]]
                G[j] = pr @ R
                P[f, j] = P[f, jt["parent"]] + pr @ pos
    return P


# ---------------------------------------------------------------------------
# Bases e ângulos
# ---------------------------------------------------------------------------
def nrm(v):
    n = np.linalg.norm(v)
    return v / n if n > 1e-9 else v


def basis_xy(x_hint, y, z_hint=None):
    """Base ortonormal com Y exato e X o mais próximo de x_hint (colunas X, Y, Z)."""
    y = nrm(y)
    x = x_hint - y * np.dot(x_hint, y)
    if np.linalg.norm(x) < 0.15:
        # osso quase paralelo à dica (braço esticado para o lado): usa o Z
        zh = z_hint if z_hint is not None else np.array([0, 0, 1.0])
        z = nrm(zh - y * np.dot(zh, y))
        x = np.cross(y, z)
    x = nrm(x)
    z = np.cross(x, y)
    return np.stack([x, y, z], axis=1)


def euler_yxz(R):
    """Ângulos (x, y, z) em graus no formato Basis.get_euler() do Godot (ordem YXZ)."""
    m12 = R[1, 2]
    if m12 < 1.0 - 1e-7:
        if m12 > -1.0 + 1e-7:
            x = math.asin(-m12)
            y = math.atan2(R[0, 2], R[2, 2])
            z = math.atan2(R[1, 0], R[1, 1])
        else:
            x = math.pi * 0.5
            y = math.atan2(R[0, 1], R[0, 0])
            z = 0.0
    else:
        x = -math.pi * 0.5
        y = -math.atan2(R[0, 1], R[0, 0])
        z = 0.0
    return [round(math.degrees(x), 2), round(math.degrees(y), 2), round(math.degrees(z), 2)]


def retarget(joints, P, ft, kind, name):
    idx = {j["name"]: k for k, j in enumerate(joints)}
    J = lambda n: P[:, idx[n]]
    # escala pelo comprimento da perna
    leg = np.linalg.norm(J("LeftLeg") - J("LeftUpLeg"), axis=1).mean() + np.linalg.norm(J("LeftFoot") - J("LeftLeg"), axis=1).mean()
    sc = LEG_GAME / leg
    # BVH (olha para +Z) -> jogo (olha para -Z): gira 180° em Y
    G = P * sc
    G[..., 0] *= -1.0
    G[..., 2] *= -1.0
    J = lambda n: G[:, idx[n]]
    nf = len(G)
    # direção média do movimento/olhar: alinha com -Z (tira a curva do trajeto)
    lat = J("LeftUpLeg") - J("RightUpLeg")
    fwd = np.cross(lat, np.array([0, 1.0, 0]))   # esquerda × cima = frente
    fwd[:, 1] = 0
    fm = nrm(fwd.mean(axis=0))
    yaw = math.atan2(-fm[0], -fm[2])     # ângulo que leva -Z até fm
    Ry = _rot("Y", -math.degrees(yaw))
    G = G @ Ry.T
    J = lambda n: G[:, idx[n]]
    # quadros de saída
    step = max(1, int(round((1.0 / 30.0) / ft)))
    frames = list(range(0, nf, step))
    if kind == "cycle":
        frames = _cycle(J, frames, ft)
    elif kind == "idle_start":
        # só o começo, parado (antes de sair andando)
        hv = np.linalg.norm(np.diff(J("Hips")[frames][:, [0, 2]], axis=0), axis=1) / (step * ft)
        k = 0
        while k < len(hv) and hv[k] < 0.12:
            k += 1
        frames = frames[: max(30, k - 15)]
        kind = "idle"
    # altura de descanso do quadril: média em pé (idle) ou mediana do ciclo
    hips = J("Hips")
    lfoot = J("LeftFoot")
    rfoot = J("RightFoot")
    floor = np.minimum(lfoot[frames, 1], rfoot[frames, 1])
    # chão: tornozelo do pé apoiado no trecho usado = altura do tornozelo do Caio
    ground = (np.percentile(floor, 10) if kind == "cycle" else np.median(floor)) - 0.0926
    rest_hip_y = 0.9832          # quadril do Caio em pé
    out = []
    # deriva horizontal do quadril no trecho (andar em linha reta) vira velocidade
    h0 = hips[frames[0]]
    h1 = hips[frames[-1]]
    dur = (frames[-1] - frames[0]) * ft
    drift = (h1 - h0) / max(dur, 1e-6)
    speed = float(np.linalg.norm(drift[[0, 2]])) if kind == "cycle" else 0.0
    # pé: a inclinação média na fase de apoio é "plano" (calibra a pose torta do CMU)
    def foot_slope(side):
        a = J(side + "Foot")
        b = J(side + "ToeBase")
        d = b - a
        ang = np.degrees(np.arctan2(-d[:, 1], np.hypot(d[:, 0], d[:, 2])))
        h = a[:, 1]
        st = h < np.percentile(h, 25)
        return float(np.median(ang[st]))
    slope = {"Left": foot_slope("Left"), "Right": foot_slope("Right")}
    for k, f in enumerate(frames):
        t = (f - frames[0]) * ft
        g = {}
        # tronco
        lat_h = nrm(J("LeftUpLeg")[f] - J("RightUpLeg")[f])
        up_h = J("Spine")[f] - J("Hips")[f]
        if np.linalg.norm(up_h) < 1e-6:
            up_h = J("Spine1")[f] - J("Hips")[f]
        g["hips"] = basis_xy(-lat_h, up_h)
        lat_c = nrm(J("LeftArm")[f] - J("RightArm")[f])
        g["spine"] = basis_xy(-nrm(lat_h + lat_c), J("Spine1")[f] - J("Spine")[f])
        # (no CMU a junta Neck fica em cima da Spine1: o pescoço de verdade é Neck1)
        g["chest"] = basis_xy(-lat_c, J("Neck1")[f] - J("Spine1")[f])
        g["neck"] = basis_xy(-lat_c, J("Head")[f] - J("Neck1")[f])
        g["head"] = basis_xy(-lat_c, J("Head_end")[f] - J("Head")[f]) if "Head_end" in idx else g["neck"]
        g["jaw"] = g["head"]
        # membros: Y = -direção do osso; X = normal do plano de dobra
        for side, s in (("Left", "l"), ("Right", "r")):
            sh = J(side + "Arm")[f]
            el = J(side + "ForeArm")[f]
            wr = J(side + "Hand")[f]
            fi = J(side + "HandIndex1")[f] if (side + "HandIndex1") in idx else J(side + "FingerBase")[f]
            du = nrm(el - sh)
            dfo = nrm(wr - el)
            n = np.cross(du, dfo)
            par_x = g["chest"][:, 0]
            bend = min(1.0, np.linalg.norm(n) / 0.25)
            xh = nrm(n) * bend + par_x * (1.0 - bend) if np.linalg.norm(n) > 1e-6 else par_x
            g["ua_" + s] = basis_xy(xh, -du)
            g["fa_" + s] = basis_xy(xh, -dfo)
            g["hand_" + s] = basis_xy(xh, -(fi - wr))
            hp = J(side + "UpLeg")[f]
            kn = J(side + "Leg")[f]
            an = J(side + "Foot")[f]
            to = J(side + "ToeBase")[f]
            dt = nrm(kn - hp)
            ds = nrm(an - kn)
            n2 = np.cross(ds, dt)
            par_x = g["hips"][:, 0]
            bend = min(1.0, np.linalg.norm(n2) / 0.2)
            xh = nrm(n2) * bend + par_x * (1.0 - bend) if np.linalg.norm(n2) > 1e-6 else par_x
            g["th_" + s] = basis_xy(xh, -dt)
            g["sh_" + s] = basis_xy(xh, -ds)
            # pé: Z local = -frente (do tornozelo aos dedos), corrigido pela inclinação de apoio
            fv = nrm(to - an)
            axis = nrm(np.cross(fv, np.array([0, 1.0, 0])))
            if np.linalg.norm(axis) > 1e-6:
                a = math.radians(slope[side])
                fv = nrm(fv * math.cos(a) + np.cross(axis, fv) * math.sin(a) + axis * np.dot(axis, fv) * (1 - math.cos(a)))
            zf = -fv
            xf = nrm(xh - zf * np.dot(xh, zf))
            yf = np.cross(zf, xf)
            g["ft_" + s] = np.stack([xf, yf, zf], axis=1)
        pose = {}
        for b, name_b in enumerate(GAME_BONES):
            if name_b == "jaw":
                continue
            R = g[name_b]
            par = PARENTS[b]
            L = R if par < 0 else g[GAME_BONES[par]].T @ R
            e = euler_yxz(L)
            if abs(e[0]) + abs(e[1]) + abs(e[2]) > 0.05:
                pose[str(b)] = e
        hp = hips[f] - (h0 + drift * t)
        pose["p"] = [round(float(hp[0]), 4), round(float(hips[f][1] - ground - rest_hip_y), 4), round(float(hp[2]), 4)]
        out.append(pose)
    return {"name": name, "fps": 30.0, "speed": round(speed, 3), "loop": True, "frames": out,
            "source": "CMU Graphics Lab Motion Capture Database (BVH: github.com/Shriinivas/cmubvh)"}


def _cycle(J, frames, ft):
    """Um ciclo de passada inteiro (duas pisadas do pé esquerdo) no trecho mais
    estável: duração plausível, velocidade do quadril alta e constante, e a pose
    do fim parecida com a do começo (loop sem emenda)."""
    hip = J("Hips")
    fr = np.array(frames)
    # apoio do pé esquerdo: perto do chão e parado (velocidade horizontal baixa);
    # a pisada é o primeiro quadro de cada apoio
    foot = J("LeftFoot")[fr]
    dtf = (fr[1] - fr[0]) * ft
    vel = np.r_[0.0, np.linalg.norm(np.diff(foot[:, [0, 2]], axis=0), axis=1) / dtf]
    low = foot[:, 1] < np.percentile(foot[:, 1], 15) + 0.04
    stance = low & (vel < 0.45)
    strikes = [i for i in range(1, len(fr)) if stance[i] and not stance[i - 1]]
    if len(strikes) < 2:
        return frames
    best = None
    dt = (fr[1] - fr[0]) * ft
    for a, b in zip(strikes[:-1], strikes[1:]):
        dur = (b - a) * dt
        if dur < 0.45 or dur > 1.9:
            continue
        seg = hip[fr[a:b + 1]]
        v = np.linalg.norm(np.diff(seg[:, [0, 2]], axis=0), axis=1) / dt
        steady = v.std() / max(v.mean(), 1e-3)
        diff = np.linalg.norm(J("LeftFoot")[fr[a]] - hip[fr[a]] - (J("LeftFoot")[fr[b]] - hip[fr[b]])) + \
            np.linalg.norm(J("RightFoot")[fr[a]] - hip[fr[a]] - (J("RightFoot")[fr[b]] - hip[fr[b]]))
        score = v.mean() - steady * 2.0 - diff * 4.0
        if best is None or score > best[0]:
            best = (score, a, b)
    if best is None:
        a, b = strikes[len(strikes) // 2 - 1], strikes[len(strikes) // 2]
    else:
        a, b = best[1], best[2]
    return list(fr[a:b + 1])


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else "/tmp/mocap"
    os.makedirs(OUT, exist_ok=True)
    index = {}
    for name, (fn, kind) in CLIPS.items():
        p = os.path.join(src, fn)
        if not os.path.exists(p):
            print("falta", p)
            continue
        joints, motion, ft = parse_bvh(p)
        P = fk_positions(joints, motion)
        clip = retarget(joints, P, ft, kind, name)
        json.dump(clip, open(os.path.join(OUT, name + ".json"), "w"), separators=(",", ":"))
        index[name] = {"frames": len(clip["frames"]), "speed": clip["speed"], "file": fn}
        print("%-11s %-10s %4d quadros  %.2f m/s" % (name, fn, len(clip["frames"]), clip["speed"]))
    json.dump(index, open(os.path.join(OUT, "index.json"), "w"), indent=1)
    open(os.path.join(OUT, "LICENCA.txt"), "w").write(
        "Movimentos capturados: CMU Graphics Lab Motion Capture Database (http://mocap.cs.cmu.edu),\n"
        "financiada pela NSF EIA-0196217. Conversão BVH: https://github.com/Shriinivas/cmubvh.\n"
        "\"CMU places no restrictions on the use of the original dataset\"; a conversão também não.\n"
        "Retarget para o esqueleto do jogo: tools/mocap_retarget.py.\n"
        "Clipes: " + ", ".join("%s (%s)" % (k, v[0]) for k, v in CLIPS.items()) + "\n")


if __name__ == "__main__":
    main()
