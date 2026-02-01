
# ffnh-light-control-led-mapper

Hersteller-/Modell-Mappings für Status-LEDs, die vom Paket
`gluon-ffnh-light-control` genutzt werden. Hier werden pro Boardname
die sysfs-LED-Namen und verfügbare Farben hinterlegt.

## Struktur
- `files/usr/share/ffnh-light-control/mapper/*.lua` – je Hersteller eine Lua-Datei, die eine Tabelle zurückgibt:

```lua
return {
  ["ubiquiti,unifi-ac-lite"] = {
    colors = { "blue", "white" },
    leds   = { blue = "ubnt:blue:dome", white = "ubnt:white:dome" },
    default_color = "blue"
  },
  -- weitere Modelle ...
}
```

**Hinweis:** Boardnamen entsprechen i.d.R. `board.json.board_name`.

## Beitrag
Pull Requests mit weiteren Modellen/Beispielen sind willkommen.
