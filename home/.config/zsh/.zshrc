# Initialize zsh's auto-completion system
autoload -Uz compinit
zmodload -i zsh/complist
compinit

# Syntax Highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
eval "$(starship init zsh)"

# mise
eval "$(mise activate zsh)"

# Config
source "$XDG_CONFIG_HOME/zsh/scripts/config.zsh"

# Source alias files
for file in $XDG_CONFIG_HOME/zsh/aliases/*.zsh; do
    [[ -r "$file" ]] && source "$file"
done

# Source function files
for file in $XDG_CONFIG_HOME/zsh/functions/*.zsh; do
    [[ -r "$file" ]] && source "$file"
done
