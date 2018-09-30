# Setting $PATH.
export PATH=$HOME/.yarn/bin:$PATH

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
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Spaceship theme settings
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Sources
source $ZSH/oh-my-zsh.sh