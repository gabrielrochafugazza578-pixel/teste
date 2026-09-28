package abismo;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.geom.Arc2D;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.Rectangle2D;

/** O Andarilho: o pequeno cavaleiro mascarado controlado pelo jogador. */
final class Player {
    static final double RUN = 250, JUMP = 680, DJUMP = 600, G = 2100, MAXFALL = 820, DASH = 760, DASH_T = 0.2;
    static final int SOUL_MAX = 99, SPELL_COST = 33;

    final Body b = new Body(0, 0, 18, 40);
    int facing = 1;
    int hp = 5, maxHp = 5, soul = 0, geo = 0;
    boolean hasDash, hasWings;
    boolean dead, sitting, focusing;

    double invuln, knockT, dashT, dashCd, attackT, attackCd, spellCd, coyote, jumpBuf, dropT, recoilT, recoilV, forceT;
    int forceDir, airJumps, attackDir, swingId;
    boolean canDash = true, jumping, altSlash;
    double focusT, animT, squash, ghostT, runDust;
    double safeX, safeY;

    void place(double feetCx, double feetY) {
        b.x = feetCx - b.w / 2;
        b.y = feetY - b.h;
        b.vx = b.vy = 0;
        safeX = b.x;
        safeY = b.y;
    }

    void update(Game gm, double dt) {
        Input in = gm.in;
        Room room = gm.room;
        boolean locked = gm.locked();
        animT += dt;
        invuln = Math.max(0, invuln - dt);
        squash = U.approach(squash, 0, dt * 4);

        if (sitting) {
            b.vx = 0;
            if (!locked && (in.left() || in.right() || in.jump() || in.downPressed())) sitting = false;
            else {
                b.vy = Math.min(b.vy + G * dt, MAXFALL);
                b.move(room, dt);
                return;
            }
        }

        int dir = locked ? 0 : (in.right() ? 1 : 0) - (in.left() ? 1 : 0);
        if (forceT > 0) { forceT -= dt; dir = forceDir; }
        boolean wasGround = b.onGround;
        double prevVy = b.vy;

        // --- foco (cura)
        boolean wantFocus = !locked && in.focusHeld() && b.onGround && soul >= SPELL_COST && hp < maxHp && dashT <= 0 && knockT <= 0;
        if (wantFocus) {
            if (!focusing) focusT = 0;
            focusing = true;
            focusT += dt;
            dir = 0;
            if (Math.random() < dt * 40) {
                double a = Math.random() * Math.PI * 2, r = 40 + Math.random() * 30;
                Particle p = new Particle(Particle.GLOW, b.cx() + Math.cos(a) * r, b.cy() + Math.sin(a) * r,
                        -Math.cos(a) * r * 2.5, -Math.sin(a) * r * 2.5, 0.4, 4, U.rgb(0xeaf6ff));
                gm.particles.add(p);
            }
            if (focusT >= 0.95) {
                hp++;
                soul -= SPELL_COST;
                focusT = 0;
                gm.onHeal();
            }
        } else {
            focusing = false;
            focusT = 0;
        }

        // --- movimento horizontal
        if (knockT > 0) {
            knockT -= dt;
        } else if (dashT <= 0) {
            double target = dir * RUN;
            if (recoilT > 0) { recoilT -= dt; target = recoilV; }
            b.vx = U.approach(b.vx, target, (b.onGround ? 5200 : 3400) * dt);
            if (dir != 0 && attackT <= 0) facing = dir;
        }
        if (dashT <= 0) b.vy = Math.min(b.vy + G * dt, MAXFALL);

        // --- pulo
        if (b.onGround) { coyote = 0.1; airJumps = hasWings ? 1 : 0; canDash = true; } else coyote -= dt;
        if (!locked && in.jump()) jumpBuf = 0.13; else jumpBuf -= dt;
        if (jumpBuf > 0 && !focusing && knockT <= 0) {
            if (b.onGround && in.downKey() && onPlatform(room)) {
                b.dropThrough = true;
                dropT = 0.22;
                jumpBuf = 0;
            } else if (coyote > 0) {
                b.vy = -JUMP;
                coyote = 0;
                jumpBuf = 0;
                jumping = true;
                squash = -0.25;
                Sound.play("jump");
                gm.dust(b.cx(), b.y + b.h, 5);
            } else if (airJumps > 0 && dashT <= 0) {
                b.vy = -DJUMP;
                airJumps--;
                jumpBuf = 0;
                jumping = true;
                squash = -0.2;
                Sound.play("wings");
                gm.wingBurst(this);
            }
        }
        if (jumping && b.vy < 0 && !in.jumpHeld()) { b.vy *= 0.45; jumping = false; }
        if (b.vy >= 0) jumping = false;
        if (dropT > 0) { dropT -= dt; if (dropT <= 0) b.dropThrough = false; }

        // --- dash
        dashCd -= dt;
        if (!locked && in.dash() && hasDash && canDash && dashCd <= 0 && !focusing && knockT <= 0) {
            if (dir != 0) facing = dir;
            dashT = DASH_T;
            dashCd = 0.5;
            if (!b.onGround) canDash = false;
            attackT = 0;
            Sound.play("dash");
            gm.dashBurst(this);
        }
        if (dashT > 0) {
            dashT -= dt;
            b.vx = facing * DASH;
            b.vy = 0;
            ghostT -= dt;
            if (ghostT <= 0) {
                ghostT = 0.028;
                Particle p = new Particle(Particle.GHOST, b.cx(), b.y + b.h, 0, 0, 0.3, 1, U.rgb(0x1a1f2c));
                p.facing = facing;
                gm.particles.add(p);
            }
            if (dashT <= 0) b.vx = facing * RUN;
        }

        // --- ataque com o ferrao
        attackCd -= dt;
        if (!locked && in.attack() && attackCd <= 0 && !focusing && dashT <= 0) {
            attackDir = in.up() ? 1 : (in.downKey() && !b.onGround) ? 2 : 0;
            attackT = 0.2;
            attackCd = 0.34;
            swingId++;
            altSlash = !altSlash;
            Sound.play("slash");
        }
        if (attackT > 0) {
            if (attackT > 0.09) gm.playerAttack(this, attackBox(), attackDir, swingId);
            attackT -= dt;
        }

        // --- feitico
        spellCd -= dt;
        if (!locked && in.spell() && soul >= SPELL_COST && spellCd <= 0 && !focusing && dashT <= 0 && knockT <= 0) {
            soul -= SPELL_COST;
            spellCd = 0.45;
            recoilT = 0.14;
            recoilV = -facing * 240;
            gm.castSpell(this);
        }

        b.move(room, dt);

        // --- aterrissagem, poeira de corrida
        if (b.onGround && !wasGround && prevVy > 300) {
            squash = U.clamp(prevVy / 1600, 0.12, 0.4);
            Sound.play("land");
            gm.dust(b.cx(), b.y + b.h, 7);
        }
        if (b.onGround && Math.abs(b.vx) > 100) {
            runDust -= dt;
            if (runDust <= 0) { runDust = 0.12; gm.dust(b.cx() - facing * 6, b.y + b.h, 1); }
        }

        // --- espinhos e posicao segura
        if (room.touchesSpikes(b.x + 3, b.y, b.w - 6, b.h)) gm.playerHazard();
        else if (b.onGround && safeGround(room)) { safeX = b.x; safeY = b.y; }
    }

    Rectangle2D attackBox() {
        double cx = b.cx(), cy = b.cy();
        switch (attackDir) {
            case 1: return new Rectangle2D.Double(cx - 24, b.y - 58, 48, 66);
            case 2: return new Rectangle2D.Double(cx - 24, b.y + b.h - 10, 48, 62);
            default: return facing > 0 ? new Rectangle2D.Double(cx + 2, cy - 24, 64, 40) : new Rectangle2D.Double(cx - 66, cy - 24, 64, 40);
        }
    }

    void pogo() {
        b.vy = -580;
        jumping = false;
        airJumps = hasWings ? 1 : 0;
        canDash = true;
    }

    boolean hurt(Game gm, int dmg, double fromX) {
        if (invuln > 0 || dead) return false;
        hp -= dmg;
        invuln = 1.3;
        knockT = 0.2;
        b.vx = (b.cx() < fromX ? -1 : 1) * 320;
        b.vy = -430;
        dashT = 0;
        attackT = 0;
        focusing = false;
        focusT = 0;
        sitting = false;
        gm.onPlayerHurt();
        return true;
    }

    private boolean onPlatform(Room r) {
        int ty = (int) Math.floor((b.y + b.h + 1) / U.T);
        int x0 = (int) Math.floor(b.x / U.T), x1 = (int) Math.floor((b.x + b.w - 0.01) / U.T);
        boolean any = false;
        for (int tx = x0; tx <= x1; tx++) {
            if (r.solid(tx, ty)) return false;
            if (r.platform(tx, ty)) any = true;
        }
        return any;
    }

    private boolean safeGround(Room r) {
        int ty = (int) Math.floor((b.y + b.h + 1) / U.T);
        int x0 = (int) Math.floor((b.x - U.T) / U.T), x1 = (int) Math.floor((b.x + b.w + U.T) / U.T);
        for (int tx = x0; tx <= x1; tx++) {
            if (r.spike(tx, ty) || r.spike(tx, ty - 1) || r.spike(tx, ty + 1)) return false;
            if (!r.solid(tx, ty)) return false;
        }
        return true;
    }

    // ------------------------------------------------------------------ desenho

    private static final Color CLOAK_TOP = U.rgb(0x333c4f), CLOAK_BOT = U.rgb(0x181c26), OUTLINE = U.rgb(0x0b0d12);
    private static final Color MASK = U.rgb(0xf1eee6), MASK_SHADE = U.rgb(0xbdb7ab), SCARF = U.rgb(0x86c2e0);

    void render(Graphics2D g, double camX, double camY) {
        if (dead) return;
        boolean blink = invuln > 0 && ((int) (invuln * 18)) % 2 == 0;
        double cx = b.cx() - camX, fy = b.y + b.h - camY;
        if (blink) Art.setAlpha(g, 0.35);

        AffineTransform old = g.getTransform();
        g.translate(cx, fy);
        double sy = 1 - squash, sx = 1 + squash * 0.6;
        g.scale(facing * sx, sy);

        boolean air = !b.onGround;
        double speed = Math.abs(b.vx) / RUN;
        double run = b.onGround && speed > 0.1 ? Math.sin(animT * 15) : 0;
        double bob = b.onGround ? Math.abs(run) * 1.5 : 0;
        if (sitting) { g.translate(0, 8); }
        g.translate(0, -bob);

        // pernas
        g.setColor(OUTLINE);
        g.setStroke(new BasicStroke(3.2f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        if (sitting) {
            g.draw(new Line2D.Double(-3, -9, 5, -6));
            g.draw(new Line2D.Double(3, -9, 9, -5));
        } else if (air) {
            double k = b.vy < 0 ? 1 : 0.5;
            g.draw(new Line2D.Double(-3, -10, -5, -3 + k));
            g.draw(new Line2D.Double(3, -10, 5, -4 + k * 2));
        } else {
            g.draw(new Line2D.Double(-3, -10, -3 + run * 5, 0 + bob - Math.max(0, run) * 3));
            g.draw(new Line2D.Double(3, -10, 3 - run * 5, 0 + bob - Math.max(0, -run) * 3));
        }

        // capa
        double sway = -U.clamp(Math.abs(b.vx) / RUN, 0, 1.4) * 5 + Math.sin(animT * 2.6) * 0.8;
        double lift = air ? U.clamp(b.vy / 600, -1, 1) * -3 : 0;
        if (dashT > 0) sway = -10;
        Path2D cloak = new Path2D.Double();
        cloak.moveTo(-6, -27);
        cloak.curveTo(-9, -20, -11 + sway * 0.5, -12, -12 + sway, -5 + lift);
        cloak.lineTo(-7 + sway * 0.8, -8 + lift);
        cloak.lineTo(-3 + sway * 0.6, -4 + lift);
        cloak.lineTo(1 + sway * 0.4, -8 + lift);
        cloak.lineTo(5 + sway * 0.3, -4 + lift);
        cloak.lineTo(10 + sway * 0.2, -7 + lift);
        cloak.curveTo(10, -13, 8, -21, 6, -27);
        cloak.closePath();
        g.setPaint(new GradientPaint(0, -27, CLOAK_TOP, 0, -4, CLOAK_BOT));
        g.fill(cloak);
        g.setColor(OUTLINE);
        g.setStroke(new BasicStroke(1.3f));
        g.draw(cloak);

        // cachecol
        double wave = Math.sin(animT * 9) * 2;
        double trail = 10 + U.clamp(Math.abs(b.vx) / RUN, 0, 3) * 7;
        Path2D scarf = new Path2D.Double();
        scarf.moveTo(-3, -27);
        scarf.quadTo(-trail * 0.5, -29 + wave, -trail, -26 - wave + (air ? -3 : 2));
        scarf.lineTo(-trail + 2, -23 - wave + (air ? -3 : 2));
        scarf.quadTo(-trail * 0.5, -25 + wave, -3, -23);
        scarf.closePath();
        g.setColor(SCARF);
        g.fill(scarf);
        g.setColor(U.alpha(OUTLINE, 0.8));
        g.draw(scarf);

        drawHead(g, 0, -35, focusing ? focusT : 0);

        // ferrao nas costas quando parado
        if (attackT <= 0) {
            g.setColor(U.rgb(0x9aa3b3));
            g.setStroke(new BasicStroke(1.6f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
            g.draw(new Line2D.Double(-6, -22, -13, -9));
        }
        g.setTransform(old);
        if (blink) Art.setAlpha(g, 1);

        if (attackT > 0) drawSlash(g, camX, camY);
    }

    static void drawHead(Graphics2D g, double hx, double hy, double glow) {
        Path2D horns = new Path2D.Double();
        horns.moveTo(hx - 7, hy - 5);
        horns.curveTo(hx - 10, hy - 11, hx - 11, hy - 17, hx - 8, hy - 22);
        horns.curveTo(hx - 7, hy - 16, hx - 5, hy - 11, hx - 2, hy - 7);
        horns.closePath();
        horns.moveTo(hx + 7, hy - 5);
        horns.curveTo(hx + 10, hy - 11, hx + 11, hy - 17, hx + 8, hy - 22);
        horns.curveTo(hx + 7, hy - 16, hx + 5, hy - 11, hx + 2, hy - 7);
        horns.closePath();
        Ellipse2D head = new Ellipse2D.Double(hx - 10, hy - 9, 20, 18);
        g.setPaint(new GradientPaint(0, (float) (hy - 20), MASK, 0, (float) (hy + 9), MASK_SHADE));
        g.fill(horns);
        g.fill(head);
        g.setColor(OUTLINE);
        g.setStroke(new BasicStroke(1.4f));
        g.draw(horns);
        g.draw(head);
        g.setColor(OUTLINE);
        g.fill(new Ellipse2D.Double(hx - 5.5 + 1.5, hy - 4, 4.6, 7.5));
        g.fill(new Ellipse2D.Double(hx + 1.5 + 1.5, hy - 4, 4.6, 7.5));
        if (glow > 0) {
            g.setColor(U.alpha(Color.WHITE, Math.min(0.6, glow * 0.6)));
            g.fill(new Ellipse2D.Double(hx - 14, hy - 13, 28, 26));
        }
    }

    private void drawSlash(Graphics2D g, double camX, double camY) {
        double p = 1 - attackT / 0.2; // progresso 0..1
        double a = U.clamp(1.2 - p * 1.2, 0, 1);
        double cx = b.cx() - camX, cy = b.cy() - camY;
        AffineTransform old = g.getTransform();
        g.translate(cx, cy);
        double base;
        switch (attackDir) {
            case 1: base = -90; g.translate(0, -26); break;
            case 2: base = 90; g.translate(0, 30); break;
            default: base = facing > 0 ? 0 : 180; g.translate(facing * 26, -4); break;
        }
        double sweep = 150;
        double start = -(base) - sweep / 2 + (altSlash ? 10 : -10);
        double r = 34;
        for (int i = 0; i < 3; i++) {
            double rr = r - i * 6;
            g.setColor(U.alpha(i == 0 ? U.rgb(0xdfe9ff) : Color.WHITE, a * (0.35 + i * 0.3)));
            g.setStroke(new BasicStroke((float) (10 - i * 3), BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
            double ext = sweep * U.clamp(p * 2.2, 0.2, 1) - i * 12;
            g.draw(new Arc2D.Double(-rr, -rr * (attackDir == 0 ? 0.8 : 1), rr * 2, rr * 2 * (attackDir == 0 ? 0.8 : 1), start + i * 6, ext, Arc2D.OPEN));
        }
        g.setTransform(old);
    }

    /** Silhueta usada nos rastros do dash. */
    static void drawSilhouette(Graphics2D g, double sx, double sy, int facing, Color c, double alpha) {
        AffineTransform old = g.getTransform();
        g.translate(sx, sy);
        g.scale(facing, 1);
        g.setColor(U.alpha(c, alpha));
        Path2D p = new Path2D.Double();
        p.moveTo(-6, -27);
        p.lineTo(-16, -6);
        p.lineTo(10, -6);
        p.lineTo(6, -27);
        p.closePath();
        g.fill(p);
        g.fill(new Ellipse2D.Double(-10, -44, 20, 18));
        g.setColor(U.alpha(U.rgb(0xaad4ff), alpha * 0.6));
        g.fill(new Ellipse2D.Double(-8, -42, 16, 14));
        g.setTransform(old);
    }
}
