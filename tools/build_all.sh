#!/usr/bin/env bash
# Pacote único Windows + Linux do "O Início do Fim".
# Exporta as duas versões (export templates 4.7.2 de Linux e Windows instalados)
# e junta num .zip: Windows/ e Linux/ lado a lado, LEIA-ME e licenças na raiz.
# Uso: GODOT=/caminho/godot tools/build_all.sh
set -e
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."
"$GODOT" --headless --path . --import >/dev/null 2>&1 || true
mkdir -p build/linux build/windows
rm -f build/linux/* build/windows/*
"$GODOT" --headless --path . --export-release "Linux" build/linux/o_inicio_do_fim.x86_64 >/dev/null 2>&1
"$GODOT" --headless --path . --export-release "Windows Desktop" "build/windows/O Inicio do Fim.exe" >/dev/null 2>&1
for f in build/linux/o_inicio_do_fim.x86_64 build/linux/o_inicio_do_fim.pck "build/windows/O Inicio do Fim.exe" "build/windows/O Inicio do Fim.pck"; do
	[ -f "$f" ] || { echo "Falhou a exportação: $f (faltam os export templates?)"; exit 1; }
done
PKG=O_Inicio_do_Fim
rm -rf "build/$PKG" "build/${PKG}_Windows_e_Linux.zip"
mkdir -p "build/$PKG/Linux" "build/$PKG/Windows" "build/$PKG/licencas"
cp build/linux/o_inicio_do_fim.x86_64 build/linux/o_inicio_do_fim.pck tools/dist/jogar.sh "build/$PKG/Linux/"
cp "build/windows/O Inicio do Fim.exe" "build/windows/O Inicio do Fim.pck" "build/$PKG/Windows/"
cp tools/dist/LEIA-ME.txt "build/$PKG/"
# cópia do LEIA-ME com quebras de linha do Windows dentro da pasta Windows
sed 's/$/\r/' tools/dist/LEIA-ME.txt > "build/$PKG/Windows/LEIA-ME.txt"
cp assets/textures/grass_bush_LICENSE.txt "build/$PKG/licencas/SimpleGrassTextured_MIT.txt"
chmod +x "build/$PKG/Linux/o_inicio_do_fim.x86_64" "build/$PKG/Linux/jogar.sh"
# zip que guarda a permissão de execução do Linux (o Gerenciador de Arquivos respeita)
python3 - "build/$PKG" "build/${PKG}_Windows_e_Linux.zip" <<'PY'
import os, sys, zipfile
src, dst = sys.argv[1], sys.argv[2]
root = os.path.dirname(src)
with zipfile.ZipFile(dst, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
    for d, _, files in os.walk(src):
        for f in sorted(files):
            p = os.path.join(d, f)
            info = zipfile.ZipInfo.from_file(p, os.path.relpath(p, root))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3   # Unix: mantém os bits de execução
            info.external_attr = (os.stat(p).st_mode & 0xFFFF) << 16
            with open(p, "rb") as fh:
                z.writestr(info, fh.read(), compresslevel=9)
PY
# o .tar.gz só do Linux continua disponível
GODOT="$GODOT" tools/build_linux.sh >/dev/null 2>&1 || true
echo "Pacote: build/${PKG}_Windows_e_Linux.zip"
ls -la "build/${PKG}_Windows_e_Linux.zip"
