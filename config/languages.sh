#!/usr/bin/env bash
#
# Language runtime setup via asdf
# Run: ./setup languages
#

set -euo pipefail

###############################################################################
# Configuration                                                               #
###############################################################################

PYTHON_VERSION="3.14.3"
PYTHON_PACKAGES=(ipython jupyter black flake8 pylint pytest requests pyyaml pipenv poetry)

RUBY_VERSION="3.4.9"
RUBY_GEMS=(bundler rake rails solargraph rubocop pry)

NODE_VERSION="24.14.0"
NPM_PACKAGES=(yarn typescript ts-node npm-check-updates)

###############################################################################
# asdf setup                                                                  #
###############################################################################

echo "--- asdf ---"

brew install asdf 2>/dev/null || true

# Source asdf for the current session
source "$(brew --prefix asdf)/libexec/asdf.sh"

###############################################################################
# Python                                                                      #
###############################################################################

echo "--- Python (asdf) ---"

asdf plugin add python 2>/dev/null || true

if ! asdf list python 2>/dev/null | grep -q "$PYTHON_VERSION"; then
  echo "Installing Python $PYTHON_VERSION..."
  asdf install python "$PYTHON_VERSION"
fi

asdf set --home python "$PYTHON_VERSION"
pip install --upgrade pip --quiet

for pkg in "${PYTHON_PACKAGES[@]}"; do
  pip install "$pkg" --quiet 2>/dev/null || true
done
echo "Python $PYTHON_VERSION ready."

###############################################################################
# Ruby                                                                        #
###############################################################################

echo "--- Ruby (asdf) ---"

# libyaml is required to build the psych extension
brew install libyaml 2>/dev/null || true

asdf plugin add ruby 2>/dev/null || true

if ! asdf list ruby 2>/dev/null | grep -q "$RUBY_VERSION"; then
  echo "Installing Ruby $RUBY_VERSION..."
  RUBY_CONFIGURE_OPTS="--with-libyaml-dir=$(brew --prefix libyaml)" \
    asdf install ruby "$RUBY_VERSION"
fi

asdf set --home ruby "$RUBY_VERSION"
gem update --system --quiet 2>/dev/null || true

for gem in "${RUBY_GEMS[@]}"; do
  gem install "$gem" --quiet 2>/dev/null || true
done
echo "Ruby $RUBY_VERSION ready."

###############################################################################
# Node.js                                                                     #
###############################################################################

echo "--- Node.js (asdf) ---"

asdf plugin add nodejs 2>/dev/null || true

if ! asdf list nodejs 2>/dev/null | grep -q "$NODE_VERSION"; then
  echo "Installing Node.js $NODE_VERSION..."
  asdf install nodejs "$NODE_VERSION"
fi

asdf set --home nodejs "$NODE_VERSION"

for pkg in "${NPM_PACKAGES[@]}"; do
  npm install -g "$pkg" --silent 2>/dev/null || true
done
echo "Node.js $NODE_VERSION ready."
