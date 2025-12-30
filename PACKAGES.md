# Package List for Minimal Hyprland Setup

## Core Components (Required)

hyprland # Dynamic tiling Wayland compositor
waybar # Highly customizable status bar
kitty # Fast, feature-rich terminal emulator
wofi # Lightweight application launcher
rofi-wayland # Window switcher (Alt+Tab)
mako # Minimal notification daemon
polkit-gnome # Authentication agent for GUI apps

## System Integration (Required)

xdg-desktop-portal-hyprland # Screen sharing and file picker support
qt5ct # Qt5 configuration tool

## Utilities (Required)

grim # Screenshot utility for Wayland
slurp # Region selector for screenshots
wl-clipboard # Clipboard utilities for Wayland
brightnessctl # Brightness control utility
playerctl # Media player control utility
pamixer # PulseAudio mixer control
wireplumber # Session/policy manager for PipeWire

## Applications (Recommended)

thunar # Lightweight file manager
ttf-jetbrains-mono-nerd # Font with icon support for status bar
eza # Modern, maintained replacement for ls
bat # Cat clone with syntax highlighting
zoxide # Smarter cd command
ripgrep # Faster grep
fzf # Command-line fuzzy finder
starship # Customizable prompt for any shell

## Shell Enhancements (Zsh)

zsh-syntax-highlighting # Fish-like syntax highlighting
zsh-autosuggestions # Fish-like autosuggestions
zsh-completions # Additional completion definitions

## Optional Enhancements

network-manager-applet # NetworkManager system tray applet
blueman # Bluetooth manager with GTK+ UI
pavucontrol # PulseAudio volume control GUI
alacritty # Alternative terminal emulator
foot # Another minimal terminal option
dunst # Alternative notification daemon

## Development Tools (Optional)

neovim # Modal text editor
visual-studio-code-bin # Popular code editor
firefox # Web browser
chromium # Alternative web browser

## Installation Commands

### Using yay (AUR helper)

```bash
yay -S hyprland waybar kitty wofi mako polkit-gnome \
       xdg-desktop-portal-hyprland qt5ct grim slurp \
       wl-clipboard brightnessctl playerctl pamixer \
       wireplumber thunar ttf-jetbrains-mono-nerd
```

### Using pacman (official repos only)

```bash
sudo pacman -S hyprland waybar kitty wofi mako polkit-gnome \
               xdg-desktop-portal-hyprland qt5ct grim slurp \
               wl-clipboard brightnessctl playerctl pamixer \
               wireplumber thunar
```

### Font installation (from AUR)

```bash
yay -S ttf-jetbrains-mono-nerd
```

## Estimated Disk Usage

- Core packages: ~150-200 MB
- With optional enhancements: ~300-400 MB
- Full development setup: ~1-2 GB (including IDEs)

## Resource Usage After Install

- Idle RAM: 400-600 MB
- Idle CPU: <5%
- Boot time: Fast (depends on hardware and autostart services)
