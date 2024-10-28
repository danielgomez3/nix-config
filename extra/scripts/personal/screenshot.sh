#!/usr/bin/env bash

screenshot() {
  mkdir -p ./.screenshots/
  local filename="''${1:-screenshot}"  # Default to 'screenshot' if no argument is provided
  grim -g "$(slurp)" ./.screenshots/"$filename".png
}

