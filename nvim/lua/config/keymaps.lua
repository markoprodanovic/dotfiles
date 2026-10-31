-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, desc = "Exit insert mode" })

-- Cmd+/ comment toggle (mirrors VS Code behavior).
-- <D-/>: Rex passes Cmd+/ through natively via the kitty keyboard protocol.
-- <C-_>: Ghostty forwards Cmd+/ as Ctrl+_ (ghostty/config).
for _, key in ipairs({ "<D-/>", "<C-_>" }) do
  vim.keymap.set("n", key, "gcc", { remap = true, desc = "Toggle comment" })
  vim.keymap.set("v", key, "gc", { remap = true, desc = "Toggle comment" })
end

-- Copy the current file's path (relative to project root) to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local oil_ok, oil = pcall(require, "oil")
  local path = oil_ok and oil.get_current_dir() or nil
  if path then
    path = vim.fn.fnamemodify(path, ":.")
  else
    path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  end
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied path" })
end, { desc = "Yank file path (relative)" })

vim.keymap.set("n", "<leader>gv", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end, { desc = "Toggle Diffview" })

