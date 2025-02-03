{pkgs, lib, config, ...}:{

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
  security.pam.u2f = {
    enable = true;
    interactive = true;  # Prompt to 'insert U2F device'
    cue = true;  # 'Please touch device'
    origin = "pam://yubi";  # Don't only work for a single user
    authFile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
    config.myVars.username
    ":<KeyHandle1>,<UserKey1>,<CoseType1>,<Options1>"
    ":<KeyHandle2>,<UserKey2>,<CoseType2>,<Options2>"
  ]);
  };
  # security.pam.services = {
  #   login.u2fAuth = true;
  #   sudo.u2fAuth = true;
  # };

}
