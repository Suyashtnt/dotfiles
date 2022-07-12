pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local helpers = require("helpers")
require("awful.autofocus")

local beautiful = require("beautiful")

local ruled = require("ruled")
local menubar = require("menubar")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local bling = require("bling")

local machi = require("layout-machi")
require("beautiful").layout_machi = machi.get_icon()

playerctl = bling.signal.playerctl.lib()
dpi = beautiful.xresources.apply_dpi

require("awful.hotkeys_popup.keys")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "lvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

-- {{{ beautiful conf
local xrdb = beautiful.xresources.get_current_theme()
x = {
	--           xrdb variable
	background = xrdb.background,
	foreground = xrdb.foreground,
	color0 = xrdb.color0,
	color1 = xrdb.color1,
	color2 = xrdb.color2,
	color3 = xrdb.color3,
	color4 = xrdb.color4,
	color5 = xrdb.color5,
	color6 = xrdb.color6,
	color7 = xrdb.color7,
	color8 = xrdb.color8,
	color9 = xrdb.color9,
	color10 = xrdb.color10,
	color11 = xrdb.color11,
	color12 = xrdb.color12,
	color13 = xrdb.color13,
	color14 = xrdb.color14,
	color15 = xrdb.color15,
}
-- }}}

require("modules.notifs")
require("modules.layouts")
require("modules.tags")
require("modules.taglist")
require("modules.tasklist")
require("modules.layoutbox")
require("modules.wibar")

require("widgets.leftbar")
require("widgets.rightbar")

screen.connect_signal("request::wallpaper", function(s)
	gears.wallpaper.maximized(beautiful.wallpaper, s)
	awful.spawn.with_shell("feh --no-xinerama --bg-center ~/.config/awesome/wallpaper.png")
end)

awful.mouse.append_global_mousebindings({
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})

require("modules.keybinds.awesome")
require("modules.keybinds.spotify")
require("modules.keybinds.screenshot")
require("modules.keybinds.apps")
require("modules.keybinds.tags")
require("modules.keybinds.focus")
require("modules.keybinds.layout")

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

client.connect_signal("manage", function(c)
	c.shape = helpers.rrect(beautiful.border_radius)
end)

ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			role = {
				"pop-up",
			},
		},
		properties = { floating = true },
	})

	ruled.client.append_rule({
		rule = { class = { "Firefox" } },
		properties = { screen = 1, tag = "2" },
	})

	ruled.client.append_rule({
		rule = { class = { "Steam" } },
		properties = { screen = 1, tag = "5" },
	})

	ruled.client.append_rule({
		rule = { class = { "Discord" } },
		properties = { screen = 1, tag = "4" },
	})
end)

client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)
