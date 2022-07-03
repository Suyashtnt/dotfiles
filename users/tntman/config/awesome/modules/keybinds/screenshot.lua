local awful = require("awful")

awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "s", function()
    awful.spawn.with_shell("maim -s --format png /dev/stdout | xclip -selection clipboard -t image/png -i")
  end, { description = "Screen Capture", group = "screenshot" }),

  awful.key({ modkey, "Shift" }, "s", function()
    awful.spawn.with_shell(
      "maim -i $(xdotool getactivewindow) --format png /dev/stdout | xclip -selection clipboard -t image/png -i"
    )
  end, { description = "Capture Active", group = "screenshot" }),

  awful.key({ modkey, "Control" }, "s", function()
    awful.spawn.with_shell("maim --format png /dev/stdout | xclip -selection clipboard -t image/png -i")
  end, { description = "Capture Screen", group = "screenshot" }),
})
