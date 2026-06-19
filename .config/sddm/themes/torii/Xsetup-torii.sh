#!/bin/sh
if xrandr | grep -q "DP-3 connected"; then
    xrandr --output DP-3 --primary --auto --output LVDS-1 --auto --right-of DP-3
else
    xrandr --output LVDS-1 --primary --auto
fi
xdotool mousemove 1280 720
