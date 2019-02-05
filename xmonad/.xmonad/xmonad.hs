import           XMonad
import           XMonad.Hooks.DynamicLog        ( dynamicLogWithPP
                                                , PP(..)
                                                , xmobarColor
                                                , xmobarPP
                                                )
import           XMonad.Hooks.ManageDocks       ( avoidStruts
                                                , docks
                                                , manageDocks
                                                , docksEventHook
                                                )
import           XMonad.Hooks.ManageHelpers     ( doCenterFloat
                                                , isDialog
                                                )
import           System.Exit                    ( exitWith
                                                , ExitCode(..)
                                                )
import           Graphics.X11.ExtraTypes.XF86   ( xF86XK_AudioRaiseVolume
                                                , xF86XK_AudioLowerVolume
                                                , xF86XK_AudioMute
                                                , xF86XK_MonBrightnessUp
                                                , xF86XK_MonBrightnessDown
                                                )

import           XMonad.Hooks.EwmhDesktops      ( fullscreenEventHook )
import           XMonad.Config.Desktop
import qualified XMonad.StackSet               as W
import qualified Data.Map                      as M
import           Data.Monoid                    ( All(..) )
import           XMonad.Util.SpawnOnce          ( spawnOnce )
import           XMonad.Layout.NoBorders        ( smartBorders )
import           XMonad.Util.Run                ( spawnPipe )

import           System.IO                      ( hPutStrLn )

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ desktopConfig
    { modMask            = mod4Mask
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , terminal           = myTerminal
    , workspaces         = myWorkspaces
    , keys               = myKeys
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = myLayoutHook $ layoutHook desktopConfig
    , logHook            = myLogHook xmproc <+> logHook desktopConfig
    , handleEventHook    = myEventHook <+> handleEventHook desktopConfig
    , startupHook        = myStartupHook <+> startupHook desktopConfig
    }

-- User stuff
myTerminal = "termite"
myBorderWidth = 3
myNormalBorderColor = "#c5c8c6"
myFocusedBorderColor = "#F7486F"
myWorkspaces = ["<fn=2>\xf268</fn>", "<fn=1>\xf121</fn>", "<fn=1>\xf120</fn>", "<fn=1>\xf008</fn>", "<fn=1>\xf07b</fn>", "<fn=1>\xf3ed</fn>"]

-- Hooks
myLayoutHook = smartBorders

myManageHook = composeAll
  [ className =? "Google-chrome" --> doShift (myWorkspaces !! 0)
  , className =? "code-oss" --> doShift (myWorkspaces !! 1)
  , className =? "mpv" --> doShift (myWorkspaces !! 3) <+> doCenterFloat
  , className =? "Pcmanfm" --> doShift (myWorkspaces !! 4)
  , className =? "openfortiGUI" --> doShift (myWorkspaces !! 5)
  , className =? "Peek" --> doFloat
  , className =? "Yad" --> doFloat
  , isDialog --> doCenterFloat
  ]

myEventHook = fullscreenEventHook <+> removeBordersEventHook

myLogHook proc = do
  dynamicLogWithPP xmobarPP { ppOutput          = hPutStrLn proc
                            , ppOrder           = \(ws : l : t : _) -> [ws]
                            , ppCurrent         = xmobarColor "#F7296D" ""
                            , ppHidden          = xmobarColor "#c5c8c6" ""
                            , ppHiddenNoWindows = xmobarColor "#373b41" ""
                            , ppUrgent          = xmobarColor "#198844" ""
                            , ppLayout          = xmobarColor "#c5c8c6" ""
                            }

myStartupHook = spawnOnce "compton -b"

-- Keyboard shortcuts
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $  [ -- launch a terminal
         ((modMask, xK_Return), spawn $ XMonad.terminal conf)
       , -- launch ROFI 
         ((modMask, xK_d)     , spawn " ~/.config/rofi/scripts/drun")
       , -- screenshot
         ((0, xK_Print)       , spawn "maim | xclip -select c -t image/png")
       , ( (modMask, xK_Print)
         , spawn
           "maim -i $(xdotool getactivewindow) | xclip -select c -t image/png"
         )
       , ( (modMask .|. shiftMask, xK_Print)
         , spawn "maim -s | xclip -select c -t image/png"
         )
       ,
         -- multimedia
         ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 2%+")
       , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 2%-")
       , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
       , ((0, xF86XK_MonBrightnessUp)       , spawn "xbacklight -inc 10")
       , ((0, xF86XK_MonBrightnessDown)     , spawn "xbacklight -dec 10")
       , -- Swap the focused window and the master window
         ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
       , -- close focused window
         ((modMask, xK_q)                   , kill)
       ,
         -- Reset the layouts on the current workspace to default
         ((modMask .|. shiftMask, xK_space) , setLayout $ layoutHook conf)
       , -- Rotate through the available layout algorithms
         ((modMask, xK_space)               , sendMessage NextLayout)
       , -- Push window back into tiling
         ((modMask, xK_t)                   , withFocused $ windows . W.sink)
       , -- Restart xmonad
         ( (modMask .|. shiftMask, xK_r)
         , spawn "xmonad --recompile; xmonad --restart"
         )

     -- Quit xmonad
       , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
       ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
       [ ((m .|. modMask, k), windows $ f i)
       | (i, k) <- zip (workspaces conf) [xK_1 .. xK_9]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]


-- Utils
removeBordersEventHook :: Event -> X All
removeBordersEventHook ev = do
  whenX (className =? "mpv" `runQuery` w) $ withDisplay $ \d ->
    io $ setWindowBorderWidth d w 0
  return (All True)
  where w = ev_window ev
