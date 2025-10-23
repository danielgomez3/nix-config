# server.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: let
  username = config.myVars.username;
in {
  myVars.username = "danielgomezcoder"; # Specific username for this machine
  myVars.hostname = "hetzner-vps"; # Specific hostname for this machine

  users.users.${username} = {
    description = "danielgomezcoder's hetzner cloud vps server";
  };

  myNixOS = {
    core-system.enable = true;
    sops.enable = true;
    openssh.enable = true;
  };

  home-manager.users.${username}.myHomeManager = {
    helix.enable = true;
    git.enable = true;
    zellij.enable = true;
    zsh.enable = true;
    starship.enable = true;
    rclone.enable = true;
  };
}
