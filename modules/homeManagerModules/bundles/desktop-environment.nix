{pkgs,lib,...}:
{
  myHomeManager = {
    gui-apps.enable = true; 
    cli-apps.enable = true; 
    sway.enable = true;
    swayidle.enable = true;
    # wayland-pipewire-idle-inhibit.enable = true;
  }; 
}
