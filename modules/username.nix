# modules/username.nix
{ config, pkgs, lib, ... }:

{
  options.myConfig.username = lib.mkOption {
    type = lib.types.str;
    default = "error"; # optional default
    description = "The username for this specific machine.";
  };
}

