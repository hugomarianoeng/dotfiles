local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local battery_widget = wibox.widget {
    {
        id = 'text',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

local function update_battery()
    awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/BAT0/capacity && cat /sys/class/power_supply/BAT0/status", function(stdout)
        local lines = {}
        for line in stdout:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local cap = tonumber(lines[1])
        local status = lines[2]

        if cap then
            local icon = ""
            local color = "#9ece6a"

            if status and status:match("Charging") then
                if cap >= 90 then
                    icon = "󰂅"
                elseif cap >= 70 then
                    icon = "󰂋"
                elseif cap >= 50 then
                    icon = "󰂊"
                elseif cap >= 30 then
                    icon = "󰢞"
                    color = "#e0af68"
                elseif cap >= 15 then
                    icon = "󰢜"
                    color = "#ff9e64"
                else
                    icon = "󰢟"
                    color = "#f7768e"
                end
            else
                if cap >= 90 then
                    icon = "󰁹"
                elseif cap >= 80 then
                    icon = "󰂂"
                elseif cap >= 70 then
                    icon = "󰂁"
                elseif cap >= 60 then
                    icon = "󰂀"
                elseif cap >= 50 then
                    icon = "󰁿"
                elseif cap >= 40 then
                    icon = "󰁾"
                elseif cap >= 30 then
                    icon = "󰁽"
                    color = "#e0af68"
                elseif cap >= 20 then
                    icon = "󰁼"
                    color = "#ff9e64"
                elseif cap >= 10 then
                    icon = "󰁻"
                    color = "#f7768e"
                else
                    icon = "󰁺"
                    color = "#f7768e"
                end
            end

            battery_widget:get_children_by_id('text')[1]:set_markup(
                string.format('<span foreground="%s">%s %d%%</span> ', color, icon, cap)
            )
        end
    end)
end

update_battery()
gears.timer {
    timeout = 30,
    autostart = true,
    callback = update_battery
}

return battery_widget
