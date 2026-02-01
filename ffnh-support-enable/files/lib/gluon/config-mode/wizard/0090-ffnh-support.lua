-- Wizard-Modul: zeigt den Schalter auf der ersten Seite (nach Autoupdater-Info)
-- Installationspfad im Image: /lib/gluon/config-mode/wizard/0090-ffnh-support.lua

local uci = require('simple-uci').cursor()

return function(form)
  local s = form:section(Section, nil, translate(
    "Hier kannst Du technischen Support durch Freifunk-Nordhessen erhalten. " ..
    "Unsere Administratoren erhalten damit Fernzugriff auf deinen Knoten."
  ))

  local o = s:option(Flag, 'support_enabled', translate('Fernsupport zulassen'))

  local default_enabled = uci:get_bool('gluon-config-mode', 'support_enabled')
  o.default = default_enabled == true

  function o:write(data)
    uci:set('gluon-config-mode', 'ffnh_support', 'settings')
    uci:set('gluon-config-mode', 'support_enabled', data and '1' or '0')
    uci:commit('gluon-config-mode')
  end
end
