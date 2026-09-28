#!/usr/bin/env bash
# Compila o jogo e gera EcosDoAbismo.jar
set -e
cd "$(dirname "$0")"
if ! command -v javac >/dev/null 2>&1; then
    echo "ERRO: 'javac' nao encontrado. Instale o JDK (versao 11 ou mais nova):"
    echo "  Ubuntu/Debian/Mint:  sudo apt install openjdk-17-jdk"
    echo "  Fedora:              sudo dnf install java-17-openjdk-devel"
    echo "  Arch/Manjaro:        sudo pacman -S jdk17-openjdk"
    exit 1
fi
rm -rf out
mkdir -p out
javac -encoding UTF-8 --release 11 -d out src/abismo/*.java
printf 'Main-Class: abismo.Main\n' > out/MANIFEST.MF
jar cfm EcosDoAbismo.jar out/MANIFEST.MF -C out abismo
echo "Pronto: EcosDoAbismo.jar  (rode ./run.sh para jogar)"
