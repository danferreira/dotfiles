install-default:
	pacman -Syu neovim htop intel-ucode tar unrar unzip xarchiver xorg-server xorg-xbacklight xorg-xrandr zsh zsh-completions

install-xmonad:
	yay -Syu stack-static wireless_tools
	stack setup
	mkdir ~/.xmonad
	cd ~/.xmonad
	git clone "https://github.com/xmonad/xmonad" xmonad-git
	git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
	git clone "https://github.com/jaor/xmobar" xmobar-git
	stack init
	stack install --flag xmobar:all_extensions
	
install-yay:
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay

install-work-tools:
	yay -Syu code docker docker-compose elixir http-prompt openfortigui peek
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash


install-fonts:
	yay -Syu otf-fira-code otf-font-awesome ttf-dejavu ttf-emojione ttf-google-fonts-git ttf-ms-fonts ttf-symbola

install-visual:
	yay -Syu compton dunst dzen2 gsimplecal libnotify maim neofetch rofi stow xclip

install-usefull:
	yay -Syu firefox google-chrome iw pcmanfm powertop reflector subliminal transmission-gtk youtube-dl

install-video:
	yay -Syu optimus-manager xf86-video-intel

install-audio:
	yay -Syu alsa-utils pavucontrol pulseaudio pulseaudio-alsa

install-media:
	yay -Syu vlc pavucontrol

install-display-manager:
	yay -Syu lightdm lightdm-gtk-greeter light-locker

install-oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	#install a theme
	git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
