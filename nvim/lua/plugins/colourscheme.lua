-- Active theme. Change to "kanagawa" and restart Neovim to switch back.
-- To preview without restarting: :colorscheme kanagawa-wave / :colorscheme merino-dark
local theme = "merino"

local colorschemes = {
  merino = "merino-dark", -- matches Rex's Merino Dark
  kanagawa = "kanagawa-wave",
}

return {
  {
    -- Vendored local copy (no upstream repo), see nvim/vendor/merino.nvim/README.md
    dir = vim.fn.stdpath("config") .. "/vendor/merino.nvim",
    name = "merino.nvim",
    lazy = true,
    init = function()
      -- merino.nvim has no override option, so reapply ours whenever it loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "merino*",
        callback = function()
          local c = require("merino.colors").get(vim.o.background)
          -- Mix fg into bg by `amount` (0-1), same approach as merino.colors
          local function blend(fg, bg, amount)
            local out = {}
            for i = 2, 6, 2 do
              local a, b = tonumber(fg:sub(i, i + 1), 16), tonumber(bg:sub(i, i + 1), 16)
              out[#out + 1] = math.floor(a * amount + b * (1 - amount) + 0.5)
            end
            return string.format("#%02x%02x%02x", unpack(out))
          end
          -- Merino reuses the terminal's inverted selection (solid white, fg forced dark),
          -- which wipes out syntax colours. Use a translucent blue tint and keep fg.
          local selection = blend(c.blue, c.bg, 0.3)
          local overrides = {
            Visual = { bg = selection },
            PmenuSel = { bg = selection },
            PmenuMatchSel = { fg = c.blue, bg = selection, bold = true },
            WildMenu = { bg = selection },
            -- Floats/popups (Snacks explorer + pickers, lazygit, completion, hover) sit on
            -- the editor bg instead of Merino's grey `surface`; borders separate them,
            -- like Rex panes. Relies on vim.o.winborder (options.lua) for borderless popups.
            NormalFloat = { fg = c.fg, bg = c.bg },
            FloatBorder = { fg = c.border, bg = c.bg },
            FloatTitle = { fg = c.blue, bg = c.bg, bold = true },
            FloatFooter = { fg = c.muted, bg = c.bg },
            Pmenu = { fg = c.fg, bg = c.bg },
            MsgSeparator = { fg = c.border, bg = c.bg },
            -- Diffview: diagonal fill as editor bg with grey stripes
            DiffviewDiffDelete = { bg = c.bg, fg = c.subtle },
            -- File panel counts: text colour only, no background
            DiffviewFilePanelInsertions = { fg = c.green },
            DiffviewFilePanelDeletions = { fg = c.red },
            -- Status letters (M, A, D, etc.): text colour only, no background
            DiffviewStatusAdded = { fg = c.green },
            DiffviewStatusUntracked = { fg = c.green },
            DiffviewStatusModified = { fg = c.blue },
            DiffviewStatusRenamed = { fg = c.blue },
            DiffviewStatusCopied = { fg = c.blue },
            DiffviewStatusTypeChange = { fg = c.blue },
            DiffviewStatusUnmerged = { fg = c.blue },
            DiffviewStatusDeleted = { fg = c.red },
            DiffviewStatusUnknown = { fg = c.red },
            DiffviewStatusBroken = { fg = c.red },
            SnacksDashboardHeader = { fg = c.fg },
            SnacksDashboardIcon = { fg = c.yellow },
            SnacksDashboardKey = { fg = c.blue },
            SnacksDashboardDesc = { fg = c.fg },
            SnacksDashboardFooter = { fg = c.muted },
            SnacksDashboardTitle = { fg = c.yellow },
            SnacksDashboardSpecial = { fg = c.fg },
            -- Snacks picker/explorer selection defaults to Visual, which Merino inverts to
            -- solid white. Use Merino's own picker selection style (TelescopeSelection).
            SnacksPickerListCursorLine = { bg = c.elevated, bold = true },
            SnacksPickerPreviewCursorLine = { bg = c.elevated },
            StatusLine = { bg = "NONE", fg = c.fg },
            StatusLineNC = { bg = "NONE", fg = c.muted },
          }
          for group, spec in pairs(overrides) do
            vim.api.nvim_set_hl(0, group, spec)
          end
        end,
      })
    end,
  },
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
      colorscheme = colorschemes[theme],
    },
  },
}
