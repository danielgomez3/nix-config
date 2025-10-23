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

  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
    "git+ssh://git@github.com/" # My secrets repository
    "git+ssh://git@github.com/danielgomez3/nix-secrets.git"
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
}
