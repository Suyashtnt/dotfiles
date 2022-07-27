local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local color = require("color")
local rubato = require("rubato")
local bling = require("bling")
local tags = require("modules.tags")

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

	-- Create a taglist widget (stolen from https://github.com/andOrlando/nix-dotfiles/blob/main/bennett/awesome/rc.lua#L525)
	s.mytaglist = (function()
		local ti = {} --inverse taglist
		local layout = wibox.layout.manual()
		layout.forced_width = dpi(14)

		for i, tag in ipairs(s.tags) do
			ti[tag] = i --add to inverse taglist

			local text = wibox.widget({
				text = "",
				align = "center",
				widget = wibox.widget.textbox,
			})
			local w = wibox.widget({
				text,
				bg = "#444956",
				forced_width = dpi(6),
				forced_height = dpi(30),
				shape = gears.shape.rounded_rect,
				widget = wibox.container.background,
			})
			layout:add_at(w, { x = dpi(4), y = i * dpi(36) - dpi(30) })

			local populated_trans =
				color.transition(color.color({ hex = "#444956" }), color.color({ hex = "#444956" }) + "0.2l")
			local populated_timed = rubato.timed({
				duration = 0.2,
				intro = 0.075,
				subscribed = function(pos)
					w.bg = populated_trans(pos).hex
				end,
			})
			client.connect_signal("tagged", function()
				populated_timed.target = math.min(#tag:clients(), 1)
			end)
			client.connect_signal("untagged", function()
				populated_timed.target = math.min(#tag:clients(), 1)
			end)

			tag:connect_signal("property::urgent", function()
				if awful.tag.getproperty(tag, "urgent") then
					text.text = "!"
				else
					text.text = ""
				end
			end)
		end

		local w = wibox.widget({
			wibox.widget({}),
			bg = "#489568",
			forced_width = dpi(8),
			forced_height = dpi(30),
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background,
		})
		layout:add_at(w, { x = 0, y = 0 })
		local pos_timed = rubato.timed({
			pos = 1,
			duration = 0.3,
			intro = 0.1,
			debug = true,
			subscribed = function(pos)
				layout:move_widget(w, { x = dpi(3), y = pos * dpi(36) - dpi(30) })
			end,
		})

		local pos_hover_trans =
			color.transition(color.color({ hex = "#489568" }), color.color({ hex = "#489568" }) + "0.06l")

		local pos_hover_timed = rubato.timed({
			duration = 0.2,
			intro = 0.075,
			subscribed = function(pos)
				w.bg = pos_hover_trans(pos).hex
			end,
		})

		s:connect_signal("tag::history::update", function()
			pos_timed.target = ti[s.selected_tag]
			pos_hover_timed.target = 0
		end)

		w:connect_signal("mouse::enter", function()
			pos_hover_timed.target = 1
		end)

		w:connect_signal("mouse::leave", function()
			pos_hover_timed.target = 0
		end)

		return layout
	end)()

	-- awful.widget.taglist({
	-- screen = s,
	-- filter = awful.widget.taglist.filter.all,
	--
	-- layout = {
	-- 	spacing = dpi(12),
	-- 	layout = wibox.layout.fixed.horizontal,
	-- 	spacing_widget = {
	-- 		bg = beautiful.bg_normal .. "00",
	-- 		border_color = beautiful.bg_normal .. "00",
	-- 		thickness = dpi(0),
	-- 		shape = gears.shape.rect,
	-- 		widget = wibox.widget.separator,
	-- 	},
	-- },
	--
	-- widget_template = {
	-- 	{
	-- 		{
	-- 			id = "text_role",
	-- 			widget = wibox.widget.textbox,
	-- 		},
	-- 		top = dpi(3),
	-- 		bottom = dpi(3),
	-- 		left = dpi(12),
	-- 		right = dpi(12),
	-- 		widget = wibox.container.margin,
	-- 	},
	-- 	id = "background_role",
	-- 	widget = wibox.container.background,
	-- 	fg = "#cdd6f4",
	-- 	create_callback = function(self, c3, _, _)
	-- 		self:connect_signal("mouse::enter", function()
	-- 			if #c3:clients() > 0 then
	-- 				awesome.emit_signal("bling::tag_preview::update", c3)
	-- 				awesome.emit_signal("bling::tag_preview::visibility", s, true)
	-- 			end
	-- 		end)
	-- 		self:connect_signal("mouse::leave", function()
	-- 			awesome.emit_signal("bling::tag_preview::visibility", s, false)
	-- 		end)
	-- 	end,
	-- },
	--
	-- buttons = {
	-- 	awful.button({}, 1, function(t)
	-- 		t:view_only()
	-- 	end),
	-- 	awful.button({ modkey }, 1, function(t)
	-- 		if client.focus then
	-- 			client.focus:move_to_tag(t)
	-- 		end
	-- 	end),
	-- 	awful.button({}, 3, awful.tag.viewtoggle),
	-- 	awful.button({ modkey }, 3, function(t)
	-- 		if client.focus then
	-- 			client.focus:toggle_tag(t)
	-- 		end
	-- 	end),
	-- 	awful.button({}, 4, function(t)
	-- 		awful.tag.viewprev(t.screen)
	-- 	end),
	-- 	awful.button({}, 5, function(t)
	-- 		awful.tag.viewnext(t.screen)
	-- 	end),
	-- },
	-- })
end)
