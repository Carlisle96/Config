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

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WindowSwallowing

import XMonad.Actions.SpawnOn
import XMonad.Util.NamedScratchpad

import Graphics.X11.ExtraTypes.XF86

import qualified Data.Map        as M
import qualified XMonad.StackSet as W


------------------------------------------------------------------------
main = xmonad $ ewmh $ docks $ defaults

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
    , workspaces         = ["1","2","3","4","5","6"]
    , manageHook         = myManageHook
    , handleEventHook    = myEventHook
    , logHook            = myLogHook
    , startupHook        = autostart }

tabConfig = def 
    { fontName = "xft:M PLUS 1:pixelsize=14:antialias=true:hinting=true"
    , activeColor = "#7652B8"
    , activeTextColor = "#E9EAEB"
    , activeBorderColor = "#27292d"
    , inactiveColor = "#18191A"
    , inactiveTextColor = "#E9EAEB"
    , inactiveBorderColor = "#27292d"
    , urgentColor = "#B85261"
    , urgentTextColor = "#E9EAEB"
    , urgentBorderColor = "#27292d"
    , decoHeight = 24 }

autostart = do
    spawn "xinput --set-prop 'pointer:Logitech G900' 165 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 3.000000"
    spawn "/home/thyriaen/.xmonad/hooks/startup.sh"
    spawn "polybar"
    spawnOn "6" signal
    -- spawn "picom"
    
------------------------------------------------------------------------
-- Layouts:

gap = spacingRaw False (Border 8 8 8 8 ) True (Border 8 8 8 8) True
tabGap = addTabs shrinkText tabConfig . gap

myLayout = ( configurableNavigation noNavigateBorders $ avoidStruts 
    ( monoTab ||| dualTab )) 
    ||| fullScr 
  where
    dualTab = tabGap $ combineTwo (TwoPane 0.03 0.5) Simplest Simplest
    monoTab = tabGap Simplest
    fullScr = noBorders Full

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.

-- Laptop
-- floatingCenter = doRectFloat (W.RationalRect   (1 % 5)  (1 % 6) (3 % 5) (2 % 3))
-- floatingCalc   = doRectFloat (W.RationalRect (41 % 48) (1 % 27) (1 % 8) (1 % 3))
-- floatingNNN    = doRectFloat (W.RationalRect   (1 % 8) (1 % 12) (3 % 4) (5 % 6))
-- 
-- myManageHook = composeAll
--     [ className =? "filepicker" --> floatingCenter
--     , className =? "KeePassXC" --> floatingCenter
--     , className =? "nnn" --> floatingNNN
--     , className =? "Xdg-desktop-portal-gtk" --> floatingCenter 
--     , className =? "Mate-calc" --> floatingCalc ]

-- Desktop
myManageHook = manageSpawn <+>  composeAll
    [ namedScratchpadManageHook scratchpads
    , className =? "filepicker" --> floatingCenter
    , className =? "KeePassXC" --> floatingKPass
    -- , className =? "nnn" --> floatingNNN 
    , className =? "Xdg-desktop-portal-gtk" --> floatingCenter 
    , className =? "Mate-calc" --> floatingCalc 
    , className =? "Nemo" --> floatingNemo ]
  where 
    floatingCenter  = doRectFloat ( W.RationalRect   (1 % 5)  (1 % 6)   (3 % 5)  (2 % 3) )
    floatingCalc    = doRectFloat ( W.RationalRect (39 % 48) (1 % 27)  (3 % 32) (5 % 18) )
    floatingKPass   = doRectFloat ( W.RationalRect (18 % 32) (9 % 18) (13 % 32) (8 % 18) )
    floatingNemo    = doRectFloat ( W.RationalRect  (1 % 32) (1 % 18) (13 % 32) (8 % 18) )


------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = swallowEventHook ( className =? "kitty" ) ( return True )

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Key bindings:

scratchpads =
    [ NS "nnn" "kitty --class=nnn sh -c \"nnn -P p\"" 
        (className =? "nnn") 
        ( customFloating $ floatingNNN )
    -- , 
    ]
  where        
    floatingNNN     = W.RationalRect (1 % 8) (1 % 12) (3 % 4) (5 % 6)


rofi = "rofi -show drun"
screenshot = "maim -s -u -o -b 3 | tee ~/Pictures/screenshots/$(date +%s).png | xclip -selection clipboard -t image/png -i"
superhuman = "google-chrome --new-window --class=superhuman --app=https://mail.superhuman.com/ --user-data-dir=/home/thyriaen/.webapps/superhuman %U"
nnn = "kitty --class=nnn sh -c \"nnn -P p\""
signal = "/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=signal-desktop --file-forwarding org.signal.Signal --use-tray-icon @@u %U @@"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 

    [ (( modm, xK_t ), spawn $ XMonad.terminal conf)
    , (( modm, xK_space ), spawn rofi )
    , (( modm, xK_b ), spawn "google-chrome")
    , (( modm, xK_p ), spawn screenshot )
    , (( modm, xK_e ), spawn superhuman )
    , (( modm, xK_c ), spawn "mate-calc")
    -- , (( modm, xK_v ), spawn nnn )
    , (( modm, xK_f ), spawn "nemo" )
    , (( modm, xK_v ), namedScratchpadAction scratchpads "nnn" )

    , ((modm , xK_q     ), kill)
    , ((modm,               xK_Return ), sendMessage NextLayout)
    , ((0, xF86XK_MonBrightnessUp) , spawn "light -A 5")
    , ((0, xF86XK_MonBrightnessDown) , spawn "light -U 5") 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Swap the focused window and the master window
    -- , ((modm,               xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    -- Push window back into tiling
    , ((modm,               xK_g     ), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    -- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    , ((modm .|. shiftMask, xK_q     ), spawn "killall polybar; killall picom; xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_6]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- ++
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
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