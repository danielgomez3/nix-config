
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
    bundles.server-programs.enable = true;
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
    # DELETME:
    syncthing = {
      guiAddress = "0.0.0.0:8384";
    };   
  };


}
