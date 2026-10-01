#!/usr/bin/env bash
# Roda o Terra Redonda direto do codigo-fonte no Linux.
# Se a Godot 4.7 nao estiver instalada, baixa automaticamente (~75 MB) para
# ~/.local/share/terra-redonda/ (nao precisa de sudo).
#
# Uso:  ./jogar.sh            -> joga
#       ./jogar.sh --editor   -> abre o projeto no editor da Godot
#       ./jogar.sh --opengl   -> modo compativel (PCs/placas de video antigas)
set -e
cd "$(dirname "$0")"
VER="4.7.2"
GODOT="${GODOT:-}"

if [ -z "$GODOT" ]; then
  if command -v godot >/dev/null 2>&1 && godot --version 2>/dev/null | grep -qE '^4\.(7|8|9)'; then
    GODOT="godot"
  else
    DIR="$HOME/.local/share/terra-redonda/godot-$VER"
    GODOT="$DIR/Godot_v${VER}-stable_linux.x86_64"
    if [ ! -x "$GODOT" ]; then
      echo ">> Baixando a Godot $VER (~75 MB), so na primeira vez..."
      mkdir -p "$DIR"
      URL="https://github.com/godotengine/godot-builds/releases/download/${VER}-stable/Godot_v${VER}-stable_linux.x86_64.zip"
      if command -v curl >/dev/null 2>&1; then
        curl -L --fail -o "$DIR/godot.zip" "$URL"
      else
        wget -O "$DIR/godot.zip" "$URL"
      fi
      if command -v unzip >/dev/null 2>&1; then
        unzip -o -q "$DIR/godot.zip" -d "$DIR"
      else
        python3 -c "import zipfile,sys; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" "$DIR/godot.zip" "$DIR"
      fi
      rm -f "$DIR/godot.zip"
      chmod +x "$GODOT"
    fi
  fi
fi

# primeira vez: a Godot precisa importar o projeto
if [ ! -d .godot ]; then
  echo ">> Preparando o projeto (primeira vez)..."
  "$GODOT" --headless --path . --import >/dev/null 2>&1 || true
fi

ARGS=()
for a in "$@"; do
  case "$a" in
    --editor) ARGS+=("--editor") ;;
    --opengl) ARGS+=("--rendering-driver" "opengl3") ;;
    *) ARGS+=("$a") ;;
  esac
done
exec "$GODOT" --path . "${ARGS[@]}"
