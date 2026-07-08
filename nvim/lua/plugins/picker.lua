return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          -- Single "reveal everything" toggle: flip hidden AND ignored together.
          toggle_hidden_ignored = function(picker)
            picker.opts.hidden = not picker.opts.hidden
            picker.opts.ignored = not picker.opts.ignored
            picker:find()
          end,
        },
        -- One key for every picker: <C-e> reveals hidden + ignored files.
        -- Ctrl works in both the insert-mode search box and the normal-mode
        -- list, needs no terminal changes, and leaves <C-h/j/k/l> for
        -- pane/split navigation (vim-tmux-navigator).
        win = {
          input = {
            keys = {
              ["<c-e>"] = { "toggle_hidden_ignored", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-e>"] = { "toggle_hidden_ignored", mode = { "i", "n" } },
            },
          },
        },
        sources = {
          -- The explorer is a picker too: give it the same <C-e> toggle and
          -- retire its default H (hidden) / I (ignored) split.
          explorer = {
            win = {
              list = {
                keys = {
                  ["<c-e>"] = { "toggle_hidden_ignored", mode = { "i", "n" } },
                  ["H"] = false,
                  ["I"] = false,
                },
              },
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
