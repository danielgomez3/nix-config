
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "danielgomez3";  # Specific username for this machine
  myVars.hostname = "${name}";  # Specific username for this machine
  myVars.isSyncthingServer = true;

  users.users.${username} = {
    description = "server";
  };
  myNixOS = {
    bundles.base-system.enable = true;
    netboot.enable = true;
    hydra.enable = true;
    borg-backup.enable = true;
  };
  home-manager.users.${username}.myHomeManager = {
    cli-apps.enable = true;
  };
  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = config.sops.secrets.github_token.path;  
    #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
    # };
    systemPackages = with pkgs; [
      kitty  # Make SSHing into this pretty.
      python3
    ];
  };



  security.acme = {
    defaults.email = "${toString config.sops.secrets.email}";
    acceptTerms = true;
  };

  services = {
    tailscale = {
      useRoutingFeatures = "server";
    };
    plex = {
      enable = true;
      openFirewall = true;
      user = "${username}";
      # dataDir = "/home/${username}/plex";
    };
    vaultwarden = {
      enable = true;
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      virtualHosts."server.tail1b372c.ts.net" = {
        enableACME = false;  # Disable Let's Encrypt
        forceSSL = false;    # Skip HTTPS enforcement (Tailscale already encrypts traffic)
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";  # Forward to Vaultwarden
        };
      };
    };
    # DELETME:
    syncthing = {
      guiAddress = "0.0.0.0:8384";
    };   
  };


}
