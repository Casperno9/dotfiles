#!/usr/bin/env bash
# Installe greetd + tuigreet et active un écran de connexion sobre.
# Usage : ./scripts/setup-login.sh   (demande sudo)
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$DIR/system/greetd/config.toml"
DST="/etc/greetd/config.toml"

[ -f "$SRC" ] || { echo "Introuvable : $SRC" >&2; exit 1; }

echo "==> Installation de greetd et tuigreet"
sudo pacman -S --needed --noconfirm greetd greetd-tuigreet

echo "==> Sauvegarde puis copie de la configuration"
[ -f "$DST" ] && sudo cp "$DST" "$DST.bak.$(date +%s)"
sudo install -Dm644 "$SRC" "$DST"

echo "==> Activation du service"
# Désactive un éventuel autre display manager pour éviter les conflits
for dm in sddm gdm lightdm ly; do
    if systemctl is-enabled "$dm.service" &>/dev/null; then
        echo "    désactivation de $dm"
        sudo systemctl disable "$dm.service"
    fi
done
sudo systemctl enable greetd.service

echo "Terminé. Redémarre pour voir l'écran de connexion."
