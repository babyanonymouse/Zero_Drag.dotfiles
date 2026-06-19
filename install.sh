#!/bin/bash
# Installation script for Zero-Drag Hyprland dotfiles
# Optimized for Kitty, Quickshell, and High Performance
# Part of Zero-Drag Dotfiles

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
    "kitty"
    "fuzzel"
    "swaync"
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
    "flat-remix-gtk"
    "papirus-icon-theme"
    "xdg-utils"
    "ttf-jetbrains-mono-nerd"
    "wlogout"
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
    "gthumb"
    "hyprpicker"
    "imagemagick"
    "swww"
    "wallust"
    "xdotool"
    "xorg-xrandr"
    "jq"
)

# Check if yay is available, otherwise use pacman
if command -v yay &> /dev/null; then
    PKG_MANAGER="yay"
else
    PKG_MANAGER="sudo pacman"
fi

echo "Using package manager: $PKG_MANAGER"

echo -e "${YELLOW}Step 1a: Updating keyrings and system...${NC}"
# Update database and keyrings first to avoid signature errors
$PKG_MANAGER -Sy --noconfirm archlinux-keyring
$PKG_MANAGER -S --noconfirm cachyos-keyring 2>/dev/null || true

# Perform full system upgrade to ensure compatibility
$PKG_MANAGER -Su --noconfirm

echo -e "${YELLOW}Step 1b: Removing conflicting file managers...${NC}"
# Remove Nautilus and Dolphin if present to stick to Thunar
for pkg in nautilus dolphin dolphin-plugins; do
    if pacman -Qi $pkg &> /dev/null; then
        echo "Removing $pkg..."
        sudo pacman -Rns --noconfirm $pkg || true
    fi
done

echo -e "${GREEN}Step 1c: Installing Zero-Drag packages...${NC}"
$PKG_MANAGER -S --needed --noconfirm "${PACKAGES[@]}"

# Install quickshell-git from AUR if yay is available
if [ "$PKG_MANAGER" = "yay" ]; then
    echo -e "${GREEN}Step 1d: Installing quickshell-git from the AUR...${NC}"
    yay -S --needed --noconfirm quickshell-git
else
    echo -e "${YELLOW}Warning: yay not found. Please install quickshell-git manually from the AUR.${NC}"
fi

# Set up swww (awww) symlinks so the wallpaper transition scripts work flawlessly
echo -e "${GREEN}Step 1e: Creating swww (awww) symlinks...${NC}"
sudo ln -sf /usr/bin/swww /usr/bin/awww
sudo ln -sf /usr/bin/swww-daemon /usr/bin/awww-daemon

echo ""
echo -e "${GREEN}Step 2: Backing up existing configurations...${NC}"
echo ""

BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing configs
for dir in hypr kitty fuzzel swaync wlogout quickshell wallust fastfetch systemd; do
    if [ -d "$HOME/.config/$dir" ]; then
        echo "Backing up $dir..."
        mv "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
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
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fuzzel" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/swaync" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wlogout" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/gtk-3.0" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/gtk-4.0" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/quickshell" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/wallust" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/fastfetch" "$HOME/.config/"
cp -r "$SCRIPT_DIR/.config/systemd" "$HOME/.config/"

# Copy starship config
cp "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# Copy .zshrc
echo "Copying .zshrc..."
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# Copy greeting script
echo "Copying Zsh greeting script..."
mkdir -p "$HOME/scripts"
cp "$SCRIPT_DIR/scripts/torii-greeting.sh" "$HOME/scripts/torii-greeting.sh"
chmod +x "$HOME/scripts/torii-greeting.sh"

# Copy wallpapers
mkdir -p "$HOME/.config/hypr/wallpapers"
cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME/.config/hypr/wallpapers/"

# Ensure all scripts are executable
chmod +x "$HOME/.config/hypr/scripts"/*

echo ""
echo -e "${GREEN}Step 4: Setting up environment...${NC}"
echo ""

# Create Pictures directory for screenshots
mkdir -p "$HOME/Pictures"

# Set Thunar as default file manager
xdg-mime default thunar.desktop inode/directory

# Apply GTK Theme and Icon Theme
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"

# Run SDDM Setup Script
echo -e "${GREEN}Step 5: Running SDDM theme setup...${NC}"
bash "$SCRIPT_DIR/setup_sddm.sh"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Installation complete! Zero-Drag Enabled.${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Keybindings quick reference:${NC}"
echo "  SUPER + Return       - Open Terminal (Kitty)"
  echo "  SUPER + E            - File Manager (Thunar)"
  echo "  SUPER + Space        - Launcher (Quickshell QML Launcher)"
  echo "  SUPER + V            - Clipboard History (Quickshell QML Clipboard)"
  echo "  SUPER + C            - Wallpaper Picker (Quickshell QML Picker)"
  echo "  SUPER + B            - Shuffle Wallpaper & Sync Colors (swww + wallust)"
  echo "  SUPER + L            - Lock Screen (Quickshell blurred lock overlay)"
  echo "  SUPER + T            - Toggle Floating Window"
  echo "  Print                - Screenshot Overlay (rishot)"
  echo "  SUPER + [1-9]        - Switch Workspace"
echo ""
echo -e "${YELLOW}Please source ~/.zshrc or open a new terminal to see the greeting!${NC}"
echo -e "${YELLOW}We recommend logging out and back in to load the new Hyprland Lua environment.${NC}"
echo ""
