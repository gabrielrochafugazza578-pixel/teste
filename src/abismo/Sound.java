package abismo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.SourceDataLine;

/** Efeitos sonoros e musica totalmente sintetizados (sem arquivos externos). */
final class Sound {
    private Sound() {}

    static final int RATE = 44100;
    private static final Map<String, float[]> SFX = new HashMap<>();
    private static final Map<String, float[]> MUSIC = new HashMap<>();
    private static final List<Voice> VOICES = new ArrayList<>();
    private static volatile boolean enabled = true;
    private static volatile String wantedMusic = null;
    private static Voice musicVoice, fadingVoice;
    private static final Random R = new Random(7);

    /** Uma voz tocando no mixer. */
    private static final class Voice {
        final float[] data;
        final boolean loop;
        final float vol;
        int pos;
        float fade = 1, fadeStep;

        Voice(float[] data, float vol, boolean loop) {
            this.data = data;
            this.vol = vol;
            this.loop = loop;
        }
    }

    static void disable() { enabled = false; }

    static void init() {
        if (!enabled) return;
        Thread t = new Thread(Sound::run, "audio");
        t.setDaemon(true);
        t.start();
    }

    /** Thread de audio: gera os sons e mistura tudo numa unica linha de saida. */
    private static void run() {
        SourceDataLine line;
        try {
            AudioFormat fmt = new AudioFormat(RATE, 16, 1, true, false);
            line = AudioSystem.getSourceDataLine(fmt);
            line.open(fmt, 4096 * 2);
            line.start();
        } catch (Throwable t) {
            enabled = false;
            System.err.println("[audio] desativado: " + t.getMessage());
            return;
        }
        try {
            SFX.put("slash", slash());
            SFX.put("hit", scaled(hit(), 0.6));
            SFX.put("hurt", scaled(hurt(), 0.75));
            SFX.put("jump", jump());
            SFX.put("wings", wings());
            SFX.put("dash", dash());
            SFX.put("land", land());
            SFX.put("geo", geo());
            SFX.put("die", enemyDie());
            SFX.put("spell", spell());
            SFX.put("heal", heal());
            SFX.put("bench", bench());
            SFX.put("pickup", pickup());
            SFX.put("roar", roar());
            SFX.put("slam", scaled(slam(), 0.65));
            SFX.put("shoot", shoot());
            SFX.put("break", scaled(rockBreak(), 0.55));
            SFX.put("menu", menu());
            SFX.put("tink", tink());
        } catch (Throwable t) {
            enabled = false;
            return;
        }
        // musica e gerada em outra thread para nao atrasar os efeitos
        Thread gen = new Thread(() -> {
            float[] amb = ambientMusic();
            synchronized (VOICES) { MUSIC.put("ambient", amb); }
            float[] boss = bossMusic();
            synchronized (VOICES) { MUSIC.put("boss", boss); }
        }, "music-gen");
        gen.setDaemon(true);
        gen.start();

        final int frames = 512;
        float[] mix = new float[frames];
        byte[] out = new byte[frames * 2];
        String playing = null;
        while (true) {
            java.util.Arrays.fill(mix, 0);
            synchronized (VOICES) {
                String want = wantedMusic;
                if (want != null && !want.equals(playing) && MUSIC.containsKey(want)) {
                    if (musicVoice != null) {
                        fadingVoice = musicVoice;
                        fadingVoice.fadeStep = -1f / (RATE * 0.8f);
                        VOICES.add(fadingVoice);
                    }
                    musicVoice = new Voice(MUSIC.get(want), want.equals("boss") ? 0.5f : 0.45f, true);
                    musicVoice.fade = 0;
                    musicVoice.fadeStep = 1f / (RATE * 1.2f);
                    playing = want;
                }
                if (musicVoice != null) mixVoice(musicVoice, mix, frames);
                for (int k = VOICES.size() - 1; k >= 0; k--) {
                    Voice v = VOICES.get(k);
                    if (!mixVoice(v, mix, frames)) VOICES.remove(k);
                }
            }
            for (int i = 0; i < frames; i++) {
                int sv = (int) (Math.tanh(mix[i] * 1.1) * 30000);
                out[i * 2] = (byte) sv;
                out[i * 2 + 1] = (byte) (sv >> 8);
            }
            line.write(out, 0, out.length);
        }
    }

    /** Mistura uma voz no buffer; devolve false quando terminou. */
    private static boolean mixVoice(Voice v, float[] mix, int frames) {
        for (int i = 0; i < frames; i++) {
            if (v.pos >= v.data.length) {
                if (!v.loop) return false;
                v.pos = 0;
            }
            if (v.fadeStep != 0) {
                v.fade += v.fadeStep;
                if (v.fade >= 1) { v.fade = 1; v.fadeStep = 0; }
                if (v.fade <= 0) return false;
            }
            mix[i] += v.data[v.pos++] * v.vol * v.fade;
        }
        return true;
    }

    static void play(String name) {
        if (!enabled) return;
        synchronized (VOICES) {
            float[] d = SFX.get(name);
            if (d == null) return;
            if (VOICES.size() > 24) VOICES.remove(0);
            VOICES.add(new Voice(d, 0.8f, false));
        }
    }

    private static float[] scaled(float[] d, double k) {
        for (int i = 0; i < d.length; i++) d[i] *= (float) k;
        return d;
    }

    static void music(String name) {
        wantedMusic = name;
    }

    // ------------------------------------------------------------------ sintese

    private static float[] buf(double sec) { return new float[(int) (RATE * sec)]; }
    private static double noise() { return R.nextDouble() * 2 - 1; }
    private static double env(double t, double atk, double decay) { return Math.min(1, t / atk) * Math.exp(-t * decay); }

    private static float[] slash() {
        float[] o = buf(0.2);
        double lp = 0, lp2 = 0, ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            double cut = 0.08 + 0.55 * Math.exp(-t * 18);
            double x = noise();
            lp += cut * (x - lp);
            lp2 += 0.02 * (lp - lp2);
            ph += 2 * Math.PI * (3200 - 6000 * t) / RATE;
            o[i] = (float) ((lp - lp2) * env(t, 0.006, 22) * 0.9 + Math.sin(ph) * 0.06 * Math.exp(-t * 35));
        }
        return o;
    }

    private static float[] hit() {
        float[] o = buf(0.2);
        double lp = 0, ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.25 * (noise() - lp);
            ph += 2 * Math.PI * (220 * Math.exp(-t * 12) + 50) / RATE;
            o[i] = (float) (lp * env(t, 0.002, 30) * 1.1 + Math.sin(ph) * env(t, 0.002, 14) * 0.9);
        }
        return o;
    }

    private static float[] hurt() {
        float[] o = buf(0.6);
        double lp = 0, ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.15 * (noise() - lp);
            ph += 2 * Math.PI * (320 * Math.exp(-t * 5) + 45) / RATE;
            double s = Math.sin(ph) + 0.4 * Math.sin(ph * 2.01);
            o[i] = (float) (Math.tanh(s * 2.5) * env(t, 0.003, 6) * 0.7 + lp * env(t, 0.001, 12) * 1.2);
        }
        return o;
    }

    private static float[] jump() {
        float[] o = buf(0.14);
        double lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += (0.05 + t * 2) * (noise() - lp);
            o[i] = (float) (lp * env(t, 0.01, 25) * 0.5);
        }
        return o;
    }

    private static float[] wings() {
        float[] o = buf(0.3);
        double lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.12 * (noise() - lp);
            double e = env(t, 0.01, 18) + 0.7 * env(Math.max(0, t - 0.1), 0.01, 18) * (t > 0.1 ? 1 : 0);
            o[i] = (float) (lp * e * 0.9);
        }
        return o;
    }

    private static float[] dash() {
        float[] o = buf(0.3);
        double lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            double cut = 0.04 + 0.3 * Math.sin(Math.PI * Math.min(1, t / 0.25));
            lp += cut * (noise() - lp);
            o[i] = (float) (lp * Math.sin(Math.PI * Math.min(1, t / 0.3)) * 0.9);
        }
        return o;
    }

    private static float[] land() {
        float[] o = buf(0.12);
        double lp = 0, ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.08 * (noise() - lp);
            ph += 2 * Math.PI * (110 - 400 * t) / RATE;
            o[i] = (float) ((lp * 0.8 + Math.sin(ph) * 0.4) * env(t, 0.002, 40));
        }
        return o;
    }

    private static float[] geo() {
        float[] o = buf(0.35);
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            double a = Math.sin(2 * Math.PI * 1760 * t) * env(t, 0.002, 14);
            double b = t > 0.05 ? Math.sin(2 * Math.PI * 2637 * t) * env(t - 0.05, 0.002, 12) : 0;
            o[i] = (float) ((a + b) * 0.28);
        }
        return o;
    }

    private static float[] enemyDie() {
        float[] o = buf(0.45);
        double lp = 0, ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.2 * (noise() - lp);
            ph += 2 * Math.PI * (380 * Math.exp(-t * 6) + 60 + 30 * Math.sin(t * 90)) / RATE;
            o[i] = (float) (lp * env(t, 0.002, 10) * 0.9 + Math.sin(ph) * env(t, 0.005, 7) * 0.5);
        }
        return o;
    }

    private static float[] spell() {
        float[] o = buf(0.7);
        double lp = 0, ph = 0, ph2 = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += (0.05 + 0.2 * Math.exp(-t * 4)) * (noise() - lp);
            ph += 2 * Math.PI * (700 * Math.exp(-t * 3) + 150) / RATE;
            ph2 += 2 * Math.PI * (1400 * Math.exp(-t * 2) + 300) / RATE;
            o[i] = (float) ((lp * 0.8 + Math.sin(ph) * 0.4 + Math.sin(ph2) * 0.15) * env(t, 0.01, 5));
        }
        return o;
    }

    private static float[] heal() {
        float[] o = buf(1.0);
        double[] notes = {523.25, 659.25, 783.99, 1046.5};
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE, s = 0;
            for (int k = 0; k < notes.length; k++) {
                double st = k * 0.08;
                if (t > st) s += Math.sin(2 * Math.PI * notes[k] * t) * env(t - st, 0.01, 4) * 0.22;
            }
            o[i] = (float) s;
        }
        return o;
    }

    private static float[] bench() {
        float[] o = buf(2.0);
        double[] notes = {220, 261.63, 329.63, 440};
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE, s = 0;
            for (int k = 0; k < notes.length; k++) {
                double st = k * 0.12;
                if (t > st) s += (Math.sin(2 * Math.PI * notes[k] * t) + 0.3 * Math.sin(4 * Math.PI * notes[k] * t)) * env(t - st, 0.02, 2.2) * 0.2;
            }
            o[i] = (float) s;
        }
        return o;
    }

    private static float[] pickup() {
        float[] o = buf(2.5);
        double[] notes = {440, 523.25, 659.25, 880, 1046.5, 1318.5};
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE, s = 0;
            for (int k = 0; k < notes.length; k++) {
                double st = k * 0.11;
                if (t > st) s += (Math.sin(2 * Math.PI * notes[k] * t) + 0.25 * Math.sin(2 * Math.PI * notes[k] * 2.001 * t)) * env(t - st, 0.01, 1.8) * 0.17;
            }
            o[i] = (float) s;
        }
        return reverb(o, 0.4);
    }

    private static float[] roar() {
        float[] o = buf(1.4);
        double ph = 0, lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            ph += 2 * Math.PI * (80 + 25 * Math.sin(t * 30) - 20 * t) / RATE;
            double saw = ((ph / (2 * Math.PI)) % 1) * 2 - 1;
            lp += 0.1 * (saw * 0.8 + noise() * 0.5 - lp);
            o[i] = (float) (Math.tanh(lp * 3) * env(t, 0.08, 2.2) * 0.8);
        }
        return o;
    }

    private static float[] slam() {
        float[] o = buf(0.9);
        double ph = 0, lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            ph += 2 * Math.PI * (70 * Math.exp(-t * 4) + 28) / RATE;
            lp += 0.06 * (noise() - lp);
            o[i] = (float) ((Math.sin(ph) * 1.2 + lp * 1.5) * env(t, 0.002, 5));
        }
        return o;
    }

    private static float[] shoot() {
        float[] o = buf(0.25);
        double ph = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            ph += 2 * Math.PI * (300 - 600 * t + 40 * Math.sin(t * 120)) / RATE;
            o[i] = (float) (Math.sin(ph) * env(t, 0.005, 14) * 0.6);
        }
        return o;
    }

    private static float[] rockBreak() {
        float[] o = buf(0.25);
        double lp = 0;
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            lp += 0.35 * (noise() - lp);
            double crackle = R.nextDouble() < 0.02 ? noise() * 2 : 0;
            o[i] = (float) ((lp + crackle) * env(t, 0.001, 18) * 0.9);
        }
        return o;
    }

    private static float[] menu() {
        float[] o = buf(0.1);
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            o[i] = (float) (Math.sin(2 * Math.PI * 880 * t) * env(t, 0.002, 45) * 0.3);
        }
        return o;
    }

    private static float[] tink() {
        float[] o = buf(0.2);
        for (int i = 0; i < o.length; i++) {
            double t = i / (double) RATE;
            o[i] = (float) ((Math.sin(2 * Math.PI * 2400 * t) + 0.5 * Math.sin(2 * Math.PI * 3700 * t)) * env(t, 0.001, 30) * 0.3);
        }
        return o;
    }

    // ------------------------------------------------------------------ musica

    private static double midi(double n) { return 440 * Math.pow(2, (n - 69) / 12.0); }

    private static float[] ambientMusic() {
        double chordLen = 4.0;
        int[][] chords = {{57, 60, 64}, {53, 57, 60}, {48, 52, 55}, {55, 59, 62}, {57, 60, 64}, {53, 57, 60}, {50, 53, 57}, {52, 56, 59}};
        double total = chordLen * chords.length;
        float[] o = buf(total);
        int n = o.length;
        for (int c = 0; c < chords.length; c++) {
            double st = c * chordLen;
            for (int note : chords[c]) {
                double f = midi(note - 12);
                addPad(o, st - 1.0, chordLen + 2.0, f, 0.09, total);
            }
            addPad(o, st - 1.0, chordLen + 2.0, midi(chords[c][0] - 24), 0.1, total);
        }
        // caixinha de musica esparsa
        int[] scale = {69, 72, 74, 76, 79, 81, 84};
        Random rr = new Random(3);
        for (double t = 0.5; t < total - 0.5; t += 0.55 + rr.nextDouble() * 0.9) {
            if (rr.nextDouble() < 0.35) continue;
            double f = midi(scale[rr.nextInt(scale.length)]);
            int s0 = (int) (t * RATE);
            for (int i = 0; i < RATE * 2.5; i++) {
                double tt = i / (double) RATE;
                double v = (Math.sin(2 * Math.PI * f * tt) + 0.15 * Math.sin(2 * Math.PI * f * 3 * tt)) * env(tt, 0.004, 2.2) * 0.07;
                o[(s0 + i) % n] += (float) v;
            }
        }
        return reverb(o, 0.55);
    }

    private static void addPad(float[] o, double start, double len, double f, double amp, double total) {
        int n = o.length;
        double ph1 = 0, ph2 = 0, ph3 = 0;
        int count = (int) (len * RATE);
        for (int i = 0; i < count; i++) {
            double t = i / (double) RATE;
            double e = Math.min(1, t / 1.4) * Math.min(1, (len - t) / 1.6);
            ph1 += 2 * Math.PI * f * 1.003 / RATE;
            ph2 += 2 * Math.PI * f * 0.997 / RATE;
            ph3 += 2 * Math.PI * f * 2 / RATE;
            double v = (Math.sin(ph1) + Math.sin(ph2) + 0.2 * Math.sin(ph3)) * 0.5 * e * amp;
            int idx = (int) ((start * RATE + i) % n);
            if (idx < 0) idx += n;
            o[idx] += (float) v;
        }
    }

    private static float[] bossMusic() {
        double bpm = 124, beat = 60 / bpm;
        int bars = 8;
        double total = bars * 4 * beat;
        float[] o = buf(total);
        int n = o.length;
        int[] bass = {38, 38, 41, 38, 40, 38, 36, 37};
        int[][] chordsPerBar = {{50, 53, 57}, {50, 53, 57}, {46, 50, 53}, {48, 52, 55}, {50, 53, 57}, {50, 53, 57}, {46, 50, 53}, {45, 49, 52}};
        for (int b = 0; b < bars; b++) {
            for (int e8 = 0; e8 < 8; e8++) {
                double t0 = (b * 4 + e8 * 0.5) * beat;
                int note = bass[e8] + (b >= 6 ? -2 : 0) + ((b % 4 == 2) ? -4 : 0);
                double f = midi(note);
                double ph = 0, lp = 0;
                for (int i = 0; i < beat * 0.5 * RATE; i++) {
                    double t = i / (double) RATE;
                    ph += f / RATE;
                    double saw = (ph % 1) * 2 - 1;
                    lp += 0.08 * (saw - lp);
                    o[(int) (t0 * RATE + i) % n] += (float) (lp * env(t, 0.005, 6) * 0.35);
                }
            }
            // tambores
            for (int q = 0; q < 4; q++) {
                double t0 = (b * 4 + q) * beat;
                boolean strong = q == 0 || q == 2;
                drum(o, t0, strong ? 0.9 : 0.45, strong ? 65 : 90);
                if (q == 3 && b % 2 == 1) drum(o, t0 + beat * 0.5, 0.6, 80);
            }
            // cordas
            for (int note : chordsPerBar[b]) {
                double f = midi(note + 12);
                double ph1 = 0, ph2 = 0;
                double len = 4 * beat;
                for (int i = 0; i < len * RATE; i++) {
                    double t = i / (double) RATE;
                    ph1 += f * 1.004 / RATE;
                    ph2 += f * 0.996 / RATE;
                    double saw = ((ph1 % 1) + (ph2 % 1)) - 1;
                    double e = Math.min(1, t / 0.08) * (0.55 + 0.45 * Math.exp(-t * 3)) * Math.min(1, (len - t) / 0.1);
                    o[(int) ((b * 4 * beat) * RATE + i) % n] += (float) (saw * e * 0.05);
                }
            }
        }
        return reverb(o, 0.3);
    }

    private static void drum(float[] o, double t0, double amp, double f0) {
        double ph = 0, lp = 0;
        int n = o.length;
        for (int i = 0; i < RATE * 0.5; i++) {
            double t = i / (double) RATE;
            ph += 2 * Math.PI * (f0 * Math.exp(-t * 8) + 38) / RATE;
            lp += 0.1 * (noise() - lp);
            o[(int) (t0 * RATE + i) % n] += (float) ((Math.sin(ph) + lp * 0.6) * env(t, 0.002, 9) * amp * 0.8);
        }
    }

    /** Reverb simples (Schroeder) com cauda circular para loops perfeitos. */
    private static float[] reverb(float[] in, double mix) {
        int n = in.length;
        int[] combs = {1557, 1617, 1491, 1422};
        int[] aps = {225, 556};
        float[] wet = new float[n];
        float[][] cb = new float[combs.length][];
        for (int k = 0; k < combs.length; k++) cb[k] = new float[combs[k] * 2];
        int[] ci = new int[combs.length];
        for (int pass = 0; pass < 2; pass++) {
            for (int i = 0; i < n; i++) {
                double s = 0;
                for (int k = 0; k < combs.length; k++) {
                    float[] b = cb[k];
                    float y = b[ci[k]];
                    b[ci[k]] = (float) (in[i] + y * 0.84);
                    ci[k] = (ci[k] + 1) % b.length;
                    s += y;
                }
                if (pass == 1) wet[i] = (float) (s * 0.25);
            }
        }
        for (int d : aps) {
            float[] b = new float[d];
            int bi = 0;
            for (int i = 0; i < n; i++) {
                float y = b[bi];
                float x = wet[i];
                b[bi] = (float) (x + y * 0.5);
                wet[i] = (float) (y - x * 0.5);
                bi = (bi + 1) % d;
            }
        }
        float[] out = new float[n];
        for (int i = 0; i < n; i++) out[i] = (float) (in[i] * (1 - mix * 0.5) + wet[i] * mix);
        return out;
    }
}
