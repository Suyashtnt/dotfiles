#!/bin/sh

pushd ~/dotfiles
nix flake update
./apply-system.sh
popd
