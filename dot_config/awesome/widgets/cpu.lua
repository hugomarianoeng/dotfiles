local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local cpu_widget = wibox.widget {
    {
        id = 'text',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

local function update_cpu()
    awful.spawn.easy_async_with_shell(
        "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'",
        function(stdout)
            local cpu = tonumber(stdout)
            if cpu then
                local color = "#9ece6a"
                if cpu > 80 then
                    color = "#f7768e"
                elseif cpu > 50 then
                    color = "#e0af68"
                end
                cpu_widget:get_children_by_id('text')[1]:set_markup(
                    string.format('<span foreground="#7dcfff">󰻠 </span><span foreground="%s">%.0f%%</span> ', color, cpu)
                )
            end
        end
    )
end

update_cpu()
gears.timer {
    timeout = 5,
    autostart = true,
    callback = update_cpu
}

return cpu_widget
