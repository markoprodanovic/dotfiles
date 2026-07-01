return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
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
        local t = colors.theme
        return {
          -- Diffview: diagonal fill as editor bg with grey stripes
          DiffviewDiffDelete = { bg = t.ui.bg, fg = t.ui.nontext },
          -- File panel counts: text colour only, no background
          DiffviewFilePanelInsertions = { fg = t.vcs.added },
          DiffviewFilePanelDeletions = { fg = t.vcs.removed },
          -- Status letters (M, A, D, etc.): text colour only, no background
          DiffviewStatusAdded = { fg = t.vcs.added },
          DiffviewStatusUntracked = { fg = t.vcs.added },
          DiffviewStatusModified = { fg = t.vcs.changed },
          DiffviewStatusRenamed = { fg = t.vcs.changed },
          DiffviewStatusCopied = { fg = t.vcs.changed },
          DiffviewStatusTypeChange = { fg = t.vcs.changed },
          DiffviewStatusUnmerged = { fg = t.vcs.changed },
          DiffviewStatusDeleted = { fg = t.vcs.removed },
          DiffviewStatusUnknown = { fg = t.vcs.removed },
          DiffviewStatusBroken = { fg = t.vcs.removed },
          SnacksDashboardHeader = { fg = p.fujiWhite },
          SnacksDashboardIcon = { fg = p.carpYellow },
          SnacksDashboardKey = { fg = p.crystalBlue },
          SnacksDashboardDesc = { fg = p.fujiWhite },
          SnacksDashboardFooter = { fg = p.fujiGray },
          SnacksDashboardTitle = { fg = p.carpYellow },
          SnacksDashboardSpecial = { fg = p.fujiWhite },
          StatusLine = { bg = "NONE", fg = p.fujiWhite },
          StatusLineNC = { bg = "NONE", fg = p.fujiGray },
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
