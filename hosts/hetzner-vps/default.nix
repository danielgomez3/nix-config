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
  myVars.username = "danielgomezcoder"; # Specific username for this machine
  myVars.hostname = "hetzner-vps"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "danielgomezcoder's hetzner cloud vps server";
  };

  myNixOS = {
    core-system.enable = true;
    wireguard-server.enable = true;
    mail-server.enable = true;
  };

  # home-manager.users.${config.myVars.username}.myHomeManager = {
  #   cli-apps.enable = true;
  # };

  # programs.git = {
  #   enable = true;
  #   settings = {
  #     user.name = "danielgomez3";
  #     user.email = "danielgomezcoder@gmail.com";
  #   };
  #   # user = {
  #   #   name = "danielgomez3";
  #   #   email = "danielgomezcoder@gmail.com";
  #   # };
  #   # settings = {
  #   #   extraConfig = {
  #   #     commit.gpgsign = true;
  #   #     gpg.format = "ssh";
  #   #     user.signingkey = "~/.ssh/id_ed25519.pub";
  #   #     push.autoSetupRemote = true;
  #   #   };
  #   # };
  #   signing = {
  #     # gpg --list-secret-keys --keyid-format=long
  #     key = "5E8044D0F8A9F629"; # FIXME: put in sops, or put private key somewhere??
  #     signByDefault = true;
  #   };
  # };
}
