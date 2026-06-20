local mod = "SUPER"
local home = os.getenv("HOME")

-- Core Window Management (User's workflow)
hl.bind(mod .. " + Return",    hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q",         hl.dsp.window.close())
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + M",         hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mod .. " + Tab",       hl.dsp.focus({ workspace = "previous" }))
hl.bind("ALT + Tab",           hl.dsp.exec_cmd("hyprctl dispatch cyclenext"))
hl.bind("ALT + SHIFT + Tab",   hl.dsp.exec_cmd("hyprctl dispatch cyclenext prev"))

-- Focus movement (User's vim keybindings + arrows)
hl.bind(mod .. " + Left",      hl.dsp.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind(mod .. " + Right",     hl.dsp.exec_cmd("hyprctl dispatch movefocus r"))
hl.bind(mod .. " + Up",        hl.dsp.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind(mod .. " + Down",      hl.dsp.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind(mod .. " + H",         hl.dsp.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind(mod .. " + L",         hl.dsp.exec_cmd("hyprctl dispatch movefocus r"))
hl.bind(mod .. " + K",         hl.dsp.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind(mod .. " + J",         hl.dsp.exec_cmd("hyprctl dispatch movefocus d"))

-- Workspaces 1-9 (Loop generation)
for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Mouse Bindings
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Desktop Shell Utilities (Quickshell triggers)
hl.bind(mod .. " + Space",      hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/launcher.sh"))
hl.bind(mod .. " + V",          hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/clipboard.sh"))
hl.bind(mod .. " + SUPER_L",    hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/link.sh"), { release = true })
hl.bind(mod .. " + SHIFT + L",  hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/lock.sh"))
hl.bind(mod .. " + B",          hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper.sh"))
hl.bind(mod .. " + C",          hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wallpaper-picker.sh"))

-- Color picker
hl.bind(mod .. " + SHIFT + C",  hl.dsp.exec_cmd("hyprpicker -a"))

-- Multimedia / Hardware Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                                 { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),                             { locked = true })
