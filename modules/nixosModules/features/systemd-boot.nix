{pkgs,...}:{

  myNixOS.silent-boot.enable = true;

  nix.settings.auto-optimise-store = true;  # Optimize store every build. May slow down rebuilds
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.configurationLimit = 2;
  };

}
