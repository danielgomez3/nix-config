# custom-iso/default.nix
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
  myVars.username = "nixos"; # Specific username for this machine
  myVars.hostname = "custom-iso"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${config.myVars.username} = {
    description = "this is a custom iso I want used and built for everywhere, which ssh access, and ssh access to my server";
  };

  myNixOS = {
    # bundles.base-system.enable = true; # TODO doesn't work!  change systemd boot..
    core-system.enable = true;
    # bundles.desktop-environment.enable = true;
    iso-config.enable = true; # WIP
    # wifi-config.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    # transitory.enable = true;
  };

  # Donn't override minimal iso nixpkgs imp;ort!
  # users.users.root.hashedPasswordFile = "";
  # users.users.nixos.extraGroups = ["wheel"];
}
