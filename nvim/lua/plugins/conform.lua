return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = {},
        php = {},
        java = { "google-java-format" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
      },
    },
  },
}
