#!/bin/sh

pushd ~/dotfiles/
home-manager switch --flake .#GAMER-PC
systemctl --user restart picom.service
popd
