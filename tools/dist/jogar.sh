#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"
chmod +x "$DIR/o_inicio_do_fim.x86_64" 2>/dev/null
exec "$DIR/o_inicio_do_fim.x86_64" "$@"
