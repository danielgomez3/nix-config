{pkgs,lib,...}:
{
  myHomeManager = {
    sway.enable = true;
    swayidle.enable = true;
    # mako.enable = true;  # Wayland notifications
    dunst.enable = true;  # Wayland notifications
    wayland-pipewire-idle-inhibit.enable = true;
  }; 
}

