# core-system.nix
# NOTE: EVERY device should inherit this, without exception.
# Headless servers, all secure devices. Secure devices SHOULD NOT inherit base-system.nix
{
  config,
  pkgs,
  ...
}: {
  # Select internationalisation properties.
  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
    "git+ssh://git@github.com/" # My secrets repository
    "git+ssh://git@github.com/danielgomez3/nix-secrets.git"
  ];

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
    users.${config.myVars.username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      wget
      curl
      pigz
      nftables
      iptables
      unixtools.netstat
      btop
      toybox
      busybox # telnet,
      openssl
      dig # check dns records
      mailutils # send mail via 'mail'
      sysz
      wireguard-tools
    ];
  };
}
