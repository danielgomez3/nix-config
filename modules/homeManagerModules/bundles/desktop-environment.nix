{
  pkgs,
  lib,
  ...
}: {
  myHomeManager = {
    gui-apps.enable = lib.mkDefault true;
    sway-desktop.enable = lib.mkDefault true;
    cosmic-desktop.enable = lib.mkDefault false;
    zed.enable = lib.mkDefault true;
  };
}
