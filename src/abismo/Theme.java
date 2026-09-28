package abismo;

import java.awt.Color;

/** Paleta visual de cada area do mundo. */
final class Theme {
    final String key;
    final Color sky1, sky2, fog, rock, rockDark, rim, accent, light;
    final int darkness; // opacidade da escuridao ambiente (0-255)

    private Theme(String key, int sky1, int sky2, int fog, int rock, int rockDark, int rim, int accent, int light, int darkness) {
        this.key = key;
        this.sky1 = U.rgb(sky1);
        this.sky2 = U.rgb(sky2);
        this.fog = U.rgb(fog);
        this.rock = U.rgb(rock);
        this.rockDark = U.rgb(rockDark);
        this.rim = U.rgb(rim);
        this.accent = U.rgb(accent);
        this.light = U.rgb(light);
        this.darkness = darkness;
    }

    static final Theme CAVERNS = new Theme("caverns", 0x0a1322, 0x1d2d44, 0x456080, 0x273244, 0x080b12, 0xb4c8e2, 0x9fd8ff, 0xd5e9ff, 150);
    static final Theme GARDEN = new Theme("garden", 0x05140e, 0x10382a, 0x357058, 0x1c3a2b, 0x050e09, 0x96dca0, 0xbfff9e, 0xe4ffd2, 145);
    static final Theme ABYSS = new Theme("abyss", 0x06040c, 0x170e2c, 0x3c2c60, 0x221a38, 0x06040b, 0xa894dc, 0xd6b8ff, 0xe8dcff, 175);
    static final Theme ARENA = new Theme("arena", 0x100706, 0x2c130e, 0x643223, 0x33211b, 0x0c0605, 0xe6a878, 0xffb070, 0xffdcb4, 160);
}
