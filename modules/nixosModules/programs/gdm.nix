{pkgs,lib,...}:{

  security.pam.services.gdm = {};
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

}
