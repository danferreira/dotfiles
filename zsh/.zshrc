# Setting $PATH.
export PATH=$HOME/.local/bin:$HOME/.yarn/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="spaceship"

# Use case-sensitive completion.
CASE_SENSITIVE="false"

# Use hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Disable marking untracked files.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Oh-my-zsh plugins. (~/.oh-my-zsh/plugins/* or ~/.oh-my-zsh/custom/plugins/)
plugins=(
  git
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=100

# Spaceship theme settings
SPACESHIP_PROMPT_ORDER=(
   	time
  	user
  	dir
  	git
    elm
  	exec_time
  	line_sep
  	battery
  	exit_code
  	char
)

# Sources
source $ZSH/oh-my-zsh.sh

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
