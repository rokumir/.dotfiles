#!/usr/bin/env fish

set -l active_pid (hyprctl activewindow | rg -o 'pid: [0-9]*' | cut -d' ' -f2)

# Check if active_pid is empty or not a number
if [ -z "$active_pid" ]; or not string match -qr '^[0-9]+$' "$active_pid"
    notify-send -u low -i "$HOME/.config/swaync/images/error.png" "Kill Active Window" "No active window PID found."
    exit 1
end

# Close active window
kill "$active_pid"
