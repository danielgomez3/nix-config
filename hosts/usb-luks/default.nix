# hosts/usb-luks/default.nix
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
  myVars.hostname = "usb-luks"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "persistent usb device with fde";
  };

  myNixOS = {
    bundles.pc-boot.enable = true;
    bundles.base-system.enable = true;
    bundles.desktop-environment.enable = true;
    # fde-config.enable = true;
    # zram.enable = true;
    installer-usb-config.enable = true;
    # laptop-device-settings.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  # };
}
