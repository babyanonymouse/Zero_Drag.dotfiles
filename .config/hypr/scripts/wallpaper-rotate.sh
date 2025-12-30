#!/bin/bash

# Folder containing wallpapers
DIR="$HOME/.config/hypr/wallpapers"

# 1. Select a random image (jpg, png, or jpeg)
PICS=($(ls "$DIR" | grep -E ".jpg|.png|.jpeg"))
RANDOM_PIC=${PICS[ $RANDOM % ${#PICS[@]} ]}
WALLPAPER="$DIR/$RANDOM_PIC"

# 2. Tell Hyprpaper to load it
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"

# 3. Save memory (Unload the old one after a brief pause)
sleep 1
hyprctl hyprpaper unload unused