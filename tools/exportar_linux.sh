#!/usr/bin/env bash
# Gera o executavel para Linux em build/linux/TerraRedonda.x86_64 e o pacote
# build/TerraRedonda-linux-x86_64.tar.gz
# Precisa da Godot 4.7.2 e dos "export templates" do Linux instalados
# (Editor > Gerenciar Templates de Exportacao, ou ~/.local/share/godot/export_templates/4.7.2.stable/).
set -e
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
mkdir -p build/linux
"$GODOT" --headless --path . --export-release "Linux" build/linux/TerraRedonda.x86_64
rm -rf build/pacote && mkdir -p build/pacote/TerraRedonda
cp build/linux/TerraRedonda.x86_64 build/pacote/TerraRedonda/
cp tools/LEIA-ME.txt build/pacote/TerraRedonda/
chmod +x build/pacote/TerraRedonda/TerraRedonda.x86_64
tar -C build/pacote -czf build/TerraRedonda-linux-x86_64.tar.gz TerraRedonda
echo "Pronto: build/TerraRedonda-linux-x86_64.tar.gz"
