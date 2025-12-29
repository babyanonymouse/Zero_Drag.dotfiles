# Kitty Terminal Configuration

This directory contains the Kitty terminal emulator configuration.

## Files

- `kitty.conf` - Main Kitty configuration file

## Overview

Kitty is a fast, feature-rich, GPU-based terminal emulator with support for modern terminal features.

## Key Features Configured

### Appearance
- **Font**: JetBrainsMono Nerd Font (11pt)
- **Color Scheme**: Catppuccin Mocha (modern, eye-friendly dark theme)
- **Cursor**: Beam style with smooth blinking
- **Opacity**: 95% background opacity for slight transparency
- **Tab Bar**: Powerline style with slanted separators

### Functionality
- **Scrollback**: 10,000 lines of history
- **Window Padding**: 5px for comfortable spacing
- **Performance**: Optimized repaint and input delays
- **Remote Control**: Enabled for automation

### Keybindings
- `Ctrl+Shift+C` - Copy to clipboard
- `Ctrl+Shift+V` - Paste from clipboard
- `Ctrl+Shift+T` - New tab
- `Ctrl+Shift+Q` - Close tab
- `Ctrl+Shift+→` - Next tab
- `Ctrl+Shift+←` - Previous tab
- `Ctrl+Shift++` - Increase font size
- `Ctrl+Shift+-` - Decrease font size
- `Ctrl+Shift+Backspace` - Reset font size

## Font Requirements

Install JetBrainsMono Nerd Font for full icon support:
```bash
yay -S ttf-jetbrains-mono-nerd
```

## Color Scheme

The configuration uses **Catppuccin Mocha**, a soothing pastel theme with excellent contrast:
- Background: `#1e1e2e`
- Foreground: `#cdd6f4`
- 16 carefully selected terminal colors
- Consistent with the overall system theme

## Customization

### Change Font
Edit the `font_family` and `font_size` lines:
```conf
font_family YourFont
font_size 12.0
```

### Adjust Opacity
Modify `background_opacity`:
```conf
background_opacity 1.0  # Fully opaque
```

### Different Color Scheme
Replace the color definitions with your preferred scheme.

## Resources

- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty GitHub](https://github.com/kovidgoyal/kitty)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
