return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      on_highlights = function(hl, c)
        -- Diagonal fill: editor bg with blue-grey stripes
        hl.DiffviewDiffDelete = { bg = c.bg, fg = c.dark3 }
        -- File panel counts: text colour only, no background
        hl.DiffviewFilePanelInsertions = { fg = c.git.add }
        hl.DiffviewFilePanelDeletions = { fg = c.git.delete }
        -- Status letters (M, A, D, etc.): text colour only, no background
        hl.DiffviewStatusAdded = { fg = c.git.add }
        hl.DiffviewStatusUntracked = { fg = c.git.add }
        hl.DiffviewStatusModified = { fg = c.git.change }
        hl.DiffviewStatusRenamed = { fg = c.git.change }
        hl.DiffviewStatusCopied = { fg = c.git.change }
        hl.DiffviewStatusTypeChange = { fg = c.git.change }
        hl.DiffviewStatusUnmerged = { fg = c.git.change }
        hl.DiffviewStatusDeleted = { fg = c.git.delete }
        hl.DiffviewStatusUnknown = { fg = c.git.delete }
        hl.DiffviewStatusBroken = { fg = c.git.delete }
      end,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors)
        local p = colors.palette
        return {
          SnacksDashboardHeader = { fg = p.fujiWhite },
          SnacksDashboardIcon = { fg = p.carpYellow },
          SnacksDashboardKey = { fg = p.crystalBlue },
          SnacksDashboardDesc = { fg = p.fujiWhite },
          SnacksDashboardFooter = { fg = p.fujiGray },
          SnacksDashboardTitle = { fg = p.carpYellow },
          SnacksDashboardSpecial = { fg = p.sakuraPink },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
}
