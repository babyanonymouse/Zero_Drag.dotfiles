#!/bin/bash
set -e

# 1. Install Prerequisites
echo "==> Checking Prerequisites..."

# Check and install nwg-look
if ! command -v nwg-look &> /dev/null; then
    echo "nwg-look not found. Installing via yay..."
    yay -S --noconfirm nwg-look
else
    echo "nwg-look is already installed."
fi

# Create standard directories
echo "Creating ~/.themes and ~/.icons..."
mkdir -p ~/.themes
mkdir -p ~/.icons

# 2. Fetch the Assets
echo "==> Fetching Assets..."

# 2. Fetch Assets
echo "==> Fetching Assets..."

DOWNLOAD_DIR="$HOME/Downloads"
mkdir -p "$DOWNLOAD_DIR"

GENTLY_SRC="$DOWNLOAD_DIR/Gently-Color-GTK"
YAMIS_SRC="$DOWNLOAD_DIR/YAMIS"

# --- Gently Theme ---
if [ -d "$GENTLY_SRC" ]; then
    echo "Found local Gently-Color-GTK in Downloads."
else
    echo "Gently-Color-GTK not found locally. Cloning from GitHub..."
    git clone https://github.com/L4ki/Gently-Color-Plasma-Themes.git "$GENTLY_SRC"
fi

# --- YAMIS Icons ---
if [ -d "$YAMIS_SRC" ]; then
    echo "Found local YAMIS in Downloads."
else
    echo "YAMIS not found locally. Cloning from Bitbucket..."
    git clone https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git "$YAMIS_SRC"
fi

# 3. Application
echo "==> Installing Themes..."

# --- Install Gently Theme ---
if [ -d "$GENTLY_SRC" ]; then
    echo "Searching for themes in $GENTLY_SRC..."
    
    # Method 1: Look for index.theme
    FOUND_THEMES=$(find "$GENTLY_SRC" -name "index.theme")
    
    # Method 2: Look for gtk-3.0 (fallback if index.theme is missing)
    if [ -z "$FOUND_THEMES" ]; then
        echo "No index.theme found. Checking for gtk-3.0 folder..."
        FOUND_THEMES=$(find "$GENTLY_SRC" -type d -name "gtk-3.0")
    fi

    if [ -n "$FOUND_THEMES" ]; then
        echo "$FOUND_THEMES" | while read -r marker_file; do
            # If marker is index.theme, root is dirname.
            # If marker is gtk-3.0 dir, root is dirname of that dir.
            if [[ "$(basename "$marker_file")" == "gtk-3.0" ]]; then
                 THEME_ROOT=$(dirname "$marker_file")
            else
                 THEME_ROOT=$(dirname "$marker_file")
            fi
            
            THEME_NAME=$(basename "$THEME_ROOT")
            
            echo "Found theme candidate: $THEME_NAME"
            echo "Copying to ~/.themes/..."
            rm -rf "$HOME/.themes/$THEME_NAME"
            cp -r "$THEME_ROOT" "$HOME/.themes/"
        done
    else
        echo "WARNING: Could not detect a valid theme structure (no index.theme or gtk-3.0) in $GENTLY_SRC"
    fi
else
    echo "WARNING: $GENTLY_SRC does not exist. Please ensure the folder is present."
fi

# --- Install YAMIS Icons ---
if [ -d "$YAMIS_SRC" ]; then
    echo "Searching for icons in $YAMIS_SRC..."
    find "$YAMIS_SRC" -name "index.theme" | while read -r icon_file; do
        ICON_ROOT=$(dirname "$icon_file")
        ICON_NAME=$(basename "$ICON_ROOT")
        
        echo "Found icon set: $ICON_NAME"
        echo "Copying to ~/.icons/..."
        rm -rf "$HOME/.icons/$ICON_NAME" # overwrite
        cp -r "$ICON_ROOT" "$HOME/.icons/"
    done
else
    echo "WARNING: $YAMIS_SRC does not exist. Please ensure the folder is present."
fi

echo ""
echo "========================================"
echo "Installation Complete!"
echo "Run 'nwg-look' and select 'Gently-Color-GTK' (or similar) and 'Monochrome-Icons' to finish."
echo "========================================"
