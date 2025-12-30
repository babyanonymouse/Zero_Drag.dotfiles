#!/bin/bash
# Verification script for minimal Hyprland dotfiles
# Checks if all required packages and configurations are properly installed

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Hyprland Dotfiles Verification Script${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

ERRORS=0
WARNINGS=0

# Function to check if a package is installed
check_package() {
    local package=$1
    local optional=${2:-false}
    
    if pacman -Qi "$package" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $package is installed"
        return 0
    else
        if [ "$optional" = "true" ]; then
            echo -e "${YELLOW}⚠${NC} $package is not installed (optional)"
            ((WARNINGS++))
        else
            echo -e "${RED}✗${NC} $package is not installed (required)"
            ((ERRORS++))
        fi
        return 1
    fi
}

# Function to check if a config file exists
check_config() {
    local file=$1
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file exists"
        return 0
    else
        echo -e "${RED}✗${NC} $file is missing"
        ((ERRORS++))
        return 1
    fi
}

# Function to check if a directory exists
check_dir() {
    local dir=$1
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $dir exists"
        return 0
    else
        echo -e "${RED}✗${NC} $dir is missing"
        ((ERRORS++))
        return 1
    fi
}

echo -e "${BLUE}Checking required packages...${NC}"
echo ""

# Core packages
check_package "hyprland"
check_package "waybar"
check_package "kitty"
check_package "fuzzel"
check_package "mako"
check_package "polkit-gnome"
check_package "hyprpaper"
check_package "rofi-wayland"
check_package "wlogout"

echo ""
echo -e "${BLUE}Checking system integration packages...${NC}"
echo ""

check_package "xdg-desktop-portal-hyprland"
check_package "qt5ct"

echo ""
echo -e "${BLUE}Checking utility packages...${NC}"
echo ""

check_package "grim"
check_package "slurp"
check_package "wl-clipboard"
check_package "brightnessctl" true
check_package "playerctl" true
check_package "pamixer" true
check_package "wireplumber"
check_package "jq"
check_package "xdg-utils"

echo ""
echo -e "${BLUE}Checking optional packages...${NC}"
echo ""

check_package "nautilus" true

echo ""
echo -e "${BLUE}Checking configuration directories...${NC}"
echo ""

check_dir "$HOME/.config/hypr"
check_dir "$HOME/.config/waybar"
check_dir "$HOME/.config/kitty"
check_dir "$HOME/.config/fuzzel"
check_dir "$HOME/.config/mako"

echo ""
echo -e "${BLUE}Checking configuration files...${NC}"
echo ""

check_config "$HOME/.config/hypr/hyprland.conf"
check_config "$HOME/.config/hypr/hyprpaper.conf"
check_config "$HOME/.config/hypr/scripts/window_switcher.sh"

check_config "$HOME/.config/waybar/config"
check_config "$HOME/.config/waybar/style.css"
check_config "$HOME/.config/kitty/kitty.conf"
check_config "$HOME/.config/fuzzel/fuzzel.ini"
check_config "$HOME/.config/mako/config"

echo ""
echo -e "${BLUE}Checking additional directories...${NC}"
echo ""

if [ ! -d "$HOME/Pictures" ]; then
    echo -e "${YELLOW}⚠${NC} $HOME/Pictures directory doesn't exist (creating...)"
    mkdir -p "$HOME/Pictures"
    ((WARNINGS++))
else
    echo -e "${GREEN}✓${NC} $HOME/Pictures exists"
fi

echo ""
echo -e "${BLUE}Validating configuration syntax...${NC}"
echo ""

# Check if Waybar config is valid JSON
if command -v python3 &> /dev/null; then
    if python3 -m json.tool "$HOME/.config/waybar/config" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Waybar config is valid JSON"
    else
        echo -e "${RED}✗${NC} Waybar config has JSON syntax errors"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Cannot validate Waybar config (python3 not found)"
    ((WARNINGS++))
fi



echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Verification Summary${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo -e "${GREEN}Your Hyprland setup is ready to use.${NC}"
    echo ""
    echo -e "To start using Hyprland:"
    echo -e "1. Log out of your current session"
    echo -e "2. Select 'Hyprland' from your display manager"
    echo -e "3. Log in and enjoy!"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Verification completed with $WARNINGS warning(s)${NC}"
    echo -e "${YELLOW}Optional packages or features are missing, but core functionality should work.${NC}"
    exit 0
else
    echo -e "${RED}✗ Verification failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo -e "${RED}Please install missing packages or fix configuration issues.${NC}"
    echo ""
    echo -e "Run the installation script again: ${GREEN}./install.sh${NC}"
    exit 1
fi
