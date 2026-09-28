# O INÍCIO DO FIM

Survival horror de mundo aberto em 3D feito em **Godot 4.7.2 (renderer Compatibility / OpenGL 3.3)**,
otimizado para **Intel i3-4130 + 16 GB RAM + GTX 750 Ti 2 GB** no Linux, com arquitetura pronta para Windows 10/11.

Santa Aurora. Uma terapia de regeneração celular — o **Projeto NEXUS**, da Corvalis Biotecnologia — deu errado.
Semanas depois do colapso, **Caio** volta pela serra procurando a mãe e a irmã. A **Dra. Helena Vasconcelos**
deixou gravações espalhadas pela cidade.

---

## Como rodar

```bash
# Linux (editor/runtime oficial 4.7.2)
godot --path .                      # boot → menu principal
godot --path . -- --skip-menu       # novo jogo direto (com a abertura)
godot --path . -- --skip-menu --skip-opening
godot --path . -- --load=auto       # carrega um slot
```

Primeira execução: o jogo **gera as texturas PBR na GPU** (Texture2DArray, 16 camadas) e **sintetiza os sons**
(cache em `user://`). A qualidade é detectada pelo nome da GPU (GTX 750 Ti → BAIXO).

### Controles (remapeáveis em Configurações → Controles)

| Ação | Teclado/mouse | Gamepad |
|---|---|---|
| Mover / correr / agachar | WASD / Shift / C | Analógico esq. / L3 / R3 |
| Pular, escalar, transpor | Espaço | A |
| Interagir (segurar = ações longas) | E | X |
| Atacar (segurar = pesado) / Defender, mirar | Mouse esq. / Mouse dir. | RT / LT |
| Esquivar / Empurrar / Arremessar distração | Q / F / G | B / RB / LB |
| Lanterna / Cura rápida / Atalhos | L / H / 1–4 | ↑ / ↓ |
| Inventário e fabricação / Mapa / Diário | Tab / M / J | Back |
| Pausa / Pular cinemática (segurar) | Esc / Enter | Start / Y |
| Salvar/carregar rápido / Painel de desempenho / Esconder HUD | F5 / F9 / F3 / F1 | |

---

## Desempenho (hardware alvo)

* **Compatibility renderer** (GL 3.3): sem Vulkan, roda na GTX 750 Ti e em iGPUs.
* **Resolução interna** (escala 3D 50–100 %) com upscaling bilinear + VSync; alvo 30 FPS a 720p/900p no BAIXO.
* **Predefinições**: MUITO BAIXO, BAIXO, MÉDIO, ALTO, ULTRA + ajuste individual (resolução, texturas, sombras,
  distância de visão/objetos, vegetação, partículas, pós, densidade de NPCs e infectados, clima, reflexos,
  MSAA, VSync, limite de FPS, FOV).
* **Texturas**: 2 `Texture2DArray` (albedo+rugosidade / normal+AO+metal) compartilhadas por todo o mundo;
  256–2048 px por camada (≈ 11–720 MB) — BAIXO usa 512 px ≈ 45 MB.
* **Draw calls**: cada chunk de 64 m é mesclado em poucas malhas com um único material; props repetidos em
  **MultiMesh**; vegetação/grama instanciada; *visibility ranges*; *occlusion culling* com `ArrayOccluder3D`.
  Medido: 100–230 draw calls, ~80 MB de VRAM na cidade.
* **Streaming**: anéis de LOD (0/1/2) por distância; geração em `WorkerThreadPool`; aplicação no main thread
  com orçamento em µs por quadro; interiores gerados sob demanda ao se aproximar.
* **Camada distante** (`FarLayer`): terreno do mapa inteiro a 32 m/célula + silhueta de todos os prédios num
  único MultiMesh (janelas procedurais que acompanham energia/apagão). Some onde o chunk real está carregado
  (máscara 48×48 de chunks lida no shader) — dá para ver a cidade da serra por ~2 draw calls.
* **LOD de simulação** (`SimScheduler`): perto = física + percepção 8 Hz + animação por quadro; médio =
  movimento cinemático 3 Hz; longe = interpolado 1 Hz; fora = população abstrata (dados). Orçamento de CPU
  por quadro, fatiamento de tempo, *pooling* de infectados, pathfinding limitado ao grafo viário (A*).
* **Eventos** em vez de consultas: ruído, missões, facções, clima, UI — tudo via `EventBus`.
* Painel **F3**: FPS, ms, draw calls, VRAM, chunks, agentes por tier, µs de IA e de streaming.

---

## Arquitetura (módulos)

```
scripts/
  core/        EventBus, Settings (presets), GameState, SimScheduler, ShaderGlobals, Assets (bake PBR), InputSetup, Util
  world/       WorldLayout (cidade/região), TerrainGen, BuildingGen, InteriorGen, PropLib, Vegetation,
               ChunkBuilder/Chunk/World (streaming), FarLayer (terreno/silhueta distantes),
               EnvironmentController (sol/lua/céu/neblina), Setor7
  world/interactables/  Door, LootContainer, ItemPickup, Station (cama/bancada/fogo/coletor/baú), StoryObject, FuelPump, Elevator
  character/   Appearance, HeadTemplate (cabeça/pescoço anatômicos via SDF), HumanoidMeshBuilder (malha skinned 18 ossos,
               1 draw call), AnimLibrary, ProceduralAnimator, HumanoidBody
  player/      Player (Caio), PlayerCamera
  survival/    Survival (fome, sede, energia, fôlego, temperatura, sangramento, fratura, dor, infecções, doenças, peso, moral)
  inventory/   ItemDB (≈130 itens), Inventory (peso + espaços)
  loot/        LootTables (loot contextual por local e móvel)
  crafting/    CraftingDB, Crafting (fabricação, culinária, reparos, melhorias), StructureManager, CanAlarm
  combat/      DamageInfo, Melee, WeaponMeshes, Projectile, FireArea
  infected/    InfectedTypes (Errante, Febril, Sentinela, Colosso, Rastejante, Hospedeiro), Infected, SporeCloud
  ai/          AIDirector (população por células, hordas, pooling), EventDirector (eventos emergentes)
  npc/         NPCDB, SurvivorNPC, SurvivorManager, DialogueDB, DialogueRunner, Trade, NPCTalk
  factions/    FactionManager (Remanescentes, Guarda Aurora, Despertos, Corvos do Rio, Segurança Corvalis)
  vehicles/    Vehicle (suspensão por raycast), VehicleManager, VehicleDoor/Trunk, CarProbe, VehicleMeshBuilder
  missions/    MissionDB (7 capítulos + secundárias/eventos), MissionManager
  story/       StoryDB (16 gravações da Dra. Helena, documentos, itens-chave), StoryManager
  weather/     WeatherManager (limpo, nublado, encoberto, neblina, chuva, tempestade), WeatherFX
  time/        TimeManager (madrugada, manhã, tarde, noite)
  audio/       Synth + SoundBank (síntese procedural), AudioManager (barramentos, pool 3D), MusicDirector, AmbienceController
  cinematics/  CinematicDirector, CineActor, CityLife (trânsito/pedestres), CineFX
  save/        SaveManager (slots JSON, autosave, quicksave)
  ui/          UITheme, UIKit, MainMenu, SettingsMenu, SaveLoadMenu, LoadingScreen, HUD (+ bússola/olho/mira),
               InventoryScreen, MapScreen/MapView, JournalScreen, DialogueScreen, TradeScreen, PauseMenu,
               SleepDialog, DeathScreen, ReadableScreen, DebugOverlay, CinematicOverlay, EndingScreen, GameUI
  game/        Game (monta e conecta tudo)
shaders/       bake_surface, world_surface, terrain, character, foliage, grass, water, sky, glass,
               screen_monitor, window_light, emissive_power, post_accessibility, far_terrain, far_skyline
cinematics/    opening.json (timeline editável da abertura)
scenes/        boot, menu, game, cinematics/opening_cinematic.tscn
tests/         parse_check, visual_test, bench_chunks, smoke_test (gameplay + abertura)
tools/         check.sh, bake_cinematic.gd
```

Todos os assets (texturas, malhas, personagens, animações, sons, música) são **gerados pelo próprio jogo**
a partir de código — não há arquivos de terceiros com licença restrita.

### Personagens (sem cara de boneco)

* **Cabeça e pescoço** vêm de um molde anatômico (`HeadTemplate`): um campo de distância com crânio, massa
  facial, mandíbula e ângulo da mandíbula, queixo, maçãs, bucinadores, arco das sobrancelhas, órbitas
  escavadas, nariz (dorso/ponta/asas), lábios, orelhas, pescoço com esternocleidomastoides e pomo de adão.
  A superfície é amostrada por raios numa grade mais densa no rosto (LOD 0 ≈ 3 200 vértices, LOD 1 ≈ 350),
  com oclusão ambiente calculada no próprio SDF. Um molde por sexo/LOD, em cache em `user://cache`.
* Cada personagem aplica variações baratas por máscara de região (largura da mandíbula, nariz, queixo,
  bochechas, lábios, comprimento do rosto, sobrancelha) a partir da semente — rostos distintos e estáveis.
* Olhos com esclera mais larga que a íris, íris/pupila com bordas nítidas, pálpebras amendoadas que se
  encontram nos cantos; cabelo acompanha a pele do molde com linha do cabelo, costeletas e fios no shader;
  barba/bigode, sobrancelhas, lábios e olheiras por máscara.
* Corpo: ombros em cúpula (deltoide), sobreposição nas articulações (sem frestas ao dobrar), decote em V do
  jaleco e faixas de roupa com bordas nítidas; detalhe de pele/malha/brim/couro em `Texture2DArray`.

---

## A abertura (cinemática real no motor)

A abertura é renderizada **em tempo real**, com o mesmo mundo, personagens, materiais, iluminação, partículas,
clima e áudio do gameplay — sem vídeo, sem imagens pré-renderizadas.

1. **A cidade normal** — câmera aérea desce até a Avenida Central: trânsito, ônibus, táxis, pedestres, lojas.
2. **Laboratório NEXUS** — pesquisadores, computadores, corredores, a Dra. Helena trabalhando; "PROJECT NEXUS" discreto.
3. **O acidente** — alarme, luzes de emergência, faíscas, fumaça, pesquisadores correndo, porta selada.
4. **O primeiro paciente** — pelo vidro da observação, Rafael muda: postura, tiques, a mão no vidro, o sorriso.
5. **A contaminação** — hospital São Lucas, ambulâncias com sirene, polícia, pessoas tossindo.
6. **O colapso** — pânico nas ruas, barricada, saque no mercado, plantão na TV, helicóptero, onda de apagão.
7. **Silêncio** — ruas vazias, carros abandonados, chuva, papéis ao vento, colunas de fumaça.
8. **ALGUMAS SEMANAS DEPOIS** — a mesma rua destruída, mato, barricadas, infectados vagando.
9. **Caio chega** — sai do túnel com a mochila, para no mirante, olha a cidade; a câmera da cena **funde-se na
   câmera de gameplay** atrás do ombro dele e o controle passa ao jogador **no mesmo lugar** (sem tela preta,
   sem teleporte). Segure **Enter/Y** para pular.

### Editando a cinemática

* `cinematics/opening.json` — cenas (fase do mundo, hora, clima, música, interior, preparação) e tomadas
  (âncora, duração, chaves de câmera `[t, posição, alvo, fov]`, eventos com tempo). Âncoras:
  `poi:<id>`, `door:<poi>` (x = lateral, z = para fora da porta), `marker:<poi>:<marcador>` (interiores),
  `caio`, `caio_follow`. `ground: true` torna o *y* relativo ao chão.
* Eventos disponíveis: `actor`, `place`, `walk`, `face`, `anim`, `infect`, `sound`, `sound3d`, `subtitle`,
  `music`, `card`, `shake`, `alarm`, `lights`, `flicker`, `door`, `sparks`, `smoke`, `smoke_column`, `papers`,
  `tv`, `traffic`, `crowd`, `crowd_at`, `anim_crowd`, `vehicle`, `drive`, `helicopter`, `blackout`,
  `barricade`, `infected`, `ambience`, `caio`, `caio_walk`, `caio_face` (ver `CinematicDirector._run_event`).
* Cada tomada vira uma `Animation` (trilhas de câmera/olhar/FOV + trilha de métodos). Para editar no editor:
  `godot --headless --path . -s tools/bake_cinematic.gd` gera `cinematics/opening_library.tres`; adicione-a ao
  `AnimationPlayer` de `scenes/cinematics/opening_cinematic.tscn` (a biblioteca da cena tem prioridade;
  apague o `.tres` para voltar a usar só o JSON).

---

## Sistemas de jogo

* **Sobrevivência interligada**: fome, sede, energia, fôlego, temperatura corporal (clima, roupa, chuva,
  fogo), sangramento, fraturas, dor, infecção de ferida, intoxicação, resfriado, febre, infecção NEXUS
  (incubação, inibidor), umidade, peso e moral — tudo afeta velocidade, fôlego, visão e combate.
* **Inventário limitado** por peso e espaços; mochilas, bolsos, porta-malas, baús, esconderijos, armários;
  condição/frescor dos itens; atalhos rápidos.
* **Loot contextual**: casa, mercado, farmácia, hospital, oficina, posto, delegacia, escola, laboratório…
* **Fabricação e reparo**: sobrevivência, medicamentos, culinária (no fogo), armas, ferramentas, estruturas
  (fogueira, coletor de chuva, baú, esconderijo, cama, bancada, alarme de latas, barricadas), reparos e melhorias.
* **Combate corpo a corpo tático**: leves/pesados em combo, bloqueio e aparo, esquiva, empurrão, reações,
  atordoamento, derrubadas, ataques furtivos; desgaste de armas; armas de fogo barulhentas e arco silencioso.
* **Infectados originais** com percepção (visão, audição, luz, obstáculos, ruído, distância, outros
  infectados): Errante, Febril (corre), Sentinela (grita e chama), Colosso (investida), Rastejante
  (emboscada), Hospedeiro (esporos). Evoluem a partir do capítulo 6.
* **Furtividade**: visibilidade (luz, lanterna, postura, movimento), ruído (passos por superfície,
  combate, portas, veículos), distrações arremessáveis.
* **Sobreviventes** com necessidades, rotinas por hora, memória e relação com o jogador; exploram, coletam,
  protegem a base, fogem, negociam, ajudam, acompanham, entram em conflito; eventos emergentes e encontros.
* **Facções** com identidade, território, objetivos, recursos, líderes, relações mutáveis e simulação por hora.
* **Veículos** com combustível, condição do motor, lataria, bateria, porta-malas, física própria, ruído,
  atropelamento; sifonar gasolina, ligação direta, conserto.
* **Dia/noite e clima dinâmico** afetam luz, visibilidade, temperatura, infectados e sobreviventes.
* **História** em 7 capítulos (O Retorno, Silêncio, NEXUS, Os Sobreviventes, A Verdade, Evolução,
  O Início do Fim), missões secundárias, decisões (travessia, destino da mãe, final) e 3 finais.
* **Salvamento**: posição, inventário, equipamento, progresso, missões, decisões, veículos, estruturas,
  contêineres, portas, itens largados, facções, clima, horário e população.

---

## Testes

```bash
GODOT=/caminho/godot tools/check.sh                                 # compila todos os scripts e shaders
godot --headless --path . res://tests/smoke_test.tscn -- --no-audio  # gameplay: andar, telas, fabricar, salvar/carregar
xvfb-run godot --path . --rendering-driver opengl3 res://tests/smoke_test.tscn -- --opening --shots=/tmp/shots
xvfb-run godot --path . --rendering-driver opengl3 res://tests/visual_test.tscn -- --out=/tmp/shots
godot --headless --path . res://tests/bench_chunks.tscn             # tempo de geração dos chunks
```

## Build

`export_presets.cfg` traz as predefinições **Linux** e **Windows Desktop** (x86_64, texturas S3TC/BPTC).
Com os *export templates* 4.7.2 instalados:

```bash
godot --headless --path . --export-release "Linux" build/linux/o_inicio_do_fim.x86_64
godot --headless --path . --export-release "Windows Desktop" "build/windows/O Inicio do Fim.exe"
```

Sem templates, `tools/build_linux.sh` empacota o jogo num `.pck` e o executa com o binário oficial do Godot.
