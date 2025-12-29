#!/bin/bash
# Installation script for minimal Hyprland dotfiles on CachyOS

set -e

echo "========================================="
echo "Minimal Hyprland Dotfiles Installer"
echo "For CachyOS - Developer Edition"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on CachyOS
if [ ! -f /etc/cachyos-release ]; then
    echo -e "${YELLOW}Warning: This script is optimized for CachyOS${NC}"
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}Step 1: Installing required packages...${NC}"
echo ""

# Core packages
PACKAGES=(
    "hyprland"
    "waybar"
    "kitty"
    "wofi"
    "mako"
    "polkit-gnome"
    "xdg-desktop-portal-hyprland"
    "qt5ct"
    "grim"
    "slurp"
    "wl-clipboard"
    "brightnessctl"
    "playerctl"
    "pamixer"
    "wireplumber"
    "thunar"
    "ttf-jetbrains-mono-nerd"
)

# Check if yay is available, otherwise use pacman
if command -v yay &> /dev/null; then
    PKG_MANAGER="yay"
else
    PKG_MANAGER="sudo pacman"
fi

echo "Using package manager: $PKG_MANAGER"
$PKG_MANAGER -S --needed --noconfirm "${PACKAGES[@]}"

echo ""
echo -e "${GREEN}Step 2: Backing up existing configurations...${NC}"
echo ""

BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing configs
for dir in hypr waybar kitty wofi mako; do
    if [ -d "$HOME/.config/$dir" ]; then
        echo "Backing up $dir..."
        mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

echo "Backup created at: $BACKUP_DIR"

echo ""
echo -e "${GREEN}Step 3: Installing dotfiles...${NC}"
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy configurations
echo "Copying configurations..."
cp -r "$SCRIPT_DIR/.config/hypr" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/waybar" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wofi" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/mako" "$HOME/.config/"

echo ""
echo -e "${GREEN}Step 4: Setting up environment...${NC}"
echo ""

# Create Pictures directory for screenshots
mkdir -p "$HOME/Pictures"

# Set permissions
chmod +x "$HOME/.config/hypr/hyprland.conf"
chmod +x "$HOME/.config/hypr/keybinds.conf"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Log out of your current session"
echo "2. Select 'Hyprland' from your display manager"
echo "3. Log in and enjoy your minimal setup!"
echo ""
echo -e "${YELLOW}Keybindings quick reference:${NC}"
echo "  SUPER + Return       - Open terminal (Kitty)"
echo "  SUPER + D            - Application launcher (Wofi)"
echo "  SUPER + Q            - Close window"
echo "  SUPER + M            - Exit Hyprland"
echo "  SUPER + F            - Fullscreen"
echo "  SUPER + [1-5]        - Switch workspace"
echo "  SUPER + h/j/k/l      - Move focus (vim keys)"
echo ""
echo -e "For more keybindings, see: ${GREEN}~/.config/hypr/keybinds.conf${NC}"
echo ""
