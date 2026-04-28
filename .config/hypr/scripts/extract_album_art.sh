#!/bin/bash
# Extracts album art for the currently playing track and saves it to /tmp/album_art.png

playerctl metadata mpris:artUrl --follow 2>/dev/null | while read -r url; do
    if [[ "$url" == file://* ]]; then
        # Local file
        filepath="${url#file://}"
        if [[ -f "$filepath" ]]; then
            cp "$filepath" /tmp/album_art.png
        else
            rm -f /tmp/album_art.png
        fi
    elif [[ "$url" == http://* || "$url" == https://* ]]; then
        # Remote file
        curl -sL "$url" -o /tmp/album_art.png
    else
        # No URL or unsupported protocol
        rm -f /tmp/album_art.png
    fi
done
