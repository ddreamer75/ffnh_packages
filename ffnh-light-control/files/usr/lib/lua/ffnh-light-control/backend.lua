
local M = {}
local uci = require('uci').cursor()
local mapper = require('ffnh-light-control.mapper')

local function write(path, value)
  local f = io.open(path, 'w')
  if not f then return false end
  f:write(value)
  f:close()
  return true
end

local function set_led_brightness(sysfs_name, brightness)
  local base = '/sys/class/leds/' .. sysfs_name
  -- Ensure trigger none first to avoid overrides
  write(base .. '/trigger', 'none')
  write(base .. '/brightness', tostring(brightness))
end

function M.apply(color, mode)
  local supported, info = mapper.get()
  if not supported then
    return false, 'unsupported'
  end

  -- Determine color selection
  local selected = color or 'auto'
  if selected == 'auto' then
    selected = info.default_color or (info.colors and info.colors[1]) or nil
  end

  if not selected or not info.leds or not info.leds[selected] then
    return false, 'no-color'
  end

  -- Turn all group LEDs off first
  for _, name in pairs(info.leds) do
    set_led_brightness(name, 0)
  end

  if mode == 'on' then
    set_led_brightness(info.leds[selected], 255)
  else
    -- keep all off
  end

  return true
end

function M.apply_from_uci()
  local enabled = uci:get('ffnh-light-control', 'main', 'enabled')
  if enabled ~= '1' then
    return true
  end
  local color = uci:get('ffnh-light-control', 'main', 'color') or 'auto'
  local mode = uci:get('ffnh-light-control', 'main', 'mode') or 'on'
  return M.apply(color, mode)
end

return M
