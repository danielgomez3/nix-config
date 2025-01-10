# modules/username.nix
{ config, pkgs, lib, ... }:

{
  options.myVars.username = lib.mkOption {
    type = lib.types.str;
    default = "error"; # optional default
    description = "The username for this specific machine.";
  };
}

