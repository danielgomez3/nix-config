{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  username = config.myVars.username;
in {
  myNixOS = {
    bundles.core-system.enable = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true;
    yubikey-functionality.enable = lib.mkDefault false;
    internet.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault false;
    openssh.enable = lib.mkDefault true;
    tailscale.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
    virtualization.enable = lib.mkDefault false;
    good-repl-access.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true; # TODO change where fonts go, this could be too big
    gnupg.enable = lib.mkDefault true;
  };

  home-manager.users.${username}.myHomeManager = {
    stylix.enable = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment = {
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
