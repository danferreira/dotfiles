import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           System.Exit
import           XMonad.Config.Desktop
import           Graphics.X11.ExtraTypes.XF86

import           XMonad.Layout.Spacing
import           XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet               as W
import qualified Data.Map                      as M
import           Data.Monoid

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig

myConfig = desktopConfig { modMask            = mod4Mask
                         , borderWidth        = myBorderWidth
                         , normalBorderColor  = myNormalBorderColor
                         , focusedBorderColor = myFocusedBorderColor
                         , terminal           = "termite"
                         , manageHook         = myManageHook
                         , layoutHook         = myLayoutHook
                         , handleEventHook    = myEventHook
                         , workspaces         = myWorkspaces
                         , keys               = myKeys
                         }


-- Visual
myBorderWidth = 3
myNormalBorderColor = "#c5c8c6"
myFocusedBorderColor = "#F7486F"

myWorkspaces = ["\xf268", "\xf121", "\xf120", "\xf008", "\xf07b", "\xf3ed"]

myLayoutHook = spacing 10 $ avoidStruts $ layoutHook desktopConfig

myManageHook = composeAll
  [ className =? "Google-chrome" --> doShift (myWorkspaces !! 0)
  , className =? "code" --> doShift (myWorkspaces !! 1)
  , className =? "mpv" --> doShift (myWorkspaces !! 3) <+> doFloat
  , className =? "openfortiGUI" --> doShift (myWorkspaces !! 5)
  , className =? "Peek" --> doFloat
  , isDialog --> doCenterFloat
  , manageDocks
  , manageHook def
  ]

myEventHook = fullscreenEventHook <+> removeBordersEventHook

-- Keyboard shortcuts
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $  [ (-- launch a terminal
           (modMask, xK_Return)
         , spawn $ XMonad.terminal conf
         )
       , ( (modMask, xK_d)
         , spawn " ~/.config/rofi/scripts/drun"
         )
         -- screenshot
       , ((0, xK_Print), spawn "maim | xclip -select c -t image/png")
       , ( (modMask, xK_Print)
         , spawn
           "maim -i $(xdotool getactivewindow) | xclip -select c -t image/png"
         )
       , ( (modMask .|. shiftMask, xK_Print)
         , spawn "maim -s | xclip -select c -t image/png"
         )
    -- multimedia
       , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 2%+")
       , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 2%-")
       , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
       , ((0, xF86XK_MonBrightnessUp) , spawn "xbacklight -inc 10")
       , ( (0, xF86XK_MonBrightnessDown)
         , spawn "xbacklight -dec 10"
         )
     -- Swap the focused window and the master window
       , ( (modMask .|. shiftMask, xK_Return)
         , windows W.swapMaster
         )
     -- close focused window
       , ( (modMask, xK_q)
         , kill
         )
         --  Reset the layouts on the current workspace to default
       , ( (modMask .|. shiftMask, xK_space)
         , setLayout $ XMonad.layoutHook conf
         )

    -- Push window back into tiling
       , ( (modMask, xK_t)
         , withFocused $ windows . W.sink
         )

     -- Restart xmonad
       , ( (modMask .|. shiftMask, xK_r)
         , spawn "xmonad --recompile; xmonad --restart"
         )

     -- Quit xmonad
       , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
       ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
       [ ((m .|. modMask, k), windows $ f i)
       | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]


myPP = xmobarPP { ppOrder           = \(ws : l : t : _) -> [ws]
                , ppCurrent         = xmobarColor "#F7296D" ""
                , ppHidden          = xmobarColor "#c5c8c6" ""
                , ppHiddenNoWindows = xmobarColor "#373b41" ""
                , ppUrgent          = xmobarColor "#198844" ""
                , ppLayout          = xmobarColor "#c5c8c6" ""
                }

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

removeBordersEventHook :: Event -> X All
removeBordersEventHook ev = do
  whenX (className =? "mpv" `runQuery` w) $ withDisplay $ \d ->
    io $ setWindowBorderWidth d w 0
  return (All True)
  where w = ev_window ev
