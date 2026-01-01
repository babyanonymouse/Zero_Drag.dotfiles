#!/bin/bash
# Script to update dotfiles without reinstalling packages

set -e

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Updating configurations..."

# Copy configurations
cp -r "$SCRIPT_DIR/.config/hypr" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/waybar" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fuzzel" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/mako" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wlogout" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wallust" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/rofi" "$HOME/.config/"
# Copy Thunar custom actions
mkdir -p "$HOME/.config/Thunar"
cp "$SCRIPT_DIR/.config/Thunar/uca.xml" "$HOME/.config/Thunar/uca.xml"
# Copy .zshrc and starship.toml
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
cp "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# Copy wallpapers if they exist
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    mkdir -p "$HOME/.config/hypr/wallpapers"
    cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.config/hypr/wallpapers/"
fi

# Copy scripts if they exist
# Scripts are already copied with .config/hypr/scripts
if [ -d "$HOME/.config/hypr/scripts" ]; then
    if compgen -G "$HOME/.config/hypr/scripts/"'*.sh' > /dev/null; then
        chmod +x "$HOME/.config/hypr/scripts/"*.sh
    fi
fi

echo "Configurations updated successfully."
echo "Configurations updated. Please source ~/.zshrc manually to apply changes."
echo "You may need to reload Hyprland (SUPER+M to exit or use hyprctl reload)"
