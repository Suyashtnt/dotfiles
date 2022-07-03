#!/bin/sh

pushd ~/dotfiles/
home-manager switch -f ./users/tntman/home.nix
systemctl --user restart picom.service
popd
