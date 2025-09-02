.PHONY: homebrew
homebrew:
	brew bundle --verbose --cleanup --file="./Brewfile"
	brew cleanup --verbose