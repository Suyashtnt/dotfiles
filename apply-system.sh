#!/bin/sh

pushd ~/dotfiles
sudo nixos-rebuild switch --flake .#
systemctl --user restart emacs.service
popd
