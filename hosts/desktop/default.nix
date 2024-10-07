# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, username, config, ... }:

{
  # sops.secrets."private_keys/user_desktop" = {  # This way, it could be server, desktop, whatever!
  #   # Automatically generate this private key at this location if it's there or not:
  #   path = "/home/${username}/.ssh/id_ed25519";
  #   # mode = "600";
  #   owner = config.users.users.${username}.name;
  # };
  users.users.${username} = {
    description = "desktop";
  };
  hardware.keyboard.zsa.enable = true;

  boot.blacklistedKernelModules = [
    # "iwlwifi"
    "rtw88_8821ce"
  ];

  services = {
    coding = {
      enable = true;
    };
    gui = {
      enable = true;
    };
    all = {
      enable = true;
    };
    virtualization = {
      enable = true;
    };
    xserver = {
      xkb = {
        options = "caps:swapescape";
        # extraLayouts.${username} = {
        #   description = "Daniel's remapped keys";
        #   languages = ["eng"];
        #   symbolsFile = ./custom_symbols;
        # };
      };
    };
    syncthing = {
      guiAddress = "127.0.0.1:8385";
    };
    # ddclient = {
    #   enable = true;
    #   # The server (API) to update, which is Duck DNS
    #   server = "www.duckdns.org"; 
    #   # The protocol for Duck DNS
    #   protocol = "duckdns";
    #   # Duck DNS domain name without the .duckdns.org part
    #   domains = [ 
    #     "danielgomezcoder-d"
    #   ];
    #   username = config.sops.secrets.duck_dns_username.path;
    #   interval = "5m";
    #   # Use your Duck DNS token as the password
    #   passwordFile = config.sops.secrets.duck_dns_token.path;  # Shoutout to sops baby.
    #   use = "web, web=https://ifconfig.me";
    # };

  };


  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        # packages = with pkgs; [
        #   minecraft
        # ];
        pointerCursor = {
          name = "Adwaita";
          package = pkgs.gnome.adwaita-icon-theme;
          size = 24;
          x11 = {
            enable = true;
            defaultCursor = "Adwaita";
          };
        };
      };
      wayland.windowManager.sway = {
        extraConfig = ''
        output HDMI-A-1 scale 2
        ## Sleep

        exec swayidle -w \
        	timeout 520 'swaylock -c 000000 -f' \
        	timeout 550 'swaymsg "output * power off"' \
        	resume 'swaymsg "output * power on"'

        '';
        config = {
          startup = [
            { command = "kdeconnect-sms"; }
            { command = "plexamp"; }
          ];
        };
      };
    };
  };
}
