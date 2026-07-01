return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- vim.NIL, not {}: lazy.nvim merges an empty table into the default
        -- list (keeping shfmt/php_cs_fixer active); vim.NIL clears the key
        sh = vim.NIL,
        php = vim.NIL,
        java = { "google-java-format" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
      },
    },
  },
}
