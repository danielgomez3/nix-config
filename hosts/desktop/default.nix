# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, config, host, ... }:
let
  username = config.myVars.username;
in
{
  myVars.username = "daniel";  # Specific username for this machine
  users.users.${username} = {
    description = "desktop";
  };
  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
  };
  # myHomeManager = {
  #   features.gui-apps.enable = true;
  # };

  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;

  boot.blacklistedKernelModules = [
    # "iwlwifi"
    "rtw88_8821ce"
  ];

  services = {
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
    tailscale = {
      authKeyFile = config.sops.secrets.tailscale.path;
    };
    syncthing.guiAddress = "127.0.0.1:8385";
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


  home-manager = { 
    # extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        # packages = with pkgs; [
        #   minecraft
        # ];
        # pointerCursor = {
        #   name = "Adwaita";
        #   # package = pkgs.adwaita-icon-theme;  # Unstable
        #   package = pkgs.gnome.adwaita-icon-theme;
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
