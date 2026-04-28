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
│   │       ├── wallpaper-rotate.sh     # Cycle through wallpapers
│   │       ├── screenshot.sh           # Screenshot utility
│   │       ├── window_switcher.sh      # ALT+Tab window switcher
│   │       ├── hyprlock-music.sh       # All-in-one music info + album art for Hyprlock
│   │       └── suspend_gatekeeper.sh   # Smart suspend (skip if music playing or load > 0.8)
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

### Decoration & Animations

All blur and shadow decorations are **disabled** for performance and thermal control. Animations are enabled but capped to ultra-fast 100ms snap transitions to preserve responsiveness without perceptible delay:

```conf
decoration {
    rounding = 0        # Sharp corners
    blur { enabled = false }
    shadow { enabled = false }
}
animations {
    enabled = true
    # "snap" bezier: 100ms instant-feel slide — perceptually near-zero
    bezier = snap, 0.12, 0.96, 0.18, 1.0
    animation = windows, 1, 1, snap, slide
    animation = workspaces, 1, 1, snap, slidefade 10%
    # fade/border/layers disabled — no visual overhead
    animation = fade, 0
    animation = border, 0
    animation = borderangle, 0
    animation = layers, 0
}
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

Catppuccin Mocha-styled lock screen with a full media player widget.

| Element | Description |
| :------ | :---------- |
| **Background** | Wallpaper image with frosted glass blur (2 passes) |
| **Clock** | 80px `HH:MM`, Lavender, near top of screen |
| **Date** | 24px `Day, Month DD`, centered below clock |
| **Input field** | 250×50px, Lavender outline, Base fill |
| **Music widget** | Semi-transparent rounded card (500×140px) anchored to the bottom |
| **Album art** | 100px square-cropped image from `$HOME/.cache/hyprlock-art/current.jpg`, reloaded every 2s via `hyprlock-music.sh --art`, Lavender border |
| **Song title** | Track title from `hyprlock-music.sh --title` (truncated to 29 chars) |
| **Artist** | Artist name from `hyprlock-music.sh --artist` |
| **Player source** | Active player name + icon from `hyprlock-music.sh --player` |
| **Playback controls** | Clickable ⏮ / ▶/⏸ / ⏭ buttons via `playerctl` |
| **Progress bar** | Pango-markup progress bar from `hyprlock-music.sh --progress-bar` |
| **Position / Length** | Current position and total length from `hyprlock-music.sh --position/--length` |

> **Note**: Update the `path` in the background block to point to your wallpaper file.
> Album art is fetched on-demand by `hyprlock-music.sh` — no background daemon is required. See the [Troubleshooting](Troubleshooting.md#-album-art-not-showing-on-lock-screen) page if album art does not appear.

---

## Idle Management (`hypridle.conf`)

| Timeout | Action |
| :------ | :----- |
| **7 minutes** | Dim backlight to 10% (`brightnessctl -s set 10`); restore on resume |
| **10 minutes** | Lock screen (`loginctl lock-session`) |
| **10.5 minutes** | Turn off display (`dpms off`); turn on on resume |
| **15 minutes** | Smart suspend via `suspend_gatekeeper.sh` |

The `general {}` block locks the session before the system sleeps (`before_sleep_cmd`) and re-enables the display on wake (`after_sleep_cmd`).

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

**Current module layout:**

| Position | Modules |
| :------- | :------ |
| **Left** | Clock |
| **Center** | Hyprland Workspaces |
| **Right** | PulseAudio · Temperature · Battery · System Tray · Power+Notification button |

---

## Notifications & Control Center (`swaync/config.json` + `swaync/style.css`)

swaync is used for a full **Control Center** panel accessible via the rightmost Waybar button (` `) or `SUPER+N`.

### Key config values

| Key | Value | Description |
| :-- | :---- | :---------- |
| `control-center-width` | `350` | Fixed panel width |
| `control-center-height` | `600` | Fixed panel height |
| `control-center-margin-top/right` | `7` | Float gap from screen edges |
| `fit-to-screen` | `false` | Prevents full-screen stretching |
| `timeout` | `3` | Normal popups auto-dismiss after 3s |
| `timeout-low` | `3` | Low-priority popups also auto-dismiss after 3s |
| `timeout-critical` | `0` | Critical popups persist indefinitely |

### Widget order

```json
"widgets": ["mpris", "title", "volume", "backlight", "notifications", "buttons-grid"]
```

Custom icons are stored in `.config/swaync/icons/` and `.config/swaync/images/`.

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
