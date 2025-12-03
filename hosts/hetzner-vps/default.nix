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
  imports = [
    ./firewall.nix
    ./nginx-proxy.nix
  ];
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "hetzner-vps"; # Specific hostname for this machine
  myVars.isINTEL = true;
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "danielgomezcoder's hetzner cloud vps server";
  };

  myNixOS = {
    systemd-boot.enable = true;
    core-system.enable = true;
    # bundles.base-system.enable = true;
    # openssh.enable = true;
    wireguard-server.enable = true;
    mail-server.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    zsh.enable = true;
    btop.enable = true;
  };
}
