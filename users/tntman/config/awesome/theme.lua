---------------------------
-- Default awesome theme --
---------------------------
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

theme.tasklist_bg_normal = "#313244"
theme.tasklist_bg_focus = theme.bg_normal
theme.tasklist_fg_normal = "#cdd6f4"
theme.tasklist_fg_focus = "#cdd6f4"
theme.tasklist_shape_border_width = dpi(4)
theme.tasklist_shape_border_color = "#a0d9a9"
theme.tasklist_shape_border_color_focus = "#f5c2e7"

theme.fg_normal = "#aaaaaa"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(6)
theme.border_width = dpi(0)
theme.border_color_normal = "#000000"
theme.border_color_active = "#535d6c"
theme.border_color_marked = "#91231c"

theme.taglist_bg_focus = "#89b4fa"
theme.taglist_bg_empty = "#181825"
theme.taglist_bg_occupied = "#313244"

theme.taglist_font = "Font Awesome 6 Free 18"
theme.taglist_shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, 8)
end

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
