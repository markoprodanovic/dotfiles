-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LazyVim enables spell check for markdown (via lazyvim_wrap_spell augroup).
-- This overrides it to disable spell check for markdown only, leaving other
-- filetypes (text, plaintex, typst, gitcommit) unaffected.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Disable all format-on-save for PHP files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Disable Intelephense's willSaveWaitUntil which formats on save
-- bypassing conform and LazyVim's format system entirely
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "intelephense" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      -- Disable willSave text edits
      if client.server_capabilities.textDocumentSync then
        if type(client.server_capabilities.textDocumentSync) == "table" then
          client.server_capabilities.textDocumentSync.willSaveWaitUntil = false
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  command = "set guicursor=a:ver25-blinkon1",
})
