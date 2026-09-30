#!/usr/bin/env bash
# Verificação rápida: reimporta (atualiza cache de classes) e compila todos os scripts.
# Uso: GODOT=/caminho/godot tools/check.sh
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."
timeout 300 "$GODOT" --headless --path . --import >/dev/null 2>&1
timeout 300 "$GODOT" --headless --path . -s tests/parse_check.gd 2>&1 \
  | grep -E "SCRIPT ERROR|Parse Error|Compile Error|Scripts verificados|at: GDScript::reload|FALHA" -A1 \
  | grep -v -E "^--$|GDScript backtrace|Failed to compile depended"
