#!/bin/sh

if type "apm" > /dev/null; then
  packages=(
    autoclose-html
    color-picker
    project-manager
    Sublime-Style-Column-Selection
    unity-ui
    vim-mode
  )
  apm install ${packages[@]}
fi
