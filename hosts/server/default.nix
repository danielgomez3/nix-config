
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "danielgomez3";  # Specific username for this machine
  users.users.${username} = {
    description = "server";
  };
  myNixOS = {
    all.enable = true;
    sops.enable = true;
    desktop-environment.enable = true;
    desktop-apps.enable = true;
    coding.enable = true;
    virtualization.enable = false;
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


  hardware.keyboard.zsa.enable = true;
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
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings = {
        gui = {
          user = "${username}";
          password = "naruto88";  # FIXME: the sops path doesn't work.
          # password = config.sops.secrets.syncthing.gui_password.path;
        };
        folders = {
          "Documents" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/${username}/Documents";    # Which folder to add to Syncthing
            devices = [ "desktop" "server" "laptop" ];      # Which devices to share the folder with
            autoAccept = true;
            id = "Documents";
          };
          "Productivity" = {
            path = "/home/${username}/Documents/productivity";
            devices = [ "desktop" "server" "laptop" "phone" ];
            autoAccept = true;
            id = "Productivity";
          };
          "Projects" = {
            path = "/home/${username}/Projects";
            devices = [ "desktop" "server" "laptop" ];
            autoAccept = true;
            id = "Projects";
          };
        };
      };
    };   
  };

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    # FIXME: using 'cat' for the password may be impure and may cause side effects when deploying using NixOs-Anywhere... Investigate!
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat ${config.sops.secrets.tailscale.path})
    '';
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
