#!/usr/bin/env bash
# Zero-Drag Hyprland Dotfiles Installer
# Performance Focused. Zero Bloat.
# Optimized for Kitty, Quickshell, and High Performance

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Helper output functions
say()  { printf '%b%s%b\n' "${BLUE}" "$*" "${NC}"; }
step() { printf '\n%b:: %s%b\n' "${GREEN}" "$*" "${NC}"; }
warn() { printf '%b! %s%b\n' "${YELLOW}" "$*" "${NC}"; }
die()  { printf '%berror: %s%b\n' "${RED}" "$*" "${NC}" >&2; exit 1; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_SRC_DIR="${SCRIPT_DIR}/.config"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Installation variables
PROFILE="core"
METHOD="copy"
SETUP_SDDM=false
SKIP_PACKAGES=false
DRY_RUN=false

show_help() {
    cat <<EOF
Zero-Drag Hyprland Dotfiles Installer

Usage: $0 [options]

Options:
  -c, --core          Install core shell packages & configs (default)
  -f, --full          Install core shell + daily applications (brave, vscode, discord, etc.)
  -s, --symlink       Symbolic link configurations to ~/.config (recommended for developers)
  -p, --copy          Copy configurations to ~/.config (default method)
  -d, --sddm          Automatically install and enable the Torii SDDM theme
  -n, --no-packages   Deploy configurations only, skip package installation
  -y, --dry-run       Show installation steps without making any modifications
  -h, --help          Show this help message
EOF
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--core) PROFILE="core"; shift ;;
        -f|--full) PROFILE="full"; shift ;;
        -s|--symlink) METHOD="symlink"; shift ;;
        -p|--copy) METHOD="copy"; shift ;;
        -d|--sddm) SETUP_SDDM=true; shift ;;
        -n|--no-packages) SKIP_PACKAGES=true; shift ;;
        -y|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) die "Unknown option: $1. Run with --help for usage." ;;
    esac
done

step "Zero-Drag Hyprland Dotfiles Installer"

# 1. Distro Verification
if [ -f /etc/cachyos-release ]; then
    say "System detected: CachyOS (fully compatible & optimized)"
elif [ -f /etc/arch-release ]; then
    say "System detected: Arch Linux (compatible)"
else
    warn "This rice is optimized for Arch Linux and CachyOS."
    if [ "$DRY_RUN" = false ]; then
        read -p "Do you want to proceed anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            die "Installation aborted by user."
        fi
    fi
fi

# 2. Parse Package List
step "Reading packages.list..."
CORE_PACKAGES=()
DAILY_PACKAGES=()
CURRENT_SECTION=""

while IFS= read -r line || [ -n "$line" ]; do
    # Remove leading/trailing whitespace
    line=$(echo "$line" | xargs || echo "$line")
    # Skip empty lines and full comments
    [ -z "$line" ] && continue
    if [[ "$line" =~ ^#\ --- ]]; then
        if [[ "$line" == *"Core Desktop"* || "$line" == *"Fonts & Themes"* ]]; then
            CURRENT_SECTION="core"
        elif [[ "$line" == *"Daily Applications"* ]]; then
            CURRENT_SECTION="daily"
        fi
        continue
    fi
    [[ "$line" =~ ^# ]] && continue

    if [ "$CURRENT_SECTION" = "core" ]; then
        CORE_PACKAGES+=("$line")
    elif [ "$CURRENT_SECTION" = "daily" ]; then
        DAILY_PACKAGES+=("$line")
    fi
done < "${SCRIPT_DIR}/packages.list"

say "Parsed ${#CORE_PACKAGES[@]} Core packages and ${#DAILY_PACKAGES[@]} Daily application packages."

# 3. Package Installation
if [ "$SKIP_PACKAGES" = true ]; then
    say "Skipping package installation (--no-packages active)."
else
    step "Installing Packages..."
    # Check package manager (prefer yay over pacman)
    if command -v yay &> /dev/null; then
        PKG_MANAGER="yay"
    else
        PKG_MANAGER="sudo pacman"
        warn "yay not found. Installing packages with standard pacman. AUR packages may fail."
    fi

    # Compile final package list
    PKGS_TO_INSTALL=("${CORE_PACKAGES[@]}")
    if [ "$PROFILE" = "full" ]; then
        PKGS_TO_INSTALL+=("${DAILY_PACKAGES[@]}")
    fi

    say "Using package manager: $PKG_MANAGER"
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would run: $PKG_MANAGER -S --needed --noconfirm ${PKGS_TO_INSTALL[*]}"
    else
        # Update keyring first to prevent signature verification errors
        say "Updating keyrings..."
        $PKG_MANAGER -Sy --needed --noconfirm archlinux-keyring || true
        if [ -f /etc/cachyos-release ]; then
            $PKG_MANAGER -S --needed --noconfirm cachyos-keyring 2>/dev/null || true
        fi
        
        # Install the packages
        $PKG_MANAGER -S --needed --noconfirm "${PKGS_TO_INSTALL[@]}"

        # Setup swww (awww) symlinks so color transition scripts work natively
        if command -v swww &>/dev/null; then
            say "Creating swww/awww compatibility symlinks..."
            sudo ln -sf /usr/bin/swww /usr/bin/awww
            sudo ln -sf /usr/bin/swww-daemon /usr/bin/awww-daemon
        fi
    fi
fi

# 4. Backup Existing Configurations
step "Backing up existing configurations..."
BACKUP_DIR="${XDG_CONFIG_HOME}-backup-$(date +%Y%m%d-%H%M%S)"

# List of all dotfiles directories and files to backup
CONFIG_DIRS=(
    "hypr" "quickshell" "fish" "ghostty" "fastfetch" "alacritty"
    "btop" "cava" "gtk-3.0" "gtk-4.0" "kitty" "micro" "systemd"
    "uwsm" "menus" "noctalia" "qt5ct" "qt6ct" "ricelin" "xsettingsd" "sddm" "grub"
)
CONFIG_FILES=(
    "kdeglobals" "dolphinrc" "mimeapps.list" "user-dirs.dirs" 
    "user-dirs.locale" "trashrc" "starship.toml" "kdeglobals.ricelin-managed" "cachyos-hello.json"
)

BACKUP_ITEMS=()
for d in "${CONFIG_DIRS[@]}"; do
    if [ -d "${XDG_CONFIG_HOME}/${d}" ]; then
        BACKUP_ITEMS+=("${XDG_CONFIG_HOME}/${d}")
    fi
done
for f in "${CONFIG_FILES[@]}"; do
    if [ -f "${XDG_CONFIG_HOME}/${f}" ]; then
        BACKUP_ITEMS+=("${XDG_CONFIG_HOME}/${f}")
    fi
done
if [ -f "$HOME/.zshrc" ]; then
    BACKUP_ITEMS+=("$HOME/.zshrc")
fi

if [ ${#BACKUP_ITEMS[@]} -eq 0 ]; then
    say "No existing configuration directories found. Backup skipped."
else
    say "Found ${#BACKUP_ITEMS[@]} existing configuration item(s)."
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would create backup folder: $BACKUP_DIR"
        for item in "${BACKUP_ITEMS[@]}"; do
            say "[DRY-RUN] Would move $item -> $BACKUP_DIR/"
        done
    else
        mkdir -p "$BACKUP_DIR"
        for item in "${BACKUP_ITEMS[@]}"; do
            say "Backing up $(basename "$item")..."
            mv "$item" "$BACKUP_DIR/"
        done
        say "Backup created successfully at: $BACKUP_DIR"
    fi
fi

# 5. Deploy Configurations
step "Deploying Configurations (method: $METHOD)..."

# Ensure XDG_CONFIG_HOME exists
if [ "$DRY_RUN" = false ]; then
    mkdir -p "$XDG_CONFIG_HOME"
fi

# Deploying folder configs
for d in "${CONFIG_DIRS[@]}"; do
    SRC="${CONFIG_SRC_DIR}/${d}"
    DEST="${XDG_CONFIG_HOME}/${d}"
    [ -d "$SRC" ] || continue

    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would deploy dir: $SRC -> $DEST"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$SRC" "$DEST"
        else
            cp -r "$SRC" "$DEST"
        fi
    fi
done

# Deploying file configs
for f in "${CONFIG_FILES[@]}"; do
    SRC="${CONFIG_SRC_DIR}/${f}"
    DEST="${XDG_CONFIG_HOME}/${f}"
    [ -f "$SRC" ] || continue

    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would deploy file: $SRC -> $DEST"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$SRC" "$DEST"
        else
            cp "$SRC" "$DEST"
        fi
    fi
done

# Deploy Zsh configuration
ZSH_SRC="${SCRIPT_DIR}/.zshrc"
if [ -f "$ZSH_SRC" ]; then
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would deploy Zsh config: $ZSH_SRC -> $HOME/.zshrc"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$ZSH_SRC" "$HOME/.zshrc"
        else
            cp "$ZSH_SRC" "$HOME/.zshrc"
        fi
        say "Zsh config deployed."
    fi
fi

# Copy wallpapers to configuration directory for reference
WALLPAPER_SRC="${SCRIPT_DIR}/wallpapers"
WALLPAPER_DEST="${XDG_CONFIG_HOME}/hypr/wallpapers"
if [ -d "$WALLPAPER_SRC" ]; then
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would deploy wallpapers: $WALLPAPER_SRC -> $WALLPAPER_DEST"
    else
        mkdir -p "$WALLPAPER_DEST"
        if [ "$METHOD" = "symlink" ]; then
            # Link individual files inside wallpapers, or the folder
            ln -sf "$WALLPAPER_SRC"/* "$WALLPAPER_DEST/"
        else
            cp -r "$WALLPAPER_SRC"/* "$WALLPAPER_DEST/"
        fi
        say "Wallpapers deployed."
    fi
fi

# Ensure all scripts are executable
if [ "$DRY_RUN" = false ]; then
    say "Setting script permissions..."
    chmod +x "${XDG_CONFIG_HOME}/hypr/scripts"/*
fi

# 6. SDDM Theme Setup
if [ "$SETUP_SDDM" = true ]; then
    step "Installing SDDM Theme..."
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would run: sudo bash ${XDG_CONFIG_HOME}/sddm/themes/torii/install.sh"
    else
        chmod +x "${XDG_CONFIG_HOME}/sddm/themes/torii/install.sh"
        sudo bash "${XDG_CONFIG_HOME}/sddm/themes/torii/install.sh"
    fi
fi

# 7. Generate Initial Colors Cache
step "Pre-generating terminal and shell colors..."
if [ "$DRY_RUN" = true ]; then
    say "[DRY-RUN] Would run: python3 ${XDG_CONFIG_HOME}/hypr/scripts/wallcolors.py --hue 30 dark"
else
    # Find a wallpaper to initialize the theme, otherwise default to manual hue
    INITIAL_WALL=$(find "$WALLPAPER_SRC" -type f \( -iname '*.jpg' -o -iname '*.png' \) | head -n1 || echo "")
    if [ -n "$INITIAL_WALL" ]; then
        say "Generating theme from initial wallpaper: $(basename "$INITIAL_WALL")..."
        python3 "${XDG_CONFIG_HOME}/hypr/scripts/wallcolors.py" "$INITIAL_WALL" || true
    else
        say "No wallpaper found. Generating theme with fallback hue..."
        python3 "${XDG_CONFIG_HOME}/hypr/scripts/wallcolors.py" --hue 30 dark || true
    fi
fi

step "Installation Completed Successfully!"
say "-------------------------------------------------------"
say "Keybindings Quick Reference:"
say "  SUPER + Return       - Open Terminal (Kitty)"
say "  SUPER + E            - File Manager (Dolphin)"
say "  SUPER + Space        - Launcher (Quickshell QML Launcher)"
say "  SUPER + V            - Clipboard History (Quickshell QML Clipboard)"
say "  SUPER + C            - Wallpaper Picker (Quickshell QML Picker)"
say "  SUPER + B            - Shuffle Wallpaper & Sync Colors (swww + wallust)"
say "  SUPER + L            - Lock Screen"
say "  Print                - Screenshot Overlay (rishot)"
say "-------------------------------------------------------"
say "Please restart Hyprland or run 'killall -USR1 kitty' to load color changes."
say "If you chose symlinking, any edits you make in ~/.config/ will directly sync to this git repository!"
