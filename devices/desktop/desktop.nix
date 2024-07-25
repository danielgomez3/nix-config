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

  services = {
    # openssh = {
    # };
    # pixiecore = {
    #   enable = true;
    #   openFirewall = true;
    #   dhcpNoBind = true;
    #   kernel = "https://boot.netboot.xyz";
    # };
    xserver = {
      xkb.options = "";
    };
    syncthing = {
      guiAddress = "127.0.0.1:8385";
      settings = {
        devices = {
          "laptop" = { 
            id = "N4J2FSZ-DDQTYR2-RT6FC3Q-GKVPV66-MCMP2FD-6JDYI4P-JZYQR2L-OEOKHQW"; 
            autoAcceptFolders = true; 
          };
          "desktop" = { 
            id = "23GQV6A-ROUBBEV-N2S53WL-R6WJXFT-G2UKAXW-7D7C44A-USAGYXV-GW6WAQ2";
            autoAcceptFolders = true;
          };
          "phone" = {
            id = "L4PI6U7-VTRHUSU-WLSC3GV-EHWG4QX-DMSNSEL-DVACMSN-7D2EOIT-AIREAAZ";
            autoAcceptFolders = true; 
          };
        };
        folders = {
          "Documents" = {         
            path = "~/Documents";    
            devices = [ "laptop" ];      
          };
          "Productivity" = {         
            path = "~/Productivity";    
            devices = [ "laptop" "phone" ];      
          };
          "Projects" = {         
            path = "~/Projects";    
            devices = [ "laptop" ];      
          };
          "flake" = {         
            path = "~/flake";    
            devices = [ "laptop" ];      
          };
        };
      };
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
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };
      wayland.windowManager.sway = {
        extraConfig = ''
        output HDMI-A-1 scale 2
        '';
      };
    };
  };

}
