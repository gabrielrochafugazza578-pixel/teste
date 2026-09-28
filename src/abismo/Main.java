package abismo;

import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

/** Ecos do Abismo - um metroidvania 2D. Ponto de entrada. */
public final class Main {
    private Main() {}

    public static void main(String[] args) throws Exception {
        if (args.length > 0 && args[0].equals("--shots")) {
            Shots.run(new File(args.length > 1 ? args[1] : "shots"));
            return;
        }
        if (args.length > 0 && args[0].equals("--mute")) Sound.disable();
        System.setProperty("sun.java2d.xrender", System.getProperty("sun.java2d.xrender", "true"));
        Sound.init();
        SwingUtilities.invokeAndWait(() -> new GameWindow().start());
    }
}

/** Janela, laco principal com passo fixo e escala com barras pretas. */
final class GameWindow {
    private final JFrame frame = new JFrame("Ecos do Abismo");
    private final Canvas canvas = new Canvas();
    private final Input input = new Input();
    private final BufferedImage back = new BufferedImage(U.W, U.H, BufferedImage.TYPE_INT_RGB);
    private volatile boolean fullscreen, running = true;
    private Game game;

    void start() {
        canvas.setPreferredSize(new Dimension(1280, 720));
        canvas.setBackground(Color.BLACK);
        canvas.setIgnoreRepaint(true);
        canvas.setFocusTraversalKeysEnabled(false);
        canvas.addKeyListener(input);
        canvas.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                if (e.getKeyCode() == KeyEvent.VK_F11 || (e.getKeyCode() == KeyEvent.VK_ENTER && e.isAltDown())) toggleFullscreen();
            }
        });
        frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                running = false;
                System.exit(0);
            }
        });
        frame.add(canvas);
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        canvas.requestFocus();
        game = new Game(input);
        Thread loop = new Thread(this::loop, "game-loop");
        loop.start();
    }

    private void toggleFullscreen() {
        fullscreen = !fullscreen;
        GraphicsDevice dev = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
        frame.dispose();
        frame.setUndecorated(fullscreen);
        if (fullscreen) {
            frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
            try { dev.setFullScreenWindow(frame); } catch (Exception ignored) { }
        } else {
            try { dev.setFullScreenWindow(null); } catch (Exception ignored) { }
            frame.setExtendedState(JFrame.NORMAL);
            frame.pack();
            frame.setLocationRelativeTo(null);
        }
        frame.setVisible(true);
        canvas.requestFocus();
    }

    private void loop() {
        final double step = 1 / 120.0;
        long last = System.nanoTime();
        double acc = 0;
        while (running) {
            long now = System.nanoTime();
            acc += Math.min(0.1, (now - last) / 1e9);
            last = now;
            while (acc >= step) {
                game.update(step);
                acc -= step;
            }
            Graphics2D g = back.createGraphics();
            game.render(g, back);
            g.dispose();
            present();
            long spent = System.nanoTime() - now;
            long wait = (long) (1e9 / 120) - spent;
            if (wait > 0) {
                try { Thread.sleep(wait / 1_000_000, (int) (wait % 1_000_000)); } catch (InterruptedException e) { return; }
            }
        }
    }

    private void present() {
        if (!canvas.isDisplayable()) return;
        BufferStrategy bs = canvas.getBufferStrategy();
        if (bs == null) {
            try { canvas.createBufferStrategy(2); } catch (Exception e) { return; }
            return;
        }
        try {
            do {
                do {
                    Graphics2D g = (Graphics2D) bs.getDrawGraphics();
                    int cw = canvas.getWidth(), ch = canvas.getHeight();
                    double s = Math.min(cw / (double) U.W, ch / (double) U.H);
                    int w = (int) (U.W * s), h = (int) (U.H * s);
                    int ox = (cw - w) / 2, oy = (ch - h) / 2;
                    g.setColor(Color.BLACK);
                    if (ox > 0) { g.fillRect(0, 0, ox, ch); g.fillRect(ox + w, 0, cw - ox - w, ch); }
                    if (oy > 0) { g.fillRect(0, 0, cw, oy); g.fillRect(0, oy + h, cw, ch - oy - h); }
                    g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
                    g.drawImage(back, ox, oy, w, h, null);
                    g.dispose();
                } while (bs.contentsRestored());
                bs.show();
            } while (bs.contentsLost());
            Toolkit.getDefaultToolkit().sync();
        } catch (IllegalStateException e) {
            // janela sendo recriada (tela cheia)
        }
    }
}

/** Modo de teste: roda o jogo sem janela e salva capturas de tela. */
final class Shots {
    private Shots() {}

    static void run(File dir) throws Exception {
        dir.mkdirs();
        System.setProperty("user.home", dir.getAbsolutePath());
        Sound.disable();
        Input in = new Input();
        Game g = new Game(in);
        BufferedImage img = new BufferedImage(U.W, U.H, BufferedImage.TYPE_INT_RGB);
        step(g, 2.0);
        shot(g, img, new File(dir, "00_titulo.png"));
        g.newGame();
        step(g, 1.0);
        shot(g, img, new File(dir, "01_inicio.png"));
        hold(g, in, KeyEvent.VK_RIGHT, 1.2);
        in.set(KeyEvent.VK_Z, true);
        step(g, 0.15);
        in.set(KeyEvent.VK_X, true);
        step(g, 0.05);
        shot(g, img, new File(dir, "02_pulo_ataque.png"));
        in.clear();
        hold(g, in, KeyEvent.VK_RIGHT, 2.5);
        shot(g, img, new File(dir, "03_caverna.png"));
        String[][] rooms = {{"r2", "1"}, {"r3", "2"}, {"r4", "1"}, {"r5", "1"}};
        g.player.hasDash = true;
        g.player.hasWings = true;
        int i = 4;
        for (String[] r : rooms) {
            teleport(g, r[0], r[1].charAt(0));
            step(g, 1.5);
            shot(g, img, new File(dir, String.format("%02d_%s.png", i++, r[0])));
        }
        // entrar na arena do chefe
        hold(g, in, KeyEvent.VK_RIGHT, 1.6);
        step(g, 2.0);
        hold(g, in, KeyEvent.VK_RIGHT, 0.9);
        step(g, 0.6);
        shot(g, img, new File(dir, String.format("%02d_chefe.png", i++)));
        for (int k = 0; k < 40; k++) {
            in.set(KeyEvent.VK_X, true);
            step(g, 0.1);
            in.set(KeyEvent.VK_X, false);
            step(g, 0.1);
            if (g.st == Game.St.DEAD) break;
        }
        shot(g, img, new File(dir, String.format("%02d_luta.png", i++)));
        System.out.println("estado final: " + g.st + " hp=" + g.player.hp + " geo=" + g.player.geo
                + " sala=" + g.room.def.id + (g.boss != null ? " chefe hp=" + g.boss.hp : ""));
    }

    private static void teleport(Game g, String room, char door) throws Exception {
        java.lang.reflect.Method m = Game.class.getDeclaredMethod("loadRoom", String.class);
        m.setAccessible(true);
        m.invoke(g, room);
        java.lang.reflect.Method p = Game.class.getDeclaredMethod("placeAtDoor", char.class, int.class);
        p.setAccessible(true);
        p.invoke(g, door, 1);
        java.lang.reflect.Method s = Game.class.getDeclaredMethod("snapCamera");
        s.setAccessible(true);
        s.invoke(g);
    }

    private static void hold(Game g, Input in, int key, double sec) {
        in.set(key, true);
        step(g, sec);
        in.set(key, false);
    }

    private static void step(Game g, double sec) {
        for (int i = 0; i < sec * 120; i++) g.update(1 / 120.0);
    }

    private static void shot(Game g, BufferedImage img, File f) throws Exception {
        long t0 = System.nanoTime();
        Graphics2D gr = img.createGraphics();
        g.render(gr, img);
        gr.dispose();
        long ms = (System.nanoTime() - t0) / 1_000_000;
        ImageIO.write(img, "png", f);
        System.out.println(f.getName() + "  (render " + ms + " ms)");
    }
}
