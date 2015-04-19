#!/bin/sh

if [ ! -d "$HOME/.vim/" ]; then
  mkdir $HOME/.vim
fi
if [ ! -d "$HOME/.vim/backups" ]; then
  mkdir $HOME/.vim/backups
fi
if [ ! -d "$HOME/.vim/swaps" ]; then
  mkdir $HOME/.vim/swaps
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
/bin/cp -Rf $DIR/autoload/ $HOME/.vim/autoload
/bin/cp -Rf $DIR/bitmaps/ $HOME/.vim/bitmaps
/bin/cp -Rf $DIR/colors/ $HOME/.vim/colors
