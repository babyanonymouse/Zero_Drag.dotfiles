<div align="center">

# Zero-Drag Rice

**A high-performance, performance-focused Hyprland shell on Arch Linux/CachyOS. Powered by custom Quickshell and optimized terminal integrations.**

![Zero-Drag Desktop](assets/hero.png)

</div>

Zero-Drag is a heavily tuned Hyprland setup built for maximum responsiveness, zero bloat, and a modern aesthetic. It uses custom Quickshell widgets for the system panel and controls, Kitty as the preferred terminal, and dynamic palette generation.

## Features

- **Window Manager:** Hyprland configured in Lua.
- **Shell UI:** Hand-written Quickshell pill panel that morphs into a launcher, calendar, media controller, audio/brightness sliders, and wallpaper picker.
- **Terminal:** Kitty, loaded with custom padding, font scaling, copy-on-select, and dynamic color switching.
- **Dynamic Palette:** Matugen and custom color scripts extract cohesive HSL palettes from your active wallpaper, re-coloring Kitty, the panel, borders, and fastfetch dynamically.
- **Bootloader Theme:** Includes the gorgeous Torii GRUB and SDDM theme.

---

## Installation

Ensure git is installed and clone the repository:

```sh
git clone https://github.com/babyanonymouse/Zero_Drag.dotfiles.git ~/Zero_Drag.dotfiles
cd ~/Zero_Drag.dotfiles
```

### 1. Main Installer (`install.sh`)

The installer will validate your distribution (optimized for CachyOS/Arch), install the required system packages, back up your existing configurations, and deploy the new configurations.

```sh
# Run the guided default install (Core packages + Copy configs)
./install.sh

# Recommended for developers: Symlink configurations instead of copying
# (Any edits you make in ~/.config/ will directly sync back to the git repo!)
./install.sh --symlink

# Perform a Full installation (Core shell + Everyday Apps: Brave, VS Code, Discord, Spotify, Obsidian, etc.)
./install.sh --full

# Auto-setup the Torii SDDM login theme along with the installation
./install.sh --sddm
```

#### Installer Flags
```
  -c, --core          Install core shell packages & configs (default)
  -f, --full          Install core shell + daily applications (brave, vscode, discord, etc.)
  -s, --symlink       Symbolic link configurations to ~/.config (recommended for developers)
  -p, --copy          Copy configurations to ~/.config (default method)
  -d, --sddm          Automatically install and enable the Torii SDDM theme
  -n, --no-packages   Deploy configurations only, skip package installation
  -y, --dry-run       Show installation steps without making any modifications
  -h, --help          Show the help menu
```

### 2. GTK Theme & Icon Installer (`install_custom_theme.sh`)

Downloads and installs the Gently Plasma GTK Theme, YAMIS Monochrome icon set, and the `nwg-look` GTK settings tool.

```sh
./install_custom_theme.sh
```
*After running, open `nwg-look` and select 'Gently-Color-GTK' and 'Monochrome-Icons' to complete the theme mapping.*

### 3. Quick Config Sync (`update_configs.sh`)

Use this script to update/sync configurations from your local repository to `~/.config/` without executing full package installations or root commands.

```sh
# Copy updated configs
./update_configs.sh

# Symlink updated configs
./update_configs.sh --symlink
```

---

## Keybindings

| Key | Action |
|---|---|
| `Super` + `Return` | Open Kitty Terminal |
| `Super` + `Space` | Open App Launcher |
| `Super` + `V` | Clipboard History |
| `Super` + `C` | Wallpaper Picker / Changer |
| `Super` + `B` | Shuffle Wallpaper and Sync System Colors |
| `Super` + `E` | Open Dolphin File Manager |
| `Super` + `T` | Toggle Floating Window |
| `Super` + `L` | Lock Screen |
| `Print` | Screen Capture & Annotation (Rishot) |

---

## Structure

```
.
├── .config/             # Consolidated configuration files
│   ├── alacritty/       # Alacritty configuration (fallback terminal)
│   ├── btop/            # btop configuration
│   ├── cava/            # Cava audio visualizer configuration
│   ├── fastfetch/       # Fastfetch layouts
│   ├── fish/            # Fish shell configurations & greetings
│   ├── ghostty/         # Ghostty configurations
│   ├── grub/            # Torii GRUB theme files
│   ├── gtk-3.0/         # GTK theme overrides
│   ├── gtk-4.0/         # GTK theme overrides
│   ├── hypr/            # Hyprland Lua modules, binds, and scripts
│   ├── kitty/           # Unified Kitty terminal configuration
│   ├── micro/           # Micro editor configuration
│   ├── quickshell/      # Hand-written desktop shell components (qml)
│   ├── sddm/            # Torii SDDM theme files
│   ├── systemd/         # User systemd services
│   └── uwsm/            # UWSM session configurations
├── assets/              # README previews and logos
├── wallpapers/          # Dynamic wallpaper assets used for theming
├── install.sh           # Main installer script
├── install_custom_theme.sh # GTK and icon installer script
├── update_configs.sh    # Configuration sync script
└── packages.list        # List of explicitly installed packages
```

---

## Support & Credits

- The lock screen, SDDM backgrounds, and wallpapers are collected from various artists.
- Build based on a custom fork of Ricelin.
