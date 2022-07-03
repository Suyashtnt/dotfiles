local awful = require("awful")
local bling = require("bling")
local machi = require("layout-machi")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		bling.layout.mstab,
		bling.layout.centered,
		machi.default_layout,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.right,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.max,
		awful.layout.suit.magnifier,
	})
end)
