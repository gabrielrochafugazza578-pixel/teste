# Criptas de Valdor

Um *dungeon crawler* de ação em 3D, com câmera isométrica e mundo feito de blocos, no estilo de *Minecraft Dungeons*, mas com conteúdo próprio e visual realista: texturas com relevo (normal maps) e rugosidade, sombras dinâmicas, tochas com luz tremulante, névoa, bloom e correção de cor.

Tudo é gerado por código: as masmorras (diferentes a cada partida), as texturas, os modelos, a música e os efeitos sonoros. Não há nenhum arquivo de imagem ou som.

## Como jogar

Abra o arquivo **`index.html`** em um navegador moderno (Chrome, Edge, Firefox ou Safari). Não precisa instalar nada nem ligar servidor: o jogo já vem compilado em `dist/jogo.js` e funciona sem internet. (Com internet, a interface usa as fontes IM Fell English SC e Alegreya Sans do Google Fonts; sem internet, usa as fontes do sistema.)

No Linux, também dá para usar:

```bash
./jogar.sh
```

## Objetivo

Cada andar é uma masmorra nova, gerada na hora. Para descer:

1. Encontre e acenda os **3 braseiros ancestrais** (aparecem em laranja no minimapa). Cada braseiro aceso atrai uma emboscada.
2. Com os três acesos, o **portão da grande arena** se abre. Entre e enfrente o guardião do andar.
3. Derrote o guardião e atravesse o **portal** que surge no centro da arena.

| Andar | Região | Guardião |
|---|---|---|
| 1 | Catacumbas Esquecidas | Gorran, o Devorador |
| 2 | Minas de Ferro Negro | Vesh'kara, Mãe da Teia |
| 3 | Forja Profunda | Colosso de Obsidiana |
| 4+ | As regiões se repetem, cada vez mais perigosas | |

Se você cair, pode tentar o andar de novo. Ele é recriado e você volta com o equipamento que tinha ao entrar nele.

## Controles

| Ação | Teclado e mouse | Controle (gamepad) |
|---|---|---|
| Mover | W A S D ou setas | analógico esquerdo |
| Mirar | mouse | analógico direito |
| Ataque corpo a corpo (segure para fazer combo) | botão esquerdo ou J | X / RB |
| Atirar com o arco | botão direito ou K | RT |
| Rolar (fica invulnerável) | Espaço ou Shift | A |
| Poção de vida | Q | B |
| Artefatos | 1, 2, 3 | LB, LT, RB |
| Interagir / equipar item | E | Y |
| Zoom | roda do mouse | |
| Pausa | Esc ou P | Start |

No celular ou tablet, arraste no lado esquerdo da tela para andar e use os botões da direita. A mira é automática.

## Inimigos

- **Carniçal**: morto-vivo lento que ataca de perto.
- **Esqueleto Arqueiro**: mantém distância e dispara flechas.
- **Aranha da Cripta**: rápida, dá botes.
- **Necromante**: lança orbes que perseguem o alvo e ergue carniçais.
- **Esporo Inchado**: corre até você e explode. Role para escapar, e use a explosão contra os outros inimigos.

## Equipamento

Os itens caem de inimigos, baús e vasos, e também podem ser comprados no **Altar das Oferendas**. Cada item tem uma raridade (**Comum**, **Raro** ou **Único**). Os raros e únicos trazem encantamentos, como golpes flamejantes, vampirismo, raios, flechas explosivas, espinhos e regeneração. Chegue perto de um item para ver a comparação com o que você está usando e aperte **E** para equipar.

- **Armas corpo a corpo**: espada, machado, adagas gêmeas, martelo de guerra, lança.
- **Armas à distância**: arco curto, arco longo, besta pesada.
- **Armaduras**: couro, cota de malha, placas, manto do andarilho, couraça de obsidiana. A aparência do herói muda com a armadura.
- **Artefatos** (3 espaços): Tomo das Chamas, Relâmpago Engarrafado, Estandarte de Guerra, Chifre do Vendaval, Lâminas Espectrais, Totem Gélido.

## Gráficos

No menu de pausa, a opção **Gráficos** alterna entre Alta, Média e Baixa. Se o jogo rodar abaixo de ~30 FPS nos primeiros segundos, a qualidade baixa sozinha.

## Para desenvolvedores

O código-fonte fica em `src/` e usa [Three.js](https://threejs.org/). Para recompilar depois de mudar algo:

```bash
npm install
npm run build     # gera dist/jogo.js
npm run dev       # recompila automaticamente a cada alteração
```

```
src/
  main.js        renderizador, pós-processamento (bloom, cor, vinheta), qualidade e laço principal
  game.js        andares, câmera, luzes dinâmicas, campo de fluxo da IA, efeitos e eventos
  dungeon.js     gerador de masmorras (salas, corredores com A*, piscinas, pilares, objetos, inimigos)
  voxmesh.js     transforma a masmorra em blocos e gera as malhas (oclusão de ambiente por vértice)
  textures.js    texturas procedurais: atlas dos blocos (cor, relevo, rugosidade, brilho) e personagens
  models.js      modelos articulados dos personagens e das armas
  entities.js    jogador, inimigos, chefes e projéteis
  objects.js     baús, vasos, braseiros, portões, portal, altar, saques e efeitos
  props.js       objetos de cenário (tochas, barris, caixas, ossos, teias, estandartes...)
  particles.js   partículas em GPU
  audio.js       sintetizador de efeitos e trilha (Web Audio)
  items.js       itens, raridades e encantamentos
  ui.js          HUD, minimapa, cartões de item e menus
  input.js       teclado, mouse, toque e gamepad
  themes.js      temas visuais de cada região
```

Projeto pessoal e sem fins comerciais, inspirado no estilo de *Minecraft Dungeons*. Todo o conteúdo (nomes, regiões, criaturas, itens e arte) é original.
