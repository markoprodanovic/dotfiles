return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = false,
      keymaps = {
        ["<leader>ff"] = {
          callback = function()
            local dir = require("oil").get_current_dir()
            Snacks.picker.files({ cwd = dir, title = "Files: " .. vim.fn.fnamemodify(dir, ":.") })
          end,
          desc = "Find files in current directory",
        },
        ["<leader>sg"] = {
          callback = function()
            local dir = require("oil").get_current_dir()
            Snacks.picker.grep({ cwd = dir, title = "Grep: " .. vim.fn.fnamemodify(dir, ":.") })
          end,
          desc = "Grep in current directory",
        },
      },
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
  },
}
