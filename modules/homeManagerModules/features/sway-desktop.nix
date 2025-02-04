{pkgs,lib,...}:
{
  myHomeManager = {
    sway.enable = true;
    swayidle.enable = true;
    dunst.enable = true;  # Wayland notifications
    wayland-pipewire-idle-inhibit.enable = true;
  }; 
}

