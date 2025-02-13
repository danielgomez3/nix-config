{
  pkgs,
  lib,
  ...
}: {

  myNixOS = {
    gui-apps.enable = lib.mkDefault true;  
    gnome.enable = lib.mkDefault true;
    window-manager.enable = lib.mkDefault false;
    display-manager.enable = lib.mkDefault false;
    printing.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault false;
    logind.enable = lib.mkDefault false;
  };

}
