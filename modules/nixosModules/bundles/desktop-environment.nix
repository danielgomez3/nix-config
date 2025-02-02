{
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    gui-apps.enable = true;  
    window-manager.enable = true;
    display-manager.enable = true;
    printing.enable = true;
    sound.enable = true;
    logind.enable = false;
  };

}
