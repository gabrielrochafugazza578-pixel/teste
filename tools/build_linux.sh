#!/usr/bin/env bash
# Build Linux do "O Início do Fim".
#  - Com export templates 4.7.2 instalados: executável completo (export-release).
#  - Sem templates: empacota em .pck e gera um lançador que usa o binário oficial
#    do Godot 4.7.2 (o mesmo runtime; nada é baixado de terceiros).
# Uso: GODOT=/caminho/godot tools/build_linux.sh
set -e
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."
OUT=build/linux
mkdir -p "$OUT"
"$GODOT" --headless --path . --import >/dev/null 2>&1 || true
if "$GODOT" --headless --path . --export-release "Linux" "$OUT/o_inicio_do_fim.x86_64" >/dev/null 2>&1 && [ -f "$OUT/o_inicio_do_fim.x86_64" ]; then
	# pacote para distribuir: executável + .pck + lançador + LEIA-ME + licenças de terceiros
	PKG=O_Inicio_do_Fim_Linux
	rm -rf "build/$PKG" "build/$PKG.tar.gz"
	mkdir -p "build/$PKG"
	cp "$OUT/o_inicio_do_fim.x86_64" "$OUT/o_inicio_do_fim.pck" tools/dist/jogar.sh tools/dist/LEIA-ME.txt "build/$PKG/"
	mkdir -p "build/$PKG/licencas"
	cp assets/textures/grass_bush_LICENSE.txt "build/$PKG/licencas/SimpleGrassTextured_MIT.txt"
	chmod +x "build/$PKG/o_inicio_do_fim.x86_64" "build/$PKG/jogar.sh"
	tar -C build -czf "build/$PKG.tar.gz" "$PKG"
	echo "Executável: $OUT/o_inicio_do_fim.x86_64"
	echo "Pacote: build/$PKG.tar.gz"
	exit 0
fi
echo "Export templates ausentes: gerando .pck + lançador."
"$GODOT" --headless --path . --export-pack "Linux" "$OUT/o_inicio_do_fim.pck"
cp "$(command -v "$GODOT" || echo "$GODOT")" "$OUT/godot_runtime.x86_64"
cat > "$OUT/o_inicio_do_fim.sh" <<'SH'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$DIR/godot_runtime.x86_64" --main-pack "$DIR/o_inicio_do_fim.pck" "$@"
SH
chmod +x "$OUT/o_inicio_do_fim.sh" "$OUT/godot_runtime.x86_64"
echo "Pronto: $OUT/o_inicio_do_fim.sh"
