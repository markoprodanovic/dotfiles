return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- sourcekit-lsp ships with Xcode; it isn't in Mason
        sourcekit = { mason = false },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },
}
