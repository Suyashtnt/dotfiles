local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local color = require("color")
local rubato = require("rubato")

screen.connect_signal("request::desktop_decoration", function(s)
	local spacing = dpi(12)

	-- Create a taglist widget (stolen from https://github.com/andOrlando/nix-dotfiles/blob/main/bennett/awesome/rc.lua#L525), modified to work with a horizontal bar and font icons
	s.mytaglist = (function()
		local ti = {} --inverse taglist
		local layout = wibox.layout.manual()
		layout.forced_width = dpi(330)

		for i, tag in ipairs(s.tags) do
			ti[tag] = i --add to inverse taglist

			local text = wibox.widget({
				text = tag.name,
				align = "center",
				valign = "center",
				font = beautiful.icon_font,
				widget = wibox.widget.textbox,
			})

			local w = wibox.widget({
				text,
				bg = beautiful.taglist_bg_empty,
				forced_width = beautiful.taglist_size,
				forced_height = beautiful.taglist_size,
				shape = gears.shape.circle,
				widget = wibox.container.background,
			})

			layout:add_at(w, { y = dpi(4), x = i * (beautiful.taglist_size + spacing) - spacing })

			local populated_trans = color.transition(
				color.color({ hex = beautiful.taglist_bg_empty }),
				color.color({ hex = beautiful.taglist_bg_occupied })
			)

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
					text.text = tag.name .. "!"
				else
					text.text = tag.name .. ""
				end
			end)
		end

		local text = wibox.widget({
			text = s.selected_tag,
			align = "center",
			valign = "center",
			font = beautiful.icon_font,
			widget = wibox.widget.textbox,
		})

		local w = wibox.widget({
			text,
			bg = "#489568",
			forced_width = beautiful.taglist_size,
			forced_height = beautiful.taglist_size,
			shape = gears.shape.circle,
			widget = wibox.container.background,
		})

		layout:add_at(w, { x = 0, y = 0 })

		local bouncy = {
			F = (20 * math.sqrt(3) * math.pi - 30 * math.log(2) - 6147)
				/ (10 * (2 * math.sqrt(3) * math.pi - 6147 * math.log(2))),
			easing = function(t)
				return (
					4096 * math.pi * math.pow(2, 10 * t - 10) * math.cos(20 / 3 * math.pi * t - 43 / 6 * math.pi)
					+ 6144 * math.pow(2, 10 * t - 10) * math.log(2) * math.sin(20 / 3 * math.pi * t - 43 / 6 * math.pi)
					+ 2 * math.sqrt(3) * math.pi
					- 3 * math.log(2)
				) / (2 * math.pi * math.sqrt(3) - 6147 * math.log(2))
			end,
		}

		local pos_timed = rubato.timed({
			pos = 1,
			duration = 0.4,
			intro = 0,
			outro = 0.2,
			easing = bouncy,
			debug = true,
			subscribed = function(pos)
				layout:move_widget(w, { x = pos * (beautiful.taglist_size + spacing) - spacing, y = dpi(4) })
			end,
		})

		local pos_hover_trans = color.transition(
			color.color({ hex = beautiful.taglist_bg_focus }),
			color.color({ hex = beautiful.taglist_bg_focus }) + "0.06l"
		)

		local pos_hover_timed = rubato.timed({
			duration = 0.2,
			intro = 0.075,
			subscribed = function(pos)
				w.bg = pos_hover_trans(pos).hex
			end,
		})

		s:connect_signal("tag::history::update", function()
			text.text = (s.selected_tag or s.tags[1]).name
			pos_timed.target = ti[s.selected_tag or s.tags[1]]
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
