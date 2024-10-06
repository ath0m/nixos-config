---@diagnostic disable: unused-local
local wezterm = require("wezterm")

local config = {
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	canonicalize_pasted_newlines = "None",
	color_scheme = "Catppuccin Mocha",
	cursor_blink_rate = 500,
	default_cursor_style = "BlinkingBlock",
	default_cwd = wezterm.home_dir,
	-- font = wezterm.font("VictorMono Nerd Font Propo", { weight = "DemiBold", stretch = "Normal" }),
	font = wezterm.font("CaskaydiaMono Nerd Font Propo", { weight = "Medium", stretch = "Normal", style = "Normal" }),
	font_size = 11.0,
	hyperlink_rules = wezterm.default_hyperlink_rules(),
	inactive_pane_hsb = {
		saturation = 1.0,
		brightness = 0.6,
	},
	max_fps = 120,
	scrollback_lines = 3000,
	send_composed_key_when_left_alt_is_pressed = false,
	show_new_tab_button_in_tab_bar = false,
	switch_to_last_active_tab_when_closing_tab = true,
	tab_max_width = 80,
	underline_position = -4,
	use_fancy_tab_bar = false,
	macos_window_background_blur = 19,
	window_decorations = "RESIZE",
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
}

return config
