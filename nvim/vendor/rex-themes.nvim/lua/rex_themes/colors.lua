local M = {}

-- Blend a source color into the theme background for secondary UI surfaces.
local function blend(fg, bg, amount)
  local channels = {}
  for i = 2, 6, 2 do
    local a = tonumber(fg:sub(i, i + 1), 16)
    local b = tonumber(bg:sub(i, i + 1), 16)
    channels[#channels + 1] = math.floor(a * amount + b * (1 - amount) + 0.5)
  end
  return string.format("#%02x%02x%02x", unpack(channels))
end

M.blend = blend

-- Semantic colours for a theme id (a key in palettes.lua, e.g. "abyssal-trench").
function M.get(id)
  local p = require("rex_themes.palettes")[id]
  assert(p, "Unknown Rex theme: " .. tostring(id))
  return {
    bg = p.background,
    fg = p.foreground,
    cursor = p.cursor,
    cursor_text = p.cursor_text,
    selection_bg = p.selection_background,
    selection_fg = p.selection_foreground,
    red = p.ansi[1],
    green = p.ansi[2],
    yellow = p.ansi[3],
    blue = p.ansi[4],
    purple = p.ansi[5],
    cyan = p.ansi[6],
    muted = p.ansi[8],
    surface = blend(p.foreground, p.background, 0.045),
    elevated = blend(p.foreground, p.background, 0.08),
    border = blend(p.foreground, p.background, 0.22),
    subtle = blend(p.foreground, p.background, 0.35),
    add = blend(p.ansi[2], p.background, 0.12),
    change = blend(p.ansi[4], p.background, 0.12),
    delete = blend(p.ansi[1], p.background, 0.12),
    diff_text = blend(p.ansi[4], p.background, 0.24),
    warning = blend(p.ansi[3], p.background, 0.12),
    info = blend(p.ansi[6], p.background, 0.12),
  }
end

return M
