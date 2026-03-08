# Installation Guide

This guide covers all methods to install the Zero-Drag Hyprland dotfiles on your system.

---

## 📋 Prerequisites

- **Operating System**: CachyOS (recommended) or Arch Linux
- **AUR Helper**: `yay` (recommended) or `paru`
- **Git**: `sudo pacman -S git`
- **Shell**: Zsh (`sudo pacman -S zsh`)

> **Note**: The automated installer checks for CachyOS but will prompt before continuing on other Arch-based systems.

---

## ⚡ Automated Installation (Recommended)

The `install.sh` script handles everything: package installation, config backup, and dotfile deployment.

```bash
# 1. Clone the repository
git clone https://github.com/babyanonymouse/Zero_Drag.dotfiles.git
cd Zero_Drag.dotfiles

# 2. Make scripts executable
chmod +x install.sh verify.sh update_configs.sh

# 3. Run the installer
./install.sh
```

### What the installer does

1. **Checks for CachyOS** — warns and prompts if running on a different distro.
2. **Updates keyrings and system** — runs `pacman -Sy archlinux-keyring` and a full system upgrade.
3. **Removes conflicting apps** — uninstalls Nautilus/Dolphin if present to avoid conflicts with Thunar.
4. **Installs all packages** — installs the full software stack using `yay` (or `pacman` as fallback).
5. **Backs up existing configs** — saves existing `~/.config/{hypr,waybar,kitty,fuzzel,swaync,wlogout}` to a timestamped backup directory.
6. **Deploys dotfiles** — copies all configuration files to `~/.config/`.
7. **Sets up environment** — creates `~/Pictures`, sets Thunar as default file manager, applies GTK/icon themes.

---

## 🔄 Updating Configs

After pulling new changes from the repository, use `update_configs.sh` to redeploy configs without reinstalling packages:

```bash
git pull
./update_configs.sh
```

---

## 🛠️ Manual Installation

### Step 1 — Install Packages

See [PACKAGES.md](../../PACKAGES.md) for the complete package list.

**Using yay:**
```bash
yay -S hyprland waybar kitty fuzzel hyprpaper swaync polkit-gnome \
       xdg-desktop-portal-hyprland qt5ct libappindicator-gtk3 grim slurp wl-clipboard \
       brightnessctl playerctl pamixer wireplumber thunar \
       thunar-archive-plugin thunar-volman file-roller gvfs \
       catppuccin-gtk-theme-mocha papirus-icon-theme xdg-utils \
       ttf-jetbrains-mono-nerd wlogout starship \
       eza bat zoxide ripgrep fzf cliphist hyprlock hypridle \
       zsh-syntax-highlighting zsh-autosuggestions zsh-completions gthumb hyprpicker
```

**Using pacman (official repos only):**
```bash
sudo pacman -S hyprland waybar kitty fuzzel hyprpaper swaync polkit-gnome \
               xdg-desktop-portal-hyprland qt5ct libappindicator-gtk3 grim slurp wl-clipboard \
               brightnessctl playerctl pamixer wireplumber thunar \
               thunar-archive-plugin thunar-volman file-roller gvfs \
               catppuccin-gtk-theme-mocha papirus-icon-theme xdg-utils \
               wlogout starship eza bat zoxide ripgrep fzf \
               cliphist hyprlock hypridle zsh-syntax-highlighting \
               zsh-autosuggestions zsh-completions gthumb hyprpicker
```

**Install the Nerd Font (AUR):**
```bash
yay -S ttf-jetbrains-mono-nerd
```

### Step 2 — Back Up Existing Configs

```bash
BACKUP_DIR="$HOME/.config/hyprland-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
for dir in hypr waybar kitty fuzzel swaync wlogout; do
    [ -d "$HOME/.config/$dir" ] && mv "$HOME/.config/$dir" "$BACKUP_DIR/"
done
echo "Backup at: $BACKUP_DIR"
```

### Step 3 — Copy Configurations

```bash
cp -r .config/hypr    ~/.config/
cp -r .config/waybar  ~/.config/
cp -r .config/kitty   ~/.config/
cp -r .config/fuzzel  ~/.config/
cp -r .config/swaync  ~/.config/
cp -r .config/wlogout ~/.config/
cp    .config/starship.toml ~/.config/starship.toml
cp    .zshrc ~/.zshrc
```

### Step 4 — Copy Wallpapers

```bash
mkdir -p ~/.config/hypr/wallpapers
cp -r wallpapers/* ~/.config/hypr/wallpapers/
```

### Step 5 — Make Scripts Executable

```bash
chmod +x ~/.config/hypr/scripts/*.sh
```

### Step 6 — Apply GTK Theme and Icons

```bash
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Blue-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
xdg-mime default thunar.desktop inode/directory
```

---

## ✅ Post-Installation

### 1. Run Verification

```bash
./verify.sh
```

This script checks for missing packages or configuration errors and reports any issues.

### 2. Set Zsh as Default Shell

```bash
chsh -s $(which zsh)
```

Log out and back in for the change to take effect.

### 3. Start Hyprland

- Log out of your current session.
- Select **Hyprland** from your display manager (SDDM or GDM).
- Log in.

### 4. Optional — SDDM Theme

The repository includes a helper script for a custom SDDM theme:

```bash
chmod +x install_custom_theme.sh
./install_custom_theme.sh
```

SDDM theme dependencies:
```bash
yay -S qt5-graphicaleffects qt5-quickcontrols2 qt5-svg
```

---

## 📝 Notes

- **Laptop users**: Ensure `brightnessctl` is working for backlight keys. You may need to add your user to the `video` group: `sudo usermod -aG video $USER`.
- **Numlock**: Forced **OFF** by default (`numlock_by_default = false` in `hyprland.conf`). Change this in `~/.config/hypr/hyprland.conf` if needed.
- **Weather widget**: Set your city in `~/.config/waybar/config` — see the [Customization](Customization.md) page.
- **Hyprlock background**: Update the path in `~/.config/hypr/hyprlock.conf` to point to your wallpaper.
