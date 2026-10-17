-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_php_lsp = "intelephense"

-- Default border for floats that don't set their own (blink completion/docs, signature help).
-- Floats share the editor bg (see colourscheme.lua), so the border is what separates them.
vim.o.winborder = "rounded"

-- Recognize .env.* files (e.g. .env.local, .env.production) for syntax highlighting
vim.filetype.add({
  filename = {
    [".env.local"] = "sh",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
  },
})
