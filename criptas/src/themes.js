// Temas de cada andar: blocos, luz e inimigos.
export const THEMES = {
  catacumbas: {
    name: 'Catacumbas Esquecidas',
    walls: [['brick', 5], ['brick_mossy', 3], ['brick_cracked', 2], ['bone_wall', 1]],
    floor: [['flagstone', 6], ['cobble', 2]],
    corridor: 'cobble', raised: 'polished', cap: 'slate', pillar: 'brick', foundation: 'brick',
    pool: 'pit', bridge: 'planks',
    fog: 0x07080c, hemiSky: 0x5f6f94, hemiGround: 0x1b1612, hemi: 0.55,
    moon: 0x8fa3d6, moonI: 0.9, torch: 0xff9a4a,
    enemies: [['carnical', 6], ['esqueleto', 4], ['aranha', 1], ['necromante', 1]],
    boss: 'gorran', props: ['bones', 'bones', 'skull', 'cobweb', 'candles', 'pot', 'pot', 'barrel', 'banner', 'rubble', 'coffin'],
  },
  minas: {
    name: 'Minas de Ferro Negro',
    walls: [['stone', 6], ['stone_ore', 2]],
    floor: [['dirt', 5], ['gravel', 3]],
    corridor: 'gravel', raised: 'planks', cap: 'stone', pillar: 'log_side', foundation: 'stone',
    pool: 'water', bridge: 'planks',
    fog: 0x07090a, hemiSky: 0x6b7a78, hemiGround: 0x1d1810, hemi: 0.5,
    moon: 0x9fb4c0, moonI: 0.75, torch: 0xffb060,
    enemies: [['aranha', 5], ['carnical', 3], ['esporo', 3], ['esqueleto', 2]],
    boss: 'veshkara', props: ['crate', 'crate', 'barrel', 'barrel', 'beam', 'crystal', 'crystal', 'rubble', 'pot', 'cart', 'cobweb'],
  },
  forja: {
    name: 'Forja Profunda',
    walls: [['darkbrick', 5], ['basalt', 3], ['obsidian', 1]],
    floor: [['basalt', 5], ['basalt_glow', 1]],
    corridor: 'basalt', raised: 'obsidian', cap: 'obsidian', pillar: 'darkbrick', foundation: 'basalt',
    pool: 'lava', bridge: 'basalt',
    fog: 0x0c0706, hemiSky: 0x7a5a50, hemiGround: 0x1a0c08, hemi: 0.45,
    moon: 0xd09070, moonI: 0.55, torch: 0xff7a30,
    enemies: [['esqueleto', 4], ['esporo', 3], ['necromante', 2], ['carnical', 3]],
    boss: 'colosso', props: ['anvil', 'barrel', 'crate', 'rubble', 'rubble', 'banner', 'pot', 'chains'],
  },
};
export const THEME_ORDER = ['catacumbas', 'minas', 'forja'];
export const themeFor = (floor) => THEME_ORDER[(floor - 1) % 3];
