local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

local section_shapes = helpers.rrect(beautiful.wibar_radius)

local function get_color_based_on_number(colour_number_map, value)
	table.sort(colour_number_map, function(a, b)
		return a.v > b.v
	end)
	for _, v in ipairs(colour_number_map) do
		if value >= v.v then
			return v.col
		end
	end

	-- default
	return colour_number_map[1].col
end

local function colourize_based_on_number(colour_percentage_map, value, text)
	return helpers.colorize_text(text, get_color_based_on_number(colour_percentage_map, value))
end

local function textbox()
	local tb = wibox.widget.textbox()
	tb.align = "center"
	tb.valign = "center"
	tb.font = beautiful.wibar_font
	return tb
end

local clock = wibox.widget.textclock(
	helpers.create_emoji("\u{f017}", beautiful.green)
		.. " <span foreground='#abe9b3'>%b %d</span> <span foreground='#96cdfb'>%H:%M</span>"
)
clock.font = beautiful.wibar_font

local net_speed = textbox()
vicious.register(net_speed, vicious.contrib.net, function(_, args)
	return helpers.create_emoji("\u{f019}", beautiful.yellow)
		.. " "
		.. args["{total down_mb}"]
		.. "mb "
		.. helpers.create_emoji("\u{f093}", beautiful.blue)
		.. " "
		.. args["{total up_mb}"]
		.. "mb"
end, 1)

local main_col_table = {
	{
		v = 0,
		col = beautiful.green,
	},
	{
		v = 60,
		col = beautiful.yellow,
	},
	{
		v = 80,
		col = beautiful.red,
	},
}

local cpu = textbox()
local cpu_radial = wibox.container.radialprogressbar(cpu)
cpu_radial.paddings = {
	top = 2,
	bottom = 2,
}
cpu_radial.forced_width = 50

vicious.register(cpu, vicious.widgets.cpu, function(_, args)
	return colourize_based_on_number(main_col_table, args[1], args[1] .. "%")
end, 3)
vicious.register(cpu_radial, vicious.widgets.cpu, "$1", 3)

local mem = textbox()
local mem_radial = wibox.container.radialprogressbar(mem)
mem_radial.paddings = {
	top = 2,
	bottom = 2,
}
mem_radial.forced_width = 70

vicious.cache(vicious.widgets.mem)
vicious.register(mem, vicious.widgets.mem, function(_, args)
	return colourize_based_on_number(main_col_table, args[1], ("%.1fGiB"):format(args[2] / 1000))
end, 3)
vicious.register(mem_radial, vicious.widgets.mem, "$1", 3)

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
				helpers.merge({
					{
						widget = wibox.container.place({
							{
								{
									widget = clock,
									align = "center",
									valign = "center",
								},
								net_speed,
								{
									widget = textbox(),
									markup = helpers.create_emoji("\u{f538}", beautiful.blue),
								},
								mem_radial,
								{
									widget = textbox(),
									markup = helpers.create_emoji("\u{f2db}", beautiful.blue),
								},
								cpu_radial,
								wibox.widget.systray(),
								s.layoutbox,

								layout = wibox.layout.fixed.horizontal,
								spacing = beautiful.systray_icon_spacing,
								spacing_widget = wibox.widget.seperator,
							},
							widget = wibox.container.background,
							fg = beautiful.green,
						}),
						align = "center",
						valign = "center",
					},
					widget = wibox.container.margin,
				}, beautiful.wibar_right_section_margins),
				widget = wibox.container.background,
				bg = beautiful.bg_normal,
				-- The systray widget doesnt respect forced_height and makes this look bad
				shape_border_color = beautiful.border_color_normal,
				shape_border_width = beautiful.tasklist_shape_border_width,
				shape = section_shapes,
			},
		},
		height = beautiful.wibar_height,
		bg = beautiful.bg_normal .. "00",
		type = "dock",
	})
end)
-- }}}
