# Initialize zsh's auto-completion system
autoload -Uz compinit
zmodload -i zsh/complist
compinit

# Syntax Highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"