return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          toggle_hidden_ignored = function(picker)
            picker.opts.hidden = not picker.opts.hidden
            picker.opts.ignored = not picker.opts.ignored
            picker:find()
          end,
        },
        win = {
          input = {
            keys = {
              ["<C-h>"] = { "toggle_hidden_ignored", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-h>"] = { "toggle_hidden_ignored", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
    },
  },
}
