#!/bin/sh

pushd ~/dotfiles/
home-manager switch --flake .#GAMER-PC
cp users/tntman/config/awesome/* ~/.config/awesome -r # temp fix for issue
systemctl --user restart picom.service
popd
