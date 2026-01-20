local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local memory_widget = wibox.widget {
    {
        id = 'text',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

local function update_memory()
    awful.spawn.easy_async_with_shell(
        "free | grep Mem | awk '{print ($3/$2) * 100.0}'",
        function(stdout)
            local mem = tonumber(stdout)
            if mem then
                local color = "#9ece6a"
                if mem > 80 then
                    color = "#f7768e"
                elseif mem > 60 then
                    color = "#e0af68"
                end
                memory_widget:get_children_by_id('text')[1]:set_markup(
                    string.format('<span foreground="#2ac3de">󰍛 </span><span foreground="%s">%.0f%%</span> ', color, mem)
                )
            end
        end
    )
end

update_memory()
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update_memory
}

return memory_widget
