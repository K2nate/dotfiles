.PHONY: homebrew
homebrew:
	brew bundle --verbose --cleanup --file="./Brewfile"
	brew cleanup --verbose

.PHONY: macos
macos:
	bash ./scripts/setup-macos.sh