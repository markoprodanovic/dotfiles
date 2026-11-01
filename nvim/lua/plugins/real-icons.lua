return {
  {
    "Mirsmog/real-icons.nvim",
    build = ":RealIcons install",
    opts = {
      backend = "kitty",
      integrations = {
        snacks_picker = true,
        oil = true,
      },
    },
  },
}
