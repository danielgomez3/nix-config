# iso-config.nix
# NOTE: this is not needed anymore
{inputs, ...}: {
  system.stateVersion = "25.11";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
}
