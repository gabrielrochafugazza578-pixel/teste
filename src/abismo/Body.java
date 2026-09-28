package abismo;

import java.awt.geom.Rectangle2D;

/** Corpo fisico com colisao contra os blocos da sala. */
class Body {
    static final int T = U.T;
    double x, y, w, h, vx, vy;
    boolean onGround, wallL, wallR, ceil;
    boolean dropThrough;
    boolean collides = true;

    Body(double x, double y, double w, double h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    double cx() { return x + w / 2; }
    double cy() { return y + h / 2; }
    Rectangle2D box() { return new Rectangle2D.Double(x, y, w, h); }

    void move(Room r, double dt) {
        onGround = wallL = wallR = ceil = false;
        double dx = vx * dt, dy = vy * dt;
        if (!collides) {
            x += dx;
            y += dy;
            return;
        }
        int steps = (int) Math.ceil(Math.max(Math.abs(dx), Math.abs(dy)) / (T * 0.4));
        if (steps < 1) steps = 1;
        for (int i = 0; i < steps; i++) {
            moveX(r, dx / steps);
            moveY(r, dy / steps);
        }
    }

    private void moveX(Room r, double dx) {
        if (dx == 0) return;
        x += dx;
        int y0 = (int) Math.floor(y / T), y1 = (int) Math.floor((y + h - 0.01) / T);
        if (dx > 0) {
            int tx = (int) Math.floor((x + w - 0.01) / T);
            for (int ty = y0; ty <= y1; ty++)
                if (r.solid(tx, ty)) { x = tx * T - w; vx = 0; wallR = true; return; }
        } else {
            int tx = (int) Math.floor(x / T);
            for (int ty = y0; ty <= y1; ty++)
                if (r.solid(tx, ty)) { x = (tx + 1) * T; vx = 0; wallL = true; return; }
        }
    }

    private void moveY(Room r, double dy) {
        if (dy == 0) return;
        double prevBottom = y + h;
        y += dy;
        int x0 = (int) Math.floor(x / T), x1 = (int) Math.floor((x + w - 0.01) / T);
        if (dy > 0) {
            int ty = (int) Math.floor((y + h - 0.01) / T);
            for (int tx = x0; tx <= x1; tx++) {
                boolean plat = !dropThrough && r.platform(tx, ty) && prevBottom <= ty * T + 0.5;
                if (r.solid(tx, ty) || plat) { y = ty * T - h; vy = 0; onGround = true; return; }
            }
        } else {
            int ty = (int) Math.floor(y / T);
            for (int tx = x0; tx <= x1; tx++)
                if (r.solid(tx, ty)) { y = (ty + 1) * T; vy = 0; ceil = true; return; }
        }
    }

    /** Existe chao logo a frente (para inimigos nao cairem de bordas)? */
    boolean groundAhead(Room r, int dir) {
        double fx = dir > 0 ? x + w + 2 : x - 2;
        int tx = (int) Math.floor(fx / T), ty = (int) Math.floor((y + h + 2) / T);
        return r.solid(tx, ty) || r.platform(tx, ty);
    }

    boolean wallAhead(Room r, int dir) {
        double fx = dir > 0 ? x + w + 2 : x - 2;
        int tx = (int) Math.floor(fx / T);
        int y0 = (int) Math.floor(y / T), y1 = (int) Math.floor((y + h - 1) / T);
        for (int ty = y0; ty <= y1; ty++) if (r.solid(tx, ty)) return true;
        return false;
    }

    boolean overlaps(Body o) {
        return x < o.x + o.w && x + w > o.x && y < o.y + o.h && y + h > o.y;
    }

    boolean overlaps(Rectangle2D r) {
        return r.intersects(x, y, w, h);
    }
}
