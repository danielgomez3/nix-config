# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!
{
  pkgs,
  inputs,
  config,
  host,
  ...
}: let
  username = config.myVars.username;
in {
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "desktop"; # Specific hostname for this machine
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "desktop";
  };

  # for gnome desktop on my desktop graphics
  services.xserver.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];

  myNixOS = {
    bundles.base-system.enable = true;
    bundles.desktop-environment.enable = true;
    bundles.embedded-dev-environment.enable = true;
    bundles.desktop-gaming.enable = true;
    virtualization.enable = false;
    yubikey-functionality.enable = true;
    discord.enable = true;
  };
  home-manager.users.${username}.myHomeManager = {
    bundles.desktop-environment.enable = true;
    bundles.coding-environment.enable = true;
  };

  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;
  services = {
    syncthing.guiAddress = "127.0.0.1:8385";
  };
}
