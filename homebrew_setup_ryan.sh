#!/usr/bin/env bash
#
# Sets up Homebrew, OpenSSL, Ruby and Node.js environments, 'ag' and 'wget' for
# shell convenience, and a special list of applications from brew-cask.

fancy_echo() {
  printf "\n%b\n" "$1"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="$2"

  if [[ -w "$HOME/.zshrc.local" ]]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if [ $SHELL == "/bin/bash" ]; then
    zshrc="$HOME/.bash_profile"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if (( skip_new_line )); then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}
## End Common Functions


brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      brew upgrade "$@"
    fi
  else
    brew install "$@"
  fi
}

brew_is_installed() {
  local NAME=$(brew_expand_alias "$1")

  brew list -1 | grep -Fqx "$NAME"
}

brew_is_upgradable() {
  local NAME=$(brew_expand_alias "$1")

  brew outdated --quiet "$NAME" >/dev/null
  [[ $? -ne 0 ]]
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_launchctl_restart() {
  local NAME=$(brew_expand_alias "$1")
  local DOMAIN="homebrew.mxcl.$NAME"
  local PLIST="$DOMAIN.plist"

  mkdir -p ~/Library/LaunchAgents
  ln -sfv /usr/local/opt/$NAME/$PLIST ~/Library/LaunchAgents

  if launchctl list | grep -q $DOMAIN; then
    launchctl unload ~/Library/LaunchAgents/$PLIST >/dev/null
  fi
  launchctl load ~/Library/LaunchAgents/$PLIST >/dev/null
}
## END Homebrew Functions (credit: thoughtbot/laptop)


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew, a good OS X package manager ..."
    ruby <(curl -fsS https://raw.githubusercontent.com/Homebrew/install/master/install)

    append_to_zshrc '# recommended by brew doctor'
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
    export PATH="/usr/local/bin:$PATH"
else
  fancy_echo "Homebrew already installed."
  fancy_echo "Updating Homebrew formulas ..."
  brew update
fi
## End Homebrew



fancy_echo "Upgrading and linking OpenSSL ..."
  brew_install_or_upgrade 'openssl'
  brew unlink openssl && brew link openssl --force
## End OpenSSL / Mac replacement binaries


if [[ ! -d "$HOME/.rbenv" ]]; then
  fancy_echo "Installing rbenv, to change Ruby versions ..."
    append_to_zshrc '# rbenv setup'
    append_to_zshrc 'RBENV_ROOT=/usr/local/var/rbenv' 1

    export RBENV_ROOT="/usr/local/var/rbenv"

    brew_install_or_upgrade 'rbenv'

    append_to_zshrc 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' 1
    eval "$(rbenv init -)"
fi

if [[ ! -d "$HOME/.rbenv/plugins/rbenv-gem-rehash" ]]; then
  fancy_echo "Installing rbenv-gem-rehash so the shell automatically picks up binaries after installing gems with binaries..."
    brew_install_or_upgrade 'rbenv-gem-rehash'
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
  fancy_echo "Installing ruby-build, to install Rubies ..."
    brew_install_or_upgrade 'ruby-build'
fi

ruby_version="2.1.3"

fancy_echo "Installing Ruby $ruby_version ..."
  rbenv install -s "$ruby_version"

fancy_echo "Setting $ruby_version as global default Ruby ..."
  rbenv global "$ruby_version"
  rbenv rehash

fancy_echo "Updating to latest Rubygems version ..."
  gem update --system
## End Ruby Install




fancy_echo "Installing Node.js"
  brew install node --without-npm

fancy_echo "Installing NPM"
  echo 'prefix=~/.node' >> ~/.npmrc
  curl -L https://www.npmjs.org/install.sh | sh

fancy_echo "Installing n (simple node version management)"
  npm install -g n

fancy_echo "Setting node to latest stable version via n"
  n stable
## End Node Install


fancy_echo "Installing The Silver Searcher, aka 'ag' (better than ack or grep) to search the contents of files ..."
  brew_install_or_upgrade 'the_silver_searcher'

fancy_echo "Installing wget ..."
  brew_install_or_upgrade 'wget'
# End Common Utility Install


fancy_echo "Brew Cleanup ..."
  brew cleanup

fancy_echo "Installing brew-cask ..."
  brew tap caskroom/cask
  brew_install_or_upgrade 'brew-cask'

# Custom Apps
# Add/remove from https://github.com/caskroom/homebrew-cask.git
apps=(
  alfred
  atom
  cakebrew
  codekit
  cyberduck
  diskmaker-x
  dropbox
  firefox
  google-chrome
  istat-menus
  iterm2
  jing
  opera
  skype
  spotify
  tower
  transmission
  vlc
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
  quicklook-csv
  betterzipql
  forklift
  less
  monotype-skyfonts
  sublime-text
  tilemill
  transmit
)


# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}


# Fix Alfred launching of cask apps
# May need to start Alfred before this..
fancy_echo "Open Alfred and run 'brew cask alfred link'"

fancy_echo "Done!"
