
return {
  -- Beispiele, bitte je nach realem Boardnamen anpassen/erweitern
  ["ubiquiti,unifi-ac-lite"] = {
    colors = { "blue", "white" },
    leds   = { blue = "ubnt:blue:dome", white = "ubnt:white:dome" },
    default_color = "blue",
  },
  ["ubiquiti,nanostation-m2"] = {
    colors = { "green" },
    leds   = { green = "ubnt:green:status" },
    default_color = "green",
  },
}
