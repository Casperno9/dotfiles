#!/usr/bin/env bash
# Installation des dotfiles Hyprland (Arch Linux)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

PACKAGES=(
    hyprland waybar kitty wofi mako swaybg
    grim slurp wl-clipboard libnotify
    pamixer brightnessctl playerctl
    thunar ttf-jetbrains-mono-nerd
    python-pillow python-numpy
)

echo "==> Installation des paquets"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

link() {
    local src="${1%/}" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP"
        mv "$dst" "$BACKUP/"
        echo "    sauvegarde : $dst -> $BACKUP/"
    fi
    ln -sfn "$src" "$dst"
    echo "    lien : $dst"
}

echo "==> Création des liens"
for dir in "$DOTFILES"/config/*/; do
    name="$(basename "$dir")"
    link "$dir" "$CONFIG/$name"
done
link "$DOTFILES/scripts" "$CONFIG/scripts"
link "$DOTFILES/wallpapers" "$CONFIG/wallpapers"

chmod +x "$DOTFILES"/scripts/*.sh "$DOTFILES"/scripts/*.py

echo "==> Terminé."
echo "    Écran de connexion (optionnel) : ./scripts/setup-login.sh"
echo "    Puis déconnecte-toi et lance Hyprland."
