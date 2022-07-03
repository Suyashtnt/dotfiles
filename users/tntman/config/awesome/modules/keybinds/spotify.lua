local awful = require("awful")
local naughty = require("naughty")

local play_command = function()
  playerctl:play_pause()
end

awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "p", play_command, { description = "Play/Pause", group = "spotify" }),

  awful.key({ modkey, "Shift" }, "l", function()
    awful.spawn.easy_async_with_shell("spt playback --like", function(out)
      naughty.notification({ title = "liked song", message = out })
    end)
  end, { description = "Like currently playing song", group = "spotify" }),

  awful.key({ modkey, "Shift" }, "p", function()
    awful.spawn.easy_async_with_shell("spt playback --share-track | xclip -selection c", function()
      naughty.notification({ title = "copied link", message = "copied to clipboard" })
    end)
  end, { description = "Copy current song URL to clipboard", group = "spotify" }),
})
