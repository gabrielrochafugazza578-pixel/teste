package abismo;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

/** Salvamento simples em ~/.ecos-do-abismo/save.properties */
final class Save {
    String benchRoom = World.START_ROOM;
    int benchX = -1, benchY = -1;
    int geo, maxHp = 5;
    boolean hasDash, hasWings, bossDead;
    double playTime;

    static File file() {
        return new File(System.getProperty("user.home"), ".ecos-do-abismo" + File.separator + "save.properties");
    }

    static boolean exists() { return file().isFile(); }

    static Save load() {
        Save s = new Save();
        try (InputStream in = new FileInputStream(file())) {
            Properties p = new Properties();
            p.load(in);
            s.benchRoom = p.getProperty("benchRoom", World.START_ROOM);
            if (!World.DEFS.containsKey(s.benchRoom)) s.benchRoom = World.START_ROOM;
            s.benchX = Integer.parseInt(p.getProperty("benchX", "-1"));
            s.benchY = Integer.parseInt(p.getProperty("benchY", "-1"));
            s.geo = Integer.parseInt(p.getProperty("geo", "0"));
            s.maxHp = Integer.parseInt(p.getProperty("maxHp", "5"));
            s.hasDash = Boolean.parseBoolean(p.getProperty("hasDash", "false"));
            s.hasWings = Boolean.parseBoolean(p.getProperty("hasWings", "false"));
            s.bossDead = Boolean.parseBoolean(p.getProperty("bossDead", "false"));
            s.playTime = Double.parseDouble(p.getProperty("playTime", "0"));
        } catch (Exception e) {
            return new Save();
        }
        return s;
    }

    void write() {
        try {
            File f = file();
            f.getParentFile().mkdirs();
            Properties p = new Properties();
            p.setProperty("benchRoom", benchRoom);
            p.setProperty("benchX", String.valueOf(benchX));
            p.setProperty("benchY", String.valueOf(benchY));
            p.setProperty("geo", String.valueOf(geo));
            p.setProperty("maxHp", String.valueOf(maxHp));
            p.setProperty("hasDash", String.valueOf(hasDash));
            p.setProperty("hasWings", String.valueOf(hasWings));
            p.setProperty("bossDead", String.valueOf(bossDead));
            p.setProperty("playTime", String.valueOf(playTime));
            try (OutputStream out = new FileOutputStream(f)) {
                p.store(out, "Ecos do Abismo - save");
            }
        } catch (Exception e) {
            System.err.println("Nao foi possivel salvar: " + e.getMessage());
        }
    }
}
