# merino.nvim

Two Lua colorschemes for Neovim 0.10+: `merino-dark` and `merino-light`,
derived from **Merino Dark** and **Merino Light** in `theme-studio/themes/`.
Background, foreground, cursor, selection, and all 16 ANSI colors match the
source themes exactly. Secondary UI surfaces blend those palette colors.

Includes editor UI, syntax, Treesitter captures, LSP semantic tokens and
diagnostics, Telescope, Gitsigns, nvim-cmp, blink.cmp, and lualine highlights.
No dependencies; terminal ANSI colors are set when the theme loads.

## Install and use

With lazy.nvim and this local checkout:

```lua
{
  dir = vim.fn.expand("~/Apps/merino.nvim"),
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark" -- or "light"
    vim.cmd.colorscheme("merino")
  end,
}
```

Or add the directory to your runtime path before loading:

```lua
vim.opt.rtp:prepend(vim.fn.expand("~/Apps/merino.nvim"))
vim.cmd.colorscheme("merino-dark") -- or "merino-light"
```

`:colorscheme merino` follows `vim.o.background`, including subsequent
`:set background=light` / `:set background=dark` changes. Explicit variant
names select their own background. True color is enabled automatically.
Cursor highlights use the source cursor colors; terminal cursor rendering
also depends on your terminal and Neovim's `guicursor` setting.

## Lualine

Configure lualine after loading the colorscheme:

```lua
require("lualine").setup({ options = { theme = "merino" } })
```

`merino-dark` and `merino-light` are also available as explicit lualine themes.
If switching backgrounds at runtime, reapply lualine's theme with
`require("merino.lualine").get()` to obtain a fresh table for the current mode.

## Verify

From the repository root:

```sh
nvim --headless -u NONE -i NONE -l tests/smoke.lua
```
