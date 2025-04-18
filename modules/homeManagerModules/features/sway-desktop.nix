{pkgs,lib,...}:
{
  myHomeManager = {
    sway.enable = false;
    swayidle.enable = false;
    dunst.enable = false;  # Wayland notifications
    wayland-pipewire-idle-inhibit.enable = false;
  }; 
}

