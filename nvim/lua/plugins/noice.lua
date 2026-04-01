return {
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
        },
      },
    },
    init = function()
      local function set_hl()
        local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
        local bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "#1a2130"
        local cyan = "#4ec9b0"

        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = cyan, bg = bg })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", { fg = cyan, bg = bg })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = bg })
        -- Make the icon area blend in (no inner box)
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = cyan, bg = bg })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", { fg = "#f4a261", bg = bg })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#f4a261", bg = bg })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_hl,
      })
      -- Apply immediately if colorscheme already loaded
      set_hl()
    end,
  },
}
