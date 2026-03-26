#!/usr/bin/env bash

padding=10
width=355
height=200

loc_x=$padding
loc_y=$((1080 - "$height" - "$padding"))

# -------
niri msg action move-window-to-floating
niri msg action set-column-width $width
niri msg action set-window-height $height
niri msg action move-floating-window --x $loc_x --y $loc_y # bottom left
