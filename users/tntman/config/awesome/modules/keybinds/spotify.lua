local awful = require("awful")

local play_command = function()
	playerctl:play_pause()
end

awful.keyboard.append_global_keybindings({
	awful.key({ modkey }, "p", play_command, { description = "Play/Pause", group = "spotify" }),
})
