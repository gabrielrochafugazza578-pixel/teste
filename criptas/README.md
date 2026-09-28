# Criptas de Valdor

Um *dungeon crawler* de ação em 3D, com câmera isométrica, inspirado no estilo de *Minecraft Dungeons* mas com identidade própria: personagens com anatomia e articulações de verdade, criaturas originais, paredes e objetos de formas orgânicas, reflexos no chão e na água, sombras de tochas, névoa, bloom e correção de cor.

Tudo é gerado por código: as masmorras (diferentes a cada partida), as texturas, os modelos, a música e os efeitos sonoros. Não há nenhum arquivo de imagem ou som.

## Como jogar

Abra o arquivo **`index.html`** em um navegador moderno (Chrome, Edge, Firefox ou Safari). Não precisa instalar nada nem ligar servidor: o jogo já vem compilado em `dist/jogo.js` e funciona sem internet. (Com internet, a interface usa as fontes IM Fell English SC e Alegreya Sans do Google Fonts; sem internet, usa as fontes do sistema.)

No Linux, também dá para usar:

```bash
./jogar.sh
```

## O Refúgio

O jogo começa no **Refúgio da Última Chama**, um acampamento subterrâneo. Lá você encontra:

- **Oren, o Escriba** e o **quadro de missões**: aceite até 3 contratos de cada vez.
- **Ilsa, a Mercadora**: compre equipamentos, flechas, melhorias permanentes da poção e fragmentos dimensionais. Venda o que estiver sobrando na bolsa.
- **Brom, o Ferreiro**: aprimora o que você tem equipado, de +1 até +5 (12% mais forte por nível).
- **A fogueira**: descansar restaura a vida e salva o progresso.
- **O portal azul**, que desce às Criptas, e **o portal roxo**, que leva às dimensões.

## Andares e dimensões

Cada andar é uma masmorra nova e grande (140 × 140 blocos, até 22 salas). Para vencer um andar:

1. Encontre e ative os **3 objetivos** do lugar (braseiros, cristais, totens ou selos; aparecem em laranja no minimapa). Cada um atrai uma emboscada.
2. Com os três ativos, o **portão da grande arena** se abre. Entre e enfrente o guardião.
3. Derrote o guardião, pegue os **fragmentos dimensionais** que ele deixa e entre no portal para voltar ao Refúgio.

| Lugar | Tipo | Guardião |
|---|---|---|
| Catacumbas Esquecidas | Andar 1, 4, 7... | Gorran, o Devorador |
| Minas de Ferro Negro | Andar 2, 5, 8... | Vesh'kara, a Serpente-Mãe |
| Forja Profunda | Andar 3, 6, 9... | Colosso de Obsidiana |
| Geleira Eterna | Dimensão (gelo polido e escorregadio) | Ysra, a Rainha Hibernal |
| Pântano Afogado | Dimensão (água rasa e juncos) | Mórbida, a Flor Ancestral |
| Vazio Estelar | Dimensão (plataformas sobre o abismo) | Arauto do Vazio |

Cada viagem a uma dimensão custa 1 fragmento. As dimensões são mais difíceis e dão recompensas melhores.

Se você cair, pode tentar de novo ou voltar ao Refúgio. Nos dois casos volta com o que tinha ao entrar no lugar.

## Missões

Tipos de contrato: caçada (derrotar N criaturas de um tipo), caçador de campeões (elites), saqueador de tumbas (baús), guardião (derrotar o chefe do andar), relíquia perdida (encontrar um objeto no próximo andar), resgate (libertar um prisioneiro enjaulado) e além do véu (vencer uma dimensão). As recompensas (ouro, XP, itens raros ou únicos e fragmentos) chegam assim que a missão é cumprida.

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
| Guardar item do chão na bolsa | G | |
| Bolsa | I ou Tab | |
| Diário de missões | O | |
| Zoom | roda do mouse | |
| Pausa | Esc ou P | Start |

No celular ou tablet, arraste no lado esquerdo da tela para andar e use os botões da direita. A bolsa e o diário ficam no canto superior esquerdo.

## Criaturas

Todas as criaturas são originais:

- **Rastejante Pálido**: humanoide cego que anda de quatro e ataca com garras longas.
- **Cardo Sepulcral**: planta espinhosa que abre a flor e dispara leques de espinhos.
- **Serpe das Fendas**: serpente de escamas que dá botes rápidos.
- **Bulbo de Miasma**: água-viva flutuante que incha e explode, deixando uma nuvem tóxica.
- **Vidente Sem-Rosto**: figura flutuante de máscara de porcelana e quatro braços; lança orbes e invoca rastejantes.
- **Couraçado**: besouro blindado de casco iridescente que investe em linha reta. Se bater na parede, fica atordoado.
- **Mariposa Cinérea**: mariposa gigante que ataca em mergulhos.
- **Espreitador do Vazio** e **Lobo de Geada**: feras rápidas com espinhos de cristal ou gelo.
- Variantes das dimensões: Afogado, Cardo Glacial, Aparição Glacial, Casco Glacial, Couraçado de Magma, Mariposa da Neve e Bulbo do Vazio.

## Equipamento

Os itens caem de inimigos, baús e vasos, e podem ser comprados com Ilsa. Cada item tem raridade (**Comum**, **Raro** ou **Único**); os raros e únicos trazem encantamentos. Chegue perto de um item para ver a comparação com o que está usando: **E** equipa (o antigo vai para a bolsa) e **G** guarda na bolsa.

- **Armas corpo a corpo**: espada, machado, adagas gêmeas, martelo de guerra, lança.
- **Armas à distância**: arco curto, arco longo, besta pesada.
- **Armaduras**: couro, cota de malha, placas, manto do andarilho, couraça de obsidiana. Cada uma muda o visual do herói (capuz, elmo fechado com pluma, chifres, capa...).
- **Artefatos** (3 espaços): Tomo das Chamas, Relâmpago Engarrafado, Estandarte de Guerra, Chifre do Vendaval, Lâminas Espectrais, Totem Gélido.

## Gráficos

No menu de pausa, a opção **Gráficos** alterna entre Ultra, Alta, Média e Baixa.

- **Ultra** (padrão): reflexos no chão (poças, gelo e pisos polidos refletem tochas, personagens e paredes, com desfoque pela rugosidade), água espelhada, reflexos do ambiente nos metais atualizados em tempo real, sombras projetadas pelas 4 tochas mais próximas e mais luzes simultâneas.
- **Alta**: os mesmos efeitos, em resolução menor e com 2 tochas fazendo sombra.
- **Média** e **Baixa**: para aparelhos mais fracos.

Se o jogo rodar abaixo de ~24 FPS no Ultra, ele passa sozinho para Alta (dá para voltar no menu de pausa). O progresso fica salvo no navegador; use **Continuar** na tela inicial.

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
  dungeon.js     gerador de masmorras e do Refúgio (salas, corredores A*, lagos, pilares, objetos, inimigos)
  voxmesh.js     gera a malha do mundo (deformação orgânica, oclusão de ambiente por vértice, água e lava)
  textures.js    texturas procedurais: atlas dos blocos (cor, relevo, rugosidade, brilho) e personagens
  models.js      humanos articulados (herói, NPCs), armas e arcos
  creatures.js   criaturas e chefes, com as animações de cada anatomia
  rig.js         materiais, esqueleto de pivôs e cache de modelos
  geo.js         geometrias suaves (membros, torno, lâminas, tubos, rochas)
  reflect.js     espelho do chão/água e mapa de ambiente dinâmico
  quests.js      contratos do quadro de missões
  entities.js    jogador, inimigos, chefes e projéteis
  objects.js     baús, vasos, objetivos, portões, portais, altar, NPCs, prisioneiro, relíquia, saques
  props.js       objetos de cenário (tochas, barris, caixas, ossos, teias, estandartes...)
  particles.js   partículas em GPU
  audio.js       sintetizador de efeitos e trilha (Web Audio)
  items.js       itens, raridades e encantamentos
  ui.js          HUD, minimapa, cartões de item e menus
  input.js       teclado, mouse, toque e gamepad
  themes.js      regiões, dimensões e Refúgio (luz, reflexos, criaturas, objetivo)
```

Projeto pessoal e sem fins comerciais, inspirado no gênero de *Minecraft Dungeons*. Todo o conteúdo (nomes, regiões, criaturas, itens e arte) é original.
