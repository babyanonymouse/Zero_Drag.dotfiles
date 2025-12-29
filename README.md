# Minimal Hyprland Dotfiles for CachyOS

A lightweight, developer-focused Hyprland configuration optimized for minimal resource usage (RAM, CPU, GPU) while maintaining a clean, productive workflow.

## 🎯 Features

### Minimal & Performant
- **Disabled blur effects** - Saves GPU resources
- **Minimal animations** - Smooth yet efficient
- **No drop shadows** - Reduced compositor overhead
- **VFR (Variable Frame Rate)** - Power saving when idle
- **Optimized window rules** - Better resource management
- **5 workspaces only** - Focused workflow

### Developer-Friendly
- **Vim-style keybindings** - h/j/k/l navigation
- **JetBrains Mono Nerd Font** - Perfect for coding
- **Kitty terminal** - GPU-accelerated, lightweight
- **Clean status bar** - Shows only essential info (CPU, RAM, network, battery)
- **Quick application launcher** - Wofi with minimal config

### Included Components
- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Minimal, informative status bar
- **Kitty** - Fast, feature-rich terminal emulator
- **Wofi** - Lightweight application launcher
- **Mako** - Minimal notification daemon
- **Polkit-gnome** - Authentication agent

## 📦 Installation

### Prerequisites
- CachyOS (or Arch-based distribution)
- Git
- Either `yay` or `pacman` package manager

### Quick Install

```bash
# Clone the repository
git clone https://github.com/babyanonymouse/my_dotfiles.git
cd my_dotfiles

# Run the installation script
./install.sh
```

The install script will:
1. Install all required packages
2. Backup your existing configurations
3. Copy the new dotfiles to `~/.config/`
4. Set up the environment

### Manual Installation

If you prefer manual installation:

```bash
# Install required packages
yay -S hyprland waybar kitty wofi mako polkit-gnome \
       xdg-desktop-portal-hyprland qt5ct grim slurp \
       wl-clipboard brightnessctl playerctl pamixer \
       wireplumber thunar ttf-jetbrains-mono-nerd

# Copy configuration files
cp -r .config/* ~/.config/
```

## ⌨️ Keybindings

### Essential Shortcuts
| Keybinding | Action |
|------------|--------|
| `SUPER + Return` | Open terminal (Kitty) |
| `SUPER + D` | Application launcher (Wofi) |
| `SUPER + Q` | Close window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + F` | Fullscreen toggle |
| `SUPER + V` | Toggle floating |

### Window Navigation (Vim-style)
| Keybinding | Action |
|------------|--------|
| `SUPER + h/j/k/l` | Move focus left/down/up/right |
| `SUPER + Arrow Keys` | Move focus (alternative) |
| `SUPER + SHIFT + h/j/k/l` | Move window left/down/up/right |
| `SUPER + CTRL + h/j/k/l` | Resize window |

### Workspace Management
| Keybinding | Action |
|------------|--------|
| `SUPER + [1-5]` | Switch to workspace 1-5 |
| `SUPER + SHIFT + [1-5]` | Move window to workspace 1-5 |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + Mouse Wheel` | Scroll through workspaces |

### Screenshots
| Keybinding | Action |
|------------|--------|
| `Print` | Screenshot selection to clipboard |
| `SHIFT + Print` | Screenshot full screen to clipboard |
| `SUPER + Print` | Screenshot selection to file |

### System Controls
| Keybinding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |
| `XF86AudioPlay` | Play/Pause media |

## 🎨 Customization

### Changing the Color Scheme

Edit `~/.config/waybar/style.css` and `~/.config/kitty/kitty.conf` to adjust colors.

### Adding More Workspaces

Edit `~/.config/hypr/hyprland.conf`:
```conf
workspace = 6, persistent:true
workspace = 7, persistent:true
```

And update `~/.config/hypr/keybinds.conf` to add keybindings.

### Enabling Effects for More Eye Candy

If you have resources to spare, edit `~/.config/hypr/hyprland.conf`:
```conf
decoration {
    blur {
        enabled = true
        size = 5
        passes = 2
    }
    drop_shadow = true
}
```

## 📊 Resource Usage

Typical idle usage on a modern system:
- **RAM**: ~400-600 MB
- **CPU**: <5% idle
- **GPU**: Minimal usage due to disabled effects

## 🔧 Dependencies

### Required Packages
- `hyprland` - Wayland compositor
- `waybar` - Status bar
- `kitty` - Terminal emulator
- `wofi` - Application launcher
- `mako` - Notification daemon
- `polkit-gnome` - Authentication agent
- `xdg-desktop-portal-hyprland` - Screen sharing support

### Optional Utilities
- `grim` - Screenshot tool
- `slurp` - Region selector
- `wl-clipboard` - Clipboard manager
- `brightnessctl` - Brightness control
- `playerctl` - Media control
- `pamixer` / `wireplumber` - Audio control
- `thunar` - File manager
- `ttf-jetbrains-mono-nerd` - Font with icons

## 🐛 Troubleshooting

### Waybar not showing icons
```bash
yay -S ttf-jetbrains-mono-nerd
```

### Screen sharing not working
```bash
yay -S xdg-desktop-portal-hyprland
```

### High CPU usage
Check for problematic animations in `hyprland.conf` and reduce `passes` values.

### Terminal not opening
Verify Kitty is installed: `which kitty`

## 🤝 Contributing

Feel free to submit issues and pull requests for improvements!

## 📄 License

This configuration is provided as-is for personal use. Feel free to modify and distribute.

## 🙏 Credits

- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [CachyOS](https://cachyos.org/) - Optimized Arch Linux distribution
- Various dotfile inspirations from the r/unixporn community
