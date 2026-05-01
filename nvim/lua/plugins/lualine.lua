return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    opts.options.section_separators   = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }
    opts.options.theme = {
      normal   = { a = { bg = "NONE", fg = "#DCD7BA", gui = "bold" }, b = { bg = "NONE", fg = "#DCD7BA" }, c = { bg = "NONE", fg = "#727169" } },
      insert   = { a = { bg = "NONE", fg = "#98BB6C", gui = "bold" } },
      visual   = { a = { bg = "NONE", fg = "#957FB8", gui = "bold" } },
      replace  = { a = { bg = "NONE", fg = "#FF5D62", gui = "bold" } },
      command  = { a = { bg = "NONE", fg = "#E6C384", gui = "bold" } },
      inactive = { a = { bg = "NONE", fg = "#727169" }, b = { bg = "NONE", fg = "#727169" }, c = { bg = "NONE", fg = "#727169" } },
    }

    opts.sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "diff",
          symbols = {
            added = icons.git.added,
            modified = icons.git.modified,
            removed = icons.git.removed,
          },
          source = function()
            local summary = vim.b.minidiff_summary
            return summary
              and {
                added = summary.add,
                modified = summary.change,
                removed = summary.delete,
              }
          end,
        },
        { LazyVim.lualine.pretty_path() },
      },
      lualine_x = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
      },
      lualine_y = { { "location", color = { fg = "#727169" } } },
      lualine_z = { { "filetype", icon_only = true } },
    }

    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    }

    return opts
  end,
}
