# Rofi Configuration

This directory contains the Rofi application launcher configuration.

## Files

- `config.rasi` - Rofi configuration and theme

## Overview

Rofi is a fast and customizable application launcher and window switcher for X11 and Wayland.

## Features

### Modes
- **drun**: Desktop application launcher (default)
- **run**: Command runner
- **window**: Window switcher

### Appearance
- **Theme**: Catppuccin Mocha color scheme
- **Width**: 30% of screen width
- **Icons**: Enabled with Papirus Dark icon theme
- **Font**: JetBrainsMono Nerd Font
- **Border**: Blue rounded border with 10px radius
- **Layout**: Single column with 8 visible items

### Keybindings (Default)
- `Escape` - Close Rofi
- `Enter` - Launch selected application
- `Arrow Keys` or `j/k` - Navigate through items
- `Tab` - Switch between modes
- Type to filter applications

## Usage

Launch Rofi from Hyprland with:
- `SUPER + R` - Open application launcher

Or from terminal:
```bash
rofi -show drun  # Application launcher
rofi -show run   # Command runner
rofi -show window # Window switcher
```

## Dependencies

### Required
- `rofi` - The application itself
- `rofi-wayland` - Wayland support (for Hyprland)

### Optional
- `papirus-icon-theme` - For application icons
- `ttf-jetbrains-mono-nerd` - For proper font rendering

Install on Arch/CachyOS:
```bash
yay -S rofi-wayland papirus-icon-theme ttf-jetbrains-mono-nerd
```

## Customization

### Change Width
Modify the `width` property:
```css
width: 40%;  /* Percentage of screen width */
```

### Number of Items
Modify the `lines` in listview:
```css
lines: 10;  /* Show 10 items at a time */
```

### Colors
The color scheme is defined at the top of `config.rasi`:
```css
* {
    bg: #1e1e2e;          /* Background */
    bg-alt: #313244;      /* Alternative background */
    fg: #cdd6f4;          /* Foreground text */
    fg-alt: #7f849c;      /* Alternative foreground */
}
```

### Icon Theme
Change the `icon-theme` property:
```
icon-theme: "Your-Icon-Theme";
```

## Resources

- [Rofi Documentation](https://github.com/davatorium/rofi)
- [Rofi Wiki](https://github.com/davatorium/rofi/wiki)
- [Rofi Themes](https://github.com/davatorium/rofi-themes)
