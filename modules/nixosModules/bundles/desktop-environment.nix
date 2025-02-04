{
  pkgs,
  lib,
  ...
}: {

  myNixOS = {
    gui-apps.enable = lib.mkDefault true;  
    window-manager.enable = lib.mkDefault true;
    display-manager.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    sound.enable = lib.mkDefault true;
    logind.enable = lib.mkDefault false;
  };

}
