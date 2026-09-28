package abismo;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

/** Teclado: estado das teclas e deteccao de "acabou de apertar". */
final class Input implements KeyListener {
    private final boolean[] down = new boolean[1024];
    private final boolean[] pressed = new boolean[1024];

    @Override
    public synchronized void keyPressed(KeyEvent e) {
        int c = e.getKeyCode();
        if (c < 0 || c >= down.length) return;
        if (!down[c]) pressed[c] = true;
        down[c] = true;
    }

    @Override
    public synchronized void keyReleased(KeyEvent e) {
        int c = e.getKeyCode();
        if (c >= 0 && c < down.length) down[c] = false;
    }

    @Override
    public void keyTyped(KeyEvent e) {}

    /** Usado pelo modo de teste automatico. */
    synchronized void set(int code, boolean isDown) {
        if (isDown && !down[code]) pressed[code] = true;
        down[code] = isDown;
    }

    synchronized boolean isDown(int... codes) {
        for (int c : codes) if (down[c]) return true;
        return false;
    }

    synchronized boolean wasPressed(int... codes) {
        for (int c : codes) if (pressed[c]) return true;
        return false;
    }

    synchronized void endFrame() { java.util.Arrays.fill(pressed, false); }

    synchronized void clear() {
        java.util.Arrays.fill(pressed, false);
        java.util.Arrays.fill(down, false);
    }

    boolean left() { return isDown(KeyEvent.VK_LEFT, KeyEvent.VK_A); }
    boolean right() { return isDown(KeyEvent.VK_RIGHT, KeyEvent.VK_D); }
    boolean up() { return isDown(KeyEvent.VK_UP, KeyEvent.VK_W); }
    boolean downKey() { return isDown(KeyEvent.VK_DOWN, KeyEvent.VK_S); }
    boolean upPressed() { return wasPressed(KeyEvent.VK_UP, KeyEvent.VK_W); }
    boolean downPressed() { return wasPressed(KeyEvent.VK_DOWN, KeyEvent.VK_S); }
    boolean jumpHeld() { return isDown(KeyEvent.VK_Z, KeyEvent.VK_SPACE); }
    boolean jump() { return wasPressed(KeyEvent.VK_Z, KeyEvent.VK_SPACE); }
    boolean attack() { return wasPressed(KeyEvent.VK_X, KeyEvent.VK_J); }
    boolean dash() { return wasPressed(KeyEvent.VK_C, KeyEvent.VK_K, KeyEvent.VK_SHIFT); }
    boolean spell() { return wasPressed(KeyEvent.VK_V, KeyEvent.VK_L); }
    boolean focusHeld() { return isDown(KeyEvent.VK_F, KeyEvent.VK_Q); }
    boolean pause() { return wasPressed(KeyEvent.VK_ESCAPE, KeyEvent.VK_P); }
    boolean confirm() { return wasPressed(KeyEvent.VK_ENTER, KeyEvent.VK_SPACE, KeyEvent.VK_Z, KeyEvent.VK_X, KeyEvent.VK_J); }
    boolean anyAction() { return confirm() || jump() || attack() || left() || right() || downPressed(); }
}
