{
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    window-manager.enable = true;
    gui-apps.enable = true;  
    greeter.enable = true;
    printing.enable = true;
    sound.enable = true;
    suspend-and-hibernate.enable = true;
  };

}
