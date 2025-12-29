#!/bin/bash
# Wallpaper rotation script for hyprpaper
# Dependencies: hyprpaper, hyprctl

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine wallpaper directory
# First try the installed location, then fallback to dev location
if [ -d "$HOME/.config/hypr/wallpapers" ]; then
    WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
else
    # Fallback to repository structure (for development)
    WALLPAPER_DIR="$(dirname "$SCRIPT_DIR")/wallpapers"
fi

# State file to track current wallpaper (per-user cache)
if [ -n "$XDG_CACHE_HOME" ]; then
    CACHE_DIR="$XDG_CACHE_HOME"
else
    CACHE_DIR="$HOME/.cache"
fi

mkdir -p "$CACHE_DIR"
STATE_FILE="$CACHE_DIR/hyprpaper_current_wallpaper"
# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Get list of all wallpapers sorted (by extension), then validate they are real image files
mapfile -t CANDIDATE_WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

WALLPAPERS=()
for candidate in "${CANDIDATE_WALLPAPERS[@]}"; do
    if command -v file >/dev/null 2>&1; then
        mime_type="$(file --mime-type -b "$candidate" 2>/dev/null || echo "")"
        if [[ "$mime_type" == image/* ]]; then
            WALLPAPERS+=("$candidate")
        fi
    else
        # Fallback: if 'file' is not available, trust the extension-based filter
        WALLPAPERS+=("$candidate")
    fi
done
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Get current wallpaper index
CURRENT_INDEX=0
CURRENT_WALLPAPER=""
if [ -f "$STATE_FILE" ]; then
    CURRENT_WALLPAPER=$(cat "$STATE_FILE")
    # Find index of current wallpaper
    FOUND_INDEX=-1
    for i in "${!WALLPAPERS[@]}"; do
        if [ "${WALLPAPERS[$i]}" = "$CURRENT_WALLPAPER" ]; then
            FOUND_INDEX=$i
            break
        fi
    done

    if [ "$FOUND_INDEX" -ge 0 ]; then
        CURRENT_INDEX=$FOUND_INDEX
    else
        # Saved wallpaper no longer exists; reset index and ignore stale state
        CURRENT_INDEX=-1
        CURRENT_WALLPAPER=""
    fi
fi

# Get next wallpaper (cycle through list)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Save current wallpaper to state file
echo "$WALLPAPER" > "$STATE_FILE"

# Set wallpaper using hyprpaper
if command -v hyprctl &> /dev/null; then
    # Preload the new wallpaper
    if hyprctl hyprpaper preload "$WALLPAPER" 2>/dev/null; then
        # Set wallpaper for all monitors
        if hyprctl hyprpaper wallpaper "",$WALLPAPER" 2>/dev/null; then
            # Unload old wallpapers to save memory
            if [ -n "$CURRENT_WALLPAPER" ] && [ "$CURRENT_WALLPAPER" != "$WALLPAPER" ]; then
                hyprctl hyprpaper unload "$CURRENT_WALLPAPER" 2>/dev/null || true
            fi
            notify-send "Wallpaper Changed" "$(basename "$WALLPAPER")"
        else
            notify-send "Error" "Failed to set wallpaper"
            exit 1
        fi
    else
        notify-send "Error" "Failed to preload wallpaper"
        exit 1
    fi
# Fallback to swww
elif command -v swww &> /dev/null; then
    swww img "$WALLPAPER" --transition-type fade --transition-duration 2
    notify-send "Wallpaper Changed" "$(basename "$WALLPAPER")"
# Fallback to swaybg
elif command -v swaybg &> /dev/null; then
    # Kill existing swaybg process for this user if running
    if pgrep -xu "$USER" swaybg > /dev/null; then
        pkill -xu "$USER" swaybg 2>/dev/null || true
    fi
    swaybg -i "$WALLPAPER" -m fill &
    notify-send "Wallpaper Changed" "$(basename "$WALLPAPER")"
else
    notify-send "Error" "No wallpaper manager found (hyprpaper, swww, or swaybg)"
    exit 1
fi
