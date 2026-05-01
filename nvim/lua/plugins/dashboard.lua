return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local art = require("ascii_art")
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = art.mountains2
      opts.dashboard.sections = {
        { section = "header" },
        { text = { { "Welcome Marko", hl = "SnacksDashboardDesc", align = "center" } } },
        { padding = 1 },
        { section = "startup" },
      }
      return opts
    end,
  },
}
