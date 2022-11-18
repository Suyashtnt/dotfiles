#!/bin/sh

pushd ~/dotfiles
nix flake update
./rebuild.sh
popd
