# heztner-vps/default.nix
# NOTE: This contains all common features I want only my server to have!
# TODO: make jovian and kde-plasma into a bundle
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "living-room"; # Specific hostname for this machine
  myVars.isAMD = true;
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "danielgomezcoder's living room gaming device";
  };

  myNixOS = {
    bundles.base-system.enable = true;
    # systemd-boot.enable = true;
    jovian-nixos.enable = true;
    # kde-plasma.enable = true;
    bundles.desktop-environment.enable = true;
    retroarch.enable = true;
    network-config.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    chromium.enable = true;
  };

  # services = {
  #   lgtv = {
  #     enable = true;
  #   };
  # };
}
