{-# LANGUAGE NoMonomorphismRestriction #-}
import XMonad

-- import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.TrackFloating
import XMonad.Layout.Combo
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.CenteredIfSingle
import XMonad.Layout.Reflect

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.WindowSwallowing

import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.SpawnOnce

import XMonad.Actions.SpawnOn

import Graphics.X11.ExtraTypes.XF86
import Data.Ratio
import Data.Maybe
import qualified Data.Map        as M
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
-- General Setup

main = xmonad 
  $ addEwmhWorkspaceSort (pure myFilter) 
  $ ewmh 
  $ docks 
  $ defaults
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
  , workspaces         = myWorkspaces
  , manageHook         = myManageHook
  , handleEventHook    = myEventHook
  , logHook            = myLogHook
  , startupHook        = autostart }

myWorkspaces = ["\61728", "\60188", "\60043", "\61508", "\984479", "\61670"]

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

autostart = do
  spawnOnce "/home/thyriaen/.config/xmonad/hooks/startup.sh"
  spawnOnce "/home/thyriaen/.config/xmonad/hooks/tint.sh"
  spawnOnce "picom"
  spawnOnce "redshift"
  spawnOnce "synology-drive start"
  spawnOnce "keepassxc %f"
  spawnOnce signal
  spawnOnce "flatpak run com.discordapp.Discord"

------------------------------------------------------------------------
-- Layouts

myLayout = ( lessBorders OnlyScreenFloat 
  $ configurableNavigation noNavigateBorders 
  $ avoidStruts
  $ trackFloating 
  $ spacingRaw False (Border 8 16 16 16) True (Border 8 0 0 0) True
  $ reflectHoriz
  -- sidebanks are 456 wide
  $ centeredIfSingle (158 / 215) 1 dualTab ) 
    ||| noBorders Full
  where
    dualTab =  combineTwo (TwoPane 0.05 0.4) leftTab righTab
    righTab = spacingRaw False (Border 0 0 0 8) True (Border 0 0 0 0) True 
      $ defaultTab
    leftTab = spacingRaw False (Border 0 0 8 0) True (Border 0 0 0 0) True 
      $ defaultTab
    defaultTab = tabbed shrinkText tabConfig



------------------------------------------------------------------------
-- Window rules

myManageHook = manageSpawn <+> composeAll
  [ namedScratchpadManageHook scratchpads
  , className =? "filepicker" --> floatingCenter
  , className =? "Xdg-desktop-portal-gtk" --> floatingCenter 
  , className =? "KeePassXC" --> floatingKPass
  , className =? "DesktopEditors" --> floatingCenter
  , className =? "Pavucontrol" --> floatingCenter
  , className =? "Dragon" --> floatingDragon 

  , className =? "kitty" --> myDoShift 1
  , className =? "Sublime_text" --> myDoShift 1
  , className =? "superhuman" --> myDoShift 2
  , className =? "darlehen" --> myDoShift 3
  , className =? "gdocs" --> myDoShift 3
  , className =? "datev" --> myDoShift 4
  , className =? "Google-chrome" --> myDoShift 5
  , className =? "Signal" --> myDoShift 6
  , className =? "Hexchat" --> myDoShift 6
  , className =? "Spotify" --> myDoShift 6

  , className =? "mpv" --> doFullFloat
  , className =? "MediaChips" --> myDoShift 3
  , className =? "chessx" --> myDoShift 4
  , className =? "discord" --> myDoShift 6
  , className =? "asana" --> myDoShift 6
  ]
  where 
    myDoShift x     = doShift ( myWorkspaces !! ( x - 1 ) ) 
    -- x, y, w, h
    floatingCenter  = doRectFloat 
      $ W.RationalRect (1 % 5) (1 % 6) (3 % 5) (2 % 3) 
    floatingKPass   = doRectFloat 
      $ W.RationalRect (273 % 430) (1 % 2) (145 % 430) (13 % 30) 
    floatingDragon  = doRectFloat
    -- Desktop Section: 
      $ W.RationalRect (15 % 16) (23 % 48) (1 % 48) (1 % 24)
    -- Laptop Section
    --  $ W.RationalRect (30 % 32) (23 % 48) (1 % 24) (1 % 18)
    --floatingKPass   = doRectFloat 
    --  $ W.RationalRect (18 % 32) (9 % 18) (13 % 32) (8 % 18) 

------------------------------------------------------------------------
-- Key bindings

rofi = "rofi -show drun"
screenshot = "maim -s -u -o -b 3 \
  \| tee ~/Pictures/screenshots/$(date +%s).png \
  \| xclip -selection clipboard -t image/png -i"
superhuman = "google-chrome \
  \--new-window \
  \--class=superhuman \
  \--app=https://mail.superhuman.com/ \
  \--user-data-dir=/home/thyriaen/.webapps/superhuman %U"
signal = "/usr/bin/flatpak run \
  \--branch=stable --arch=x86_64 \
  \--command=signal-desktop \
  \--file-forwarding org.signal.Signal \
  \--use-tray-icon @@u %U @@"

scratchpads =
  [ NS "nnn" "kitty --class=nnn sh -c \"nnn -d -P p\"" 
    ( className =? "nnn" ) 
    ( customFloating $ floatingNNN )
  , NS "calc" "mate-calc"
    ( className =? "Mate-calc" )
    ( customFloating $ floatingCalc )
  , NS "plan" "flatpak run org.gnome.GTG"
    ( className =? "Gtg" )
    ( customFloating $ floatingPlan ) 
  ]
  where        
    -- x, y, w, h
    -- Desktop Section:
    floatingNNN   = W.RationalRect (1 % 4) (1 % 12) (1 % 2) (5 % 6)
    floatingPlan  = W.RationalRect (3 % 8) (1 % 30) (1 % 4) (2 % 5)
    -- minimal possible width of calc 424 px 
    floatingCalc  = W.RationalRect (375 % 430) (1 % 90) (53 % 430)(5 % 18)
    -- Laptop Section:
    -- floatingNNN   = W.RationalRect (1 % 8) (1 % 12) (3 % 4) (5 % 6)
    -- floatingCalc  = W.RationalRect (79 % 96) (1 % 27)  (5 % 32) (6 % 18)

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 
  [ (( modm              , xK_q ) , kill )
  , (( modm .|. shiftMask, xK_q ) , spawn "monad --recompile; xmonad --restart" )
  , (( modm, xK_space )           , spawn rofi )
  -- Programs
  , (( modm, xK_t )               , spawn $ XMonad.terminal conf )
  , (( modm, xK_b )               , spawn "google-chrome" )
  , (( modm, xK_p )               , spawn screenshot )
  , (( modm, xK_e )               , spawn superhuman )
  -- Scratchpads
  , (( modm, xK_c )               , namedScratchpadAction scratchpads "calc" )
  , (( modm, xK_f )               , namedScratchpadAction scratchpads "nnn"  )
  , (( modm, xK_r )               , namedScratchpadAction scratchpads "plan" )
  -- Layout
  , (( modm, xK_Return )          , sendMessage NextLayout  )
  , (( modm, xK_s )               , sendMessage (Move L)    )
  , (( modm, xK_d )               , sendMessage (Move R)    )
  , (( modm, xK_l )               , sendMessage Shrink      )
  , (( modm, xK_h )               , sendMessage Expand      )
  -- Focus
  , (( modm, xK_g )                   , withFocused $ windows . W.sink )
  , (( modm              , xK_Tab )   , windows W.focusUp   )
  , (( modm .|. shiftMask, xK_Tab )   , windows W.focusDown )
  -- Special keys
  , (( 0, xF86XK_MonBrightnessUp )    
    , spawn "light -A 5 && /home/thyriaen/.config/xmonad/hooks/brightness.sh ")
  , (( 0, xF86XK_MonBrightnessDown )  
    , spawn "light -U 5 && /home/thyriaen/.config/xmonad/hooks/brightness.sh ")
  , (( 0, xF86XK_AudioMute)           , spawn "amixer set Master toggle")
  , (( 0, xF86XK_AudioLowerVolume)    
    , spawn "amixer set Master 10%- && /home/thyriaen/.config/thymonad/volume.sh")
  , (( 0, xF86XK_AudioRaiseVolume)    
    , spawn "amixer set Master 10%+ && /home/thyriaen/.config/thymonad/volume.sh")
  ]
  ++
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace Np
  [ (( m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_6]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

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