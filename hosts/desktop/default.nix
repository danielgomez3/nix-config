# hosts/desktop.nix
# NOTE: This contains all common features I want only my desktop to have!
{
  pkgs,
  inputs,
  config,
  host,
  ...
}: let
  username = config.myVars.username;
  # cfg = config.home-manager.users.${username}.myHomeManager;
in {
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "desktop"; # Specific hostname for this machine
  myVars.isAMD = true;
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "desktop";
  };

  # for gnome desktop on my desktop graphics
  myNixOS = {
    bundles.base-system.enable = true;
    bundles.desktop-environment.enable = true;
    bundles.embedded-dev-environment.enable = true;
    bundles.desktop-gaming.enable = true;
    amd-support.enable = true;
    virtualization.enable = false;
    yubikey-functionality.enable = true;
    discord.enable = true;
    rdp-client-gnome.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    jambi.enable = true;
  };

  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;
  services = {
    syncthing.guiAddress = "127.0.0.1:8385";
  };
}
