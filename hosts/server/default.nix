
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

  users.users.${username} = {
    description = "server";
  };

  hardware.keyboard.zsa.enable = true;
  security.acme = {
    defaults.email = config.sops.secrets.email;
    acceptTerms = true;
  };
  services = {
    coding = {
      enable = true;
    };
    all = {
      enable = true;
    };
    virtualization = {
      enable = false;
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
    vaultwarden = {
      enable = true;
    };
    nginx = {
      enable = true;
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
