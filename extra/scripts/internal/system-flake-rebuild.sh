#!/usr/bin/env bash
# NOTE: we can rebuild any system host! Or default is our own.

if [ ! -z $1 ]; then
  export HOST=$1
else
  export HOST=$(hostname)
fi

sudo nixos-rebuild --impure --flake .#$HOST switch
