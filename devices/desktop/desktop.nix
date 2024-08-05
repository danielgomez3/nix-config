# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, username, host, ... }:

let 
  c_d = "configurations";
in
{
  imports =
    [ 
      ../${c_d}/all.nix
      ../${c_d}/gui.nix
      ../${c_d}/coding.nix
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];

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
      greeter = "Daniel";
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
  # console.font =
  #   "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  # services.xserver.dpi = 230;
  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "2";
  #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #   };


  # NOTE: Unique home-manager config for desktop:
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
        config = rec {
          startup = [
            { command = "kdeconnect-sms"; }
            { command = "spotify"; }
          ];
        };
      };
    };
  };
}
