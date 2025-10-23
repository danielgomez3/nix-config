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
  # myVars.isSyncthingServer = true;

  users.users.${username} = {
    description = "danielgomezcoder's hetzner cloud vps server";
  };

  myNixOS = {
    bundles.base-system.enable = true;
  };

  home-manager.users.${username}.myHomeManager = {
    bundles.coding-environment.enable = true;
    cli-apps.enable = true; # NOTE: Has to be enabled here, we don't inherit it anywhere in bundles.
    rclone.enable = true;
  };
  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = config.sops.secrets.github_token.path;
    #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
    # };
    systemPackages = with pkgs; [
      kitty # Make SSHing into this pretty.
    ];
  };

  # security.acme = {
  #   defaults.email = "${toString config.sops.secrets.email}";
  #   acceptTerms = true;
  # };
}
