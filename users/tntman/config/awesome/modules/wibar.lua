local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

-- Create a textclock widget
local clock = wibox.widget.textclock("<span foreground='#abe9b3'>%b %d</span> <span foreground='#96cdfb'>%H:%M</span>")

screen.connect_signal("request::desktop_decoration", function(s)
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- padding for left-right
	local lr = dpi(18)
	-- padding for top-bottom
	local tb = dpi(8)

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = wibox.container.margin({
			widget = wibox.container.background,
			shape_border_width = 10,
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
				{
					s.mytaglist,
					widget = wibox.container.background,
					bg = beautiful.bg_normal,
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, 24)
					end,
				},
				s.mypromptbox,
			},
			{ -- Middle widget
				{
					s.mytasklist,
					widget = wibox.container.background,
					bg = beautiful.bg_normal,
					shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, dpi(24))
					end,
				},
				right = 10,
				widget = wibox.container.margin,
			},
			{ -- Right widgets
				{
					layout = wibox.layout.fixed.horizontal,
					{
						{
							{
								widget = clock,
								align = "center",
								valign = "center",
							},
							widget = wibox.container.margin,
							left = dpi(16),
							right = dpi(16),
							top = dpi(8),
							bottom = dpi(8),
						},
						widget = wibox.container.background,
						bg = beautiful.bg_normal,
						shape = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, dpi(24))
						end,
					},
					{
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

						top = dpi(8),
						bottom = dpi(8),
						left = dpi(16),
						right = dpi(16),
					},
					{
						{
							wibox.widget.systray(),
							s.mylayoutbox,
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(8),
						},
						widget = wibox.container.margin,
						bg = beautiful.bg_normal,
						top = dpi(8),
						bottom = dpi(8),
						left = dpi(12),
						right = dpi(12),
					},
				},
				widget = wibox.container.background,
				bg = beautiful.bg_normal,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, dpi(24))
				end,
			},
			spacing = dpi(10),
		}, lr, lr, tb, tb),
		width = 1905,
		height = dpi(60),
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 30)
		end,
		border_width = dpi(6),
		bg = beautiful.bg_normal .. "00",
	})
end)
-- }}}
