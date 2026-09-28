# Ecos do Abismo

> **Novo:** este repositório também tem o **[Criptas de Valdor](criptas/)**, um *dungeon crawler* 3D isométrico de blocos com visual realista, no estilo de *Minecraft Dungeons*. Para jogar, abra `criptas/index.html` no navegador.

Um metroidvania 2D em Java inspirado em *Hollow Knight*: cavernas sombrias com várias camadas de fundo, iluminação dinâmica, um pequeno andarilho mascarado, combate com ferrão, alma para curar e lançar feitiços, habilidades que abrem novos caminhos e um chefe no final.

Toda a arte, a música e os efeitos sonoros são gerados por código. Não há nenhum arquivo externo nem biblioteca extra: basta ter o Java instalado.

## Como jogar no Linux

1. Instale o JDK (versão 11 ou mais nova), se ainda não tiver:

   | Distribuição | Comando |
   |---|---|
   | Ubuntu / Debian / Mint / Pop!_OS | `sudo apt install openjdk-17-jdk` |
   | Fedora | `sudo dnf install java-17-openjdk-devel` |
   | Arch / Manjaro | `sudo pacman -S jdk17-openjdk` |

2. Na pasta do projeto:

   ```bash
   ./run.sh
   ```

   Na primeira vez, o script compila o jogo e cria o `EcosDoAbismo.jar`. Depois disso, você também pode rodar o jar direto com `java -jar EcosDoAbismo.jar`.

   - `./run.sh --mute`: joga sem som
   - `OPENGL=true ./run.sh`: tenta usar aceleração OpenGL (pode ficar mais fluido em algumas placas de vídeo)
   - **F11** (ou Alt+Enter): alterna a tela cheia

## Controles

| Ação | Teclas |
|---|---|
| Mover | ← → ou A D |
| Pular (segure para ir mais alto) | Z ou Espaço |
| Atacar com o ferrão | X ou J |
| Golpe para cima / para baixo (no ar) | ↑ + X / ↓ + X |
| Avanço rápido (depois de obter o Manto) | C, Shift ou K |
| Feitiço (gasta 1/3 da alma) | V ou L |
| Curar (gasta 1/3 da alma) | segure F ou Q, parado no chão |
| Sentar no banco (cura e salva) | ↑ ou W perto do banco |
| Olhar para cima / para baixo | segure ↑ / ↓ parado |
| Descer de uma plataforma fina | ↓ + pular |
| Pausa | Esc ou P |

## O mundo

- **Cavernas Sussurrantes**: o começo. Tem um banco, rastejantes e moscas vigias. Um fosso de espinhos largo demais bloqueia o caminho para a direita.
- **Jardim Musgoso**: fica abaixo das cavernas. Tem vegetação, cuspidores e, no fim, o **Manto de Sombra** (avanço rápido).
- **Abismo Silencioso**: um poço profundo e roxo. No fundo está a **Asa Monarca** (pulo duplo), a única forma de subir de volta.
- **Trono do Guardião**: a arena do **Guardião Oco**. Ele salta e esmaga o chão soltando ondas de choque, investe contra as paredes derrubando pedras do teto e gira uma clava enorme. Com metade da vida, fica mais rápido.

### Dicas
- Acertar inimigos com o ferrão enche o vaso de **alma** (o círculo no canto). Com ele pelo menos 1/3 cheio, você pode curar uma máscara ou lançar o **Espírito Vingativo**.
- O golpe para baixo no ar faz você **quicar** em inimigos e espinhos, e ainda recarrega o avanço e o pulo duplo.
- Pule as ondas de choque do chefe. Quando ele bate na parede, saia de baixo da poeira que cai do teto.
- Ao morrer, você perde o geo e volta ao último banco. Sua **sombra** fica onde você caiu, guardando o geo; toque nela para recuperá-lo.
- O jogo salva ao sentar num banco, ao pegar uma habilidade e ao vencer o chefe. O arquivo fica em `~/.ecos-do-abismo/save.properties`; apague-o para zerar o progresso.

## Estrutura do código

```
src/abismo/
  Main.java      janela, laço principal (lógica a 120 Hz) e modo de capturas (--shots)
  Game.java      estados, regras, câmera, iluminação e interface (HUD/menus)
  Player.java    física, combate e desenho do personagem
  Enemies.java   rastejante, mosca vigia, cuspidor, rocha de geo, projéteis, geo
  Boss.java      o Guardião Oco (máquina de estados com 2 fases)
  Art.java       arte procedural: textura das rochas, cenários em camadas, brilhos
  Sound.java     sintetizador: efeitos, trilha ambiente e trilha do chefe (mixer próprio)
  Room.java      colisão por blocos de cada sala
  World.java     salas, ligações entre portas e dicas
  Maps.java      mapas (gerado por tools/genmaps.py)
tools/genmaps.py  editor das salas em Python: altere e rode para regenerar Maps.java
```

Para criar ou mudar fases, edite `tools/genmaps.py` (a legenda dos símbolos está no topo do arquivo), rode `python3 tools/genmaps.py` e depois `./run.sh`.

## Problemas comuns

- **Sem som**: o jogo continua funcionando e mostra `[audio] desativado` no terminal. Confira se o PulseAudio ou o PipeWire está ativo.
- **Lento**: experimente `OPENGL=true ./run.sh`. A resolução interna é 960×540, ampliada para o tamanho da janela.
- **`javac` não encontrado**: instale o pacote **JDK**, não apenas o JRE (veja a tabela acima).

Projeto pessoal e sem fins comerciais, feito como homenagem ao estilo de *Hollow Knight*. Todo o conteúdo é original e gerado por código.
