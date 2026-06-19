#!/bin/sh
umask 077
dir="${XDG_RUNTIME_DIR:-/tmp}"
hyprctl monitors -j | jq -r '.[].name' | while read -r out; do
    [ -n "$out" ] || continue
    rm -f "$dir/ricelin-lock-$out.png"
    grim -o "$out" "$dir/ricelin-lock-$out.png" 2>/dev/null
done
qs -c lock ipc call lock lock
