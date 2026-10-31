-- Rex configuration
-- Symlinked to ~/.config/rex/init.lua by install.sh. Reload with: rex config reload

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
rex.bind("cmd+shift+j", "client.tab.next")
rex.bind("cmd+shift+k", "client.tab.previous")
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

-- LazyGit overlay: toggles a centered floating LazyGit over the current tab,
-- opened in the focused pane's working directory. Toggling off closes it.
local TERMINAL = "com.superlogical.terminal"
local LAZYGIT_LABEL = "lazygit-overlay"

-- Directory of the given terminal block: the one the shell reported (OSC 7),
-- else the foreground program's cwd, else the shell's, else $HOME.
local function block_cwd(block_id)
	local pwd = rex.block.call(TERMINAL, "pwd", { block_id = block_id })
	if pwd and pwd.path and pwd.path ~= "" then
		return pwd.path
	end
	local proc = rex.block.call(TERMINAL, "process", { block_id = block_id })
	if proc then
		if proc.foreground and proc.foreground.cwd then
			return proc.foreground.cwd
		end
		for _, p in ipairs(proc.ancestors or {}) do
			if p.cwd then
				return p.cwd
			end
		end
	end
	return os.getenv("HOME")
end

-- The window holding block_id (falls back to the active window).
local function window_of(view, block_id)
	for _, w in ipairs(view.windows or {}) do
		for _, layer in ipairs(w.layers or {}) do
			for _, b in ipairs(layer.blocks or {}) do
				if b.block_id == block_id then
					return w
				end
			end
		end
	end
	for _, w in ipairs(view.windows or {}) do
		if w.window_id == view.active_window_id then
			return w
		end
	end
end

-- The floating layer in window w that holds the LazyGit overlay, if any.
local function lazygit_layer(w)
	for _, layer in ipairs(w.layers or {}) do
		if layer.kind ~= "tiled" then
			for _, b in ipairs(layer.blocks or {}) do
				if b.label == LAZYGIT_LABEL then
					return layer.layer_id
				end
			end
		end
	end
end

rex.action({
	name = "lazygit_toggle",
	title = "Toggle LazyGit Overlay",
	description = "Open LazyGit in a centered floating pane in the focused pane's directory, or close it if open.",
	keywords = "git lazygit float overlay",
	run = function(ctx)
		local view, err = rex.session.view({})
		if not view then
			error(err, 0)
		end
		local w = window_of(view, ctx.block_id)
		if not w then
			error("no window to open LazyGit in", 0)
		end

		local existing = lazygit_layer(w)
		if existing then
			local _, cerr = rex.session.close_layer({ layer_id = existing })
			if cerr then
				error(cerr, 0)
			end
			return
		end

		local source = ctx.block_id or w.focused_block_id
		local _, nerr = rex.session.new_layer({
			window_id = w.window_id,
			bounds = { 0.075, 0.075, 0.85, 0.85 },
			focus = true,
			layout = rex.layout.block({
				flavor = TERMINAL .. ".shell",
				label = LAZYGIT_LABEL,
				options = { command = { "lazygit" }, cwd = block_cwd(source) },
			}),
		})
		if nerr then
			error(nerr, 0)
		end
	end,
})
rex.bind(P .. "g", "lazygit_toggle")

-- App
rex.bind(P .. "b", "client.sidebar.toggle")
rex.bind(P .. ",", "client.settings")
rex.bind(P .. "shift+r", "client.config.reload")
rex.bind(P .. "shift+/", "client.palette.toggle") -- prefix ? (herdr help)
