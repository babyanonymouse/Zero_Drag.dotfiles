#!/bin/bash
# System Upgrade Script: Alacritty/Thunar -> Kitty/Nautilus

set -e

echo "Uninstalling legacy tools..."
sudo pacman -Rns --noconfirm alacritty thunar thunar-volman dolphin 2>/dev/null || true

echo "Installing new tools..."
sudo pacman -S --needed --noconfirm kitty nautilus xdg-utils

echo "Setting defaults..."
xdg-mime default org.gnome.Nautilus.desktop inode/directory
# Set Kitty as default terminal if possible (distro-dependent, usually via env vars)
export TERMINAL=kitty

echo "Upgrade complete."
