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

| Ação | Teclado/mouse | PlayStation | Xbox |
|---|---|---|---|
| Mover / câmera | WASD / mouse | analógico esq. / dir. | analógico esq. / dir. |
| Correr / agachar | Shift / C | L3 (clique trava a corrida) / ○ | LS / B |
| Câmera 1ª ↔ 3ª pessoa | V | R3 | RS |
| Pular, escalar, transpor | Espaço | ✕ | A |
| Interagir (segurar = ações longas) | E | □ | X |
| Atacar (segurar = pesado) / Defender, mirar | Mouse esq. / Mouse dir. | R2 / L2 | RT / LT |
| Empurrar / Esquivar | F / Q | R1 / L1 | RB / LB |
| Arremessar distração | G | △ segurado | Y segurado |
| Atalhos | 1–4 | ←/→ escolhe, △ usa | ←/→ escolhe, Y usa |
| Lanterna (faróis no carro) / Cura rápida | L / H | ↑ / ↓ | ↑ / ↓ |
| Mochila e fabricação / Mapa / Diário | Tab / M / J (ou os botões do HUD) | Share / touchpad / L2-R2 nos menus | View / — / LT-RT nos menus |
| Veículo: acelerar / frear-ré / freio de mão / buzina / sair | W / S / Espaço / R / E | R2 / L2 / ✕ / △ / □ | RT / LT / A / Y / X |
| Pausa / Pular cinemática (segurar) | Esc / Enter | Options / △ | Menu / Y |
| Liberar o cursor para clicar nos botões do HUD (segurar) | Alt | | |
| Salvar/carregar rápido / Painel de desempenho / Esconder HUD | F5 / F9 / F3 / F1 | | |

**Controle** (`scripts/core/pad_input.gd`, autoload `Pad`): qualquer controle SDL (DualShock 4, DualSense,
Xbox, Switch Pro, genéricos). O jogo percebe o que está sendo usado (teclado/mouse ou controle) e troca os
ícones da tela sozinho (`InputPrompt` desenha ✕ ○ □ △ coloridos no PlayStation, A B X Y no Xbox). Os
gatilhos viram "botões" com histerese (um aperto = um golpe/tiro), o analógico esquerdo navega nos menus
com repetição, o direito rola listas; nos menus ✕ escolhe, ○ volta, □/△ ações extras, L1/R1 abas e L2/R2
trocam entre Mochila, Mapa e Diário. No mapa o analógico move e ✕ marca destino. Câmera com zona morta
radial, curva de resposta, aceleração no fim do curso e assistência de mira leve (a câmera desacelera com um
infectado na mira). Vibração em golpes, tiros, dano e batidas de carro. Opções em Configurações → Controles.

**1ª pessoa** (V / R3): a câmera vai para os olhos do Caio (o osso da cabeça é encolhido para não ver o rosto
por dentro), o corpo segue a câmera e continua visível; olhando para baixo a câmera avança um pouco para
não atravessar a gola. No carro a câmera volta para trás do veículo.

---

## Desempenho (hardware alvo)

* **Compatibility renderer** (GL 3.3): sem Vulkan, roda na GTX 750 Ti e em iGPUs.
* **Resolução interna** (escala 3D 50–100 %) com upscaling bilinear + VSync; alvo 30 FPS a 720p/900p no BAIXO.
* **Predefinições**: MUITO BAIXO, BAIXO, MÉDIO, ALTO, ULTRA + ajuste individual (resolução, texturas, sombras,
  distância de visão/objetos, vegetação, partículas, pós, densidade de NPCs e infectados, clima, reflexos,
  MSAA, VSync, limite de FPS, FOV).
* **Iluminação sem energia** (depois do surto): nenhuma lâmpada acesa. Céu e sol com tonemap ACES e sombras
  mais escuras; noite só com luar. Dentro dos prédios a luz ambiente cai para ~15% (neutra, não o azul do céu)
  e quem ilumina é a janela: `World._update_window_lights` liga até 3 spots de claridade (dia) ou luar (noite)
  nas janelas mais próximas do jogador e 1 spot de mancha de sol quando o sol bate naquela janela; janelas
  tapadas deixam passar menos. A malha do interior é dividida em pedaços de ~8 m por andar (feito na thread)
  para cada pedaço receber só as luzes próximas — lanterna + brilho + janelas cabem no limite de 6 luzes por
  malha do Compatibility. A exposição se adapta um pouco ao escuro e reduz com a lanterna acesa em lugar fechado.
* **Texturas**: 2 `Texture2DArray` (albedo+rugosidade / normal+AO+metal) compartilhadas por todo o mundo;
  256–2048 px por camada (≈ 11–720 MB) — BAIXO usa 512 px ≈ 45 MB. Cada camada tem detalhe próprio (asfalto
  com agregado, remendos e rachaduras; concreto com juntas e poros; tijolo com lascas e eflorescência; reboco
  com escorridos e descascado; madeira com veios, nós e pregos; piso com peças trincadas…) e o shader quebra
  a repetição das camadas orgânicas com uma segunda amostra girada. As armas usam um atlas à parte
  (`Assets.weapon_a/b`: nogueira, aço escovado, polímero, borracha). Interiores recebem uma luz indireta
  falsa opcional (`interior_fill`, desligada por padrão: a luz dos interiores vem das janelas).
* **Draw calls**: cada chunk de 64 m é mesclado em poucas malhas com um único material; props repetidos em
  **MultiMesh**; vegetação/grama instanciada; *visibility ranges*; *occlusion culling* com `ArrayOccluder3D`.
  Medido: 100–230 draw calls, ~80 MB de VRAM na cidade.
* **Streaming**: anéis de LOD (0/1/2) por distância; geração em `WorkerThreadPool`; aplicação no main thread
  com orçamento em µs por quadro; interiores gerados sob demanda ao se aproximar.
* **Sem piscar** (medido com `tests/flicker.tscn` + `tools/flicker_score.py`: a câmera anda milímetros por
  quadro e o script marca os pixels que mudam de forma não suave):
  - o terreno desenhado afunda 30 cm sob ruas e quarteirões da cidade e 16 cm sob o asfalto das rodovias
    (`WorldLayout.visual_sink`; a física não muda) — antes ficava no mesmo plano do asfalto e brigava pelo depth;
  - decalques (manchas, papéis, marcas de parede, remendos, sangue, óleo) têm `UV2.y = 2 + nível + semente` e o
    `world_surface` os puxa para a câmera ao longo do raio de visão (a posição na tela não muda, só a
    profundidade, proporcional ao quadrado da distância);
  - janelas procedurais, faixas da rua e caixilhos com antisserrilhado analítico (`fwidth`) e, de longe, a
    média da grade no lugar do padrão (sem moiré); rugosidade aumenta onde a normal varia dentro do pixel;
  - folhas e grama com alfa que preserva a cobertura nos mipmaps e borda de 1 pixel (não somem de longe);
  - sol girando em passos de 0,15° (as bordas das sombras não "rastejam" a cada quadro);
  - plano próximo da câmera 0,12 m (0,05 m em 1ª pessoa) e filtro anisotrópico 8×.
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
               EnvironmentController (sol/lua/céu/neblina), Setor7, Birds (urubus planando)
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
shaders/       bake_surface, world_surface, terrain, character, foliage, grass, water, sky, glass, flag, leaf_particle, highlight, hazard_blink, bird,
               screen_monitor, window_light, emissive_power, post_accessibility, far_terrain, far_skyline
cinematics/    opening.json (timeline editável da abertura)
scenes/        boot, menu, game, cinematics/opening_cinematic.tscn
tests/         parse_check, visual_test, bench_chunks, smoke_test (gameplay + abertura)
tools/         check.sh, bake_cinematic.gd
```

Os assets (texturas, malhas, animações, sons, música) são **gerados pelo próprio jogo** a partir de código.
Exceções (arquivos de fora, em `assets/`):

* `assets/models/caio_survivor.bin` — o GLB "sobrevivente pós-apocalíptico" do Caio, fornecido pelo autor do
  projeto (extensão `.bin` para o Godot não tentar importá-lo; o jogo lê o arquivo direto em `CaioModel`).
* `assets/textures/grass_bush.png` — textura de moita de grama do addon
  [SimpleGrassTextured](https://github.com/IcterusGames/SimpleGrassTextured) (IcterusGames, licença MIT,
  texto em `assets/textures/grass_bush_LICENSE.txt`). Só a textura é usada: a grama continua espalhada
  proceduralmente por chunk (MultiMesh), em 3 planos cruzados com alpha scissor, vento e empurrão do jogador
  em `shaders/grass.gdshader`.
* `assets/materials/NN_a.png` / `NN_b.png` — texturas fotográficas do [Poly Haven](https://polyhaven.com)
  (CC0; lista em `assets/materials/LICENCA.txt`), empacotadas por `tools/fetch_textures.py` no formato das
  camadas do jogo (A = cor + rugosidade, B = normal xy + AO + metal) com a escala real de cada foto em
  `escala.json`. O bake usa a foto quando existe e cai no material procedural quando não (grama e tecido
  continuam procedurais).
* `assets/models/props/barrel`, `assets/models/props/trash_bag` — modelos glTF do Poly Haven (CC0), lidos por
  `PropLib.MODELS` (base no chão, escala à altura alvo, várias cópias fundidas numa malha para o MultiMesh).

### Caio (modelo GLB)

* `CaioModel` lê o GLB em tempo de execução (sem importador), converte Z-up → Y-up, agrupa cada peça
  (calça, botas, jaqueta, mochila, luvas, boné...) no osso certo do esqueleto de 18 ossos e monta **uma malha
  skinada** com o mesmo shader dos outros personagens — por isso toda a biblioteca de animações, o IK dos pés
  e os pontos de encaixe de arma/lanterna funcionam nele sem mudança.
* Mochila, cinto e bolsos ficam presos ao tronco; as pernas usam pesos suaves no quadril e no joelho.
* O `ProceduralAnimator` deriva a escala de passada do comprimento real das pernas do modelo.

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

1. **A cidade normal** — manhã de sol; a câmera aérea desce pela Avenida Central com as fachadas iluminadas
   (letreiro "SANTA AURORA"): trânsito, ônibus, táxis, pedestres, lojas, telhados com caixas d'água e ar-condicionado.
2. **Laboratório NEXUS** — luminárias fluorescentes acesas, piso vinílico, lambri com a faixa do projeto,
   pesquisadores, computadores, a Dra. Helena trabalhando; "PROJECT NEXUS" discreto.
3. **O acidente** — a energia cai (luminárias apagam), alarme e luzes vermelhas de emergência, faíscas, fumaça,
   pesquisadores correndo, porta selada.
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
  `caio`, `caio_follow`. `ground: true` torna o *y* relativo ao chão. `focus: [[x, y, z], …]` (tomada) lista
  pontos do trajeto que precisam estar carregados antes da cena; `power_out: true` (cena de interior) mantém
  o prédio sem luz.
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
  Sítios e cabanas têm ferramentas de roça e armas de caça; cada prédio pode ter uma arma largada
  (`LootTables.WEAPONS`), e arma de fogo achada vem com um pouco de munição do lado.
* **Itens soltos pelo mundo**: em cima de mesas, balcões, escrivaninhas, criados-mudos, bancadas, camas e no
  chão (`InteriorGen._scatter_items`, tabela do móvel ou do cômodo), até 40 por prédio. Cada item tem um modelo
  3D próprio em escala real (`ItemModels`: latas, garrafas PET e de vidro, remédios, munição, ferramentas,
  roupas dobradas, mochilas, galões, documentos…) com os materiais do atlas das armas.
* **Painel "Itens por perto"** (`HUDNearby`, lado direito): até 6 itens visíveis num raio de 6,5 m (sem contar
  o que está atrás de parede), com ícone, nome, quantidade e distância; o item na mira fica destacado com a
  tecla de interação e, com o cursor livre (Alt), dá para clicar e pegar.
* **Interiores decorados e abandonados** (depois do surto; antes dele ficam arrumados): lojas, farmácias e
  ferragens com gôndolas em fileiras, bares com mesas e cadeiras, escritórios com mesas, cadeiras de rodinha e
  computadores, recepções com sofás e poltronas, rodapé, luminárias, quadros, relógios, cartazes, espelhos,
  plantas secas, micro-ondas, louça, abajures. O abandono: móveis tombados, gôndolas caídas com produtos
  espalhados, papéis, lixo, entulho de reboco, manchas de sujeira, infiltração e sangue, rachaduras, tijolo
  exposto, pichações, janelas tapadas com tábuas, cacos de vidro, luminárias penduradas ou caídas, forro
  desabado e "ninhos" de sobreviventes. Tudo numa malha por interior, com teto de ~150 mil vértices.
* **Armas**: 25 brancas, fora as ferramentas que também servem de arma (faca, canivete, cutelo, soco-inglês, facão, machadinha, machado, picareta, foice,
  enxada, katana, tacos, bastões, chave de roda…) e 11 de fogo/arremesso (revólver .38, pistola 9 mm, pistola
  .380, submetralhadora, espingarda 12 de bomba e de cano duplo, carabina .22, rifle com luneta, carabina
  policial 5.56, besta e arco), todas modeladas em código (`WeaponMeshes`) com atlas próprio de nogueira, aço
  escovado, polímero e borracha. Espingardas disparam chumbo (vários projéteis com queda de dano), armas
  automáticas atiram enquanto o botão está apertado, miras com luneta aproximam a câmera, besta e arco são
  silenciosos e as setas podem ser recuperadas. Pistolas são miradas com os braços estendidos; armas longas
  vão para o ombro.
* **Fabricação e reparo**: sobrevivência, medicamentos, culinária (no fogo), armas, ferramentas, estruturas
  (fogueira, coletor de chuva, baú, esconderijo, cama, bancada, alarme de latas, barricadas), reparos e melhorias.
* **Combate corpo a corpo tático**: leves/pesados, combo leve-leve-finalização (o 3º golpe seguido é mais
  forte), cliques durante um golpe entram na fila, mira assistida (o Caio vira para o infectado mais próximo à
  frente e dá um passo curto se ele estiver um pouco longe), bloqueio e aparo, esquiva, empurrão, reações,
  atordoamento, derrubadas, ataques furtivos; respingo no acerto e marcador na mira; desgaste de armas; armas
  de fogo barulhentas e arco silencioso. **Sem agarrão**: os infectados arranham e mordem, mas não prendem o
  jogador. O empurrão de um golpe é uma velocidade inicial com atrito (não acumula): tapa ~5–10 cm, taco
  ~0,4 m, marreta pesada ~1 m (`tests/combat.tscn` mede por arma).
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
* **Interface do jogo** (o menu inicial mantém o visual próprio): tema `UITheme.game_theme()`, ícones
  vetoriais desenhados em código para itens e HUD (`UIIcons`), HUD em cartões (vitais com ícones, relógio e
  clima, objetivo com distância, tecla na dica, arma e atalhos com ícones, botões Mochila/Diário/Mapa),
  inventário e troca em grade (`ItemSlot`) com filtros e condição, diário com aba **Progresso** (capítulos,
  história, descobertas, estatísticas) e missões em cartões com barra de objetivos.
* **Prédios com relevo** (`BuildingGen._relief`, só perto: LOD 0 completo, LOD 1 o grosso): embasamento,
  pilares de canto, cornija, marquise e faixa de letreiro no térreo comercial, montantes entre vitrines,
  sacadas e peitoris alinhados às janelas dos residenciais, brises nos escritórios e alpendre nas casas.
  Custa ~860 triângulos e ~3 ms de geração (em thread) por chunk do centro; desligado no preset MUITO BAIXO.
* **Salvamento**: posição, inventário, equipamento, progresso, missões, decisões, veículos, estruturas,
  contêineres, portas, itens largados, facções, clima, horário e população.

---

## Testes

```bash
GODOT=/caminho/godot tools/check.sh                                 # compila todos os scripts e shaders
godot --headless --path . res://tests/smoke_test.tscn -- --no-audio  # gameplay: andar, telas, fabricar, salvar/carregar
xvfb-run godot --path . --rendering-driver opengl3 res://tests/smoke_test.tscn -- --opening --shots=/tmp/shots
xvfb-run godot --path . --rendering-driver opengl3 res://tests/visual_test.tscn -- --out=/tmp/shots
godot --headless --path . res://tests/bench_chunks.tscn             # tempo de geração dos chunks (e custo do relevo)
xvfb-run godot --path . --rendering-driver opengl3 res://tests/combat.tscn -- --out=/tmp/combate   # acerto/dano/empurrão por arma
xvfb-run godot --path . --rendering-driver opengl3 res://tests/ui.tscn -- --out=/tmp/ui            # fotos de todas as telas do jogo
xvfb-run godot --path . --rendering-driver opengl3 res://tests/light.tscn -- --out=/tmp/luz        # iluminação: dia, noite, interior, Setor 7
xvfb-run godot --path . --rendering-driver opengl3 res://tests/buildings.tscn -- --out=/tmp/predios # fachadas de perto e do alto
xvfb-run godot --path . --rendering-driver opengl3 res://tests/interiors.tscn -- --out=/tmp/interiores [--only=house,police]  # dentro dos prédios
xvfb-run godot --path . --rendering-driver opengl3 res://tests/arms.tscn -- --out=/tmp/armas_mao [--only=rifle_caca]        # armas na mão e disparo
xvfb-run godot --path . --rendering-driver opengl3 res://tests/weapons_test.tscn -- --out=/tmp/armas                         # vitrine dos modelos de arma
xvfb-run godot --path . --rendering-driver opengl3 res://tests/tex_dump.tscn -- --out=/tmp/texturas                          # todas as texturas geradas
PORTAS_N=7 xvfb-run godot --path . --rendering-driver opengl3 res://tests/doors.tscn -- --no-audio --out=/tmp/portas   # abre portas e entra (PORTAS_TIPOS=house,shop · PORTAS_MOVEIS=1 · PORTAS_ITENS=1)
xvfb-run godot --path . --rendering-driver opengl3 res://tests/veg_probe.tscn -- --out=/tmp/veg [--hour=10 --props --folhas --bandeira --passaros --fita]  # vegetação, props, folhas, bandeira e urubus
```

## Build

`export_presets.cfg` traz as predefinições **Linux** e **Windows Desktop** (x86_64, texturas S3TC/BPTC).
Com os *export templates* 4.7.2 instalados:

```bash
godot --headless --path . --export-release "Linux" build/linux/o_inicio_do_fim.x86_64
godot --headless --path . --export-release "Windows Desktop" "build/windows/O Inicio do Fim.exe"
```

Sem templates, `tools/build_linux.sh` empacota o jogo num `.pck` e o executa com o binário oficial do Godot.

**Pacote único Windows + Linux** (a pessoa escolhe a pasta do seu sistema):

```bash
GODOT=/caminho/godot tools/build_all.sh    # → build/O_Inicio_do_Fim_Windows_e_Linux.zip
```

O `.zip` traz `Windows/` (`O Inicio do Fim.exe` + `.pck`), `Linux/` (`o_inicio_do_fim.x86_64` + `.pck` +
`jogar.sh`, com o bit de execução preservado), `LEIA-ME.txt` e `licencas/`. Precisa dos *export templates*
4.7.2 de Linux e de Windows (`windows_release_x86_64.exe`). Não há código específico de sistema: saves ficam
em `~/.local/share/o_inicio_do_fim/` (Linux) e `%APPDATA%\o_inicio_do_fim\` (Windows).

No GitHub, `.github/workflows/build.yml` faz o mesmo a cada push neste branch: exporta as duas versões, publica
o `.zip` como *artifact* da execução (Actions → Build Windows + Linux → Artifacts) e abre o `.exe` num runner
Windows (`--headless`) procurando erros de script no `godot.log`.
