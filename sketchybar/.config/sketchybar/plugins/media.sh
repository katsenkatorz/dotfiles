#!/bin/sh

# Now Playing via media-control (macOS 15.4+ closed the MediaRemote API to
# third parties; this helper is the supported path). Click = play/pause.
# Absolute path: launchd services do not have /opt/homebrew/bin in PATH.

MC=/opt/homebrew/bin/media-control

if [ "$SENDER" = "mouse.clicked" ]; then
  "$MC" toggle-play-pause
  sleep 0.3
fi

eval "$("$MC" get 2>/dev/null | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin) or {}
except Exception:
    d = {}
title = (d.get("title") or "").replace("\x27", " ")
artist = (d.get("artist") or "").replace("\x27", " ")
label = f"{artist} - {title}" if artist and title else (title or "")
playing = d.get("playing")
print(f"LABEL=\x27{label}\x27")
print(f"PLAYING={1 if playing else 0}")
')"

if [ -z "$LABEL" ]; then
  sketchybar --set "$NAME" drawing=off
elif [ "$PLAYING" = "1" ]; then
  sketchybar --set "$NAME" drawing=on icon="" label="$LABEL"
else
  sketchybar --set "$NAME" drawing=on icon="" label="$LABEL"
fi
