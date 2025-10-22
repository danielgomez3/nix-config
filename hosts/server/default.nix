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
  myVars.username = "danielgomez3"; # Specific username for this machine
  myVars.hostname = "server"; # Specific hostname for this machine
  myVars.isSyncthingServer = true;

  users.users.${username} = {
    description = "server";
  };

  myNixOS = {
    bundles.base-system.enable = true;
    caching.enable = true;
    nix-netboot-serve.enable = false;
    hydra.enable = false;
    borg-backup.enable = true;
    # plex.enable = true;
    vaultwarden.enable = true;
    nextcloud.enable = true;
    immich.enable = true;
    remoteDeployment-nix-on-droid.enable = true;
    mySws.enable = true;
    macos-emulation.enable = false;
    docker.enable = true;
    ollama.enable = true;
  };

  home-manager.users.${username}.myHomeManager = {
    bundles.desktop-environment.enable = true;
    bundles.coding-environment.enable = true;
    cli-apps.enable = true; # NOTE: Has to be enabled here, we don't inherit it anywhere in bundles.
    stylix.enable = true;
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

  services = {
    tailscale = {
      useRoutingFeatures = "server";
    };
    # DELETME:
    syncthing = {
      guiAddress = "0.0.0.0:8384";
    };
  };
}
