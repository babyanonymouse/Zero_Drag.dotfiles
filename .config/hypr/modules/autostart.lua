hl.on("hyprland.start", function()
    -- Start clipboard history daemon watcher
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/cliphist-watch.sh")
    
    -- Start wallpaper swww daemon and initialize
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper.sh init")
    
    -- Set system cursor
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
    
    -- Register session with systemd user manager
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    
    -- Start Polkit authentication daemon
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    
    -- Launch Quickshell daemon layers (pill bar and lock screen watchdogs)
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/pill-daemon.sh")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/lock-daemon.sh")

    -- Launch hypridle (which triggers suspend_gatekeeper.sh)
    hl.exec_cmd("hypridle")
end)
