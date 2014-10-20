#!/usr/bin/env bash
#
# Bootstrap installs things

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd)

source $DOTFILES_ROOT/common.sh

set -e

if [[ $USER=="adamboulware" ]]; then
  source $DOTFILES_ROOT/zsh/zsh_setup.sh
  source $DOTFILES_ROOT/homebrew/homebrew_setup.sh
  source $DOTFILES_ROOT/osx/osx_tweaks.sh

  link_file "$DOTFILES_ROOT/system/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
  link_file "$DOTFILES_ROOT/system/env.zsh" "$HOME/.oh-my-zsh/custom/env.zsh"
  link_file "$DOTFILES_ROOT/system/path.zsh" "$HOME/.oh-my-zsh/custom/path.zsh"

  link_file "$DOTFILES_ROOT/zsh/ohmyzsh.zsh" "$HOME/.oh-my-zsh/custom/ohmyzsh.zsh"

  link_file "$DOTFILES_ROOT/zsh/adambware.zsh-theme" "$HOME/.oh-my-zsh/custom/adambware.zsh-theme"
else
  source $DOTFILES_ROOT/homebrew/homebrew_setup_ryan.sh
fi
