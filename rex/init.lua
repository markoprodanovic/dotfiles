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
rex.bind(P .. "shift+s", "session.rename") -- Shift + first letter renames, like Shift+T for tabs
rex.bind(P .. "shift+d", "session.close")

-- LazyGit overlay: a centered floating LazyGit over the current tab, opened in
-- the focused pane's working directory. Toggling minimizes it rather than
-- closing it, so LazyGit keeps its state (cursor, panel, filters) between uses.
-- Inside the overlay, q and Esc also minimize (lazygit/overlay.yml); Q quits.
local TERMINAL = "com.superlogical.terminal"
local LAZYGIT_LABEL = "lazygit-overlay"
-- The overlay loads overlay.yml on top of the normal config. Setting
-- LG_CONFIG_FILE replaces the default lookup, so both files are listed.
local LAZYGIT_CONFIG_DIR = os.getenv("HOME") .. "/Library/Application Support/lazygit"
local LAZYGIT_CONFIG = LAZYGIT_CONFIG_DIR .. "/config.yml," .. LAZYGIT_CONFIG_DIR .. "/overlay.yml"
-- overlay layer_id -> block it was opened from (lost on config reload; then the
-- first tiled pane is used as the split anchor instead).
local overlay_source = {}

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

-- The floating layer in window w that holds the LazyGit overlay, if any, and
-- whether it is minimized.
local function lazygit_layer(w)
	for _, layer in ipairs(w.layers or {}) do
		if layer.kind ~= "tiled" then
			for _, b in ipairs(layer.blocks or {}) do
				if b.label == LAZYGIT_LABEL then
					return layer.layer_id, layer.state == "minimized"
				end
			end
		end
	end
end

rex.action({
	name = "lazygit_toggle",
	title = "Toggle LazyGit Overlay",
	description = "Open LazyGit in a centered floating pane in the focused pane's directory, or minimize/restore it if already open.",
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

		local existing, minimized = lazygit_layer(w)
		if existing then
			local _, serr
			if minimized then
				_, serr = rex.session.set_layer_state({ layer_id = existing, state = "normal", focus = true })
			else
				_, serr = rex.session.set_layer_state({ layer_id = existing, state = "minimized" })
			end
			if serr then
				error(serr, 0)
			end
			return
		end

		local source = ctx.block_id or w.focused_block_id
		local layer, nerr = rex.session.new_layer({
			window_id = w.window_id,
			bounds = { 0.075, 0.075, 0.85, 0.85 },
			focus = true,
			layout = rex.layout.block({
				flavor = TERMINAL .. ".shell",
				label = LAZYGIT_LABEL,
				options = {
					command = { "env", "LG_CONFIG_FILE=" .. LAZYGIT_CONFIG, "lazygit" },
					cwd = block_cwd(source),
				},
			}),
		})
		if nerr then
			error(nerr, 0)
		end
		overlay_source[layer.layer_id] = source
	end,
})
-- Cmd+G rather than Ctrl+L: Ctrl+L is Neovim's move-right (vim-tmux-navigator)
-- and the shell's clear-screen, and a Rex binding would take it from every pane.
rex.bind("cmd+g", "lazygit_toggle")

-- Find the RPC socket of the nvim whose TUI process is pid. Since nvim 0.10 the
-- TUI and the server are separate processes, and the socket
-- ($TMPDIR/nvim.$USER/*/nvim.<pid>.0) is named after the server, a child of the TUI.
local function nvim_socket(pid)
	local script = [[
dir="${TMPDIR:-$(getconf DARWIN_USER_TEMP_DIR)}"
dir="${dir%/}/nvim.$(id -un)"
for p in "$1" $(pgrep -P "$1"); do
	for s in "$dir"/*/nvim."$p".0; do
		[ -S "$s" ] && { echo "$s"; exit 0; }
	done
done
exit 1]]
	local r = rex.exec({ "sh", "-c", script, "sh", tostring(pid) }, { timeout = 5 })
	if r and r.ok then
		return (r.stdout:gsub("%s+$", ""))
	end
end

-- The first terminal in window w (outside the overlay) running nvim, as
-- block_id, socket, nvim binary. Prefers the tiled layout over floating panes.
local function find_nvim(w)
	for _, layer in ipairs(w.layers or {}) do
		for _, b in ipairs(layer.blocks or {}) do
			if b.creator_name == TERMINAL and b.label ~= LAZYGIT_LABEL then
				local proc = rex.block.call(TERMINAL, "process", { block_id = b.block_id })
				local fg = proc and proc.foreground
				if fg and (fg.name == "nvim" or fg.argv0 == "nvim") then
					local sock = nvim_socket(fg.pid)
					if sock then
						-- Rex's own PATH lacks Homebrew, so reuse the running binary.
						return b.block_id, sock, fg.invoked_path or fg.path
					end
				end
			end
		end
	end
end

-- The first block of the window's tiled layer, used as a split anchor when
-- nothing better is known.
local function first_tiled_block(w)
	for _, layer in ipairs(w.layers or {}) do
		if layer.kind == "tiled" and layer.blocks and layer.blocks[1] then
			return layer.blocks[1].block_id
		end
	end
end

-- Called by LazyGit's "e" key (lazygit/config.yml). Opens file in the tab's
-- nvim if there is one, else in a new nvim split, then minimizes the overlay.
rex.action({
	name = "lazygit_edit",
	title = "Open File from LazyGit Overlay",
	args = { file = "string", cwd = "string?" },
	run = function(ctx, args)
		local file = args.file
		if file:sub(1, 1) ~= "/" and args.cwd then
			file = args.cwd .. "/" .. file
		end

		local view, err = rex.session.view({})
		if not view then
			error(err, 0)
		end
		local w = window_of(view, ctx.block_id)
		if not w then
			error("no window found", 0)
		end
		local overlay = lazygit_layer(w)

		local nvim_block, sock, nvim_bin = find_nvim(w)
		if nvim_block then
			-- LazygitEdit (nvim/lua/plugins/lazygit.lua) picks a normal window and
			-- edits the file there. "<" must be escaped for --remote-send.
			local keys = "<C-\\><C-n>:silent LazygitEdit " .. file:gsub("<", "<lt>") .. "<CR>"
			local r, xerr = rex.exec({ nvim_bin, "--server", sock, "--remote-send", keys }, { timeout = 5 })
			if not r then
				error(xerr, 0)
			end
			if not r.ok then
				error(r.stderr, 0)
			end
			rex.session.focus_block({ block_id = nvim_block })
		else
			-- Split the pane the overlay was opened from, so nvim lands next to it.
			local anchor = overlay_source[overlay]
			if not anchor or not window_of(view, anchor) or window_of(view, anchor).window_id ~= w.window_id then
				anchor = first_tiled_block(w)
			end
			local _, serr = rex.session.new_split({
				anchor_id = anchor,
				direction = "horizontal",
				side = "after",
				focus = true,
				layout = rex.layout.block({
					flavor = TERMINAL .. ".shell",
					options = { command = { "nvim", file }, cwd = args.cwd },
				}),
			})
			if serr then
				error(serr, 0)
			end
		end

		-- Minimize rather than close, so LazyGit is where you left it next time.
		if overlay then
			rex.session.set_layer_state({ layer_id = overlay, state = "minimized" })
		end
	end,
})

-- App
rex.bind(P .. "b", "client.sidebar.toggle")
-- Sidebar on Cmd+Shift+E (VS Code's explorer key). Frees Cmd+/, which Rex then
-- passes to the terminal; Neovim maps it as <D-/> to toggle comments.
rex.bind("cmd+shift+e", "client.sidebar.toggle")
rex.unbind("cmd+/")
rex.bind(P .. ",", "client.settings")
rex.bind(P .. "shift+r", "client.config.reload")
rex.bind(P .. "shift+/", "client.palette.toggle") -- prefix ? (herdr help)
