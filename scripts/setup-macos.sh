#!/bin/bash

# -C          : Prevent overwriting files with output redirection
# -e          : Exit the script if any command returns a non-zero status
# -u          : Exit the script if an undefined variable is used
# -o pipefail : Change pipeline exit status to the last non-zero exit
#               code in the pipeline, or zero if all commands succeed
# -x          : (Optional) Enable command tracing for easier debugging
set -Ceuo pipefail

# ----------------------------------------------------------------
# Utils
# ----------------------------------------------------------------
request_admin_privileges() {
  if [ "${CI:-false}" = "true" ]; then
    return
  fi

  echo -e "- 👨🏻‍🚀 Please enter your password to grant sudo access for this operation"
  sudo -v

  # Temporarily increase sudo's timeout until the process has finished
  (
    while true; do
      sudo -n true
      sleep 60
      kill -0 "$$" || exit
    done
  ) 2>/dev/null &
}

request_admin_privileges

# ----------------------------------------------------------------
# MacOS setup
# ----------------------------------------------------------------
echo "💻 Initializing MacOS setup..."

# ----------------------------------------------------------------
# NSGlobalDomain(General)
# ----------------------------------------------------------------
echo "- 🐤 NSGlobalDomain(General)"

# Dark Mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Show all file extensions in the Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ----------------------------------------------------------------
# Finder
# ----------------------------------------------------------------
echo "- 🗂 Finder" # killall Finder

# Set the default finder view style to icon view
defaults write com.apple.Finder FXPreferredViewStyle -string "icnv"

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Display the status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Display the path bar
defaults write com.apple.finder ShowPathbar -bool true

# ----------------------------------------------------------------
# Dock
# ----------------------------------------------------------------
echo "- 🚢 Dock" # killall Dock

# Autohides the Dock. You can toggle the Dock using ⌥ + ⌘ +d.
defaults write com.apple.dock autohide -bool true

# disable magnification
defaults write com.apple.dock magnification -bool false

# ----------------------------------------------------------------
# Menu bar
# ----------------------------------------------------------------
echo "- 🕹 Menu bar" # killall SystemUIServer

# This setting configures the time and date format for the menubar digital clock
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  h:mm a"

# Time format 12 hour time: AM/PM
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true

# ----------------------------------------------------------------
# Control Center
# ----------------------------------------------------------------
echo "- 🪁 Control Center"

# Hide Spotlight
defaults write com.apple.controlcenter "NSStatusItem Visible Item-0" -bool false

# Hide Do Not Disturb
defaults write com.apple.controlcenter "NSStatusItem Visible DoNotDisturb" -bool false

# ----------------------------------------------------------------
# Keyboard
# ----------------------------------------------------------------
echo "- ⌨️ Keyboard"

# Set key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Set delay until repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable ⌃ + Space for "Select the previous input source"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'

# Disable ⌃ + ⌥ + Space for "Select next source in input menu"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><false/></dict>'

# Disable ⌘ + Space for "Show Spotlight search"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'

# Disable ⌥ + ⌘ + Space for "Show Finder search window"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '<dict><key>enabled</key><false/></dict>'

# ----------------------------------------------------------------
# Mouse & Trackpad
# ----------------------------------------------------------------
echo "- 🖱️ Mouse & 🖥️ Trackpad"

# Set mouse speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float "2"

# Set trackpad speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float "2"

# ----------------------------------------------------------------
# Killall
# ----------------------------------------------------------------
echo "- 👼 Killall..."

killall Finder
killall Dock
killall SystemUIServer

echo "💻 MacOS setup is complete 🎉"
