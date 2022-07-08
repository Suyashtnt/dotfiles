local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

-- Create a textclock widget
local clock = wibox.widget.textclock("<span foreground='#abe9b3'>%b %d</span> <span foreground='#96cdfb'>%H:%M</span>")

screen.connect_signal("request::desktop_decoration", function(s)
  -- Create the wibox
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    margins = {
      top = 8,
      left = 16,
      right = 16,
    },
    widget = {
      widget = wibox.container.background,
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        s.mytaglist,
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, 24)
        end,
      },
      { -- Middle widget
        {
          widget = wibox.container.place(
            s.mytasklist
          ),
          align = "center",
          valign = "center",
        },
        right = 32,
        left = 32,
        widget = wibox.container.margin,
      },
      { -- Right widgets
        {
          layout = wibox.layout.fixed.horizontal,
          {
            {
              {
                widget = clock,
                align = "center",
                valign = "center",
              },
              widget = wibox.container.margin,
              left = dpi(16),
              right = dpi(16),
              top = dpi(8),
              bottom = dpi(8),
            },
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
            shape = function(cr, width, height)
              gears.shape.rounded_rect(cr, width, height, dpi(24))
            end,
          },
          {
            {
              widget = wibox.container.place({
                net_speed_widget(),
                widget = wibox.container.background,
                fg = "#efd9a9",
              }),
              align = "center",
              valign = "center",
            },
            widget = wibox.container.margin,
            top = dpi(8),
            bottom = dpi(8),
            left = dpi(16),
            right = dpi(16),
          },
          {
            {
              wibox.widget.systray(),
              s.mylayoutbox,
              layout = wibox.layout.fixed.horizontal,
              spacing = dpi(8),
            },
            widget = wibox.container.margin,
            bg = beautiful.bg_normal,
            top = dpi(8),
            bottom = dpi(8),
            left = dpi(12),
            right = dpi(12),
          },
        },
        widget = wibox.container.background,
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, dpi(24))
        end,
      },
    },
    height = dpi(40),
    bg = beautiful.bg_normal .. "00",
  })
end)
-- }}}
