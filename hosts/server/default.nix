
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ username, pkgs, inputs, config, ... }:

{
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
      interval = "5m";
      # The server (API) to update, which is Duck DNS
      server = "www.duckdns.org"; 
      # The protocol for Duck DNS
      protocol = "duckdns";

      # Duck DNS domain name without the .duckdns.org part
      domains = [ "danielgomezcoder" ];

      # Use your Duck DNS token as the password
      passwordFile = config.sops.secrets.duck_dns_token.path;  # Shoutout to sops baby.

      # Use 'web' for auto IP detection (ddclient will use your public IP)
      use = "web";

      # Enforce SSL for secure updates
      ssl = true;
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
