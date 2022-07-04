-- modules
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

-- Create the sidebar_left
local sidebar_left = wibox({ visible = false, ontop = true, type = "dock", screen = screen.primary })
sidebar_left.bg = "#00000000" -- For anti aliasing
sidebar_left.fg = x.color7
sidebar_left.opacity = 1
sidebar_left.height = screen.primary.geometry.height / 1.5
sidebar_left.width = dpi(300)
sidebar_left.y = 0

awful.placement.left(sidebar_left)

sidebar_left:buttons(gears.table.join(
	-- Middle click - Hide sidebar_left
	awful.button({}, 2, function()
		sidebar_left_hide()
	end)
))

sidebar_left:connect_signal("mouse::leave", function()
	sidebar_left_hide()
end)

sidebar_left_show = function()
	sidebar_left.visible = true
end

sidebar_left_hide = function()
	sidebar_left.visible = false
end

sidebar_left_toggle = function()
	if sidebar_left.visible then
		sidebar_left_hide()
	else
		sidebar_left_show()
	end
end

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

-- sidebar_left placement
sidebar_left:setup({
	{
		{
			markup = "This <i>is</i> a <b>textbox</b>!!!",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.vertical,
	},
	shape = helpers.prrect(dpi(40), false, true, true, false),
	bg = x.background,
	widget = wibox.container.background,
})
