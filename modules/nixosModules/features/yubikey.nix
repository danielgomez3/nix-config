{pkgs,...}:{

  services.udev.packages =  with pkgs; [
    yubikey-personalization
    pam_u2f  # To generate public key
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Declaratively use u2f to login and sudo
  # security.pam.services = {
  #   login.u2fAuth = true;
  #   sudo.u2fAuth = true;
  # };

}
