# Zero-Drag Hyprland Dotfiles

A high-performance, minimalist Hyprland configuration optimized for **CachyOS** and thermally constrained hardware.

**Philosophy**: "Function over Flash". Precision, efficiency, and zero distractions.

## 🏁 Philosophy

> "I am the guy in the garage tuning a race car engine that’s running hot. I need precision, efficiency, and zero distractions."

- **Visuals**: Catppuccin Mocha, High Contrast, Sharp Corners.
- **Performance**: Zero Blur, Zero Shadows, Zero Bloat.
- **Thermal Safety**: Critical red-line indicators for CPU heat.

## 🛠️ Software Stack

Selected for startup speed and low footprint.

| Component        | Selection     | Why?                                  |
| ---------------- | ------------- | ------------------------------------- |
| **WM**           | **Hyprland**  | Lightweight, scriptable, no overhead. |
| **Terminal**     | **Kitty**     | GPU-accelerated, highly configurable. |
| **Launcher**     | **Fuzzel**    | Wayland-native, lightweight.          |
| **Bar**          | **Waybar**    | Stripped down with "Heat-Safe" logic. |
| **File Manager** | **Nautilus**  | Clean, effective GNOME file manager.  |
| **Wallpaper**    | **Hyprpaper** | Efficient wallpaper daemon.           |
| **Notify**       | **Mako**      | Minimalist daemon.                    |

## 🎨 Design System

- **Theme**: Catppuccin Mocha full integration.
- **Font**: `JetBrains Mono Nerd Font` (Size 11).
- **Rounding**: **0px** (Sharp corners).
- **Decorations**: NONE. `blur=false`, `drop_shadow=false`.
- **Animations**: Disabled for thermal control.

## ⚙️ Functional Requirements

### 1. "Heat-Safe" Status Bar

- **Logic**: The CPU Temp module turns **RED** (Critical class) if the sensor exceeds **80°C**.
- **Modules**: Workspaces, Clock, CPU Temp, RAM, Battery.

### 2. Window Management

- **Layout**: Dwindle (Master is backup).
- **Focus**: Mouse movement focuses, Click raises.
- **Workspaces**:
  1.  Coding (Terminal/Editor)
  2.  Browser
  3.  Social/Music
  4.  General
  5.  General

### 3. Input Rules

- **Numlock**: Forced `OFF` by default (`numlock_by_default = false`).

### 4. Keybindings (Core Workflow)

> **Full List**: See [KEYBINDINGS.md](KEYBINDINGS.md) for a complete reference of shortcuts.

**Essential Shortcuts:**

| Key              | Action          |
| :--------------- | :-------------- |
| `SUPER + Return` | Open Terminal   |
| `SUPER + Space`  | Launcher        |
| `ALT + Tab`      | Window Switcher |
| `SUPER + Q`      | Close Window    |

## 📦 Installation

### Prerequisites

- **OS**: CachyOS (Recommended) or Arch Linux.
- **Git** installed.

### ⚡ Quick Install (Automated)

The included script handles package installation, backups, and config symlinking.

```bash
git clone https://github.com/babyanonymouse/Zero_Drag.dotfiles.git
cd Zero_Drag.dotfiles
chmod +x install.sh verify.sh update_configs.sh
./install.sh
```

### 🔄 Updating Configs

To update your dotfiles without reinstalling all packages (useful after `git pull`):

```bash
./update_configs.sh
```

### 🛠️ Manual Installation

If you prefer to install packages yourself:

1.  **Install Packages**:

    ```bash
    yay -S hyprland waybar alacritty fuzzel hyprpaper mako polkit-gnome \
           xdg-desktop-portal-hyprland qt5ct grim slurp wl-clipboard \
           brightnessctl playerctl pamixer wireplumber thunar \
           ttf-jetbrains-mono-nerd wlogout rofi-wayland
    ```

2.  **Copy Configs**:
    ```bash
    cp -r .config/* ~/.config/
    ```

### ✅ Post-Installation

1.  **Run Verification**:

    ```bash
    ./verify.sh
    ```

    This script checks for missing packages or config errors.

2.  **Start Hyprland**:
    - Log out of your current session.
    - Select **Hyprland** from your display manager (SDDM/GDM).
    - Log in.

> **Note**: If you are on a laptop, ensure `brightnessctl` is working for backlight keys.

## 📄 License

Provided as-is for personal use.
