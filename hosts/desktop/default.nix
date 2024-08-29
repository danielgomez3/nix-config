# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, username, ... }:

{
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
  };


  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        packages = with pkgs; [
          minecraft
        ];
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
