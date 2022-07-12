-- modules
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local vicious = require("vicious")
local beautiful = require("beautiful")

-- Create the sidebar_left
local sidebar_left = wibox({ visible = false, ontop = true, type = "dock", screen = screen.primary })
sidebar_left.bg = "#00000000" -- For anti aliasing
sidebar_left.fg = beautiful.fg_normal
sidebar_left.opacity = 1
sidebar_left.height = screen.primary.geometry.height / 1.5
sidebar_left.width = dpi(300)
sidebar_left.y = 0

awful.placement.left(sidebar_left)

local sidebar_left_hide = function()
	sidebar_left.visible = false
end

sidebar_left:buttons(gears.table.join(
	-- Middle click - Hide sidebar_left
	awful.button({}, 2, function()
		sidebar_left_hide()
	end)
))

sidebar_left:connect_signal("mouse::leave", function()
	sidebar_left_hide()
end)
-- Activate sidebar_left by moving the mouse at the edge of the screen

local sidebar_left_activator = wibox({
	y = sidebar_left.y,
	width = 1,
	visible = true,
	ontop = false,
	opacity = 0,
	below = true,
	screen = screen.primary,
})

sidebar_left_activator.height = sidebar_left.height
sidebar_left_activator:connect_signal("mouse::enter", function()
	sidebar_left.visible = true
end)
awful.placement.left(sidebar_left_activator)

local function make_fa_icon(code)
	return "<span color='#cdd6f4' font='" .. beautiful.icon_font .. "'>" .. code .. "</span> "
end

local function colourize_based_on_number(colour_percentage_map, value, text)
	table.sort(colour_percentage_map, function(a, b)
		return a.v > b.v
	end)
	for _, v in ipairs(colour_percentage_map) do
		if value > v.v then
			return helpers.colorize_text(text, v.col)
		end
	end
end

local function textbox()
	local tb = wibox.widget.textbox()
	tb.align = "center"
	tb.valign = "center"
	return tb
end

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

local cpuwidget = textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, function(_, args)
	return make_fa_icon("\u{f2db}") .. colourize_based_on_number(main_col_table, args[1], args[1] .. "%")
end, 3)

local memwidget = textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, function(_, args)
	return make_fa_icon("\u{f538}")
		.. colourize_based_on_number(main_col_table, args[1], ("%s%% (%sMiB/%sMiB)"):format(args[1], args[2], args[3]))
end, 13)

-- sidebar_left placement
sidebar_left:setup({
	{
		helpers.vertical_pad(16),
		cpuwidget,
		memwidget,
		helpers.vertical_pad(16),
		layout = wibox.layout.fixed.vertical,
	},
	shape = helpers.prrect(dpi(40), false, true, true, false),
	bg = beautiful.bg_normal,
	widget = wibox.container.background,
})
