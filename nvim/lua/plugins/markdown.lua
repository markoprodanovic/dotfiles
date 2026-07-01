return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- vim.NIL, not {}: lazy.nvim merges an empty table into the default
        -- list (keeping markdownlint-cli2 active); vim.NIL clears the key
        markdown = vim.NIL,
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

  -- Peek replaces markdown-preview.nvim, which the lang.markdown extra pulls in
  { "iamcco/markdown-preview.nvim", enabled = false },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      {
        "<leader>mp",
        function()
          if require("peek").is_open() then
            require("peek").close()
          else
            require("peek").open()
          end
        end,
        desc = "Toggle Markdown Preview",
      },
    },
  },
}
