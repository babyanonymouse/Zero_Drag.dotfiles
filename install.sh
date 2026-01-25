#!/bin/bash
# Installation script for Zero-Drag Hyprland dotfiles
# Optimized for Kitty, Fuzzel, and High Performance

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
    "kitty"
    "fuzzel"
    "hyprpaper"
    "mako"
    "polkit-gnome"
    "xdg-desktop-portal-hyprland"
    "qt5ct"
    "libappindicator-gtk3"
    "grim"
    "slurp"
    "wl-clipboard"
    "brightnessctl"
    "playerctl"
    "pamixer"
    "wireplumber"
    "thunar"
    "thunar-archive-plugin"
    "thunar-volman"
    "file-roller"
    "gvfs"
    "gvfs"
    "papirus-icon-theme"
    "xdg-utils"
    "ttf-jetbrains-mono-nerd"
    "wlogout"
    "batsignal"
    "batsignal"
    "starship"
    "eza"
    "bat"
    "zoxide"
    "ripgrep"
    "fzf"
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-completions"
    "cliphist"
    "hyprlock"
    "hypridle"
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

echo -e "${YELLOW}Step 1c: Removing conflicting file managers...${NC}"
# Remove Nautilus and Dolphin if present
for pkg in nautilus dolphin dolphin-plugins; do
    if pacman -Qi $pkg &> /dev/null; then
        echo "Removing $pkg..."
        sudo pacman -Rns --noconfirm $pkg || true
    fi
done

echo -e "${GREEN}Step 1b: Installing Zero-Drag packages...${NC}"
$PKG_MANAGER -S --needed --noconfirm "${PACKAGES[@]}"

echo ""


echo ""
echo -e "${GREEN}Step 2: Backing up existing configurations...${NC}"
echo ""

BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing configs
for dir in hypr waybar kitty fuzzel mako wlogout; do
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
cp -r "$SCRIPT_DIR/.config/fuzzel" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/mako" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wlogout" "$HOME/.config/"


# Copy starship config
cp "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
# Copy .zshrc
echo "Copying .zshrc..."
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
# Copy wallpapers
mkdir -p "$HOME/.config/hypr/wallpapers"
cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.config/hypr/wallpapers/"
# Copy scripts
# Scripts are already copied with .config/hypr
chmod +x "$HOME/.config/hypr/scripts/"* 2>/dev/null || true

# Ensure scripts are executable
chmod +x "$HOME/.config/hypr/scripts/"*.sh

echo ""
echo -e "${GREEN}Step 4: Setting up environment...${NC}"
echo ""

# Create Pictures directory for screenshots
# Create Pictures directory for screenshots
mkdir -p "$HOME/Pictures"

# Set Thunar as default file manager
xdg-mime default thunar.desktop inode/directory

# Apply GTK Theme and Icon Theme
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation complete! Zero-Drag Enabled.${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Keybindings quick reference:${NC}"
echo "  SUPER + Return       - Open Terminal (Kitty)"
echo "  SUPER + E            - File Manager (Thunar)"
echo "  SUPER + Space        - Launcher (Fuzzel)"
echo "  SUPER + Tab          - Window Switcher (Cycling)"
echo "  ALT + Tab            - Window Switcher (Graphical)"
echo "  SUPER + Q            - Close Window"
echo "  SUPER + F            - Fullscreen"
echo "  SUPER + W            - Cycle Wallpapers"
echo "  SUPER + [1-9]        - Switch Workspace"
echo ""
