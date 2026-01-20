local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local volume_widget = wibox.widget {
    {
        id = 'text',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

local function update_volume()
    awful.spawn.easy_async_with_shell("pamixer --get-volume && pamixer --get-mute", function(stdout)
        local lines = {}
        for line in stdout:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        local vol = tonumber(lines[1])
        local muted = lines[2]

        if vol then
            local icon = "󰕾"
            if muted == "true" then
                icon = "󰖁"
            elseif vol == 0 then
                icon = "󰖁"
            elseif vol < 30 then
                icon = "󰕿"
            elseif vol < 70 then
                icon = "󰖀"
            else
                icon = "󰕾"
            end
            volume_widget:get_children_by_id('text')[1]:set_markup(
                string.format('<span foreground="#bb9af7">%s %d%%</span> ', icon, vol)
            )
        end
    end)
end

update_volume()
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update_volume
}

return volume_widget
