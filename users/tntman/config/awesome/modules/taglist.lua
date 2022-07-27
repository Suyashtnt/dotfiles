local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local bling = require("bling")

screen.connect_signal("request::desktop_decoration", function(s)
	bling.widget.tag_preview.enable({
		show_client_content = true,
		x = 10,
		y = 10,
		scale = 0.50,
		honor_padding = true,
		honor_workarea = true,
		placement_fn = function(c)
			awful.placement.top_left(c, {
				margins = {
					top = 30,
					left = 30,
				},
			})
		end,
		background_widget = {
			image = beautiful.wallpaper,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
			widget = wibox.widget.imagebox,
		},
	})

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
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				top = dpi(3),
				bottom = dpi(3),
				left = dpi(12),
				right = dpi(12),
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			fg = "#cdd6f4",
			create_callback = function(self, c3, _, _)
				self:connect_signal("mouse::enter", function()
					if #c3:clients() > 0 then
						awesome.emit_signal("bling::tag_preview::update", c3)
						awesome.emit_signal("bling::tag_preview::visibility", s, true)
					end
				end)
				self:connect_signal("mouse::leave", function()
					awesome.emit_signal("bling::tag_preview::visibility", s, false)
				end)
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
