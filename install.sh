#!/bin/bash
# Installation script for Zero-Drag Hyprland dotfiles
# Optimized for Alacritty, Fuzzel, and High Performance

set -e

echo "========================================="
echo "Zero-Drag Hyprland Dotfiles Installer"
echo "Performance Focused. Zero Bloat."
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on CachyOS (Optional but good check)
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
    "alacritty"
    "fuzzel"
    "hyprpaper"
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

echo -e "${YELLOW}Step 1a: Updating keyrings and system...${NC}"
# Update database and keyrings first to avoid 572/signature errors
$PKG_MANAGER -Sy --noconfirm archlinux-keyring
$PKG_MANAGER -S --noconfirm cachyos-keyring 2>/dev/null || true

# Perform full system upgrade to ensure compatibility
$PKG_MANAGER -Su --noconfirm

echo -e "${GREEN}Step 1b: Installing Zero-Drag packages...${NC}"
$PKG_MANAGER -S --needed --noconfirm "${PACKAGES[@]}"

echo ""
echo -e "${GREEN}Step 2: Backing up existing configurations...${NC}"
echo ""

BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing configs
for dir in hypr waybar alacritty fuzzel mako; do
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
cp -r "$SCRIPT_DIR/.config/alacritty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fuzzel" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/mako" "$HOME/.config/"
# Copy wallpapers
mkdir -p "$HOME/.config/hypr/wallpapers"
cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.config/hypr/wallpapers/"

# Ensure scripts are executable
chmod +x "$HOME/.config/hypr/scripts/"*.sh

echo ""
echo -e "${GREEN}Step 4: Setting up environment...${NC}"
echo ""

# Create Pictures directory for screenshots
mkdir -p "$HOME/Pictures"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation complete! Zero-Drag Enabled.${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Keybindings quick reference:${NC}"
echo "  SUPER + Return       - Open Terminal (Alacritty)"
echo "  SUPER + Space        - Launcher (Fuzzel)"
echo "  SUPER + Tab          - Window Switcher"
echo "  SUPER + Q            - Close Window"
echo "  SUPER + F            - Fullscreen"
echo "  SUPER + [1-9]        - Switch Workspace"
echo ""
