# hosts/xxhostnamexx/default.nix
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
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  myVars.username = "xxusernamexx"; # Specific username for this machine
  myVars.hostname = "xxhostnamexx"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "xxdescriptionxx";
  };

  myNixOS = {
    bundles.pc-boot.enable = true;
    bundles.base-system.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
