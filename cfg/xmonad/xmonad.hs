{-# LANGUAGE NoMonomorphismRestriction #-}

import XMonad
import Data.Ratio

import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Combo
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
-- import XMonad.Layout.IndependentScreens
import XMonad.Layout.CenteredIfSingle

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WindowSwallowing

import XMonad.Actions.SpawnOn
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce

import Graphics.X11.ExtraTypes.XF86

import Data.Maybe
import qualified Data.Map        as M
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
-- General Setup
main = xmonad . addEwmhWorkspaceSort (pure myFilter) . ewmh $ docks $ defaults
    where
        myFilter = filterOutWs [scratchpadWorkspaceTag]
        
defaults = def 
    { terminal           = "kitty"
    , focusFollowsMouse  = True
    , borderWidth        = 4
    , modMask            = mod4Mask
    , normalBorderColor  = "#18191A"
    , focusedBorderColor = "#7652B8"
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayout
    -- , workspaces         = ["1","2","3","4","5","6"]
    , workspaces         = ["\61728", "\60188", "\60043", "\61508", "\64158", "\61670"]
    , manageHook         = myManageHook
    , handleEventHook    = myEventHook
    , logHook            = myLogHook
    , startupHook        = autostart }

tabConfig = def 
    { fontName = "xft:M PLUS 1:pixelsize=14:antialias=true:hinting=true"
    , activeColor = "#7652B8"
    , activeTextColor = "#E9EAEB"
    , activeBorderColor = "#7652B8"
    , inactiveColor = "#18191A"
    , inactiveTextColor = "#E9EAEB"
    , inactiveBorderColor = "#18191A"
    , urgentColor = "#B85261"
    , urgentTextColor = "#E9EAEB"
    , urgentBorderColor = "#27292d"
    , decoHeight = 24 }

-- Solid> it's probably more complicated for scratchpads, since once you summon them once they just get moved to another workspace and the manageHook isn't executed after that
-- Solid> but for normal windows you can just do something like "appName =? "my-query" --> doShift . fromJust =<< liftX (screenWorkspace 0)"



------------------------------------------------------------------------
-- Layouts

-- gap = spacingWithEdge 8
-- tabGap = addTabs shrinkText tabConfig . gap

-- myLayout = ( configurableNavigation noNavigateBorders $ avoidStruts 
--    ( testTab ||| dualTab )) ||| fullScr
--  where
--    dualTab = tabGap $ combineTwo (TwoPane 0.03 0.5) testTab testTab
--    monoTab = tabGap Simplest
--    fullScr = noBorders Full
--    testTab = spacingRaw False (Border 16 16 16 16 ) True (Border 8 8 8 8) True ( addTabs shrinkText tabConfig $ 
--        Simplest )


leftTab = spacingRaw False (Border 24 32 16 32) True (Border 8 0 0 0) True $ tabbed shrinkText tabConfig
righTab = spacingRaw False (Border 24 32 32 16) True (Border 8 0 0 0) True $ tabbed shrinkText tabConfig

myLayout = ( configurableNavigation noNavigateBorders $ avoidStruts 
        ( centeredIfSingle 0.75 0.954 dualTab )) ||| fullScr
    where
        dualTab = combineTwo (TwoPane 0.03 0.5) leftTab righTab
        -- monoTab = spacingRaw False (Border 8 16 16 16) True (Border 8 0 0 0) True $ tabbed shrinkText tabConfig
        fullScr = noBorders Simplest

------------------------------------------------------------------------
-- Window rules

myManageHook = manageSpawn <+> composeAll
    [ namedScratchpadManageHook scratchpads
    -- , isDialog  =? doCenterFloat
    , className =? "filepicker" --> floatingCenter
    , className =? "KeePassXC" --> floatingKPass
    , className =? "Xdg-desktop-portal-gtk" --> floatingCenter 
    , className =? "DesktopEditors" --> floatingCenter
    , className =? "Mate-calc" --> floatingCalc 
    , className =? "Signal" --> doShift "6"
    , className =? "Hexchat" --> doShift "6" 
    , className =? "superhuman" --> doShift "2"
    , className =? "kitty" --> doShift "1"
    -- , className =? "Sublime_text" --> doShift "1"
    , className =? "Google-chrome" --> doShift "5" 
    , className =? "datev" --> doShift "4"
    , className =? "Dragon" --> floatingDragon 
    , className =? "Spotify" --> doShift "6"
    -- , className =? "FullScreenGame" --> defineBorderWidth 0
    ]
  where 
    floatingCenter  = doRectFloat ( W.RationalRect   (1 % 5)  (1 % 6)   (3 % 5)  (2 % 3) )
    floatingCalc    = doRectFloat ( W.RationalRect (39 % 48) (1 % 27)  (3 % 32) (5 % 18) ) --DESKTOP
    -- floatingCalc    = doRectFloat ( W.RationalRect (79 % 96) (1 % 27)  (5 % 32) (6 % 18) )
    floatingKPass   = doRectFloat ( W.RationalRect (18 % 32) (9 % 18) (13 % 32) (8 % 18) )
    -- floatingDragon  = doRectFloat ( W.RationalRect  (30 % 32) (23 % 48) (1 % 24) (1 % 18) )
    floatingDragon  = doRectFloat ( W.RationalRect  (15 % 16) (23 % 48) (1 % 48) (1 % 24) ) --DESKTOP

    -- x, y, w, h

------------------------------------------------------------------------
-- Event handling
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

myEventHook = swallowEventHook ( className =? "kitty" ) ( return True )

------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

myLogHook = return ()

------------------------------------------------------------------------
-- Applications

autostart = do
    spawnOnce "/home/thyriaen/.config/xmonad/hooks/startup.sh"
    spawn "polybar left"
    spawn "polybar middle"
    spawn "polybar right"
    -- Cannot remember for which windows this was needed: 
    -- spawnOnce "picom --shadow-exclude='override_redirect = true && !WM_NAME:s'"
    spawnOnce "picom"
    spawnOnce "redshift -m vidmode -l 48.4:14.4 -t 6500:3000"
    spawnOnce "synology-drive start"
    spawnOnce "keepassxc %f"
    spawnOnce signal
    --spawn "tint2 -c /home/thyriaen/.config/tint2/launchy.tint2rc"

------------------------------------------------------------------------
-- Key bindings

rofi = "rofi -show drun"
screenshot = "maim -s -u -o -b 3 | tee ~/Pictures/screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i"
superhuman = "google-chrome --new-window --class=superhuman --app=https://mail.superhuman.com/ --user-data-dir=/home/thyriaen/.webapps/superhuman %U"
signal = "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=signal-desktop --file-forwarding org.signal.Signal --use-tray-icon @@u %U @@"

scratchpads =
    [ NS "nnn" "kitty --class=nnn sh -c \"nnn -d -P p\"" 
        ( className =? "nnn" ) 
        ( customFloating $ floatingNNN )
    -- , 
    ]
  where        
    -- floatingNNN     = W.RationalRect (1 % 8) (1 % 12) (3 % 4) (5 % 6)
    floatingNNN     = W.RationalRect (1 % 4) (1 % 12) (1 % 2) (5 % 6) -- DESKTOP

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 

    [ (( modm, xK_t ), spawn $ XMonad.terminal conf)
    , (( modm, xK_space ), spawn rofi )
    , (( modm, xK_b ), spawn "google-chrome")
    , (( modm, xK_p ), spawn screenshot )
    , (( modm, xK_e ), spawn superhuman )
    -- , (( modm, xK_v ), spawn "xterm" )
    , (( modm, xK_c ), spawn "mate-calc")
    -- , (( modm, xK_f ), spawn "nemo" )
    , (( modm, xK_f ), namedScratchpadAction scratchpads "nnn" )

    , ((modm , xK_q     ), kill)
    , ((modm,               xK_Return ), sendMessage NextLayout)
    , ((0, xF86XK_MonBrightnessUp) ,   spawn "light -A 5")
    , ((0, xF86XK_MonBrightnessDown) , spawn "light -U 5") 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp  )

    , ((modm,               xK_s     ), sendMessage (Move L))
    , ((modm,               xK_d     ), sendMessage (Move R))

    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_g     ), withFocused $ windows . W.sink)

    , ((modm .|. shiftMask, xK_q     ), spawn "monad --recompile; xmonad --restart")

    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_6]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
