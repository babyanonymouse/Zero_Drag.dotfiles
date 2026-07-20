#!/usr/bin/env bash
# update_configs.sh
# Script to update/sync configurations without reinstalling packages.
# Part of Zero-Drag Dotfiles

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Helper output functions
say()  { printf '%b%s%b\n' "${BLUE}" "$*" "${NC}"; }
warn() { printf '%b! %s%b\n' "${YELLOW}" "$*" "${NC}"; }
die()  { printf '%berror: %s%b\n' "${RED}" "$*" "${NC}" >&2; exit 1; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_SRC_DIR="${SCRIPT_DIR}/.config"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
METHOD="copy"
DRY_RUN=false

show_help() {
    cat <<EOF
Zero-Drag Config Updater

Usage: $0 [options]

Options:
  -s, --symlink       Symbolic link configurations to ~/.config (recommended for developers)
  -p, --copy          Copy configurations to ~/.config (default method)
  -y, --dry-run       Show update steps without making any modifications
  -h, --help          Show this help message
EOF
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--symlink) METHOD="symlink"; shift ;;
        -p|--copy) METHOD="copy"; shift ;;
        -y|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) die "Unknown option: $1. Run with --help for usage." ;;
    esac
done

say "Zero-Drag Configuration Sync (method: $METHOD)"

# Ensure source .config exists
[ -d "$CONFIG_SRC_DIR" ] || die "Source config folder not found at $CONFIG_SRC_DIR"

# List of config directories and files to sync
CONFIG_DIRS=(
    "hypr" "quickshell" "fish" "ghostty" "fastfetch" "alacritty"
    "btop" "cava" "gtk-3.0" "gtk-4.0" "kitty" "micro" "systemd"
    "uwsm" "menus" "noctalia" "qt5ct" "qt6ct" "ricelin" "xsettingsd" "sddm" "grub"
)
CONFIG_FILES=(
    "kdeglobals" "dolphinrc" "mimeapps.list" "user-dirs.dirs" 
    "user-dirs.locale" "trashrc" "starship.toml" "kdeglobals.ricelin-managed" "cachyos-hello.json"
)

# 1. Back up existing configs to temporary backup before syncing
BACKUP_DIR="${XDG_CONFIG_HOME}-backup-$(date +%Y%m%d-%H%M%S)"
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

if [ ${#BACKUP_ITEMS[@]} -gt 0 ]; then
    say "Backing up existing configurations to $BACKUP_DIR..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$BACKUP_DIR"
        for item in "${BACKUP_ITEMS[@]}"; do
            mv "$item" "$BACKUP_DIR/"
        done
    else
        say "[DRY-RUN] Would create backup: $BACKUP_DIR"
    fi
fi

# 2. Deploy directories
for d in "${CONFIG_DIRS[@]}"; do
    SRC="${CONFIG_SRC_DIR}/${d}"
    DEST="${XDG_CONFIG_HOME}/${d}"
    [ -d "$SRC" ] || continue

    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would update dir: $SRC -> $DEST"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$SRC" "$DEST"
        else
            cp -r "$SRC" "$DEST"
        fi
    fi
done

# 3. Deploy files
for f in "${CONFIG_FILES[@]}"; do
    SRC="${CONFIG_SRC_DIR}/${f}"
    DEST="${XDG_CONFIG_HOME}/${f}"
    [ -f "$SRC" ] || continue

    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would update file: $SRC -> $DEST"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$SRC" "$DEST"
        else
            cp "$SRC" "$DEST"
        fi
    fi
done

# 4. Deploy Zsh config
ZSH_SRC="${SCRIPT_DIR}/.zshrc"
if [ -f "$ZSH_SRC" ]; then
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would update Zsh config: $ZSH_SRC -> $HOME/.zshrc"
    else
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$ZSH_SRC" "$HOME/.zshrc"
        else
            cp "$ZSH_SRC" "$HOME/.zshrc"
        fi
    fi
fi

# 5. Copy wallpapers
WALLPAPER_SRC="${SCRIPT_DIR}/wallpapers"
WALLPAPER_DEST="${XDG_CONFIG_HOME}/hypr/wallpapers"
if [ -d "$WALLPAPER_SRC" ]; then
    if [ "$DRY_RUN" = true ]; then
        say "[DRY-RUN] Would deploy wallpapers: $WALLPAPER_SRC -> $WALLPAPER_DEST"
    else
        mkdir -p "$WALLPAPER_DEST"
        if [ "$METHOD" = "symlink" ]; then
            ln -sf "$WALLPAPER_SRC"/* "$WALLPAPER_DEST/"
        else
            cp -r "$WALLPAPER_SRC"/* "$WALLPAPER_DEST/"
        fi
    fi
fi

# Ensure executable permissions on deployed scripts
if [ "$DRY_RUN" = false ]; then
    chmod +x "${XDG_CONFIG_HOME}/hypr/scripts"/*
fi

# 6. Regen Colors Cache based on current wallpaper
WP_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/ricelin-wallpaper"
if [ -r "$WP_STATE" ] && [ "$DRY_RUN" = false ]; then
    CURRENT_WP=$(cat "$WP_STATE")
    if [ -f "$CURRENT_WP" ]; then
        say "Re-generating colors based on active wallpaper: $(basename "$CURRENT_WP")..."
        python3 "${XDG_CONFIG_HOME}/hypr/scripts/wallcolors.py" "$CURRENT_WP" || true
    fi
else
    if [ "$DRY_RUN" = false ]; then
        say "No active wallpaper state found. Generating theme with fallback hue..."
        python3 "${XDG_CONFIG_HOME}/hypr/scripts/wallcolors.py" --hue 30 dark || true
    fi
fi

# Trigger Kitty reload
if [ "$DRY_RUN" = false ]; then
    killall -USR1 kitty >/dev/null 2>&1 || true
fi

say "Sync completed. Please restart Hyprland or run 'killall -USR1 kitty' to apply changes."
