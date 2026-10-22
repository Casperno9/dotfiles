#!/usr/bin/env python3
"""Génère des fonds d'écran épurés (palette Catppuccin Mocha).
Usage : python3 scripts/gen-wallpapers.py [largeur] [hauteur]
Dépendances : python-pillow, python-numpy
"""
import sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFilter

W = int(sys.argv[1]) if len(sys.argv) > 1 else 2560
H = int(sys.argv[2]) if len(sys.argv) > 2 else 1440
OUT = Path(__file__).resolve().parent.parent / "wallpapers"
OUT.mkdir(exist_ok=True)


def hex2rgb(h):
    h = h.lstrip("#")
    return np.array([int(h[i:i + 2], 16) for i in (0, 2, 4)], dtype=np.float32)


CRUST, MANTLE, BASE = hex2rgb("#11111b"), hex2rgb("#181825"), hex2rgb("#1e1e2e")
SURFACE, MAUVE, BLUE, LAV = (hex2rgb(c) for c in
                             ("#313244", "#cba6f7", "#89b4fa", "#b4befe"))
ROSEWATER = hex2rgb("#f5e0dc")

yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
xn, yn = xx / W, yy / H


def vgrad(top, bottom):
    t = yn[..., None]
    return top * (1 - t) + bottom * t


def glow(cx, cy, r, color, strength):
    d = np.sqrt(((xn - cx) * W / H) ** 2 + (yn - cy) ** 2)
    a = np.exp(-(d / r) ** 2)[..., None] * strength
    return color * a


def vignette(img, power=0.35):
    d = np.sqrt(((xn - .5) * 1.2) ** 2 + (yn - .5) ** 2)
    return img * (1 - power * np.clip(d, 0, 1)[..., None] ** 2)


def finish(img, name):
    rng = np.random.default_rng(42)
    # grain léger : évite le banding des dégradés sombres
    img = img + rng.normal(0, 1.4, img.shape[:2])[..., None]
    out = Image.fromarray(np.clip(img, 0, 255).astype(np.uint8))
    out.save(OUT / f"{name}.jpg", quality=95, subsampling=0)
    print("ok", name)


# 1. dusk : dégradé doux avec lueur mauve en bas
img = vgrad(CRUST, BASE) + glow(.5, 1.05, .55, MAUVE, .22)
finish(vignette(img), "dusk")

# 2. horizon : une ligne fine, lueur bleutée au-dessus
img = vgrad(CRUST, MANTLE)
img = img + glow(.5, .62, .35, BLUE, .16)
img[int(H * .62):] *= 0.55
line = np.exp(-((yy - H * .62) / 1.2) ** 2)[..., None] * LAV * .55
fade = np.clip(1 - np.abs(xn - .5) * 2.2, 0, 1)[..., None]
finish(vignette(img + line * fade), "horizon")

# 3. moon : grand disque flou, très discret
base = Image.new("L", (W, H), 0)
dr = ImageDraw.Draw(base)
r, cx, cy = int(H * .22), int(W * .68), int(H * .38)
dr.ellipse((cx - r, cy - r, cx + r, cy + r), fill=255)
halo = np.asarray(base.filter(ImageFilter.GaussianBlur(r * .9)),
                  dtype=np.float32)[..., None] / 255
disc = np.asarray(base.filter(ImageFilter.GaussianBlur(3)),
                  dtype=np.float32)[..., None] / 255
img = vgrad(CRUST, BASE) + halo * LAV * .16 + disc * ROSEWATER * .10
finish(vignette(img), "moon")

# 4. void : quasi uni, pour un rendu ultra-minimal
img = np.broadcast_to(MANTLE, (H, W, 3)).copy() + glow(.5, .5, .6, SURFACE, .35)
finish(vignette(img, .45), "void")
