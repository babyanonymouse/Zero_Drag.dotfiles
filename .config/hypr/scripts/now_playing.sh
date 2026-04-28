#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null
else
    echo ""
fi
