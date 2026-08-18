#!/bin/sh

# wifi_change fires on network transitions; a periodic refresh covers the
# cases it misses (captive portals, sleep/wake). Click opens Wi-Fi settings.
# The legacy `airport` CLI is gone on recent macOS: ipconfig getsummary is
# the supported way to read the current SSID.

if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.wifi-settings-extension"
  exit 0
fi

SSID="$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID :/ {print $2}')"

if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon="󰤨" label="$SSID"
else
  sketchybar --set "$NAME" icon="󰤭" label="off"
fi
