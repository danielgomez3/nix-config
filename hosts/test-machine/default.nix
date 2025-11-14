# test-machine/default.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  imports = [
  ];
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "test-machine"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "this is an underpowered device to use for testing";
  };

  myNixOS = {
    core-system.enable = true;
    systemd-boot.enable = true;
    server-with-lid.enable = true;
    tailscale.enable = false;
  };
}
