{
  config,
  pkgs,
  ...
}: {
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
    users.root = {
      hashedPasswordFile = config.sops.secrets.user_password.path;
    };

    users.${config.myVars.username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.user_password.path; # Shoutout to sops baby.
      # password = "123";
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = config.sops.secrets.github_token.path;
    #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
    # };
    systemPackages = with pkgs; [
      # linux linux-firmware
      efibootmgr # for forcing dual-boot in cli
      lm_sensors
      cmatrix
      vim
      jmtpfs # For interfacing with my OP-1 Field.
      git
      wget
      curl
      pigz
      woeusb
      ntfs3g
      iptables
      nftables
      file
      toybox
      waypipe # x11 forwarding alternative:
      # Security
      age
    ];
  };
}
