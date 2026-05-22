local M = {}

M.monitor = {
    output = "DP-3",
    mode = "3440x1440@165",
    position = "0x0",
    scale = "1",
    vrr = 0,
}

M.center_single_master = true
M.keepass_move = "2344 800"
M.keepass_size = "1032 576"
M.nnn_size = "1720 1152"
M.sideterm_size = "1200 720"
M.sideterm_move = "140 652"
M.pomo_size = "352 416"
M.calc_size = "420 480"
M.calc_move = "2968 42"
M.dragon_move = "3240 700"

function M.autostart()
    hl.exec_cmd("easyeffects --gapplication-service")
end

function M.binds()
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 0"), { locked = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("ddcutil setvcp 10 60"), { locked = true })
end

function M.rules()
    hl.window_rule({
        name = "cs2",
        match = { class = "^(cs2)$" },
        float = true,
        fullscreen = true,
    })
end

return M
