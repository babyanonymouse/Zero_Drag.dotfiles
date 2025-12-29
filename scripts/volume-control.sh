#!/bin/bash
# Volume control script with notification
# Dependencies: pamixer, libnotify

get_volume() {
    pamixer --get-volume
}

get_mute_status() {
    pamixer --get-mute
}

send_notification() {
    volume=$(get_volume)
    muted=$(get_mute_status)
    
    if [ "$muted" == "true" ]; then
        notify-send -a "volume" -h int:value:0 -h string:x-canonical-private-synchronous:volume "Volume Muted"
    else
        notify-send -a "volume" -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume "Volume: ${volume}%"
    fi
}

case "$1" in
    up)
        pamixer -i 5
        send_notification
        ;;
    down)
        pamixer -d 5
        send_notification
        ;;
    mute)
        pamixer -t
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac
