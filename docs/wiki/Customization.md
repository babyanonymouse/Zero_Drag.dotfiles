# Customization Guide

How to personalize your Zero-Drag setup without breaking the performance-first design.

---

## 🎨 Colors

All colors use the **Catppuccin Mocha** palette. The palette is centralized in:

```
~/.config/waybar/colors/colors.css
```

Edit this file to change the color scheme across all Waybar modules. Then reload Waybar:

```bash
~/.config/waybar/scripts/launch.sh
```

### Catppuccin Mocha Palette Reference

| Name | Hex | Usage |
| :--- | :-- | :---- |
| Base | `#1e1e2e` | Backgrounds |
| Surface0 | `#313244` | Raised surfaces |
| Surface1 | `#45475a` | Inactive borders |
| Overlay2 | `#9399b2` | Disabled text |
| Text | `#cdd6f4` | Primary text |
| Lavender | `#b4befe` | Active borders, accents |
| Blue | `#89b4fa` | Clock, notifications |
| Green | `#a6e3a1` | Battery, success |
| Teal | `#94e2d5` | Network |
| Peach | `#fab387` | Volume, audio |
| Red | `#f38ba8` | Critical alerts (CPU temp) |

---

## 🖼️ Wallpapers

Wallpapers live in `~/.config/hypr/wallpapers/`. Add any `.png`, `.jpg`, or `.jpeg` files there.

The `wallpaper-rotate.sh` script picks a random file from that directory each time it runs:

```bash
SUPER + W    # Cycle to a new random wallpaper
```

To set a specific wallpaper permanently, edit `~/.config/hypr/hyprpaper.conf`:

```conf
preload = ~/.config/hypr/wallpapers/your-wallpaper.jpg
wallpaper = ,~/.config/hypr/wallpapers/your-wallpaper.jpg
```

---

## 📊 Waybar Modules

### Add or Remove Modules

Edit `~/.config/waybar/config` and modify the `modules-left`, `modules-center`, or `modules-right` arrays:

```jsonc
"modules-left": ["clock"],
"modules-center": ["hyprland/workspaces"],
"modules-right": ["pulseaudio", "temperature", "battery", "tray", "custom/notification"]
```

### Timezone

```jsonc
"clock": {
    "timezone": "Europe/Paris"
}
```

### CPU Temperature Threshold

The critical (red) threshold is set in `style.css`. Find the `.critical` rule and adjust if needed. The threshold itself is configured in the `temperature` module block in `config`:

```jsonc
"temperature": {
    "critical-threshold": 80
}
```

---

## ⌨️ Keybindings

Edit `~/.config/hypr/hyprland.conf` to change or add keybindings.

**Syntax:**
```conf
bind = MODIFIER, KEY, ACTION, [params]
```

**Example — add a browser shortcut:**
```conf
bind = $mainMod, B, exec, firefox
```

See the [Keybindings](Keybindings.md) page for the full current list.

---

## 🖋️ Font

The font is used across Waybar, Kitty, Fuzzel, and Hyprlock. To change it:

1. Install your preferred Nerd Font: `yay -S ttf-<fontname>-nerd`
2. Update references in:
   - `~/.config/waybar/style.css` — `font-family`
   - `~/.config/kitty/kitty.conf` — `font_family`
   - `~/.config/hypr/hyprlock.conf` — `font_family`
   - `~/.config/fuzzel/fuzzel.ini` — `font`

---

## 🖥️ Monitor Configuration

Hyprland auto-detects your monitor. For specific resolution, refresh rate, or position, edit `~/.config/hypr/hyprland.conf`:

```conf
# Syntax: monitor = NAME, RESOLUTION@REFRESHRATE, POSITION, SCALE
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 2560x1440@144, 1920x0, 1
```

For multiple monitors with different wallpapers, edit `hyprpaper.conf`:

```conf
preload = ~/.config/hypr/wallpapers/main.jpg
preload = ~/.config/hypr/wallpapers/second.jpg
wallpaper = eDP-1,~/.config/hypr/wallpapers/main.jpg
wallpaper = HDMI-A-1,~/.config/hypr/wallpapers/second.jpg
```

---

## 🔢 Numlock

Numlock is forced **off** by default. To enable it at startup:

```conf
# ~/.config/hypr/hyprland.conf
input {
    numlock_by_default = true
}
```

---

## 🔒 Lock Screen

Update the background image path in `~/.config/hypr/hyprlock.conf`:

```conf
background {
    path = /home/yourusername/.config/hypr/wallpapers/your-wallpaper.jpg
}
```

### Album Art on Lock Screen

The lock screen shows the currently playing track's album art. This is powered by `hyprlock-music.sh`, which is called directly by Hyprlock's `reload_cmd` — no background daemon is required. The script fetches album art from `playerctl`, downloads remote art via `curl` if needed, and caches a square-cropped version (via ImageMagick) in `$HOME/.cache/hyprlock-art/`.

To disable the media widget, remove or comment out the `shape { ... }`, `image { ... }`, and all media `label { ... }` blocks in `~/.config/hypr/hyprlock.conf` (everything below `# MUSIC WIDGET BACKGROUND`).

---

## 🌸 GTK Theme

To switch to a different Catppuccin variant (e.g., Macchiato, Latte):

```bash
yay -S catppuccin-gtk-theme-macchiato
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Macchiato-Standard-Blue-Dark"
```

---

## 🐚 Shell Aliases

Add custom aliases to `~/.zshrc`. The existing aliases section starts after the plugin sourcing block:

```zsh
# Custom aliases
alias myalias='my command'
```

Reload the shell after saving:

```bash
source ~/.zshrc
```

---

## ⚙️ Autostart Applications

Add new autostart entries to `~/.config/hypr/hyprland.conf`:

```conf
exec-once = your-application
```

Use `exec-once` for applications that should start only once per session, and `exec` for applications that should restart if they crash.

---

## 🔔 Idle Timeouts

Edit `~/.config/hypr/hypridle.conf` to change dimming, lock, screen-off, and suspend timeouts:

```conf
listener {
    timeout = 420    # seconds until backlight dims (currently 7 min)
    on-timeout = brightnessctl -s set 10
    on-resume = brightnessctl -r
}

listener {
    timeout = 600    # seconds until lock screen (currently 10 min)
    on-timeout = loginctl lock-session
}

listener {
    timeout = 630    # seconds until screen off (currently 10.5 min)
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}

listener {
    timeout = 900    # seconds until smart suspend (currently 15 min)
    on-timeout = ~/.config/hypr/scripts/suspend_gatekeeper.sh
}
```
