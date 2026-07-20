hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/cliphist-watch.sh")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper.sh init")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/watchdog.sh pill")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/watchdog.sh lock")
    hl.exec_cmd("systemctl --user restart hypridle")
    
    -- -- Fix for VS Code / OS Keyring detection
    hl.exec("dbus-update-activation-environment --systemd --all")
hl.exec("gnome-keyring-daemon --start --components=secrets")

end)
