---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local theme = {}

theme.font = "JetBrainsMono Nerd Font 12"

theme.bg_normal = "#1E1E2E"
theme.bg_focus = "#302D41"
theme.bg_urgent = "#FAE3B0"
theme.bg_minimize = "#575268"

theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(8)

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_normal
theme.tasklist_shape_border_width = dpi(4)
theme.tasklist_shape_border_color = "#a0d9a9"
theme.tasklist_shape_border_color_focus = "#96cdfb"

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(6)
theme.border_width = dpi(0)
theme.border_color_normal = "#000000"
theme.border_color_active = "#535d6c"
theme.border_color_marked = "#91231c"

local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_bg_focus = "#1E1E2E"

theme.notification_border_width = dpi(3)
theme.notification_opacity = 0.6
theme.notification_padding = dpi(8)
theme.notification_min_width = dpi(32)
theme.notification_min_height = dpi(20)
theme.notification_border_radius = dpi(12)
theme.notification_font = "JetBrainsMono Nerd Font 20"
theme.notification_font_small = "JetBrainsMono Nerd Font 10"
theme.notification_icon_size = theme.notification_min_width

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "wallpaper.png"

theme.tabbar_style = "modern"
theme.tabbar_radius = dpi(8)
theme.mstab_border_radius = dpi(8)

theme.playerctl_player = { "spotify", "%any" }
theme.playerctl_update_on_activity = true

theme.icon_theme = "/home/tntman/.icons/.default"

return theme
