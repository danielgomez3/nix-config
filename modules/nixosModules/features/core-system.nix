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
    user-config.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true; # NOTE: this might be too big, and belong on base-system.nix
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

  nix.settings.auto-optimise-store = true; # Optimize store every build. May slow down rebuilds
  nix.settings.download-buffer-size = 9024288000; # 9 GB
  nixpkgs.config.allowUnfree = true;

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
    nmap # even better: nmap -sn <ip>/24
    procs # view processes, cpu usage, and memory. Like btop and ps aux had a baby
    uutils-coreutils-noprefix # updated version of 'dd' with progress param.
    grc # colorize can cmd: grc nmap
    gptfdisk
    direnv
    just
  ];
}
