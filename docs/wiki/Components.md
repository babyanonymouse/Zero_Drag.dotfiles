# Software Components

A detailed breakdown of every tool in the Zero-Drag software stack — why it was chosen and how it is configured.

---

## 🪟 Hyprland (Window Manager)

**Package**: `hyprland`

A dynamic tiling Wayland compositor. Chosen for its lightweight footprint, scriptability, and zero compositor overhead when decorations are disabled.

**Key config choices:**
- **Layout**: Dwindle (Master layout available as backup).
- **Rounding**: `0px` — sharp corners, no GPU rounding cost.
- **Blur / Shadows / Animations**: All disabled — maximum thermal and performance headroom.
- **VFR**: Enabled — variable framerate reduces idle GPU load.

---

## 📊 Waybar (Status Bar)

**Package**: `waybar`

Highly customizable Wayland status bar. Styled as a transparent bar with rounded pill-shaped modules.

### Module Layout

| Position | Modules |
| :------- | :------ |
| **Left** | Notification bell (swaync toggle), Clock, Weather |
| **Center** | Hyprland workspaces (5 persistent, icon-based) |
| **Right** | Volume (PulseAudio), Battery, Network, System Tray, Power menu |

### Heat-Safe CPU Module

The Waybar config monitors CPU temperature. When the sensor exceeds **80°C**, the CPU temperature module switches to the `critical` CSS class and turns **red** — a visual alert that the system is thermal-throttling.

### Weather Widget

Live weather is fetched from [wttr.in](https://wttr.in) via `scripts/get_weather.sh`. To set your city, edit the `custom/weather` exec line in `~/.config/waybar/config`:

```jsonc
"exec": "${HOME}/.config/waybar/scripts/get_weather.sh London+UK"
```

Replace spaces with `+` (e.g., `New+York+USA`).

---

## 💻 Kitty (Terminal)

**Package**: `kitty`

GPU-accelerated terminal emulator. Chosen for rendering performance and rich configuration options.

- **Font**: `JetBrains Mono Nerd Font`, size 11.
- **Theme**: Catppuccin Mocha.

---

## 🔍 Fuzzel (Launcher)

**Package**: `fuzzel`

Wayland-native application launcher. Lightweight and fast with no X11 dependencies. Also used as a dmenu replacement for:

- **ALT+Tab** window switcher (`window_switcher.sh`)
- **Clipboard history** picker (`SUPER+V` → `cliphist list | fuzzel --dmenu`)

---

## 📁 Thunar (File Manager)

**Package**: `thunar` + `thunar-archive-plugin` + `thunar-volman` + `file-roller` + `gvfs`

Lightweight GTK file manager. Set as the default file manager via `xdg-mime`.

Custom actions are defined in `.config/Thunar/uca.xml`.

---

## 🖼️ Hyprpaper (Wallpaper Daemon)

**Package**: `hyprpaper`

Efficient Wayland wallpaper daemon with near-zero memory overhead once wallpapers are preloaded.

The `wallpaper-rotate.sh` script randomly selects a wallpaper from `~/.config/hypr/wallpapers/` and applies it via `hyprctl`. Triggered at startup and via `SUPER+W`.

---

## 🔔 swaync (Notifications)

**Package**: `swaync`

Notification daemon with a slide-out notification center. Accessed via the Waybar notification bell or by clicking the bell widget. Styled with Catppuccin Mocha colors.

---

## 🔒 Hyprlock (Lock Screen)

**Package**: `hyprlock`

Wayland lock screen. Minimal design with:
- Time and date display.
- Password input field (Catppuccin Lavender border).
- No blur (zero GPU cost).

Triggered by `SUPER+L` or automatically by `hypridle` after inactivity.

---

## ⏱️ Hypridle (Idle Daemon)

**Package**: `hypridle`

Manages screen timeout and system suspend:

| Timeout | Action |
| :------ | :----- |
| 5 minutes | Screen off (`dpms off`) |
| 10 minutes | Suspend (`systemctl suspend`) |

---

## 🔋 batsignal (Battery Alerts)

**Package**: `batsignal`

Sends desktop notifications at configurable battery levels. Configured in `hyprland.conf`:

```conf
exec-once = batsignal -w 15 -c 5 -d 2 -p
```

| Flag | Threshold | Action |
| :--- | :-------- | :----- |
| `-w 15` | 15% | Warning notification |
| `-c 5` | 5% | Critical notification |
| `-d 2` | 2% | Danger (shutdown) notification |
| `-p` | — | Show percentage in notifications |

---

## 📋 Clipboard (cliphist)

**Package**: `cliphist` + `wl-clipboard`

Clipboard history manager. Both text and image clipboard entries are stored:

```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

Access clipboard history with `SUPER+V`.

---

## 📸 Screenshots (grim + slurp)

**Packages**: `grim`, `slurp`

`screenshot.sh` uses `slurp` to select a screen region, then `grim` to capture it. The image is saved to `~/Pictures/Screenshots/` and copied to the clipboard with `wl-copy`.

---

## 🎨 Color Picker (hyprpicker)

**Package**: `hyprpicker`

Screen color picker. Press `SUPER+Shift+C` to activate, click anywhere on screen to copy the hex color to clipboard.

---

## 🖥️ wlogout (Power Menu)

**Package**: `wlogout`

Stylized power menu with options for logout, shutdown, reboot, suspend, hibernate, and lock. Launched via the Waybar power button.

---

## 🔑 Polkit (Authentication Agent)

**Package**: `polkit-gnome`

Provides GUI authentication prompts for privileged operations (e.g., mounting drives, package installation via GUI tools).

```conf
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
```

---

## 🌐 Network & Bluetooth

| Package | Purpose |
| :------ | :------ |
| `network-manager-applet` | NetworkManager system tray icon (click to open `nm-connection-editor`) |
| `blueman` | Bluetooth manager tray applet |

---

## 🖋️ Fonts

**Package**: `ttf-jetbrains-mono-nerd`

Used across all components: Waybar, Kitty, Hyprlock, Fuzzel. The Nerd Font variant provides all the icons used in status bar modules.

---

## 🎨 Theme

**Package**: `catppuccin-gtk-theme-mocha` + `papirus-icon-theme`

- **GTK Theme**: Catppuccin Mocha Standard Blue Dark
- **Icon Theme**: Papirus-Dark
- **Colors**: Defined in `.config/waybar/colors/colors.css`
