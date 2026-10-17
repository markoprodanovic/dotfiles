local M = {}

function M.load(variant)
  local name = variant and ("merino-" .. variant) or "merino"
  variant = variant or vim.o.background
  local palette = require("merino.palettes")[variant]
  assert(palette, "Unknown Merino variant: " .. tostring(variant))

  vim.o.termguicolors = true
  vim.o.background = variant
  vim.cmd("highlight clear")
  if vim.g.syntax_on then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = name

  for group, spec in pairs(require("merino.highlights").get(variant)) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = palette.ansi[i]
  end
end

return M
