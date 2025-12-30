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

| Component        | Selection      | Why?                                  |
| ---------------- | -------------- | ------------------------------------- |
| **WM**           | **Hyprland**   | Lightweight, scriptable, no overhead. |
| **Terminal**     | **Kitty**      | GPU-accelerated, highly configurable. |
| **Launcher**     | **Fuzzel**     | Wayland-native, lightweight.          |
| **Bar**          | **Waybar**     | Stripped down with "Heat-Safe" logic. |
| **File Manager** | **Nautilus**   | Clean, effective GNOME file manager.  |
| **Wallpaper**    | **Hyprpaper**  | Efficient wallpaper daemon.           |
| **Notify**       | **Mako**       | Minimalist daemon.                    |
| **Shell**        | **Zsh + Rust** | eza, bat, zoxide, ripgrep, starship.  |

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
- **Shell**: Fully modernized with `eza`, `bat`, `zoxide`, `ripgrep`, and `starship` prompt. Icons and syntax highlighting enabled.

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
- **Mouse**:
  - `Drag` with **Left Button** to move/snap windows.
  - `Drag` with **Right Button** to resize windows.

### 4. Keybindings (Core Workflow)

> **Full List**: See [KEYBINDINGS.md](KEYBINDINGS.md) for a complete reference of shortcuts.

**Essential Shortcuts:**

| Key                    | Action               |
| :--------------------- | :------------------- |
| `SUPER + Return`       | Open Terminal        |
| `SUPER + Space`        | Launcher             |
| `ALT + Tab`            | Window Switcher      |
| `SUPER + W`            | Cycle Wallpapers     |
| `SUPER + Q`            | Close Window         |
| `CTRL + ALT + Arrows`  | Move Window Position |
| `SUPER + ALT + Arrows` | Resize Window        |

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

    > **See [PACKAGES.md](PACKAGES.md) for the complete list of packages and installation commands.**

    Basic set:

    ```bash
    yay -S hyprland waybar kitty fuzzel hyprpaper mako polkit-gnome \
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

2.  **Set System Defaults** (Optional):

    To ensure Nautilus and Kitty are system-wide defaults:

    ```bash
    # Set Nautilus as default file manager
    xdg-mime default org.gnome.Nautilus.desktop inode/directory

    # Set Kitty as default terminal (verify schema first with: gsettings list-schemas | grep terminal)
    # For GNOME-based systems:
    # gsettings set org.gnome.desktop.default-applications.terminal exec kitty
    # For alternatives, create/edit ~/.local/share/applications/mimeapps.list
    ```

3.  **Start Hyprland**:
    - Log out of your current session.
    - Select **Hyprland** from your display manager (SDDM/GDM).
    - Log in.

### 🎨 SDDM Login Screen Theme (Optional)

To apply the **Catppuccin Mocha** theme to your SDDM login screen:

**Automated Installation:**

```bash
sudo ./install_sddm_theme.sh
```

This script will:
- Install required Qt5 dependencies (`qt5-graphicaleffects`, `qt5-quickcontrols2`, `qt5-svg`)
- Clone and install the Catppuccin Mocha SDDM theme
- Configure SDDM to use the theme
- Sync your desktop wallpaper to the login screen
- Provide test commands for verification

**Testing the Theme:**

```bash
# Test mode (may not work on all systems)
sddm-greeter --test-mode --theme /usr/share/sddm/themes/catppuccin-mocha

# Or simply reboot to see the login screen
sudo reboot
```

**Manual Installation:**

If you prefer to install manually:

1.  **Install Dependencies:**
    ```bash
    sudo pacman -S --needed qt5-graphicaleffects qt5-quickcontrols2 qt5-svg sddm
    ```

2.  **Install Theme:**
    ```bash
    git clone https://github.com/catppuccin/sddm.git /tmp/catppuccin-sddm
    sudo cp -r /tmp/catppuccin-sddm/src/catppuccin-mocha /usr/share/sddm/themes/
    rm -rf /tmp/catppuccin-sddm
    ```

3.  **Configure SDDM:**
    ```bash
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=catppuccin-mocha" | sudo tee /etc/sddm.conf.d/theme.conf
    ```

4.  **Sync Wallpaper (Optional):**
    ```bash
    sudo mkdir -p /usr/share/sddm/themes/catppuccin-mocha/backgrounds
    sudo cp ~/.config/hypr/wallpapers/digital_art.jpg /usr/share/sddm/themes/catppuccin-mocha/backgrounds/wall.jpg
    sudo sed -i 's|^Background=.*|Background=backgrounds/wall.jpg|' /usr/share/sddm/themes/catppuccin-mocha/theme.conf
    ```

> **Note**: If you are on a laptop, ensure `brightnessctl` is working for backlight keys.

## 📄 License

Provided as-is for personal use.
