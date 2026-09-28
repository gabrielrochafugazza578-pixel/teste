package abismo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Definicao estatica de uma sala: mapa, tema, ligacoes e dicas. */
final class RoomDef {
    final String id, area;
    final Theme theme;
    final String[] map;
    final Map<Character, String[]> links = new HashMap<>();
    final List<Object[]> hints = new ArrayList<>();

    RoomDef(String id, String area, Theme theme, String[] map) {
        this.id = id;
        this.area = area;
        this.theme = theme;
        this.map = map;
    }

    RoomDef link(char door, String room, char targetDoor) {
        links.put(door, new String[]{room, String.valueOf(targetDoor)});
        return this;
    }

    RoomDef hint(double tx, double ty, String text) {
        hints.add(new Object[]{tx, ty, text});
        return this;
    }
}

/** O mapa do mundo: todas as salas e como se conectam. */
final class World {
    private World() {}

    static final Map<String, RoomDef> DEFS = new LinkedHashMap<>();

    static final String START_ROOM = "r1";

    static {
        add(new RoomDef("r1", "Cavernas Sussurrantes", Theme.CAVERNS, Maps.R1)
                .link('1', "r2", '1')
                .hint(12, 12.6, "← →  mover      Z / Espaço  pular (segure para ir mais alto)")
                .hint(23, 16.2, "X  atacar      ↑ + X  golpe para cima      ↓ + X no ar  golpe para baixo")
                .hint(28.5, 18.4, "Golpeie os espinhos para baixo para quicar neles")
                .hint(45, 13.8, "Acertar inimigos enche sua ALMA  ·  segure F para curar  ·  V lança um feitiço"));
        add(new RoomDef("r2", "Cavernas Sussurrantes", Theme.CAVERNS, Maps.R2)
                .link('1', "r1", '1').link('2', "r3", '2').link('3', "r4", '1')
                .hint(61, 26, "Largo demais para um salto comum..."));
        add(new RoomDef("r3", "Jardim Musgoso", Theme.GARDEN, Maps.R3)
                .link('2', "r2", '2'));
        add(new RoomDef("r4", "Abismo Silencioso", Theme.ABYSS, Maps.R4)
                .link('1', "r2", '3').link('2', "r5", '1'));
        add(new RoomDef("r5", "Trono do Guardião", Theme.ARENA, Maps.R5)
                .link('1', "r4", '2'));
    }

    private static void add(RoomDef d) { DEFS.put(d.id, d); }

    private static final Map<String, Room> CACHE = new HashMap<>();

    /** Carrega (e guarda em cache) a sala com toda a arte pre-renderizada. */
    static synchronized Room room(String id) {
        return CACHE.computeIfAbsent(id, k -> {
            Room r = new Room(DEFS.get(k));
            r.buildArt();
            return r;
        });
    }

    /** Pre-gera a arte de todas as salas em segundo plano. */
    static void preloadAsync() {
        Thread t = new Thread(() -> {
            for (String id : DEFS.keySet()) room(id);
        }, "preload");
        t.setDaemon(true);
        t.setPriority(Thread.MIN_PRIORITY);
        t.start();
    }
}
