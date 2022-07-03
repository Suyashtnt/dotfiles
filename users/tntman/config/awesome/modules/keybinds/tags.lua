local awful = require("awful")

awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),
})
