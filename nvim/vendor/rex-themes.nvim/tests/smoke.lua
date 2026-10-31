-- nvim --headless -u NONE -i NONE -l tests/smoke.lua  (from the plugin root)
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.cmd("syntax on")

local function equal(actual, expected, label)
  assert(actual == expected, label .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
end

local function color(value)
  return tonumber(value:sub(2), 16)
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local palettes = require("rex_themes.palettes")
local ids = vim.tbl_keys(palettes)
table.sort(ids)

local function check(id)
  local p = palettes[id]
  equal(vim.g.colors_name, "rex-" .. id, "colors_name")
  equal(require("rex_themes").current(), id, "current")
  equal(vim.o.background, p.appearance, id .. " background option")
  equal(hl("Normal").bg, color(p.background), id .. " Normal bg")
  equal(hl("Normal").fg, color(p.foreground), id .. " Normal fg")
  equal(hl("Cursor").bg, color(p.cursor), id .. " Cursor bg")
  equal(hl("Visual").bg, color(p.selection_background), id .. " Visual bg")
  for i = 0, 15 do
    equal(vim.g["terminal_color_" .. i], p.ansi[i], id .. " terminal color " .. i)
  end
  for group in pairs(require("rex_themes.highlights").get(id)) do
    assert(next(hl(group)), id .. ": empty or unresolved highlight " .. group)
  end
  equal(hl("@lsp.type.function").fg, color(p.ansi[4]), id .. " semantic function")
  equal(hl("BlinkCmpKindFunction").fg, color(p.ansi[4]), id .. " blink function")
end

-- Every theme, plus dark/light/dark hops to exercise background switching.
for _, id in ipairs(ids) do
  vim.cmd.colorscheme("rex-" .. id)
  check(id)
end
for _, id in ipairs({ "abyssal-trench", "merino-light", "abyssal-trench" }) do
  vim.cmd.colorscheme("rex-" .. id)
  check(id)
end
print(("rex-themes: %d themes passed"):format(#ids))
vim.cmd("qa!")
