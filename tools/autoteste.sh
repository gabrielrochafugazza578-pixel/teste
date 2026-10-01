#!/usr/bin/env bash
# Joga sozinho por N segundos (piloto automatico) e mostra erros + resumo.
# Uso: tools/autoteste.sh [segundos]
cd "$(dirname "$0")/.."
SECS="${1:-90}"
timeout $((SECS + 300)) xvfb-run -a -s "-screen 0 1280x720x24" godot --path . --rendering-driver vulkan -- --autotest="$SECS" --radius=5 2>&1 \
  | grep -vE "ALSA|libpulse|audio driver|init_output_device|dummy driver|^\s*at: \(?(drivers|servers)/|^$" || true
