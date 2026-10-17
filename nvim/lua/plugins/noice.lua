return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        -- Border on LSP hover docs (K); noice draws hover itself and ignores vim.o.winborder
        lsp_doc_border = true,
      },
    },
  },
}
