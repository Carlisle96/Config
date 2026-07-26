local M = {}

M.monitor = {
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = "1",
}

M.center_single_master = false
M.achievement_display = "compact"
M.achievement_compact_x = "40"
M.achievement_compact_y = "64"
M.achievement_compact_anchor = "top center"
M.keepass_move = "1056 516"
M.keepass_size = "800 500"
M.nnn_size = "1267 864"
M.sideterm_size = "864 540"
M.sideterm_move = "134 497"
M.pomo_size = "300 300"
M.calc_size = "420 480"
M.calc_move = "1436 64"
M.dragon_move = "1766 540"
M.pomotroid_move_idle = "144 64"
M.pomotroid_move_active = "461 259"

function M.autostart()
    hl.exec_cmd("light -N 1")
    hl.exec_cmd("dunstctl reload ~/.config/dunst/dunstrc ~/.config/dunst/laptop.conf")
end

function M.binds()
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10"), { locked = true, repeating = true })
    hl.bind("SUPER + slash", hl.dsp.exec_cmd("thyachieve-toggle"), { locked = true })
    hl.gesture({
        fingers = 3,
        direction = "vertical",
        action = "workspace",
    })
    hl.gesture({
        fingers = 3,
        direction = "left",
        action = function()
            hl.dispatch(hl.dsp.group.next())
        end
    })
    hl.gesture({
        fingers = 3,
        direction = "right",
        action = function()
            hl.dispatch(hl.dsp.group.prev())
        end
    })
end

function M.rules()
    hl.window_rule({
        name = "group-all-windows",
        match = {
            class = "negative:^(nnn|sideterm|pomotroid)$",
            float = false,
            fullscreen = false,
            modal = false
        },
        group = "set"
    })

    hl.window_rule({
        name = "group-windows-opened-from-nnn",
        match = {
            workspace = "name:special:nnn",
            class = "negative:^nnn$",
            float = false,
            fullscreen = false,
            modal = false
        },
        group = "override barred set"
    })

end

return M
