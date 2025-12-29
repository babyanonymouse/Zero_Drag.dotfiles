# Scripts

This directory contains helper scripts for your Hyprland setup.

## Overview

Utility scripts to enhance your Hyprland experience with automation and convenience features.

## Available Scripts

### screenshot.sh
Takes screenshots with different modes:
- Full screen
- Selection area
- Active window

### volume-control.sh
Control audio volume with notification feedback.

### brightness-control.sh
Adjust screen brightness with notification feedback.

### wallpaper-rotate.sh
Randomly change wallpapers from the wallpapers directory.

## Usage

Make scripts executable:
```bash
chmod +x ~/my_dotfiles/scripts/*.sh
```

### Keybinding Integration

Add to `hyprland.conf`:
```conf
# Screenshots
bind = , Print, exec, ~/my_dotfiles/scripts/screenshot.sh full
bind = SHIFT, Print, exec, ~/my_dotfiles/scripts/screenshot.sh selection
bind = CTRL, Print, exec, ~/my_dotfiles/scripts/screenshot.sh window

# Volume control
bind = , XF86AudioRaiseVolume, exec, ~/my_dotfiles/scripts/volume-control.sh up
bind = , XF86AudioLowerVolume, exec, ~/my_dotfiles/scripts/volume-control.sh down
bind = , XF86AudioMute, exec, ~/my_dotfiles/scripts/volume-control.sh mute

# Brightness control
bind = , XF86MonBrightnessUp, exec, ~/my_dotfiles/scripts/brightness-control.sh up
bind = , XF86MonBrightnessDown, exec, ~/my_dotfiles/scripts/brightness-control.sh down
```

## Creating New Scripts

When creating new scripts:
1. Add shebang: `#!/bin/bash`
2. Make executable: `chmod +x script.sh`
3. Test thoroughly before adding to keybindings
4. Add comments for clarity
5. Handle errors gracefully

## Dependencies

Common dependencies for scripts:
```bash
# Screenshot utilities
yay -S grim slurp wl-clipboard

# Audio control
yay -S pamixer libnotify

# Brightness control
yay -S brightnessctl libnotify

# Wallpaper management
yay -S swww  # or swaybg/hyprpaper
```

## Script Template

```bash
#!/bin/bash
# Script: script-name.sh
# Description: What this script does

# Check dependencies
if ! command -v required_command &> /dev/null; then
    notify-send "Error" "required_command not found"
    exit 1
fi

# Main functionality
main() {
    # Your code here
    echo "Script executed"
}

main "$@"
```

## Tips

- Use `notify-send` for user feedback
- Check for dependencies at script start
- Use functions for better organization
- Log errors for debugging
- Consider using `set -e` to exit on errors

## Resources

- [Hyprland Wiki - Useful Utilities](https://wiki.hyprland.org/Useful-Utilities/)
- [Arch Wiki - Wayland](https://wiki.archlinux.org/title/Wayland)
