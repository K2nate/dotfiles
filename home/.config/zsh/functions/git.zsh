# Undo last commit (keep changes)
gundo() {
    local mode="${1:-soft}"

    case "$mode" in
        soft)
            git reset --soft HEAD~1
            echo "Last commit undone (changes kept in staging)"
            ;;
        mixed)
            git reset --mixed HEAD~1
            echo "Last commit undone (changes kept unstaged)"
            ;;
        hard)
            echo -n "Warning: This will discard all changes. Continue? [y/N] "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                git reset --hard HEAD~1
                echo "Last commit and changes discarded"
            else
                echo "Cancelled"
                return 1
            fi
            ;;
        *)
            echo "Usage: gundo [soft|mixed|hard]"
            echo "  soft:  Keep changes staged (default)"
            echo "  mixed: Keep changes unstaged"
            echo "  hard:  Discard all changes"
            return 1
            ;;
    esac
}

# fzf ghq
function fzf-ghq() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*" --reverse)
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N fzf-ghq
bindkey '^g' fzf-ghq
