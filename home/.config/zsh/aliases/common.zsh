# ls aliases
if command -v eza > /dev/null 2>&1; then
  alias ls="eza --group-directories-first"
  alias ll="eza --group-directories-first --all --long --header --git"
fi

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Shortcuts
alias h='history'
alias c='clear'
alias e='echo'

# Directory listing
alias tree='tree -C'