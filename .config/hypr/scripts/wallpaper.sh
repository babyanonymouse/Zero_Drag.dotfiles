#!/usr/bin/env bash
set -euo pipefail

WPDIR="$HOME/.config/hypr/wallpapers"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/ricelin-wallpaper"
BAG="${XDG_STATE_HOME:-$HOME/.local/state}/ricelin-wallpaper-bag"

ensure_daemon() {
    awww query >/dev/null 2>&1 && return 0
    local attempt i
    for attempt in 1 2 3 4 5; do
        awww-daemon >/dev/null 2>&1 &
        for i in $(seq 1 15); do
            awww query >/dev/null 2>&1 && return 0
            sleep 0.2
        done
    done
    return 1
}

list_pics() {
    find "$WPDIR" -type f \( -iname '*.jpg' -o -iname '*.png' \)
}

refill_bag() {
    local current="" shuffled
    [ -r "$STATE" ] && current=$(cat "$STATE")
    shuffled=$(list_pics | shuf)
    [ -n "$shuffled" ] || return 0
    if [ "$(printf '%s\n' "$shuffled" | head -n1)" = "$current" ] && [ "$(printf '%s\n' "$shuffled" | wc -l)" -gt 1 ]; then
        shuffled=$(printf '%s\n' "$shuffled" | tail -n +2; printf '%s\n' "$current")
    fi
    mkdir -p "$(dirname "$BAG")"
    printf '%s\n' "$shuffled" > "$BAG"
}

pop_bag() {
    local line refilled=false
    mkdir -p "$(dirname "$BAG")"
    (
        flock 9
        while :; do
            if [ ! -s "$BAG" ]; then
                [ "$refilled" = true ] && exit 1
                refill_bag
                refilled=true
                [ -s "$BAG" ] || exit 1
            fi
            line=$(head -n1 "$BAG")
            tail -n +2 "$BAG" > "$BAG.tmp" && mv "$BAG.tmp" "$BAG"
            if [ -f "$line" ]; then
                printf '%s\n' "$line"
                exit 0
            fi
        done
    ) 9>"$BAG.lock"
}

daemon_was_running=true
awww query >/dev/null 2>&1 || daemon_was_running=false
ensure_daemon || exit 0

cmd="${1:-}"

if [ "$cmd" = "init" ]; then
    [ "$daemon_was_running" = true ] && exit 0
    if [ -r "$STATE" ] && pic=$(cat "$STATE") && [ -f "$pic" ]; then
        :
    else
        pic=$(pop_bag) || exit 0
    fi
elif [ "$cmd" = "set" ]; then
    pic="${2:-}"
    [ -f "$pic" ] || exit 1
else
    pic=$(pop_bag) || exit 0
fi

[ -n "$pic" ] || exit 0

awww img "$pic" \
    --transition-type wave \
    --transition-angle 30 \
    --transition-wave "60,30" \
    --transition-fps 60 \
    --transition-step 90

mkdir -p "$(dirname "$STATE")"
printf '%s\n' "$pic" > "$STATE"

wallust run "$pic" >/dev/null 2>&1 || true
hyprctl reload >/dev/null 2>&1 || true
