# Create directory and cd into it
mkcd() {
    local dir="${1:?Error: directory name required}"
    mkdir -p "$dir" && cd "$dir"
}

# Extract various archive formats
extract() {
    local archive="${1:?Error: archive path required}"
    
    if [[ ! -f "$archive" ]]; then
        echo "Error: '$archive' not found"
        return 1
    fi
    
    case "$archive" in
        *.tar.bz2)   tar xjf "$archive"     ;;
        *.tar.gz)    tar xzf "$archive"     ;;
        *.tar.xz)    tar xJf "$archive"     ;;
        *.bz2)       bunzip2 "$archive"     ;;
        *.rar)       unrar x "$archive"     ;;
        *.gz)        gunzip "$archive"      ;;
        *.tar)       tar xf "$archive"      ;;
        *.tbz2)      tar xjf "$archive"     ;;
        *.tgz)       tar xzf "$archive"     ;;
        *.zip)       unzip "$archive"       ;;
        *.Z)         uncompress "$archive"  ;;
        *.7z)        7z x "$archive"        ;;
        *)           
            echo "Error: '$archive' - unsupported format"
            return 1
            ;;
    esac
}

# Navigate up multiple directories
up() {
    local count="${1:-1}"
    local path=""
    
    # Validate input
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "Error: argument must be a positive number"
        return 1
    fi
    
    # Build path
    for ((i=0; i<count; i++)); do
        path="../$path"
    done
    
    cd "$path" || return 1
}

# Create timestamped backup of a file
backup() {
    local file="${1:?Error: file path required}"
    
    if [[ ! -f "$file" ]]; then
        echo "Error: '$file' not found"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="${file}.${timestamp}.bak"
    
    cp -p "$file" "$backup_file" && echo "Backup created: $backup_file"
}

# fzf history
function fzf-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-history
bindkey '^r' fzf-history