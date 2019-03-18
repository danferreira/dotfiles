install-xorg:
	pacman -S xorg-server xorg-xbacklight xorg-xrandr

install-utils:
	pacman -S neovim htop tar unrar unzip xarchiver stow

install-zsh:
	pacman -S zsh zsh-completions
	chsh -s /bin/zsh

install-terminal:
	pacman -S alacritty

install-oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	#install Spaceship Prompt theme
	git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

install-yay:
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay

install-xmonad:
	yay -S stack-static wireless_tools
	stack setup
	mkdir ~/.xmonad
	cd ~/.xmonad
	git clone "https://github.com/xmonad/xmonad" xmonad-git
	git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
	git clone "https://github.com/jaor/xmobar" xmobar-git
	stack init
	stack install --flag xmobar:all_extensions

install-display-manager:
	yay -S lightdm lightdm-gtk-greeter light-locker

install-work-tools:
	yay -S code docker docker-compose elixir http-prompt openfortigui peek
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

install-fonts:
	yay -S otf-fira-code otf-font-awesome ttf-dejavu ttf-emojione ttf-google-fonts-git ttf-ms-fonts ttf-symbola

install-visual:
	yay -S compton dunst dzen2 libnotify maim neofetch rofi stow xclip

install-usefull:
	yay -S firefox google-chrome iw pcmanfm powertop reflector subliminal youtube-dl

install-video:
	yay -S optimus-manager xf86-video-intel

install-audio:
	yay -S alsa-utils pavucontrol pulseaudio pulseaudio-alsa

install-media:
	yay -S vlc pavucontrol
