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
- **VFR**: Enabled via the `debug` block in Hyprland v0.55+.

---

## 📊 Waybar (Status Bar)

**Package**: `waybar`

Highly customizable Wayland status bar. Styled as a transparent bar with rounded pill-shaped modules.

### Module Layout

| Position | Modules |
| :------- | :------ |
| **Left** | Clock |
| **Center** | Hyprland workspaces (4 persistent, icon-based) |
| **Right** | Volume (PulseAudio), Temperature, Battery, System Tray, Power+Notification button |

### Notification & Power Button

The rightmost Waybar module (` `) is a combined **notification count + power menu** toggle. A single click opens the SwayNC Control Center. A right-click toggles Do-Not-Disturb mode.

### Heat-Safe CPU Module

The Waybar config monitors CPU temperature. When the sensor exceeds **80°C**, the CPU temperature module switches to the `critical` CSS class and turns **red** — a visual alert that the system is thermal-throttling.

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

## 🔔 swaync (Notification & Control Center)

**Package**: `swaync`

Notification daemon with a full slide-out **Control Center**, accessible via the Waybar ` ` button or `SUPER+N`. Styled with an opaque Catppuccin Mocha card design.

### Widget Stack (top to bottom)

| Widget | Description |
| :----- | :---------- |
| **MPRIS** | Currently-playing music card. Shows track title, artist, and playback controls. Auto-hides when nothing is playing. |
| **Title** | Panel header with "Notifications" label and a **Clear All** ghost button. |
| **Volume** | Live volume slider (PulseAudio). |
| **Backlight** | Screen brightness slider (brightnessctl). |
| **Notifications** | Scrollable notification list. |
| **Buttons Grid** | Power action row: Lock ·  Suspend · Logout · Reboot · Shutdown. |

### Notification Popup Behaviour

- **Normal / Low** notifications auto-dismiss after **3 seconds**.
- **Critical** notifications persist until manually dismissed.
- Close buttons are hidden by default and fade in on hover.

---

## 🔒 Hyprlock (Lock Screen)

**Package**: `hyprlock`

Wayland lock screen with a full media player widget. Features:
- Time and date display.
- Password input field (Catppuccin Lavender border).
- Frosted glass background blur (2 passes).
- **Music widget**: A semi-transparent rounded card at the bottom of the screen containing:
  - Square-cropped album art (cached in `$HOME/.cache/hyprlock-art/`, reloaded every 2 seconds).
  - Song title and artist name.
  - Active player name with icon (Spotify, Firefox, mpv, VLC, etc.).
  - Clickable ⏮ / ▶/⏸ / ⏭ playback controls via `playerctl`.
  - Pango-markup progress bar with current position and total track length.
- All media data is fetched on-demand by `hyprlock-music.sh` — no background daemon needed.

Triggered by `SUPER+L` or automatically by `hypridle` after inactivity.

---

## ⏱️ Hypridle (Idle Daemon)

**Package**: `hypridle`

Manages screen dimming, locking, and smart suspend. Also locks before system sleep and restores the display on resume.

| Timeout | Action |
| :------ | :----- |
| 7 minutes | Dim backlight to 10% (`brightnessctl -s set 10`); restore on resume |
| 10 minutes | Lock screen (`loginctl lock-session`) |
| 10.5 minutes | Turn off display (`dpms off`); turn on on resume |
| 15 minutes | Smart suspend via `suspend_gatekeeper.sh` |

---

## 📜 Hypr Scripts

Custom shell scripts in `.config/hypr/scripts/`:

| Script | Trigger | Description |
| :----- | :------ | :---------- |
| `wallpaper-rotate.sh` | Startup, `SUPER+W` | Picks a random wallpaper from `~/.config/hypr/wallpapers/` and applies it via `hyprctl`. |
| `screenshot.sh` | `SUPER+S`, `Print` | Region-select screenshot with `slurp`/`grim`; saves to `~/Pictures/Screenshots` and copies to clipboard. |
| `window_switcher.sh` | `ALT+Tab` | Fuzzel-based graphical window picker. |
| `hyprlock-music.sh` | Called by Hyprlock | All-in-one music integration for the lock screen. Accepts flags: `--title`, `--artist`, `--status`, `--length`, `--position`, `--progress-bar`, `--art`, `--player`. Fetches album art from `playerctl` and caches a square-cropped copy in `$HOME/.cache/hyprlock-art/`. Requires `playerctl`; uses `curl` for remote art and `ImageMagick` (`convert`) for cropping. |
| `suspend_gatekeeper.sh` | Hypridle (15 min) | Smart suspend — skips suspend if music is playing or system load > 0.8. |

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

## 🖼️ imv (Image Viewer)

**Package**: `imv`

Lightweight Wayland-native image viewer. Set as the default XDG handler for common image types (PNG, JPG, WEBP, GIF, BMP, TIFF, ICO, SVG). Supports transparency checking.

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
