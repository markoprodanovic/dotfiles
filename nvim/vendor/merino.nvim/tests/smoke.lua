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

local function check(variant, name)
  local p = require("merino.palettes")[variant]
  equal(vim.g.colors_name, name, "colors_name")
  equal(vim.o.background, variant, "background")
  equal(vim.o.termguicolors, true, "termguicolors")
  equal(hl("Normal").bg, color(p.background), "Normal background")
  equal(hl("Normal").fg, color(p.foreground), "Normal foreground")
  equal(hl("Cursor").bg, color(p.cursor), "Cursor background")
  equal(hl("Cursor").fg, color(p.cursor_text), "Cursor foreground")
  equal(hl("Visual").bg, color(p.selection_background), "Visual background")
  equal(hl("Visual").fg, color(p.selection_foreground), "Visual foreground")
  for i = 0, 15 do
    equal(vim.g["terminal_color_" .. i], p.ansi[i], "terminal color " .. i)
  end
  for group in pairs(require("merino.highlights").get(variant)) do
    assert(next(hl(group)), "Empty or unresolved highlight: " .. group)
  end
  equal(hl("@lsp.type.function").fg, color(p.ansi[4]), "semantic function")
  equal(hl("DiagnosticError").fg, color(p.ansi[1]), "diagnostic error")
  equal(hl("GitSignsAdd").fg, color(p.ansi[2]), "git addition")
  equal(hl("CmpItemKindFunction").fg, color(p.ansi[4]), "cmp function")
  equal(hl("BlinkCmpKindFunction").fg, color(p.ansi[4]), "blink function")
  equal(require("merino.lualine").get().normal.a.bg, p.ansi[4], "lualine auto")
  equal(require("lualine.themes.merino-" .. variant).normal.a.bg, p.ansi[4], "lualine variant")
end

-- Repeated switches exercise Lua's module cache and background reloads.
for _, variant in ipairs({ "dark", "light", "dark", "light" }) do
  vim.cmd.colorscheme("merino-" .. variant)
  check(variant, "merino-" .. variant)
end
for _, variant in ipairs({ "dark", "light" }) do
  vim.o.background = variant
  vim.cmd.colorscheme("merino")
  check(variant, "merino")
end
for _, variant in ipairs({ "dark", "light", "dark" }) do
  vim.o.background = variant
  check(variant, "merino")
end
equal(require("lualine.themes.merino").normal.a.bg, "#58a6ff", "lualine entry point")
print("Merino: both variants, automatic background switching, highlights, terminal colors, and lualine passed")
vim.cmd("qa!")
