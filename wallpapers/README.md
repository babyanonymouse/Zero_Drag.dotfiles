# Wallpapers

This directory contains wallpapers for your Hyprland setup.

## Overview

Store your wallpaper images here for use with wallpaper managers like `hyprpaper`, `swaybg`, or `swww`.

## Usage

### With Hyprpaper

Create a `~/.config/hypr/hyprpaper.conf` file:
```conf
preload = ~/my_dotfiles/wallpapers/wallpaper.jpg
wallpaper = ,~/my_dotfiles/wallpapers/wallpaper.jpg
```

Then add to Hyprland's autostart:
```conf
exec-once = hyprpaper
```

### With swaybg
```bash
exec-once = swaybg -i ~/my_dotfiles/wallpapers/wallpaper.jpg -m fill
```

### With swww (Animated wallpapers)
```bash
exec-once = swww init
exec-once = swww img ~/my_dotfiles/wallpapers/wallpaper.jpg
```

## Organization

You can organize wallpapers in subdirectories:
```
wallpapers/
├── nature/
├── abstract/
├── minimal/
└── anime/
```

## Supported Formats

- PNG
- JPG/JPEG
- WebP
- GIF (with swww for animation)

## Recommended Sources

- [Wallhaven](https://wallhaven.cc/)
- [Unsplash](https://unsplash.com/)
- [Pexels](https://www.pexels.com/)
- [r/wallpapers](https://reddit.com/r/wallpapers)
- [r/Hyprland](https://reddit.com/r/Hyprland) - Community shares

## Tips

- **Resolution**: Use wallpapers matching or exceeding your monitor resolution
- **Aspect Ratio**: Match your monitor's aspect ratio for best results
- **File Size**: Optimize large images to reduce memory usage
- **Multiple Monitors**: Configure different wallpapers per monitor in hyprpaper.conf

## Dynamic Wallpapers

Create a script to change wallpapers automatically:

```bash
#!/bin/bash
# ~/my_dotfiles/scripts/wallpaper-rotate.sh
WALLPAPER_DIR=~/my_dotfiles/wallpapers
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
swww img "$WALLPAPER" --transition-type fade --transition-duration 2
```

Add to crontab or use a timer to run periodically.
