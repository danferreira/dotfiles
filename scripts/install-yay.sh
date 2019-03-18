#!/bin/sh

#install yay
git clone https://aur.archlinux.org/yay.git yay-tmp
cd yay-tmp
makepkg -si
cd ..
rm -rf yay-tmp