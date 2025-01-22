{pkgs,lib,...}:
{
  myHomeManager = {
    sway.enable = true;
    swayidle.enable = true;
    wayland-pipewire-idle-inhibit.enable = true;
  }; 
}

