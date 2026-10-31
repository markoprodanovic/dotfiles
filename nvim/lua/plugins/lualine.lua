local function hl_fg(name)
  local fg = vim.api.nvim_get_hl(0, { name = name, link = false }).fg
  return fg and string.format("#%06x", fg)
end

-- Bright ANSI accents (10 green, 11 yellow, 9 red) plus 5 purple and 8 muted,
-- falling back to highlight groups for colorschemes that skip terminal colours.
local function statusline_colors()
  local t = function(i)
    return vim.g["terminal_color_" .. i]
  end
  return {
    fg = hl_fg("Normal"),
    muted = t(8) or hl_fg("Comment"),
    green = t(10) or hl_fg("String"),
    purple = t(5) or hl_fg("Statement"),
    red = t(9) or hl_fg("DiagnosticError"),
    yellow = t(11) or hl_fg("DiagnosticWarn"),
  }
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local icons = LazyVim.config.icons

    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }
    -- Transparent statusline coloured from the active theme, so it follows any
    -- colorscheme. Accents come from the 16 terminal colours, which Rex themes and
    -- Kanagawa both set; lualine re-evaluates this on every :colorscheme.
    opts.options.theme = function()
      local c = statusline_colors()
      return {
        normal = {
          a = { bg = "NONE", fg = c.fg, gui = "bold" },
          b = { bg = "NONE", fg = c.fg },
          c = { bg = "NONE", fg = c.muted },
        },
        insert = { a = { bg = "NONE", fg = c.green, gui = "bold" } },
        visual = { a = { bg = "NONE", fg = c.purple, gui = "bold" } },
        replace = { a = { bg = "NONE", fg = c.red, gui = "bold" } },
        command = { a = { bg = "NONE", fg = c.yellow, gui = "bold" } },
        inactive = {
          a = { bg = "NONE", fg = c.muted },
          b = { bg = "NONE", fg = c.muted },
          c = { bg = "NONE", fg = c.muted },
        },
      }
    end

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
      lualine_y = {},
      lualine_z = {
        {
          "location",
          color = function()
            return { fg = statusline_colors().muted }
          end,
          padding = { left = 1, right = 0 },
        },
      },
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
