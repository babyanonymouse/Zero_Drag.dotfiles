# Mako Notification Daemon Configuration

This directory contains the Mako notification daemon configuration for Wayland.

## Files

- `config` - Mako configuration file

## Overview

Mako is a lightweight notification daemon for Wayland compositors like Hyprland. It displays desktop notifications in a clean, customizable format.

## Features Configured

### Appearance
- **Position**: Top-right corner
- **Size**: 300x150 pixels per notification
- **Theme**: Catppuccin Mocha color scheme
- **Font**: JetBrainsMono Nerd Font 11pt
- **Border**: Rounded corners (10px) with colored borders
- **Icons**: Enabled with Papirus Dark icons (48px max size)

### Behavior
- **Max Visible**: Up to 5 notifications at once
- **History**: Stores last 20 notifications
- **Timeout**: 5 seconds default (varies by urgency)
- **Sorting**: Newest notifications on top

### Urgency Levels

#### Low Urgency (Cyan border)
- Timeout: 3 seconds
- Used for informational messages

#### Normal Urgency (Blue border)
- Timeout: 5 seconds
- Default for most notifications

#### High Urgency (Red border)
- No timeout (stays until dismissed)
- Used for important alerts

### Application-Specific Rules
- **Volume notifications**: Cyan border, 2-second timeout
- **Brightness notifications**: Yellow border, 2-second timeout

## Usage

Mako starts automatically via Hyprland's `exec-once` in `hyprland.conf`.

### Manual Control
```bash
# Start mako
mako

# Reload configuration
makoctl reload

# Dismiss all notifications
makoctl dismiss --all

# View notification history
makoctl history
```

### Test Notification
```bash
notify-send "Test" "This is a test notification"
notify-send -u critical "Important" "This is urgent!"
```

## Keybindings

You can add keybindings in Hyprland to control notifications:
```conf
# In hyprland.conf
bind = $mainMod, N, exec, makoctl dismiss
bind = $mainMod SHIFT, N, exec, makoctl dismiss --all
```

## Dependencies

```bash
# Install on Arch/CachyOS
yay -S mako libnotify papirus-icon-theme
```

## Customization

### Change Position
Modify the `anchor` setting:
```conf
anchor=top-center    # Top center
anchor=bottom-right  # Bottom right
anchor=center        # Center of screen
```

### Timeout Duration
Adjust `default-timeout` (in milliseconds):
```conf
default-timeout=3000  # 3 seconds
```

### Colors
Customize the color scheme:
```conf
background-color=#your-bg-color
text-color=#your-text-color
border-color=#your-border-color
```

### Notification Size
Modify dimensions:
```conf
width=400
height=200
```

## Resources

- [Mako GitHub](https://github.com/emersion/mako)
- [Mako Man Page](https://man.archlinux.org/man/mako.5)
