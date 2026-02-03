
local uci = require('uci').cursor()
local pkg_i18n = i18n 'ffnh-light-control'
local mapper = require('ffnh-light-control.mapper')

local M = {}

function M.section(form)
  local supported, info = mapper.get()
  if not supported then
    local s = form:section(Section, nil, pkg_i18n.translate('LED control'))
    s:option(DummyValue, nil, '<div style="padding:8px;color:#888;background:#222;border-radius:4px;">' ..
      pkg_i18n.translate('This device does not support status LED control.') .. '</div>')
    return
  end

  local s = form:section(Section, pkg_i18n.translate('LED control'), pkg_i18n.translate('Status LED'))

  local color = s:option(ListValue, 'color', pkg_i18n.translate('Color'))
  color.default = 'auto'
  color:value('auto', pkg_i18n.translate('Automatic'))
  if info.colors then
    for _, c in ipairs(info.colors) do
      color:value(c, c)
    end
  end

  local mode = s:option(ListValue, 'mode', pkg_i18n.translate('Mode'))
  mode:value('on', pkg_i18n.translate('Permanently on'))
  mode:value('off', pkg_i18n.translate('Permanently off'))

  function s:write()
    uci:set('ffnh-light-control', 'main', 'color', color:formvalue())
    uci:set('ffnh-light-control', 'main', 'mode', mode:formvalue())
    uci:commit('ffnh-light-control')
    os.execute('/usr/libexec/ffnh-light-control/apply &')
  end
end

return M
