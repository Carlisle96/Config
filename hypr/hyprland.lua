local device = require("device")
require("layouts.thylayout").setup()

hl.monitor(device.monitor)

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/libexec/xfce-polkit")
    hl.exec_cmd("/home/thyriaen/.config/hypr/scripts/nnn-listen.sh")
    hl.exec_cmd("TZ=Etc/GMT-1 wlsunset -t 1000 -s 19:30 -S 07:30 -d 7200")
    hl.exec_cmd("keepassxc")
    hl.exec_cmd("synology-drive start")
    hl.exec_cmd("flatpak run org.signal.Signal --use-tray-icon")
    device.autostart()
end)

-------------------
--- ENVIRONMENT ---
-------------------

hl.env("XCURSOR_THEME", "material_light_cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "material_light_cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")

------------
--- LOOK ---
------------

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 16,
        border_size = 4,
        col = {
            active_border = "rgb(7652B8)",
            inactive_border = "rgb(18191A)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "lua:thylayout",
    },
    decoration = {
        rounding = 16,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 16,
            render_power = 4,
            color = "rgba(18191Aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    group = {
        col = {
            border_active = "rgb(7652B8)",
            border_inactive = "rgb(18191A)",
        },
        groupbar = {
            enabled = true,
            font_size = 14,
            font_family = "Hasklug Nerd Font",
            font_weight_active = "Bold",
            gradients = true,
            height = 24,
            indicator_height = 0,
            indicator_gap = 0,
            gradient_rounding = 16,
            keep_upper_gap = false,
            col = {
                active = "rgb(7652B8)",
                inactive = "rgb(18191A)",
            },
            text_color = "rgb(E9EAEB)",
            gaps_in = 8,
            gaps_out = 8,
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
    },
    input = {
        kb_layout = "thy",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-----------------
--- ANIMATION ---
-----------------

hl.curve("myBezier", {
    type = "bezier",
    points = {
        { 0.05, 0.9 },
        { 0.1,  1.05 },
    },
})
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "slidevert" })

-------------
--- BINDS ---
-------------


hl.bind("SUPER + TAB", hl.dsp.group.next())
hl.bind("SUPER + space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
device.binds()

for i = 1, 6 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + W", hl.dsp.window.fullscreen())
hl.bind("SUPER + E", hl.dsp.exec_cmd(
    "google-chrome --new-window --app=https://mail.superhuman.com/ " ..
    "--user-data-dir=/home/thyriaen/.webapps/superhuman " ..
    "--ozone-platform=wayland --password-store=basic"))
-- hl.bind("SUPER + R")
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))

-- hl.bind("SUPER + A")
hl.bind("SUPER + S", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind("SUPER + D")
hl.bind("SUPER + F", hl.dsp.workspace.toggle_special("nnn"))
hl.bind("SUPER + G", hl.dsp.group.toggle())

-- hl.bind("SUPER + Z")
-- hl.bind("SUPER + X")
hl.bind("SUPER + C", hl.dsp.exec_cmd("mate-calc"))
hl.bind("SUPER + V", hl.dsp.workspace.toggle_special("sideterm"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))


hl.bind("SUPER + P",
    hl.dsp.exec_cmd('grim -g "$(slurp)" - | tee ~/Pictures/screenshots/$(date +%s).png | wl-copy'))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("pomo"))


hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------
--- RULES ---
-------------

local keep_on_special = {
    nnn = true,
    sideterm = true,
    pomotroid = true,
}

hl.on("window.open", function(w)
    local special = hl.get_active_special_workspace()
    if special == nil then
        return
    end

    if keep_on_special[w.class] then
        return
    end

    local ws = hl.get_active_workspace()
    if ws == nil then
        return
    end

    if w.workspace ~= nil and w.workspace.name:match("^special:") then
        hl.dispatch(hl.dsp.window.move({
            window = w,
            workspace = ws,
            follow = false,
        }))
    end
end)

hl.workspace_rule({ workspace = "special:nnn", on_created_empty = 'kitty --class=nnn sh -c "nnn -d -P p"' })
hl.workspace_rule({ workspace = "special:sideterm", on_created_empty = "kitty --class=sideterm" })
hl.workspace_rule({ workspace = "special:pomo", on_created_empty = "pomotroid" })


hl.window_rule({
    name = "xwayland-error",
    match = { xwayland = true },
    border_color = "rgb(B85261) rgb(18191A)"
})
hl.window_rule({
    name = "spotify-border",
    match = { class = "^(Spotify)$" },
    border_color = "rgb(7652B8) rgb(18191A)"
})
hl.window_rule({
    name = "steam-border",
    match = { class = "^(steam)$" },
    border_color = "rgb(7652B8) rgb(18191A)"
})
hl.window_rule({
    name = "mediachips-border",
    match = { class = "^(MediaChips)$" },
    border_color = "rgb(7652B8) rgb(18191A)"
})

hl.window_rule({
    name = "kitty-workspace",
    match = { class = "^(kitty)$" },
    workspace = "1"
})
hl.window_rule({
    name = "zed-workspace",
    match = { class = "^(dev.zed.Zed)$" },
    workspace = "3"
})
hl.window_rule({
    name = "datev-workspace",
    match = { class = "^(chrome-duo\\.datev\\.de__-Default)$" },
    workspace = "4"
})
hl.window_rule({
    name = "firefox-workspace",
    match = { class = "^(org\\.mozilla\\.firefox)$" },
    workspace = "5"
})
hl.window_rule({
    name = "spotify-workspace",
    match = { class = "^(Spotify)$" },
    workspace = "6"
})
hl.window_rule({
    name = "signal-workspace",
    match = { class = "^(org.signal.Signal)$" },
    workspace = "6"
})

hl.layer_rule({
    name = "vicinae",
    no_anim = true,
    blur = true,
    ignore_alpha = 0,
    match = { namespace = "vicinae" },
})

hl.window_rule({
    name = "dragon",
    match = { class = "^(dragon)$" },
    float = true,
    move = device.dragon_move
})
hl.window_rule({
    name = "file-picker",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
    size = "1032 576",
    center = true
})
hl.window_rule({
    name = "superhuman",
    match = { class = "^(chrome-mail\\.superhuman\\.com__-Default)$" },
    workspace = "2",
    tile = true,
    opacity = 0.95
})
hl.window_rule({
    name = "nnn",
    match = { class = "^(nnn)$" },
    float = true,
    size = device.nnn_size,
    center = true
})
hl.window_rule({
    name = "sideterm",
    match = { class = "^(sideterm)$" },
    float = true,
    size = device.sideterm_size,
    move = device.sideterm_move
})
hl.window_rule({
    name = "sublime",
    match = { class = "^(sublime_text)$" },
    workspace = "1",
    opacity = 0.95
})
hl.window_rule({
    name = "keepass",
    match = { class = "^(org\\.keepassxc\\.KeePassXC)$", title = "^.* - KeePassXC$" },
    float = true,
    size = device.keepass_size,
    move = device.keepass_move
})
hl.window_rule({
    name = "mate-calc",
    match = { class = "^(mate-calc)$" },
    float = true,
    size = device.calc_size,
    move = device.calc_move
})
hl.window_rule({ name = "web-eid", match = { class = "^(eu.web-eid.web-eid)$" }, float = true })
hl.window_rule({ name = "xfce-polkit", match = { class = "^(xfce-polkit)$" }, float = true })
hl.window_rule({ name = "pomotroid-float", match = { class = "^(pomotroid)$" }, float = true })
hl.window_rule({ name = "pomotroid-size", match = { class = "^(pomotroid)$" }, size = device.pomo_size })
hl.window_rule({
    name = "pomotroid-idle",
    match = { class = "^(pomotroid)$", title = "^(Pomotroid)$" },
    move = device.pomotroid_move_idle or "160 84"
})
hl.window_rule({
    name = "pomotroid-active",
    match = { class = "^(pomotroid)$", title = "^(Pomotroid .+)$" },
    move = device.pomotroid_move_active or "240 128"
})

device.rules()
