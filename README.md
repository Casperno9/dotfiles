# Dotfiles Hyprland

Configuration légère de **Hyprland** sur **Arch Linux** : barre Waybar, raccourcis clavier, notifications, fonds d'écran épurés, écran de connexion sobre et scripts utilitaires.

## Contenu

- **Hyprland** : gestionnaire de fenêtres Wayland (gaps, bordures, animations)
- **Waybar** : barre avec workspaces, horloge, audio, réseau, batterie
- **Keybinds** : raccourcis dans un fichier séparé (`keybinds.conf`)
- **Kitty** : terminal (thème Catppuccin Mocha)
- **Mako** : notifications
- **Wallpapers** : 4 fonds épurés (dusk, horizon, moon, void), changement avec `Super + W`
- **Login manager** : greetd + tuigreet, thème sobre (optionnel)
- **Scripts** : capture d'écran, changement de fond, installation du login manager

## Arborescence

```
dotfiles/
├── README.md
├── install.sh
├── .gitignore
├── config/
│   ├── hypr/      (hyprland.conf, keybinds.conf)
│   ├── waybar/    (config.jsonc, style.css)
│   ├── kitty/     (kitty.conf)
│   └── mako/      (config)
├── scripts/       (screenshot.sh, wallpaper.sh, setup-login.sh, gen-wallpapers.py)
├── system/
│   └── greetd/    (config.toml)
└── wallpapers/    (dusk, horizon, moon, void, wall.jpg)
```

## Installation

```
git clone https://github.com/Casperno9/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

Les anciennes configurations sont sauvegardées dans `~/.config-backup-*`.

### Écran de connexion (optionnel)

```
./scripts/setup-login.sh
```

Installe `greetd` et `greetd-tuigreet`, copie `system/greetd/config.toml` dans `/etc/greetd/` (l'ancien fichier est sauvegardé) et active le service. tuigreet est en mode texte : il n'affiche pas d'image.

## Raccourcis principaux

| Raccourci             | Action                      |
|-----------------------|-----------------------------|
| `Super + Entrée`      | Terminal                    |
| `Super + D`           | Lanceur d'applications      |
| `Super + Q`           | Fermer la fenêtre           |
| `Super + F`           | Plein écran                 |
| `Super + V`           | Mode flottant               |
| `Super + W`           | Fond d'écran suivant        |
| `Super + & é " ' (`   | Workspaces 1 à 5 (AZERTY)   |
| `Impr` / `Maj + Impr` | Capture zone / écran entier |

## Dépendances

hyprland, waybar, kitty, wofi, mako, swaybg, grim, slurp, wl-clipboard, libnotify, pamixer, brightnessctl, playerctl, thunar, ttf-jetbrains-mono-nerd, python-pillow, python-numpy

Pour l'écran de connexion : greetd, greetd-tuigreet (installés par `setup-login.sh`).

## Personnalisation

- Fonds d'écran : `scripts/wallpaper.sh moon` (ou `next`). Pour en régénérer : `python3 scripts/gen-wallpapers.py 1920 1080`. `wall.jpg` est le fond utilisé par défaut.
- Le clavier est en AZERTY (`kb_layout = fr`).
- Si Hyprland affiche un avertissement au lancement depuis tuigreet, remplace `--cmd Hyprland` par `--cmd start-hyprland` dans `system/greetd/config.toml` si ta version le fournit.
