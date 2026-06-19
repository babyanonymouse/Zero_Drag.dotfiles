# Ricelin Configuration Analysis & Comparison Guide

Welcome to the **Ricelin Rice Analysis**. As an expert ricer, I have analyzed the repository files and broken down every tool, utility, configuration script, and application used.

Below is the structured catalog of what is in this rice, highlighting how you can copy these features over to your own setup, along with critical corrections (such as the fact that **Waybar is not used at all** and the screenshot tool is named **rishot**, not _tissot_).

---

## 1. The Desktop Shell: Quickshell (Not Waybar!)

> [!IMPORTANT]
> **Waybar is not used in this rice.** Instead, the entire desktop interface (the status bar, notifications, and morphing "dynamic island") is custom-written in **Quickshell** using QML/JavaScript.

Quickshell is a modern Wayland shell program that runs QML configurations. In this setup, it is split into several sub-shells under `configs/quickshell/`:

- `pill/`: The main "Dynamic Island" centered at the top. It handles:
  - **Audio/Brightness Mixer** (`Mixer.qml`) via `wpctl` and `brightnessctl`.
  - **Media Player Controls** (`Media.qml`) via MPRIS and `playerctl`.
  - **Network & Bluetooth Controls** (`LinkWifi.qml`, `LinkBt.qml`).
  - **Clipboard History** (`Clipboard.qml`) integration.
  - **Workspaces Indicator** (`Workspaces.qml`).
  - **Wallpaper Swapper & Picker** (`Wallpaper.qml`).
- `topbar/`: The main top bar (`Bar.qml`, `Clock.qml`, `Calendar.qml`, `Tray.qml`).
- `launcher/`: A custom app launcher (`Launcher.qml`).
- `lock/`: A custom lock screen (`LockSurface.qml`) using QML shaders for screen-blur.
- `sidebar/`: A slide-out panel for system actions.

### How it operates (Daemon & IPC model)

The shell manages widgets as background daemons and controls them through Quickshell's built-in IPC.

1.  **Watchdog Scripts:** `configs/hypr/scripts/*-daemon.sh` (e.g. [pill-daemon.sh](file:///media/Hybrid/Ricelin/configs/hypr/scripts/pill-daemon.sh), [lock-daemon.sh](file:///media/Hybrid/Ricelin/configs/hypr/scripts/lock-daemon.sh)) run in the background. They check if the quickshell daemon is active using `qs -c <module> ipc show` and, if not, spawn it using `qs -c <module> -d`.
2.  **IPC Calls:** Interactivity triggers via scripts sending IPC messages. For instance:
    - [launcher.sh](file:///media/Hybrid/Ricelin/configs/hypr/scripts/launcher.sh) runs: `qs -c pill ipc call pill launcher "$mon"`
    - [clipboard.sh](file:///media/Hybrid/Ricelin/configs/hypr/scripts/clipboard.sh) runs: `qs -c pill ipc call pill clipboard "$mon"`

---

## 2. Wallpaper Changer & Color Sync (Wallust)

Retheming and wallpaper transitions are orchestrated via a bash script and template-based color generation.

### The Wallpaper Daemon

- **Transition Engine:** Powered by `swww` (Sway Wayland Wallpaper). The scripts call it via the name `awww`, which is either a wrapper script or a symlink.
- **Transition Style:** Triggered in [wallpaper.sh](file:///media/Hybrid/Ricelin/configs/hypr/scripts/wallpaper.sh):
  ```bash
  awww img "$pic" \
      --transition-type wave \
      --transition-angle 30 \
      --transition-wave "60,30" \
      --transition-fps 60 \
      --transition-step 90
  ```

### Color Sync (Wallust)

When a new wallpaper is selected, `wallpaper.sh` executes `wallust run "$pic"`.

- **Wallust Config:** Defined in [wallust.toml](file:///media/Hybrid/Ricelin/configs/wallust/wallust.toml). It parses the colors of the wallpaper and applies them to templates under `configs/wallust/templates/`:
  1.  `ghostty-colors.tmpl` -> Output to `~/.cache/wallust/ghostty-colors` (Ghostty theme colors).
  2.  `hypr-colors.lua.tmpl` -> Output to `~/.cache/wallust/hypr-colors.lua` (Hyprland window border colors).
  3.  `fastfetch.jsonc.tmpl` -> Output to `~/.config/fastfetch/config.jsonc` (Fastfetch coloring).
- **Applying Colors to Hyprland:** The Hyprland config loads these colors on reload using Lua's `dofile` ([decoration.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/decoration.lua#L1-L11)):
  ```lua
  local ok, wc = pcall(dofile, os.getenv("HOME") .. "/.cache/wallust/hypr-colors.lua")
  local active   = border(wc and wc.active, "#e0563b")
  local inactive = border(wc and wc.inactive, "#313a4d")
  ```

---

## 3. Screenshot Utility: `rishot` (Not "Tissot")

The screenshot tool used in this config is **`rishot`** (a custom screenshot and annotation overlay written for Quickshell). It was likely misread as _tissot_ due to key proximity.

- **Location:** [quickshell/rishot](file:///media/Hybrid/Ricelin/configs/quickshell/rishot)
- **Functionality:** Captures the screen, opens a custom QML overlay (`shell.qml`), provides annotation tools (`AnnLayer.qml`), toolbar controls (`Toolbar.qml`), and settings (`SettingsPanel.qml`).
- **Hyprland Bindings:** Set in [rishot.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/rishot.lua):
  - `Print`: `flock -n -o /tmp/rishot.lock qs -c rishot` (Capture region/annotate)
  - `Shift` + `Print`: `env RISHOT_MODE=monitor qs -c rishot` (Capture full monitor)

---

## 4. Toggle Floating Binds

The floating window toggle is configured in the Hyprland Lua bindings:

- **File:** [binds.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/binds.lua#L8)
- **Lua Syntax:** `hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))`

---

## 5. Custom Fastfetch Logo & Config

- **Logo Art:** Located at [fastfetch/lantern.txt](file:///media/Hybrid/Ricelin/configs/fastfetch/lantern.txt)—a stunning ASCII representation of a Japanese stone lantern (Torii style).
- **Config Generation:** Wallust builds the fastfetch configuration dynamically from the template [fastfetch.jsonc.tmpl](file:///media/Hybrid/Ricelin/configs/wallust/templates/fastfetch.jsonc.tmpl).
- > [!WARNING]
  > The fastfetch template has a hardcoded path on line 5 pointing to `/home/erik/Ricelin/configs/fastfetch/lantern.txt`. If you copy this, you **must** change `erik` to your own username.

---

## 6. Grub Theme (Torii)

- **Theme Location:** `configs/grub/themes/torii/`
- **Installation Script:** [install-torii.sh](file:///media/Hybrid/Ricelin/configs/grub/install-torii.sh) copies the themes, modifies `/etc/default/grub` options (timeout, resolution `2560x1440,auto`), and regenerates the config.
- > [!WARNING]
  > The script copies a file named `10_ricelin` to `/etc/grub.d/`. However, `10_ricelin` is in the repository's `.gitignore` and **was not committed to GitHub**. To use this theme installer, you must write your own `/etc/grub.d/` generator script or leave the default `/etc/grub.d/10_linux` active (by deleting line 27-32 in the installer script).

---

## 7. Brave Theme

- **Theme Location:** [configs/brave-theme](file:///media/Hybrid/Ricelin/configs/brave-theme)
- **Files:** `manifest.json` (Manifest V3 Chromium theme config) and `Cached Theme.pak`.
- **Color Palette:** Vermillion (`#e0563b` / `[224, 86, 59]`) on dark brown.
- **How to use:** Open Brave/Chrome, navigate to `chrome://extensions`, enable **Developer mode**, and click **Load unpacked**. Select the `configs/brave-theme` directory.

---

## 8. SDDM Theme (Torii)

- **Theme Location:** [sddm/themes/torii](file:///media/Hybrid/Ricelin/configs/sddm/themes/torii)
- **Theme Engine:** QML-based theme (`Main.qml`).
- **Installation Script:** [install.sh](file:///media/Hybrid/Ricelin/configs/sddm/themes/torii/install.sh) copies files to `/usr/share/sddm/themes/torii` and sets:
  - `/etc/sddm.conf.d/10-theme.conf` (enables the theme).
  - `/etc/sddm/Xsetup-torii.sh` (forces display layout and cursor warp).
  - `virtualkeyboard.conf` (disables the virtual keyboard).
- > [!NOTE]
  > The file [Xsetup-torii.sh](file:///media/Hybrid/Ricelin/configs/sddm/themes/torii/Xsetup-torii.sh) contains hardware-specific configuration: `xrandr --output DP-0 --primary`. Change `DP-0` to your primary display port (e.g., `DP-1` or `HDMI-A-1`).

---

## 9. Key Highlights from Hyprland & Systemd Folders

### Hyprland Config (v0.55+ Lua configuration)

This setup leverages Hyprland's native Lua configuration language.

- **Monitors & Workspaces:** [monitors.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/monitors.lua) assigns workspaces 1-5 to `DP-1` (280Hz) and workspaces 6-10 to `HDMI-A-1` (144Hz).
- **Animations:** [animations.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/animations.lua) utilizes custom bezier curves (`easeOutQuint`, `quick`, `almostLinear`) to animate workspaces, windows, and layers smoothly.
- **Window Rules:** [window_rules.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/window_rules.lua) enforces floating rules for system dialogs, file pickers, Dolphin (centered, size 1500x850), and Spotify.

### Systemd Integration

- **File:** [hyprland-session.target](file:///media/Hybrid/Ricelin/configs/systemd/user/hyprland-session.target)
- **Purpose:** Registers Hyprland's user session. When Hyprland starts, it triggers `systemctl --user start hyprland-session.target` (see [autostart.lua](file:///media/Hybrid/Ricelin/configs/hypr/modules/autostart.lua#L5)). This allows you to launch background services (like Polkit agents, portal runners, or syncthing) clean and tied directly to the graphical session.

---

## 10. Fish Config Greeting -> Zsh Porting Guide

The fish configuration uses a custom greeting script: [torii-greeting.sh](file:///media/Hybrid/Ricelin/configs/fish/torii-greeting.sh). It pulls system stats and outputs them next to a gorgeous ANSI color art of a Japanese Torii gate.

### Zsh Equivalent Configuration

To implement this in your Zsh setup:

1.  Copy the greeting script: `cp configs/fish/torii-greeting.sh ~/.config/zsh/torii-greeting.sh` (or path of choice). Make sure to make it executable: `chmod +x ~/.config/zsh/torii-greeting.sh`.
2.  Add the following blocks to your `~/.zshrc`:

```zsh
# --- Torii Greeting ---
if [[ -f "$HOME/.config/zsh/torii-greeting.sh" ]]; then
    # Run in bash shell as the script has bash-specific array processing
    bash "$HOME/.config/zsh/torii-greeting.sh"
fi

# --- Zoxide (Smarter cd) ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# --- Abbreviations / Aliases ---
alias ff="fastfetch"
```

---

## Summary of Dependency Stack

If you want to copy this rice over, you will need the following tools installed on your system:

| Tool                    | Purpose                                   | Package Name (Arch Linux)      |
| ----------------------- | ----------------------------------------- | ------------------------------ |
| **Quickshell**          | UI Shell Framework (pill, topbar, lock)   | `quickshell-git` (AUR)         |
| **Hyprland**            | Window Manager (v0.55+ for Lua config)    | `hyprland`                     |
| **swww**                | Wallpaper transitions daemon              | `swww` (referred to as `awww`) |
| **wallust**             | Color scheme extractor/generator          | `wallust`                      |
| **grim**                | Screenshot capture utility (used by lock) | `grim`                         |
| **Ghostty**             | Main Terminal emulator                    | `ghostty`                      |
| **Zoxide**              | Directory jumping helper                  | `zoxide`                       |
| **Bibata-Modern-Ice**   | Cursor theme                              | `bibata-cursor-theme`          |
| **Papirus-Dark**        | Icon Theme                                | `papirus-icon-theme`           |
| **JetBrains Mono Nerd** | Main UI & terminal font                   | `ttf-jetbrains-mono-nerd`      |
| **xdotool / xrandr**    | Mouse centering & display setup (SDDM)    | `xdotool` `xorg-xrandr`        |
| **wpctl / playerctl**   | Audio and media player controls           | `wireplumber` `playerctl`      |
| **brightnessctl**       | Monitor brightness control                | `brightnessctl`                |
| **jq**                  | JSON parser for scripts                   | `jq`                           |
