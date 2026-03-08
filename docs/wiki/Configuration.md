# Configuration Reference

An overview of all configuration files and their key settings.

---

## Directory Structure

```
.
├── .config/
│   ├── hypr/
│   │   ├── hyprland.conf         # Main Hyprland config
│   │   ├── hyprlock.conf         # Lock screen config
│   │   ├── hypridle.conf         # Idle/suspend config
│   │   ├── hyprpaper.conf        # Wallpaper config
│   │   └── scripts/
│   │       ├── wallpaper-rotate.sh  # Cycle through wallpapers
│   │       ├── screenshot.sh        # Screenshot utility
│   │       └── window_switcher.sh   # ALT+Tab window switcher
│   ├── waybar/
│   │   ├── config                # Waybar module config (JSONC)
│   │   ├── style.css             # Waybar appearance
│   │   ├── colors/colors.css     # Catppuccin Mocha color palette
│   │   └── scripts/
│   │       ├── get_weather.sh    # Weather data via wttr.in
│   │       └── launch.sh         # Restart Waybar and swaync
│   ├── kitty/
│   │   └── kitty.conf            # Kitty terminal config
│   ├── fuzzel/
│   │   └── fuzzel.ini            # Fuzzel launcher config
│   ├── swaync/
│   │   ├── config.json           # swaync notification config
│   │   └── style.css             # Notification styling
│   ├── wlogout/
│   │   ├── layout                # wlogout button layout
│   │   └── style.css             # wlogout styling
│   ├── Thunar/
│   │   └── uca.xml               # Thunar custom actions
│   └── starship.toml             # Starship prompt config
├── .zshrc                        # Zsh shell configuration
├── wallpapers/                   # Wallpaper collection
├── install.sh                    # Automated installer
├── update_configs.sh             # Config updater
└── verify.sh                     # Installation verifier
```

---

## Hyprland (`hyprland.conf`)

The main window manager configuration.

### Monitor

```conf
monitor = ,preferred,auto,1
```

Auto-detects monitor with preferred resolution and scale `1`. For HiDPI screens, change scale to `2`.

### Autostart

| Program | Purpose |
| :------ | :------ |
| `waybar` | Status bar |
| `swaync` | Notification daemon |
| `nm-applet --indicator` | Network Manager tray |
| `blueman-applet` | Bluetooth tray |
| `polkit-gnome-authentication-agent-1` | Polkit authentication agent |
| `hyprpaper` | Wallpaper daemon |
| `wallpaper-rotate.sh` | Initial random wallpaper |
| `hypridle` | Idle/suspend management |
| `batsignal` | Battery level notifications |
| `wl-paste … cliphist store` | Clipboard history (text + images) |

### General Settings

| Setting | Value | Description |
| :------ | :---- | :---------- |
| `gaps_in` | `3` | Inner gaps between windows |
| `gaps_out` | `6` | Outer gaps from screen edges |
| `border_size` | `1` | Window border width (px) |
| `col.active_border` | `rgba(b4befeff)` | Lavender active border |
| `col.inactive_border` | `rgba(6c7086ff)` | Surface1 inactive border |
| `layout` | `dwindle` | Default tiling layout |

### Decoration

All decorations are **disabled** for performance and thermal control:

```conf
decoration {
    rounding = 0        # Sharp corners
    blur { enabled = false }
    shadow { enabled = false }
}
animations { enabled = false }
```

### Input

| Setting | Value | Description |
| :------ | :---- | :---------- |
| `kb_layout` | `us` | Keyboard layout |
| `numlock_by_default` | `false` | Numlock off at start |
| `follow_mouse` | `1` | Focus follows mouse |
| `natural_scroll` | `true` | Touchpad natural scroll |
| `sensitivity` | `0` | Mouse sensitivity (no change) |

### Misc

| Setting | Value | Description |
| :------ | :---- | :---------- |
| `vfr` | `true` | Variable framerate (power saving) |
| `disable_hyprland_logo` | `true` | No default wallpaper |
| `disable_splash_rendering` | `true` | No splash screen |

---

## Lock Screen (`hyprlock.conf`)

Minimal lock screen with Catppuccin Mocha styling.

| Element | Description |
| :------ | :---------- |
| **Background** | Wallpaper image or `rgba(30,30,46)` base color |
| **Blur** | `0 passes` — disabled for performance |
| **Clock** | 64px `HH:MM`, centered, updates every second |
| **Date** | 24px `Day, Month DD`, centered below clock |
| **Input field** | 250×50px, lavender outline, base fill |

> **Note**: Update the `path` in the background block to point to your wallpaper file.

---

## Idle Management (`hypridle.conf`)

| Timeout | Action |
| :------ | :----- |
| **5 minutes** | Turn off display (`dpms off`) |
| **10 minutes** | Suspend system (`systemctl suspend`) |

The lock command (`hyprlock`) is triggered via `loginctl lock-session` (e.g., `SUPER + L`).

---

## Waybar (`config` + `style.css`)

See the [Components](Components.md) page for the full Waybar module breakdown.

**Key settings:**

| Setting | Value |
| :------ | :---- |
| Position | Top |
| Background | Transparent |
| Module style | Rounded pill-shape (`border-radius: 50px`) |
| Font | `JetBrainsMono Nerd Font` |
| Colors | Catppuccin Mocha (via `colors/colors.css`) |

---

## Notifications (`swaync/config.json`)

swaync is used for notifications with a panel accessible via the Waybar notification widget (click) or `SUPER + N`.

The style matches Catppuccin Mocha. Custom icons are stored in `.config/swaync/icons/` and `.config/swaync/images/`.

---

## Kitty Terminal (`kitty/kitty.conf`)

GPU-accelerated terminal. Key defaults:
- **Font**: `JetBrains Mono Nerd Font`
- **Theme**: Catppuccin Mocha

---

## Fuzzel Launcher (`fuzzel/fuzzel.ini`)

Wayland-native application launcher styled with Catppuccin Mocha colors.

Also used for:
- The **ALT+Tab** window switcher (`window_switcher.sh`)
- The **clipboard history** picker (`SUPER+V`)

---

## Shell (`.zshrc`)

See the [Shell Setup](Shell-Setup.md) page for full details.

---

## Starship Prompt (`.config/starship.toml`)

Customizable cross-shell prompt, initialized by `.zshrc`. Edit `~/.config/starship.toml` to adjust prompt segments and icons.
