# hosts/custom-kexec-host/default.nix
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
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "custom-kexec-host"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "host config for kexec image to adopt and use";
  };

  myNixOS = {
    # bundles.pc-boot.enable = true;
    bundles.base-system.enable = true;
    server-with-lid.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
