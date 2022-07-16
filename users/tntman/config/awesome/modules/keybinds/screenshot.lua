local awful = require("awful")
local naughty = require("naughty")

awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "s", function()
		awful.spawn.with_shell("~/dotfiles/users/tntman/config/awesome/utils/screensht area")
	end, { description = "Take Screenshot", group = "Screenshot" }),

	awful.key({ modkey, "Shift" }, "s", function()
		awful.spawn.with_shell(
			"maim -i $(nix run nixpkgs#xdotool -- getactivewindow) --format png /dev/stdout | xclip -selection clipboard -t image/png -i"
		)
	end, { description = "Capture Active", group = "Screenshot" }),

	awful.key({ modkey, "Control" }, "s", function()
		awful.spawn.with_shell("~/dotfiles/users/tntman/config/awesome/utils/screensht full")
	end, { description = "Capture Screen", group = "Screenshot" }),

	awful.key({ modkey, "Control", "Shift" }, "s", function()
		awful.spawn.with_shell("sleep 5 && ~/dotfiles/users/tntman/config/awesome/utils/screensht full")
	end, { description = "Capture Screen (5 sec delay)", group = "Screenshot" }),
})
