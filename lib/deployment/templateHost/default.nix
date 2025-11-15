# xxhostnamexx/default.nix
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
  myVars.username = "xxusernamexx"; # Specific username for this machine
  myVars.hostname = "xxhostnamexx"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${config.myVars.username} = {
    description = "xxdescriptionxx";
  };

  myNixOS = {
    bundles.base-system.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
