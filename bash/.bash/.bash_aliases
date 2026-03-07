# --- Eza (replacement for ls) aliases ---
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# --- Git aliases ---
alias g="git"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
alias gco="git checkout"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias glog="git log --oneline --graph"
alias gb="git branch"
alias gm="git merge"
alias gst="git stash"
alias gstp="git stash pop"
alias nah="git reset --hard && git clean -df"

# --- Tool aliases ---
alias vim="nvim"
alias python="python3"

# --- CD aliases ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
