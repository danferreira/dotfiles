#!/bin/sh

yay -S stack-static wireless_tools
stack setup
mkdir ~/.xmonad
cd ~/.xmonad
git clone "https://github.com/xmonad/xmonad" xmonad-git
git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
git clone "https://github.com/jaor/xmobar" xmobar-git
stack init
stack install --flag xmobar:all_extensions