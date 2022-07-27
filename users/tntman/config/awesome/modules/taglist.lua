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
		layout.forced_width = beautiful.taglist_width

		for i, tag in ipairs(s.tags) do
			ti[tag] = i --add to inverse taglist

			local text = wibox.widget({
				text = tag.name,
				align = "center",
				valign = "center",
				font = beautiful.taglist_font,
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

			layout:add_at(w, { y = dpi(4), x = i * (beautiful.taglist_size + spacing) })

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
			font = beautiful.taglist_font,
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
				layout:move_widget(w, { x = pos * (beautiful.taglist_size + spacing), y = dpi(4) })
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

		layout:add_at({
			text = "\u{f02b}",
			font = beautiful.taglist_font,
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		}, { y = beautiful.taglist_icon_x, x = spacing * 1.5 })

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
end)
