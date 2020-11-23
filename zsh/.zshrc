## Oh-my-zsh settings

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

# Spaceship theme settings
SPACESHIP_PROMPT_ORDER=(
   	time
  	user
  	dir
  	git
  	exec_time
  	line_sep
  	battery
  	exit_code
  	char
)

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  docker
  nvm
  wd
  safe-paste
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=50

source $ZSH/oh-my-zsh.sh

## Functions

ram() {
  local sum
  local items
  local app="$1"
  if [ -z "$app" ]; then
    echo "First argument - pattern to grep from processes"
  else
    sum=0
    for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
      sum=$(($i + $sum))
    done
    sum=$(echo "scale=2; $sum / 1024.0" | bc)
    if [[ $sum != "0" ]]; then
      echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
    else
      echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
    fi
  fi
}

## Alias

alias gdm="git remote prune origin && git branch -vv | grep ': gone' | awk '{print \$1}' | xargs -r git branch -D"

## Setting $PATH.
export PATH=$(yarn global bin):$PATH
