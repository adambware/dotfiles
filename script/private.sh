#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

echo $DOTFILES_ROOT

# find the installers and run them iteratively
find $DOTFILES_ROOT -name install.sh -print | xargs -n1 sh
