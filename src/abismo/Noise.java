package abismo;

/** Ruido de valor deterministico usado para gerar texturas e cenarios. */
final class Noise {
    private Noise() {}

    static double hash(int x, int y, int seed) {
        int h = x * 374761393 + y * 668265263 + seed * 1442695041;
        h = (h ^ (h >>> 13)) * 1274126177;
        h ^= (h >>> 16);
        return (h & 0x7fffffff) / 2147483647.0;
    }

    static double value(double x, double y, int seed) {
        int xi = (int) Math.floor(x), yi = (int) Math.floor(y);
        double fx = x - xi, fy = y - yi;
        double u = fx * fx * (3 - 2 * fx), v = fy * fy * (3 - 2 * fy);
        double a = hash(xi, yi, seed), b = hash(xi + 1, yi, seed);
        double c = hash(xi, yi + 1, seed), d = hash(xi + 1, yi + 1, seed);
        return a + (b - a) * u + (c - a) * v + (a - b - c + d) * u * v;
    }

    static double fbm(double x, double y, int octaves, int seed) {
        double sum = 0, amp = 0.5, norm = 0;
        for (int i = 0; i < octaves; i++) {
            sum += value(x, y, seed + i * 31) * amp;
            norm += amp;
            x *= 2.03;
            y *= 2.03;
            amp *= 0.5;
        }
        return sum / norm;
    }

    /** Ruido 1D suave, util para contornos de silhuetas. */
    static double line(double x, int seed) { return fbm(x, 0.5, 3, seed); }
}
