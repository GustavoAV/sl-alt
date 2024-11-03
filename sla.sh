#!/usr/bin/env bash

set -euo pipefail

get_frames() {
    local option index filename
    option="$1"
    index=0

    while true; do
        filename="${option}${index}.txt"
        if [[ -r "$filename" ]]; then
            frames+=("$(< $filename)")
            index=$((index + 1))
        else
            return 0
        fi
    done
}

print_animation() {
    term_width="${COLUMNS:-80}"
    term_height="${LINES:-24}"

    position="$term_width"

    while [ $position -ge 0 ]; do
        clear
        printf "%*s%s\n" "$position" "" "${frames[0]}"
        sleep 0.1
        position=$((position - 1))
    done

    # index=$(( (index + 1) % ${#array[@]} ))
}

declare -a frames

if [[ $# -gt 0 ]]; then
    get_frames "$1"
else
    frames=( "🚂🚃🚃" )
fi

# echo "${frames[0]}"
print_animation

exit 0
