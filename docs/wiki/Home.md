# Zero-Drag Dotfiles Wiki

Welcome to the **Zero-Drag Hyprland Dotfiles** wiki — a high-performance, minimalist Hyprland configuration optimized for **CachyOS** and thermally constrained hardware.

> **Philosophy**: *"I am the guy in the garage tuning a race car engine that's running hot. I need precision, efficiency, and zero distractions."*

---

## 📚 Wiki Pages

| Page | Description |
| :--- | :---------- |
| [Home](Home.md) | This page — overview and navigation |
| [Installation](Installation.md) | How to install and set up the dotfiles |
| [Configuration](Configuration.md) | Reference for all configuration files |
| [Keybindings](Keybindings.md) | Complete keybinding reference |
| [Components](Components.md) | Software stack and component details |
| [Customization](Customization.md) | How to customize your setup |
| [Shell Setup](Shell-Setup.md) | Zsh shell configuration details |
| [Troubleshooting](Troubleshooting.md) | Common issues and solutions |

---

## 🏁 Design Principles

| Principle | Details |
| :-------- | :------ |
| **Visuals** | Catppuccin Mocha, High Contrast, Sharp Corners (0px rounding) |
| **Performance** | Zero Blur, Zero Shadows, Zero Animations, Zero Bloat |
| **Thermal Safety** | Critical red-line CPU temperature indicators on the status bar |
| **Ergonomics** | Vim-style navigation, modern Rust-powered CLI tools |

---

## 🛠️ Quick Software Overview

| Component | Tool | Purpose |
| :-------- | :--- | :------ |
| **Window Manager** | Hyprland | Dynamic tiling Wayland compositor |
| **Terminal** | Kitty | GPU-accelerated terminal |
| **Launcher** | Fuzzel | Wayland-native app launcher |
| **Status Bar** | Waybar | Heat-safe system bar |
| **File Manager** | Thunar | Lightweight GTK file manager |
| **Wallpaper** | Hyprpaper | Efficient wallpaper daemon |
| **Notifications** | swaync | Minimalist notification daemon |
| **Lock Screen** | Hyprlock | Wayland lock screen |
| **Shell** | Zsh + Starship | Modern shell with Rust-powered tools |

---

## ⚡ Quick Start

```bash
git clone https://github.com/babyanonymouse/Zero_Drag.dotfiles.git
cd Zero_Drag.dotfiles
chmod +x install.sh verify.sh update_configs.sh
./install.sh
```

See the [Installation](Installation.md) page for full details.

---

## 🔗 External Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Catppuccin Theme](https://catppuccin.com/)
- [CachyOS](https://cachyos.org/)
