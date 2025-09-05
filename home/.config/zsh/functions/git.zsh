# Git add all and commit with message
gcam() {
    local message="${1:?Error: commit message required}"
    
    git add -A && git commit -m "$message"
}

# Delete local branches that have been merged
gclean() {
    echo "Deleting merged branches..."
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    
    # Delete merged branches except main/master/develop and current
    git branch --merged | \
        grep -v -E "^\*|main|master|develop|${current_branch}" | \
        xargs -n 1 git branch -d 2>/dev/null
    
    echo "Cleanup complete"
}

# Delete local branches that are gone on remote
gbda() {
    echo "Pruning remote tracking branches..."
    git remote prune origin
    
    echo "Deleting local branches with no remote..."
    git branch -vv | \
        grep ': gone]' | \
        grep -v '\*' | \
        awk '{print $1}' | \
        xargs -n 1 git branch -d 2>/dev/null
    
    echo "Cleanup complete"
}

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

# Create GitHub Pull Request (requires GitHub CLI)
gpr() {
    if ! command -v gh &> /dev/null; then
        echo "Error: GitHub CLI (gh) not found"
        echo "Install with: brew install gh"
        return 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        echo "Error: not in a git repository"
        return 1
    fi
    
    # Push current branch if needed
    local current_branch=$(git branch --show-current)
    echo "Pushing branch '$current_branch'..."
    git push -u origin "$current_branch"
    
    # Create PR with optional title
    if [[ -n "$1" ]]; then
        gh pr create --title "$1" --fill
    else
        gh pr create --fill
    fi
}