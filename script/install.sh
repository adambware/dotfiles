#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

dotfiles_dir=`pwd`

# find the installers and run them iteratively
find $dotfiles_dir -name install.sh -print
