local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("helpers")
local ruled = require("ruled")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

-- Presets / rules

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if new == true then
		naughty.notify({
			title = title,
			text = "By " .. artist .. " - " .. album .. " From player" .. player_name,
			image = album_path,
		})
	end
end)

ruled.notification.connect_signal("request::rules", function()
	-- Critical notifs
	ruled.notification.append_rule({
		rule = { urgency = "critical" },
		properties = {
			font = "JetBrainsMono Nerd Font Mono 11",
			bg = "#e64553",
			fg = "#ffffff",
			margin = dpi(16),
			position = "top_right",
			timeout = 0,
			implicit_timeout = 0,
		},
	})

	-- 	-- Normal notifs
	ruled.notification.append_rule({
		rule = { urgency = "normal" },
		properties = {
			font = "JetBrainsMono Nerd Font Mono 11",
			bg = "#181825",
			fg = beautiful.fg_normal,
			margin = dpi(16),
			position = "top_right",
			timeout = 5,
			implicit_timeout = 5,
		},
	})

	-- Low notifs
	ruled.notification.append_rule({
		rule = { urgency = "low" },
		properties = {
			font = "JetBrainsMono Nerd Font Mono 11",
			bg = "#9399b2",
			fg = beautiful.fg_normal,
			margin = dpi(16),
			position = "top_right",
			timeout = 5,
			implicit_timeout = 5,
		},
	})
end)

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Something went wrong" .. (startup and " during startup!" or "!"),
		message = message,
		app_name = "",
		icon = beautiful.awesome_icon,
	})
end)

beautiful.notification_shape = helpers.rrect(dpi(12))

naughty.connect_signal("request::display", function(n)
	local actions = wibox.widget({
		notification = n,

		base_layout = wibox.widget({
			spacing = dpi(5),
			layout = wibox.layout.flex.horizontal,
		}),

		widget_template = {
			{
				{
					{
						font = beautiful.notification_font,
						markup = helpers.colorize_text(" ", beautiful.notification_action_colour),
						widget = wibox.widget.textbox,
					},
					{
						id = "text_role",
						font = beautiful.notification_font,
						widget = wibox.widget.textbox,
					},
					forced_height = dpi(35),
					layout = wibox.layout.fixed.horizontal,
				},
				widget = wibox.container.place,
			},
			strategy = "min",
			width = dpi(60),
			widget = wibox.container.constraint,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
		},
		widget = naughty.list.actions,
	})

	naughty.layout.box({
		notification = n,
		shape = helpers.rrect(beautiful.notification_border_radius),
		border_width = beautiful.notification_border_width,
		border_color = beautiful.notification_border_color,
		position = beautiful.notification_position,
		widget_template = {
			{
				{
					{
						{
							{
								clip_shape = helpers.rrect(beautiful.notification_icon_radius),
								widget = naughty.widget.icon,
							},
							{
								{
									nil,
									{
										{
											align = "left",
											font = beautiful.notification_font,
											markup = "<b>" .. n.title .. "</b>",
											widget = wibox.widget.textbox,
										},
										{
											align = "left",
											font = beautiful.notification_font_small,
											markup = n.message,
											widget = wibox.widget.textbox,
										},
										layout = wibox.layout.fixed.vertical,
									},
									expand = "none",
									layout = wibox.layout.align.vertical,
								},
								left = n.icon and beautiful.notification_padding or 0,
								widget = wibox.container.margin,
							},
							layout = wibox.layout.align.horizontal,
						},
						{
							helpers.vertical_pad(dpi(8)),
							{
								nil,
								actions,
								expand = "none",
								layout = wibox.layout.align.horizontal,
							},
							visible = n.actions and #n.actions > 0,
							layout = wibox.layout.fixed.vertical,
						},
						layout = wibox.layout.fixed.vertical,
					},
					margins = beautiful.notification_padding,
					widget = wibox.container.margin,
				},
				margins = beautiful.notification_border_width,
				color = beautiful.border_color_active,
				widget = wibox.container.margin,
			},
			strategy = "min",
			width = beautiful.notification_min_width,
			height = beautiful.notification_min_height,
			widget = wibox.container.constraint,
		},
	})
end)
