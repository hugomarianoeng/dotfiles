local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local network_widget = wibox.widget {
    {
        id = 'text',
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Adiciona o clique para abrir o network manager
network_widget:buttons(gears.table.join(
    awful.button({ }, 1, function()
        awful.spawn("nm-connection-editor")
    end)
))

local function update_network()
    awful.spawn.easy_async_with_shell(
        "nmcli -t -f STATE general",
        function(stdout)
            local state = stdout:match("^([^\r\n]+)")
            local icon = "󰖪"
            local color = "#f7768e"

            if state == "connected" then
                awful.spawn.easy_async_with_shell(
                    "nmcli -t -f TYPE device status | grep -E 'wifi|ethernet' | head -n1",
                    function(type_out)
                        local net_color = "#9ece6a"
                        if type_out:match("wifi") then
                            icon = "󰖩"
                        else
                            icon = "󰈀"
                        end
                        network_widget:get_children_by_id('text')[1]:set_markup(
                            string.format('<span foreground="%s">%s</span> ', net_color, icon)
                        )
                    end
                )
            else
                network_widget:get_children_by_id('text')[1]:set_markup(
                    string.format('<span foreground="%s">%s</span> ', color, icon)
                )
            end
        end
    )
end

update_network()
gears.timer {
    timeout = 10,
    autostart = true,
    callback = update_network
}

return network_widget
