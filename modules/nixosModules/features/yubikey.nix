{pkgs,...}:{

  services.udev.packages =  with pkgs; [
    yubikey-personalization
    pam_u2f  
  ];

  environment.systemPackages = with pkgs; [
    pam_u2f  
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
