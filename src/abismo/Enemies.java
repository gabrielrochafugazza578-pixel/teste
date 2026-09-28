package abismo;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.QuadCurve2D;
import java.awt.geom.Rectangle2D;
import java.util.HashSet;
import java.util.Set;

/** Base de todos os inimigos. */
abstract class Enemy extends Body {
    static final Color INFECTION = U.rgb(0xff9a3c);
    int hp, maxHp, geoDrop, facing = 1, lastSwing = -1;
    double flash, kbT, t = Math.random() * 10;
    boolean dead, contact = true, knockable = true;

    Enemy(double x, double y, double w, double h, int hp, int geo) {
        super(x, y, w, h);
        this.hp = this.maxHp = hp;
        this.geoDrop = geo;
    }

    abstract void update(Game gm, double dt);

    abstract void render(Graphics2D g, double cx, double cy);

    void hit(Game gm, int dmg, double dirX, double dirY) {
        hp -= dmg;
        flash = 0.14;
        if (knockable) {
            if (dirX != 0) vx = dirX * 300;
            if (dirY != 0) vy = dirY * 300;
            kbT = 0.16;
        }
        gm.hitFx(cx(), cy(), dirX, dirY, blood());
        if (hp <= 0 && !dead) {
            dead = true;
            gm.enemyDeath(this);
        }
    }

    Color blood() { return INFECTION; }

    boolean hittable() { return !dead; }

    boolean harmful() { return contact && !dead; }

    Color c(Color base) { return flash > 0 ? U.mix(base, Color.WHITE, 0.85) : base; }

    void addLights(Game gm) {}

    /** Luz alaranjada dos olhos infectados. */
    void eye(Graphics2D g, double x, double y, double r) {
        g.drawImage(Art.glow(INFECTION), (int) (x - r * 3), (int) (y - r * 3), (int) (r * 6), (int) (r * 6), null);
        g.setColor(U.rgb(0xffe0a0));
        g.fill(new Ellipse2D.Double(x - r / 2, y - r / 2, r, r));
    }
}

/** Rastejante: besouro de casco que patrulha o chao. */
final class Crawler extends Enemy {
    Crawler(double x, double y) { super(x, y, 34, 22, 26, 3); }

    @Override
    void update(Game gm, double dt) {
        t += dt;
        flash -= dt;
        if (kbT > 0) {
            kbT -= dt;
            vx *= 0.88;
        } else {
            if (wallAhead(gm.room, facing) || !groundAhead(gm.room, facing)) facing = -facing;
            vx = facing * 55;
        }
        vy = Math.min(vy + 2000 * dt, 800);
        move(gm.room, dt);
    }

    @Override
    void render(Graphics2D g, double camX, double camY) {
        double sx = cx() - camX, sy = y + h - camY;
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.scale(facing, 1);
        // pernas
        g.setColor(c(U.rgb(0x120c0a)));
        g.setStroke(new BasicStroke(2f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        for (int i = 0; i < 3; i++) {
            double lx = -9 + i * 8, ph = Math.sin(t * 14 + i * 2) * 3;
            g.draw(new Line2D.Double(lx, -5, lx + ph - 2, 0));
        }
        // casco
        Path2D shell = new Path2D.Double();
        shell.moveTo(-18, -4);
        shell.curveTo(-18, -22, 12, -26, 16, -8);
        shell.lineTo(14, -3);
        shell.closePath();
        g.setPaint(new GradientPaint(0, -24, c(U.rgb(0x7a5a44)), 0, -2, c(U.rgb(0x2a1c16))));
        g.fill(shell);
        g.setColor(c(U.rgb(0x100a08)));
        g.setStroke(new BasicStroke(1.4f));
        g.draw(shell);
        g.setColor(c(U.rgb(0x3a281f)));
        for (int i = 0; i < 3; i++) g.draw(new QuadCurve2D.Double(-12 + i * 8, -19 + i, -9 + i * 8, -12, -12 + i * 8, -4));
        g.setColor(c(U.alpha(U.rgb(0xd9b99a), 0.5)));
        g.draw(new QuadCurve2D.Double(-12, -17, -2, -24, 8, -18));
        // cabeca
        g.setColor(c(U.rgb(0x1b1210)));
        g.fill(new Ellipse2D.Double(10, -12, 12, 10));
        eye(g, 18, -8, 3.4);
        g.setTransform(old);
    }
}

/** Mosca vigia: voa e persegue o jogador. */
final class Flyer extends Enemy {
    final double homeX, homeY;

    Flyer(double x, double y) {
        super(x, y, 28, 24, 26, 3);
        homeX = x;
        homeY = y;
    }

    @Override
    void update(Game gm, double dt) {
        t += dt;
        flash -= dt;
        Body p = gm.player.b;
        double dx = p.cx() - cx(), dy = p.cy() - 20 - cy();
        double dist = Math.hypot(dx, dy);
        if (kbT > 0) {
            kbT -= dt;
            vx *= 0.9;
            vy *= 0.9;
        } else if (dist < 340 && !gm.player.dead) {
            vx += dx / dist * 420 * dt;
            vy += dy / dist * 420 * dt + Math.sin(t * 5) * 60 * dt;
            double sp = Math.hypot(vx, vy);
            if (sp > 150) { vx *= 150 / sp; vy *= 150 / sp; }
            facing = dx > 0 ? 1 : -1;
        } else {
            vx = U.approach(vx, (homeX - x) * 0.8, 200 * dt);
            vy = U.approach(vy, (homeY - y) * 0.8 + Math.sin(t * 2) * 25, 200 * dt);
            if (Math.abs(vx) > 5) facing = vx > 0 ? 1 : -1;
        }
        move(gm.room, dt);
    }

    @Override
    void render(Graphics2D g, double camX, double camY) {
        double sx = cx() - camX, sy = cy() - camY + Math.sin(t * 6) * 2;
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.scale(facing, 1);
        double flap = Math.abs(Math.sin(t * 32));
        g.setColor(U.alpha(U.rgb(0xcfe0ee), 0.35));
        g.fill(new Ellipse2D.Double(-14, -18 - flap * 6, 16, 8 + flap * 10));
        g.fill(new Ellipse2D.Double(-4, -20 - flap * 6, 16, 8 + flap * 10));
        g.setColor(U.alpha(Color.WHITE, 0.5));
        g.setStroke(new BasicStroke(1f));
        g.draw(new Ellipse2D.Double(-4, -20 - flap * 6, 16, 8 + flap * 10));
        // corpo
        Ellipse2D body = new Ellipse2D.Double(-13, -10, 26, 22);
        g.setPaint(new GradientPaint(0, -10, c(U.rgb(0x4a3a4a)), 0, 12, c(U.rgb(0x1a1219))));
        g.fill(body);
        g.setColor(c(U.alpha(INFECTION, 0.5)));
        g.fill(new Ellipse2D.Double(-8, 0, 14, 9));
        g.setColor(c(U.rgb(0x0e0a0e)));
        g.setStroke(new BasicStroke(1.3f));
        g.draw(body);
        Path2D sting = new Path2D.Double();
        sting.moveTo(-12, 4);
        sting.lineTo(-20, 9);
        sting.lineTo(-10, 8);
        g.fill(sting);
        eye(g, 7, -3, 4);
        g.setTransform(old);
    }
}

/** Cuspidor: bolsa inchada que cospe gosma infectada. */
final class Spitter extends Enemy {
    double timer = 1.5 + Math.random(), swell;

    Spitter(double x, double y) {
        super(x, y, 30, 28, 39, 5);
        knockable = false;
    }

    @Override
    void update(Game gm, double dt) {
        t += dt;
        flash -= dt;
        Body p = gm.player.b;
        double dx = p.cx() - cx(), dy = p.cy() - cy();
        facing = dx > 0 ? 1 : -1;
        if (Math.abs(dx) < 480 && Math.abs(dy) < 320 && !gm.player.dead) {
            timer -= dt;
            swell = timer < 0.55 ? 1 - timer / 0.55 : U.approach(swell, 0, dt * 3);
            if (timer <= 0) {
                timer = 2.3 + Math.random() * 0.6;
                double tt = U.clamp(Math.hypot(dx, dy) / 380, 0.55, 1.2);
                double g = 900;
                double pvx = dx / tt, pvy = dy / tt - 0.5 * g * tt;
                gm.projectiles.add(new Projectile(Projectile.GLOB, cx(), y + 4, pvx, pvy, 8, g));
                Sound.play("shoot");
                swell = 0;
            }
        } else swell = U.approach(swell, 0, dt * 3);
        vy = Math.min(vy + 2000 * dt, 800);
        vx = 0;
        move(gm.room, dt);
    }

    @Override
    void render(Graphics2D g, double camX, double camY) {
        double sx = cx() - camX, sy = y + h - camY;
        double pulse = Math.sin(t * 3) * 1.2 + swell * 5;
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        // tentaculos
        g.setColor(c(U.rgb(0x1f1418)));
        g.setStroke(new BasicStroke(2.4f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        for (int i = -2; i <= 2; i++) g.draw(new QuadCurve2D.Double(i * 5, -4, i * 8, -1 + Math.sin(t * 4 + i), i * 10, 0));
        Ellipse2D sack = new Ellipse2D.Double(-15 - pulse / 2, -30 - pulse, 30 + pulse, 28 + pulse);
        g.setPaint(new GradientPaint(0, (float) (-30 - pulse), c(U.rgb(0x6b4458)), 0, 0, c(U.rgb(0x241520))));
        g.fill(sack);
        g.setColor(c(U.alpha(INFECTION, 0.35 + swell * 0.4)));
        for (int i = 0; i < 4; i++) g.fill(new Ellipse2D.Double(-10 + i * 5.5, -22 + (i % 2) * 7, 4 + swell * 2, 4 + swell * 2));
        g.setColor(c(U.rgb(0x120a0f)));
        g.setStroke(new BasicStroke(1.4f));
        g.draw(sack);
        // boca
        double m = 2 + swell * 5;
        g.fill(new Ellipse2D.Double(-5 + facing * 3, -30 - pulse - m / 2, 10, m));
        if (swell > 0.3) {
            Art.setAlpha(g, swell);
            g.drawImage(Art.glow(INFECTION), (int) (-14 + facing * 3), (int) (-44 - pulse), 28, 28, null);
            Art.setAlpha(g, 1);
        }
        g.setTransform(old);
    }
}

/** Deposito de geo: quebra depois de alguns golpes, soltando geo. */
final class GeoRock extends Enemy {
    double shake;

    GeoRock(double x, double y) {
        super(x, y, 30, 30, 5, 0);
        contact = false;
        knockable = false;
    }

    @Override
    void update(Game gm, double dt) {
        flash -= dt;
        shake = Math.max(0, shake - dt);
        t += dt;
    }

    @Override
    void hit(Game gm, int dmg, double dirX, double dirY) {
        hp -= 1;
        flash = 0.1;
        shake = 0.18;
        Sound.play("break");
        gm.spawnGeo(cx(), y + 6, 3);
        for (int i = 0; i < 6; i++)
            gm.particles.add(new Particle(Particle.SHARD, cx(), cy(), U.rnd(-160, 160), U.rnd(-260, -60), 0.7, 4, gm.room.def.theme.rim).grav(1400));
        if (hp <= 0 && !dead) {
            dead = true;
            gm.spawnGeo(cx(), y, 6);
            for (int i = 0; i < 14; i++)
                gm.particles.add(new Particle(Particle.SHARD, cx(), cy(), U.rnd(-220, 220), U.rnd(-320, -80), 1.0, 5, U.scale(gm.room.def.theme.rock, 1.5)).grav(1400));
        }
    }

    @Override
    void render(Graphics2D g, double camX, double camY) {
        double sx = cx() - camX + (shake > 0 ? Math.sin(shake * 120) * 3 : 0), sy = y + h - camY;
        Theme th = Theme.CAVERNS;
        Path2D rock = new Path2D.Double();
        rock.moveTo(-17, 0);
        rock.lineTo(-14, -18);
        rock.lineTo(-4, -27);
        rock.lineTo(9, -24);
        rock.lineTo(17, -10);
        rock.lineTo(16, 0);
        rock.closePath();
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.setPaint(new GradientPaint(0, -27, c(U.rgb(0x57606e)), 0, 0, c(U.rgb(0x22262e))));
        g.fill(rock);
        g.setColor(c(th.rockDark));
        g.setStroke(new BasicStroke(1.5f));
        g.draw(rock);
        double[][] shards = {{-6, -15}, {4, -12}, {-1, -6}, {9, -18}};
        for (int i = 0; i < Math.min(shards.length, hp); i++) Geo.drawShard(g, shards[i][0], shards[i][1], 4, t + i);
        g.setTransform(old);
    }
}

/** Projeteis inimigos: gosma, onda de choque, escombros. */
final class Projectile {
    static final int GLOB = 0, WAVE = 1, ROCK = 2;
    final int type;
    double x, y, vx, vy, r, grav, delay, life = 6, t;
    boolean dead;

    Projectile(int type, double x, double y, double vx, double vy, double r, double grav) {
        this.type = type;
        this.x = x;
        this.y = y;
        this.vx = vx;
        this.vy = vy;
        this.r = r;
        this.grav = grav;
    }

    void update(Game gm, double dt) {
        t += dt;
        if (delay > 0) {
            delay -= dt;
            if (Math.random() < dt * 30)
                gm.particles.add(new Particle(Particle.DOT, x + U.rnd(-12, 12), y, 0, U.rnd(60, 160), 0.6, 1.6, gm.room.def.theme.rim).grav(600));
            return;
        }
        life -= dt;
        vy += grav * dt;
        x += vx * dt;
        y += vy * dt;
        Room room = gm.room;
        int tx = (int) Math.floor(x / U.T), ty = (int) Math.floor(y / U.T);
        if (type == WAVE) {
            int ahead = (int) Math.floor((x + Math.signum(vx) * r) / U.T);
            int below = (int) Math.floor((y + r + 4) / U.T);
            if (room.solid(ahead, ty) || !room.solid(ahead, below)) dead = true;
            if (Math.random() < dt * 40)
                gm.particles.add(new Particle(Particle.GLOW, x, y + r * 0.6, -vx * 0.1 + U.rnd(-30, 30), U.rnd(-120, -30), 0.5, 5, Enemy.INFECTION).grav(300));
        } else if (room.solid(tx, (int) Math.floor((y + r * 0.6) / U.T)) || ty >= room.h) {
            dead = true;
            Color col = type == GLOB ? Enemy.INFECTION : room.def.theme.rim;
            for (int i = 0; i < 8; i++)
                gm.particles.add(new Particle(type == GLOB ? Particle.DOT : Particle.SHARD, x, y, U.rnd(-150, 150), U.rnd(-220, -40), 0.6, 3, col).grav(1200));
            if (type == ROCK) Sound.play("break");
        }
        if (life <= 0) dead = true;
        Player p = gm.player;
        if (!dead && !p.dead && p.b.overlaps(new Rectangle2D.Double(x - r, y - r, r * 2, r * 2))) {
            if (p.hurt(gm, 1, x) && type != WAVE) dead = true;
        }
    }

    void render(Graphics2D g, double camX, double camY) {
        double sx = x - camX, sy = y - camY;
        if (delay > 0) return;
        switch (type) {
            case GLOB: {
                g.drawImage(Art.glow(Enemy.INFECTION), (int) (sx - r * 3), (int) (sy - r * 3), (int) (r * 6), (int) (r * 6), null);
                g.setColor(U.rgb(0xffb266));
                g.fill(new Ellipse2D.Double(sx - r * 0.7, sy - r * 0.7, r * 1.4, r * 1.4));
                g.setColor(U.rgb(0xfff0c8));
                g.fill(new Ellipse2D.Double(sx - r * 0.3, sy - r * 0.4, r * 0.5, r * 0.5));
                break;
            }
            case WAVE: {
                double hgt = r * 2.4;
                Path2D p = new Path2D.Double();
                double dir = Math.signum(vx);
                p.moveTo(sx - dir * r * 1.5, sy + r);
                p.quadTo(sx - dir * r * 0.3, sy + r - hgt * (0.8 + 0.2 * Math.sin(t * 40)), sx + dir * r, sy + r);
                p.closePath();
                g.drawImage(Art.glow(Enemy.INFECTION), (int) (sx - r * 3), (int) (sy - r * 2.5), (int) (r * 6), (int) (r * 5), null);
                g.setPaint(new GradientPaint((float) sx, (float) (sy - hgt), U.rgb(0xfff0d0), (float) sx, (float) (sy + r), U.alpha(Enemy.INFECTION, 0.4)));
                g.fill(p);
                break;
            }
            default: {
                AffineTransform old = g.getTransform();
                g.translate(sx, sy);
                g.rotate(t * 5);
                Path2D rock = new Path2D.Double();
                rock.moveTo(-r, -r * 0.3);
                rock.lineTo(-r * 0.3, -r);
                rock.lineTo(r * 0.8, -r * 0.6);
                rock.lineTo(r, r * 0.5);
                rock.lineTo(0, r);
                rock.lineTo(-r * 0.8, r * 0.6);
                rock.closePath();
                g.setColor(U.rgb(0x5a3a2c));
                g.fill(rock);
                g.setColor(U.rgb(0x1a0e0a));
                g.setStroke(new BasicStroke(1.5f));
                g.draw(rock);
                g.setTransform(old);
            }
        }
    }
}

/** Feitico do jogador: espirito vingativo. */
final class SpellShot {
    double x, y, t;
    final int dir;
    boolean dead;
    final Set<Object> hitSet = new HashSet<>();

    SpellShot(double x, double y, int dir) {
        this.x = x;
        this.y = y;
        this.dir = dir;
    }

    void update(Game gm, double dt) {
        t += dt;
        x += dir * 900 * dt;
        if (gm.room.solid((int) Math.floor((x + dir * 16) / U.T), (int) Math.floor(y / U.T)) || t > 1.2) {
            dead = true;
            gm.burst(x, y, U.rgb(0xdff0ff), 16, 260);
        }
        Rectangle2D box = new Rectangle2D.Double(x - 28, y - 18, 56, 36);
        for (Enemy e : gm.enemies)
            if (e.hittable() && !hitSet.contains(e) && e.overlaps(box)) {
                hitSet.add(e);
                e.hit(gm, 30, dir, 0);
                gm.hitStop(0.04);
            }
        for (int i = 0; i < 3; i++)
            gm.particles.add(new Particle(Particle.GLOW, x - dir * U.rnd(0, 30), y + U.rnd(-12, 12), -dir * U.rnd(40, 160), U.rnd(-40, 40), 0.45, 5, U.rgb(0xbfe4ff)));
    }

    void render(Graphics2D g, double camX, double camY) {
        double sx = x - camX, sy = y - camY;
        g.drawImage(Art.glow(U.rgb(0xcfe8ff)), (int) (sx - 60), (int) (sy - 40), 120, 80, null);
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.scale(dir, 1);
        Path2D p = new Path2D.Double();
        p.moveTo(22, 0);
        p.curveTo(14, -16, -10, -18, -40, -6 + Math.sin(t * 40) * 3);
        p.curveTo(-20, -2, -20, 2, -40, 6 - Math.sin(t * 40) * 3);
        p.curveTo(-10, 18, 14, 16, 22, 0);
        g.setPaint(new GradientPaint(22, 0, Color.WHITE, -40, 0, U.alpha(U.rgb(0x9fd0ff), 0.1)));
        g.fill(p);
        Player.drawHead(g, 6, 0, 0.6);
        g.setTransform(old);
    }
}

/** Moeda do mundo: fragmento de geo que salta e e coletado. */
final class Geo extends Body {
    double t, age;
    boolean taken;

    Geo(double x, double y) {
        super(x - 5, y - 5, 10, 10);
        vx = U.rnd(-170, 170);
        vy = U.rnd(-420, -200);
        t = Math.random() * 10;
    }

    void update(Game gm, double dt) {
        t += dt;
        age += dt;
        Body p = gm.player.b;
        double dx = p.cx() - cx(), dy = p.cy() - cy();
        double d = Math.hypot(dx, dy);
        if (age > 0.35 && d < 70 && !gm.player.dead) {
            collides = false;
            vx = dx / d * 520;
            vy = dy / d * 520;
        } else {
            collides = true;
            double pvy = vy;
            vy = Math.min(vy + 1800 * dt, 900);
            move(gm.room, dt);
            if (onGround) {
                if (pvy > 160) vy = -pvy * 0.42;
                vx *= Math.pow(0.02, dt);
            }
            return;
        }
        move(gm.room, dt);
        if (d < 16) taken = true;
    }

    void render(Graphics2D g, double camX, double camY) {
        AffineTransform old = g.getTransform();
        g.translate(cx() - camX, cy() - camY);
        drawShard(g, 0, 0, 5, t);
        g.setTransform(old);
    }

    static void drawShard(Graphics2D g, double x, double y, double s, double t) {
        double sq = 0.6 + 0.4 * Math.abs(Math.cos(t * 3));
        Path2D p = new Path2D.Double();
        p.moveTo(x, y - s);
        p.lineTo(x + s * sq, y - s * 0.3);
        p.lineTo(x + s * 0.6 * sq, y + s);
        p.lineTo(x - s * 0.6 * sq, y + s);
        p.lineTo(x - s * sq, y - s * 0.3);
        p.closePath();
        g.drawImage(Art.glow(U.rgb(0xbfe0e8)), (int) (x - s * 2.5), (int) (y - s * 2.5), (int) (s * 5), (int) (s * 5), null);
        g.setPaint(new GradientPaint((float) x, (float) (y - s), U.rgb(0xf4fbff), (float) x, (float) (y + s), U.rgb(0x8aa6b4)));
        g.fill(p);
        g.setColor(U.rgb(0x2a3440));
        g.setStroke(new BasicStroke(1f));
        g.draw(p);
    }
}
