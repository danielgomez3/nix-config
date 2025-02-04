{pkgs,lib,...}:
{
  myHomeManager = {
    gui-apps.enable = lib.mkDefault true; 
    cli-apps.enable = lib.mkDefault true; 
    sway-desktop.enable = lib.mkDefault true; 
    speech-recognition.enable = lib.mkDefault true;
  }; 
}
