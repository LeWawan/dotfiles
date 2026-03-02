# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# source ~/.local/share/omarchy/default/bash/rc

source ~/.bash/.bash_envs
source ~/.bash/.bash_shell
source ~/.bash/.bash_aliases
source ~/.bash/.bash_init
source ~/.bash/.bash_personal

bind -x '"\C-f": tmux-sessionizer'
bind -f ~/.bash/.bash_inputrc

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"


# --- Sourcing personal bash files ---
source ~/.bash_personal
