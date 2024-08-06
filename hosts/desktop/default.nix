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
      greeter = "${username}";
    };
    gui = {
      enable = true;
      greeter = "${username}";
    };
    all = {
      enable = true;
      greeter = "${username}";
    };
    # openssh = {
    # };
    # pixiecore = {
    #   enable = true;
    #   openFirewall = true;
    #   dhcpNoBind = true;
    #   kernel = "https://boot.netboot.xyz";
    # };
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



  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "daniel" ];
  # virtualisation.virtualbox.host.enableExtensionPack = true;  
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #   }; 
  # };

  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
      home = {
        # packages = with pkgs; [
        #   xorg.xmodmap
        # ];
        pointerCursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
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
        '';
        config = {
          startup = [
            { command = "kdeconnect-sms"; }
            { command = "spotify"; }
          ];
        };
      };
    };
  };
}
