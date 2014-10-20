#!/usr/bin/env bash`

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew, a good OS X package manager ..."
    ruby <(curl -fsS https://raw.githubusercontent.com/Homebrew/install/master/install)

    append_to_zshrc '# recommended by brew doctor'
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1
    export PATH="/usr/local/bin:$PATH"
else
  fancy_echo "Homebrew already installed. Skipping ..."
fi

fancy_echo "Updating Homebrew formulas ..."
brew update
## END Homebrew


if [ $SHELL != "/usr/local/bin/zsh" ]; then
  fancy_echo "Install homebrew zsh ..."
    brew install --disable-etcdir zsh

  fancy_echo "Adding homebrew zsh to shell path"
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi

if [[ -f /etc/zshenv ]]; then
  fancy_echo "Fixing OSX zsh environment bug ..."
    sudo mv /etc/{zshenv,zshrc}
fi
## End Zsh Install


fancy_echo "Install oh-my-zsh"
  curl -L http://install.ohmyz.sh | sh
## End oh-my-zsh Install

## INSERT ADDED ZSH THEMES,ALIASES,CONFIGS
