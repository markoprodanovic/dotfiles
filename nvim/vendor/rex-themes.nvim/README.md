# rex-themes.nvim

Rex terminal themes as Neovim colorschemes, named `rex-<id>`. Currently
`rex-abyssal-trench`, `rex-merino-dark` and `rex-merino-light`; to add another,
put its id in the `keep` list in `scripts/sync.lua` and re-run it. Ids match
`Workspace.darkThemeID` / `lightThemeID` in `defaults read com.superlogical.rex`.

Background, foreground, cursor, selection and all 16 ANSI colours match Rex
exactly; secondary UI surfaces are blended from them. Light and dark themes set
`background` themselves. Covers editor UI, syntax, Treesitter, LSP semantic
tokens, diagnostics, Telescope, Gitsigns, nvim-cmp and blink.cmp.

Started as a vendored Merino Dark/Light port, generalised to any Rex palette.

## Choosing a theme

Set `colorscheme` at the top of `nvim/lua/plugins/colourscheme.lua`. Preview
live with `:colorscheme rex-<Tab>`. The statusline (`lualine.lua`) reads its
accents from the active theme, so nothing else needs changing.

## Layout

- `lua/rex_themes/palettes.lua` - generated raw palettes, one per theme
- `lua/rex_themes/colors.lua` - palette -> semantic colours (`red`, `surface`, `border`...)
- `lua/rex_themes/highlights.lua` - semantic colours -> highlight groups
- `colors/rex-*.lua` - generated one-line entry points

To restyle every theme at once, edit `colors.lua` or `highlights.lua`.
Personal tweaks live in the `ColorScheme` autocmd in `colourscheme.lua`.

## Syncing from Rex

`palettes.lua` and `colors/` are generated from the `themes.json` bundled in
the Rex app. Re-run after a Rex update changes these themes, or after editing `keep`:

```sh
nvim -l nvim/vendor/rex-themes.nvim/scripts/sync.lua [path/to/themes.json]
```

Without an argument it finds `/Applications/Rex*.app`. Generated files are
committed, so Neovim never depends on the app being installed.

## Verify

From this directory:

```sh
nvim --headless -u NONE -i NONE -l tests/smoke.lua
```
