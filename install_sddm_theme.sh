#!/bin/bash
# SDDM Theme Installation Script for Zero-Drag Hyprland dotfiles
# Installs Catppuccin Mocha theme to match the desktop environment

set -e

echo "========================================="
echo "SDDM Catppuccin Mocha Theme Installer"
echo "Zero-Drag Login Screen Theme"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: This script must be run as root or with sudo${NC}"
    echo "Usage: sudo ./install_sddm_theme.sh"
    exit 1
fi

# Store the real user's home directory (in case script is run with sudo)
if [ -n "$SUDO_USER" ]; then
    REAL_USER="$SUDO_USER"
    REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    REAL_USER="$USER"
    REAL_HOME="$HOME"
fi

echo -e "${GREEN}Step 1: Installing Qt5 dependencies for SDDM themes...${NC}"
echo ""

# Install required Qt5 modules
DEPENDENCIES=(
    "qt5-graphicaleffects"
    "qt5-quickcontrols2"
    "qt5-svg"
    "sddm"
)

echo "Installing: qt5-graphicaleffects qt5-quickcontrols2 qt5-svg sddm"
pacman -S --needed --noconfirm "${DEPENDENCIES[@]}"

echo ""
echo -e "${GREEN}Step 2: Installing Catppuccin Mocha theme...${NC}"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Clone the Catppuccin SDDM repository
echo "Cloning Catppuccin SDDM theme repository..."
if ! git clone https://github.com/catppuccin/sddm.git "$TEMP_DIR/catppuccin-sddm"; then
    echo -e "${RED}Error: Failed to clone the theme repository${NC}"
    echo "Please check your internet connection and try again."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Create themes directory if it doesn't exist
mkdir -p /usr/share/sddm/themes/

# Copy the Mocha theme
echo "Installing catppuccin-mocha theme..."
cp -r "$TEMP_DIR/catppuccin-sddm/src/catppuccin-mocha" /usr/share/sddm/themes/

echo ""
echo -e "${GREEN}Step 3: Configuring SDDM to use Catppuccin Mocha...${NC}"
echo ""

# Create SDDM config directory if it doesn't exist
mkdir -p /etc/sddm.conf.d

# Create theme configuration
cat > /etc/sddm.conf.d/theme.conf << 'EOF'
[Theme]
Current=catppuccin-mocha
EOF

echo "Created /etc/sddm.conf.d/theme.conf"

echo ""
echo -e "${GREEN}Step 4: Syncing wallpaper with desktop...${NC}"
echo ""

# Check if the user's wallpaper exists
# Note: Using digital_art.jpg as specified in the Zero-Drag configuration
# Users can manually change this to sync a different wallpaper if needed
WALLPAPER_SOURCE="$REAL_HOME/.config/hypr/wallpapers/digital_art.jpg"
WALLPAPER_DEST="/usr/share/sddm/themes/catppuccin-mocha/backgrounds/wall.jpg"

if [ -f "$WALLPAPER_SOURCE" ]; then
    echo "Found wallpaper: $WALLPAPER_SOURCE"
    
    # Create backgrounds directory if it doesn't exist
    mkdir -p /usr/share/sddm/themes/catppuccin-mocha/backgrounds
    
    # Copy wallpaper
    cp "$WALLPAPER_SOURCE" "$WALLPAPER_DEST"
    echo "Wallpaper copied to: $WALLPAPER_DEST"
    
    # Update theme.conf to use the wallpaper
    THEME_CONF="/usr/share/sddm/themes/catppuccin-mocha/theme.conf"
    
    if [ -f "$THEME_CONF" ]; then
        # Update the Background parameter to point to wall.jpg
        sed -i 's|^Background=.*|Background=backgrounds/wall.jpg|' "$THEME_CONF"
        echo "Updated theme configuration to use synced wallpaper"
    else
        echo -e "${YELLOW}Warning: theme.conf not found at $THEME_CONF${NC}"
    fi
else
    echo -e "${YELLOW}Warning: Wallpaper not found at $WALLPAPER_SOURCE${NC}"
    echo "The default theme wallpaper will be used."
    echo "You can manually copy your wallpaper later with:"
    echo "  sudo cp ~/.config/hypr/wallpapers/digital_art.jpg $WALLPAPER_DEST"
    echo "  sudo sed -i 's|^Background=.*|Background=backgrounds/wall.jpg|' /usr/share/sddm/themes/catppuccin-mocha/theme.conf"
fi

echo ""
echo -e "${GREEN}Step 5: Cleaning up temporary files...${NC}"
echo ""

# Remove temporary directory
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up"

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}SDDM Theme Installation Complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Test the theme (without rebooting):"
echo "   ${GREEN}sddm-greeter --test-mode --theme /usr/share/sddm/themes/catppuccin-mocha${NC}"
echo ""
echo "2. Reboot to see the new login screen:"
echo "   ${GREEN}sudo reboot${NC}"
echo ""
echo -e "${YELLOW}Note:${NC} The test mode may not work on all systems."
echo "If test mode fails, just reboot to see the login screen."
echo ""
echo -e "${YELLOW}Troubleshooting:${NC}"
echo "- If the theme doesn't apply, check: cat /etc/sddm.conf.d/theme.conf"
echo "- Verify theme exists: ls /usr/share/sddm/themes/catppuccin-mocha"
echo "- Check SDDM logs: journalctl -u sddm -b"
echo ""
