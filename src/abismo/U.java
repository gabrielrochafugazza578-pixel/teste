package abismo;

import java.awt.Color;

/** Pequenas funcoes utilitarias de matematica e cor. */
final class U {
    private U() {}

    static final int W = 960, H = 540, T = 32;

    static double clamp(double v, double lo, double hi) { return v < lo ? lo : (v > hi ? hi : v); }
    static double lerp(double a, double b, double t) { return a + (b - a) * t; }
    static double approach(double v, double target, double d) {
        return v < target ? Math.min(v + d, target) : Math.max(v - d, target);
    }
    static double smooth(double t) { t = clamp(t, 0, 1); return t * t * (3 - 2 * t); }
    static double rnd(double a, double b) { return a + Math.random() * (b - a); }

    static Color rgb(int hex) { return new Color(hex); }

    static Color mix(Color a, Color b, double t) {
        t = clamp(t, 0, 1);
        return new Color((int) (a.getRed() + (b.getRed() - a.getRed()) * t),
                (int) (a.getGreen() + (b.getGreen() - a.getGreen()) * t),
                (int) (a.getBlue() + (b.getBlue() - a.getBlue()) * t),
                (int) (a.getAlpha() + (b.getAlpha() - a.getAlpha()) * t));
    }

    static Color alpha(Color c, double a) {
        return new Color(c.getRed(), c.getGreen(), c.getBlue(), (int) (clamp(a, 0, 1) * 255));
    }

    static Color scale(Color c, double k) {
        return new Color((int) clamp(c.getRed() * k, 0, 255), (int) clamp(c.getGreen() * k, 0, 255),
                (int) clamp(c.getBlue() * k, 0, 255), c.getAlpha());
    }

    static int argb(double r, double g, double b) {
        return 0xff000000 | ((int) clamp(r, 0, 255) << 16) | ((int) clamp(g, 0, 255) << 8) | (int) clamp(b, 0, 255);
    }
}
