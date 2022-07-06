local awful = require("awful")
local bling = require("bling")
local machi = require("layout-machi")

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		machi.default_layout,
		bling.layout.mstab,
	})
end)
