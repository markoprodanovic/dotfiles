-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("VimLeave", {
  command = "set guicursor=a:ver25-blinkon1",
})

-- Muted diff highlights (Bearded arc-blueberry sets these too saturated)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiffAdd",    { bg = "#1a3a1a", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a1a1a", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1a2a3a", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffText",   { bg = "#2a4a6a", fg = "NONE", bold = true })
  end,
})
