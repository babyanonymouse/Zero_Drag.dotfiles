# Hyprland Quick Reference Card

## Essential Commands
```
SUPER + Return       → Terminal
SUPER + D            → App Launcher
SUPER + Q            → Close Window
SUPER + M            → Exit Hyprland
SUPER + F            → Fullscreen
```

## Window Navigation
```
SUPER + h/j/k/l      → Move Focus (Vim)
SUPER + Arrows       → Move Focus
SUPER + Shift + hjkl → Move Window
SUPER + Ctrl + hjkl  → Resize Window
```

## Workspaces
```
SUPER + [1-5]        → Switch Workspace
SUPER + Shift + [1-5]→ Move to Workspace
SUPER + S            → Scratchpad
```

## Screenshots
```
Print                → Select Area (clipboard)
Shift + Print        → Full Screen (clipboard)
SUPER + Print        → Select Area (save file)
```

## System
```
F11/F12              → Brightness
Volume Keys          → Audio Control
Media Keys           → Playback Control
```

## Configuration Files
```
~/.config/hypr/hyprland.conf     → Main config
~/.config/hypr/keybinds.conf     → Keybindings
~/.config/waybar/config          → Status bar
~/.config/kitty/kitty.conf       → Terminal
```

## Tips
- Use SUPER + Vim keys for efficient window management
- Workspaces 1-5 are persistent and always available
- Screenshots are saved to ~/Pictures/ when using SUPER + Print
- Waybar shows CPU, RAM, network, battery in real-time
- All effects optimized for minimal resource usage

## Troubleshooting
```bash
# Reload Hyprland config
SUPER + Shift + R (if configured) or restart

# Check Hyprland version
hyprctl version

# View active windows
hyprctl clients

# Check running services
systemctl --user status waybar
systemctl --user status mako
```

## Useful Commands
```bash
# Take screenshot
grim -g "$(slurp)" ~/Pictures/screenshot.png

# List available outputs
hyprctl monitors

# Reload Waybar
killall waybar && waybar &

# Test notifications
notify-send "Test" "This is a test notification"
```
