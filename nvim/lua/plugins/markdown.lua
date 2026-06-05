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
