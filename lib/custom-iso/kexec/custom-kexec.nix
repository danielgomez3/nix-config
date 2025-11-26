# custom-kexec.nix
# To run:
# https://github.com/nix-community/nixos-generators
# nix run github:nix-community/nixos-generators -- -f kexec -c custom-kexec.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Add your lid switch configuration
  # TODO: reference same settings as system.nix for pxe boot
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "custom-kexec"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  environment.systemPackages = [pkgs.networkmanager];

  # Not needed, nixos-anywhere already gives out your key
  # users.users.root.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAfIEr/ppknhpMfpGAMvMnm8bWQjB57KPy72qgUDz8u danielgomez3@server"
  # ];

  system.stateVersion = config.system.nixos.release;

  networking.networkmanager.enable = true;
  hardware.enableRedistributableFirmware = true;
  # networking.wireless = {
  #   enable = true;
  #   userControlled.enable = true;
  # };
}
