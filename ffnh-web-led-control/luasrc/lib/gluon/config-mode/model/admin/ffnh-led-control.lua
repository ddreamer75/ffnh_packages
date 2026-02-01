
local uci = require('simple-uci').cursor()
local fs = require('nixio.fs')

local function leds_dir() return '/sys/class/leds' end
local function has_led_support() return fs.isdir(leds_dir()) end

local function list_leds()
  local t = {}
  for led in fs.dir(leds_dir()) or function() end do t[#t+1] = led end
  return t
end

local function is_dimmable_any()
  for _, led in ipairs(list_leds()) do
    local p = string.format('%s/%s/max_brightness', leds_dir(), led)
    if fs.isfile(p) and tonumber(fs.readfile(p) or '1') > 1 then return true end
  end
  return false
end

local function list_colors()
  local seen, out = {}, {}
  for _, led in ipairs(list_leds()) do
    local c = led:match('^[^:]+:([^:]+):')
    if c and not seen[c] then seen[c]=true; out[#out+1]=c end
  end
  table.sort(out)
  return out
end

local f = Form(translate('LED Control'), translate('Configure the status LED of this device.'))
if not has_led_support() then
  local s = f:section(Section)
  local o = s:option(Value, 'info')
  o.render = function(self, scope)
    scope:write('<div style="background:#333;color:#ccc;padding:.6em;border-radius:.2em;text-align:center;">')
    scope:write(translate('This device does not support LED control.'))
    scope:write('</div>')
  end
  return f
end

local colors = list_colors()
local multiple_colors = (#colors > 1)
local any_dimmable = is_dimmable_any()

local s = f:section(Section, translate('Status LED'))

local en = s:option(Flag, 'enabled', translate('Enable'))
en.default = uci:get('ffnh_ledcontrol','status','enabled') or '1'
function en:write(data) uci:set('ffnh_ledcontrol','status','enabled', data and '1' or '0') end

if multiple_colors then
  local o = s:option(ListValue, 'color', translate('Color'))
  o:value('auto', translate('Automatic'))
  for _, c in ipairs(colors) do o:value(c, c) end
  o.default = uci:get('ffnh_ledcontrol','status','color') or 'auto'
  function o:write(data) uci:set('ffnh_ledcontrol','status','color', data) end
end

local tr = s:option(ListValue, 'trigger', translate('Trigger'))
tr:value('permanent', translate('Permanent'))
tr:value('timer', translate('Timer'))
tr.default = uci:get('ffnh_ledcontrol','status','trigger') or 'permanent'
function tr:write(data) uci:set('ffnh_ledcontrol','status','trigger', data) end

local trig_cur = uci:get('ffnh_ledcontrol','status','trigger') or 'permanent'
if trig_cur == 'timer' then
  local ts = s:option(Section, translate('Timer settings'))
  local onv = ts:option(Value, 'delay_on', translate('On time (ms)'))
  onv.datatype='uinteger'; onv.default = uci:get('ffnh_ledcontrol','status','delay_on') or '500'
  function onv:write(data) uci:set('ffnh_ledcontrol','status','delay_on', tostring(data)) end

  local offv = ts:option(Value, 'delay_off', translate('Off time (ms)'))
  offv.datatype='uinteger'; offv.default = uci:get('ffnh_ledcontrol','status','delay_off') or '500'
  function offv:write(data) uci:set('ffnh_ledcontrol','status','delay_off', tostring(data)) end
end

if any_dimmable then
  local b = s:option(Value, 'brightness', translate('Brightness (%)'), translate('0 = off, 100 = max (mapped to hardware max_brightness).'))
  b.datatype='uinteger'; b.default = uci:get('ffnh_ledcontrol','status','brightness') or '100'
  function b:write(data) uci:set('ffnh_ledcontrol','status','brightness', tostring(data)) end
end

local st = s:option(ListValue, 'state', translate('Permanent state'))
st:value('on', translate('On')); st:value('off', translate('Off'))
st.default = uci:get('ffnh_ledcontrol','status','state') or 'off'
function st:write(data) uci:set('ffnh_ledcontrol','status','state', data) end

function f:write()
  uci:commit('ffnh_ledcontrol')
  os.execute('/etc/init.d/ffnh-led-control reload')
end

return f
