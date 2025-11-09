# heztner-vps/default.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  myVars.username = "gamer"; # Specific username for this machine
  myVars.hostname = "living-room"; # Specific hostname for this machine
  myVars.isAMD = true;
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "danielgomezcoder's living room gaming device";
  };

  myNixOS = {
    core-system.enable = true;
    jovian-nixos.enable = true;
    retroarch.enable = true;
  };
}
