package abismo;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;

/** Particulas: faiscas, brilhos, gosma, poeira, aneis de impacto. */
final class Particle {
    static final int GLOW = 0, DOT = 1, SPARK = 2, RING = 3, SHARD = 4, GHOST = 5, DUST = 6;

    int type;
    double x, y, vx, vy, life, max, size, gravity, drag = 0.0, rot, vrot;
    Color color;
    int facing = 1;

    Particle(int type, double x, double y, double vx, double vy, double life, double size, Color color) {
        this.type = type;
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
        this.life = this.max = life;
        this.size = size;
        this.color = color;
        this.rot = Math.random() * Math.PI * 2;
        this.vrot = (Math.random() - 0.5) * 10;
    }

    Particle grav(double g) { gravity = g; return this; }
    Particle drag(double d) { drag = d; return this; }

    boolean update(double dt) {
        life -= dt;
        vy += gravity * dt;
        double k = Math.pow(1 - drag, dt * 60);
        vx *= k;
        vy *= k;
        x += vx * dt;
        y += vy * dt;
        rot += vrot * dt;
        return life > 0;
    }

    void render(Graphics2D g, double cx, double cy) {
        double t = life / max;
        double sx = x - cx, sy = y - cy;
        if (sx < -80 || sy < -80 || sx > U.W + 80 || sy > U.H + 80) return;
        switch (type) {
            case GLOW: {
                double s = size * (0.5 + 0.5 * t) * 4;
                Art.setAlpha(g, t);
                g.drawImage(Art.glow(color), (int) (sx - s / 2), (int) (sy - s / 2), (int) s, (int) s, null);
                Art.setAlpha(g, 1);
                g.setColor(U.alpha(Color.WHITE, t * 0.9));
                double c = size * 0.35 * (0.4 + 0.6 * t);
                g.fill(new Ellipse2D.Double(sx - c, sy - c, c * 2, c * 2));
                break;
            }
            case DOT: {
                g.setColor(U.alpha(color, Math.min(1, t * 1.5)));
                double s = size * (0.4 + 0.6 * t);
                g.fill(new Ellipse2D.Double(sx - s, sy - s, s * 2, s * 2));
                break;
            }
            case SPARK: {
                g.setColor(U.alpha(color, t));
                g.setStroke(new BasicStroke((float) (size * t + 0.5), BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
                g.draw(new Line2D.Double(sx, sy, sx - vx * 0.03, sy - vy * 0.03));
                break;
            }
            case RING: {
                double r = size * (1 - t) + 4;
                g.setColor(U.alpha(color, t * 0.8));
                g.setStroke(new BasicStroke((float) (4 * t + 0.5)));
                g.draw(new Ellipse2D.Double(sx - r, sy - r, r * 2, r * 2));
                break;
            }
            case SHARD: {
                g.setColor(U.alpha(color, Math.min(1, t * 2)));
                Path2D p = new Path2D.Double();
                double c = Math.cos(rot), s = Math.sin(rot), z = size;
                p.moveTo(sx + c * z, sy + s * z);
                p.lineTo(sx - s * z * 0.5, sy + c * z * 0.5);
                p.lineTo(sx - c * z * 0.8, sy - s * z * 0.8);
                p.closePath();
                g.fill(p);
                break;
            }
            case GHOST: {
                Player.drawSilhouette(g, sx, sy, facing, color, t * 0.45);
                break;
            }
            case DUST: {
                g.setColor(U.alpha(color, t * 0.35));
                double s = size * (1.5 - t);
                g.fill(new Ellipse2D.Double(sx - s, sy - s * 0.6, s * 2, s * 1.2));
                break;
            }
            default: break;
        }
    }
}
