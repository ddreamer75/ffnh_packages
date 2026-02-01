
# ffnh-light-control (Gluon Package)

**Maintainer:** Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>

Dieses Gluon-Paket stellt eine Administrationsseite bereit, um die Status-LED eines Geräts
je nach Hardwaremodell zu steuern (Farbwahl falls vorhanden, sowie permanentes An/Aus).
Falls die Hardware keine LED-Steuerung unterstützt, blendet die Admin-Seite die Optionen aus
und zeigt einen deaktivierten Hinweistext.

## Features
- Hardware-Erkennung via Mapper (separates Paket `gluon-ffnh-light-control-led-mapper`) oder Fallback-Autodetektion
- Dropdown für LED-Farbe (sofern mehrere Farben verfügbar)
- Modus: "Permanent an" oder "Permanent aus" (setzt Trigger auf `none` und steuert `brightness`)
- Mehrsprachig (de/en)
- Anwendung der Einstellungen beim Speichern sowie beim Booten (Init-Skript)

## Installation
1. Das Paket in Eure `site.mk` aufnehmen:
   ```make
   GLUON_SITE_PACKAGES +=                    gluon-ffnh-light-control                    gluon-ffnh-light-control-led-mapper
   ```
2. Bauen und flashen wie gewohnt.

> Hinweis: Das Mapper-Paket ist optional, verbessert aber die Erkennung je nach Hersteller/Modell.
> Ohne Mapper versucht die Autodetektion, eine Status-LED aus `/etc/board.json`/`/sys/class/leds` herzuleiten.

## Konfiguration
UCI-Pfade:
```
config led_control 'main'
    option enabled '1'
    option color 'auto'      # z.B. auto|green|blue|amber|white|red (modellabhängig)
    option mode 'on'         # on|off
```

## Funktionsweise
- Beim Speichern im Admin-UI werden die Werte in `uci` geschrieben und eine Apply-Routine aufgerufen.
- Die Apply-Routine setzt den LED-Trigger auf `none` und `brightness` je nach Modus/ausgewählter Farbe.
- Bei mehrfarbigen LEDs werden nicht ausgewählte Farben ausgeschaltet.

## Lizenz
Dieses Paket ist für Gluon/OpenWrt gedacht. Sofern nicht anders angegeben, gilt GPL-3.0-or-later.
