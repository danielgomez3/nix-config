#!/usr/bin/env bash

for dir in */; do
  for f in "./${dir%/}/disko-config.nix"; do
    mv $f "./${dir%/}/disk-config.nix"
  done
done
