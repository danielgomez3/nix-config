# iso-config.nix
# TODO
#   users.users.nixos = lib.mkForce {}; # Completely override/remove the nixos user
{inputs, ...}: {
  system.stateVersion = "25.11";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
}
