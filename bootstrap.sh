#!/bin/bash
# Bootstrap de Kyu OS sobre una CachyOS ya instalada.
# Instala git, clona el repo y lanza el setup en un solo paso.
#
# Uso (instalacion rapida, estilo Omarchy):
#   bash <(curl -fsSL https://raw.githubusercontent.com/Johankyuk/kyu-os/main/bootstrap.sh)
#
# Acepta los mismos flags que setup_master.sh, p.ej:
#   bash <(curl -fsSL .../bootstrap.sh) --dry-run
#
# Variables opcionales:
#   KYU_OS_DIR   donde clonar el repo   (default: ~/kyu-os)
#   KYU_REF      rama o tag a clonar     (default: main)
set -euo pipefail

REPO_URL="https://github.com/Johankyuk/kyu-os.git"
DEST="${KYU_OS_DIR:-$HOME/kyu-os}"
REF="${KYU_REF:-main}"

say() { printf '\033[0;35m[kyu]\033[0m %s\n' "$1"; }
die() { printf '\033[0;31m[err]\033[0m %s\n' "$1" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] && die "No corras esto como root. Hazlo como tu usuario; el setup pedira sudo cuando lo necesite."

# 1) git presente
if ! command -v git >/dev/null 2>&1; then
    say "git no esta, instalandolo..."
    sudo pacman -S --needed --noconfirm git
fi

# 2) clonar o actualizar (idempotente: re-ejecutar no rompe nada)
if [ -d "$DEST/.git" ]; then
    say "Repo ya presente en $DEST, actualizando a origin/$REF..."
    git -C "$DEST" fetch --depth 1 origin "$REF"
    git -C "$DEST" reset --hard "origin/$REF"
else
    say "Clonando Kyu OS en $DEST..."
    git clone --depth 1 --branch "$REF" "$REPO_URL" "$DEST"
fi

# 3) registrar la ruta para que 'kyu-setup' se autolocalice despues
mkdir -p "$HOME/.config/kyu-os"
printf '%s\n' "$DEST" > "$HOME/.config/kyu-os/repo"

# 4) lanzar el setup, reenviando cualquier flag tal cual
say "Lanzando setup..."
exec bash "$DEST/setup_master.sh" "$@"
