local awful = require("awful")
local machi = require("layout-machi")

--  icon path relative to ./icons
local tags = {
	"\u{f120}",
	"\u{e007}",
	"\u{f121}",
	"\u{f392}",
	"\u{f1b6}",
	"\u{f025}",
	"\u{f013}"
}

screen.connect_signal("request::desktop_decoration", function(s)
	for id, tag in pairs(tags) do
		awful.tag.add(tag, {
			layout = machi.default_layout,
			screen = s,
		})
	end
end)

return tags
