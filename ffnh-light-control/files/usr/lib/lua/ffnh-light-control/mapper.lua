
local util = {}
function util.readfile(path)
  local f = io.open(path, 'r')
  if not f then return nil end
  local c = f:read('*a')
  f:close()
  return c
end

local jsonc_ok, json = pcall(require, 'luci.jsonc')
local M = {}

local function load_board()
  local data
  if jsonc_ok then
    local content = util.readfile('/etc/board.json')
    if content then
      data = json.parse(content)
    end
  end
  return data or {}
end

local function try_mapper_files(board)
  -- Attempt vendor/model-specific tables from external mapper package
  -- Files: /usr/share/ffnh-light-control/mapper/*.lua should return a table mapping board_name -> info
  local paths = {
    '/usr/share/ffnh-light-control/mapper/zyxel.lua',
    '/usr/share/ffnh-light-control/mapper/ubiquiti.lua',
    '/usr/share/ffnh-light-control/mapper/tplink.lua',
    '/usr/share/ffnh-light-control/mapper/mikrotik.lua',
  }
  for _, p in ipairs(paths) do
    local ok, t = pcall(dofile, p)
    if ok and type(t) == 'table' then
      local info = t[board] or t[(loadfile('/proc/device-tree/model') and io.open('/proc/device-tree/model','r'):read('*l')) or '']
      if info then
        return true, info
      end
    end
  end
  return false
end

local function autodetect(boardjson)
  -- Best-effort: find a likely status LED; also detect colors by name pattern
  local leds = {}
  local colors = {}
  local default
  if type(boardjson) == 'table' and boardjson.leds then
    for name, led in pairs(boardjson.leds) do
      local sysfs = led and led.sysfs
      if sysfs then
        -- Heuristics: prefer LEDs whose name includes 'status' or 'power'
        local lname = tostring(sysfs)
        local lower = lname:lower()
        local color = nil
        for _, c in ipairs({'green','blue','amber','white','red','orange'}) do
          if lower:find(':'..c..':') or lower:find('-'..c..'-') or lower:find('_'..c..'_') then
            color = c
            break
          end
        end
        if lower:find('status') or lower:find('power') then
          if color then
            leds[color] = lname
            colors[#colors+1] = color
            if not default and (color == 'green' or color == 'white') then default = color end
          else
            -- single-color device: map as 'green' by default
            leds['green'] = lname
            if not default then default = 'green' end
            colors[#colors+1] = 'green'
          end
        end
      end
    end
  end
  if next(leds) then
    return true, { colors = colors, leds = leds, default_color = default }
  end
  return false
end

function M.get()
  local board = load_board()
  local board_name = (board and board.board_name) or (board and board.model and board.model.id) or ''
  local ok, info = try_mapper_files(board_name)
  if ok then
    return true, info
  end
  local ok2, info2 = autodetect(board)
  if ok2 then
    return true, info2
  end
  return false
end

return M
