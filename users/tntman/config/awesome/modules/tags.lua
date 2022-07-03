local awful = require("awful")
local gears = require("gears")

--  icon path relative to ./icons
local tags = {
	{ ["icon"] = "console", ["colour"] = "#11111b" },
	{
		["icon"] = "firefox",
		["colour"] = "#fe7a08",
	},
	{
		["icon"] = "code-tags",
		["colour"] = "#8ab5fa",
	},
	{
		["icon"] = "discord",
		["colour"] = "#5662f6",
	},
	{
		["icon"] = "google-controller",
		["colour"] = "#1e66f5",
	},
	{
		["icon"] = "headphones",
		["colour"] = "#1dd05d",
	},
	{
		["icon"] = "cog",
		["colour"] = "#a5acc9",
	},
}

screen.connect_signal("request::desktop_decoration", function(s)
	for id, tag in pairs(tags) do
		awful.tag.add(id, {
			icon = gears.color.recolor_image(
				gears.filesystem.get_configuration_dir() .. "icons/" .. tag.icon .. ".svg",
				"#FFFFFF"
			),
			layout = awful.layout.suit.tile,
			screen = s,
			icon_only = true,
		})
	end
end)

return tags
