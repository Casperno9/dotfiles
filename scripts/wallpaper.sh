#!/usr/bin/env bash
# Change le fond d'écran avec swaybg.
#   wallpaper.sh            -> applique le dernier choix (ou wall.jpg)
#   wallpaper.sh moon       -> applique wallpapers/moon.jpg
#   wallpaper.sh next       -> passe au suivant
# Dossier surchargeable : WALL_DIR=~/Images/walls wallpaper.sh
set -euo pipefail

WALL_DIR="${WALL_DIR:-$HOME/.config/wallpapers}"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper"
mkdir -p "$(dirname "$STATE")"

mapfile -t walls < <(find -L "$WALL_DIR" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.png' \) ! -name 'wall.jpg' | sort)
[ "${#walls[@]}" -gt 0 ] || walls=("$WALL_DIR/wall.jpg")

current=""
[ -f "$STATE" ] && current="$(cat "$STATE")"

case "${1:-}" in
    "")   choice="${current:-${walls[0]}}" ;;
    next)
        choice="${walls[0]}"
        for i in "${!walls[@]}"; do
            if [ "${walls[$i]}" = "$current" ]; then
                choice="${walls[$(( (i + 1) % ${#walls[@]} ))]}"
                break
            fi
        done ;;
    *)
        choice="$(printf '%s\n' "${walls[@]}" | grep -m1 "/$1\.[a-z]*$" || true)"
        [ -n "$choice" ] || { echo "Fond introuvable : $1" >&2; exit 1; } ;;
esac

[ -f "$choice" ] || choice="$WALL_DIR/wall.jpg"
echo "$choice" > "$STATE"

old="$(pgrep -x swaybg || true)"
setsid swaybg -m fill -i "$choice" >/dev/null 2>&1 &
sleep 0.3
[ -z "$old" ] || kill $old 2>/dev/null || true
