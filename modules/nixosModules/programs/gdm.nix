{pkgs,lib,...}:{

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

}
