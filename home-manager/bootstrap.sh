#!/bin/bash

set -e

echo "#"
echo "# Nix Install"
echo "#"
echo

sh <(curl -L https://nixos.org/nix/install)

# shellcheck source=/dev/null
. "$HOME/.nix-profile/etc/profile.d/nix.sh"

echo "#"
echo "# Add home-manager channel"
echo "#"
echo

nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

echo "#"
echo "# Install home-manager"
echo "#"
echo
nix-shell '<home-manager>' -A install

echo "#"
echo "# Apply our home-manager config"
echo "#"
echo
home-manager -f home.nix switch

SHELL_PATH="$(which zsh)"
echo "#"
echo "# Update our shell to $SHELL_PATH"
echo "#"
echo

if ! grep -qxF "$SHELL_PATH" /etc/shells; then
  echo "$SHELL_PATH" | sudo tee -a /etc/shells
  chsh -s "$SHELL_PATH"
fi

