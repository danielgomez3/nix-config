
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myConfig.username;
in
{
  myConfig.username = "danielgomez3";  # Specific username for this machine
  environment = {
    # sessionVariables = {
    #   GITHUB_TOKEN = config.sops.secrets.github_token.path;  
    #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
    # };
    systemPackages = with pkgs; [
      kitty  # Make SSHing into this pretty.
    ];
  };


  home-manager = { 
    # extraSpecialArgs = { inherit inputs; };
    users.root = {
      home = {
        stateVersion = "24.05";
      };
      # programs = {
      #   };
      };
    };

  users.users.${username} = {
    description = "server";
  };

  hardware.keyboard.zsa.enable = true;
  services = {
    coding = {
      enable = true;
    };
    all = {
      enable = true;
    };
    virtualization = {
      enable = true;
    };
    tailscale = {
      useRoutingFeatures = "server";
    };
    plex = {
      enable = true;
      openFirewall = true;
      user = "${username}";
      # dataDir = "/home/${username}/plex";
    };
    ddclient = {
      domains = [ 
          "server.danielgomezcoder.org"
      ];
      interval = "3m";
    };
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "${username}";
        # FIXME: This is bad. This is a unique password tho.
        password = "naruto88";
        # password = config.sops.secrets.user_password.path;
      };
    };

  };


  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
  #   users.${username} = {
  #     programs = with pkgs; {
  #       kitty = {
  #         font = {
  #           size = 11;
  #         };
  #       };
  #     };
  #   };
  #   packages = with pkgs; [
  #     hello
  #   ];

  # };

}
