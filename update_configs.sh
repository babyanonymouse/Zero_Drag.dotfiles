#!/bin/bash
# Script to update dotfiles without reinstalling packages

set -e

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Updating configurations..."

# Copy configurations
cp -r "$SCRIPT_DIR/.config/hypr" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fuzzel" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/swaync" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wlogout" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/quickshell" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wallust" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fastfetch" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/systemd" "$HOME/.config/"

# Copy Thunar custom actions
mkdir -p "$HOME/.config/Thunar"
cp "$SCRIPT_DIR/.config/Thunar/uca.xml" "$HOME/.config/Thunar/uca.xml" 2>/dev/null || true

# Copy .zshrc
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# Copy greeting script
mkdir -p "$HOME/scripts"
cp "$SCRIPT_DIR/scripts/torii-greeting.sh" "$HOME/scripts/torii-greeting.sh"
chmod +x "$HOME/scripts/torii-greeting.sh"

# Copy wallpapers if they exist
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    mkdir -p "$HOME/.config/hypr/wallpapers"
    cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.config/hypr/wallpapers/"
fi

# Ensure scripts are executable
if [ -d "$HOME/.config/hypr/scripts" ]; then
    chmod +x "$HOME/.config/hypr/scripts"/*
fi

echo "Configurations updated successfully."
echo "Please source ~/.zshrc manually to apply changes."
echo "You may need to reload Hyprland or run 'qs -c pill ipc show' / restarting the quickshell daemons."
