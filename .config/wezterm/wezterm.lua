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

config.keys = {
	{
		key = "Enter",
		mods = "CMD",
		action = act.SendKey({ key = "Enter", mods = "CTRL" }),
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

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

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
