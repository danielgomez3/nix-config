# core-system.nix
# EVERY device should inherit this, without exception.
# The goal is it should be architecture-agnostic!
# Headless servers, all secure devices. Secure devices SHOULD NOT inherit base-system.nix
# TODO: make a bundle?
# TODO: usueable by all machines, even remote non nix ones, for a shell?
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
in {
  myNixOS = {
    openssh.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
  };
  home-manager.users.${config.myVars.username}.myHomeManager = {
    cli-apps.enable = lib.mkDefault true;
  };

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
    # Define a user account. Don't forget to set a password with 'passwd'.
    mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
    users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
    users.${config.myVars.username} = {
      hashedPasswordFile = config.sops.secrets.user_password.path;
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    pigz
    nftables
    iptables
    unixtools.netstat
    toybox
    busybox # telnet,
    openssl
    dig # check dns records
    mailutils # send mail via 'mail'
    sysz
    wireguard-tools
    fd
    procps
    file
    efibootmgr # for forcing dual-boot in cli
    lm_sensors
    gnutar
    arp-scan # this one is sick: arp-scan --localnet
  ];
}
