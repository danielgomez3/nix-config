# base-system.nix
# NOTE: different than core-system because this only should be inherited by personal, powerful, headed machines.
# This is insecure and casual because we implement a password login. DO NO INHERIT if you expose your server to the internet!!!
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
    core-system.enable = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true; # FIXME: does a base system need this? Or anyone at all?
    yubikey-functionality.enable = lib.mkDefault false;
    internet.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault false;
    tailscale.enable = lib.mkDefault true;
    stylix.enable = lib.mkDefault true;
    virtualization.enable = lib.mkDefault false;
    good-repl-access.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true; # TODO change where fonts go, this could be too big
    gnupg.enable = lib.mkDefault true;
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
      efibootmgr # for forcing dual-boot in cli
      lm_sensors
      cmatrix
      jmtpfs # For interfacing with my OP-1 Field.
      woeusb
      ntfs3g
      file
      waypipe # x11 forwarding alternative:
      # Security
      age
    ];
  };
}
