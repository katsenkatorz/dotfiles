#!/bin/sh

# Two top samples: the first one only reports the since-boot average.
CPU="$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ {u=$3; s=$5} END {gsub("%","",u); gsub("%","",s); printf "%d", u+s}')"
sketchybar --set "$NAME" label="${CPU}%"
