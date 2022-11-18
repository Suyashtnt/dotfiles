local wezterm = require "wezterm"

return {
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font_with_fallback {
		'JetBrainsMono Nerd Font Mono', -- Comic code breaks the font
		'Noto Color Emoji',
	},
	font_size = 13,
	line_height = 1.6,
	font_antialias = "Subpixel",
        harfbuzz_features = {
          "cv06=1",
          "cv14=1",
          "cv32=1",
          "ss04=1",
          "ss07=1",
          "ss09=1",
        },
	enable_wayland = false, -- https://github.com/wez/wezterm/issues/2755
	cursor_blink_ease_in = "EaseIn",
	cursor_blink_ease_out = "EaseOut",
	animation_fps = 120,
	cursor_blink_rate = 800,
	cursor_thickness = 1.0,
	default_cursor_style = "BlinkingBar",
	initial_rows = 17,
	initial_cols = 70,
	window_padding = {
		left = 12,
		right = 12,
		top = 12,
		bottom = 12,
	},
	window_frame = {
		inactive_titlebar_bg = '#171723',
		active_titlebar_bg = '#171723',
		inactive_titlebar_fg = '#9399b2',
		active_titlebar_fg = '#cdd6f4',
		font = wezterm.font { family = 'Inter', weight = 'Bold' },
	},
	colors = {
		tab_bar = {
			active_tab = {
				bg_color = '#1e1e2e',
				fg_color = '#cdd6f4',
				intensity = 'Bold',
			},
			inactive_tab = {
				bg_color = '#313244',
				fg_color = '#9399b2',
			},
                        inactive_tab_hover = {
                                bg_color = '#11111b',
                                fg_color = '#cdd6f4',
                        },
			new_tab = {
				bg_color = '#181825',
				fg_color = '#cdd6f4',
			},
			new_tab_hover = {
                                bg_color = '#1e1e2e',
                                fg_color = '#cdd6f4',
                        },
		},
	},
}