package abismo;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;
import java.awt.geom.Rectangle2D;
import java.awt.geom.RoundRectangle2D;

/** O Guardiao Oco: cavaleiro de carapaca com uma clava enorme. */
final class Boss extends Enemy {
    enum S { DORMANT, INTRO, IDLE, JUMP_WIND, JUMP, CHARGE_WIND, CHARGE, STUN, SWING_WIND, SWING, RECOVER, DYING }

    static final String NAME = "GUARDIÃO OCO";
    S s = S.DORMANT;
    double st, mace = 0.7, shakeT;
    boolean phase2, impactDone;
    int lastChoice = -1;

    Boss(double x, double y) {
        super(x, y, 64, 88, 420, 0);
        knockable = false;
        facing = -1;
    }

    private void go(S ns) {
        s = ns;
        st = 0;
        impactDone = false;
    }

    @Override
    boolean hittable() { return !dead && s != S.DORMANT && s != S.DYING; }

    @Override
    boolean harmful() { return !dead && s != S.DORMANT && s != S.DYING && s != S.INTRO; }

    boolean awake() { return s != S.DORMANT && !dead; }

    @Override
    void update(Game gm, double dt) {
        t += dt;
        st += dt;
        flash -= dt;
        shakeT = Math.max(0, shakeT - dt);
        Player p = gm.player;
        double dx = p.b.cx() - cx();
        double spd = phase2 ? 1.25 : 1.0;
        double targetMace = 0.7;

        switch (s) {
            case DORMANT:
                if (p.b.cx() > 9 * U.T && !p.dead) {
                    gm.bossWake(this);
                    go(S.INTRO);
                    Sound.play("roar");
                }
                break;
            case INTRO:
                targetMace = -1.6 + Math.sin(st * 20) * 0.1;
                if (st > 0.3 && st < 1.3) gm.shake(4);
                if (st > 1.7) go(S.IDLE);
                break;
            case IDLE:
                vx = 0;
                facing = dx > 0 ? 1 : -1;
                if (st > (phase2 ? 0.3 : 0.55)) {
                    double dist = Math.abs(dx), r = Math.random();
                    int choice;
                    if (dist < 170 && r < 0.65) choice = 2;
                    else if (dist > 280 && r < 0.55) choice = 1;
                    else choice = 0;
                    if (choice == lastChoice && Math.random() < 0.5) choice = (choice + 1) % 3;
                    lastChoice = choice;
                    go(choice == 0 ? S.JUMP_WIND : choice == 1 ? S.CHARGE_WIND : S.SWING_WIND);
                }
                break;
            case JUMP_WIND:
                vx = 0;
                targetMace = -0.6;
                if (st > 0.45 / spd) {
                    double air = 0.85;
                    vx = U.clamp((p.b.cx() - cx()) / air, -560, 560);
                    vy = -880;
                    facing = vx >= 0 ? 1 : -1;
                    go(S.JUMP);
                }
                break;
            case JUMP:
                targetMace = -1.8;
                if (onGround && st > 0.1) {
                    vx = 0;
                    slam(gm, true);
                    go(S.RECOVER);
                }
                break;
            case CHARGE_WIND:
                vx = -facing * 30;
                targetMace = 2.4;
                if (st > 0.6 / spd) go(S.CHARGE);
                break;
            case CHARGE:
                targetMace = 2.2;
                vx = facing * 540 * spd;
                if (Math.random() < dt * 30) gm.dust(cx() - facing * 20, y + h, 2);
                if (wallAhead(gm.room, facing) || wallL || wallR) {
                    vx = 0;
                    gm.shake(12);
                    Sound.play("slam");
                    for (int i = 0; i < (phase2 ? 6 : 4); i++) debris(gm, U.rnd(7 * U.T, 40 * U.T), 0.4 + i * 0.12);
                    go(S.STUN);
                }
                break;
            case STUN:
                vx = 0;
                targetMace = 1.3;
                if (st > 0.95 / spd) go(S.IDLE);
                break;
            case SWING_WIND:
                vx = 0;
                targetMace = -2.3;
                if (st > 0.5 / spd) go(S.SWING);
                break;
            case SWING:
                targetMace = 0.85;
                if (st > 0.1 && !impactDone) {
                    impactDone = true;
                    double hx = cx() + facing * 80;
                    gm.shake(10);
                    Sound.play("slam");
                    gm.burst(hx, y + h - 6, U.rgb(0xffcf99), 18, 320);
                    gm.projectiles.add(new Projectile(Projectile.WAVE, hx, y + h - 14, facing * (phase2 ? 470 : 390), 0, 14, 0));
                    if (phase2) debris(gm, p.b.cx(), 0.3);
                }
                if (st < 0.2) {
                    Rectangle2D hb = facing > 0 ? new Rectangle2D.Double(cx() + 10, y + 10, 100, 80) : new Rectangle2D.Double(cx() - 110, y + 10, 100, 80);
                    if (!p.dead && p.b.overlaps(hb)) p.hurt(gm, 1, cx());
                }
                if (st > 0.3) go(S.RECOVER);
                break;
            case RECOVER:
                vx = 0;
                targetMace = 1.2;
                if (st > (phase2 ? 0.45 : 0.8)) go(S.IDLE);
                break;
            case DYING:
                vx = 0;
                targetMace = 1.6 + Math.sin(st * 30) * 0.2;
                gm.shake(3);
                if (Math.random() < dt * 25) gm.burst(cx() + U.rnd(-30, 30), cy() + U.rnd(-40, 30), INFECTION, 6, 220);
                if (st > 2.8) {
                    dead = true;
                    gm.bossDefeated(this);
                }
                break;
            default:
                break;
        }
        mace = U.approach(mace, targetMace, dt * (s == S.SWING ? 22 : 6));
        vy = Math.min(vy + 2000 * dt, 1000);
        move(gm.room, dt);
    }

    private void slam(Game gm, boolean both) {
        gm.shake(14);
        Sound.play("slam");
        gm.dust(cx(), y + h, 16);
        double sp = phase2 ? 460 : 380;
        gm.projectiles.add(new Projectile(Projectile.WAVE, cx() + 34, y + h - 14, sp, 0, 14, 0));
        if (both) gm.projectiles.add(new Projectile(Projectile.WAVE, cx() - 34, y + h - 14, -sp, 0, 14, 0));
        if (phase2) for (int i = 0; i < 2; i++) debris(gm, gm.player.b.cx() + U.rnd(-120, 120), 0.35 + i * 0.2);
    }

    private void debris(Game gm, double x, double delay) {
        int tx = (int) (x / U.T);
        int top = gm.room.ceilingAbove(tx, gm.room.h - 5);
        Projectile r = new Projectile(Projectile.ROCK, x, top * U.T + 10, 0, 0, 11, 1300);
        r.delay = delay;
        gm.projectiles.add(r);
    }

    @Override
    void hit(Game gm, int dmg, double dirX, double dirY) {
        if (!hittable()) return;
        hp -= dmg;
        flash = 0.12;
        shakeT = 0.12;
        gm.hitFx(cx() - dirX * 20, cy() - 10, dirX, dirY, INFECTION);
        if (!phase2 && hp < maxHp / 2) {
            phase2 = true;
            Sound.play("roar");
            gm.shake(8);
        }
        if (hp <= 0) {
            hp = 0;
            go(S.DYING);
            Sound.play("roar");
            gm.hitStop(0.35);
            gm.flash(0.6);
        }
    }

    @Override
    void render(Graphics2D g, double camX, double camY) {
        double sx = cx() - camX + (shakeT > 0 ? Math.sin(t * 90) * 3 : 0) + (s == S.DYING ? Math.sin(t * 70) * 3 : 0);
        double sy = y + h - camY;
        double breathe = Math.sin(t * 2.2) * 1.5;
        double crouch = (s == S.JUMP_WIND || s == S.CHARGE_WIND) ? 8 : (s == S.STUN ? 5 : 0);
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.scale(facing, 1);
        if (s == S.DORMANT) g.translate(0, 6);

        // pernas
        g.setColor(c(U.rgb(0x140d0b)));
        g.fill(new RoundRectangle2D.Double(-24, -22, 16, 22, 8, 8));
        g.fill(new RoundRectangle2D.Double(6, -22, 16, 22, 8, 8));
        g.translate(0, crouch - breathe);

        // braco de tras
        drawMace(g, -mace * 0.4 - 0.4, -58, 0.8, true);

        // corpo / carapaca
        Path2D body = new Path2D.Double();
        body.moveTo(-36, -18);
        body.curveTo(-46, -60, -20, -92, 8, -88);
        body.curveTo(36, -84, 42, -50, 34, -18);
        body.curveTo(18, -8, -20, -8, -36, -18);
        body.closePath();
        g.setPaint(new GradientPaint(0, -90, c(U.rgb(0x5a4236)), 0, -10, c(U.rgb(0x150d0b))));
        g.fill(body);
        g.setColor(c(U.rgb(0x0b0706)));
        g.setStroke(new BasicStroke(2f));
        g.draw(body);
        // placas
        g.setColor(c(U.rgb(0x2a1d18)));
        g.setStroke(new BasicStroke(2.2f));
        for (int i = 0; i < 3; i++) {
            Path2D pl = new Path2D.Double();
            pl.moveTo(-34 + i * 4, -30 - i * 18);
            pl.quadTo(0, -40 - i * 20, 32 - i * 4, -30 - i * 18);
            g.draw(pl);
        }
        // barriga infectada pulsante
        double pulse = 0.5 + 0.5 * Math.sin(t * (phase2 ? 7 : 4));
        Art.setAlpha(g, 0.5 + 0.4 * pulse);
        g.drawImage(Art.glow(INFECTION), -30, -56, 50, 44, null);
        Art.setAlpha(g, 1);
        g.setColor(c(U.alpha(U.rgb(0xffb070), 0.35 + 0.35 * pulse)));
        g.fill(new Ellipse2D.Double(-16, -40, 18, 14));
        g.fill(new Ellipse2D.Double(-2, -32, 10, 8));

        // cabeca / mascara
        double hx = 14, hy = -86;
        Path2D horns = new Path2D.Double();
        horns.moveTo(hx - 8, hy - 8);
        horns.curveTo(hx - 16, hy - 26, hx - 4, hy - 44, hx + 18, hy - 46);
        horns.curveTo(hx + 4, hy - 38, hx - 2, hy - 24, hx + 2, hy - 10);
        horns.closePath();
        horns.moveTo(hx + 12, hy - 8);
        horns.curveTo(hx + 16, hy - 22, hx + 30, hy - 34, hx + 42, hy - 30);
        horns.curveTo(hx + 30, hy - 26, hx + 22, hy - 16, hx + 18, hy - 6);
        horns.closePath();
        Ellipse2D head = new Ellipse2D.Double(hx - 16, hy - 16, 36, 32);
        g.setPaint(new GradientPaint(0, (float) (hy - 40), c(U.rgb(0xeae3d6)), 0, (float) (hy + 16), c(U.rgb(0xa39a8a))));
        g.fill(horns);
        g.fill(head);
        g.setColor(c(U.rgb(0x0b0706)));
        g.setStroke(new BasicStroke(1.8f));
        g.draw(horns);
        g.draw(head);
        g.fill(new Ellipse2D.Double(hx - 6, hy - 6, 9, 12));
        g.fill(new Ellipse2D.Double(hx + 7, hy - 6, 9, 12));
        if (s != S.DORMANT) {
            eye(g, hx - 1.5, hy, 3.5);
            eye(g, hx + 11.5, hy, 3.5);
        }

        // braco da frente com a clava
        drawMace(g, mace, -58, 1.0, false);
        g.setTransform(old);
    }

    private void drawMace(Graphics2D g, double ang, double shoulderY, double scale, boolean back) {
        AffineTransform old = g.getTransform();
        g.translate(back ? -6 : 18, shoulderY);
        g.rotate(ang);
        g.scale(scale, scale);
        Color dark = back ? U.rgb(0x0d0807) : U.rgb(0x1c1311);
        g.setColor(c(dark));
        g.fill(new RoundRectangle2D.Double(-5, -5, 30, 10, 8, 8)); // braco
        if (!back) {
            g.setColor(c(U.rgb(0x3a2a22)));
            g.fill(new RoundRectangle2D.Double(24, -3, 46, 6, 4, 4)); // cabo
            g.setPaint(new GradientPaint(70, -20, c(U.rgb(0x7a6a5c)), 90, 20, c(U.rgb(0x221816))));
            Ellipse2D ball = new Ellipse2D.Double(64, -18, 36, 36);
            g.fill(ball);
            g.setColor(c(U.rgb(0x0b0706)));
            g.setStroke(new BasicStroke(2f));
            g.draw(ball);
            for (int i = 0; i < 8; i++) {
                double a = i * Math.PI / 4;
                double bx = 82 + Math.cos(a) * 17, by = Math.sin(a) * 17;
                Path2D sp = new Path2D.Double();
                sp.moveTo(bx + Math.cos(a + 1.3) * 5, by + Math.sin(a + 1.3) * 5);
                sp.lineTo(82 + Math.cos(a) * 27, Math.sin(a) * 27);
                sp.lineTo(bx + Math.cos(a - 1.3) * 5, by + Math.sin(a - 1.3) * 5);
                sp.closePath();
                g.setColor(c(U.rgb(0xb8ab98)));
                g.fill(sp);
            }
        }
        g.setTransform(old);
    }
}
