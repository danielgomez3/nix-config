{
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    window-manager.enable = true;
    gui-apps.enable = true;  
    greetd.enable = true;
    printing.enable = true;
    sound.enable = true;
  };

}
