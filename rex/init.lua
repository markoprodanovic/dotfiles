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
