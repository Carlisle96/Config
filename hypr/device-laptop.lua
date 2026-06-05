local M = {}

M.monitor = {
    output = "eDP-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = "1",
}

M.center_single_master = false
M.achievement_display = "full"
M.keepass_move = "1280 584"
M.keepass_size = "576 432"
M.nnn_size = "1267 864"
M.sideterm_size = "864 540"
M.sideterm_move = "134 497"
M.pomo_size = "192 108"
M.calc_size = "576 432"
M.calc_move = "1306 16"
M.dragon_move = "1766 540"
M.pomotroid_move_idle = "77 130"
M.pomotroid_move_active = "461 259"

function M.autostart()
    hl.exec_cmd("light -N 1")
end

function M.binds()
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10"), { locked = true, repeating = true })
    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
end

function M.rules() end

return M
