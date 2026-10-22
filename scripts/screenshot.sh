#!/usr/bin/env bash
# Capture d'écran : screenshot.sh area (zone) | full (écran entier)
set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y%m%d-%H%M%S).png"

case "${1:-area}" in
    area) geom="$(slurp)" || exit 0
          grim -g "$geom" "$FILE" ;;
    full) grim "$FILE" ;;
    *)    echo "Usage : $0 [area|full]" >&2; exit 1 ;;
esac

wl-copy < "$FILE"
notify-send "Capture d'écran" "$FILE"
