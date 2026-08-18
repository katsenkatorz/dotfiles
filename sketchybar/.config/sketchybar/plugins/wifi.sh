#!/bin/sh

# wifi_change + periodic refresh update the SSID. Click toggles a popup
# with the local IP and a shortcut to the Wi-Fi settings.
# The legacy `airport` CLI is gone on recent macOS: ipconfig getsummary is
# the supported way to read the current SSID.

case "$SENDER" in
  "mouse.clicked")
    IP="$(ipconfig getifaddr en0 2>/dev/null)"
    sketchybar --set wifi.ip label="IP  ${IP:-aucune}" \
               --set "$NAME" popup.drawing=toggle
    ;;
  "mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  *)
    SSID="$(ipconfig getsummary en0 2>/dev/null | awk -F ' SSID : ' '/ SSID :/ {print $2}')"

    if [ -n "$SSID" ]; then
      sketchybar --set "$NAME" icon="󰤨" label="$SSID"
    else
      sketchybar --set "$NAME" icon="󰤭" label="off"
    fi
    ;;
esac
