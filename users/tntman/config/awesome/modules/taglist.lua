local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local tags = require("modules.tags")
local beautiful = require("beautiful")

screen.connect_signal("request::desktop_decoration", function(s)
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,

		layout = {
			spacing = dpi(12),
			layout = wibox.layout.fixed.horizontal,
			spacing_widget = {
				bg = beautiful.bg_normal .. "00",
				border_color = beautiful.bg_normal .. "00",
				thickness = dpi(0),
				shape = gears.shape.rect,
				widget = wibox.widget.separator,
			},
		},

		widget_template = {
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				top = dpi(4),
				bottom = dpi(4),
				left = dpi(10),
				right = dpi(10),
				widget = wibox.container.margin,
			},
			id = "bg",
			widget = wibox.container.background,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 4)
			end,
			create_callback = function(self, t, index, tagsList)
				self.bg = tags[tonumber(t.name)].colour or x.color0
			end,
		},

		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})
end)
