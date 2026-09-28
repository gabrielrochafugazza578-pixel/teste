#!/usr/bin/env bash
# Abre o jogo no navegador padrao.
cd "$(dirname "$0")"
if [ ! -f dist/jogo.js ]; then
    echo "dist/jogo.js nao encontrado. Rode: npm install && npm run build"
    exit 1
fi
URL="file://$(pwd)/index.html"
if command -v xdg-open >/dev/null 2>&1; then xdg-open "$URL"
elif command -v open >/dev/null 2>&1; then open "$URL"
else echo "Abra no navegador: $URL"; fi
