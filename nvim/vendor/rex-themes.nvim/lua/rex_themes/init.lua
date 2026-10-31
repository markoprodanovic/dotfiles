local M = {}

-- Apply a Rex theme by id (a key in palettes.lua). Invoked by colors/rex-<id>.lua.
function M.load(id)
  local palette = require("rex_themes.palettes")[id]
  assert(palette, "Unknown Rex theme: " .. tostring(id))

  vim.o.termguicolors = true
  vim.cmd("highlight clear")
  -- Clear colors_name first: changing 'background' while it is set makes
  -- Neovim reload the previous colorscheme.
  vim.g.colors_name = nil
  vim.o.background = palette.appearance
  if vim.g.syntax_on then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "rex-" .. id

  for group, spec in pairs(require("rex_themes.highlights").get(id)) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = palette.ansi[i]
  end
end

-- Id of the active Rex theme, or nil if a non-Rex colorscheme is loaded.
function M.current()
  local name = vim.g.colors_name
  return name and name:match("^rex%-(.+)$")
end

return M
