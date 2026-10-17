local M = {}

function M.get(variant)
  local c = require("merino.colors").get(variant or vim.o.background)
  local function mode(accent)
    return {
      a = { fg = c.bg, bg = accent, gui = "bold" },
      b = { fg = c.fg, bg = c.elevated },
      c = { fg = c.muted, bg = c.surface },
    }
  end
  return {
    normal = mode(c.blue),
    insert = mode(c.green),
    visual = mode(c.purple),
    replace = mode(c.red),
    command = mode(c.yellow),
    terminal = mode(c.cyan),
    inactive = {
      a = { fg = c.muted, bg = c.surface },
      b = { fg = c.muted, bg = c.surface },
      c = { fg = c.muted, bg = c.bg },
    },
  }
end

return M
