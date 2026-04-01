return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = {},
        php = {},
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
      },
    },
  },
}
