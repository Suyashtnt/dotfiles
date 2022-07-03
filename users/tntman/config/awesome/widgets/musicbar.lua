-- modules
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")

-- Create the music sidebar
local music_sidebar = wibox({ visible = false, ontop = true, type = "dock", screen = screen.primary })
music_sidebar.bg = "#00000000" -- For anti aliasing
music_sidebar.fg = x.color7
music_sidebar.opacity = 1
music_sidebar.height = screen.primary.geometry.height / 1.5
music_sidebar.width = dpi(350)
music_sidebar.y = 0

awful.placement.right(music_sidebar)
awful.placement.maximize_vertically(sidebar, { honor_workarea = true, margins = { top = dpi(5) * 2 } })

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
				icon.markup = helpers.colorize_text("", color)
			else
				icon.markup = helpers.colorize_text("", color)
			end
		end
	end)

	button:buttons(gears.table.join(awful.button({}, 1, function()
		command()
	end)))

	button:connect_signal("mouse::enter", function()
		icon.markup = helpers.colorize_text(icon.text, x.foreground)
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

local playerctl_play_symbol = create_button("", x.color4, play_command, true)

local playerctl_prev_symbol = create_button("玲", x.color4, prev_command, false)
local playerctl_next_symbol = create_button("怜", x.color4, next_command, false)

music_sidebar:buttons(gears.table.join(
	-- Middle click - Hide sidebar
	awful.button({}, 2, function()
		music_sidebar_hide()
	end)
))

music_sidebar:connect_signal("mouse::leave", function()
	music_sidebar_hide()
end)

music_sidebar_show = function()
	music_sidebar.visible = true
end

music_sidebar_hide = function()
	music_sidebar.visible = false
end

music_sidebar_toggle = function()
	if music_sidebar.visible then
		music_sidebar_hide()
	else
		music_sidebar.visible = true
	end
end

-- Activate sidebar by moving the mouse at the edge of the screen

local music_sidebar_activator = wibox({
	y = music_sidebar.y,
	width = 1,
	visible = true,
	ontop = false,
	opacity = 0,
	below = true,
	screen = screen.primary,
})

music_sidebar_activator.height = music_sidebar.height
music_sidebar_activator:connect_signal("mouse::enter", function()
	music_sidebar.visible = true
end)
awful.placement.right(music_sidebar_activator)

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
	forced_height = dpi(8),
	bar_color = x.foreground,
	handle_color = x.foreground,
	handle_shape = gears.shape.circle,
	handle_border_color = x.foreground,
	handle_border_width = dpi(8),
	handle_width = dpi(32),
	value = 25,
	widget = wibox.widget.slider,
})

-- Music sidebar placement
music_sidebar:setup({
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
				api_key = helpers.read_file(os.getenv("HOME") .. "/dotfiles/.secrets/weatherapikey.txt"),
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
	bg = x.background,
	widget = wibox.container.background,
})

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	-- Set art widget
	art:set_image(gears.surface.load_uncached(album_path))

	-- Set player name, title and artist widgets
	title_widget:set_markup_silently("<b>" .. title .. "</b>")
	artist_widget:set_markup_silently("By <b>" .. artist .. "</b>")
end)

local function DecimalsToMinutes(dec)
	local ms = tonumber(dec)
	return math.floor(ms / 60) .. ":" .. math.floor(ms % 60)
end

playerctl:connect_signal("position", function(_, pos, length, _)
	time_bar.value = (pos / length) * 100

	start_time.markup = DecimalsToMinutes(pos)
	end_time.markup = DecimalsToMinutes(length)
end)
