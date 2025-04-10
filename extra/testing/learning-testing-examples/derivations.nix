# NOTE: failed attempt
let
  drv = (import (builtins.getFlake "nixpkgs") {}).hello;
in
  drv
