#!/bin/sh

# Route messaging apps to the MacBook built-in display's space when the lid
# is open, else to space 4 on the main display. Re-run by the
# display_added/display_removed signals, so it must resolve the target at
# call time. Absolute binary paths: signal actions inherit a minimal PATH.

YABAI=/opt/homebrew/bin/yabai
MSG_DISPLAY_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"
APPS="^(Discord|Telegram|Microsoft Teams)$"
FALLBACK_SPACE=4

TARGET=$("$YABAI" -m query --displays | /usr/bin/python3 -c "
import json, sys
uuid = '$MSG_DISPLAY_UUID'
fallback = $FALLBACK_SPACE
spaces = [d['spaces'] for d in json.load(sys.stdin) if d['uuid'] == uuid]
print(spaces[0][0] if spaces and spaces[0] else fallback)
")

"$YABAI" -m rule --remove msg-space 2>/dev/null
"$YABAI" -m rule --add label=msg-space app="$APPS" space="$TARGET"

# Relocate windows that are already open
"$YABAI" -m query --windows | /usr/bin/python3 -c "
import json, re, sys
for w in json.load(sys.stdin):
    if re.match(r'$APPS', w['app']):
        print(w['id'])
" | while read -r wid; do
  "$YABAI" -m window "$wid" --space "$TARGET"
done
