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

longest_line_size=0

for frame in "${frames[@]}"; do
    current_line_size=$(echo "$frame" | wc -L)
    if [[ $current_line_size -gt $longest_line_size ]]; then
        longest_line_size=$current_line_size
    fi
done

# Print animation

columns=$(tput cols)
position=$((columns - longest_line_size))
frame_time=0.01

cleanup() {
    tput cnorm
}

trap cleanup EXIT
tput civis

# If position >= 0, spaces each line from the frame
# If position < 0, print only section of line
while [[ $position -gt -$longest_line_size ]]; do
    clear

    # TODO: Loop for multiple frames
    while IFS= read -r line; do
        if [[ $position -ge 0 ]]; then
            printf "%*s%s\n" "$position" "" "$line"
        else
            # Substring expansion: https://unix.stackexchange.com/a/163484
            echo "${line: -$position}"
            # abs_position=${position/-/}
            # cut -c "$(( abs_position + 1 ))-$longest_line_size" <<< "$line"

        fi
    done <<<"${frames[0]}"

    sleep "$frame_time"
    position=$((position - 1))
done

cleanup
clear

exit 0
