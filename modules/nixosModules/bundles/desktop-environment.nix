{
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    gui-apps.enable = lib.mkDefault true;
    music.enable = lib.mkDefault true;
    gnome.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    allow-sleep-then-hibernate.enable = lib.mkDefault false;
  };
}
