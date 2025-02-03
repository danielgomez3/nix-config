{pkgs,...}:{

  services.udev.packages =  with pkgs; [
  yubikey-personalization
  pam_u2f  # To generate public key
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

}
