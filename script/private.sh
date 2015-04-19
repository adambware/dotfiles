#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

if [ ! -n "$DOTFILES_ROOT" ]; then
  cd "$(dirname "$0")/.."
  DOTFILES_ROOT=$(pwd -P)
fi

# find the installers and run them iteratively
find $DOTFILES_ROOT -name install.sh -print | xargs -n1 sh
