package abismo;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.MultipleGradientPaint;
import java.awt.RadialGradientPaint;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.geom.AffineTransform;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;
import java.awt.geom.Point2D;
import java.awt.geom.QuadCurve2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.awt.image.DataBufferInt;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

/** Toda a arte procedural: terreno texturizado, cenarios em camadas, brilhos. */
final class Art {
    private Art() {}

    static final int T = U.T;

    static Graphics2D hq(BufferedImage img) {
        Graphics2D g = img.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        return g;
    }

    // ------------------------------------------------------------------ terreno

    static BufferedImage terrain(Room r) {
        Theme th = r.def.theme;
        int seed = r.def.id.hashCode() & 0xffff;
        int W = r.pxW(), H = r.pxH();
        int gw = r.w + 2, gh = r.h + 2;
        float[] sol = new float[gw * gh];
        float[] dep = new float[gw * gh];
        ArrayDeque<int[]> q = new ArrayDeque<>();
        for (int gy = 0; gy < gh; gy++)
            for (int gx = 0; gx < gw; gx++) {
                boolean s = r.rock(gx - 1, gy - 1);
                sol[gy * gw + gx] = s ? 1 : 0;
                dep[gy * gw + gx] = s ? 99 : 0;
                if (!s) q.add(new int[]{gx, gy});
            }
        while (!q.isEmpty()) {
            int[] p = q.poll();
            float d = dep[p[1] * gw + p[0]];
            int[][] nb = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
            for (int[] n : nb) {
                int nx = p[0] + n[0], ny = p[1] + n[1];
                if (nx < 0 || ny < 0 || nx >= gw || ny >= gh) continue;
                if (dep[ny * gw + nx] > d + 1) {
                    dep[ny * gw + nx] = d + 1;
                    q.add(new int[]{nx, ny});
                }
            }
        }

        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_ARGB_PRE);
        int[] px = ((DataBufferInt) img.getRaster().getDataBuffer()).getData();
        Color base = th.rock, dark = th.rockDark, rim = th.rim;
        for (int py = 0; py < H; py++) {
            double gyf = py / (double) T + 0.5;
            int iy = (int) gyf;
            double fy = gyf - iy;
            for (int pxx = 0; pxx < W; pxx++) {
                double gxf = pxx / (double) T + 0.5;
                int ix = (int) gxf;
                double fx = gxf - ix;
                int i00 = iy * gw + ix;
                float s00 = sol[i00], s10 = sol[i00 + 1], s01 = sol[i00 + gw], s11 = sol[i00 + gw + 1];
                float sum = s00 + s10 + s01 + s11;
                if (sum == 0) continue;
                double d = s00 * (1 - fx) * (1 - fy) + s10 * fx * (1 - fy) + s01 * (1 - fx) * fy + s11 * fx * fy;
                if (sum < 4) d += (Noise.fbm(pxx * 0.06, py * 0.06, 2, seed) - 0.5) * 0.28;
                if (d < 0.5) continue;
                double depth = Math.min(dep[i00], 8) * (1 - fx) * (1 - fy) + Math.min(dep[i00 + 1], 8) * fx * (1 - fy)
                        + Math.min(dep[i00 + gw], 8) * (1 - fx) * fy + Math.min(dep[i00 + gw + 1], 8) * fx * fy;
                double grain = Noise.hash(pxx, py, seed) - 0.5;
                if (depth > 4.2) {
                    double k = 0.8 + grain * 0.1;
                    px[py * W + pxx] = U.argb(dark.getRed() * k, dark.getGreen() * k, dark.getBlue() * k);
                    continue;
                }
                double tex = Noise.fbm(pxx * 0.02, py * 0.02, 3, seed + 5);
                double fine = Noise.value(pxx * 0.25, py * 0.25, seed + 11);
                double shade = 1 - U.smooth((depth - 0.4) / 3.6);
                double k = (0.62 + 0.7 * tex + 0.1 * fine);
                double cr = U.lerp(dark.getRed(), base.getRed(), shade) * k + grain * 6;
                double cg = U.lerp(dark.getGreen(), base.getGreen(), shade) * k + grain * 6;
                double cb = U.lerp(dark.getBlue(), base.getBlue(), shade) * k + grain * 6;
                double crack = Math.abs(Noise.fbm(pxx * 0.028, py * 0.028, 2, seed + 9) * 2 - 1);
                if (crack < 0.022 && depth > 0.35) { double m = 0.72 + crack * 10; cr *= m; cg *= m; cb *= m; }
                double e = d - 0.5;
                if (sum < 4 && e < 0.22) {
                    double gradY = (s01 - s00) * (1 - fx) + (s11 - s10) * fx;
                    double gradX = Math.abs((s10 - s00) * (1 - fy) + (s11 - s01) * fy);
                    double lit = U.clamp(0.25 + 0.75 * Math.max(0, gradY) + 0.3 * gradX, 0, 1);
                    double m = e < 0.06 ? 0.85 * lit : (1 - (e - 0.06) / 0.16) * 0.28 * lit;
                    if (gradY < -0.2) m *= 0.35; // bordas de baixo: quase sem brilho
                    cr = U.lerp(cr, rim.getRed(), m);
                    cg = U.lerp(cg, rim.getGreen(), m);
                    cb = U.lerp(cb, rim.getBlue(), m);
                }
                px[py * W + pxx] = U.argb(cr, cg, cb);
            }
        }

        Graphics2D g = hq(img);
        Random rnd = new Random(seed);
        for (int ty = 0; ty < r.h; ty++)
            for (int tx = 0; tx < r.w; tx++) {
                if (r.rock(tx, ty) && ty > 0 && !r.rock(tx, ty - 1)) decorTop(g, th, tx * T, ty * T, rnd);
                if (r.rock(tx, ty) && ty < r.h - 1 && !r.rock(tx, ty + 1)) decorBottom(g, th, tx * T, (ty + 1) * T, rnd);
                if (r.spike(tx, ty)) spikes(g, th, tx * T, ty * T, rnd);
                if (r.platform(tx, ty) && !r.platform(tx - 1, ty)) {
                    int len = 0;
                    while (r.platform(tx + len, ty)) len++;
                    platform(g, th, tx * T, ty * T, len * T, rnd);
                }
            }
        g.dispose();
        return img;
    }

    private static void decorTop(Graphics2D g, Theme th, int x, int y, Random rnd) {
        switch (th.key) {
            case "garden": {
                g.setColor(U.mix(th.rock, th.rim, 0.35));
                for (int i = 0; i < 4; i++)
                    g.fill(new Ellipse2D.Double(x + rnd.nextDouble() * T - 6, y - 2 + rnd.nextDouble() * 3, 12 + rnd.nextDouble() * 8, 6));
                for (int i = 0; i < 11; i++) {
                    double x0 = x + rnd.nextDouble() * T, len = 4 + rnd.nextDouble() * 13, bend = (rnd.nextDouble() - 0.5) * 9;
                    g.setStroke(new BasicStroke((float) (1.2 + rnd.nextDouble() * 1.2), BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
                    g.setColor(U.mix(U.scale(th.rim, 0.45), th.rim, rnd.nextDouble()));
                    g.draw(new QuadCurve2D.Double(x0, y + 2, x0 + bend * 0.3, y - len * 0.6, x0 + bend, y - len));
                }
                if (rnd.nextDouble() < 0.12) {
                    double fx = x + rnd.nextDouble() * T, fh = 10 + rnd.nextDouble() * 12;
                    g.setStroke(new BasicStroke(1.2f));
                    g.setColor(U.scale(th.rim, 0.6));
                    g.draw(new QuadCurve2D.Double(fx, y, fx + 2, y - fh * 0.5, fx - 1, y - fh));
                    g.setColor(U.alpha(th.accent, 0.9));
                    g.fill(new Ellipse2D.Double(fx - 3, y - fh - 3, 6, 6));
                }
                break;
            }
            case "abyss": {
                if (rnd.nextDouble() < 0.18) crystal(g, th, x + rnd.nextDouble() * T, y + 2, 8 + rnd.nextDouble() * 16, rnd, -1);
                g.setColor(U.alpha(th.rim, 0.5));
                for (int i = 0; i < 3; i++) g.fill(new Ellipse2D.Double(x + rnd.nextDouble() * T, y - 1, 2 + rnd.nextDouble() * 3, 2));
                break;
            }
            case "arena": {
                g.setColor(U.alpha(U.mix(th.rim, Color.WHITE, 0.3), 0.6));
                for (int i = 0; i < 3; i++) g.fill(new Ellipse2D.Double(x + rnd.nextDouble() * T, y - 1.5, 3 + rnd.nextDouble() * 5, 2.5));
                if (rnd.nextDouble() < 0.15) {
                    g.setColor(U.alpha(th.accent, 0.7));
                    g.fill(new Ellipse2D.Double(x + rnd.nextDouble() * T, y + 3 + rnd.nextDouble() * 6, 2.5, 2.5));
                }
                break;
            }
            default: {
                g.setColor(U.alpha(th.rim, 0.55));
                for (int i = 0; i < 4; i++)
                    g.fill(new Ellipse2D.Double(x + rnd.nextDouble() * T - 2, y - 1.5 + rnd.nextDouble() * 2, 3 + rnd.nextDouble() * 6, 2 + rnd.nextDouble() * 2));
                if (rnd.nextDouble() < 0.1) {
                    double sx = x + rnd.nextDouble() * T, sh = 6 + rnd.nextDouble() * 12;
                    Path2D p = new Path2D.Double();
                    p.moveTo(sx - 4, y + 1);
                    p.lineTo(sx + 0.5, y - sh);
                    p.lineTo(sx + 4, y + 1);
                    p.closePath();
                    g.setPaint(new GradientPaint((float) sx, (float) (y - sh), U.mix(th.rock, th.rim, 0.5), (float) sx, y, th.rock));
                    g.fill(p);
                }
            }
        }
    }

    private static void decorBottom(Graphics2D g, Theme th, int x, int y, Random rnd) {
        switch (th.key) {
            case "garden": {
                if (rnd.nextDouble() < 0.35) {
                    double vx = x + rnd.nextDouble() * T, len = 15 + rnd.nextDouble() * 70, sway = (rnd.nextDouble() - 0.5) * 16;
                    g.setStroke(new BasicStroke(1.6f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
                    Color vc = U.mix(th.rock, th.rim, 0.35);
                    g.setColor(vc);
                    g.draw(new QuadCurve2D.Double(vx, y - 2, vx + sway, y + len * 0.5, vx + sway * 0.4, y + len));
                    for (double s = 0.2; s < 1; s += 0.18) {
                        double lx = vx + sway * (2 * s * (1 - s)) + sway * 0.4 * s * s, ly = y + len * s;
                        g.setColor(U.mix(vc, th.rim, rnd.nextDouble() * 0.6));
                        double side = rnd.nextBoolean() ? 1 : -1;
                        g.fill(new Ellipse2D.Double(lx + (side > 0 ? 0 : -7), ly - 2, 7, 3.5));
                    }
                }
                break;
            }
            case "abyss": {
                if (rnd.nextDouble() < 0.2) crystal(g, th, x + rnd.nextDouble() * T, y - 2, 6 + rnd.nextDouble() * 10, rnd, 1);
                break;
            }
            default: {
                if (rnd.nextDouble() < 0.3) {
                    double sx = x + rnd.nextDouble() * T, sh = 6 + rnd.nextDouble() * (th.key.equals("arena") ? 14 : 22), sw = 3 + rnd.nextDouble() * 4;
                    Path2D p = new Path2D.Double();
                    p.moveTo(sx - sw, y - 2);
                    p.quadTo(sx - sw * 0.3, y + sh * 0.6, sx, y + sh);
                    p.quadTo(sx + sw * 0.3, y + sh * 0.6, sx + sw, y - 2);
                    p.closePath();
                    g.setPaint(new GradientPaint((float) sx, y, th.rock, (float) sx, (float) (y + sh), U.mix(th.rock, th.rim, 0.25)));
                    g.fill(p);
                }
            }
        }
    }

    static void crystal(Graphics2D g, Theme th, double x, double y, double size, Random rnd, int dir) {
        int n = 2 + rnd.nextInt(3);
        for (int i = 0; i < n; i++) {
            double ang = (rnd.nextDouble() - 0.5) * 0.9, len = size * (0.5 + rnd.nextDouble() * 0.6), wdt = 2.5 + rnd.nextDouble() * 2.5;
            double tx = x + Math.sin(ang) * len, ty = y + dir * Math.cos(ang) * len;
            Path2D p = new Path2D.Double();
            p.moveTo(x - wdt, y);
            p.lineTo(tx - wdt * 0.4, ty - dir * wdt);
            p.lineTo(tx, ty);
            p.lineTo(x + wdt, y);
            p.closePath();
            g.setPaint(new GradientPaint((float) x, (float) y, U.alpha(U.scale(th.accent, 0.5), 0.9), (float) tx, (float) ty, U.alpha(U.mix(th.accent, Color.WHITE, 0.4), 0.95)));
            g.fill(p);
        }
    }

    private static void spikes(Graphics2D g, Theme th, int x, int y, Random rnd) {
        Color tip = th.key.equals("garden") ? U.mix(th.rim, Color.WHITE, 0.2) : U.mix(th.rim, Color.WHITE, 0.45);
        Color bot = th.key.equals("garden") ? U.rgb(0x1b2a1a) : U.scale(th.rock, 0.8);
        for (int i = 0; i < 4; i++) {
            double cx = x + 4 + i * 8 + rnd.nextDouble() * 2, top = y + T * 0.2 + rnd.nextDouble() * 8;
            Path2D p = new Path2D.Double();
            p.moveTo(cx - 5, y + T);
            p.quadTo(cx - 1, y + T * 0.6, cx + (rnd.nextDouble() - 0.5) * 3, top);
            p.quadTo(cx + 1.5, y + T * 0.6, cx + 5, y + T);
            p.closePath();
            g.setPaint(new GradientPaint((float) cx, (float) top, tip, (float) cx, y + T, bot));
            g.fill(p);
            g.setColor(U.alpha(Color.BLACK, 0.5));
            g.setStroke(new BasicStroke(1f));
            g.draw(p);
        }
    }

    private static void platform(Graphics2D g, Theme th, int x, int y, int len, Random rnd) {
        Color top = U.mix(th.rock, th.rim, 0.3);
        RoundRectangle2D slab = new RoundRectangle2D.Double(x - 2, y, len + 4, 12, 10, 10);
        g.setPaint(new GradientPaint(x, y, top, x, y + 12, U.scale(th.rock, 0.6)));
        g.fill(slab);
        g.setColor(U.alpha(th.rim, 0.8));
        g.setStroke(new BasicStroke(1.5f));
        g.drawLine(x + 3, y + 1, x + len - 3, y + 1);
        g.setColor(U.alpha(Color.BLACK, 0.45));
        for (int i = 1; i < len / 18; i++) {
            int cx = x + i * 18 + rnd.nextInt(6);
            g.drawLine(cx, y + 3, cx - 2, y + 11);
        }
        // raizes / correntes pendentes
        g.setStroke(new BasicStroke(1.2f));
        for (int i = 0; i < len / 24 + 1; i++) {
            double rx = x + 6 + rnd.nextDouble() * (len - 12), rl = 6 + rnd.nextDouble() * 16;
            g.setColor(U.alpha(U.mix(th.rock, th.rim, 0.25), 0.8));
            g.draw(new QuadCurve2D.Double(rx, y + 11, rx + 3, y + 11 + rl * 0.5, rx + 1, y + 11 + rl));
        }
    }

    // ------------------------------------------------------------------ cenario (parallax)

    static void background(Room r) {
        Theme th = r.def.theme;
        int seed = r.def.id.hashCode() & 0xffff;
        r.layerF = new double[]{0.18, 0.38, 0.6};
        double[] scale = {0.5, 0.7, 1.0};
        r.layers = new BufferedImage[3];
        for (int i = 0; i < 3; i++) {
            double f = r.layerF[i];
            int lw = (int) (U.W + Math.max(0, r.pxW() - U.W) * f) + 80;
            int lh = (int) (U.H + Math.max(0, r.pxH() - U.H) * f) + 80;
            double s = scale[i];
            BufferedImage small = new BufferedImage((int) (lw * s) + 1, (int) (lh * s) + 1, BufferedImage.TYPE_INT_ARGB_PRE);
            Graphics2D g = hq(small);
            g.scale(s, s);
            Color col = i == 0 ? U.mix(th.sky2, th.fog, 0.5) : i == 1 ? U.mix(th.sky2, th.fog, 0.2) : U.mix(th.rockDark, th.sky2, 0.55);
            Random rnd = new Random(seed * 7 + i);
            drawLayer(g, th, lw, lh, i, col, rnd, seed + i * 101);
            g.dispose();
            // a camada mais distante ja inclui o ceu e e opaca (copia rapida por quadro)
            BufferedImage full = new BufferedImage(lw, lh, i == 0 ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB_PRE);
            Graphics2D g2 = hq(full);
            if (i == 0) {
                g2.setPaint(new GradientPaint(0, 0, th.sky1, 0, lh, th.sky2));
                g2.fillRect(0, 0, lw, lh);
                setAlpha(g2, 0.35);
                g2.drawImage(glow(th.fog), lw / 2 - 900, -600, 1800, 1200, null);
                setAlpha(g2, 1);
            }
            g2.drawImage(small, 0, 0, lw, lh, null);
            g2.dispose();
            r.layers[i] = full;
        }
        // raios de luz
        Random rnd = new Random(seed + 3);
        r.shafts = new ArrayList<>();
        int ns = 2 + r.pxW() / 700;
        for (int i = 0; i < ns; i++)
            r.shafts.add(new double[]{rnd.nextDouble() * r.pxW(), 50 + rnd.nextDouble() * 110, 0.25 + rnd.nextDouble() * 0.25,
                    500 + rnd.nextDouble() * 500, 0.05 + rnd.nextDouble() * 0.06, rnd.nextDouble() * 10});
        // silhuetas em primeiro plano (parallax 1.25)
        r.foreground = new ArrayList<>();
        double fgF = 1.25;
        double totalW = U.W + Math.max(0, r.pxW() - U.W) * fgF;
        double bottom = U.H + Math.max(0, r.pxH() - U.H) * fgF;
        for (double x = rnd.nextDouble() * 200; x < totalW; x += 260 + rnd.nextDouble() * 420) {
            double hh = 50 + rnd.nextDouble() * 110;
            r.foreground.add(fgMound(x, bottom + 30, 120 + rnd.nextDouble() * 220, hh, rnd, th));
        }
        for (double x = rnd.nextDouble() * 300; x < totalW; x += 300 + rnd.nextDouble() * 500) {
            r.foreground.add(stalactite(x, -30, 20 + rnd.nextDouble() * 50, 80 + rnd.nextDouble() * 140, rnd));
        }
    }

    private static void drawLayer(Graphics2D g, Theme th, int lw, int lh, int i, Color col, Random rnd, int seed) {
        g.setColor(col);
        double amp = 40 + i * 30;
        // massa superior e inferior
        Path2D top = new Path2D.Double();
        top.moveTo(0, 0);
        for (int x = 0; x <= lw; x += 8) top.lineTo(x, 20 + i * 15 + Noise.line(x * 0.004, seed) * amp * 2);
        top.lineTo(lw, 0);
        top.closePath();
        g.fill(top);
        Path2D bot = new Path2D.Double();
        bot.moveTo(0, lh);
        for (int x = 0; x <= lw; x += 8) bot.lineTo(x, lh - 30 - i * 25 - Noise.line(x * 0.003, seed + 9) * amp * 2.2);
        bot.lineTo(lw, lh);
        bot.closePath();
        g.fill(bot);

        // estalactites e estalagmites
        int n = lw / (110 - i * 25);
        for (int k = 0; k < n; k++) {
            double x = rnd.nextDouble() * lw;
            double wdt = (14 + rnd.nextDouble() * 50) * (1 + i * 0.35);
            if (rnd.nextBoolean()) g.fill(stalactite(x, 0, wdt, 60 + rnd.nextDouble() * (160 + i * 60), rnd));
            else g.fill(stalagmite(x, lh, wdt, 60 + rnd.nextDouble() * (140 + i * 60), rnd));
        }
        // colunas atravessando
        int cols = lw / (600 + i * 200);
        for (int k = 0; k < cols; k++) {
            double x = rnd.nextDouble() * lw, wdt = 30 + rnd.nextDouble() * 60 * (1 + i * 0.4);
            g.fill(pillar(x, lh, wdt, rnd, seed + k));
        }

        switch (th.key) {
            case "caverns": if (i == 0) spires(g, th, lw, lh, col, rnd); break;
            case "garden": fronds(g, th, lw, lh, col, rnd, i); break;
            case "abyss": if (i < 2) ruins(g, th, lw, lh, col, rnd, true); break;
            case "arena": ruins(g, th, lw, lh, col, rnd, false); break;
            default: break;
        }
        // neblina na parte de baixo da camada (apenas sobre o que foi desenhado)
        java.awt.Composite oc = g.getComposite();
        g.setComposite(AlphaComposite.SrcAtop);
        g.setPaint(new GradientPaint(0, lh * 0.35f, U.alpha(th.fog, 0), 0, lh, U.alpha(th.fog, 0.3 - i * 0.08)));
        g.fillRect(0, 0, lw, lh);
        g.setComposite(oc);
        // luzes distantes
        if (i == 0) {
            for (int k = 0; k < lw / 70; k++) {
                double x = rnd.nextDouble() * lw, y = rnd.nextDouble() * lh, rr = 2 + rnd.nextDouble() * 5;
                g.drawImage(glow(th.accent), (int) (x - rr * 4), (int) (y - rr * 4), (int) (rr * 8), (int) (rr * 8), null);
            }
        }
    }

    private static void spires(Graphics2D g, Theme th, int lw, int lh, Color col, Random rnd) {
        for (double x = rnd.nextDouble() * 200; x < lw; x += 180 + rnd.nextDouble() * 260) {
            double wdt = 26 + rnd.nextDouble() * 30, ht = lh * (0.35 + rnd.nextDouble() * 0.35);
            double base = lh - 40;
            Path2D p = new Path2D.Double();
            p.moveTo(x - wdt / 2, base);
            p.lineTo(x - wdt / 2, base - ht);
            p.lineTo(x - wdt * 0.3, base - ht - 14);
            p.lineTo(x, base - ht - 60 - rnd.nextDouble() * 40);
            p.lineTo(x + wdt * 0.3, base - ht - 14);
            p.lineTo(x + wdt / 2, base - ht);
            p.lineTo(x + wdt / 2, base);
            p.closePath();
            g.setColor(col);
            g.fill(p);
            for (int k = 0; k < 4; k++) {
                if (rnd.nextDouble() < 0.6) {
                    double wy = base - ht + 20 + k * 34;
                    g.setColor(U.alpha(th.accent, 0.55));
                    g.fill(new Ellipse2D.Double(x - 4, wy, 8, 12));
                }
            }
        }
    }

    private static void fronds(Graphics2D g, Theme th, int lw, int lh, Color col, Random rnd, int layer) {
        g.setColor(col);
        for (double x = rnd.nextDouble() * 100; x < lw; x += 120 + rnd.nextDouble() * 200) {
            boolean fromTop = rnd.nextBoolean();
            double baseY = fromTop ? 20 : lh - 30;
            int leaves = 3 + rnd.nextInt(4);
            for (int k = 0; k < leaves; k++) {
                double ang = (fromTop ? Math.PI / 2 : -Math.PI / 2) + (rnd.nextDouble() - 0.5) * 1.8;
                double len = 60 + rnd.nextDouble() * (90 + layer * 40), wd = 14 + rnd.nextDouble() * 16;
                AffineTransform old = g.getTransform();
                g.translate(x, baseY);
                g.rotate(ang);
                Path2D leaf = new Path2D.Double();
                leaf.moveTo(0, 0);
                leaf.quadTo(len * 0.5, -wd, len, 0);
                leaf.quadTo(len * 0.5, wd, 0, 0);
                g.fill(leaf);
                g.setTransform(old);
            }
        }
    }

    private static void ruins(Graphics2D g, Theme th, int lw, int lh, Color col, Random rnd, boolean broken) {
        g.setColor(col);
        for (double x = rnd.nextDouble() * 200; x < lw; x += 220 + rnd.nextDouble() * 300) {
            double wdt = 24 + rnd.nextDouble() * 18, ht = lh * (0.3 + rnd.nextDouble() * 0.4), base = lh - 30;
            g.fillRect((int) (x - wdt / 2), (int) (base - ht), (int) wdt, (int) ht);
            g.fillRect((int) (x - wdt * 0.8), (int) (base - ht - 10), (int) (wdt * 1.6), 12);
            if (!broken) {
                g.fillRect((int) (x - wdt * 0.8), (int) (base - 12), (int) (wdt * 1.6), 12);
                if (rnd.nextDouble() < 0.6) {
                    double span = 140 + rnd.nextDouble() * 80;
                    Path2D arch = new Path2D.Double();
                    arch.moveTo(x, base - ht - 10);
                    arch.quadTo(x + span / 2, base - ht - 110, x + span, base - ht - 10);
                    arch.lineTo(x + span, base - ht + 6);
                    arch.quadTo(x + span / 2, base - ht - 86, x, base - ht + 6);
                    arch.closePath();
                    g.fill(arch);
                }
                // estandarte
                if (rnd.nextDouble() < 0.5) {
                    g.setColor(U.alpha(U.mix(col, th.accent, 0.35), 0.9));
                    Path2D ban = new Path2D.Double();
                    double by = base - ht + 10;
                    ban.moveTo(x - 10, by);
                    ban.lineTo(x + 10, by);
                    ban.lineTo(x + 10, by + 70);
                    ban.lineTo(x, by + 58);
                    ban.lineTo(x - 10, by + 70);
                    ban.closePath();
                    g.fill(ban);
                    g.setColor(col);
                }
            } else {
                // pedras flutuantes
                double fy = base - ht - 60 - rnd.nextDouble() * 80;
                g.fill(new Ellipse2D.Double(x - 20, fy, 40 + rnd.nextDouble() * 30, 18));
                g.fill(stalactite(x + 10, fy + 9, 30, 40, rnd));
            }
        }
    }

    static Shape stalactite(double x, double y, double wdt, double len, Random rnd) {
        Path2D p = new Path2D.Double();
        double wob = (rnd.nextDouble() - 0.5) * wdt * 0.6;
        p.moveTo(x - wdt / 2, y - 10);
        p.curveTo(x - wdt * 0.45, y + len * 0.4, x - wdt * 0.1 + wob, y + len * 0.7, x + wob, y + len);
        p.curveTo(x + wdt * 0.1 + wob, y + len * 0.7, x + wdt * 0.45, y + len * 0.35, x + wdt / 2, y - 10);
        p.closePath();
        return p;
    }

    static Shape stalagmite(double x, double y, double wdt, double len, Random rnd) {
        Path2D p = new Path2D.Double();
        double wob = (rnd.nextDouble() - 0.5) * wdt * 0.5;
        p.moveTo(x - wdt / 2, y + 10);
        p.curveTo(x - wdt * 0.4, y - len * 0.4, x - wdt * 0.12 + wob, y - len * 0.75, x + wob, y - len);
        p.curveTo(x + wdt * 0.12 + wob, y - len * 0.75, x + wdt * 0.4, y - len * 0.4, x + wdt / 2, y + 10);
        p.closePath();
        return p;
    }

    private static Shape pillar(double x, double lh, double wdt, Random rnd, int seed) {
        Path2D p = new Path2D.Double();
        p.moveTo(x - wdt / 2, -10);
        for (int y = 0; y <= lh + 10; y += 20) {
            double nx = (Noise.line(y * 0.01, seed) - 0.5) * wdt * 0.6;
            double pinch = 1 - 0.35 * Math.sin(Math.PI * y / lh);
            p.lineTo(x - wdt / 2 * pinch + nx, y);
        }
        for (int y = (int) lh + 10; y >= 0; y -= 20) {
            double nx = (Noise.line(y * 0.01, seed + 5) - 0.5) * wdt * 0.6;
            double pinch = 1 - 0.35 * Math.sin(Math.PI * y / lh);
            p.lineTo(x + wdt / 2 * pinch + nx, y);
        }
        p.closePath();
        return p;
    }

    private static Shape fgMound(double x, double baseY, double wdt, double ht, Random rnd, Theme th) {
        Path2D p = new Path2D.Double();
        p.moveTo(x - wdt / 2, baseY);
        int steps = 10;
        for (int k = 0; k <= steps; k++) {
            double t = k / (double) steps;
            double hx = x - wdt / 2 + wdt * t;
            double hy = baseY - Math.sin(Math.PI * t) * ht * (0.7 + rnd.nextDouble() * 0.4);
            p.lineTo(hx, hy);
        }
        p.closePath();
        if (th.key.equals("garden")) {
            for (int k = 0; k < 5; k++) {
                double lx = x + (rnd.nextDouble() - 0.5) * wdt * 0.6, len = ht * (0.8 + rnd.nextDouble());
                double ang = -Math.PI / 2 + (rnd.nextDouble() - 0.5) * 1.4;
                Path2D leaf = new Path2D.Double();
                leaf.moveTo(lx, baseY - ht * 0.4);
                double tx = lx + Math.cos(ang) * len, ty = baseY - ht * 0.4 + Math.sin(ang) * len;
                leaf.quadTo((lx + tx) / 2 + 20, (baseY - ht * 0.4 + ty) / 2, tx, ty);
                leaf.quadTo((lx + tx) / 2 - 20, (baseY - ht * 0.4 + ty) / 2, lx, baseY - ht * 0.4);
                p.append(leaf, false);
            }
        }
        return p;
    }

    // ------------------------------------------------------------------ sprites de brilho

    private static final Map<Integer, BufferedImage> GLOWS = new HashMap<>();

    static synchronized BufferedImage glow(Color c) {
        return GLOWS.computeIfAbsent(c.getRGB(), k -> {
            int s = 64;
            BufferedImage img = new BufferedImage(s, s, BufferedImage.TYPE_INT_ARGB_PRE);
            Graphics2D g = hq(img);
            g.setPaint(new RadialGradientPaint(new Point2D.Double(s / 2.0, s / 2.0), s / 2f, new float[]{0f, 0.25f, 1f},
                    new Color[]{U.alpha(c, 0.9), U.alpha(c, 0.35), U.alpha(c, 0)}));
            g.fillRect(0, 0, s, s);
            g.dispose();
            return img;
        });
    }

    /** Desenha uma lista de silhuetas com deslocamento e cor. */
    static void fillShapes(Graphics2D g, List<Shape> shapes, double ox, double oy, Color c) {
        AffineTransform old = g.getTransform();
        g.translate(ox, oy);
        g.setColor(c);
        java.awt.Rectangle clip = new java.awt.Rectangle((int) -ox - 50, (int) -oy - 50, U.W + 100, U.H + 100);
        for (Shape s : shapes) if (s.getBounds().intersects(clip)) g.fill(s);
        g.setTransform(old);
    }

    static void setAlpha(Graphics2D g, double a) {
        g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, (float) U.clamp(a, 0, 1)));
    }
}
