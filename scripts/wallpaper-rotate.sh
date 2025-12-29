#!/bin/bash
# Wallpaper rotation script
# Dependencies: swww (or swaybg/hyprpaper)

WALLPAPER_DIR="$HOME/my_dotfiles/wallpapers"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Find a random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set wallpaper using swww
if command -v swww &> /dev/null; then
    swww img "$WALLPAPER" --transition-type fade --transition-duration 2
    notify-send "Wallpaper Changed" "$(basename "$WALLPAPER")"
# Fallback to swaybg
elif command -v swaybg &> /dev/null; then
    killall swaybg
    swaybg -i "$WALLPAPER" -m fill &
    notify-send "Wallpaper Changed" "$(basename "$WALLPAPER")"
else
    notify-send "Error" "No wallpaper manager found (swww or swaybg)"
    exit 1
fi
