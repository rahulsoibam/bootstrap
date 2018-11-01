# Support 256 colors
export TERM="xterm-256color"
# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh
# if you want to use this, change your non-ascii font to Droid Sans Mono for Awesome
export ZSH_THEME="robbyrussell"
# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# disable autosetting terminal title.
export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.dotfiles/oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(colorize compleat dirpersist autojump git cp zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
