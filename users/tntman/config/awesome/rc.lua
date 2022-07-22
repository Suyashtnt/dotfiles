pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local helpers = require("helpers")
require("awful.autofocus")

local beautiful = require("beautiful")

local ruled = require("ruled")
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

require("modules.notifs")
require("modules.layouts")
require("modules.tags")
require("modules.taglist")
require("modules.tasklist")
require("modules.layoutbox")
require("modules.wibar")

require("modules.rightbar")

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
	if beautiful.border_radius ~= nil then
		c.shape = helpers.rrect(beautiful.border_radius)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end

	if c.icon == nil then
		local i = gears.surface(beautiful.theme_assets.awesome_icon(256, beautiful.blue, beautiful.bg_normal))
		c.icon = i._native
	end
end)

ruled.client.connect_signal("request::rules", function()
	local tags = require("modules.tags")
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
		properties = { screen = 1, tag = tags[2] },
	})

	ruled.client.append_rule({
		rule = { class = { "Steam" } },
		properties = { screen = 1, tag = tags[5] },
	})

	ruled.client.append_rule({
		rule = { class = { "Discord" } },
		properties = { screen = 1, tag = tags[4] },
	})

	ruled.client.append_rule({
		rule = { class = { "neovide" } },
		properties = { screen = 1, tag = tags[3] },
	})

	ruled.client.append_rule({
		rule = { class = { "Spotify" } },
		properties = { screen = 1, tag = tags[6] },
	})
end)

client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)
