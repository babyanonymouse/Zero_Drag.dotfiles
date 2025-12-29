# my_dotfiles
Minimal Hyprland Dotfiles for CachyOS

## Overview

This repository contains a complete, organized configuration for a beautiful and functional Hyprland setup on CachyOS. The configuration uses a cohesive Catppuccin Mocha color scheme across all applications.

## Directory Structure

```
.
├── .config/
│   ├── hypr/           # Hyprland window manager configuration
│   ├── waybar/         # Status bar configuration
│   ├── kitty/          # Terminal emulator configuration
│   ├── rofi/           # Application launcher configuration
│   └── mako/           # Notification daemon configuration
├── wallpapers/         # Wallpaper images
└── scripts/            # Utility scripts
```

## Components

### 🪟 Hyprland
Dynamic tiling Wayland compositor with smooth animations and modern features.
- Custom keybindings with SUPER as modifier
- Beautiful blur and transparency effects
- Workspace management
- See [.config/hypr/README.md](.config/hypr/README.md)

### 📊 Waybar
Highly customizable status bar showing system information.
- Workspace indicators
- System stats (CPU, memory, temperature)
- Network and battery status
- Volume control
- See [.config/waybar/README.md](.config/waybar/README.md)

### 💻 Kitty
GPU-accelerated terminal emulator.
- Fast and feature-rich
- Catppuccin Mocha theme
- Custom keybindings
- See [.config/kitty/README.md](.config/kitty/README.md)

### 🚀 Rofi
Application launcher and window switcher.
- Beautiful custom theme
- Icon support
- Multiple modes (apps, run, windows)
- See [.config/rofi/README.md](.config/rofi/README.md)

### 🔔 Mako
Notification daemon for Wayland.
- Customizable appearance
- Urgency-based styling
- History support
- See [.config/mako/README.md](.config/mako/README.md)

### 🖼️ Wallpapers
Collection of wallpapers and configuration guides.
- Multiple wallpaper manager support
- Organization tips
- See [wallpapers/README.md](wallpapers/README.md)

### 🛠️ Scripts
Utility scripts for enhanced functionality.
- Screenshot tools
- Volume control with notifications
- Brightness control
- Wallpaper rotation
- See [scripts/README.md](scripts/README.md)

## Installation

### Prerequisites

Install required packages on CachyOS:
```bash
# Core components
yay -S hyprland-git waybar kitty rofi-wayland mako

# Fonts and icons
yay -S ttf-jetbrains-mono-nerd papirus-icon-theme

# Utilities
yay -S grim slurp wl-clipboard pamixer brightnessctl swww

# Optional
yay -S thunar pavucontrol
```

### Setup

1. Clone this repository:
```bash
git clone https://github.com/babyanonymouse/my_dotfiles.git ~/my_dotfiles
```

2. Create symlinks to the configuration files:
```bash
# Backup existing configs if needed
mkdir -p ~/.config/backup
mv ~/.config/hypr ~/.config/backup/ 2>/dev/null

# Create symlinks
ln -sf ~/my_dotfiles/.config/hypr ~/.config/hypr
ln -sf ~/my_dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/my_dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/my_dotfiles/.config/rofi ~/.config/rofi
ln -sf ~/my_dotfiles/.config/mako ~/.config/mako
```

3. Make scripts executable (if not already):
```bash
chmod +x ~/my_dotfiles/scripts/*.sh
```

4. Log out and select Hyprland from your display manager.

## Keybindings

### Essential Shortcuts (with SUPER key)
- `SUPER + Q` - Open terminal (Kitty)
- `SUPER + C` - Close window
- `SUPER + M` - Exit Hyprland
- `SUPER + R` - Open launcher (Rofi)
- `SUPER + E` - File manager
- `SUPER + V` - Toggle floating
- `SUPER + [1-9,0]` - Switch workspace
- `SUPER + SHIFT + [1-9,0]` - Move window to workspace
- `SUPER + Arrow Keys` - Move focus
- `SUPER + LMB Drag` - Move window
- `SUPER + RMB Drag` - Resize window

### Screenshots
- `Print` - Full screen
- `SHIFT + Print` - Selection
- `CTRL + Print` - Active window

### Media Keys
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Mute
- `XF86MonBrightnessUp` - Brightness up
- `XF86MonBrightnessDown` - Brightness down

## Customization

Each component has its own README with detailed customization instructions:
- [Hyprland Configuration](.config/hypr/README.md)
- [Waybar Configuration](.config/waybar/README.md)
- [Kitty Configuration](.config/kitty/README.md)
- [Rofi Configuration](.config/rofi/README.md)
- [Mako Configuration](.config/mako/README.md)

## Color Scheme

All configurations use the **Catppuccin Mocha** color palette for a cohesive look:
- Background: `#1e1e2e`
- Foreground: `#cdd6f4`
- Accent: `#89b4fa` (Blue)
- Success: `#a6e3a1` (Green)
- Warning: `#f9e2af` (Yellow)
- Error: `#f38ba8` (Red)

## Troubleshooting

### Hyprland won't start
- Check logs: `cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log`
- Ensure all dependencies are installed

### Waybar not showing
- Check if waybar is running: `ps aux | grep waybar`
- Restart: `killall waybar && waybar &`

### Icons not showing
- Install required fonts: `yay -S ttf-jetbrains-mono-nerd`
- Install icon theme: `yay -S papirus-icon-theme`

### Scripts not working
- Ensure scripts are executable: `chmod +x ~/my_dotfiles/scripts/*.sh`
- Check dependencies for each script in [scripts/README.md](scripts/README.md)

## Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
- [CachyOS](https://cachyos.org/)
- [Arch Wiki](https://wiki.archlinux.org/)

## Contributing

Feel free to open issues or submit pull requests with improvements!

## License

This configuration is free to use and modify.
