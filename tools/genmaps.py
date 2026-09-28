#!/usr/bin/env python3
"""Gera src/abismo/Maps.java a partir das salas descritas aqui.

Legenda dos mapas:
  #  rocha solida        .  ar             ^  espinhos        =  plataforma (atravessavel por baixo)
  P  inicio do jogador   B  banco          L  lanterna        g  rocha de geo
  c  rastejante          f  mosca vigia    s  cuspidor        K  chefe
  D  Manto (dash)        W  Asas (pulo duplo)                 G  portao do chefe
  1-9 portas (ligacoes definidas em World.java)

Uso:  python3 tools/genmaps.py
"""
import os
import random


class Room:
    def __init__(self, w, h, seed):
        self.w, self.h = w, h
        self.g = [['#'] * w for _ in range(h)]
        self.rng = random.Random(seed)

    def carve(self, x0, y0, x1, y1, ch='.'):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.g[y][x] = ch

    def fill(self, x0, y0, x1, y1):
        self.carve(x0, y0, x1, y1, '#')

    def put(self, x, y, ch):
        self.g[y][x] = ch

    def roughen_ceiling(self, x0, x1, chance=0.35, keep_below=6):
        """Adiciona pequenas saliencias organicas no teto."""
        for x in range(x0, x1 + 1):
            for y in range(1, self.h - 1):
                if self.g[y][x] == '.' and self.g[y - 1][x] == '#':
                    clear = all(self.g[yy][x] == '.' for yy in range(y, min(self.h, y + keep_below)))
                    if clear and self.rng.random() < chance:
                        self.g[y][x] = '#'
                    break

    def rows(self):
        return [''.join(r) for r in self.g]


def r1():
    r = Room(64, 22, 1)
    r.carve(1, 3, 62, 18)
    r.fill(1, 3, 8, 4); r.fill(20, 3, 27, 3); r.fill(45, 3, 62, 5)
    r.roughen_ceiling(9, 44)
    r.fill(40, 17, 47, 18)                     # degrau
    r.carve(27, 19, 29, 19); r.carve(27, 20, 29, 20, '^')  # fosso de espinhos
    r.carve(12, 15, 15, 15, '='); r.carve(18, 12, 21, 12, '='); r.carve(31, 14, 35, 14, '=')
    r.carve(63, 16, 63, 18, '1')
    r.put(4, 18, 'P'); r.put(9, 18, 'B')
    r.put(14, 7, 'L'); r.put(37, 7, 'L'); r.put(56, 9, 'L')
    r.put(19, 11, 'g')
    r.put(34, 18, 'c'); r.put(55, 18, 'c'); r.put(52, 11, 'f')
    return r


def r2():
    r = Room(90, 34, 2)
    r.carve(1, 3, 88, 29)
    r.carve(0, 27, 0, 29, '1')
    r.carve(20, 30, 22, 32); r.carve(20, 33, 22, 33, '2')   # poco para o jardim
    r.carve(58, 30, 64, 30); r.carve(58, 31, 64, 31, '^')   # fosso largo: precisa do dash
    r.fill(57, 3, 66, 20)                                    # teto baixo sobre o fosso
    r.carve(89, 27, 89, 29, '3')
    r.fill(30, 3, 44, 8); r.fill(33, 9, 41, 10); r.fill(35, 11, 39, 11)
    r.fill(48, 17, 56, 19); r.fill(50, 20, 54, 20)
    r.fill(78, 3, 88, 9)
    r.roughen_ceiling(1, 29); r.roughen_ceiling(45, 56); r.roughen_ceiling(67, 77)
    r.carve(4, 18, 8, 18, '='); r.carve(10, 24, 14, 24, '='); r.carve(15, 21, 18, 21, '=')
    r.carve(24, 18, 28, 18, '='); r.carve(43, 22, 46, 22, '=')
    r.carve(70, 24, 74, 24, '='); r.carve(78, 20, 82, 20, '=')
    r.put(6, 17, 'g'); r.put(80, 19, 'g')
    r.put(6, 29, 'B')
    r.put(12, 7, 'L'); r.put(50, 6, 'L'); r.put(72, 11, 'L')
    r.put(32, 29, 'c'); r.put(47, 29, 'c'); r.put(76, 29, 'c')
    r.put(38, 19, 'f'); r.put(60, 25, 'f'); r.put(84, 16, 'f')
    r.put(52, 16, 's')
    return r


def r3():
    r = Room(96, 30, 3)
    r.carve(9, 0, 13, 5)
    r.carve(9, 0, 13, 0, '2')
    r.carve(1, 6, 94, 25)
    # escada de plataformas alternadas para subir de volta
    for i, y in enumerate(range(23, 1, -3)):
        if y <= 5:
            r.carve(9, y, 10, y, '=') if i % 2 == 0 else r.carve(12, y, 13, y, '=')
        else:
            r.carve(8, y, 10, y, '=') if i % 2 == 0 else r.carve(12, y, 14, y, '=')
    r.fill(14, 6, 30, 8); r.fill(1, 6, 7, 9)
    r.roughen_ceiling(15, 94)
    # relevo do chao
    r.fill(26, 23, 33, 25); r.fill(29, 21, 33, 22)
    r.carve(36, 26, 39, 26); r.carve(36, 27, 39, 27, '^')
    r.fill(44, 22, 52, 25)
    r.carve(55, 26, 58, 26); r.carve(55, 27, 58, 27, '^')
    r.fill(62, 20, 64, 25); r.carve(66, 21, 70, 21, '=')
    r.carve(73, 26, 76, 26); r.carve(73, 27, 76, 27, '^')
    r.fill(84, 21, 94, 25)
    r.fill(40, 6, 60, 11); r.fill(45, 12, 55, 13)
    r.carve(35, 17, 39, 17, '='); r.carve(55, 17, 59, 17, '='); r.carve(78, 18, 81, 18, '=')
    r.put(18, 25, 'B')
    r.put(22, 10, 'L'); r.put(66, 12, 'L'); r.put(88, 12, 'L')
    r.put(90, 20, 'D')
    r.put(37, 16, 'g')
    r.put(24, 25, 'c'); r.put(48, 21, 'c'); r.put(68, 25, 'c'); r.put(80, 25, 'c')
    r.put(42, 15, 'f'); r.put(70, 14, 'f')
    r.put(31, 20, 's'); r.put(63, 19, 's'); r.put(86, 20, 's')
    return r


def r4():
    r = Room(50, 60, 4)
    r.carve(0, 5, 8, 7); r.carve(0, 5, 0, 7, '1')
    r.carve(9, 3, 40, 55)
    r.carve(35, 5, 49, 7); r.carve(49, 5, 49, 7, '2')
    r.fill(35, 8, 40, 8)
    # zigue-zague: saltos de 5 blocos (so com pulo duplo)
    ledges = [(51, 14, 19), (46, 22, 27), (41, 14, 19), (36, 22, 27), (31, 14, 19),
              (26, 22, 27), (21, 14, 19), (16, 22, 27), (11, 28, 33)]
    for y, x0, x1 in ledges:
        r.fill(x0, y, x1, y)
    r.fill(9, 12, 12, 12)                    # atalho de volta a entrada (pulo duplo)
    for y in range(15, 54, 5):               # saliencias decorativas (espacadas: nao escalaveis)
        r.fill(9, y, 9, y + r.rng.randint(0, 1))
        r.fill(40, y + 2, 40, y + 2 + r.rng.randint(0, 1))
    r.roughen_ceiling(9, 34)
    r.put(13, 55, 'B'); r.put(30, 55, 'W')
    r.put(20, 30, 'L'); r.put(30, 45, 'L'); r.put(22, 50, 'L'); r.put(36, 14, 'L')
    r.put(24, 45, 's'); r.put(16, 30, 's'); r.put(24, 15, 's')
    r.put(30, 40, 'f'); r.put(15, 25, 'f'); r.put(33, 20, 'f'); r.put(20, 48, 'f')
    r.put(36, 55, 'c')
    return r


def r5():
    r = Room(44, 22, 5)
    r.carve(0, 15, 5, 17); r.carve(0, 15, 0, 17, '1')
    r.carve(6, 3, 41, 17)
    r.carve(4, 15, 4, 17, 'G')
    r.roughen_ceiling(6, 41, 0.5)
    r.carve(10, 12, 13, 12, '='); r.carve(33, 12, 36, 12, '=')
    r.put(12, 6, 'L'); r.put(24, 5, 'L'); r.put(35, 6, 'L')
    r.put(32, 17, 'K')
    return r


ROOMS = {'R1': r1, 'R2': r2, 'R3': r3, 'R4': r4, 'R5': r5}


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    out = os.path.join(here, '..', 'src', 'abismo', 'Maps.java')
    lines = ['package abismo;', '', '/** Gerado por tools/genmaps.py - edite o script, nao este arquivo. */',
             'final class Maps {', '    private Maps() {}', '']
    for name, fn in ROOMS.items():
        rows = fn().rows()
        lines.append(f'    static final String[] {name} = {{')
        for row in rows:
            lines.append(f'        "{row}",')
        lines.append('    };')
        lines.append('')
    lines.append('}')
    with open(out, 'w') as f:
        f.write('\n'.join(lines) + '\n')
    print('ok ->', os.path.normpath(out))


if __name__ == '__main__':
    main()
