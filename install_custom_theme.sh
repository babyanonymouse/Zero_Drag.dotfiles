#!/usr/bin/env bash
# install_custom_theme.sh
# Script to install nwg-look, Gently Color GTK theme, and YAMIS icons.
# Part of Zero-Drag Dotfiles

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Zero-Drag GTK Theme & Icon Installer${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 1. Install Prerequisites
echo -e "${GREEN}==> Checking Prerequisites...${NC}"

# Check and install nwg-look via yay/pacman
if ! command -v nwg-look &> /dev/null; then
    if command -v yay &> /dev/null; then
        echo "nwg-look not found. Installing via yay..."
        yay -S --noconfirm nwg-look
    else
        echo -e "${YELLOW}Warning: yay not found. Please install nwg-look manually via your AUR helper.${NC}"
    fi
else
    echo "nwg-look is already installed."
fi

# Create standard local directories
echo "Creating ~/.themes and ~/.icons..."
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.icons"

# 2. Fetch the Assets
echo -e "${GREEN}==> Fetching Theme Assets...${NC}"

DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

GENTLY_SRC="$DOWNLOAD_DIR/Gently-Color-GTK"
YAMIS_SRC="$DOWNLOAD_DIR/YAMIS"

# --- Clone Gently Theme ---
if [ -d "$GENTLY_SRC" ]; then
    echo "Found local Gently-Color-GTK in Downloads. Updating..."
    git -C "$GENTLY_SRC" pull || true
else
    echo "Cloning Gently-Color-Plasma-Themes from GitHub..."
    git clone https://github.com/L4ki/Gently-Color-Plasma-Themes.git "$GENTLY_SRC"
fi

# --- Clone YAMIS Icons ---
if [ -d "$YAMIS_SRC" ]; then
    echo "Found local YAMIS in Downloads. Updating..."
    git -C "$YAMIS_SRC" pull || true
else
    echo "Cloning YAMIS icons from Bitbucket..."
    git clone https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git "$YAMIS_SRC"
fi

# 3. Installation
echo -e "${GREEN}==> Installing Themes to ~/.themes and ~/.icons...${NC}"

# --- Install Gently GTK Themes ---
if [ -d "$GENTLY_SRC" ]; then
    echo "Searching for GTK themes in $GENTLY_SRC..."
    # Locate directories containing index.theme or gtk-3.0
    FOUND_THEMES=$(find "$GENTLY_SRC" -name "index.theme" -o -type d -name "gtk-3.0")
    if [ -n "$FOUND_THEMES" ]; then
        # Use find to locate subfolders that are actual theme directories
        find "$GENTLY_SRC" -type d -name "gtk-3.0" | while read -r gtk_dir; do
            THEME_ROOT=$(dirname "$gtk_dir")
            THEME_NAME=$(basename "$THEME_ROOT")
            # Avoid copying the entire clone root
            if [ "$THEME_NAME" != "Gently-Color-GTK" ] && [ "$THEME_NAME" != "Downloads" ]; then
                echo "Installing theme: $THEME_NAME"
                rm -rf "$HOME/.themes/$THEME_NAME"
                cp -r "$THEME_ROOT" "$HOME/.themes/"
            fi
        done
    else
        echo -e "${YELLOW}WARNING: No GTK themes found in $GENTLY_SRC${NC}"
    fi
fi

# --- Install YAMIS Icons ---
if [ -d "$YAMIS_SRC" ]; then
    echo "Searching for icons in $YAMIS_SRC..."
    find "$YAMIS_SRC" -name "index.theme" | while read -r icon_file; do
        ICON_ROOT=$(dirname "$icon_file")
        ICON_NAME=$(basename "$ICON_ROOT")
        if [ "$ICON_NAME" != "yet-another-monochrome-icon-set" ]; then
            echo "Installing icon set: $ICON_NAME"
            rm -rf "$HOME/.icons/$ICON_NAME"
            cp -r "$ICON_ROOT" "$HOME/.icons/"
        fi
    done
else
    echo -e "${YELLOW}WARNING: Icon source not found. Skipping icon set install.${NC}"
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Theme Assets Installation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo "Run 'nwg-look' to select the newly installed GTK theme and icon sets."
echo "Suggested theme: 'Gently-Color-GTK' (or similar variant)"
echo "Suggested icon theme: 'Monochrome-Icons' / 'YAMIS'"
echo ""
