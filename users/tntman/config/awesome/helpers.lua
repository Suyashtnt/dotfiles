local wibox = require("wibox")
local gears = require("gears")
local helpers = {}

local function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

helpers.read_file = function(file)
	if not file_exists(file) then
		return {}
	end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

helpers.merge = function(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end

	return t1
end

helpers.colorize_text = function(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

helpers.rrect = function(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

helpers.prrect = function(radius, tl, tr, br, bl)
	return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

function helpers.vertical_pad(height)
	return wibox.widget({
		forced_height = height,
		layout = wibox.layout.fixed.vertical,
	})
end

function helpers.horizontal_pad(width)
	return wibox.widget({
		forced_width = width,
		layout = wibox.layout.fixed.horizontal,
	})
end

return helpers
