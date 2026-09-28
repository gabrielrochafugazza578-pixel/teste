#!/usr/bin/env bash
# Roda o jogo (compila automaticamente se necessario).
#   ./run.sh           jogar
#   ./run.sh --mute    jogar sem som
#   OPENGL=true ./run.sh   tenta usar aceleracao OpenGL do Java2D
cd "$(dirname "$0")"
if [ ! -f EcosDoAbismo.jar ] || [ -n "$(find src -name '*.java' -newer EcosDoAbismo.jar 2>/dev/null)" ]; then
    ./build.sh || exit 1
fi
exec java -Xmx1g -Dsun.java2d.opengl="${OPENGL:-false}" -Dawt.useSystemAAFontSettings=on -jar EcosDoAbismo.jar "$@"
