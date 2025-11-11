# heztner-vps/default.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  imports = [
  ];
  myVars.username = "xxxxxxxxxxxxxx"; # Specific username for this machine
  myVars.hostname = "xxxxxxxxxxxxxx"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "xxxxxxxxxxxxxx";
  };

  myNixOS = {
    core-system.enable = true;
  };
}
