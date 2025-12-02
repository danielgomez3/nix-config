# desktop-environment.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    gui-apps.enable = lib.mkDefault true;
    music.enable = lib.mkDefault true;
    gnome.enable = lib.mkDefault true;
    cosmic-desktop.enable = lib.mkDefault false;
    printing.enable = lib.mkDefault true;
    allow-sleep-then-hibernate.enable = lib.mkDefault false;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    bundles.desktop-environment.enable = true;
  };
}
