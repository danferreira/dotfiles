#!/bin/sh

#Install zsh
sudo pacman -S zsh zsh-completions

#Change default shell for user
chsh -s /bin/zsh

#Install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#Install Spaceship Prompt theme
git clone https://github.com/denysdovhan/spaceship-prompt.git "~/.oh-my-zsh/custom/themes/spaceship-prompt"
ln -s "~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "~/.oh-my-zsh/custom/themes/spaceship.zsh-theme"
