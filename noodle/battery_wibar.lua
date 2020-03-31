local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

-- Set colors
local active_color = "#2E88F0"
local background_color = beautiful.battery_bar_background_color or "#222222"
local above80_color = "#31BD56"
local below20_color = "#F02E2E"
local charging_color = "#F0B52E"
local screen_width = awful.screen.focused().geometry.width

local battery_bar = wibox.widget{
  max_value     = 100,
  value         = 50,
    forced_height = dpi(10),
    margins       = {
      top = dpi(1),
      bottom = dpi(1),
    },
    forced_width  = screen_width,
  shape         = gears.shape.rounded_bar,
  bar_shape     = gears.shape.rounded_bar,
  color         = active_color,
  background_color = background_color,
  border_width  = 0,
  border_color  = beautiful.border_color,
  widget        = wibox.widget.progressbar,
}

awesome.connect_signal("evil::battery", function(value)
    battery_bar.value = value
    if battery_bar.color ~= charging_color then
        if value > 78 then
            battery_bar.color = above80_color
        elseif value < 20 then 
            battery_bar.color = below20_color
        else
            battery_bar.color = active_color
        end
    end
end)

awesome.connect_signal("evil::charger", function(plugged)
    if plugged then
        battery_bar.color = charging_color
    else
        if battery_bar.value > 78 then
            battery_bar.color = above80_color
        elseif battery_bar.value < 20 then 
            battery_bar.color = below20_color
        else
            battery_bar.color = active_color
        end
    end
end)

return battery_bar