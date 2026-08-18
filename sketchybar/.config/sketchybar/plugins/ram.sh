#!/bin/sh

FREE="$(memory_pressure | awk '/percentage/ {print $NF}' | tr -d '%')"
sketchybar --set "$NAME" label="$((100 - FREE))%"
