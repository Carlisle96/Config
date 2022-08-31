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
    , manageHook         = myManageHook
    , handleEventHook    = myEventHook
    , logHook            = myLogHook
    , startupHook        = autostart }

tabConfig = def 
    { fontName = "xft:Hasklig:pixelsize=14:antialias=true:hinting=true"
    , activeColor = "#7652B8"
    , activeTextColor = "#E9EAEB"
    , activeBorderColor = "#18191A"
    , inactiveColor = "#27292d"
    , inactiveTextColor = "#E9EAEB"
    , inactiveBorderColor = "#18191A"
    , decoHeight = 24 }

autostart = do
    spawn "/home/thyriaen/.xmonad/hooks/startup.sh"
    spawn "polybar"

------------------------------------------------------------------------
-- Layouts:

gap = spacingRaw False (Border 8 8 8 8 ) True (Border 8 8 8 8) True
tabGap = addTabs shrinkText tabConfig . gap

myLayout = ( configurableNavigation noNavigateBorders $ avoidStruts 
    ( dualTab ||| monoTab )) 
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

floatingCenter = doRectFloat ( W.RationalRect (1 % 5) (1 % 6) (3 % 5) (2 % 3) )

myManageHook = composeAll
    [ resource  =? "desktop_window" --> doIgnore 
    , className =? "filepicker" --> floatingCenter
    , className =? "KeePassXC" --> floatingCenter
    , className =? "nnn" --> floatingCenter ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Key bindings:

rofi = "rofi -show drun -theme ~/.config/polybar/scripts/rofi/launcher.rasi"
screenshot = "maim -s -u -o -b 3 | xclip -selection clipboard -t image/png -i"
superhuman = "google-chrome --new-window --class=superhuman --app=https://mail.superhuman.com/ --user-data-dir=~/.webapps/superhuman %U"

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ (( modm, xK_t ), spawn $ XMonad.terminal conf)
    , (( modm, xK_space ), spawn rofi )
    , (( modm, xK_b ), spawn "google-chrome")
    , (( modm, xK_p ), spawn screenshot )
    , (( modm, xK_e ), spawn superhuman)
    , (( modm, xK_f ), spawn "kitty --class=nnn sh -c \"nnn -P p\"" )

    , ((modm , xK_q     ), kill)
    , ((modm,               xK_Return ), sendMessage NextLayout)

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

    , ((modm .|. shiftMask, xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


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