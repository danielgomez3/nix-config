# hosts/persistent-usb/default.nix
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
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "persistent-usb"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${config.myVars.username} = {
    description = "Disko will help deploy this config to any usb or removeable media";
  };

  myNixOS = {
    bundles.base-system.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
