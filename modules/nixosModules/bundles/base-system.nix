# base-system.nix
# NOTE: different than core-system because this only should be inherited by personal, powerful, headed or headless x86/64 machines, that are NOT darwin or etc.
# FIXME: This is insecure and casual because we implement a password login. DO NO INHERIT if you expose your server to the internet!!!
{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}: let
  hapless = import "${inputs.self.outPath}/derivations/hapless.nix" {
    inherit (pkgs) lib fetchFromGitHub;
    python3 = pkgs.python312; # or python311
  };
  username = config.myVars.username;
in {
  nixpkgs.overlays = [
    (import "${self.outPath}/overlays/hapless.nix")
  ];
  myNixOS = {
    core-system.enable = lib.mkDefault true;
    hardware-examination.enable = lib.mkDefault true;
    coding-environment.enable = lib.mkDefault true;
    avahi.enable = lib.mkDefault true;
    network-config.enable = lib.mkDefault true;
    tailscale.enable = lib.mkDefault false;
    good-repl-access.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true; # TODO change where fonts go, this could be too big
    gnupg.enable = lib.mkDefault false;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
  environment = {
    systemPackages = with pkgs; [
      hapless # This now uses the overridden version from the overlay
      cmatrix
      jmtpfs # For interfacing with my OP-1 Field.
      woeusb
      ntfs3g
      nushell
      waypipe # x11 forwarding alternative:
      age
      nix-tree
      aria2
      eza
      tldr
      tree
    ];
  };
}
