local awful = require("awful")
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")

awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),

	awful.key({ modkey }, "d", function()
		awful.spawn.with_shell("rofi -show combi &>> /tmp/rofi.log")
	end, { description = "Launch Rofi", group = "applications" }),

	awful.key({ modkey, "Ctrl" }, "l", function()
		logout_popup.launch()
	end, { description = "Show logout screen", group = "custom" }),
})
