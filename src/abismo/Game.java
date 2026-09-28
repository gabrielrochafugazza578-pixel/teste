package abismo;

import java.awt.AlphaComposite;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.RadialGradientPaint;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.geom.AffineTransform;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** Estado do jogo, regras, camera e renderizacao de cada quadro. */
final class Game {
    enum St { TITLE, PLAY, PAUSE, DEAD, POPUP, VICTORY }

    static final int W = U.W, H = U.H, T = U.T;
    static final Font SERIF = new Font(Font.SERIF, Font.PLAIN, 16);

    final Input in;
    St st = St.TITLE;
    Room room;
    Player player = new Player();
    Save save = new Save();
    final List<Enemy> enemies = new ArrayList<>();
    final List<Particle> particles = new ArrayList<>();
    final List<Projectile> projectiles = new ArrayList<>();
    final List<SpellShot> spells = new ArrayList<>();
    final List<Geo> geos = new ArrayList<>();
    final List<double[]> pedestals = new ArrayList<>(); // x, y, tipo(0 dash / 1 asas), t
    final List<double[]> spores = new ArrayList<>();
    final List<double[]> lights = new ArrayList<>();
    Boss boss;

    double camX, camY, shakeAmt, hitStopT, flashT, time, playTime;
    double fade;
    int fadeDir;
    Runnable fadeAction;
    boolean doorLock, hazardLock;
    int spikeSwing = -1;

    String areaName = "", areaSub = "", lastArea = "";
    double areaT = 99;
    String popTitle, popText, popHint;
    double popT;
    String toast;
    double toastT = 99;
    double deadT, victoryT, hudHurtT, gateAnim;
    int menuIdx, pauseIdx;
    String shadeRoom;
    double shadeX, shadeY;
    int shadeGeo;
    boolean continueAvailable;

    // grade de iluminacao (1 ponto a cada 8 pixels) e vinheta pre-calculada
    private static final int CELL = 8, GW = W / CELL + 2, GH = H / CELL + 2;
    private final float[] lightGrid = new float[GW * GH];
    private final float[] vignetteGrid = new float[GW * GH];
    private final int[] rowD = new int[GW];
    private int[] targetPixels;
    private BufferedImage target;

    Game(Input in) {
        this.in = in;
        room = World.room(World.START_ROOM);
        World.preloadAsync();
        continueAvailable = Save.exists();
        for (int i = 0; i < 70; i++) spores.add(newSpore(true));
        for (int gy = 0; gy < GH; gy++)
            for (int gx = 0; gx < GW; gx++) {
                double nx = (gx * CELL - W / 2.0) / (W / 2.0), ny = (gy * CELL - H / 2.0) / (H / 2.0);
                double d = Math.sqrt(nx * nx * 0.8 + ny * ny * 1.1);
                vignetteGrid[gy * GW + gx] = (float) (U.smooth((d - 0.45) / 0.75) * 0.8);
            }
        Sound.music("ambient");
    }

    // ================================================================== ciclo principal

    void update(double dt) {
        time += dt;
        switch (st) {
            case TITLE: updateTitle(dt); break;
            case PAUSE: updatePause(); break;
            case POPUP:
                popT += dt;
                updateParticles(dt);
                if (popT > 0.9 && in.confirm()) st = St.PLAY;
                break;
            case DEAD:
                deadT += dt;
                updateParticles(dt);
                if (deadT > 2.4) respawn();
                break;
            case VICTORY:
                victoryT += dt;
                updateWorld(dt);
                if (victoryT > 3 && in.confirm()) st = St.PLAY;
                break;
            case PLAY:
                if (in.pause()) { st = St.PAUSE; pauseIdx = 0; Sound.play("menu"); break; }
                updateWorld(dt);
                break;
            default: break;
        }
        updateSpores(dt);
        in.endFrame();
    }

    boolean locked() { return st != St.PLAY || fadeDir != 0 || hazardLock; }

    private void updateTitle(double dt) {
        camX = (Math.sin(time * 0.05) * 0.5 + 0.5) * (room.pxW() - W);
        camY = room.pxH() - H - 40 - Math.sin(time * 0.08) * 40;
        camY = U.clamp(camY, 0, room.pxH() - H);
        int n = continueAvailable ? 3 : 2;
        if (in.upPressed()) { menuIdx = (menuIdx + n - 1) % n; Sound.play("menu"); }
        if (in.downPressed()) { menuIdx = (menuIdx + 1) % n; Sound.play("menu"); }
        if (in.wasPressed(java.awt.event.KeyEvent.VK_ENTER, java.awt.event.KeyEvent.VK_Z, java.awt.event.KeyEvent.VK_X,
                java.awt.event.KeyEvent.VK_SPACE, java.awt.event.KeyEvent.VK_J)) {
            String opt = menuOptions()[menuIdx];
            Sound.play("menu");
            if (opt.equals("Novo Jogo")) newGame();
            else if (opt.equals("Continuar")) continueGame();
            else System.exit(0);
        }
    }

    String[] menuOptions() {
        return continueAvailable ? new String[]{"Continuar", "Novo Jogo", "Sair"} : new String[]{"Novo Jogo", "Sair"};
    }

    private void updatePause() {
        if (in.pause()) { st = St.PLAY; return; }
        if (in.upPressed() || in.downPressed()) { pauseIdx = 1 - pauseIdx; Sound.play("menu"); }
        if (in.confirm()) {
            Sound.play("menu");
            if (pauseIdx == 0) st = St.PLAY;
            else {
                save.playTime = playTime;
                save.write();
                continueAvailable = true;
                st = St.TITLE;
                menuIdx = 0;
                room = World.room(World.START_ROOM);
                clearEntities();
                Sound.music("ambient");
            }
        }
    }

    void newGame() {
        save = new Save();
        player = new Player();
        playTime = 0;
        shadeRoom = null;
        lastArea = "";
        loadRoom(World.START_ROOM);
        int[] s = room.start;
        player.place(s[0] * T + T / 2.0, (s[1] + 1) * T);
        snapCamera();
        st = St.PLAY;
        fade = 1;
        fadeDir = -1;
    }

    void continueGame() {
        save = Save.load();
        player = new Player();
        player.geo = save.geo;
        player.maxHp = player.hp = save.maxHp;
        player.hasDash = save.hasDash;
        player.hasWings = save.hasWings;
        playTime = save.playTime;
        lastArea = "";
        respawnAtBench();
        st = St.PLAY;
        fade = 1;
        fadeDir = -1;
    }

    // ================================================================== mundo

    private void updateWorld(double dt) {
        if (hitStopT > 0) { hitStopT -= dt; return; }
        playTime += dt;
        if (fadeDir != 0) {
            fade += fadeDir * dt * 4.5;
            if (fadeDir > 0 && fade >= 1) {
                fade = 1;
                fadeDir = -1;
                Runnable a = fadeAction;
                fadeAction = null;
                if (a != null) a.run();
            } else if (fadeDir < 0 && fade <= 0) {
                fade = 0;
                fadeDir = 0;
            }
        }

        int prevHp = player.hp;
        if (!player.dead) player.update(this, dt);
        if (player.hp < prevHp) hudHurtT = 0.6;
        hudHurtT = Math.max(0, hudHurtT - dt);

        // portas
        if (fadeDir == 0 && !player.dead) {
            char d = room.doorAt((int) Math.floor(player.b.cx() / T), (int) Math.floor(player.b.cy() / T));
            if (d != 0 && !doorLock) enterDoor(d);
            if (d == 0) doorLock = false;
        }

        // bancos
        if (!locked() && !player.sitting && player.b.onGround && in.upPressed()) {
            int[] bench = nearBench();
            if (bench != null) sit(bench);
        }

        // habilidades
        for (double[] pd : pedestals) {
            pd[3] += dt;
            if (pd[4] == 0 && !player.dead && Math.abs(player.b.cx() - pd[0]) < 22 && Math.abs(player.b.y + player.b.h - pd[1]) < 60) {
                pd[4] = 1;
                obtain((int) pd[2], pd[0], pd[1] - 40);
            }
        }

        // inimigos
        for (Enemy e : enemies) {
            if (e.dead) continue;
            e.update(this, dt);
            if (e.harmful() && !player.dead && e.overlaps(player.b)) player.hurt(this, 1, e.cx());
            if (e.y > room.pxH() + 200) e.dead = true;
        }
        enemies.removeIf(e -> e.dead);

        for (Iterator<Projectile> it = projectiles.iterator(); it.hasNext(); ) {
            Projectile p = it.next();
            p.update(this, dt);
            if (p.dead) it.remove();
        }
        for (Iterator<SpellShot> it = spells.iterator(); it.hasNext(); ) {
            SpellShot s = it.next();
            s.update(this, dt);
            if (s.dead) it.remove();
        }
        for (Iterator<Geo> it = geos.iterator(); it.hasNext(); ) {
            Geo g = it.next();
            g.update(this, dt);
            if (g.taken) {
                it.remove();
                player.geo++;
                Sound.play("geo");
                particles.add(new Particle(Particle.GLOW, g.cx(), g.cy(), 0, -30, 0.3, 5, U.rgb(0xdff4ff)));
            }
        }

        // sombra (geo perdido)
        if (shadeRoom != null && shadeRoom.equals(room.def.id) && !player.dead
                && Math.hypot(player.b.cx() - shadeX, player.b.cy() - shadeY) < 34) {
            player.geo += shadeGeo;
            burst(shadeX, shadeY, U.rgb(0xb9a7ff), 30, 300);
            Sound.play("pickup");
            showToast("Você recuperou " + shadeGeo + " geo da sua sombra");
            shadeRoom = null;
            shadeGeo = 0;
        }

        updateParticles(dt);
        updateCamera(dt);
        shakeAmt = Math.max(0, shakeAmt - dt * 40);
        areaT += dt;
        toastT += dt;
        flashT = Math.max(0, flashT - dt);
        gateAnim = U.approach(gateAnim, room.gateClosed ? 1 : 0, dt * 3);
    }

    private void updateParticles(double dt) {
        particles.removeIf(p -> !p.update(dt));
        if (particles.size() > 1500) particles.subList(0, particles.size() - 1500).clear();
    }

    private void updateCamera(double dt) {
        Body b = player.b;
        double tx = b.cx() - W / 2.0 + player.facing * 60;
        double ty = b.cy() - H / 2.0 - 30;
        if (player.b.onGround && in.downKey() && Math.abs(b.vx) < 1 && st == St.PLAY) ty += 120;
        if (player.b.onGround && in.up() && Math.abs(b.vx) < 1 && st == St.PLAY && nearBench() == null) ty -= 110;
        camX += (tx - camX) * Math.min(1, dt * 5);
        camY += (ty - camY) * Math.min(1, dt * (b.vy > 500 ? 12 : 6));
        clampCamera();
    }

    private void snapCamera() {
        camX = player.b.cx() - W / 2.0;
        camY = player.b.cy() - H / 2.0 - 30;
        clampCamera();
    }

    private void clampCamera() {
        camX = U.clamp(camX, 0, Math.max(0, room.pxW() - W));
        camY = U.clamp(camY, 0, Math.max(0, room.pxH() - H));
    }

    private void updateSpores(double dt) {
        for (double[] s : spores) {
            s[0] += s[3] * dt + Math.sin(time * 0.7 + s[5]) * 6 * dt;
            s[1] += s[4] * dt;
            if (s[1] < -40) { double[] n = newSpore(false); System.arraycopy(n, 0, s, 0, n.length); }
        }
    }

    private double[] newSpore(boolean anywhere) {
        // x, y (espaco de tela com parallax), z, vx, vy, fase
        double z = U.rnd(0.35, 1.3);
        return new double[]{U.rnd(0, W + 100), anywhere ? U.rnd(0, H) : H + 30, z, U.rnd(-8, 8), -U.rnd(6, 22) * z, U.rnd(0, 10)};
    }

    // ================================================================== salas

    private void loadRoom(String id) {
        room = World.room(id);
        if (!room.def.area.equals(lastArea)) {
            lastArea = room.def.area;
            areaName = room.def.area;
            areaSub = "";
            areaT = 0;
        }
        clearEntities();
        room.gateClosed = false;
        gateAnim = 0;
        for (int[] s : room.spawns) {
            char c = (char) s[0];
            double x = s[1] * T, y = s[2] * T, floor = (s[2] + 1) * T;
            switch (c) {
                case 'c': enemies.add(new Crawler(x, floor - 22)); break;
                case 'f': enemies.add(new Flyer(x, y)); break;
                case 's': enemies.add(new Spitter(x + 1, floor - 28)); break;
                case 'g': enemies.add(new GeoRock(x + 1, floor - 30)); break;
                case 'K':
                    if (!save.bossDead) {
                        boss = new Boss(x, floor - 88);
                        enemies.add(boss);
                    }
                    break;
                case 'D':
                    pedestals.add(new double[]{x + T / 2.0, floor, 0, 0, player.hasDash ? 1 : 0});
                    break;
                case 'W':
                    pedestals.add(new double[]{x + T / 2.0, floor, 1, 0, player.hasWings ? 1 : 0});
                    break;
                default: break;
            }
        }
        if (boss == null && room.def.theme == Theme.ARENA) Sound.music("ambient");
    }

    private void clearEntities() {
        enemies.clear();
        projectiles.clear();
        spells.clear();
        geos.clear();
        pedestals.clear();
        boss = null;
    }

    private void enterDoor(char d) {
        String[] link = room.def.links.get(d);
        if (link == null) return;
        final int vx = (int) Math.signum(player.b.vx);
        startFade(() -> {
            loadRoom(link[0]);
            placeAtDoor(link[1].charAt(0), vx);
            snapCamera();
        });
    }

    private void startFade(Runnable r) {
        fadeAction = r;
        fadeDir = 1;
    }

    private void placeAtDoor(char d, int incomingVx) {
        List<int[]> tiles = room.doors.get(d);
        if (tiles == null) { int[] s = room.start != null ? room.start : new int[]{3, 3}; player.place(s[0] * T, (s[1] + 1) * T); return; }
        int minX = 9999, maxX = -1, minY = 9999, maxY = -1;
        for (int[] p : tiles) {
            minX = Math.min(minX, p[0]); maxX = Math.max(maxX, p[0]);
            minY = Math.min(minY, p[1]); maxY = Math.max(maxY, p[1]);
        }
        double cx = (minX + maxX + 1) * T / 2.0;
        doorLock = true;
        player.dashT = 0;
        if (minX == 0 && maxX == 0) {
            player.place(2.2 * T, (maxY + 1) * T);
            player.facing = 1;
            player.forceT = 0.25;
            player.forceDir = 1;
        } else if (maxX == room.w - 1 && minX == maxX) {
            player.place((room.w - 2.2) * T, (maxY + 1) * T);
            player.facing = -1;
            player.forceT = 0.25;
            player.forceDir = -1;
        } else if (maxY == room.h - 1) {
            player.place(cx, (room.h - 1.5) * T);
            player.b.vy = -980;
            player.forceT = 0.35;
            player.forceDir = incomingVx != 0 ? incomingVx : 1;
        } else {
            player.place(cx, 2.4 * T);
            player.b.vy = 100;
        }
        player.canDash = true;
        player.airJumps = player.hasWings ? 1 : 0;
    }

    int[] nearBench() {
        for (int[] bch : room.benches) {
            double bx = bch[0] * T + T / 2.0, by = (bch[1] + 1) * T;
            if (Math.abs(player.b.cx() - bx) < 36 && Math.abs(player.b.y + player.b.h - by) < 8) return bch;
        }
        return null;
    }

    private void sit(int[] bench) {
        player.sitting = true;
        player.b.vx = 0;
        player.b.x = bench[0] * T + T / 2.0 - player.b.w / 2;
        player.hp = player.maxHp;
        save.benchRoom = room.def.id;
        save.benchX = bench[0];
        save.benchY = bench[1];
        syncSave();
        save.write();
        continueAvailable = true;
        Sound.play("bench");
        burst(player.b.cx(), player.b.cy(), room.def.theme.light, 20, 120);
        showToast("Descansando...  vida restaurada  ·  jogo salvo");
    }

    private void syncSave() {
        save.geo = player.geo;
        save.maxHp = player.maxHp;
        save.hasDash = player.hasDash;
        save.hasWings = player.hasWings;
        save.playTime = playTime;
    }

    private void respawnAtBench() {
        loadRoom(save.benchRoom);
        int bx, by;
        if (save.benchX >= 0 && save.benchX < room.w) { bx = save.benchX; by = save.benchY; }
        else if (!room.benches.isEmpty()) { bx = room.benches.get(0)[0]; by = room.benches.get(0)[1]; }
        else { bx = room.start[0]; by = room.start[1]; }
        player.place(bx * T + T / 2.0, (by + 1) * T);
        player.sitting = !room.benches.isEmpty();
        snapCamera();
    }

    private void respawn() {
        player.dead = false;
        player.hp = player.maxHp;
        player.soul = 0;
        player.invuln = 0;
        player.knockT = 0;
        respawnAtBench();
        st = St.PLAY;
        fade = 1;
        fadeDir = -1;
        hazardLock = false;
        Sound.music("ambient");
        if (shadeRoom != null) showToast("Sua sombra guarda " + shadeGeo + " geo onde você caiu");
    }

    // ================================================================== eventos de jogo

    void playerAttack(Player p, Rectangle2D hb, int dir, int swing) {
        boolean hitAny = false;
        for (Enemy e : enemies) {
            if (!e.hittable() || e.lastSwing == swing || !e.overlaps(hb)) continue;
            e.lastSwing = swing;
            double kx = dir == 0 ? p.facing : 0, ky = dir == 1 ? -1 : dir == 2 ? 1 : 0;
            e.hit(this, 13, kx, ky);
            hitAny = true;
            if (!(e instanceof GeoRock)) p.soul = Math.min(Player.SOUL_MAX, p.soul + 11);
        }
        if (dir == 2 && spikeSwing != swing && room.touchesSpikes(hb.getX(), hb.getY(), hb.getWidth(), hb.getHeight())) {
            spikeSwing = swing;
            Sound.play("tink");
            for (int i = 0; i < 8; i++)
                particles.add(new Particle(Particle.SPARK, p.b.cx(), hb.getMaxY() - 14, U.rnd(-200, 200), U.rnd(-300, -50), 0.25, 2, Color.WHITE));
            p.pogo();
        }
        if (hitAny) {
            hitStop(0.05);
            shake(3);
            if (dir == 2) p.pogo();
            else if (dir == 0) { p.recoilT = 0.08; p.recoilV = -p.facing * 280; }
        }
    }

    void castSpell(Player p) {
        spells.add(new SpellShot(p.b.cx() + p.facing * 20, p.b.cy() - 6, p.facing));
        Sound.play("spell");
        shake(3);
        burst(p.b.cx() + p.facing * 16, p.b.cy() - 6, U.rgb(0xdff0ff), 10, 200);
    }

    void hitFx(double x, double y, double dx, double dy, Color blood) {
        Sound.play("hit");
        for (int i = 0; i < 10; i++) {
            double a = Math.atan2(dy, dx) + U.rnd(-0.7, 0.7);
            double sp = U.rnd(300, 700);
            particles.add(new Particle(Particle.SPARK, x, y, Math.cos(a) * sp, Math.sin(a) * sp, 0.18, 2.5, Color.WHITE).drag(0.08));
        }
        for (int i = 0; i < 8; i++)
            particles.add(new Particle(Particle.DOT, x, y, U.rnd(-220, 220) + dx * 150, U.rnd(-280, 40) + dy * 150, U.rnd(0.4, 0.8), U.rnd(2, 4), blood).grav(1300));
        particles.add(new Particle(Particle.RING, x, y, 0, 0, 0.22, 34, Color.WHITE));
    }

    void enemyDeath(Enemy e) {
        if (e instanceof GeoRock) return;
        Sound.play("die");
        shake(5);
        hitStop(0.07);
        burst(e.cx(), e.cy(), e.blood(), 24, 320);
        for (int i = 0; i < 10; i++)
            particles.add(new Particle(Particle.SHARD, e.cx(), e.cy(), U.rnd(-260, 260), U.rnd(-420, -80), U.rnd(0.8, 1.4), U.rnd(3, 6), U.rgb(0x2a1d18)).grav(1500));
        spawnGeo(e.cx(), e.cy(), e.geoDrop);
    }

    void spawnGeo(double x, double y, int n) {
        for (int i = 0; i < n; i++) geos.add(new Geo(x, y));
    }

    void burst(double x, double y, Color c, int n, double speed) {
        for (int i = 0; i < n; i++) {
            double a = Math.random() * Math.PI * 2, sp = Math.random() * speed;
            particles.add(new Particle(Particle.GLOW, x, y, Math.cos(a) * sp, Math.sin(a) * sp, U.rnd(0.3, 0.8), U.rnd(3, 6), c).drag(0.05));
        }
    }

    void dust(double x, double y, int n) {
        Color c = U.mix(room.def.theme.fog, room.def.theme.rim, 0.4);
        for (int i = 0; i < n; i++)
            particles.add(new Particle(Particle.DUST, x + U.rnd(-6, 6), y - 3, U.rnd(-90, 90), U.rnd(-50, -5), U.rnd(0.35, 0.7), U.rnd(4, 8), c).drag(0.08));
    }

    void wingBurst(Player p) {
        for (int i = 0; i < 12; i++) {
            double side = i % 2 == 0 ? -1 : 1;
            particles.add(new Particle(Particle.GLOW, p.b.cx() + side * 8, p.b.cy() - 6, side * U.rnd(60, 200), U.rnd(40, 160), 0.4, 4, U.rgb(0xe8f4ff)).drag(0.08));
        }
    }

    void dashBurst(Player p) {
        for (int i = 0; i < 14; i++)
            particles.add(new Particle(Particle.DUST, p.b.cx() - p.facing * 10, p.b.cy() + U.rnd(-14, 14), -p.facing * U.rnd(100, 380), U.rnd(-30, 30), 0.4, U.rnd(5, 9), U.rgb(0x0e1018)).drag(0.1));
    }

    void hitStop(double t) { hitStopT = Math.max(hitStopT, t); }
    void shake(double a) { shakeAmt = Math.max(shakeAmt, a); }
    void flash(double t) { flashT = Math.max(flashT, t); }

    void onPlayerHurt() {
        Sound.play("hurt");
        hitStop(0.14);
        shake(11);
        flash(0.22);
        for (int i = 0; i < 12; i++)
            particles.add(new Particle(Particle.SHARD, player.b.cx(), player.b.cy(), U.rnd(-300, 300), U.rnd(-400, -60), 0.8, 4, U.rgb(0x10131a)).grav(1400));
        if (player.hp <= 0) die();
    }

    void onHeal() {
        Sound.play("heal");
        burst(player.b.cx(), player.b.cy() - 10, Color.WHITE, 26, 200);
        particles.add(new Particle(Particle.RING, player.b.cx(), player.b.cy() - 10, 0, 0, 0.4, 60, Color.WHITE));
    }

    void playerHazard() {
        if (hazardLock || player.dead) return;
        hazardLock = true;
        player.hp -= 1;
        player.invuln = 0;
        player.hurt(this, 0, player.b.cx() + player.facing);
        if (player.dead || player.hp <= 0) return;
        startFade(() -> {
            player.b.x = player.safeX;
            player.b.y = player.safeY;
            player.b.vx = player.b.vy = 0;
            player.knockT = 0;
            player.invuln = 1.0;
            hazardLock = false;
            snapCamera();
        });
    }

    private void die() {
        if (player.dead) return;
        player.dead = true;
        st = St.DEAD;
        deadT = 0;
        hazardLock = false;
        fadeDir = 0;
        fadeAction = null;
        burst(player.b.cx(), player.b.cy(), U.rgb(0x9e8cff), 40, 380);
        burst(player.b.cx(), player.b.cy(), Color.WHITE, 20, 200);
        if (player.geo > 0) {
            shadeRoom = room.def.id;
            shadeX = player.safeX + player.b.w / 2;
            shadeY = player.safeY + player.b.h / 2 - 10;
            shadeGeo = player.geo;
            player.geo = 0;
        }
    }

    private void obtain(int type, double x, double y) {
        Sound.play("pickup");
        burst(x, y, Color.WHITE, 50, 420);
        particles.add(new Particle(Particle.RING, x, y, 0, 0, 0.8, 200, Color.WHITE));
        flash(0.5);
        if (type == 0) {
            player.hasDash = true;
            popTitle = "MANTO DE SOMBRA";
            popText = "Um manto tecido de fumaça antiga. Permite avançar num lampejo.";
            popHint = "Pressione  C  (ou Shift / K)  para dar um avanço rápido — também no ar";
        } else {
            player.hasWings = true;
            popTitle = "ASAS MONARCAS";
            popText = "Asas etéreas que brotam das costas do andarilho.";
            popHint = "Pressione  pular  novamente no ar para um pulo duplo";
        }
        syncSave();
        save.write();
        st = St.POPUP;
        popT = 0;
    }

    void bossWake(Boss b) {
        room.gateClosed = true;
        Sound.music("boss");
        areaName = "Guardião Oco";
        areaSub = "sentinela do trono esquecido";
        areaT = 0;
        shake(8);
    }

    void bossDefeated(Boss b) {
        save.bossDead = true;
        room.gateClosed = false;
        spawnGeo(b.cx(), b.cy(), 60);
        burst(b.cx(), b.cy(), Enemy.INFECTION, 80, 520);
        burst(b.cx(), b.cy(), Color.WHITE, 40, 300);
        Sound.play("die");
        Sound.music("ambient");
        flash(0.8);
        syncSave();
        save.write();
        st = St.VICTORY;
        victoryT = 0;
        boss = null;
    }

    void showToast(String s) {
        toast = s;
        toastT = 0;
    }

    // ================================================================== renderizacao

    void render(Graphics2D g, BufferedImage target) {
        if (this.target != target) {
            this.target = target;
            targetPixels = ((java.awt.image.DataBufferInt) target.getRaster().getDataBuffer()).getData();
        }
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);

        double sx = 0, sy = 0;
        if (shakeAmt > 0.1) {
            sx = (Noise.value(time * 40, 0, 1) - 0.5) * shakeAmt * 2;
            sy = (Noise.value(0, time * 40, 2) - 0.5) * shakeAmt * 2;
        }
        double cx = Math.round(camX + sx), cy = Math.round(camY + sy);

        renderWorld(g, cx, cy, st != St.TITLE);

        if (st == St.TITLE) { renderTitle(g); return; }

        renderHud(g);
        if (flashT > 0) {
            g.setColor(U.alpha(Color.WHITE, flashT * 0.6));
            g.fillRect(0, 0, W, H);
        }
        renderAreaTitle(g);
        renderToast(g);
        if (st == St.POPUP) renderPopup(g);
        if (st == St.PAUSE) renderPause(g);
        if (st == St.VICTORY) renderVictory(g);
        if (st == St.DEAD) {
            g.setColor(U.alpha(Color.BLACK, U.clamp((deadT - 0.6) / 1.2, 0, 1)));
            g.fillRect(0, 0, W, H);
        }
        if (fade > 0) {
            g.setColor(U.alpha(Color.BLACK, fade));
            g.fillRect(0, 0, W, H);
        }
    }

    private void renderWorld(Graphics2D g, double cx, double cy, boolean entities) {
        Theme th = room.def.theme;
        // a primeira camada de fundo e opaca e ja contem o ceu

        // camadas de fundo
        for (int i = 0; i < room.layers.length; i++) {
            double f = room.layerF[i];
            g.drawImage(room.layers[i], (int) Math.round(-cx * f - 40), (int) Math.round(-cy * f - 40), null);
            if (i == 1) renderShafts(g, cx, cy);
        }

        // terreno
        g.drawImage(room.terrain, (int) -cx, (int) -cy, null);

        lights.clear();
        if (entities || st == St.TITLE) renderDecor(g, cx, cy);
        if (entities) {
            for (Geo o : geos) o.render(g, cx, cy);
            for (Enemy e : enemies) e.render(g, cx, cy);
            for (Projectile p : projectiles) p.render(g, cx, cy);
            player.render(g, cx, cy);
            for (SpellShot s : spells) s.render(g, cx, cy);
        }
        for (Particle p : particles) p.render(g, cx, cy);

        // primeiro plano
        Art.fillShapes(g, room.foreground, -cx * 1.25, -cy * 1.25, U.scale(th.rockDark, 0.6));

        // luz e escuridao
        collectLights(entities);
        renderLighting(g, cx, cy, th);

        // esporos
        for (double[] s : spores) {
            double z = s[2];
            double x = ((s[0] - cx * z * 0.4) % (W + 100) + (W + 100)) % (W + 100) - 50;
            double y = s[1];
            double a = 0.35 + 0.35 * Math.sin(time * 2 + s[5]);
            double size = 3 + z * 5;
            Art.setAlpha(g, a * Math.min(1, z));
            g.drawImage(Art.glow(th.accent), (int) (x - size), (int) (y - size), (int) (size * 2), (int) (size * 2), null);
        }
        Art.setAlpha(g, 1);
    }

    private void renderShafts(Graphics2D g, double cx, double cy) {
        Theme th = room.def.theme;
        for (double[] s : room.shafts) {
            double x = s[0] - cx * 0.75, y = -cy * 0.75 - 40;
            double wdt = s[1], ang = s[2], len = s[3];
            double a = s[4] * (0.7 + 0.3 * Math.sin(time * 0.6 + s[5]));
            double dx = Math.sin(ang) * len, dy = Math.cos(ang) * len;
            if (x + dx < -200 || x - wdt > W + 200) continue;
            Path2D p = new Path2D.Double();
            p.moveTo(x, y);
            p.lineTo(x + wdt, y);
            p.lineTo(x + wdt * 1.8 + dx, y + dy);
            p.lineTo(x - wdt * 0.2 + dx, y + dy);
            p.closePath();
            g.setPaint(new GradientPaint((float) x, (float) y, U.alpha(th.light, a), (float) (x + dx), (float) (y + dy), U.alpha(th.light, 0)));
            g.fill(p);
        }
    }

    private void renderDecor(Graphics2D g, double cx, double cy) {
        Theme th = room.def.theme;
        // lanternas
        for (int[] l : room.lanterns) {
            double lx = l[0] * T + T / 2.0, ly = l[1] * T + T / 2.0;
            int top = room.ceilingAbove(l[0], l[1]);
            double sway = Math.sin(time * 1.2 + l[0]) * 3;
            double sx = lx - cx + sway, sy = ly - cy;
            if (sx < -100 || sx > W + 100 || sy < -100 || sy > H + 100) continue;
            g.setColor(U.rgb(0x151820));
            g.setStroke(new BasicStroke(1.5f));
            g.draw(new Line2D.Double(lx - cx, top * T - cy, sx, sy - 10));
            double flick = 0.85 + 0.15 * Noise.value(time * 6, l[0], 3);
            g.drawImage(Art.glow(th.light), (int) (sx - 40), (int) (sy - 40), 80, 80, null);
            g.setColor(U.rgb(0x1c1f28));
            g.fill(new RoundRectangle2D.Double(sx - 8, sy - 12, 16, 22, 6, 6));
            g.setColor(U.alpha(U.mix(th.light, Color.WHITE, 0.5), flick));
            g.fill(new Ellipse2D.Double(sx - 5, sy - 7, 10, 13));
            g.setColor(U.rgb(0x0d0f14));
            g.fill(new Rectangle2D.Double(sx - 9, sy - 13, 18, 3));
            g.fill(new Rectangle2D.Double(sx - 7, sy + 9, 14, 3));
            lights.add(new double[]{lx + sway, ly, 250 * flick, 0.95});
        }
        // bancos
        for (int[] bch : room.benches) {
            double bx = bch[0] * T + T / 2.0 - cx, by = (bch[1] + 1) * T - cy;
            drawBench(g, bx, by, th);
            lights.add(new double[]{bch[0] * T + T / 2.0, (bch[1] + 1) * T - 20, 150, 0.5});
            if (st == St.PLAY && !player.sitting && nearBench() == bch) prompt(g, bx, by - 70, "↑  Descansar");
        }
        // pedestais
        for (double[] pd : pedestals) {
            double px = pd[0] - cx, py = pd[1] - cy;
            g.setPaint(new GradientPaint(0, (float) (py - 30), U.mix(th.rock, th.rim, 0.4), 0, (float) py, th.rockDark));
            Path2D ped = new Path2D.Double();
            ped.moveTo(px - 18, py);
            ped.lineTo(px - 12, py - 24);
            ped.lineTo(px - 16, py - 30);
            ped.lineTo(px + 16, py - 30);
            ped.lineTo(px + 12, py - 24);
            ped.lineTo(px + 18, py);
            ped.closePath();
            g.fill(ped);
            if (pd[4] == 0) {
                double oy = py - 52 + Math.sin(pd[3] * 2.5) * 5;
                Color col = pd[2] == 0 ? U.rgb(0xb8a8ff) : U.rgb(0xfff2b0);
                g.drawImage(Art.glow(col), (int) (px - 50), (int) (oy - 50), 100, 100, null);
                g.setColor(Color.WHITE);
                g.fill(new Ellipse2D.Double(px - 8, oy - 8, 16, 16));
                lights.add(new double[]{pd[0], oy + cy, 220, 1});
            }
        }
        // portao do chefe
        if (gateAnim > 0.01) {
            for (int ty = 0; ty < room.h; ty++)
                for (int tx = 0; tx < room.w; tx++)
                    if (room.tile(tx, ty) == Room.GATE) {
                        double gx = tx * T - cx, gy = ty * T - cy;
                        double drop = (1 - gateAnim) * T * 3;
                        g.setColor(U.rgb(0x1a1210));
                        for (int k = 0; k < 3; k++) g.fill(new Rectangle2D.Double(gx + 4 + k * 10, gy - drop, 5, T));
                        g.setColor(U.alpha(th.rim, 0.5));
                        for (int k = 0; k < 3; k++) g.fill(new Rectangle2D.Double(gx + 4 + k * 10, gy - drop, 1.5, T));
                    }
        }
        // sombra
        if (shadeRoom != null && shadeRoom.equals(room.def.id)) {
            double sx = shadeX - cx, sy = shadeY - cy + Math.sin(time * 2) * 6;
            g.drawImage(Art.glow(U.rgb(0x6a4cff)), (int) (sx - 45), (int) (sy - 45), 90, 90, null);
            Player.drawSilhouette(g, sx, sy + 26, (int) Math.signum(Math.sin(time * 0.5)) | 1, U.rgb(0x07060c), 0.95);
            g.setColor(Color.WHITE);
            g.fill(new Ellipse2D.Double(sx - 4, sy - 10, 3, 5));
            g.fill(new Ellipse2D.Double(sx + 2, sy - 10, 3, 5));
            lights.add(new double[]{shadeX, shadeY, 120, 0.6});
        }
        // dicas
        g.setFont(SERIF.deriveFont(15f));
        FontMetrics fm = g.getFontMetrics();
        for (Object[] h : room.def.hints) {
            double hx = (Double) h[0] * T, hy = (Double) h[1] * T;
            double d = Math.hypot(player.b.cx() - hx, player.b.cy() - hy);
            double a = st == St.TITLE ? 0 : U.clamp(1.6 - d / 220, 0, 1);
            if (a <= 0) continue;
            String s = (String) h[2];
            int tw = fm.stringWidth(s);
            g.setColor(U.alpha(Color.BLACK, a * 0.6));
            g.drawString(s, (int) (hx - cx - tw / 2.0 + 1), (int) (hy - cy + 1));
            g.setColor(U.alpha(U.mix(th.light, Color.WHITE, 0.5), a * 0.9));
            g.drawString(s, (int) (hx - cx - tw / 2.0), (int) (hy - cy));
        }
    }

    private void prompt(Graphics2D g, double x, double y, String s) {
        g.setFont(SERIF.deriveFont(Font.BOLD, 15f));
        FontMetrics fm = g.getFontMetrics();
        int tw = fm.stringWidth(s);
        double a = 0.7 + 0.3 * Math.sin(time * 4);
        g.setColor(U.alpha(Color.BLACK, 0.5));
        g.fill(new RoundRectangle2D.Double(x - tw / 2.0 - 10, y - 17, tw + 20, 24, 12, 12));
        g.setColor(U.alpha(Color.WHITE, a));
        g.drawString(s, (int) (x - tw / 2.0), (int) y);
    }

    private void drawBench(Graphics2D g, double x, double y, Theme th) {
        Color iron = U.mix(U.rgb(0x3c4250), th.rim, 0.25), wood = U.mix(U.rgb(0x8a735c), th.rim, 0.2);
        Art.setAlpha(g, 0.35);
        g.drawImage(Art.glow(th.light), (int) x - 60, (int) y - 70, 120, 90, null);
        Art.setAlpha(g, 1);
        g.setColor(iron);
        g.setStroke(new BasicStroke(3f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        g.draw(new Line2D.Double(x - 26, y, x - 22, y - 16));
        g.draw(new Line2D.Double(x + 26, y, x + 22, y - 16));
        Path2D back = new Path2D.Double();
        back.moveTo(x - 28, y - 16);
        back.curveTo(x - 30, y - 34, x - 14, y - 44, x, y - 38);
        back.curveTo(x + 14, y - 44, x + 30, y - 34, x + 28, y - 16);
        g.setStroke(new BasicStroke(2.5f));
        g.draw(back);
        g.setStroke(new BasicStroke(1.5f));
        for (int i = -2; i <= 2; i++) g.draw(new Line2D.Double(x + i * 8, y - 18, x + i * 7, y - 36 + Math.abs(i) * 2));
        g.setPaint(new GradientPaint(0, (float) (y - 20), wood, 0, (float) (y - 13), U.scale(wood, 0.5)));
        g.fill(new RoundRectangle2D.Double(x - 32, y - 21, 64, 7, 4, 4));
        g.setColor(U.alpha(th.light, 0.6));
        g.draw(new Line2D.Double(x - 30, y - 21, x + 30, y - 21));
    }

    private void collectLights(boolean entities) {
        if (!entities) return;
        if (!player.dead) lights.add(new double[]{player.b.cx(), player.b.cy() - 10, 300 + player.soul, 0.9});
        for (SpellShot s : spells) lights.add(new double[]{s.x, s.y, 240, 1});
        for (Projectile p : projectiles) if (p.delay <= 0 && p.type != Projectile.ROCK) lights.add(new double[]{p.x, p.y, 110, 0.7});
        for (Enemy e : enemies) {
            if (e instanceof Boss) lights.add(new double[]{e.cx(), e.cy(), 260, 0.6});
            else if (!(e instanceof GeoRock)) lights.add(new double[]{e.cx(), e.cy(), 90, 0.45});
        }
        int n = 0;
        for (Geo o : geos) if (n++ < 30) lights.add(new double[]{o.cx(), o.cy(), 50, 0.4});
    }

    private void renderLighting(Graphics2D g, double cx, double cy, Theme th) {
        java.util.Arrays.fill(lightGrid, 0f);
        for (double[] l : lights) {
            double lx = (l[0] - cx) / CELL, ly = (l[1] - cy) / CELL, r = l[2] / CELL, inten = l[3];
            int x0 = (int) Math.max(0, Math.floor(lx - r)), x1 = (int) Math.min(GW - 1, Math.ceil(lx + r));
            int y0 = (int) Math.max(0, Math.floor(ly - r)), y1 = (int) Math.min(GH - 1, Math.ceil(ly + r));
            double inv = 1 / (r * r);
            for (int gy = y0; gy <= y1; gy++)
                for (int gx = x0; gx <= x1; gx++) {
                    double d2 = ((gx - lx) * (gx - lx) + (gy - ly) * (gy - ly)) * inv;
                    if (d2 >= 1) continue;
                    double f = (1 - d2);
                    float c = (float) (inten * f * f);
                    int i = gy * GW + gx;
                    lightGrid[i] = 1 - (1 - lightGrid[i]) * (1 - c);
                }
        }
        double amb = (st == St.TITLE ? th.darkness - 30 : th.darkness) / 255.0;
        // converte luz em escuridao (0..256) combinando com a vinheta
        for (int i = 0; i < lightGrid.length; i++) {
            double d = amb * (1 - lightGrid[i]);
            d = 1 - (1 - d) * (1 - vignetteGrid[i]);
            lightGrid[i] = (float) (d * 256);
        }
        Color dark = U.scale(th.sky1, 0.45);
        int dr = dark.getRed(), dg = dark.getGreen(), db = dark.getBlue();
        int[] px = targetPixels;
        for (int y = 0; y < H; y++) {
            int gy = y / CELL, fy = y % CELL;
            int r0 = gy * GW, r1 = r0 + GW;
            for (int gx = 0; gx < GW; gx++) rowD[gx] = (int) (lightGrid[r0 + gx] + (lightGrid[r1 + gx] - lightGrid[r0 + gx]) * fy / CELL);
            int row = y * W;
            for (int x = 0; x < W; x++) {
                int gx = x >> 3, fx = x & 7;
                int d = rowD[gx] + (((rowD[gx + 1] - rowD[gx]) * fx) >> 3);
                if (d <= 0) continue;
                int p = px[row + x];
                int r = (p >> 16) & 255, gg = (p >> 8) & 255, b = p & 255;
                r += ((dr - r) * d) >> 8;
                gg += ((dg - gg) * d) >> 8;
                b += ((db - b) * d) >> 8;
                px[row + x] = (r << 16) | (gg << 8) | b;
            }
        }
        // brilho colorido das lanternas
        Art.setAlpha(g, 0.22);
        for (int[] l : room.lanterns) {
            double lx = l[0] * T + T / 2.0 - cx, ly = l[1] * T + T / 2.0 - cy;
            if (lx < -200 || lx > W + 200 || ly < -200 || ly > H + 200) continue;
            g.drawImage(Art.glow(th.light), (int) (lx - 150), (int) (ly - 150), 300, 300, null);
        }
        Art.setAlpha(g, 1);
    }

    // ================================================================== HUD e telas

    private void renderHud(Graphics2D g) {
        if (player.dead && st != St.DEAD) return;
        double vx = 58, vy = 60, r = 30;
        // vaso de alma
        g.drawImage(Art.glow(U.rgb(0x10131c)), (int) (vx - 60), (int) (vy - 60), 120, 120, null);
        Path2D horn = new Path2D.Double();
        horn.moveTo(vx - 22, vy - 20);
        horn.curveTo(vx - 30, vy - 36, vx - 20, vy - 50, vx - 6, vy - 52);
        horn.curveTo(vx - 16, vy - 42, vx - 16, vy - 32, vx - 8, vy - 27);
        horn.closePath();
        g.setColor(U.rgb(0xe8e4dc));
        g.fill(horn);
        Ellipse2D outer = new Ellipse2D.Double(vx - r, vy - r, r * 2, r * 2);
        g.setColor(U.rgb(0x0a0c12));
        g.fill(outer);
        Shape oldClip = g.getClip();
        g.clip(new Ellipse2D.Double(vx - r + 4, vy - r + 4, r * 2 - 8, r * 2 - 8));
        double level = player.soul / (double) Player.SOUL_MAX;
        double top = vy + r - 4 - level * (r * 2 - 8);
        Path2D liquid = new Path2D.Double();
        liquid.moveTo(vx - r, vy + r);
        for (int i = 0; i <= 20; i++) {
            double x = vx - r + i * (r * 2 / 20.0);
            liquid.lineTo(x, top + Math.sin(time * 3 + i * 0.6) * (level > 0.02 && level < 0.98 ? 2 : 0));
        }
        liquid.lineTo(vx + r, vy + r);
        liquid.closePath();
        g.setPaint(new GradientPaint(0, (float) top, U.rgb(0xffffff), 0, (float) (vy + r), U.rgb(0xaebfd6)));
        g.fill(liquid);
        g.setClip(oldClip);
        boolean ready = player.soul >= Player.SPELL_COST;
        g.setColor(ready ? U.rgb(0xf4f2ec) : U.rgb(0xb8b4ab));
        g.setStroke(new BasicStroke(3.5f));
        g.draw(new Ellipse2D.Double(vx - r + 2, vy - r + 2, r * 2 - 4, r * 2 - 4));
        if (ready) {
            Art.setAlpha(g, 0.3 + 0.15 * Math.sin(time * 4));
            g.drawImage(Art.glow(Color.WHITE), (int) (vx - 45), (int) (vy - 45), 90, 90, null);
            Art.setAlpha(g, 1);
        }
        if (player.focusing) {
            double k = player.focusT / 0.95;
            g.setColor(U.alpha(Color.WHITE, 0.9));
            g.setStroke(new BasicStroke(3f));
            g.draw(new java.awt.geom.Arc2D.Double(vx - r - 6, vy - r - 6, r * 2 + 12, r * 2 + 12, 90, -360 * k, java.awt.geom.Arc2D.OPEN));
        }

        // mascaras (vida)
        for (int i = 0; i < player.maxHp; i++) {
            double mx = 112 + i * 30, my = 50;
            boolean full = i < player.hp;
            AffineTransform old = g.getTransform();
            g.translate(mx, my);
            g.scale(0.85, 0.85);
            if (full) {
                Player.drawHead(g, 0, 0, 0);
            } else {
                boolean justLost = hudHurtT > 0 && i == player.hp;
                Color c = justLost ? U.alpha(Color.WHITE, hudHurtT) : U.alpha(U.rgb(0x2a2f3a), 0.8);
                g.setColor(c);
                g.fill(new Ellipse2D.Double(-10, -9, 20, 18));
                g.setColor(U.alpha(U.rgb(0x8a93a3), 0.5));
                g.setStroke(new BasicStroke(1.5f));
                g.draw(new Ellipse2D.Double(-10, -9, 20, 18));
            }
            g.setTransform(old);
        }
        // geo
        AffineTransform old = g.getTransform();
        g.translate(118, 84);
        Geo.drawShard(g, 0, 0, 7, 0.3);
        g.setTransform(old);
        g.setFont(SERIF.deriveFont(Font.BOLD, 22f));
        shadowText(g, String.valueOf(player.geo), 134, 92, U.rgb(0xeef2f6), 1);

        // barra do chefe
        if (boss != null && boss.awake() && boss.s != Boss.S.DYING) {
            double bw = 420, bx = W / 2.0 - bw / 2, by = H - 44;
            g.setFont(SERIF.deriveFont(14f));
            String name = Boss.NAME;
            int tw = g.getFontMetrics().stringWidth(name);
            shadowText(g, name, (int) (W / 2.0 - tw / 2.0), (int) by - 8, U.rgb(0xe8dccc), 1);
            g.setColor(U.alpha(Color.BLACK, 0.6));
            g.fill(new Rectangle2D.Double(bx - 2, by - 2, bw + 4, 10));
            double k = boss.hp / (double) boss.maxHp;
            g.setPaint(new GradientPaint((float) bx, 0, U.rgb(0xff8a3c), (float) (bx + bw), 0, U.rgb(0xffd2a0)));
            g.fill(new Rectangle2D.Double(bx, by, bw * k, 6));
        }
    }

    private void shadowText(Graphics2D g, String s, int x, int y, Color c, double a) {
        g.setColor(U.alpha(Color.BLACK, 0.7 * a));
        g.drawString(s, x + 2, y + 2);
        g.setColor(U.alpha(c, a));
        g.drawString(s, x, y);
    }

    private void centerText(Graphics2D g, String s, double y, Color c, double a) {
        int tw = g.getFontMetrics().stringWidth(s);
        shadowText(g, s, (int) (W / 2.0 - tw / 2.0), (int) y, c, a);
    }

    private void ornament(Graphics2D g, double y, double width, double a) {
        double cx = W / 2.0;
        g.setColor(U.alpha(U.rgb(0xe8e4dc), a));
        g.setStroke(new BasicStroke(1.4f));
        g.draw(new Line2D.Double(cx - width, y, cx - 14, y));
        g.draw(new Line2D.Double(cx + 14, y, cx + width, y));
        Path2D d = new Path2D.Double();
        d.moveTo(cx, y - 6);
        d.lineTo(cx + 7, y);
        d.lineTo(cx, y + 6);
        d.lineTo(cx - 7, y);
        d.closePath();
        g.fill(d);
        g.fill(new Ellipse2D.Double(cx - width - 3, y - 3, 6, 6));
        g.fill(new Ellipse2D.Double(cx + width - 3, y - 3, 6, 6));
    }

    private void renderAreaTitle(Graphics2D g) {
        if (areaT > 4.5) return;
        double a = areaT < 0.8 ? areaT / 0.8 : areaT > 3.5 ? 1 - (areaT - 3.5) : 1;
        a = U.clamp(a, 0, 1);
        if (!areaSub.isEmpty()) {
            g.setFont(SERIF.deriveFont(Font.ITALIC, 18f));
            centerText(g, areaSub, 118, U.rgb(0xd8d2c8), a);
        }
        g.setFont(SERIF.deriveFont(46f));
        centerText(g, areaName.toUpperCase(), 170, U.rgb(0xf2efe8), a);
        ornament(g, 192, 170 * a + 40, a);
    }

    private void renderToast(Graphics2D g) {
        if (toast == null || toastT > 3.5) return;
        double a = toastT < 0.3 ? toastT / 0.3 : toastT > 2.8 ? 1 - (toastT - 2.8) / 0.7 : 1;
        g.setFont(SERIF.deriveFont(Font.ITALIC, 17f));
        centerText(g, toast, H - 70, U.rgb(0xeae6de), U.clamp(a, 0, 1));
    }

    private void renderPopup(Graphics2D g) {
        double a = U.clamp(popT / 0.6, 0, 1);
        g.setColor(U.alpha(Color.BLACK, 0.7 * a));
        g.fillRect(0, 0, W, H);
        g.drawImage(Art.glow(U.rgb(0x9fb0ff)), W / 2 - 220, 60, 440, 300, null);
        g.setFont(SERIF.deriveFont(15f));
        centerText(g, "Você obteve", 150, U.rgb(0xcfd6e6), a);
        g.setFont(SERIF.deriveFont(42f));
        centerText(g, popTitle, 205, Color.WHITE, a);
        ornament(g, 228, 200, a);
        g.setFont(SERIF.deriveFont(Font.ITALIC, 18f));
        centerText(g, popText, 280, U.rgb(0xdedad2), a);
        g.setFont(SERIF.deriveFont(Font.BOLD, 17f));
        centerText(g, popHint, 330, U.rgb(0xfff2c8), a);
        if (popT > 0.9) {
            g.setFont(SERIF.deriveFont(14f));
            centerText(g, "pressione X para continuar", 420, U.rgb(0xa8b0c0), 0.5 + 0.5 * Math.sin(time * 4));
        }
    }

    private void renderPause(Graphics2D g) {
        g.setColor(U.alpha(U.rgb(0x05060a), 0.78));
        g.fillRect(0, 0, W, H);
        g.setFont(SERIF.deriveFont(40f));
        centerText(g, "PAUSADO", 110, Color.WHITE, 1);
        ornament(g, 130, 160, 1);
        String[] opts = {"Continuar", "Salvar e sair para o menu"};
        g.setFont(SERIF.deriveFont(22f));
        for (int i = 0; i < opts.length; i++) {
            boolean sel = i == pauseIdx;
            centerText(g, (sel ? "›  " : "") + opts[i] + (sel ? "  ‹" : ""), 185 + i * 38, sel ? Color.WHITE : U.rgb(0x8a92a2), 1);
        }
        drawControls(g, 300);
    }

    private void drawControls(Graphics2D g, double y) {
        String[][] c = {
                {"Mover", "← → / A D"}, {"Pular", "Z / Espaço"}, {"Atacar", "X / J   (+ ↑ ou ↓)"},
                {"Avanço (dash)", "C / Shift / K"}, {"Feitiço", "V / L"}, {"Curar", "segure F / Q"},
                {"Descansar no banco", "↑ / W"}, {"Pausa", "Esc / P"}, {"Tela cheia", "F11"}};
        g.setFont(SERIF.deriveFont(15f));
        for (int i = 0; i < c.length; i++) {
            int col = i % 3, row = i / 3;
            double x = 150 + col * 240, yy = y + row * 44;
            shadowText(g, c[i][0], (int) x, (int) yy, U.rgb(0x9aa3b3), 1);
            shadowText(g, c[i][1], (int) x, (int) yy + 18, U.rgb(0xeef0f4), 1);
        }
    }

    private void renderVictory(Graphics2D g) {
        double a = U.clamp((victoryT - 0.8) / 1.2, 0, 1);
        g.setColor(U.alpha(Color.BLACK, 0.55 * a));
        g.fillRect(0, 0, W, H);
        g.setFont(SERIF.deriveFont(Font.ITALIC, 18f));
        centerText(g, "o silêncio retorna ao trono", 150, U.rgb(0xd8d2c8), a);
        g.setFont(SERIF.deriveFont(48f));
        centerText(g, "GUARDIÃO OCO DERROTADO", 205, Color.WHITE, a);
        ornament(g, 230, 240, a);
        g.setFont(SERIF.deriveFont(18f));
        int mins = (int) (playTime / 60), secs = (int) (playTime % 60);
        centerText(g, String.format("Tempo de jogo  %d:%02d", mins, secs), 285, U.rgb(0xe0e4ec), a);
        centerText(g, "Obrigado por jogar Ecos do Abismo", 320, U.rgb(0xe0e4ec), a);
        if (victoryT > 3) {
            g.setFont(SERIF.deriveFont(14f));
            centerText(g, "pressione X para continuar explorando", 400, U.rgb(0xa8b0c0), 0.5 + 0.5 * Math.sin(time * 4));
        }
    }

    private void renderTitle(Graphics2D g) {
        g.setPaint(new GradientPaint(0, 0, U.alpha(Color.BLACK, 0.2), 0, H, U.alpha(Color.BLACK, 0.75)));
        g.fillRect(0, 0, W, H);
        double a = U.clamp(time / 1.5, 0, 1);
        Art.setAlpha(g, 0.25 * a);
        g.drawImage(Art.glow(U.rgb(0xbcd6ff)), W / 2 - 400, 20, 800, 260, null);
        Art.setAlpha(g, 1);
        g.setFont(SERIF.deriveFont(Font.ITALIC, 18f));
        centerText(g, "um conto das profundezas", 105, U.rgb(0xb8c2d4), a);
        g.setFont(SERIF.deriveFont(76f));
        centerText(g, "ECOS DO ABISMO", 180, U.rgb(0xf4f2ee), a);
        ornament(g, 208, 260, a);

        String[] opts = menuOptions();
        g.setFont(SERIF.deriveFont(24f));
        for (int i = 0; i < opts.length; i++) {
            boolean sel = i == menuIdx;
            double y = 290 + i * 44;
            centerText(g, opts[i], y, sel ? Color.WHITE : U.rgb(0x7d8698), a);
            if (sel) {
                int tw = g.getFontMetrics().stringWidth(opts[i]);
                AffineTransform old = g.getTransform();
                g.translate(W / 2.0 - tw / 2.0 - 34, y - 14);
                g.scale(0.7, 0.7);
                Player.drawHead(g, 0, 8, 0);
                g.setTransform(old);
                old = g.getTransform();
                g.translate(W / 2.0 + tw / 2.0 + 34, y - 14);
                g.scale(-0.7, 0.7);
                Player.drawHead(g, 0, 8, 0);
                g.setTransform(old);
            }
        }
        g.setFont(SERIF.deriveFont(13f));
        centerText(g, "↑ ↓ escolher  ·  Enter / X confirmar  ·  F11 tela cheia", H - 28, U.rgb(0x8890a0), a * 0.9);
    }
}
