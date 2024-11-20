# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, config, host, ... }:
let
  username = config.myConfig.username;
in
{
  myConfig.username = "daniel";  # Specific username for this machine
  users.users.${username} = {
    description = "desktop";
  };
  time.hardwareClockInLocalTime = true;
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
    # tailscale = {
    #   useRoutingFeatures = "client";
    # };
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
    syncthing.guiAddress = "127.0.0.1:8385";
    ddclient = {
      domains = [ 
          "desktop.danielgomezcoder.org"
      ];
      interval = "1m";
    };
  };

    # sops.secrets = {
    #   "private_ssh_keys/desktop" = {  # This way, it could be server, desktop, whatever!
    #     # Automatically generate this private key at this location if it's there or not:
    #     path = "/home/${username}/.ssh/id_ed25519";
    #     # mode = "600";
    #     owner = config.users.users.${username}.name;
    #   };
    #   "private_ssh_keys/desktop_root" = {  
    #     path = "/root/.ssh/id_ed25519";
    #     owner = config.users.users.root.name;
    #   };
    # };

  networking = {
    wireless = {
      enable = true;
      networks = {
        "TMOBILE-F526" = {
          # psk = config.sops.secrets."wifi_networks/home/psk".path;
          psk = "reshuffle.think.wool.tug";
        };
      };
    };
  };

  home-manager = { 
    # extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        # packages = with pkgs; [
        #   minecraft
        # ];
        # pointerCursor = {
        #   name = "Adwaita";
        #   package = pkgs.adwaita-icon-theme;
        #   size = 24;
        #   x11 = {
        #     enable = true;
        #     defaultCursor = "Adwaita";
        #   };
        # };
      };

      # wayland.windowManager.hyprland = {
      #   extraConfig = ''
      #     # monitor=Monitor_Name,Resolution,Refresh_Rate,Scale
      #     monitor=HDMI-A-1,1920x1080,60,1,0,0
      #   '';
      # };


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

      programs = {
        ssh = {
          enable = true;
          matchBlocks = {
            "server-hosts" = {
              host = "github.com gitlab.com";
              identitiesOnly = true;
              identityFile = [
                "/home/${username}/.ssh/id_ed25519"
                # "~/.ssh/id_ed25519"
                # config.sops.secrets."private_ssh_keys/${host}".path  # This is normal user key, not a root key.
                # config.sops.secrets."private_ssh_keys/desktop".path  # This is normal user key, not a root key.
                # "${config.sops.secrets."private_ssh_keys/common".path}"
              ];
            };
          };
        };
      };
    };
  };
}
