# Waybar Configuration

This directory contains the Waybar status bar configuration for Hyprland.

## Files

- `config` - Waybar configuration (JSON format)
- `style.css` - Waybar styling and appearance

## Overview

Waybar is a highly customizable status bar for Wayland compositors. It displays system information and workspace status.

## Modules

### Left Side
- **Workspaces**: Shows Hyprland workspaces with click-to-switch functionality
- **Window Title**: Displays the currently active window

### Center
- **Clock**: Shows current time (click to toggle date format)

### Right Side
- **PulseAudio**: Volume control (click to open pavucontrol)
- **Network**: WiFi/Ethernet connection status
- **CPU**: CPU usage percentage
- **Memory**: RAM usage percentage
- **Temperature**: System temperature
- **Battery**: Battery level and charging status (if available)
- **System Tray**: Application icons

## Styling

The configuration uses a Catppuccin-inspired color scheme with:
- Semi-transparent background
- Color-coded modules for easy recognition
- Smooth transitions
- Visual indicators for active workspace
- Battery warning animations

## Customization

### Changing Timezone
Edit the `clock` section in `config`:
```json
"timezone": "Your/Timezone"
```

### Modifying Modules
Add or remove modules by editing the `modules-left`, `modules-center`, and `modules-right` arrays in `config`.

### Adjusting Colors
Edit `style.css` to customize colors, fonts, and spacing.

### Font Requirements
The configuration uses "JetBrainsMono Nerd Font". Install it for proper icon display:
```bash
yay -S ttf-jetbrains-mono-nerd
```

## Resources

- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
