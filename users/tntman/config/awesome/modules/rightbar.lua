-- modules
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")
local rubato = require("rubato")

-- Create the sidebar_right
local sidebar_right = wibox({ visible = true, ontop = true, type = "dock", screen = screen.primary })
local width = dpi(300)
sidebar_right.bg = "#00000000" -- For anti aliasing
sidebar_right.fg = beautiful.fg_normal
sidebar_right.opacity = 1
sidebar_right.height = screen.primary.geometry.height / 1.5
sidebar_right.width = dpi(300)
sidebar_right.y = 0

local timed = rubato.timed({
	intro = 0.1,
	duration = 0.3,
	rate = 60, -- S M O O T H animations
	easing = rubato.quadratic,
	subscribed = function(pos)
		sidebar_right.x = pos + screen.primary.geometry.width
	end,
})

timed.target = width

awful.placement.right(sidebar_right)

local sidebar_right_hide = function()
	timed.target = width
end

sidebar_right:buttons(gears.table.join(
	-- Middle click - Hide sidebar_right
	awful.button({}, 2, function()
		sidebar_right_hide()
	end)
))

sidebar_right:connect_signal("mouse::leave", function()
	sidebar_right_hide()
end)

-- Activate sidebar_right by moving the mouse at the edge of the screen

local sidebar_right_activator = wibox({
	y = sidebar_right.y,
	width = 1,
	visible = true,
	ontop = false,
	opacity = 0,
	below = true,
	screen = screen.primary,
})

sidebar_right_activator.height = sidebar_right.height
sidebar_right_activator:connect_signal("mouse::enter", function()
	timed.target = -width
end)
awful.placement.right(sidebar_right_activator)

local create_button = function(symbol, color, command, playpause)
	local icon = wibox.widget({
		markup = helpers.colorize_text(symbol, color),
		font = "JetBrainsMono Nerd Font 26",
		align = "center",
		valigin = "center",
		widget = wibox.widget.textbox(),
	})

	local button = wibox.widget({
		icon,
		forced_height = dpi(60),
		forced_width = dpi(60),
		widget = wibox.container.background,
	})

	playerctl:connect_signal("playback_status", function(_, playing, _)
		if playpause then
			if playing then
				icon.markup = helpers.colorize_text("???", color)
			else
				icon.markup = helpers.colorize_text("???", color)
			end
		end
	end)

	button:buttons(gears.table.join(awful.button({}, 1, function()
		command()
	end)))

	button:connect_signal("mouse::enter", function()
		icon.markup = helpers.colorize_text(icon.text, beautiful.fg_normal)
	end)

	button:connect_signal("mouse::leave", function()
		icon.markup = helpers.colorize_text(icon.text, color)
	end)

	return button
end

local play_command = function()
	playerctl:play_pause()
end
local prev_command = function()
	playerctl:previous()
end
local next_command = function()
	playerctl:next()
end

local playerctl_play_symbol = create_button("???", beautiful.blue, play_command, true)

local playerctl_prev_symbol = create_button("???", beautiful.blue, prev_command, false)
local playerctl_next_symbol = create_button("???", beautiful.blue, next_command, false)

local art = wibox.widget({
	image = "default_image.png",
	resize = true,
	clip_shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, 16)
	end,
	widget = wibox.widget.imagebox,
})

local title_widget = wibox.widget({
	markup = "Nothing Playing",
	font = "JetBrainsMono Nerd Font 18",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local start_time = wibox.widget({
	id = "start",
	markup = "0:00",
	align = "left",
	widget = wibox.widget.textbox,
})

local end_time = wibox.widget({
	id = "end",
	markup = "0:00",
	align = "right",
	widget = wibox.widget.textbox,
})

local time_widget = wibox.widget({
	start_time,
	end_time,
	layout = wibox.layout.align.horizontal,
})

local artist_widget = wibox.widget({
	markup = "Nothing Playing",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local time_bar = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = dpi(3),
	forced_height = dpi(16),
	bar_color = beautiful.fg_normal,
	handle_color = beautiful.fg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.fg_normal,
	handle_border_width = dpi(8),
	handle_width = dpi(4),
	value = 0,
	widget = wibox.widget.slider,
})

-- sidebar_right placement
sidebar_right:setup({
	{
		{
			{
				helpers.vertical_pad(dpi(30)),
				title_widget,
				helpers.vertical_pad(dpi(5)),
				art,
				helpers.vertical_pad(dpi(10)),
				artist_widget,
				helpers.vertical_pad(dpi(50)),
				time_widget,
				time_bar,
				helpers.vertical_pad(dpi(15)),
				{
					nil,
					{
						playerctl_prev_symbol,
						playerctl_play_symbol,
						playerctl_next_symbol,
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal,
					},
					nil,
					expand = "none",
					layout = wibox.layout.align.horizontal,
				},
				valign = "center",
				layout = wibox.layout.fixed.vertical,
			},
			left = dpi(20),
			right = dpi(20),
			widget = wibox.container.margin,
		},
		helpers.vertical_pad(dpi(25)),
		{
			weather_widget({
				api_key = helpers.read_file(os.getenv("HOME") .. "/dotfiles/.secrets/weatherapikey.txt")[1],
				coordinates = { -26.2041, 28.0473 }, -- CHANGE THIS TO YOUR LOCATION/NEAR YOUR LOCATION (currently: center of JHB, South Africa)
				font_name = "JetBrainsMono Nerd Font Mono",
				show_hourly_forecast = true,
				show_daily_forecast = true,
			}),
			widget = wibox.container.margin,
			bottom = dpi(20),
			left = dpi(20),
			right = dpi(20),
		},
		helpers.vertical_pad(dpi(25)),
		layout = wibox.layout.fixed.vertical,
	},
	shape = helpers.prrect(dpi(40), true, false, false, true),
	bg = beautiful.bg_normal,
	widget = wibox.container.background,
})

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, _, _)
	-- Set art widget
	art:set_image(gears.surface.load_uncached(album_path))

	-- Set player name, title and artist widgets
	title_widget:set_markup_silently("<b>" .. title .. " [" .. album .. "]" .. "</b>")
	artist_widget:set_markup_silently("By <b>" .. artist .. "</b>")
end)

local function DecimalsToMinutes(dec)
	local ms = tonumber(dec)
	return string.format("%02d:%02d", math.floor(ms / 60), math.floor(ms % 60))
end

playerctl:connect_signal("position", function(_, pos, length, _)
	time_bar.value = (pos / length) * 100

	start_time.markup = DecimalsToMinutes(pos)
	end_time.markup = DecimalsToMinutes(length)
end)
