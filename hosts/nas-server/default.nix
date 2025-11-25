# nas-server/default.nix
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
  myVars.hostname = "nas-server"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${config.myVars.username} = {
    description = "basic nas server on thinkpad, no RAID";
  };

  myNixOS = {
    bundles.pc-boot.enable = true;
    bundles.base-system.enable = true;
    server-with-lid.enable = true;
    gnupg.enable = false;
  };
  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
