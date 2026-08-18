#!/bin/sh

# volume_change supplies $INFO (current volume %, 0 when muted).
# Left click toggles the slider popup, right click toggles mute,
# scroll adjusts, leaving the bar closes the popup.

case "$SENDER" in
  "volume_change")
    VOLUME="$INFO"

    case "$VOLUME" in
      [6-9][0-9]|100) ICON="󰕾"
      ;;
      [3-5][0-9]) ICON="󰖀"
      ;;
      [1-9]|[1-2][0-9]) ICON="󰕿"
      ;;
      *) ICON="󰖁"
    esac

    sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" \
               --set volume.slider slider.percentage="$VOLUME"
    ;;
  "mouse.clicked")
    if [ "$BUTTON" = "right" ]; then
      osascript -e 'set volume output muted (not output muted of (get volume settings))'
    else
      sketchybar --set "$NAME" popup.drawing=toggle
    fi
    ;;
  "mouse.scrolled")
    osascript -e "set volume output volume ((output volume of (get volume settings)) + ${SCROLL_DELTA:-0})"
    ;;
  "mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off
    ;;
esac
