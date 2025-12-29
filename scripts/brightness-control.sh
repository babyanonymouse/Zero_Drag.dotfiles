#!/bin/bash
# Brightness control script with notification
# Dependencies: brightnessctl, libnotify

get_brightness() {
    brightnessctl -m | cut -d',' -f4 | tr -d '%'
}

send_notification() {
    brightness=$(get_brightness)
    notify-send -a "brightness" -h int:value:"$brightness" -h string:x-canonical-private-synchronous:brightness "Brightness: ${brightness}%"
}

case "$1" in
    up)
        brightnessctl set +5%
        send_notification
        ;;
    down)
        brightnessctl set 5%-
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac
