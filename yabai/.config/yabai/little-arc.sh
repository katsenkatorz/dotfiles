#!/bin/sh

# window_created handler for Arc: float Little Arc popups. They never carry
# a "Little Arc" title (Untitled -> url -> page title), but they settle at a
# small frame (~939x535) within a few polls, while real Arc windows are
# screen-sized. Float on the settled-small criterion. Absolute paths:
# signal actions inherit a minimal PATH.

YABAI=/opt/homebrew/bin/yabai
id="$YABAI_WINDOW_ID"
[ -n "$id" ] || exit 0

i=0
while [ $i -lt 20 ]; do
  info=$("$YABAI" -m query --windows --window "$id" 2>/dev/null) || exit 0
  match=$(printf '%s' "$info" | /usr/bin/python3 -c "
import json, sys
w = json.load(sys.stdin)
small = w['frame']['w'] < 1200 and w['frame']['h'] < 800
print('float' if small and not w['is-floating'] else
      'done' if w['is-floating'] else 'wait')
")
  case "$match" in
    float)
      "$YABAI" -m window "$id" --toggle float 2>/dev/null
      FOCUSED=$("$YABAI" -m query --spaces --space | /usr/bin/python3 -c "import json,sys; print(json.load(sys.stdin)['index'])")
      "$YABAI" -m window "$id" --space "$FOCUSED" 2>/dev/null
      exit 0 ;;
    done) exit 0 ;;
  esac
  sleep 0.05
  i=$((i + 1))
done
