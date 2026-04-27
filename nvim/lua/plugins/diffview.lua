return {
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
        keymaps = {
          view = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          file_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
        },
      })
    end,
  },
}
