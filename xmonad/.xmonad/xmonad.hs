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
import           Control.Monad (when, join)
import           Data.Maybe (maybeToList)

import           XMonad.Util.SpawnOnce          ( spawnOnce )
import           XMonad.Layout.NoBorders        ( smartBorders )
import           XMonad.Util.EZConfig           (removeKeys, additionalKeys)
import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Layout.Spacing

import           System.IO                      ( hPutStrLn )

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ desktopConfig
    { modMask            = myModMask
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , terminal           = myTerminal
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = myLayoutHook $ layoutHook desktopConfig
    , logHook            = myLogHook xmproc <+> logHook desktopConfig
    , handleEventHook    = myEventHook <+> handleEventHook desktopConfig
    , startupHook        = myStartupHook <+> startupHook desktopConfig <+> addEWMHFullscreen
    } `additionalKeys` myAdditionalKeys
      `additionalKeys` myWorkspaceKeys

-- User stuff
myModMask = mod4Mask
myTerminal = "termite"
myBorderWidth = 0
myNormalBorderColor = "#c5c8c6"
myFocusedBorderColor = "#F7486F"
myWorkspaces = click $ ["<fn=2>\xf269</fn>", "<fn=1>\xf121</fn>", "<fn=1>\xf120</fn>", "<fn=1>\xf07b</fn>", "<fn=1>\xf3ed</fn>", "<fn=1>\xf008</fn>"]
               where click l = [ "<action=xdotool key super+" 
                               ++ show n ++ ">" ++ ws ++ "</action>" | (i,ws) <- zip [1..] l, let n = i]


-- Hooks
myLayoutHook = smartBorders 

myManageHook = composeAll
  [ className =? "Google-chrome" --> doShift (myWorkspaces !! 0)
  , className =? "Firefox" --> doShift (myWorkspaces !! 0)
  , className =? "code-oss" --> doShift (myWorkspaces !! 1)
  , className =? "Pcmanfm" --> doShift (myWorkspaces !! 3)
  , className =? "openfortiGUI" --> doShift (myWorkspaces !! 4)
  , className =? "vlc" --> doShift (myWorkspaces !! 5)
  , className =? "Peek" --> doFloat
  , isDialog --> doCenterFloat
  ]

myEventHook = fullscreenEventHook 

myLogHook proc = do
  dynamicLogWithPP xmobarPP { ppOutput          = hPutStrLn proc
                            , ppOrder           = \(ws : l : t : _) -> [ws]
                            , ppCurrent         = xmobarColor "#F7296D" ""
                            , ppHidden          = xmobarColor "#c5c8c6" ""
                            , ppHiddenNoWindows = xmobarColor "#373b41" ""
                            , ppUrgent          = xmobarColor "#198844" ""
                            , ppLayout          = xmobarColor "#c5c8c6" ""
                            }

myStartupHook = do
    spawnOnce "compton -b"
    spawnOnce "light-locker"

-- Keyboard shortcuts
myAdditionalKeys :: [((KeyMask, KeySym), X ())]
myAdditionalKeys =
    [ -- launch a terminal
      ((myModMask, xK_Return), spawn myTerminal)
      
    , -- launch ROFI 
      ((myModMask, xK_d)     , spawn "~/.config/rofi/scripts/drun")
      
    , -- screenshot
      ((0, xK_Print)       , spawn "maim | xclip -select c -t image/png")
    , ((myModMask, xK_Print),  spawn "maim -i $(xdotool getactivewindow) | xclip -select c -t image/png")
    , ((myModMask .|. shiftMask, xK_Print), spawn "maim -s | xclip -select c -t image/png")

    , -- xrandr options
      ((myModMask, xK_o), spawn ".config/rofi/scripts/display-options")
    
    , -- multimedia
      ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 2%+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 2%-")
    , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
    , ((0, xF86XK_MonBrightnessUp)       , spawn "xbacklight -inc 10")
    , ((0, xF86XK_MonBrightnessDown)     , spawn "xbacklight -dec 10")

    , -- close focused window
      ((myModMask, xK_q)                   , kill)

     , -- Swap the focused window and the master window
      ((myModMask .|. shiftMask, xK_Return), windows W.swapMaster)
      
    , -- Restart xmonad
      ((myModMask .|. shiftMask, xK_r), spawn "xmonad --recompile; xmonad --restart")
    ]

myWorkspaceKeys :: [((KeyMask, KeySym), X ())]
myWorkspaceKeys =
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
       [ ((m .|. myModMask, k), windows $ f i)
       | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]

-- see: https://github.com/xmonad/xmonad-contrib/pull/109
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
          changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]
