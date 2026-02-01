
# ffnh-led-control (Backend)

Backend für die LED‑Steuerung auf Gluon/OpenWrt‑Nodes (Farbe, Helligkeit, Dauerzustand, Timer). Beachtet modell-/herstellerspezifische Quirks und blendet nicht sinnvoll steuerbare LEDs aus.

## UCI
```sh
uci set ffnh_ledcontrol.status.enabled='1'
uci set ffnh_ledcontrol.status.color='auto'      # auto|red|green|blue|amber|yellow|white
uci set ffnh_ledcontrol.status.brightness='75'   # 0..100
uci set ffnh_ledcontrol.status.state='on'        # on|off
uci set ffnh_ledcontrol.status.trigger='timer'   # permanent|timer
uci set ffnh_ledcontrol.status.delay_on='1000'   # ms
uci set ffnh_ledcontrol.status.delay_off='1000'  # ms
uci add_list ffnh_ledcontrol.status.exclude_glob='*:*:power'
uci commit ffnh_ledcontrol
/etc/init.d/ffnh-led-control reload
```

## Self‑Check
```sh
/usr/libexec/ffnh-led-control/selfcheck.sh
```
Zeigt Board‑Name, steuerbare LEDs, Dimmen/Timer‑Support, aktive Quirks/Excludes, verfügbare Farben, Auto‑Farbwahl und UI‑Hinweise.

## Lizenz & Maintainer
GPL-2.0-or-later — Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
