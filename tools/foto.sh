#!/usr/bin/env bash
# Tira uma foto do jogo sem janela (usa Xvfb + Vulkan por software).
# Uso: tools/foto.sh saida.png [argumentos do jogo...]
#   ex: tools/foto.sh screenshots/vista.png --time=0.45 --pos=10,20 --look=30,-10
set -e
OUT="$1"; shift
cd "$(dirname "$0")/.."
mkdir -p "$(dirname "$OUT")"
timeout 900 xvfb-run -a -s "-screen 0 1280x720x24" godot --path . --rendering-driver vulkan -- --shot="$(realpath -m "$OUT")" "$@" 2>&1 \
  | grep -vE "ALSA|libpulse|audio|init_output_device|^\s*at: |^$" || true
