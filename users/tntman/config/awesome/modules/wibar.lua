local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local section_shapes = helpers.rrect(beautiful.wibar_radius)

-- Create a textclock widget
local clock = wibox.widget.textclock("<span foreground='#abe9b3'>%b %d</span> <span foreground='#96cdfb'>%H:%M</span>")

screen.connect_signal("request::desktop_decoration", function(s)
	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		margins = beautiful.wibar_margins,
		widget = {
			widget = wibox.container.background,
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				s.mytaglist,
				widget = wibox.container.background,
				bg = beautiful.bg_normal,
				shape = section_shapes,
			},
			{ -- Middle widget
				{
					widget = wibox.container.place(s.mytasklist),
					align = "center",
					valign = "center",
				},
				right = beautiful.wibar_middle_section_margins,
				left = beautiful.wibar_middle_section_margins,
				widget = wibox.container.margin,
			},
			{ -- Right widgets
				{
					layout = wibox.layout.fixed.horizontal,
					{
						helpers.merge({
							{
								widget = clock,
								align = "center",
								valign = "center",
							},
							widget = wibox.container.margin,
						}, beautiful.wibar_left_section_margins),
						widget = wibox.container.background,
						bg = beautiful.bg_normal,
						shape = section_shapes,
					},
					helpers.merge({
						{
							widget = wibox.container.place({
								net_speed_widget(),
								widget = wibox.container.background,
								fg = "#efd9a9",
							}),
							align = "center",
							valign = "center",
						},
						widget = wibox.container.margin,
					}, beautiful.wibar_left_section_margins),
					helpers.merge({
						{
							wibox.widget.systray(),
							s.mylayoutbox,
							layout = wibox.layout.fixed.horizontal,
							spacing = beautiful.systray_icon_spacing, -- Act like extra system tray icon
						},
						widget = wibox.container.margin,
						bg = beautiful.bg_normal,
					}, beautiful.wibar_left_section_margins),
				},
				widget = wibox.container.background,
				bg = beautiful.bg_normal,
				shape = section_shapes,
			},
		},
		height = beautiful.wibar_height,
		bg = beautiful.bg_normal .. "00",
	})
end)
-- }}}
