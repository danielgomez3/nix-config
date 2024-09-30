
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ username, inputs, config, ... }:

{
  sops.secrets."private_keys/laptop" = {  # This way, it could be server, desktop, whatever!
    # Automatically generate this private key at this location if it's there or not:
    path = "/home/${username}/.ssh/id_ed25519";
    # mode = "600";
    owner = config.users.users.${username}.name;
  };
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
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
    plex = {
      enable = true;
      openFirewall = true;
      user = "${username}";
      # dataDir = "/home/${username}/plex";
    };

    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "${username}";
        # FIXME: This is bad. This is a unique password tho.
        password = "naruto88";  
      };
    };

    ddclient = {
      enable = true;
      # The server (API) to update, which is Duck DNS
      server = "www.duckdns.org"; 
      # The protocol for Duck DNS
      protocol = "duckdns";
      # Duck DNS domain name without the .duckdns.org part
      domains = [ 
        "danielgomezcoder-s"
      ];
      username = config.sops.secrets.duck_dns_username.path;
      interval = "5m";
      # Use your Duck DNS token as the password
      passwordFile = config.sops.secrets.duck_dns_token.path;  # Shoutout to sops baby.
      use = "web, web=https://ifconfig.me";
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
