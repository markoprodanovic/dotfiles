-- Rex configuration
-- Symlinked to ~/.config/rex/init.lua by install.sh. Reload with: rex config reload

-- Open a new tab with an SSH connection to `host` (an alias from ~/.ssh/config),
-- attaching to (or creating) a tmux session on the remote so work survives
-- disconnects. Persistence lives on the remote until Rex ships a Linux server.
rex.action{
  name        = "ssh_host",
  title       = "SSH: Connect to Host",
  description = "Open a tab attached to a tmux session on a remote host",
  category    = "Remote",
  keywords    = "ssh remote tmux",
  args        = { host = "string", session = "string?" },
  run         = function(_ctx, args)
    local w, err = rex.session.new_window{
      window_label = args.host,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = {
          command = { "ssh", args.host, "-t", "tmux", "new", "-A", "-s", args.session or "main" },
        },
      },
    }
    if not w then error(err, 0) end
    return { window_id = w.window_id }
  end,
}

rex.action{
  name     = "ssh_morpheus",
  title    = "SSH: Morpheus",
  category = "Remote",
  keywords = "ssh remote linux morpheus",
  run      = function(_ctx, _args)
    local result, err = rex.invoke("ssh_host", { host = "morpheus" })
    if err ~= nil then error(err, 0) end
    return result
  end,
}

rex.bind("shift+cmd+m", "ssh_morpheus")

-- Prefix keybindings, ported from ~/dotfiles/herdr/config.toml (herdr defaults + overrides).
-- Same Ctrl+A prefix as herdr and tmux. In SSH tabs running tmux, press Ctrl+A twice
-- to reach the remote tmux (and to send Ctrl+A to the shell for start-of-line).
local P = "ctrl+a>"

rex.bind(P .. "ctrl+a", "pane.send_key", { key = "ctrl+a" })

-- Tabs
rex.bind(P .. "c", "client.tab.new")
rex.bind(P .. "n", "client.tab.next")
rex.bind(P .. "p", "client.tab.previous")
-- Vim-style down/up through the sidebar tab list (same as Ctrl+Tab / Ctrl+Shift+Tab)
rex.bind("cmd+ctrl+j", "client.tab.next")
rex.bind("cmd+ctrl+k", "client.tab.previous")
rex.bind(P .. "shift+x", "client.tab.close")
rex.bind(P .. "shift+t", "client.tab.rename")
for i = 1, 9 do
	rex.bind(P .. i, "client.tab.goto", { index = i })
end

-- Panes
rex.bind(P .. "shift+\\", "pane.split.right")
rex.bind(P .. "-", "pane.split.down")
rex.bind(P .. "h", "pane.focus.left")
rex.bind(P .. "j", "pane.focus.down")
rex.bind(P .. "k", "pane.focus.up")
rex.bind(P .. "l", "pane.focus.right")
rex.bind(P .. "tab", "pane.focus_next")
rex.bind(P .. "shift+tab", "pane.focus_previous")
rex.bind(P .. "x", "pane.close")
rex.bind(P .. "z", "pane.zoom")

-- Resize mode (herdr resize_mode): prefix r, then h/j/k/l or arrows; Escape or Enter to leave
rex.mode("resize", { exclusive = true })
rex.bind(P .. "r", "client.mode.enter", { name = "resize" })
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
	rex.bind("resize/" .. key, "pane.resize", { direction = direction })
	rex.bind("resize/" .. direction, "pane.resize", { direction = direction })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

-- Sessions (herdr workspaces)
rex.bind(P .. "s", "session.switch")
rex.bind(P .. "shift+n", "session.new")
rex.bind(P .. "shift+w", "session.rename")
rex.bind(P .. "shift+d", "session.close")

-- App
rex.bind(P .. "b", "client.sidebar.toggle")
rex.bind(P .. ",", "client.settings")
rex.bind(P .. "shift+r", "client.config.reload")
rex.bind(P .. "shift+/", "client.palette.toggle") -- prefix ? (herdr help)
