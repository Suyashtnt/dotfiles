local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local theme = {}

theme.font = "JetBrainsMono Nerd Font 14"
theme.icon_font = "Font Awesome 6 Free 18"

theme.bg_normal = "#1E1E2E"
theme.bg_focus = "#302D41"
theme.bg_urgent = "#FAE3B0"
theme.bg_minimize = "#575268"

theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(8)

theme.tasklist_bg_normal = "#313244"
theme.tasklist_bg_focus = theme.bg_normal
theme.tasklist_fg_normal = "#cdd6f4"
theme.tasklist_fg_focus = "#cdd6f4"
theme.tasklist_shape_border_width = dpi(4)
theme.tasklist_shape_border_color = "#a0d9a9"
theme.tasklist_shape_border_color_focus = "#f5c2e7"

theme.fg_normal = "#cdd6f4"
theme.fg_urgent = "#a6e3a1"
theme.fg_minimize = "#a6adc8"

theme.useless_gap = dpi(6)
theme.border_width = dpi(4)
theme.border_radius = dpi(8)

theme.gap_single_client = true
theme.border_color_normal = "#000000"
theme.border_color_active = "#89b4fa"
theme.border_color_marked = "#a6e3a1"

theme.taglist_bg_focus = "#89b4fa"
theme.taglist_bg_empty = "#181825"
theme.taglist_bg_occupied = "#313244"

theme.taglist_font = theme.icon_font
theme.taglist_shape = helpers.rrect(8)

theme.notification_border_width = dpi(3)
theme.notification_border_color = "#96cdfb"
theme.notification_action_colour = "#96cdfb"
theme.notification_padding = dpi(8)
theme.notification_min_width = dpi(32)
theme.notification_min_height = dpi(20)
theme.notification_border_radius = dpi(12)
theme.notification_font = "JetBrainsMono Nerd Font 20"
theme.notification_font_small = "JetBrainsMono Nerd Font 10"
theme.notification_icon_size = theme.notification_min_width
theme.notification_icon_radius = dpi(16)

theme.wibar_height = dpi(40)
theme.wibar_margins = {
	top = 8,
	left = 16,
	right = 16,
}

theme.wibar_left_section_margins = {
	left = dpi(16),
	right = dpi(16),
	top = dpi(8),
	bottom = dpi(8),
}

theme.wibar_radius = dpi(32)
theme.wibar_middle_section_margins = dpi(16)

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "wallpaper.png"

theme.tabbar_style = "modern"
theme.tabbar_radius = dpi(8)
theme.mstab_border_radius = dpi(8)

theme.tag_preview_widget_border_radius = 8
theme.tag_preview_client_border_radius = 8
theme.tag_preview_client_opacity = 1
theme.tag_preview_client_bg = "#000000"
theme.tag_preview_client_border_color = "#ffffff"
theme.tag_preview_client_border_width = 0
theme.tag_preview_widget_bg = "#000000"
theme.tag_preview_widget_border_color = "#96cdfb"
theme.tag_preview_widget_border_width = 6
theme.tag_preview_widget_margin = 8

theme.playerctl_player = { "spotify", "ncspot", "%any" }
theme.playerctl_update_on_activity = true

theme.icon_theme = "/home/tntman/.icons/.default"

return theme
