#!/bin/bash
# setup_sddm.sh
# Script to install and configure the Torii SDDM theme
# Part of Zero-Drag Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Zero-Drag SDDM Theme Setup"
echo "Torii (Ricelin) Edition"
echo "========================================="
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCAL_THEME_DIR="$SCRIPT_DIR/.config/sddm/themes/torii"

if [ ! -d "$LOCAL_THEME_DIR" ]; then
    echo -e "${RED}Error: Local SDDM theme not found at $LOCAL_THEME_DIR${NC}"
    exit 1
fi

# 1. Install Dependencies
echo -e "${GREEN}Step 1: Installing dependencies...${NC}"

# Check for yay or use pacman
if command -v yay &> /dev/null; then
    PKG_MANAGER="yay"
else
    PKG_MANAGER="sudo pacman"
fi

DEPENDENCIES=(
    "qt5-graphicaleffects"
    "qt5-quickcontrols2"
    "qt5-svg"
    "xdotool"
    "xorg-xrandr"
)

$PKG_MANAGER -S --needed --noconfirm "${DEPENDENCIES[@]}"

# 2. Run the Theme Installer
echo -e "${GREEN}Step 2: Installing and selecting Torii SDDM theme...${NC}"
chmod +x "$LOCAL_THEME_DIR/install.sh"
bash "$LOCAL_THEME_DIR/install.sh"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}SDDM Setup Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "To verify the new login screen, run:"
echo "  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/torii"
echo ""
echo "Or simply reboot your system."
