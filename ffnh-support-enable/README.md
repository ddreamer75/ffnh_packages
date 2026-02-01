# ffnh-support-enable

Integriert einen Schalter **auf der ersten Seite** des Config-Mode-Wizards (unterhalb), um Fernsupport zuzulassen. 
Bei aktivierter Option werden die in der `site.conf` gepflegten Admin-SSH-Keys exakt synchronisiert (neue hinzu, alte entfernt). Nutzer-Keys bleiben unangetastet.

## Einbindung
- Paket in Gluon-Tree (z. B. `package/ffnh-support-enable/`)
- `site.mk`: `PACKAGES += ffnh-support-enable`
- `site.conf` Beispiel:
```lua
support = {
  ssh = {
    keys = {
      "ssh-ed25519 AAAA... admin1",
      "ssh-ed25519 BBBB... admin2",
    }
  }
}
```

## Maintainer
Freifunk Nordhessen e.V. <m.hertel@freifunk-nordhessen.de>
