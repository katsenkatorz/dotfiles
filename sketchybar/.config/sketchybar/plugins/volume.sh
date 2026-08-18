#!/bin/sh

# volume_change supplies $INFO (current volume %, 0 when muted).
# mouse.clicked toggles mute, mouse.scrolled adjusts by $SCROLL_DELTA.

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

    sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
    ;;
  "mouse.clicked")
    osascript -e 'set volume output muted (not output muted of (get volume settings))'
    ;;
  "mouse.scrolled")
    osascript -e "set volume output volume ((output volume of (get volume settings)) + ${SCROLL_DELTA:-0})"
    ;;
esac
