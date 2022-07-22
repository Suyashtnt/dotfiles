#!/bin/sh

pushd ~/dotfiles/
nix flake update

sudo nixos-rebuild switch --flake .#

home-manager switch --flake .#$1
cp users/tntman/config/awesome/* ~/.config/awesome -r # temp fix for issue
systemctl --user restart picom.service
popd
