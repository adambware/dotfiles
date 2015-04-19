#!/bin/sh

if [[ -d "~/.vim/" ]]
then
  if [[ ! -d "~/shtest/" ]]
  then
    mkdir ~/shtest
  fi
  cp -R ./autoload ~/shtest/.vim/autoload
  cp -R ./bitmaps ~/shtest/.vim/bitmaps
  cp -R ./colors ~/shtest/.vim/colors
fi
