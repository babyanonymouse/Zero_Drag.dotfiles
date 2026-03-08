# Zero-Drag Hyprland Dotfiles

A high-performance, minimalist Hyprland configuration optimized for **CachyOS** and thermally constrained hardware.

> **Philosophy**: *"I am the guy in the garage tuning a race car engine that's running hot. I need precision, efficiency, and zero distractions."*

---

## 🏁 Design Principles

| Principle | Details |
| :-------- | :------ |
| **Visuals** | Catppuccin Mocha, High Contrast, Sharp Corners (0px rounding) |
| **Performance** | Zero Blur, Zero Shadows, Zero Animations, Zero Bloat |
| **Thermal Safety** | Critical red-line CPU temperature indicators on the status bar |
| **Ergonomics** | Vim-style navigation, modern Rust-powered CLI tools |

---

## 🛠️ Software Stack

| Component | Tool | Purpose |
| :-------- | :--- | :------ |
| **Window Manager** | Hyprland | Dynamic tiling Wayland compositor |
| **Terminal** | Kitty | GPU-accelerated terminal |
| **Launcher** | Fuzzel | Wayland-native app launcher |
| **Status Bar** | Waybar | Heat-safe system bar |
| **Notifications** | swaync | Control Center with MPRIS, sliders, and power controls |
| **File Manager** | Thunar | Lightweight GTK file manager |
| **Wallpaper** | Hyprpaper | Efficient wallpaper daemon |
| **Lock Screen** | Hyprlock | Wayland lock screen |
| **Shell** | Zsh + Starship | Modern shell with Rust-powered tools |

---

## ⚡ Quick Install

```bash
git clone https://github.com/babyanonymouse/Zero_Drag.dotfiles.git
cd Zero_Drag.dotfiles
chmod +x install.sh verify.sh update_configs.sh
./install.sh
```

---

## 🔄 Updating Configs

After pulling new changes:

```bash
./update_configs.sh
```

---

## 📚 Documentation

Full documentation lives in the [Wiki](docs/wiki/):

| Page | Description |
| :--- | :---------- |
| [Installation](docs/wiki/Installation.md) | How to install and set up the dotfiles |
| [Configuration](docs/wiki/Configuration.md) | Reference for all configuration files |
| [Keybindings](docs/wiki/Keybindings.md) | Complete keybinding reference |
| [Components](docs/wiki/Components.md) | Software stack and component details |
| [Customization](docs/wiki/Customization.md) | How to customize your setup |
| [Shell Setup](docs/wiki/Shell-Setup.md) | Zsh shell configuration details |
| [Troubleshooting](docs/wiki/Troubleshooting.md) | Common issues and solutions |

---

## 📄 License

Provided as-is for personal use.
