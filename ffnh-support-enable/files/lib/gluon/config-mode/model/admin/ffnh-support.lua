local uci = require('simple-uci').cursor()
local M = {}

function M.section(form)
  local s = form:section(Section, nil, translate(
    "Hier kannst Du technischen Support durch Freifunk-Nordhessen erhalten. " ..
    "Unsere Administratoren erhalten damit Fernzugriff auf deinen Knoten."
  ))

  local o = s:option(Flag, "support_enabled", translate("Fernsupport zulassen"))

  local default_enabled = uci:get_bool("gluon-config-mode", "support_enabled")
  o.default = default_enabled == true
end

function M.handle(data)
  if data and data.support_enabled ~= nil then
    uci:set("gluon-config-mode", "ffnh_support", "settings")
    uci:set("gluon-config-mode", "support_enabled", data.support_enabled and "1" or "0")
    uci:commit("gluon-config-mode")
  end
end

return M
