{pkgs,...}:{

  myNixOS.silent-boot.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 6;
  };

}
