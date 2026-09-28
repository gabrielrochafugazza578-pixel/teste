package abismo;

import java.awt.Shape;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Uma sala jogavel: colisao por blocos e arte pre-renderizada. */
final class Room {
    static final int EMPTY = 0, SOLID = 1, SPIKE = 2, PLATFORM = 3, GATE = 4;
    static final int T = U.T;

    final RoomDef def;
    final int w, h;
    final int[][] t;
    final List<int[]> spawns = new ArrayList<>(); // {char, tx, ty}
    final Map<Character, List<int[]>> doors = new HashMap<>();
    final List<int[]> lanterns = new ArrayList<>();
    final List<int[]> benches = new ArrayList<>();
    int[] start;
    boolean gateClosed;

    // arte
    BufferedImage terrain;
    BufferedImage[] layers;
    double[] layerF, layerScale;
    List<Shape> foreground;
    List<double[]> shafts;

    Room(RoomDef def) {
        this.def = def;
        this.h = def.map.length;
        int mw = 0;
        for (String s : def.map) mw = Math.max(mw, s.length());
        this.w = mw;
        t = new int[h][w];
        for (int y = 0; y < h; y++) {
            String row = def.map[y];
            for (int x = 0; x < w; x++) {
                char c = x < row.length() ? row.charAt(x) : '#';
                int tile = EMPTY;
                switch (c) {
                    case '#': tile = SOLID; break;
                    case '^': tile = SPIKE; break;
                    case '=': tile = PLATFORM; break;
                    case 'G': tile = GATE; break;
                    case '.': case ' ': break;
                    case 'P': start = new int[]{x, y}; break;
                    case 'B': benches.add(new int[]{x, y}); break;
                    case 'L': lanterns.add(new int[]{x, y}); break;
                    default:
                        if (c >= '1' && c <= '9') doors.computeIfAbsent(c, k -> new ArrayList<>()).add(new int[]{x, y});
                        else spawns.add(new int[]{c, x, y});
                }
                t[y][x] = tile;
            }
        }
    }

    void buildArt() {
        terrain = Art.terrain(this);
        Art.background(this);
    }

    int pxW() { return w * T; }
    int pxH() { return h * T; }

    int tile(int tx, int ty) {
        if (tx < 0 || ty < 0 || tx >= w || ty >= h) return SOLID;
        return t[ty][tx];
    }

    boolean solid(int tx, int ty) {
        int k = tile(tx, ty);
        return k == SOLID || (k == GATE && gateClosed);
    }

    /** Solido "visual": usado pela arte (ignora portoes e portas). */
    boolean rock(int tx, int ty) {
        if (tx < 0 || ty < 0 || tx >= w || ty >= h) {
            tx = Math.max(0, Math.min(w - 1, tx));
            ty = Math.max(0, Math.min(h - 1, ty));
            if (isDoor(tx, ty)) return false;
        }
        return t[ty][tx] == SOLID;
    }

    boolean platform(int tx, int ty) { return tile(tx, ty) == PLATFORM; }
    boolean spike(int tx, int ty) { return tile(tx, ty) == SPIKE; }

    boolean isDoor(int tx, int ty) { return doorAt(tx, ty) != 0; }

    char doorAt(int tx, int ty) {
        for (Map.Entry<Character, List<int[]>> e : doors.entrySet())
            for (int[] p : e.getValue()) if (p[0] == tx && p[1] == ty) return e.getKey();
        return 0;
    }

    /** Linha do teto acima de um ponto (em blocos). */
    int ceilingAbove(int tx, int ty) {
        int y = ty;
        while (y > 0 && !rock(tx, y - 1)) y--;
        return y;
    }

    /** Toca em espinhos? (caixa em pixels) */
    boolean touchesSpikes(double x, double y, double bw, double bh) {
        int x0 = (int) Math.floor(x / T), x1 = (int) Math.floor((x + bw - 0.01) / T);
        int y0 = (int) Math.floor(y / T), y1 = (int) Math.floor((y + bh - 0.01) / T);
        for (int ty = y0; ty <= y1; ty++)
            for (int tx = x0; tx <= x1; tx++)
                if (spike(tx, ty)) {
                    double top = ty * T + T * 0.35;
                    if (y + bh > top) return true;
                }
        return false;
    }
}
