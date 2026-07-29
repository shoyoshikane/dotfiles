local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

local username = wezterm.home_dir:match("([^/]+)$")
local pngpaste = "/etc/profiles/per-user/" .. username .. "/bin/pngpaste"
local paste_dir = "/tmp/wezterm-clipboard-images"

local mkdir_success, _, mkdir_stderr = wezterm.run_child_process({ "/bin/mkdir", "-p", paste_dir })
if not mkdir_success then
	wezterm.log_error("Failed to create image paste directory: " .. (mkdir_stderr or "unknown error"))
end

config.automatically_reload_config = true
config.enable_kitty_keyboard = true
config.font_size = 14.0
config.font = wezterm.font("HackGen Console NF")
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 5

config.window_decorations = "RESIZE"
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

config.leader = {
	key = ";",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

local function activate_or_split_pane(direction)
	return wezterm.action_callback(function(window, pane)
		if pane:tab():get_pane_direction(direction) then
			window:perform_action(act.ActivatePaneDirection(direction), pane)
		else
			window:perform_action(act.SplitPane({ direction = direction }), pane)
		end
	end)
end

config.keys = {
	{
		key = "e",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local pane_count = #pane:tab():panes()
			if pane_count == 2 then
				window:perform_action(act.RotatePanes("Clockwise"), pane)
			elseif pane_count > 2 then
				window:perform_action(act.PaneSelect({ mode = "SwapWithActive" }), pane)
			end
		end),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = activate_or_split_pane("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = activate_or_split_pane("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = activate_or_split_pane("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = activate_or_split_pane("Right"),
	},
	{
		key = "s",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},
	{
		key = "mapped:Delete",
		mods = "NONE",
		action = act.SendString("\x1b[3~"),
	},
	{
		key = "v",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			local image_path = paste_dir .. "/paste-" .. wezterm.strftime("%Y%m%d-%H%M%S-%3f") .. ".png"
			local success, _, stderr = wezterm.run_child_process({ pngpaste, image_path })

			if success then
				pane:send_paste(image_path)
			else
				local error_message = stderr or "unknown error"
				local no_image = error_message:find("No image data found on the clipboard", 1, true)
				if not no_image then
					wezterm.log_error("Failed to save clipboard image: " .. error_message)
					window:toast_notification("Image Paste", "Failed to save clipboard image", nil, 3000)
				end
				window:perform_action(act.PasteFrom("Clipboard"), pane)
			end
		end),
	},
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "[", mods = "CTRL", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("update-status", function(window)
	if window:active_key_table() == "resize_pane" then
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "#80EBDF" } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = "  󰩨 resize  " },
		}))
	else
		window:set_right_status("")
	end
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"
	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
return config
