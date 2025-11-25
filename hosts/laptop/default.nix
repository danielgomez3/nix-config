# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!
{
  config,
  pkgs,
  inputs,
  host,
  lib,
  ...
}: let
  username = config.myVars.username;
in {
  myVars.username = "daniel";
  myVars.hostname = "laptop"; # Specific hostname for this machine
  myVars.isHardwareLimited = true;
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "laptop";
  };

  myNixOS = {
    bundles.base-system.enable = true;
    bundles.desktop-environment.enable = true;
    laptop-device-settings.enable = true;
    nix-software-center.enable = true;
  };
  home-manager.users.${username}.myHomeManager = {
    # chromium.enable = true;
  };
}
