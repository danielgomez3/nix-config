# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./common.nix
      ./workspace.nix
      # /etc/nixos/hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    description = "desktop";
  };
  hardware.keyboard.zsa.enable = true;

  networking.hostName = host; # Define your hostname.
  services = {
    # openssh = {
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
      # programs = with pkgs; {
      #   kitty = {
      #     font = {
      #       size = 11;
      #     };
      #   };
      # };
      wayland.windowManager.sway = {
        extraConfig = ''
        output HDMI-A-1 scale 2
        '';
      };
    };
  };

  # NOTE: Unique hardware-configuration.nix content for laptop:
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/82be1713-5e51-42de-842b-bca7912f9218";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7C20-2361";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
