# Troubleshooting

Common issues and their solutions for the Zero-Drag Hyprland setup.

---

## 🔧 Installation Issues

### `yay` not found

Install `yay` first:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si
```

### Keyring / signature errors during install

```bash
sudo pacman -Sy archlinux-keyring
sudo pacman -Su
```

Then re-run `./install.sh`.

### Package not found in official repos

Some packages are AUR-only. Make sure you are using `yay` instead of `pacman`:

```bash
which yay && echo "yay found" || echo "yay not found — install it first"
```

---

## 🖥️ Hyprland Issues

### Black screen on startup

1. Check that your GPU driver is properly installed.
2. Try starting Hyprland from a TTY: log out, press `Ctrl+Alt+F2`, log in, and run `Hyprland`.
3. Check the Hyprland log: `cat ~/.local/share/hyprland/hyprland.log`

### Wrong monitor resolution

Edit `~/.config/hypr/hyprland.conf`:

```conf
# Replace with your monitor name (find it with: hyprctl monitors)
monitor = DP-1, 1920x1080@60, 0x0, 1
```

Run `hyprctl monitors` to see your monitor names and current settings.

### Hyprland crashes immediately

Check for syntax errors in your config:

```bash
cat ~/.local/share/hyprland/hyprland.log | grep -i error
```

---

## 📊 Waybar Issues

### Waybar not showing / blank bar

Restart Waybar:

```bash
~/.config/waybar/scripts/launch.sh
```

Or manually:

```bash
killall waybar; waybar &
```

### Icons not displaying (squares/boxes)

Ensure the Nerd Font is installed:

```bash
yay -S ttf-jetbrains-mono-nerd
fc-cache -f -v
```

Then restart Waybar.

### CPU temp always showing 0 or wrong value

The temperature module path may differ on your hardware. Check available sensors:

```bash
ls /sys/class/thermal/
cat /sys/class/thermal/thermal_zone*/temp
```

Update the `hwmon-path` or `thermal-zone` in `~/.config/waybar/config`.

---

## 🔔 Notification Issues

### No notifications appearing

Check that `swaync` is running:

```bash
pgrep swaync || swaync &
```

If it crashed, restart it:

```bash
killall swaync; swaync &
```

---

## 🔒 Lock Screen Issues

### `hyprlock` not locking / blank screen

Ensure `hyprlock` is installed:

```bash
yay -S hyprlock
```

Check for errors:

```bash
hyprlock 2>&1 | head -20
```

### Lock screen background is wrong color (no wallpaper)

Update the path in `~/.config/hypr/hyprlock.conf`:

```conf
background {
    path = /home/YOUR_USERNAME/.config/hypr/wallpapers/your-wallpaper.jpg
}
```

Replace `YOUR_USERNAME` with your actual username.

---

## 🖼️ Wallpaper Issues

### Wallpapers not cycling with `SUPER+W`

1. Check that wallpapers exist in `~/.config/hypr/wallpapers/`.
2. Make the script executable:
   ```bash
   chmod +x ~/.config/hypr/scripts/wallpaper-rotate.sh
   ```
3. Test the script manually:
   ```bash
   ~/.config/hypr/scripts/wallpaper-rotate.sh
   ```

---

## 📋 Clipboard Issues

### `SUPER+V` opens Fuzzel but clipboard is empty

Ensure `cliphist` is running and collecting entries:

```bash
pgrep cliphist || wl-paste --type text --watch cliphist store &
```

Check stored entries:

```bash
cliphist list
```

---

## 📸 Screenshot Issues

### Screenshots not saved

Check that the `~/Pictures` directory exists:

```bash
mkdir -p ~/Pictures/Screenshots
```

Test the script:

```bash
~/.config/hypr/scripts/screenshot.sh
```

---

## 🐚 Shell Issues

### Zsh plugins not loading (no syntax highlighting / autosuggestions)

Check that the plugins are installed:

```bash
ls /usr/share/zsh/plugins/
```

If missing, install them:

```bash
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions zsh-completions
```

### Starship prompt not showing

Ensure `starship` is installed and on your PATH:

```bash
which starship
starship --version
```

Reinstall if needed: `yay -S starship`

### `eza`/`bat`/`zoxide` aliases not working

These aliases are conditional — they only activate if the tool is installed:

```bash
which eza   # Should return a path
which bat
which zoxide
```

Install missing tools:

```bash
yay -S eza bat zoxide
```

---

## 🔆 Brightness Keys Not Working

Add your user to the `video` group:

```bash
sudo usermod -aG video $USER
```

Log out and back in, then test:

```bash
brightnessctl set +5%
```

---

## 🔊 Audio Issues

### Volume keys not working

Ensure `pamixer` and `wireplumber` are running:

```bash
pgrep wireplumber || wireplumber &
which pamixer
```

Test manually:

```bash
pamixer -i 5    # Increase volume by 5%
pamixer -d 5    # Decrease volume by 5%
```

---

## 🌡️ Thermal / Performance Issues

### System running hot

This setup is designed to minimize thermal load. If you are still experiencing overheating:

1. Confirm blur is disabled: `blur { enabled = false }`.
2. Confirm animations are snap-only (≤100ms): in `hyprland.conf` verify `bezier = snap` is defined and window/workspace animations reference it (e.g. `animation = windows, 1, 1, snap, slide`). Fade, border, and layer animations should be set to `0`.
3. Enable `vfr = true` in the `misc` block.
4. Consider reducing the number of autostart applications in `hyprland.conf`.

---

## 🎵 Album Art Not Showing on Lock Screen

The lock screen album art widget calls `hyprlock-music.sh --art` directly — no background daemon is needed. If album art is missing:

### `hyprlock-music.sh` not executable

```bash
chmod +x ~/.config/hypr/scripts/hyprlock-music.sh
```

### No album art even when music is playing

Ensure `playerctl` is installed and a media player is detected:

```bash
playerctl status
playerctl metadata mpris:artUrl
```

Install playerctl if missing:

```bash
sudo pacman -S playerctl
```

If the art URL is a local file, verify the file exists. If it is a remote URL, verify `curl` is installed (`sudo pacman -S curl`).

For square cropping, `ImageMagick` is used. Verify it is installed:

```bash
which convert || sudo pacman -S imagemagick
```

The cropped art is cached in `$HOME/.cache/hyprlock-art/`. To force a refresh, clear the cache:

```bash
rm -rf ~/.cache/hyprlock-art/
```

---

## 🌙 System Suspending While Music Plays

`suspend_gatekeeper.sh` prevents suspend when a media player is active or system load is above 0.8. If the system still suspends:

1. Verify `playerctl` detects the player: `playerctl status` should return `Playing`.
2. Check the script is executable:
   ```bash
   chmod +x ~/.config/hypr/scripts/suspend_gatekeeper.sh
   ```
3. Test the script manually:
   ```bash
   ~/.config/hypr/scripts/suspend_gatekeeper.sh; echo "exit: $?"
   ```
   A non-zero exit code means suspend was blocked.

---

## 🛠️ Verify Installation

Run the included verification script to check for missing packages or config issues:

```bash
./verify.sh
```

---

## 📖 Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar GitHub Issues](https://github.com/Alexays/Waybar/issues)
- [CachyOS Forum](https://discuss.cachyos.org/)
- [r/hyprland](https://reddit.com/r/hyprland)
