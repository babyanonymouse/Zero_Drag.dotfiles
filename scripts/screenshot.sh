#!/bin/bash
# Screenshot script for Hyprland
# Dependencies: grim, slurp, wl-clipboard, libnotify

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

case "$1" in
    full)
        # Full screen screenshot
        grim "$FILENAME"
        notify-send "Screenshot" "Full screen saved to $FILENAME"
        ;;
    selection)
        # Selection area screenshot
        grim -g "$(slurp)" "$FILENAME"
        notify-send "Screenshot" "Selection saved to $FILENAME"
        ;;
    window)
        # Active window screenshot
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
        notify-send "Screenshot" "Window saved to $FILENAME"
        ;;
    clipboard)
        # Screenshot to clipboard
        grim - | wl-copy
        notify-send "Screenshot" "Copied to clipboard"
        ;;
    *)
        echo "Usage: $0 {full|selection|window|clipboard}"
        exit 1
        ;;
esac
