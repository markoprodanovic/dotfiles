return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },

  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   opts = {
  --     heading = {
  --       backgrounds = { "NONE", "NONE", "NONE", "NONE", "NONE", "NONE" },
  --     },
  --   },
  -- },

  {
    "wallpants/github-preview.nvim",
    cmd = { "GithubPreviewToggle" },
    build = "bun install",
    opts = {
      cursor_line = { disable = true },
    },
    keys = {
      { "<leader>mp", "<cmd>GithubPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
  },
}
