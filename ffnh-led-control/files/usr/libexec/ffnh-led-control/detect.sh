
#!/bin/sh
. /usr/libexec/ffnh-led-control/quirks.sh
LEDS_DIR="/sys/class/leds"
[ -d "$LEDS_DIR" ] || { echo "HAS_LED_CTRL=0"; exit 0; }
LED_LIST=""; COLOR_SET=""
match_globs(){ s="$1"; shift || true; for g in "$@"; do [ -n "$g" ] || continue; case "$s" in $g) return 0;; esac; done; return 1; }
for d in "$LEDS_DIR"/*; do [ -d "$d" ] || continue; base="$(basename "$d")"; match_globs "$base" $QUIRK_EXCLUDE_GLOBS && continue; [ -f "$d/trigger" ] || continue; LED_LIST="$LED_LIST $base"; color="$(echo "$base" | awk -F: '{print $2}')"; [ -n "$color" ] && COLOR_SET="$COLOR_SET $color"; done
COLOR_LIST="$(echo $COLOR_SET | tr ' ' '
' | sort -u | tr '
' ' ' | sed 's/ $//')"
if [ -n "$LED_LIST" ]; then echo "HAS_LED_CTRL=1"; echo "LED_LIST="$LED_LIST""; echo "COLOR_LIST="$COLOR_LIST""; else echo "HAS_LED_CTRL=0"; fi
