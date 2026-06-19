hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.monitor({
    output   = "LVDS-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Map workspaces 1-5 to DP-3 (external monitor) and 6-10 to LVDS-1 (laptop display)
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3" })
end

for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "LVDS-1" })
end
