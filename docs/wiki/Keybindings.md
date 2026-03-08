# Keybindings

A complete reference for all Zero-Drag keyboard shortcuts. The main modifier key is `SUPER` (Windows / Command key).

---

## 🪟 Window Management

| Key Binding | Action |
| :---------- | :----- |
| `SUPER + Q` | Close active window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + M` | Exit Hyprland |
| `SUPER + Tab` | Cycle to next workspace |
| `ALT + Tab` | Window switcher (Fuzzel-based graphical picker) |
| `SUPER + ←/→/↑/↓` | Move focus (arrow keys) |
| `SUPER + H/J/K/L` | Move focus (Vim-style) |
| `CTRL + ALT + ←/→/↑/↓` | Move window position |
| `SUPER + ALT + ←/→/↑/↓` | Resize active window |
| `SUPER + Left Click (drag)` | Move window |
| `SUPER + Right Click (drag)` | Resize window |

---

## 🚀 Applications

| Key Binding | Action |
| :---------- | :----- |
| `SUPER + Return` | Open terminal (Kitty) |
| `SUPER + E` | Open file manager (Thunar) |
| `SUPER + Space` | Open launcher (Fuzzel) |
| `SUPER + V` | Clipboard history picker |
| `SUPER + Shift + C` | Color picker (hyprpicker) |
| `SUPER + S` | Screenshot (region select) |
| `Print` | Screenshot (region select) |
| `SUPER + L` | Lock screen (Hyprlock) |

---

## 📦 Workspaces

| Key Binding | Action |
| :---------- | :----- |
| `SUPER + 1–9` | Switch to workspace 1–9 |
| `SUPER + Shift + 1–9` | Move active window to workspace 1–9 |

### Workspace Layout

| Workspace | Intended Use |
| :-------- | :----------- |
| 1 | Coding (Terminal / Editor) |
| 2 | Browser |
| 3 | Social / Music |
| 4 | General |
| 5 | General |

---

## 🔊 Media & Hardware

| Key Binding | Action |
| :---------- | :----- |
| `XF86AudioRaiseVolume` | Volume up (+5%) |
| `XF86AudioLowerVolume` | Volume down (-5%) |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness up (+5%) |
| `XF86MonBrightnessDown` | Brightness down (-5%) |
| `SUPER + W` | Cycle wallpapers |

---

## 💡 Notes

- `SUPER + Tab` **cycles** through workspaces (`m+1`), it does not show a graphical switcher.
- `ALT + Tab` runs `window_switcher.sh`, which uses Fuzzel as a dmenu-style graphical window picker.
- Screenshots are saved to `~/Pictures/Screenshots` and automatically copied to the clipboard.
- Clipboard history (`SUPER + V`) stores both **text** and **images** via `cliphist`.
