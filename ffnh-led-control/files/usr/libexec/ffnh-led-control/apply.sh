
#!/bin/sh
. /lib/functions.sh
. /usr/libexec/ffnh-led-control/quirks.sh
LEDS_DIR="/sys/class/leds"

choose_led_for_color(){
  want="$1"
  prio_list="$QUIRK_COLOR_PRIORITY"; [ -z "$prio_list" ] && prio_list="green white blue amber yellow red"
  if [ "$want" = "auto" ]; then
    for prio in $prio_list; do
      for d in "$LEDS_DIR"/*:"$prio":*; do [ -d "$d" ] || continue; base="$(basename "$d")"; case "$base" in $QUIRK_EXCLUDE_GLOBS) continue;; esac; [ -f "$d/trigger" ] || continue; echo "$d"; return 0; done
    done
    for d in "$LEDS_DIR"/*; do [ -d "$d" ] || continue; base="$(basename "$d")"; case "$base" in $QUIRK_EXCLUDE_GLOBS) continue;; esac; [ -f "$d/trigger" ] || continue; echo "$d"; return 0; done
  else
    for d in "$LEDS_DIR"/*:"$want":*; do [ -d "$d" ] || continue; base="$(basename "$d")"; case "$base" in $QUIRK_EXCLUDE_GLOBS) continue;; esac; [ -f "$d/trigger" ] || continue; echo "$d"; return 0; done
  fi
  return 1
}

scale_brightness(){
  max=1; [ -f "$1/max_brightness" ] && max=$(cat "$1/max_brightness" 2>/dev/null || echo 1)
  pct="$2"; [ "$pct" -lt 0 ] && pct=0; [ "$pct" -gt 100 ] && pct=100
  echo $(( (pct * max + 50) / 100 ))
}

clear_all_leds(){ for d in "$LEDS_DIR"/*; do [ -d "$d" ] || continue; echo none > "$d/trigger" 2>/dev/null; echo 0 > "$d/brightness" 2>/dev/null; done }

apply(){
  enable=1 color=auto pct=100 state=off trig=permanent don=500 doff=500
  config_load ffnh_ledcontrol
  config_get enable status enabled 1
  config_get color  status color   auto
  config_get pct    status brightness 100
  config_get state  status state   off
  config_get trig   status trigger permanent
  config_get don    status delay_on  500
  config_get doff   status delay_off 500

  [ "$enable" = "1" ] || { clear_all_leds; return 0; }
  led="$(choose_led_for_color "$color")" || { clear_all_leds; return 0; }

  if [ "$state" = "off" ]; then echo none > "$led/trigger" 2>/dev/null; echo 0 > "$led/brightness" 2>/dev/null; return 0; fi

  case "$trig" in
    timer)
      echo timer > "$led/trigger" 2>/dev/null
      [ -f "$led/delay_on" ]  && echo "$don"  > "$led/delay_on"  2>/dev/null
      [ -f "$led/delay_off" ] && echo "$doff" > "$led/delay_off" 2>/dev/null
      echo "$(scale_brightness "$led" "$pct")" > "$led/brightness" 2>/dev/null
      ;;
    *)
      echo none > "$led/trigger" 2>/dev/null
      echo "$(scale_brightness "$led" "$pct")" > "$led/brightness" 2>/dev/null
      ;;
  esac
}

case "$1" in start|apply|restart|reload) apply ;; stop) clear_all_leds ;; *) apply ;; esac
