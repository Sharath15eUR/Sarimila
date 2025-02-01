#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
Output="output.txt"

> "$Output"

grep -E '"frame.time"|"wlan.fc.type"|"wlan.fc.subtype"' "$input_file" > temp.txt

frame_time=""
fc_type=""
fc_subtype=""


while IFS= read -r line; do
    if [[ $line == *"frame.time"* ]]; then
        frame_time=$line
    elif [[ $line == *"wlan.fc.type"* ]]; then
        fc_type=$line
    elif [[ $line == *"wlan.fc.subtype"* ]]; then
        fc_subtype=$line
    fi

    if [[ -n $frame_time && -n $fc_type && -n $fc_subtype ]]; then
        echo "----------------------------------" >> "$Output"
        echo "Frame Time     : ${frame_time#*: }" >> "$Output"
        echo "WLAN FC Type   : ${fc_type#*: }" >> "$Output"
        echo "WLAN FC Subtype: ${fc_subtype#*: }" >> "$Output"
        echo "----------------------------------" >> "$Output"

        # Reseting variables for the next group
        frame_time=""
        fc_type=""
        fc_subtype=""
    fi
done < temp.txt

rm temp.txt

echo "Extraction completed. Output saved in $Output."
