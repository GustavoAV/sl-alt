#!/usr/bin/env bash

set -euo pipefail

# Set frames

declare -a frames

if [[ $# -eq 0 ]]; then
    frames=("🚂🚃🚃")
else
    # If provided files as arguments, use them for frames
    while [[ $# -gt 0 ]]; do
        filename=$1
        if [[ -r $filename ]]; then
            frames+=("$(<"$filename")")
        fi
        shift
    done
fi

# Get longest line size
# https://stackoverflow.com/questions/1655372/longest-line-in-a-file

longest_line_size=0

for frame in "${frames[@]}"; do
    current_line_size=$(echo "$frame" | wc -L)
    if [[ $current_line_size -gt $longest_line_size ]]; then
        longest_line_size=$current_line_size
    fi
done

# Print animation

# https://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
columns=$(tput cols)
position=$((columns - longest_line_size))
frame_time=0.05

cleanup() {
    tput cnorm
}

trap cleanup EXIT
tput civis

while [[ $position -ge 0 ]]; do
    clear

    # Spaces each line from the frame
    # TODO: Loop for multiple frames
    while IFS= read -r line; do
        printf "%*s%s\n" "$position" "" "$line"
    done <<<"${frames[0]}"

    sleep "$frame_time"
    position=$((position - 1))
done

cleanup
clear

exit 0
