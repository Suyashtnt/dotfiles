local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

screen.connect_signal("request::desktop_decoration", function(s)
  s.mytasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    style = {
      shape = gears.shape.rounded_bar,
    },

    layout = {
      spacing = 12,
      spacing_widget = {
        {
          forced_width = 8,
          shape = gears.shape.circle,
          widget = wibox.widget.separator,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.fixed.horizontal,
    },

    widget_template = {
      {
        {
          {
            id = "icon_role",
            widget = wibox.widget.imagebox,
          },
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(6),
        },
        left = dpi(16),
        right = dpi(16),
        top = dpi(8),
        bottom = dpi(8),
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },

    buttons = {
      awful.button({}, 1, function(c)
        c:activate({ context = "tasklist", action = "toggle_minimization" })
      end),
      awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
      end),
      awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
      end),
      awful.button({}, 5, function()
        awful.client.focus.byidx(1)
      end),
    },
  })
end)
