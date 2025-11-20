# hosts/raw-image/default.nix
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
  myVars.hostname = "raw-image"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${config.myVars.username} = {
    description = "this is for a .raw image, to download via USB, whatever you like";
  };

  myNixOS = {
    bundles.base-system.enable = true;
    raw-image-config.enable = true;
    # bundles.desktop-environment.enable = true;
    voice-transcription.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
